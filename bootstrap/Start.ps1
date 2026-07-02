<#
.SYNOPSIS
    PortableHermes Bootstrap

.DESCRIPTION
    Main entry point for PortableHermes.
    Initializes the environment and starts the bootstrap pipeline.

.NOTES
    Version: 0.0.2-dev
#>

$ErrorActionPreference = "Stop"

#region Functions

function Write-Banner {
    Write-Host ""
    Write-Host "==============================================="
    Write-Host "           PortableHermes Bootstrap"
    Write-Host "==============================================="
    Write-Host ""
}

function Resolve-ProjectRoot {

    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

}

function Import-Libraries {

    param(
        [Parameter(Mandatory)]
        [string]$ProjectRoot
    )

    $libraries = @(
        "Logger.ps1",
        "Config.ps1",
        "Environment.ps1"
    )

    foreach ($library in $libraries) {

        $path = Join-Path $ProjectRoot "lib\$library"

        if (!(Test-Path $path)) {
            throw "Missing required library:`n$path"
        }

        . $path
    }
}

#endregion

try {

    Write-Banner

    $ProjectRoot = Resolve-ProjectRoot

    Import-Libraries -ProjectRoot $ProjectRoot

    Initialize-Logger -ProjectRoot $ProjectRoot

    $config = Get-PortableConfig -ProjectRoot $ProjectRoot

    Set-LogLevel $config.LogLevel

    Write-InfoLog "Project root: $ProjectRoot"

    Initialize-Environment `
        -ProjectRoot $ProjectRoot `
        -Config $config

    Write-InfoLog "Environment initialized."

    Test-WSL

    Write-InfoLog "Bootstrap completed successfully."

    exit 0
}
catch {

    Write-Host ""
    Write-Host "PortableHermes failed to start." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow

    exit 1
}
