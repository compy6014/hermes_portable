<#
.SYNOPSIS
    PortableHermes Runtime Bridge (Windows → WSL)
#>

if ($script:PortableHermesRuntimeLoaded) {
    return
}

$script:PortableHermesRuntimeLoaded = $true

function ConvertTo-WSLPath {
    param([string]$WindowsPath)

    if ([string]::IsNullOrWhiteSpace($WindowsPath)) {
        throw "Empty path"
    }

    $path = $WindowsPath.Replace("\", "/")

    if ($path -match "^([A-Za-z]):/(.*)") {
        $drive = $matches[1].ToLower()
        $rest  = $matches[2]
        return "/mnt/$drive/$rest"
    }

    return $path
}

function Invoke-WSLCommand {
    param(
        [string]$Command,
        [string]$WorkingDirectory = ""
    )

    $wsl = (Get-Command wsl.exe).Source

    if (-not [string]::IsNullOrWhiteSpace($WorkingDirectory)) {
        $cmd = "cd `"$WorkingDirectory`" && $Command"
    }
    else {
        $cmd = $Command
    }

    Write-InfoLog "WSL: $Command"

    $output = & $wsl --exec bash -c "$cmd" 2>&1
    $exit = $LASTEXITCODE

    return @{
        Output = $output
        ExitCode = $exit
    }
}

function Start-HermesRuntime {
    param(
        [string]$ProjectRoot,
        [string]$EntryScript = "scripts/linux/launch.sh"
    )

    Write-InfoLog "Launching Hermes runtime..."

    if (-not (Test-Path (Join-Path $ProjectRoot $EntryScript))) {
        throw "Missing entry script: $EntryScript"
    }

    $wslRoot = ConvertTo-WSLPath $ProjectRoot

    $result = Invoke-WSLCommand `
        -WorkingDirectory $wslRoot `
        -Command "bash ./scripts/linux/launch.sh"

    if ($result.ExitCode -ne 0) {
        throw "WSL runtime failed: $($result.Output)"
    }

    return $result.Output
}
