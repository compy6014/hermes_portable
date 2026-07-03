<#
.SYNOPSIS
    PortableHermes Configuration Library

.DESCRIPTION
    Loads and validates the project configuration.

.NOTES
    Compatible with Windows PowerShell 5.1
#>

if ($script:PortableHermesConfigLoaded) {
    return
}

$script:PortableHermesConfigLoaded = $true

$script:PortableConfig = $null

function Get-ConfigFile {

    param(
        [Parameter(Mandatory)]
        [string]$ProjectRoot
    )

    return Join-Path $ProjectRoot "config\portable.json"

}

function Get-PortableConfig {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectRoot
    )

    if ($script:PortableConfig -ne $null) {
        return $script:PortableConfig
    }

    $configFile = Get-ConfigFile -ProjectRoot $ProjectRoot

    if (!(Test-Path $configFile)) {
        throw "Configuration file not found:`n$configFile"
    }

    try {

        $script:PortableConfig = Get-Content `
            -Path $configFile `
            -Raw |
            ConvertFrom-Json

    }
    catch {

        throw "Invalid configuration file.`n$configFile"

    }

    Test-PortableConfig `
        -Config $script:PortableConfig

    return $script:PortableConfig

}

function Test-PortableConfig {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    $required = @(
        "ProjectName",
        "Version",
        "Runtime",
        "Workspace",
        "Logs",
        "Cache",
        "State",
        "Tmp",
        "Tools",
        "Downloads",
        "Backups",
        "LogLevel",
        "RuntimeName",
        "RequiredWSLVersion",
        "EnableDiagnostics",
        "EnableDebugLogging"
    )

    foreach ($property in $required) {

        if ($null -eq $Config.$property) {
            throw "Missing configuration value: $property"
        }

        if ([string]::IsNullOrWhiteSpace($Config.$property)) {
            throw "Configuration value is empty: $property"
        }

    }

}

function Get-ConfigValue {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        $Config

    )

    if ($null -eq $Config.$Name) {
        throw "Unknown configuration key: $Name"
    }

    return $Config.$Name

}
