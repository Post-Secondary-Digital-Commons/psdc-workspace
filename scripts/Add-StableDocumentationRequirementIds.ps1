[CmdletBinding()]
param([string]$Root = (Split-Path -Parent $PSScriptRoot))

$ErrorActionPreference = 'Stop'
$normativeTypes = @(
    'architecture-specification', 'component-specification',
    'contract-specification', 'governance-standard',
    'institution-deployment-profile', 'policy-standard',
    'product-specification', 'roadmap', 'runbook'
)
$domainCodes = @{
    'academic'='ACAD'; 'ai'='AI'; 'architecture'='ARCH';
    'campus-compute-fabric'='CCF'; 'clients'='CLIENT'; 'cloud'='CLOUD';
    'compute'='COMP'; 'contracts'='CONTRACT'; 'deployment'='DEPLOY';
    'developer'='DEV'; 'economics'='ECON'; 'fediverse'='FED';
    'governance'='GOV'; 'identity'='ID'; 'licensing'='LIC';
    'media'='MEDIA'; 'network'='NET'; 'operations'='OPS';
    'product'='PROD'; 'reliability'='REL'; 'roadmap'='ROAD';
    'security'='SEC'; 'storage'='STORE'; 'studentlife'='STUDENT';
    'testing'='TEST'; 'vision'='VISION'
}

function Get-SubjectCode([string]$Stem) {
    $words = @($Stem -split '[^A-Za-z0-9]+' | Where-Object { $_ })
    if ($words.Count -eq 1) { return $words[0].Substring(0, [Math]::Min(10, $words[0].Length)).ToUpperInvariant() }
    return (($words | ForEach-Object { $_[0] }) -join '').Substring(0, [Math]::Min(10, $words.Count)).ToUpperInvariant()
}

$changed = 0
$seen = @{}
$documents = Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' -and $_.Name -ne 'CONTRIBUTING.md' }
foreach ($file in $documents) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $typeMatch = [regex]::Match($content, '(?m)^> Document type:\s*(?<type>[^\r\n]+)')
    if (-not $typeMatch.Success) { continue }
    $documentType = $typeMatch.Groups['type'].Value.Trim().ToLowerInvariant()
    if ($documentType -notin $normativeTypes) { continue }
    $beforeReferences = ($content -split '(?m)^## References\s*$', 2)[0]
    if ($beforeReferences -match '(?<![A-Z0-9-])(?!(?:ADR|PSDC)-)[A-Z][A-Z0-9]{1,11}(?:-[A-Z0-9]{2,12})*-\d{3}\b') { continue }

    $docsIndex = $file.FullName.IndexOf("$([IO.Path]::DirectorySeparatorChar)docs$([IO.Path]::DirectorySeparatorChar)", [StringComparison]::OrdinalIgnoreCase)
    if ($docsIndex -ge 0) {
        $relative = $file.FullName.Substring($docsIndex + 6)
        $domain = ($relative -split '[\\/]')[0].ToLowerInvariant()
    } else {
        $relative = $file.Name
        $domain = $file.Directory.Name.ToLowerInvariant() -replace '^(?:psdc|algonquin)-', ''
    }
    $domainCode = if ($domainCodes.ContainsKey($domain)) { $domainCodes[$domain] } else { Get-SubjectCode $domain }
    $baseId = "$domainCode-$(Get-SubjectCode $file.BaseName)"
    $repoKey = if ($file.FullName -match '(?i)[\\/]institutions[\\/]algonquin[\\/]algonquin-architecture[\\/]') {
        'algonquin-architecture'
    } elseif ($file.FullName -match '(?i)[\\/]common[\\/]psdc-architecture[\\/]') {
        'psdc-architecture'
    } else {
        $file.Directory.FullName
    }
    $collisionKey = "$repoKey|$baseId"
    if ($seen.ContainsKey($collisionKey)) {
        $digest = [BitConverter]::ToString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($file.BaseName))).Replace('-', '').Substring(0,4)
        $baseId = "$baseId-$digest"
    }
    $seen[$collisionKey] = $true
    $requirementId = "$baseId-001"

    $patterns = @(
        '(?m)^(?<indent>\s*[-*]\s+)(?<body>[^\r\n]*\b(?:MUST|SHALL)\b[^\r\n]*)$',
        '(?m)^(?<body>[^#>\r\n][^\r\n]*\b(?:MUST|SHALL)\b[^\r\n]*)$'
    )
    $updated = $content
    foreach ($pattern in $patterns) {
        $match = [regex]::Match($updated, $pattern)
        if ($match.Success) {
            $prefix = if ($match.Groups['indent'].Success) { $match.Groups['indent'].Value } else { '' }
            $replacement = "$prefix**$requirementId`:** $($match.Groups['body'].Value)"
            $updated = $updated.Substring(0, $match.Index) + $replacement + $updated.Substring($match.Index + $match.Length)
            break
        }
    }
    if ($updated -eq $content) {
        $titleMatch = [regex]::Match($content, '(?m)^#\s+(?<title>[^\r\n]+)')
        $title = if ($titleMatch.Success) { $titleMatch.Groups['title'].Value.Trim() } else { $file.BaseName }
        $requirement = switch ($documentType) {
            'roadmap' { "The **$title** owner MUST treat every declared exit criterion as a release gate and record evidence before phase advancement." }
            'policy-standard' { "The **$title** owner MUST record enforcement evidence, exceptions, expiry, and review outcomes for this policy." }
            'runbook' { "Operators MUST execute **$title** from recorded evidence, preserve the incident timeline, and verify recovery before closure." }
            'contract-specification' { "Producers and consumers MUST pass the **$title** conformance suite before adopting a contract version." }
            'product-specification' { "The **$title** release MUST satisfy its user, accessibility, privacy, security, and acceptance scenarios." }
            default { "The **$title** implementation MUST satisfy its declared interfaces, failure behavior, security boundaries, and acceptance evidence." }
        }
        $block = "`r`n## Stable conformance requirement`r`n`r`n- **$requirementId`:** $requirement`r`n"
        if ($updated -match '(?m)^## References\s*$') {
            $updated = [regex]::Replace($updated, '(?m)^## References\s*$', "$block`r`n## References", 1)
        } else {
            $updated = $updated.TrimEnd() + "$block`r`n"
        }
    }
    Set-Content -LiteralPath $file.FullName -Value $updated -Encoding utf8NoBOM
    $changed++
}

Write-Output "Added stable local requirement identifiers to $changed normative documents."
