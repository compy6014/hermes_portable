<#
.SYNOPSIS
    PortableHermes WSL Library

.DESCRIPTION
    Detects and validates WSL using compatible commands.
#>

if ($script:PortableHermesWSLLoaded) {
    return
}

$script:PortableHermesWSLLoaded = $true

function Get-WSLExecutable {

    $wsl = Get-Command "wsl.exe" -ErrorAction SilentlyContinue

    if ($null -eq $wsl) {
        throw "wsl.exe was not found in PATH."
    }

    return $wsl.Source
}

function Test-WSL {

    [CmdletBinding()]
    param()

    Write-InfoLog "Checking WSL installation..."

    $wslExe = Get-WSLExecutable

    Write-DebugLog "Using WSL executable: $wslExe"

    # ---------------------------------------------------------------------
    # FIX: use compatible command (NO --version on your system)
    # ---------------------------------------------------------------------

    $output = & $wslExe --status 2>&1
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne 0) {
        throw "WSL returned exit code $exitCode. Output: $output"
    }

    # Optional sanity check: ensure WSL actually responds
    if ([string]::IsNullOrWhiteSpace($output)) {
        throw "WSL returned empty status output."
    }

    Write-InfoLog "WSL detected."

}

function Get-WSLStatus {

    [CmdletBinding()]
    param()

    $wslExe = Get-WSLExecutable

    $status = & $wslExe --status 2>&1

    return ($status | Out-String).Trim()
}

function Get-InstalledDistributions {

    [CmdletBinding()]
    param()

    $wslExe = Get-WSLExecutable

    $result = & $wslExe --list --verbose 2>&1

    return $result
}