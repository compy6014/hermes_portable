<#
.SYNOPSIS
    PortableHermes Environment Library

.DESCRIPTION
    Initializes the PortableHermes working environment.

.NOTES
    Compatible with Windows PowerShell 5.1
#>

if ($script:PortableHermesEnvironmentLoaded) {
    return
}

$script:PortableHermesEnvironmentLoaded = $true

$script:ProjectRoot = $null

function Initialize-Environment {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ProjectRoot,

        [Parameter(Mandatory)]
        $Config

    )

    $script:ProjectRoot = $ProjectRoot

    Write-InfoLog "Initializing environment..."

    $folders = @(
        $Config.Runtime,
        $Config.Workspace,
        $Config.Logs,
        $Config.Cache,
        $Config.State,
        $Config.Tmp,
        $Config.Tools,
        $Config.Downloads,
        $Config.Backups
    )

    foreach ($folder in $folders) {

        $path = Join-Path $ProjectRoot $folder

        if (!(Test-Path $path)) {

            Write-InfoLog "Creating directory: $folder"

            New-Item `
                -ItemType Directory `
                -Force `
                -Path $path | Out-Null

        }
        else {

            Write-DebugLog "Directory exists: $folder"

        }

    }

}

function Get-ProjectRoot {

    return $script:ProjectRoot

}

function Get-ProjectPath {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$RelativePath

    )

    return Join-Path `
        $script:ProjectRoot `
        $RelativePath

}

function Test-ProjectDirectory {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$RelativePath

    )

    return Test-Path `
        (Get-ProjectPath $RelativePath)

}
