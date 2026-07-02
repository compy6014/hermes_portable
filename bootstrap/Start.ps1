<#
.SYNOPSIS
    PortableHermes Bootstrap

.DESCRIPTION
    Main entry point for PortableHermes.
    Initializes the PortableHermes environment and verifies
    the host before launching the runtime.

.NOTES
    Compatible with Windows PowerShell 5.1
#>

$ErrorActionPreference = "Stop"

#region Helper Functions

function Write-Banner {

    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "           PortableHermes Bootstrap" -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""

}

function Resolve-ProjectRoot {

    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

}

#endregion

try {

    Write-Banner

    # ---------------------------------------------------------------------
    # Determine project root
    # ---------------------------------------------------------------------

    $ProjectRoot = Resolve-ProjectRoot

    # ---------------------------------------------------------------------
    # Load library loader
    # ---------------------------------------------------------------------

    $loader = Join-Path `
        $ProjectRoot `
        "lib\Import-Libraries.ps1"

    if (!(Test-Path $loader)) {
        throw "Library loader not found:`n$loader"
    }

    . $loader
    Write-Host "Loader loaded."

    Import-PortableLibraries `
        -ProjectRoot $ProjectRoot
    Write-Host "Libraries imported."

    # ---------------------------------------------------------------------
    # Initialize logger
    # ---------------------------------------------------------------------

    Initialize-Logger `
        -ProjectRoot $ProjectRoot

    # ---------------------------------------------------------------------
    # Load configuration
    # ---------------------------------------------------------------------

    $config = Get-PortableConfig `
        -ProjectRoot $ProjectRoot

    Set-LogLevel `
        -Level $config.LogLevel

    Write-InfoLog "PortableHermes Version $($config.Version)"

    Write-InfoLog "Project root: $ProjectRoot"

    # ---------------------------------------------------------------------
    # Initialize environment
    # ---------------------------------------------------------------------

    Initialize-Environment `
        -ProjectRoot $ProjectRoot `
        -Config $config

    Write-InfoLog "Environment initialized."

    # ---------------------------------------------------------------------
    # Verify WSL
    # ---------------------------------------------------------------------

    Test-WSL

    Write-InfoLog "Bootstrap completed successfully."

    exit 0

}
catch {

    Write-Host ""
    Write-Host "PortableHermes failed to start." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow

    try {

        if (Get-Command Write-ErrorLog -ErrorAction SilentlyContinue) {
            Write-ErrorLog $_.Exception.Message
        }

    }
    catch {
    }

    exit 1

}
