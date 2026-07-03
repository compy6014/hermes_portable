<#
.SYNOPSIS
    PortableHermes Runtime Bridge (Windows -> WSL)

.DESCRIPTION
    Executes the Linux runtime inside WSL.

.NOTES
    Compatible with Windows PowerShell 5.1
#>

if ($script:PortableHermesRuntimeLoaded) {
    return
}

$script:PortableHermesRuntimeLoaded = $true

# -------------------------------------------------------------------------
# Convert Windows path to WSL path
# -------------------------------------------------------------------------

function ConvertTo-WSLPath {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$WindowsPath
    )

    if ([string]::IsNullOrWhiteSpace($WindowsPath)) {
        throw "ConvertTo-WSLPath: path is empty."
    }

    $path = $WindowsPath.Replace("\", "/")

    if ($path -match "^([A-Za-z]):/(.*)$") {

        $drive = $matches[1].ToLower()
        $rest  = $matches[2]

        return "/mnt/$drive/$rest"
    }

    return $path
}

# -------------------------------------------------------------------------
# Execute command inside WSL
# -------------------------------------------------------------------------

function Invoke-WSLCommand {

    [CmdletBinding()]
    param(
        [string]$Command,
        [string]$WorkingDirectory = ""
    )

    $wslExe = (Get-Command "wsl.exe" -ErrorAction Stop).Source

    # -------------------------------------------------------------
    # Normalize command (CRLF FIX)
    # -------------------------------------------------------------
    $Command = $Command -replace "`r", ""

    if (-not [string]::IsNullOrWhiteSpace($WorkingDirectory)) {

        $WorkingDirectory = $WorkingDirectory -replace "`r", ""

        # IMPORTANT: single-line safe bash command
        $finalCommand = "cd `"$WorkingDirectory`" && $Command"

    }
    else {
        $finalCommand = $Command
    }

    Write-InfoLog "Executing WSL command:"
    Write-InfoLog $finalCommand

    # IMPORTANT: avoid multiline heredoc entirely
    $output = & $wslExe -d Ubuntu-22.04 bash -c $finalCommand 2>&1

    $exitCode = $LASTEXITCODE

    return @{
        Output   = $output
        ExitCode = $exitCode
    }
}

# -------------------------------------------------------------------------
# Launch Hermes runtime
# -------------------------------------------------------------------------

function Start-HermesRuntime {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ProjectRoot,

        [string]$EntryScript = "scripts/linux/launch.sh"

    )

    Write-InfoLog "Launching Hermes runtime..."

    $entryWindows = Join-Path $ProjectRoot $EntryScript

    if (-not (Test-Path -LiteralPath $entryWindows)) {

        throw "Missing runtime script:`n$entryWindows"

    }

    $wslRoot = ConvertTo-WSLPath $ProjectRoot

    Write-DebugLog "Windows root : $ProjectRoot"
    Write-DebugLog "WSL root     : $wslRoot"

    $result = Invoke-WSLCommand `
        -WorkingDirectory $wslRoot `
        -Command "bash ./scripts/linux/launch.sh"

    if ($result.ExitCode -ne 0) {

        Write-ErrorLog "Linux runtime failed."

        if ($result.Output) {

            Write-Host ""
            Write-Host "============= WSL OUTPUT =============" -ForegroundColor Yellow
            $result.Output
            Write-Host "======================================" -ForegroundColor Yellow
            Write-Host ""

        }

        throw "Linux runtime exited with code $($result.ExitCode)."

    }

    Write-InfoLog "Linux runtime completed."

    return $result.Output

}
