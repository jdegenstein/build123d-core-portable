#!/bin/bash

# 1. Terminal Auto-Spawn for GUI Double-Clicks
if [ ! -t 0 ]; then
    OS="$(uname -s)"
    if [ "$OS" = "Darwin" ]; then
        # Relaunch inside macOS native Terminal
        exec open -a Terminal "$0"
        exit 0
    else
        # Relaunch inside Linux terminal emulators
        if command -v x-terminal-emulator >/dev/null 2>&1; then exec x-terminal-emulator -e "$0" "$@"; exit 0; fi
        if command -v gnome-terminal >/dev/null 2>&1; then exec gnome-terminal -- "$0" "$@"; exit 0; fi
        if command -v konsole >/dev/null 2>&1; then exec konsole -e "$0" "$@"; exit 0; fi
        if command -v xfce4-terminal >/dev/null 2>&1; then exec xfce4-terminal -x "$0" "$@"; exit 0; fi
        if command -v xterm >/dev/null 2>&1; then exec xterm -e "$0" "$@"; exit 0; fi
    fi
fi

# 2. Get the directory where this script is located
BUNDLE_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OS="$(uname -s)"

# 3. Define Configuration based on OS
PYTHON_BIN="$BUNDLE_ROOT/py/bin/python3"

if [ ! -f "$PYTHON_BIN" ]; then
    echo "ERROR: Python not found at: $PYTHON_BIN"
    if [ "$OS" = "Darwin" ]; then
        echo "Note: please run macos-unquarantine.sh first"
    fi
    # Pause before exiting so the user can actually read the error in the newly spawned terminal
    read -p "Press Enter to exit..." 
    exit 1
fi

# 4. Prepend Portable Python to PATH
PORTABLE_PYTHON_DIR="$(dirname "$PYTHON_BIN")"
export PATH="$PORTABLE_PYTHON_DIR:$PATH"

# 5. Open browser and start filewatcher123d
echo "Opening viewer at http://127.0.0.1:3939/viewer"
if [ "$OS" = "Darwin" ]; then
    open "http://127.0.0.1:3939/viewer"
elif [ "$OS" = "Linux" ]; then
    xdg-open "http://127.0.0.1:3939/viewer" &> /dev/null
fi

# Call the python module directly to bypass broken shebangs
# Passing -a by default to enable autoreload, then appending any user arguments
"$PYTHON_BIN" -m filewatcher123d.cli -a "$@"
