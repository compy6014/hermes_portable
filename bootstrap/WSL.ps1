<#
.SYNOPSIS
    PortableHermes WSL Library

.DESCRIPTION
    Detects and validates the local WSL installation.

.NOTES
    Compatible with Windows PowerShell 5.1
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

    try {

        $versionOutput = & $wslExe --version 2>&1

    }
    catch {

        throw "Unable to execute wsl.exe."

    }

    if ($LASTEXITCODE -ne 0) {
        throw "WSL returned exit code $LASTEXITCODE."
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
