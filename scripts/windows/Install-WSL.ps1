<#
.SYNOPSIS
    PortableHermes WSL Installer

.DESCRIPTION
    Creates and prepares the dedicated PortableHermes WSL distribution.

.NOTES
    Windows PowerShell 5.1 compatible
#>

$ErrorActionPreference = "Stop"

param(

    [Parameter(Mandatory)]
    [string]$ProjectRoot

)

function Write-Step {

    param(
        [string]$Message
    )

    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan

}

function Test-Administrator {

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()

    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )

}

Write-Step "Checking WSL"

$wsl = Get-Command wsl.exe -ErrorAction SilentlyContinue

if ($null -eq $wsl) {
    throw "WSL is not installed."
}

Write-Step "Preparing directories"

$runtime = Join-Path $ProjectRoot "runtime"

$wslDirectory = Join-Path $runtime "wsl"

if (!(Test-Path $wslDirectory)) {

    New-Item `
        -ItemType Directory `
        -Force `
        -Path $wslDirectory | Out-Null

}

Write-Step "Checking existing distribution"

$distributionName = "PortableHermes"

$list = & wsl.exe --list --quiet

if ($list -contains $distributionName) {

    Write-Host ""
    Write-Host "PortableHermes WSL distribution already exists."

}
else {

    Write-Host ""
    Write-Host "PortableHermes WSL distribution has not been installed yet."

    Write-Host ""
    Write-Host "The installer will import a dedicated distribution"
    Write-Host "in a later phase."

}

Write-Step "Done"
