[CmdletBinding()]
param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot),
    [string]$CheckoutRoot = 'C:\Users\jredj\dev\psdc'
)

$ErrorActionPreference = 'Stop'
$generator = Join-Path $Root 'scripts\Build-WorkspaceCommandCenter.py'
$temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) ("psdc-command-center-test-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temporaryRoot | Out-Null
python $generator --workspace-root $Root --checkout-root $CheckoutRoot --output-root $temporaryRoot
if ($LASTEXITCODE -ne 0) { throw "Command-center generator failed with exit code $LASTEXITCODE." }

$expected = @(
    'Maps\Generated\Workspace Command Center.md',
    'Maps\Generated\Repository and Dependency Catalog.md',
    'Maps\Generated\Authority Map.md',
    'Maps\Generated\Evidence and Readiness Registry.md',
    'Maps\Generated\Contract Explorer.md',
    'registry\generated-workspace-status.json'
)
foreach ($relative in $expected) {
    if (-not (Test-Path -LiteralPath (Join-Path $temporaryRoot $relative))) {
        throw "Missing generated artifact: $relative"
    }
}

Write-Host "Workspace command-center validation passed ($($expected.Count) generated artifacts)."
$resolvedTemporaryRoot = (Resolve-Path -LiteralPath $temporaryRoot).Path
$resolvedSystemTemp = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path
if (-not $resolvedTemporaryRoot.StartsWith($resolvedSystemTemp, [StringComparison]::OrdinalIgnoreCase) -or
    [IO.Path]::GetFileName($resolvedTemporaryRoot) -notlike 'psdc-command-center-test-*') {
    throw "Refusing to remove unexpected test directory: $resolvedTemporaryRoot"
}
Remove-Item -LiteralPath $resolvedTemporaryRoot -Recurse -Force
