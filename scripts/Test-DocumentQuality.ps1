[CmdletBinding()]
param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot),
    [switch]$Enforce,
    [string]$ReportPath
)

$ErrorActionPreference = 'Stop'
$rootPath = (Resolve-Path -LiteralPath $Root).Path
$ignoredNames = @('CONTRIBUTING.md')
$ignoredPatterns = @('LICENSE', 'NOTICE')
$documents = @(Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' -and $_.Name -notin $ignoredNames })
$findings = [System.Collections.Generic.List[object]]::new()

$required = @{
    # These are intentionally regular expressions. Existing documents may use
    # a more precise heading (for example "Interfaces, APIs, events, and
    # contracts") while still satisfying the same scope requirement.
    'architecture-specification' = @('Purpose(?:\s+and\s+outcome)?', 'Scope', 'Out\s+of\s+scope', 'Architecture|Ownership\s+boundaries|System\s+context|Logical\s+architecture|Platform|Product\s+strategy', 'Interfaces|API|Boundar', 'Dependencies|Adapter|Runtime|Ownership', 'Security|Privacy|Safety|Policy', 'Deployment|Implementation|Product\s+strategy', 'Capacity|Scaling|Routing', 'Failure|Recovery|Fallback|Availability', 'Testing|Evaluation|Evidence', 'Acceptance|Criteria|Decision\s+status|Evidence\s+gate')
    'architecture-map' = @('Purpose|Context', 'Scope|Boundar', 'Owner|Ownership', 'Dependenc|Relationship|Interface', 'Source[- ]of[- ]truth|References', 'Validation|Stale|Contradiction')
    'component-specification' = @('Purpose', 'responsibil', 'Interfaces|API|Contract', 'Dependencies', 'Security', 'Deployment', 'Testing|Acceptance')
    'policy-standard' = @('Purpose', 'Scope', 'Normative|Rules', 'Enforcement', 'Exception', 'Evidence|Audit', 'Acceptance|Review')
    'runbook' = @('Trigger|Symptoms', 'Prerequisites', 'Diagnostic|Hypothes', 'Rollback|Recovery', 'Escalation', 'Verification|Validation')
    'adr' = @('Context', 'Decision', 'Consequences', 'Alternatives|Options', 'Migration|Rollback')
    'product-specification' = @('Users|Stakeholders', 'Scope', 'Accessibility', 'Privacy|Security', 'Acceptance|Scenarios')
    'contract-specification' = @('Version', 'Owner', 'Producer', 'Consumer', 'Compatibility', 'Validation|Conformance')
    'roadmap' = @('Outcome', 'Dependencies', 'Phase', 'Exit\s+criteria', 'Risk', 'Evidence')
    'provenance-record' = @('Upstream', 'commit|tag', 'License', 'Included', 'Excluded', 'Import\s+state|source\s+imported')
    'institution-deployment-profile' = @('Institution', 'Upstream', 'Override', 'Identity', 'Secrets', 'Rollback')
    'repository-index' = @('Purpose', 'Belongs|Allowed|Contents', 'must\s+not|Prohibited', 'Owner', 'Contents', 'References', 'Contribution|Change')
    'governance-standard' = @('Purpose', 'Required', 'Maturity', 'Definition\s+of\s+done', 'Change\s+control')
    'template' = @('non[- ]normative', 'Instructions')
    'historical-record' = @('Date', 'Source', 'supersed')
}

function Add-Finding([IO.FileInfo]$File, [string]$Reason) {
    $repo = [IO.Path]::GetRelativePath($rootPath, $File.FullName) -split '[\\/]' | Select-Object -First 2
    $findings.Add([pscustomobject]@{ Repo = ($repo -join '/'); File = [IO.Path]::GetRelativePath($rootPath, $File.FullName); Reason = $Reason })
}

foreach ($file in $documents) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    if ([string]::IsNullOrWhiteSpace($content)) {
        Add-Finding $file 'empty document'
        continue
    }
    if ($content -match '(?m)^#\s*$') { Add-Finding $file 'empty title' }
    if ($content -match '(?m)^> Document type:\s*(?<type>[^\r\n]+)') {
        $type = $Matches.type.Trim().ToLowerInvariant()
    } else {
        Add-Finding $file 'missing control block field: Document type'
        continue
    }
    foreach ($field in @('Standard', 'Status', 'Owner', 'Accountable maintainer', 'Last reviewed', 'Governing decisions')) {
        if ($content -notmatch "(?m)^> $([regex]::Escape($field)):\s*\S+") {
            Add-Finding $file "missing control block field: $field"
        }
    }
    if (-not $required.ContainsKey($type)) {
        Add-Finding $file "unrecognized document type: $type"
        continue
    }
    foreach ($headingPattern in $required[$type]) {
        # A section may be an H2/H3 heading or an explicitly labelled
        # requirement block (for example "**Out of scope:** ..."). This keeps
        # the check strict about declared content without forcing a cosmetic
        # heading rewrite across the existing specification corpus.
        $sectionPattern = "(?im)(?:^#{1,4}[^\r\n]*($headingPattern)|^\s*(?:[-*]\s*)?\*{0,2}($headingPattern)\b)"
        if ($content -notmatch $sectionPattern) {
            Add-Finding $file "missing required content: $headingPattern"
        }
    }
    if ($type -notin @('repository-index', 'architecture-map', 'template', 'historical-record') -and
        $content.Length -lt 1200) {
        Add-Finding $file "insufficient substantive content for $type ($($content.Length) characters)"
    }
    if ($type -notin @('repository-index', 'architecture-map', 'template', 'historical-record') -and
        $content -notmatch '(?m)\b(MUST|MUST NOT|SHALL|SHALL NOT|SHOULD|MAY)\b') {
        Add-Finding $file 'no normative requirement language'
    }
}

$grouped = @($findings | Group-Object Repo | Sort-Object Name)
Write-Output "Document quality audit: $($documents.Count) Markdown documents, $($findings.Count) finding(s), $($grouped.Count) affected repository group(s)."
foreach ($group in $grouped) {
    Write-Output "[$($group.Name)] $($group.Count) finding(s)"
    $group.Group | Group-Object Reason | Sort-Object Count -Descending | Select-Object -First 12 |
        ForEach-Object { Write-Output "  $($_.Count)x $($_.Name)" }
}
if ($ReportPath) {
    $reportDirectory = Split-Path -Parent $ReportPath
    if ($reportDirectory -and -not (Test-Path -LiteralPath $reportDirectory)) {
        New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null
    }
    $findings | Export-Csv -LiteralPath $ReportPath -NoTypeInformation -Encoding utf8NoBOM
    Write-Output "Detailed finding report: $ReportPath"
}
if ($findings.Count -gt 0 -and $Enforce) {
    throw "Document quality enforcement failed with $($findings.Count) finding(s)."
}
