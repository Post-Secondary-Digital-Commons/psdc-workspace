[CmdletBinding()]
param([string]$Root = (Split-Path -Parent $PSScriptRoot))

$ErrorActionPreference = 'Stop'
$repositories = @(
    (Join-Path $Root 'common/psdc-architecture/docs')
    (Join-Path $Root 'institutions/algonquin/algonquin-architecture/docs')
)

$sections = @(
    @('Dependencies and ownership boundaries','This domain owns its schemas, policy enforcement points','Inherits [baseline ownership controls](../architecture/Cross-Cutting-Architecture-Requirements.md#ownership-and-dependency-boundaries).'),
    @('Deployment, environments, and configuration','The common repository SHALL contain portable schemas','Inherits [baseline deployment controls](../architecture/Cross-Cutting-Architecture-Requirements.md#deployment-and-configuration).'),
    @('Capacity, scaling, cost, and sustainability','Capacity SHALL be controlled by quotas, concurrency limits','Inherits [baseline capacity controls](../architecture/Cross-Cutting-Architecture-Requirements.md#capacity-and-overload).'),
    @('Observability, testing, and operational readiness','Implementations SHALL publish health, readiness, structured logs','Inherits [baseline evidence controls](../architecture/Cross-Cutting-Architecture-Requirements.md#observability-and-evidence).'),
    @('Acceptance criteria','The specification is satisfied when an implementation evidence package proves','Inherits [baseline acceptance gates](../architecture/Cross-Cutting-Architecture-Requirements.md#observability-and-evidence); every local requirement MUST also pass.')
)

$compactions = @{
    'Ownership and dependency controls are inherited from [the cross-cutting baseline](../architecture/Cross-Cutting-Architecture-Requirements.md#ownership-and-dependency-boundaries). Requirements below define only subject-specific dependencies or exceptions.' = 'Inherits [baseline ownership controls](../architecture/Cross-Cutting-Architecture-Requirements.md#ownership-and-dependency-boundaries).'
    'Deployment and configuration controls are inherited from [the cross-cutting baseline](../architecture/Cross-Cutting-Architecture-Requirements.md#deployment-and-configuration). Requirements below define subject-specific topology or configuration.' = 'Inherits [baseline deployment controls](../architecture/Cross-Cutting-Architecture-Requirements.md#deployment-and-configuration).'
    'Capacity and overload controls are inherited from [the cross-cutting baseline](../architecture/Cross-Cutting-Architecture-Requirements.md#capacity-and-overload). Requirements below define subject-specific demand and degradation.' = 'Inherits [baseline capacity controls](../architecture/Cross-Cutting-Architecture-Requirements.md#capacity-and-overload).'
    'Observability and release evidence controls are inherited from [the cross-cutting baseline](../architecture/Cross-Cutting-Architecture-Requirements.md#observability-and-evidence). Requirements below define subject-specific signals and tests.' = 'Inherits [baseline evidence controls](../architecture/Cross-Cutting-Architecture-Requirements.md#observability-and-evidence).'
    'Baseline acceptance evidence is inherited from [the cross-cutting standard](../architecture/Cross-Cutting-Architecture-Requirements.md#observability-and-evidence). Every local requirement and scenario in this specification MUST also pass.' = 'Inherits [baseline acceptance gates](../architecture/Cross-Cutting-Architecture-Requirements.md#observability-and-evidence); every local requirement MUST also pass.'
}

function Replace-GeneratedSection([string]$Content, [string]$Heading, [string]$Signature, [string]$Replacement) {
    $pattern = "(?ms)^## $([regex]::Escape($Heading))\s*\r?\n(?<body>.*?)(?=^## |\z)"
    $match = [regex]::Match($Content, $pattern)
    if (-not $match.Success -or $match.Groups['body'].Value -notmatch [regex]::Escape($Signature)) {
        return $Content
    }
    return $Content.Substring(0, $match.Index) + "## $Heading`r`n`r`n$Replacement`r`n`r`n" + $Content.Substring($match.Index + $match.Length)
}

$changed = 0
foreach ($docsRoot in $repositories) {
    foreach ($file in Get-ChildItem -LiteralPath $docsRoot -Recurse -File -Filter '*.md') {
        if ($file.Name -eq 'Cross-Cutting-Architecture-Requirements.md') { continue }
        $content = Get-Content -LiteralPath $file.FullName -Raw
        $updated = $content
        foreach ($entry in $compactions.GetEnumerator()) {
            $updated = $updated.Replace($entry.Key, $entry.Value)
        }
        foreach ($section in $sections) {
            $updated = Replace-GeneratedSection $updated $section[0] $section[1] $section[2]
        }
        if ($updated -ne $content) {
            Set-Content -LiteralPath $file.FullName -Value $updated.TrimEnd() -Encoding utf8NoBOM
            Add-Content -LiteralPath $file.FullName -Value '' -Encoding utf8NoBOM
            $changed++
        }
    }
}

Write-Output "Consolidated generated cross-cutting sections in $changed architecture documents."
