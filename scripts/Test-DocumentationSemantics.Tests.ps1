[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$checker = Join-Path $PSScriptRoot 'Test-DocumentationSemantics.ps1'
$tempParent = [IO.Path]::GetTempPath().TrimEnd([IO.Path]::DirectorySeparatorChar)
$testRoot = Join-Path $tempParent ('psdc-semantic-test-' + [guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $testRoot

try {
    $stubTemplate = @'
# {0}

> Document type: architecture-specification
> Status: Stub for later work

This is deliberately repeated generic text, not an independently scoped specification.
'@
    [IO.File]::WriteAllText((Join-Path $testRoot 'Stub-A.md'), ($stubTemplate -f 'Stub A'))
    [IO.File]::WriteAllText((Join-Path $testRoot 'Stub-B.md'), ($stubTemplate -f 'Stub B'))
    $stubOutput = (& $checker -Root $testRoot) -join "`n"
    if ($stubOutput -notmatch '0 finding\(s\)' -or $stubOutput -notmatch '2 declared stub document\(s\)') {
        throw "Stub isolation failed: $stubOutput"
    }

    $draftTemplate = @'
# {0}

> Document type: architecture-specification
> Status: Draft for owner review

The repeated text below represents substantive behavior that must not be cloned across two differently titled current-authority documents. The checker needs to detect this as duplicated specification content even though a stub with similar words is not authoritative.
'@
    [IO.File]::WriteAllText((Join-Path $testRoot 'Draft-A.md'), ($draftTemplate -f 'Draft A'))
    [IO.File]::WriteAllText((Join-Path $testRoot 'Draft-B.md'), ($draftTemplate -f 'Draft B'))
    $draftOutput = (& $checker -Root $testRoot) -join "`n"
    if ($draftOutput -notmatch 'subject-substitution-clone' -or $draftOutput -notmatch '2 declared stub document\(s\)') {
        throw "Current-authority clone detection failed: $draftOutput"
    }
    Write-Output 'Semantic checker regression passed: stubs are debt, current-authority clones are findings.'
}
finally {
    $resolvedRoot = [IO.Path]::GetFullPath($testRoot)
    $resolvedParent = [IO.Path]::GetFullPath($tempParent).TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    if (-not $resolvedRoot.StartsWith($resolvedParent, [StringComparison]::OrdinalIgnoreCase) -or
        -not ([IO.Path]::GetFileName($resolvedRoot) -match '^psdc-semantic-test-[a-f0-9]{32}$')) {
        throw "Refusing to remove unexpected temporary test path: $resolvedRoot"
    }
    Remove-Item -LiteralPath $resolvedRoot -Recurse -Force
}
