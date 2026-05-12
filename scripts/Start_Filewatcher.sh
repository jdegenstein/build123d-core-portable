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
if [ "$OS" = "Darwin" ]; then
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-macos-aarch64-none/bin/python3"
elif [ "$OS" = "Linux" ]; then
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-linux-x86_64-gnu/bin/python3"
else
    echo "Unsupported Operating System: $OS"
    exit 1
fi

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

# 5. Guided User Experience
if [ -z "$1" ]; then
    echo "========================================"
    echo "       build123d-core-portable          "
    echo "========================================"
    read -p "Enter the python file to watch [main.py]: " USER_FILE
    USER_FILE=${USER_FILE:-main.py}
    FILE_TO_WATCH="$BUNDLE_ROOT/$USER_FILE"

    if [ ! -f "$FILE_TO_WATCH" ]; then
        echo ""
        read -p "Warning: '$USER_FILE' does not exist. Create it with a template? [Y/n]: " CREATE_FILE
        CREATE_FILE=${CREATE_FILE:-Y}
        if [[ "$CREATE_FILE" =~ ^[Yy]$ ]]; then
            echo -e "from build123d import *\nfrom ocp_vscode import *\n\nset_port(3939)\n\nshow(Box(1,1,1))" > "$FILE_TO_WATCH"
            echo "Created $USER_FILE."
        else
            echo "Exiting without creating file."
            exit 0
        fi
    fi
else
    FILE_TO_WATCH="$1"
fi

# 6. Open browser and start filewatcher123d
echo "Opening viewer at http://127.0.0.1:3939/viewer"
if [ "$OS" = "Darwin" ]; then
    open "http://127.0.0.1:3939/viewer"
elif [ "$OS" = "Linux" ]; then
    xdg-open "http://127.0.0.1:3939/viewer" &> /dev/null
fi

# Call the python module directly to bypass broken shebangs
"$PYTHON_BIN" -m filewatcher123d.cli -a "$FILE_TO_WATCH"
