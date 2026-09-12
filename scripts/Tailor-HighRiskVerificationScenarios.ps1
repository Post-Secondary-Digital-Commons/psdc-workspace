[CmdletBinding()]
param([string]$Root = (Split-Path -Parent $PSScriptRoot))

$ErrorActionPreference = 'Stop'
$roots = @(
    (Join-Path $Root 'common/psdc-architecture/docs/security'),
    (Join-Path $Root 'common/psdc-architecture/docs/identity'),
    (Join-Path $Root 'institutions/algonquin/algonquin-architecture/docs/security'),
    (Join-Path $Root 'institutions/algonquin/algonquin-architecture/docs/identity')
)
$changed = 0
foreach ($rootPath in $roots) {
    foreach ($file in Get-ChildItem -LiteralPath $rootPath -File -Filter '*.md') {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        if ($content -notmatch '(?m)^## Subject-specific control contract$') { continue }
        $responsibility = ([regex]::Match($content, '(?m)^\| Owned responsibility \| (?<v>[^\r\n]+)')).Groups['v'].Value.Trim()
        $input = ([regex]::Match($content, '(?m)^\| Authoritative input \| (?<v>[^\r\n]+)')).Groups['v'].Value.Trim()
        $output = ([regex]::Match($content, '(?m)^\| Authoritative output \| (?<v>[^\r\n]+)')).Groups['v'].Value.Trim()
        $failure = ([regex]::Match($content, '(?m)^\| Unsafe failure to prevent \| (?<v>[^\r\n]+)')).Groups['v'].Value.Trim()
        if (-not $responsibility -or -not $input -or -not $output -or -not $failure) { throw "Incomplete subject table: $($file.FullName)" }
        $scenarios = @"
### Verification scenarios

1. Exercise $responsibility with $input and prove the recorded result is $output.
2. Remove or alter one required input and prove the request is denied without exposing protected diagnostic content.
3. Simulate the dependency or authority failure that could cause $failure; prove the declared safe state, revocation, and evidence are produced.

"@
        $pattern = '(?ms)^### Verification scenarios\s*\r?\n.*?(?=^## Decision traceability)'
        $updated = [regex]::Replace($content, $pattern, $scenarios, 1)
        if ($updated -ne $content) {
            Set-Content -LiteralPath $file.FullName -Value $updated -Encoding utf8NoBOM
            $changed++
        }
    }
}
Write-Output "Tailored verification scenarios in $changed high-risk specifications."
