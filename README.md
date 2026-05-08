# build123d-core-portable
A cross-platform portable installation for a live-coding 3D CAD environment.

## What is it?
`build123d-core-portable` provides a "download, unzip, and run" experience for [build123d](https://github.com/gumyr/build123d) powered by [filewatcher123d](https://github.com/jdegenstein/filewatcher123d). 

Instead of bundling an integrated editor like VS Code, this portable distribution is editor-agnostic. It bundles a standalone Python environment and launches a persistent, auto-reloading IPython kernel alongside an `ocp_vscode` 3D viewer server in your default web browser. You can edit your python file in *any* editor you choose (Notepad++, Vim, Cursor, etc), and the viewer will automatically update whenever you save.

The main components provided are:
 - Bundled standalone Python
 - `build123d` library
 - `filewatcher123d` Live-coding tool
 - `ocp_vscode` Viewer Server

## Installation & Usage (Windows / Linux)
1. Download the latest release for your OS from the Releases page.
2. Extract the folder.
3. Double click `Start_Filewatcher.cmd` (Windows) or the `Start_Filewatcher` executable (Linux).
   * **Guided Startup:** If you run the script normally, it will prompt you for the name of the file you want to watch. If the file doesn't exist, it will offer to generate a boilerplate template for you.
   * You can open this file in your favorite text editor to begin modeling!
   * To watch a specific file directly, launch it from the terminal: `./Start_Filewatcher my_model.py`

## Installation & Usage (MacOS)
1. Download the latest release for your OS from the Releases page.
2. Unzip the folder.
3. Run the `macos-unquarantine.sh` script to remove Apple gatekeeper quarantines on the Python binary.
4. Run the launcher script `./Start_Filewatcher.sh`.