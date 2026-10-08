[CmdletBinding()]
param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot),
    [string]$ReportPath,
    [switch]$Enforce
)

$ErrorActionPreference = 'Stop'
$rootPath = (Resolve-Path -LiteralPath $Root).Path
$findings = [System.Collections.Generic.List[object]]::new()
$ignoredNames = @('CONTRIBUTING.md')
$normativeTypes = @(
    'architecture-specification',
    'component-specification',
    'contract-specification',
    'governance-standard',
    'institution-deployment-profile',
    'policy-standard',
    'product-specification',
    'roadmap',

    'runbook'
)

function Get-RepositoryRoot([string]$Path) {
    $cursor = [IO.DirectoryInfo](Split-Path -Parent $Path)
    while ($cursor -and $cursor.FullName.StartsWith($rootPath, [StringComparison]::OrdinalIgnoreCase)) {
        if (Test-Path -LiteralPath (Join-Path $cursor.FullName '.git')) {
            return $cursor.FullName
        }
        $cursor = $cursor.Parent
    }
    return $rootPath
}

function Get-Metadata([string]$Content, [string]$Field) {
    $match = [regex]::Match($Content, "(?m)^> $([regex]::Escape($Field)):\s*(?<value>[^\r\n]+)")
    if ($match.Success) { return $match.Groups['value'].Value.Trim() }
    return ''
}

function Get-Title([string]$Content, [string]$Fallback) {
    $match = [regex]::Match($Content, '(?m)^#\s+(?<title>[^\r\n]+)')
    if ($match.Success) { return $match.Groups['title'].Value.Trim() }
    return $Fallback
}

function Normalize-Document([string]$Content, [string]$Title, [string]$Stem) {
    $normalized = $Content
    if ($Title) { $normalized = $normalized.Replace($Title, '<SUBJECT>') }
    if ($Stem) { $normalized = $normalized.Replace($Stem, '<SUBJECT-SLUG>') }
    # Requirement identifiers provide traceability but do not by themselves make
    # copied prose a distinct specification. Normalize them before clone hashing.
    $normalized = [regex]::Replace(
        $normalized,
        '(?<![A-Z0-9-])(?!(?:ADR|PSDC)-)[A-Z][A-Z0-9]{1,11}(?:-[A-Z0-9]{2,12})*-\d{3}\b',
        '<REQ-ID>'
    )
    $normalized = [regex]::Replace($normalized, '(?m)^> Last reviewed:.*$', '> Last reviewed: <DATE>')
    $normalized = [regex]::Replace($normalized, '\s+', ' ').Trim()
    return $normalized
}

function Normalize-Paragraph([string]$Paragraph) {
    $normalized = [regex]::Replace($Paragraph, '\s+', ' ').Trim()
    $normalized = [regex]::Replace($normalized, '(?i)\bAlgonquin\b', '<INSTITUTION>')
    return $normalized
}

function Add-Finding(
    [IO.FileInfo]$File,
    [string]$Type,
    [string]$Severity,
    [string]$Evidence,
    [string]$Cluster = ''
) {
    $repoRoot = Get-RepositoryRoot $File.FullName
    $findings.Add([pscustomobject]@{
        FindingType = $Type
        Severity = $Severity
        Repository = [IO.Path]::GetRelativePath($rootPath, $repoRoot)
        File = [IO.Path]::GetRelativePath($rootPath, $File.FullName)
        Evidence = $Evidence
        Cluster = $Cluster
    })
}

$documents = @(Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter '*.md' |
    Where-Object {
        $_.FullName -notmatch '[\\/](?:\.git|node_modules|\.venv|dist|build)[\\/]' -and
        $_.Name -notin $ignoredNames
    })

$records = foreach ($file in $documents) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $title = Get-Title $content $file.BaseName
    [pscustomobject]@{
        File = $file
        Content = $content
        Title = $title
        Type = (Get-Metadata $content 'Document type').ToLowerInvariant()
        Status = Get-Metadata $content 'Status'
        IsCurrentAuthority = (
            (Get-Metadata $content 'Document type').ToLowerInvariant() -notin @('historical-record', 'template') -and
            (Get-Metadata $content 'Status') -notmatch '(?i)historical|superseded|template|^stub\b'
        )
        Repository = Get-RepositoryRoot $file.FullName
        Normalized = Normalize-Document $content $title $file.BaseName
    }
}

# Detect documents whose entire substantive body differs only by the displayed
# subject. These are title-substitution clones, not independently scoped records.
foreach ($repoGroup in $records | Group-Object Repository) {
    $cloneGroups = @($repoGroup.Group | Where-Object IsCurrentAuthority |
        Group-Object Normalized | Where-Object Count -gt 1)
    foreach ($cloneGroup in $cloneGroups) {
        $clusterId = 'clone-' + ([BitConverter]::ToString(
            [Security.Cryptography.SHA256]::HashData(
                [Text.Encoding]::UTF8.GetBytes($cloneGroup.Name)
            )
        ).Replace('-', '').Substring(0, 12).ToLowerInvariant())
        $subjects = @($cloneGroup.Group | ForEach-Object Title | Sort-Object)
        foreach ($record in $cloneGroup.Group) {
            Add-Finding $record.File 'subject-substitution-clone' 'high' `
                "Document is semantically identical after replacing its title; cluster has $($cloneGroup.Count) subjects: $($subjects -join '; ')" `
                $clusterId
        }
    }
}

# Repeated long paragraphs are allowed only when they are short control language
# or references. Domain application, failure behavior, and acceptance evidence
# must live in the owning specification rather than be copied as filler.
foreach ($repoGroup in $records | Group-Object Repository) {
    $paragraphIndex = @{}
    $repeatedByFile = @{}
    foreach ($record in $repoGroup.Group | Where-Object IsCurrentAuthority) {
        $currentSection = ''
        foreach ($paragraph in [regex]::Split($record.Content, '\r?\n\s*\r?\n')) {
            $normalized = Normalize-Paragraph $paragraph
            # Decision citations are traceability metadata, not copied domain
            # behavior. They are intentionally shared across specifications.
            if ($normalized -match '\bADR-\d{4}\b') { continue }
            $heading = [regex]::Match($normalized, '^##\s+(?<name>.+)$')
            if ($heading.Success) { $currentSection = $heading.Groups['name'].Value.Trim() }
            if ($currentSection -match '^(?:References|Decision traceability)$') { continue }
            if ($normalized.Length -lt 180 -or
                $normalized -match '^#' -or
                $normalized -match '^>' -or
                $normalized -match '^\|' -or
                $normalized -match '^```' -or
                $normalized -match '^[-*] \[') {
                continue
            }
            if (-not $paragraphIndex.ContainsKey($normalized)) {
                $paragraphIndex[$normalized] = [System.Collections.Generic.HashSet[string]]::new(
                    [StringComparer]::OrdinalIgnoreCase
                )
            }
            $null = $paragraphIndex[$normalized].Add($record.File.FullName)
        }
    }
    foreach ($entry in $paragraphIndex.GetEnumerator() | Where-Object { $_.Value.Count -ge 5 }) {
        $paragraphId = 'paragraph-' + ([BitConverter]::ToString(
            [Security.Cryptography.SHA256]::HashData(
                [Text.Encoding]::UTF8.GetBytes($entry.Key)
            )
        ).Replace('-', '').Substring(0, 12).ToLowerInvariant())
        foreach ($path in $entry.Value) {
            if (-not $repeatedByFile.ContainsKey($path)) {
                $repeatedByFile[$path] = [System.Collections.Generic.List[object]]::new()
            }
            $repeatedByFile[$path].Add([pscustomobject]@{
                Id = $paragraphId
                Count = $entry.Value.Count
            })
        }
    }
    foreach ($entry in $repeatedByFile.GetEnumerator()) {
        $clusters = @($entry.Value | Sort-Object Count -Descending)
        $ids = @($clusters | Select-Object -First 8 | ForEach-Object Id)
        $maximum = ($clusters | Measure-Object Count -Maximum).Maximum
        Add-Finding (Get-Item -LiteralPath $entry.Key) 'repeated-substantive-content' 'high' `
            "$($clusters.Count) long substantive paragraph(s) are repeated in at least five documents; maximum reuse is $maximum." `
            ($ids -join ';')
    }
}

foreach ($record in $records | Where-Object IsCurrentAuthority) {
    if ($record.Type -in $normativeTypes -and $record.Status -notmatch '(?i)template|historical') {
        $bodyBeforeReferences = ($record.Content -split '(?m)^## References\s*$', 2)[0]
        $localRequirementIds = @([regex]::Matches(
            $bodyBeforeReferences,
            '(?<![A-Z0-9-])(?!(?:ADR|PSDC)-)[A-Z][A-Z0-9]{1,11}(?:-[A-Z0-9]{2,12})*-\d{3}\b'
        ))
        if ($localRequirementIds.Count -eq 0) {
            Add-Finding $record.File 'missing-stable-requirement-identifiers' 'high' `
                "Normative $($record.Type) contains no stable local requirement identifier before References."
        }
    }

    if ($record.Content -match '(?ms)^## References\s*.*^## Out of scope\s*\r?\n\s*Out of scope are secrets, unowned implementation internals') {
        Add-Finding $record.File 'validator-padding-after-references' 'high' `
            'A repeated generic section bundle was appended after References and does not add subject-specific scope.'
    }

    if ($record.Content -match 'There are no unresolved architecture choices in this specification\.' -and
        $record.Content -notmatch '(?im)^## (?:Assumptions|Open questions|Decision rationale)') {
        Add-Finding $record.File 'unsupported-completeness-claim' 'high' `
            'The document declares no unresolved architecture choices without an explicit assumptions/open-questions analysis.'
    }
}

$ordered = @($findings | Sort-Object Repository, File, FindingType, Cluster)
Write-Output "Semantic documentation audit: $($documents.Count) Markdown documents, $($ordered.Count) finding(s)."
$stubCount = @($records | Where-Object { $_.Status -match '(?i)^stub\b' }).Count
Write-Output "  $stubCount declared stub document(s) excluded from authority checks (tracked debt: not yet specified)."
$ordered | Group-Object FindingType | Sort-Object Count -Descending |
    ForEach-Object { Write-Output "  $($_.Count)x $($_.Name)" }

if ($ReportPath) {
    $reportDirectory = Split-Path -Parent $ReportPath
    if ($reportDirectory -and -not (Test-Path -LiteralPath $reportDirectory)) {
        New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null
    }
    $ordered | Export-Csv -LiteralPath $ReportPath -NoTypeInformation -Encoding utf8NoBOM
    Write-Output "Detailed semantic findings: $ReportPath"
}

if ($ordered.Count -gt 0 -and $Enforce) {
    throw "Semantic documentation enforcement failed with $($ordered.Count) finding(s)."
}
