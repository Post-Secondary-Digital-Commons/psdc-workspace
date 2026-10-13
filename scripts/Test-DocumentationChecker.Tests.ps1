[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$checker = Join-Path $PSScriptRoot 'Test-Documentation.ps1'
$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ("psdc-doc-checker-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $fixtureRoot | Out-Null
try {
    New-Item -ItemType File -Path (Join-Path $fixtureRoot 'empty.md') | Out-Null
    Set-Content -LiteralPath (Join-Path $fixtureRoot 'home.md') -Value '# Home' -Encoding utf8
    Set-Content -LiteralPath (Join-Path $fixtureRoot 'linked.md') -Value '[Home](home.md) and [[home]]' -Encoding utf8
    Set-Content -LiteralPath (Join-Path $fixtureRoot 'package-lock.json') -Value '{"":1}' -Encoding utf8
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'node_modules'), (Join-Path $fixtureRoot 'vendor') | Out-Null
    Set-Content -LiteralPath (Join-Path $fixtureRoot 'node_modules/README.md') -Value '[Example](missing.md)' -Encoding utf8
    Set-Content -LiteralPath (Join-Path $fixtureRoot 'vendor/SKILL.md') -Value '[Example](missing.md)' -Encoding utf8

    $positive = & $checker -Root $fixtureRoot
    if (($positive -join [Environment]::NewLine) -notmatch 'Documentation validation passed') {
        throw 'Empty notes, dependency files, vendored examples or valid JSON failed the positive fixture.'
    }

    Set-Content -LiteralPath (Join-Path $fixtureRoot 'broken.md') -Value '[Missing](not-here.md)' -Encoding utf8
    $negative = try { & $checker -Root $fixtureRoot 2>&1 } catch { $_ }
    $negativeText = $negative -join [Environment]::NewLine
    if ($negativeText -notmatch 'markdown-link' -or $negativeText -notmatch 'not-here.md') {
        throw 'A workspace-owned broken link escaped validation.'
    }
    Write-Output 'Documentation checker fixtures passed.'
}
finally {
    $resolvedRoot = [IO.Path]::GetFullPath($fixtureRoot)
    $resolvedTemp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    if (-not $resolvedRoot.StartsWith($resolvedTemp, [StringComparison]::OrdinalIgnoreCase) -or
        [IO.Path]::GetFileName($resolvedRoot) -notlike 'psdc-doc-checker-*') {
        throw "Refusing to remove unexpected fixture directory: $resolvedRoot"
    }
    Remove-Item -LiteralPath $resolvedRoot -Recurse -Force
}
