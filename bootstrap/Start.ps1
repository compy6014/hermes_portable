<#
.SYNOPSIS
    PortableHermes Bootstrap Entry Point
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "           PortableHermes Bootstrap" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

function Resolve-ProjectRoot {
    $root = Join-Path $PSScriptRoot ".."
    return (Get-Item -LiteralPath $root).FullName
}

$PH_ProjectRoot = Resolve-ProjectRoot

Write-Host "DEBUG ProjectRoot = [$PH_ProjectRoot]"

function SafeJoinPath {
    param([string]$Base, [string]$Child)

    if ([string]::IsNullOrWhiteSpace($Base)) {
        throw "SafeJoinPath: Base is null"
    }

    return Join-Path -Path $Base -ChildPath $Child
}

# -------------------------
# Load libraries
# -------------------------
$libraries = @(
    "Logger.ps1",
    "Config.ps1",
    "Environment.ps1",
    "WSL.ps1",
    "Runtime.ps1"
)

foreach ($lib in $libraries) {
    $path = SafeJoinPath $PH_ProjectRoot "lib\$lib"

    if (-not (Test-Path $path)) {
        throw "Missing library: $path"
    }

    . $path
}

Write-Host "Libraries loaded."

# -------------------------
# Init logger
# -------------------------
Initialize-Logger -ProjectRoot $PH_ProjectRoot
Write-InfoLog "Logger initialized."

# -------------------------
# Config
# -------------------------
$config = Get-PortableConfig -ProjectRoot $PH_ProjectRoot
Set-LogLevel -Level $config.LogLevel

Write-InfoLog "PortableHermes Version $($config.Version)"
Write-InfoLog "Project root: $PH_ProjectRoot"

# -------------------------
# Environment
# -------------------------
Initialize-Environment -ProjectRoot $PH_ProjectRoot -Config $config
Write-InfoLog "Environment initialized."

# -------------------------
# WSL check
# -------------------------
Test-WSL
Write-InfoLog "WSL check completed."

# -------------------------
# RUNTIME EXECUTION (CRITICAL FIX)
# -------------------------
Write-InfoLog "Starting Linux runtime..."

$result = Start-HermesRuntime -ProjectRoot $PH_ProjectRoot

Write-Host ""
Write-Host "================ LINUX OUTPUT ================" -ForegroundColor Cyan
Write-Host $result
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-InfoLog "Bootstrap completed successfully."

exit 0
