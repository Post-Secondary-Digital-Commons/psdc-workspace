[CmdletBinding()]
param([string]$Root = (Split-Path -Parent $PSScriptRoot))

$ErrorActionPreference = 'Stop'
$commonProfile = Join-Path $Root 'common/psdc-architecture/docs/architecture/Domain-Control-Profiles.md'
$algProfile = Join-Path $Root 'institutions/algonquin/algonquin-architecture/docs/architecture/Domain-Control-Profiles.md'
Copy-Item -LiteralPath $commonProfile -Destination $algProfile -Force
$roots = @(
    (Join-Path $Root 'common/psdc-architecture/docs'),
    (Join-Path $Root 'institutions/algonquin/algonquin-architecture/docs')
)
$profiles = @(
    @('AI','ai-profile','prompts, responses, embeddings','gateway-only model access'),
    @('CCF','campus-compute-fabric-profile','node attestations, hardware capabilities','mutual authentication, signed enrollment'),
    @('MEDIA','media-fabric-profile','source assets, immutable hashes','malware scanning, content-type validation'),
    @('FED','fediverse-profile','actors, objects, activities','instance-level policy, abuse throttling'),
    @('SEC','security-profile','threat models, classifications','zero implicit trust, least privilege')
)
$sections = @(
    @('Data, state, residency, and retention', 'Data controls', 0),
    @('Security, privacy, safety, and compliance', 'Security controls', 1),
    @('Failure, recovery, and compatibility', 'Failure controls', -1),
    @('Standards and implementation strategy', 'Standards controls', -1),
    @('Interfaces, APIs, events, and contracts', 'Interface controls', -1)
)
function Replace-Section([string]$Content, [string]$Heading, [string]$Signature, [string]$Replacement) {
    $pattern = "(?ms)^## $([regex]::Escape($Heading))\s*\r?\n(?<body>.*?)(?=^## |\z)"
    $match = [regex]::Match($Content, $pattern)
    if (-not $match.Success -or $match.Groups['body'].Value -notmatch [regex]::Escape($Signature)) { return $Content }
    return $Content.Substring(0, $match.Index) + "## $Heading`r`n`r`n$Replacement`r`n`r`n" + $Content.Substring($match.Index + $match.Length)
}
$changed = 0
foreach ($rootPath in $roots) {
    foreach ($file in Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter '*.md') {
        if ($file.Name -in @('Domain-Control-Profiles.md','Cross-Cutting-Architecture-Requirements.md')) { continue }
        $content = Get-Content -LiteralPath $file.FullName -Raw
        $updated = $content
        $updated = [regex]::Replace(
            $updated,
            'Inherits \[(?<label>[^\]]+)\]\((?<link>[^\)]+)\)\. The subject MUST define its local extension, evidence, and non-applicability decision\.',
            { param($match) "See [$($match.Groups['label'].Value)]($($match.Groups['link'].Value)); local extensions remain normative." }
        )
        foreach ($profile in $profiles) {
            $profilePath = if ($rootPath -like '*institutions*') { $algProfile } else { $commonProfile }
            $link = ([IO.Path]::GetRelativePath($file.Directory.FullName, $profilePath) -replace '\\','/') + "#$($profile[1])"
            foreach ($section in $sections) {
                $signature = if ($section[2] -eq 0) { $profile[2] } elseif ($section[2] -eq 1) { $profile[3] } else { $null }
                if (-not $signature) {
                    $signature = switch ($profile[0]) {
                        'AI' { if ($section[0] -like 'Failure*') {'bounded context, cancellation'} elseif ($section[0] -like 'Standards*') {'OpenAPI, OpenAI-compatible'} else {''} }
                        'CCF' { if ($section[0] -like 'Failure*') {'interactive-user priority'} elseif ($section[0] -like 'Standards*') {'OCI artifacts, S3-compatible'} elseif ($section[0] -like 'Interfaces*') {'versioned node capability'} else {''} }
                        'MEDIA' { if ($section[0] -like 'Failure*') {'resumable ingest'} elseif ($section[0] -like 'Standards*') {'S3-compatible objects'} elseif ($section[0] -like 'Interfaces*') {'upload, resumable transfer'} else {''} }
                        'FED' { if ($section[0] -like 'Failure*') {'queue backpressure'} elseif ($section[0] -like 'Standards*') {'W3C ActivityPub'} elseif ($section[0] -like 'Interfaces*') {'ActivityPub, ActivityStreams'} else {''} }
                        'SEC' { if ($section[0] -like 'Failure*') {'continuous scanning'} elseif ($section[0] -like 'Standards*') {'OWASP guidance'} elseif ($section[0] -like 'Interfaces*') {'policy decisions, security events'} else {''} }
                    }
                }
                if (-not $signature) { continue }
                $replacement = "Inherits [$($section[1])]( $link ). The subject MUST define its local extension, evidence, and non-applicability decision."
                $replacement = $replacement.Replace('( ', '(').Replace(' )', ')')
                $updated = Replace-Section $updated $section[0] $signature $replacement
            }
        }
        if ($updated -ne $content) {
            Set-Content -LiteralPath $file.FullName -Value $updated.TrimEnd() -Encoding utf8NoBOM
            Add-Content -LiteralPath $file.FullName -Value '' -Encoding utf8NoBOM
            $changed++
        }
    }
}
Write-Output "Consolidated domain profiles in $changed architecture documents."
