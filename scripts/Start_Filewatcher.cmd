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
if "%~1"=="" (
    echo ========================================
    echo        build123d-core-portable          
    echo ========================================
    set /p USER_FILE="Enter the python file to watch [main.py]: "
    if "!USER_FILE!"=="" set "USER_FILE=main.py"
    
    set "FILE_TO_WATCH=%BUNDLE_ROOT%!USER_FILE!"

    if not exist "%BUNDLE_ROOT%!USER_FILE!" (
        echo.
        set /p CREATE_FILE="Warning: '!USER_FILE!' does not exist. Create it with a template? [Y/n]: "
        if "!CREATE_FILE!"=="" set "CREATE_FILE=Y"
        if /I "!CREATE_FILE!"=="Y" (
            echo from build123d import * > "%BUNDLE_ROOT%!USER_FILE!"
            echo from ocp_vscode import * >> "%BUNDLE_ROOT%!USER_FILE!"
            echo set_port(3939) >> "%BUNDLE_ROOT%!USER_FILE!"
            echo show(Box(1,1,1)) >> "%BUNDLE_ROOT%!USER_FILE!"
            echo Created !USER_FILE!.
        ) else (
            echo Exiting without creating file.
            pause
            exit /b
        )
    )
) else (
    set "FILE_TO_WATCH=%~1"
)

REM 4. LAUNCH VIEWER AND WATCHER
echo Opening viewer at http://127.0.0.1:3939/viewer
start http://127.0.0.1:3939/viewer

fw123d -a "%FILE_TO_WATCH%"