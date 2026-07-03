@echo off
setlocal EnableExtensions

REM ============================================================================
REM PortableHermes Bootstrap Launcher
REM ----------------------------------------------------------------------------
REM Entry point for PortableHermes.
REM This script determines the project root and launches the PowerShell
REM bootstrap script without requiring installation.
REM ============================================================================

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"

set "POWERSHELL=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

if not exist "%POWERSHELL%" (
    echo [ERROR] Windows PowerShell not found.
    pause
    exit /b 1
)

"%POWERSHELL%" ^
    -NoLogo ^
    -NoProfile ^
    -ExecutionPolicy Bypass ^
    -File "%PROJECT_ROOT%\bootstrap\Start.ps1"

set EXITCODE=%ERRORLEVEL%

if NOT "%EXITCODE%"=="0" (
    echo.
    echo PortableHermes terminated with exit code %EXITCODE%.
    pause
)

exit /b %EXITCODE%
