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

function Get-ProjectRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Import-Libraries {

    param(
        [string]$ProjectRoot
    )

    $libraries = @(
        "Logger.ps1",
        "Config.ps1",
        "Environment.ps1",
        "Import-Libraries.ps1"
    )

    foreach ($library in $libraries) {

        $path = Join-Path $ProjectRoot "lib\$library"

        if (!(Test-Path $path)) {
            throw "Required library not found:`n$path"
        }

        . $path
    }
}

#endregion

Write-Banner

$ProjectRoot = Get-ProjectRoot

Import-Libraries -ProjectRoot $ProjectRoot

Initialize-Logger -ProjectRoot $ProjectRoot

Write-Log INFO "Project root: $ProjectRoot"

$config = Get-PortableConfig -ProjectRoot $ProjectRoot

Initialize-Environment `
    -ProjectRoot $ProjectRoot `
    -Config $config

Write-Log INFO "Environment initialized."

Test-WSL

Write-Log INFO "Bootstrap completed successfully."

exit 0
