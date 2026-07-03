<#
.SYNOPSIS
    PortableHermes Runtime Bridge (Windows → WSL)

.DESCRIPTION
    Executes Linux-side Hermes runtime via WSL,
    handles path translation, execution, and output capture.

.NOTES
    Requires WSL installed and validated via Test-WSL
#>

if ($script:PortableHermesRuntimeLoaded) {
    return
}

$script:PortableHermesRuntimeLoaded = $true

# -------------------------------------------------------------------------
# Convert Windows path to WSL path (O:\ -> /mnt/o/)
# -------------------------------------------------------------------------
function ConvertTo-WSLPath {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$WindowsPath
    )

    if ([string]::IsNullOrWhiteSpace($WindowsPath)) {
        throw "ConvertTo-WSLPath: input path is empty"
    }

    $path = $WindowsPath.Replace("\", "/")

    if ($path -match "^([A-Za-z]):/(.*)") {

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
        [Parameter(Mandatory)]
        [string]$Command,

        [string]$WorkingDirectory = ""
    )

    $wslExe = (Get-Command wsl.exe -ErrorAction Stop).Source

    if (-not [string]::IsNullOrWhiteSpace($WorkingDirectory)) {
        $cmd = "cd `"$WorkingDirectory`" && $Command"
    }
    else {
        $cmd = $Command
    }

    Write-InfoLog "Executing WSL command: $Command"

    $output = & $wslExe --exec bash -c "$cmd" 2>&1
    $exit   = $LASTEXITCODE

    return @{
        Output   = $output
        ExitCode = $exit
    }
}

# -------------------------------------------------------------------------
# Launch Hermes runtime inside WSL
# -------------------------------------------------------------------------
function Start-HermesRuntime {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectRoot,

        [string]$EntryScript = "scripts/linux/launch.sh"
    )

    Write-InfoLog "Starting Hermes runtime..."

    # Convert project root to WSL path
    $wslRoot = ConvertTo-WSLPath -WindowsPath $ProjectRoot

    # Convert entry script path
    $wslEntry = ConvertTo-WSLPath -WindowsPath (Join-Path $ProjectRoot $EntryScript)

    Write-DebugLog "WSL Project Root: $wslRoot"
    Write-DebugLog "WSL Entry Script: $wslEntry"

    # Ensure script exists (Windows-side check)
    if (-not (Test-Path (Join-Path $ProjectRoot $EntryScript))) {
        throw "Missing WSL entry script: $EntryScript"
    }

    # Execute via WSL
    $result = Invoke-WSLCommand -Command "bash `"$wslEntry`""

    if ($result.ExitCode -ne 0) {
        Write-ErrorLog "WSL runtime failed: $($result.Output)"
        throw "Hermes runtime failed inside WSL (exit code $($result.ExitCode))"
    }

    Write-InfoLog "Hermes runtime completed successfully."

    return $result.Output
}