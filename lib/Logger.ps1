<#
.SYNOPSIS
    PortableHermes Logging Library

.DESCRIPTION
    Central logging system for PortableHermes bootstrap and runtime.

.NOTES
    Windows PowerShell 5.1 compatible
#>

if ($script:PortableHermesLoggerLoaded) {
    return
}

$script:PortableHermesLoggerLoaded = $true

$script:LogFile = $null
$script:LogLevel = "INFO"

$script:LogLevels = @{
    DEBUG = 0
    INFO  = 1
    WARN  = 2
    ERROR = 3
}

function Initialize-Logger {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectRoot,

        [ValidateSet("DEBUG","INFO","WARN","ERROR")]
        [string]$Level = "INFO"
    )

    $logDirectory = Join-Path $ProjectRoot "logs"

    if (!(Test-Path $logDirectory)) {
        New-Item -ItemType Directory -Force -Path $logDirectory | Out-Null
    }

    $script:LogLevel = $Level.ToUpper()
    $script:LogFile = Join-Path $logDirectory "PortableHermes.log"

    if (!(Test-Path $script:LogFile)) {
        New-Item -ItemType File -Force -Path $script:LogFile | Out-Null
    }

    Write-Log INFO "Logger initialized."
}

function Set-LogLevel {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("DEBUG","INFO","WARN","ERROR")]
        [string]$Level
    )

    $script:LogLevel = $Level.ToUpper()
}

function Get-TimeStamp {
    return Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

function Get-LevelColor {

    param(
        [string]$Level
    )

    switch ($Level.ToUpper()) {
        "DEBUG" { return "DarkGray" }
        "INFO"  { return "White" }
        "WARN"  { return "Yellow" }
        "ERROR" { return "Red" }
        default { return "Gray" }
    }
}

function Write-Log {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [ValidateSet("DEBUG","INFO","WARN","ERROR")]
        [string]$Level,

        [Parameter(Mandatory)]
        [string]$Message

    )

    # ---------------------------------------------------------------------
    # SAFE FALLBACK (prevents crash if logger not initialized yet)
    # ---------------------------------------------------------------------
    if ($null -eq $script:LogFile) {

        $fallbackDir = Join-Path $env:TEMP "PortableHermes"

        if (!(Test-Path $fallbackDir)) {
            New-Item -ItemType Directory -Force -Path $fallbackDir | Out-Null
        }

        $script:LogFile = Join-Path $fallbackDir "bootstrap.log"
    }

    # ---------------------------------------------------------------------
    # LEVEL FILTER
    # ---------------------------------------------------------------------
    if ($script:LogLevels[$Level] -lt $script:LogLevels[$script:LogLevel]) {
        return
    }

    $line = "{0} [{1}] {2}" -f `
        (Get-TimeStamp),
        $Level.ToUpper(),
        $Message

    # Write to file (safe now)
    Add-Content -Path $script:LogFile -Value $line

    # Console output
    Write-Host $line -ForegroundColor (Get-LevelColor $Level)
}

function Write-DebugLog {
    param([string]$Message)
    Write-Log -Level DEBUG -Message $Message
}

function Write-InfoLog {
    param([string]$Message)
    Write-Log -Level INFO -Message $Message
}

function Write-WarnLog {
    param([string]$Message)
    Write-Log -Level WARN -Message $Message
}

function Write-ErrorLog {
    param([string]$Message)
    Write-Log -Level ERROR -Message $Message
}
