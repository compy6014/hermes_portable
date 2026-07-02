<#
.SYNOPSIS
    PortableHermes Library Loader

.DESCRIPTION
    Loads all required PowerShell libraries in the correct order.

.NOTES
    Compatible with Windows PowerShell 5.1
#>

if ($script:PortableHermesLibraryLoaderLoaded) {
    return
}

$script:PortableHermesLibraryLoaderLoaded = $true

function Import-PortableLibraries {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ProjectRoot

    )

    $libraries = @(
        "Logger.ps1",
        "Config.ps1",
        "Environment.ps1",
        "WSL.ps1"
    )

    foreach ($library in $libraries) {

        $path = Join-Path `
            $ProjectRoot `
            ("lib\" + $library)

        if (!(Test-Path $path)) {

            throw "Required library not found:`n$path"

        }

        . $path

    }

}
