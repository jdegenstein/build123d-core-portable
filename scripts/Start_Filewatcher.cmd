@echo off
setlocal enabledelayedexpansion

REM 1. CALCULATE PATHS
set "BUNDLE_ROOT=%~dp0"
set "PORTABLE_PYTHON_BIN=%BUNDLE_ROOT%pyinst\cpython-3.12.12-windows-x86_64-none\python.exe"
set "PORTABLE_PYTHON_DIR=%BUNDLE_ROOT%pyinst\cpython-3.12.12-windows-x86_64-none"
set "PORTABLE_SCRIPTS_DIR=%BUNDLE_ROOT%pyinst\cpython-3.12.12-windows-x86_64-none\Scripts"

REM 2. PREPARE ENVIRONMENT
set "PATH=%PORTABLE_PYTHON_DIR%;%PORTABLE_SCRIPTS_DIR%;%PATH%"

REM 3. GUIDED USER EXPERIENCE
if not "%~1"=="" (
    set "FILE_TO_WATCH=%~1"
    goto :launch
)

echo ========================================
echo        build123d-core-portable          
echo ========================================
set "USER_FILE="
set /p USER_FILE="Enter the python file to watch [main.py]: "
if "!USER_FILE!"=="" set "USER_FILE=main.py"

set "FILE_TO_WATCH=%BUNDLE_ROOT%!USER_FILE!"

if exist "%FILE_TO_WATCH%" goto :launch

echo.
set "CREATE_FILE="
set /p CREATE_FILE="Warning: '!USER_FILE!' does not exist. Create it with a template? [Y/n]: "
if "!CREATE_FILE!"=="" set "CREATE_FILE=Y"

if /I not "!CREATE_FILE!"=="Y" (
    echo Exiting without creating file.
    pause
    exit /b
)

echo from build123d import * > "%FILE_TO_WATCH%"
echo from ocp_vscode import * >> "%FILE_TO_WATCH%"
echo set_port(3939) >> "%FILE_TO_WATCH%"
echo show(Box(1,1,1)) >> "%FILE_TO_WATCH%"
echo Created !USER_FILE!.

:launch
REM 4. LAUNCH VIEWER AND WATCHER
echo Opening viewer at http://127.0.0.1:3939/viewer
start http://127.0.0.1:3939/viewer

REM Call the python module directly to bypass broken uv trampolines
"%PORTABLE_PYTHON_BIN%" -m filewatcher123d.cli -a "%FILE_TO_WATCH%"
