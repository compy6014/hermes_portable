<#
.SYNOPSIS
    PortableHermes Logging Library

.DESCRIPTION
    Provides a centralized logging interface for all scripts.

.NOTES
    Compatible with Windows PowerShell 5.1
#>

# Prevent duplicate loading
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
        New-Item `
            -ItemType Directory `
            -Force `
            -Path $logDirectory | Out-Null
    }

    $script:LogLevel = $Level
    $script:LogFile = Join-Path $logDirectory "PortableHermes.log"

    if (!(Test-Path $script:LogFile)) {
        New-Item `
            -ItemType File `
            -Path $script:LogFile | Out-Null
    }

    Write-Log INFO "Logger initialized."
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

    if ($script:LogLevels[$Level] -lt $script:LogLevels[$script:LogLevel]) {
        return
    }

    $line = "{0} [{1}] {2}" -f `
        (Get-TimeStamp),
        $Level.ToUpper(),
        $Message

    Add-Content `
        -Path $script:LogFile `
        -Value $line

    Write-Host $line `
        -ForegroundColor (Get-LevelColor $Level)
}

function Write-DebugLog {

    param(
        [string]$Message
    )

    Write-Log `
        -Level DEBUG `
        -Message $Message
}

function Write-InfoLog {

    param(
        [string]$Message
    )

    Write-Log `
        -Level INFO `
        -Message $Message
}

function Write-WarnLog {

    param(
        [string]$Message
    )

    Write-Log `
        -Level WARN `
        -Message $Message
}

function Write-ErrorLog {

    param(
        [string]$Message
    )

    Write-Log `
        -Level ERROR `
        -Message $Message
}

function Set-LogLevel {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [ValidateSet("DEBUG","INFO","WARN","ERROR")]
        [string]$Level

    )

    $script:LogLevel = $Level

}
