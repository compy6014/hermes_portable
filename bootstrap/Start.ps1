<#
.SYNOPSIS
    PortableHermes Bootstrap Entry Point

.DESCRIPTION
    Initializes PortableHermes on Windows, loads libraries,
    configures environment, and prepares WSL runtime execution.
#>

$ErrorActionPreference = "Stop"

# -------------------------------------------------------------------------
# Banner
# -------------------------------------------------------------------------
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "           PortableHermes Bootstrap" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------------------
# Resolve project root (isolated variable, cannot be overwritten easily)
# -------------------------------------------------------------------------
function Resolve-ProjectRoot {
    $root = Join-Path $PSScriptRoot ".."
    return (Get-Item -LiteralPath $root -ErrorAction Stop).FullName
}

# IMPORTANT: use unique variable name to avoid library collisions
$PH_ProjectRoot = Resolve-ProjectRoot

Write-Host "DEBUG ProjectRoot = [$PH_ProjectRoot]"

# -------------------------------------------------------------------------
# Safe path helper
# -------------------------------------------------------------------------
function SafeJoinPath {

    param(
        [Parameter(Mandatory)]
        [string]$Base,

        [Parameter(Mandatory)]
        [string]$Child
    )

    if ([string]::IsNullOrWhiteSpace($Base)) {
        throw "SafeJoinPath: Base path is null or empty"
    }

    return Join-Path -Path $Base -ChildPath $Child
}

# -------------------------------------------------------------------------
# Load libraries (direct dot-sourcing, no loader abstraction)
# -------------------------------------------------------------------------
$libraries = @(
    "Logger.ps1",
    "Config.ps1",
    "Environment.ps1",
    "WSL.ps1"
)

foreach ($lib in $libraries) {

    $path = SafeJoinPath $PH_ProjectRoot "lib\$lib"

    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing library: $path"
    }

    . $path
}

Write-Host "Libraries loaded."

# -------------------------------------------------------------------------
# Initialize Logger FIRST
# -------------------------------------------------------------------------
Initialize-Logger -ProjectRoot $PH_ProjectRoot

Write-InfoLog "Logger initialized."

# -------------------------------------------------------------------------
# Load configuration
# -------------------------------------------------------------------------
$config = Get-PortableConfig -ProjectRoot $PH_ProjectRoot

Set-LogLevel -Level $config.LogLevel

Write-InfoLog "PortableHermes Version $($config.Version)"
Write-InfoLog "Project root: $PH_ProjectRoot"

# -------------------------------------------------------------------------
# Initialize environment
# -------------------------------------------------------------------------
Initialize-Environment `
    -ProjectRoot $PH_ProjectRoot `
    -Config $config

Write-InfoLog "Environment initialized."

# -------------------------------------------------------------------------
# WSL check
# -------------------------------------------------------------------------
Test-WSL

Write-InfoLog "WSL check completed."

# -------------------------------------------------------------------------
# Success
# -------------------------------------------------------------------------
Write-InfoLog "Bootstrap completed successfully."

exit 0