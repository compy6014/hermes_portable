@echo off
setlocal enabledelayedexpansion

REM ==========================================================
REM PortableHermes - Windows Hermes Entry Point
REM This script is executed by the Python launcher.
REM ==========================================================

echo.
echo ===============================================
echo         PortableHermes - Hermes Start
echo ===============================================
echo.

REM ----------------------------------------------------------
REM Resolve project root (bat-relative)
REM ----------------------------------------------------------
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

for %%i in ("%PROJECT_ROOT%") do set "PROJECT_ROOT=%%~fi"

echo [Hermes] Project root: %PROJECT_ROOT%

REM ----------------------------------------------------------
REM Activate Hermes environment if it exists
REM ----------------------------------------------------------
if exist "%PROJECT_ROOT%\vendor\hermes\venv\Scripts\activate.bat" (
    call "%PROJECT_ROOT%\vendor\hermes\venv\Scripts\activate.bat"
)

REM ----------------------------------------------------------
REM Set portable environment variables
REM (these may be overridden by Python launcher too)
REM ----------------------------------------------------------

set "PORTABLE_HERMES_ROOT=%PROJECT_ROOT%"
set "PORTABLE_HERMES_WORKSPACE=%PROJECT_ROOT%\workspace"
set "PORTABLE_HERMES_CACHE=%PROJECT_ROOT%\cache"
set "PORTABLE_HERMES_STATE=%PROJECT_ROOT%\state"

REM ----------------------------------------------------------
REM Change to Hermes directory
REM ----------------------------------------------------------
cd /d "%PROJECT_ROOT%\vendor\hermes"

if not exist "main.py" (
    echo [ERROR] Hermes entry point not found in vendor\hermes
    exit /b 1
)

REM ----------------------------------------------------------
REM Launch Hermes
REM ----------------------------------------------------------
echo [Hermes] Starting Hermes runtime...

python main.py

set "EXIT_CODE=%ERRORLEVEL%"

echo.
echo [Hermes] Exit code: %EXIT_CODE%

exit /b %EXIT_CODE%
