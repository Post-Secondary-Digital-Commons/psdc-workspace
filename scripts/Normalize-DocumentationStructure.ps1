[CmdletBinding()]
param([string]$Root = (Split-Path -Parent $PSScriptRoot))

$ErrorActionPreference = 'Stop'
$changed = 0
$documents = Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' -and $_.Name -ne 'CONTRIBUTING.md' }
foreach ($file in $documents) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $match = [regex]::Match($content, '(?ms)^## References\s*\r?\n(?<references>.*?)(?=^## |\z)')
    if (-not $match.Success) { continue }
    $after = $content.Substring($match.Index + $match.Length)
    if ([string]::IsNullOrWhiteSpace($after)) { continue }
    $without = ($content.Substring(0, $match.Index) + $after).TrimEnd()
    $references = $match.Groups['references'].Value.Trim()
    $updated = "$without`r`n`r`n## References`r`n`r`n$references`r`n"
    Set-Content -LiteralPath $file.FullName -Value $updated -Encoding utf8NoBOM
    $changed++
}

Write-Output "Moved References to the terminal section in $changed documents."
