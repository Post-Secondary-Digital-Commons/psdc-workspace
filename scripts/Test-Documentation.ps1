[CmdletBinding()]
param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$rootPath = (Resolve-Path -LiteralPath $Root).Path
$failures = [System.Collections.Generic.List[string]]::new()
$markdownFiles = @(Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' })

function Add-Failure([string]$Kind, [string]$Source, [string]$Target) {
    $relative = [IO.Path]::GetRelativePath($rootPath, $Source)
    $failures.Add("$Kind`t$relative`t$Target")
}

function Test-LocalTarget([string]$SourceFile, [string]$RawTarget) {
    $target = $RawTarget.Trim().Trim('<', '>')
    if ($target -match '^(#|https?://|mailto:|tel:|data:|codex:)' -or
        $target -match '^\{\{' -or $target -match '^\$' -or
        $target -match '^[A-Za-z][A-Za-z0-9+.-]*:') {
        return
    }

    $target = ($target -split '#', 2)[0]
    if ([string]::IsNullOrWhiteSpace($target)) { return }
    $target = [Uri]::UnescapeDataString($target.Replace('/', [IO.Path]::DirectorySeparatorChar))
    $candidate = Join-Path (Split-Path -Parent $SourceFile) $target
    if (-not (Test-Path -LiteralPath $candidate)) {
        Add-Failure 'markdown-link' $SourceFile $RawTarget
    }
}

$knownMarkdown = @{}
foreach ($file in $markdownFiles) {
    $withoutExtension = [IO.Path]::GetFileNameWithoutExtension($file.Name)
    if (-not $knownMarkdown.ContainsKey($withoutExtension)) {
        $knownMarkdown[$withoutExtension] = [System.Collections.Generic.List[string]]::new()
    }
    $knownMarkdown[$withoutExtension].Add($file.FullName)
}

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw

    foreach ($match in [regex]::Matches($content, '(?<!\!)\[[^\]]*\]\((?<target>[^)]+)\)')) {
        $rawTarget = $match.Groups['target'].Value
        if ($rawTarget -match '^<[^>]+>') {
            $rawTarget = ([regex]::Match($rawTarget, '^<(?<path>[^>]+)>')).Groups['path'].Value
        } elseif ($rawTarget -match '^(?<path>\S+)\s+["'']') {
            $rawTarget = ([regex]::Match($rawTarget, '^(?<path>\S+)')).Groups['path'].Value
        }
        Test-LocalTarget $file.FullName $rawTarget
    }

    foreach ($match in [regex]::Matches($content, '\[\[(?<target>[^\]]+)\]\]')) {
        $target = (($match.Groups['target'].Value -split '\|', 2)[0] -split '#', 2)[0].Trim()
        if ([string]::IsNullOrWhiteSpace($target)) { continue }
        $targetWithExtension = if ([IO.Path]::GetExtension($target)) { $target } else { "$target.md" }
        $relativeCandidate = Join-Path (Split-Path -Parent $file.FullName) $targetWithExtension
        $rootCandidate = Join-Path $rootPath $targetWithExtension
        $baseName = [IO.Path]::GetFileNameWithoutExtension($targetWithExtension)
        if (-not (Test-Path -LiteralPath $relativeCandidate) -and
            -not (Test-Path -LiteralPath $rootCandidate) -and
            -not $knownMarkdown.ContainsKey($baseName)) {
            Add-Failure 'wiki-link' $file.FullName $match.Groups['target'].Value
        }
    }
}

$jsonFiles = @(Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter '*.json' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' })
foreach ($file in $jsonFiles) {
    try { Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json -Depth 100 | Out-Null }
    catch { Add-Failure 'invalid-json' $file.FullName $_.Exception.Message }
}

$markerPattern = '(?im)\b(TODO|TBD)\b|specification incomplete|implementation incomplete|accepted baseline|\bplaceholder\b|\bskeleton\b|TO VERIFY|TO RECORD|TO ASSIGN'
foreach ($file in $markdownFiles | Where-Object { $_.FullName -match '[\\/]common[\\/]psdc-architecture[\\/]' }) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    if ($content -match $markerPattern) {
        Add-Failure 'unresolved-marker' $file.FullName $Matches[0]
    }
}

if ($failures.Count -gt 0) {
    $failures | Sort-Object | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    throw "Documentation validation failed with $($failures.Count) issue(s)."
}

Write-Output "Documentation validation passed: $($markdownFiles.Count) Markdown files, $($jsonFiles.Count) JSON files, zero broken local links or unresolved specification markers."
