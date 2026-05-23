@echo off
setlocal enabledelayedexpansion

REM 1. CALCULATE PATHS
set "BUNDLE_ROOT=%~dp0"
set "PORTABLE_PYTHON_BIN=%BUNDLE_ROOT%py\python.exe"
set "PORTABLE_PYTHON_DIR=%BUNDLE_ROOT%py"
set "PORTABLE_SCRIPTS_DIR=%BUNDLE_ROOT%py\Scripts"

REM 2. PREPARE ENVIRONMENT
set "PATH=%PORTABLE_PYTHON_DIR%;%PORTABLE_SCRIPTS_DIR%;%PATH%"

REM 3. LAUNCH VIEWER AND WATCHER
echo Opening viewer at http://127.0.0.1:3939/viewer
start http://127.0.0.1:3939/viewer

REM Call the python module directly to bypass broken uv trampolines
REM Passing -a by default to enable autoreload, then appending any user arguments
"%PORTABLE_PYTHON_BIN%" -m filewatcher123d.cli -a %*
