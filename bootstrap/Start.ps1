<#
.SYNOPSIS
    PortableHermes Bootstrap

.DESCRIPTION
    Entry point for PortableHermes on Windows.
    Loads libraries, initializes environment, and starts validation.

.NOTES
    Windows PowerShell 5.1 compatible
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

    $root = Join-Path $PSScriptRoot ".."

    $resolved = Get-Item -LiteralPath $root -ErrorAction Stop

    return $resolved.FullName
}

#endregion

try {

    Write-Banner

    # ---------------------------------------------------------------------
    # Project root
    # ---------------------------------------------------------------------

    $ProjectRoot = Resolve-ProjectRoot

    # ---------------------------------------------------------------------
    # Load libraries (DIRECT DOTTING - no loader)
    # ---------------------------------------------------------------------

    $libraries = @(
        "Logger.ps1",
        "Config.ps1",
        "Environment.ps1",
        "WSL.ps1"
    )

    foreach ($lib in $libraries) {

        $path = Join-Path $ProjectRoot "lib\$lib"

        if (!(Test-Path $path)) {
            throw "Missing library: $path"
        }

        . $path
    }

    Write-Host "Libraries loaded."

    # ---------------------------------------------------------------------
    # Logger
    # ---------------------------------------------------------------------

    Initialize-Logger -ProjectRoot $ProjectRoot

    # ---------------------------------------------------------------------
    # Config
    # ---------------------------------------------------------------------

    $config = Get-PortableConfig -ProjectRoot $ProjectRoot

    Set-LogLevel -Level $config.LogLevel

    Write-InfoLog "PortableHermes Version $($config.Version)"
    Write-InfoLog "Project root: $ProjectRoot"

    # ---------------------------------------------------------------------
    # Environment
    # ---------------------------------------------------------------------

    Initialize-Environment `
        -ProjectRoot $ProjectRoot `
        -Config $config

    Write-InfoLog "Environment initialized."

    # ---------------------------------------------------------------------
    # WSL check
    # ---------------------------------------------------------------------

    Test-WSL

    Write-InfoLog "WSL check completed."

    Write-InfoLog "Bootstrap completed successfully."

    exit 0

}
catch {

    Write-Host ""
    Write-Host "PortableHermes failed to start." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow

    if (Get-Command Write-ErrorLog -ErrorAction SilentlyContinue) {
        Write-ErrorLog $_.Exception.Message
    }

    exit 1
}
