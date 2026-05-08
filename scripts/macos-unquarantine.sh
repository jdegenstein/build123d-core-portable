#!/bin/bash
BUNDLE_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "macOS applies a quarantine flag to downloaded files for security."
echo "To run the bundled python tools, the quarantine flag needs to be removed."
echo ""
echo "The following commands will be executed:"
echo "  xattr -dr com.apple.quarantine $BUNDLE_ROOT/pyinst"
echo "  xattr -dr com.apple.quarantine $BUNDLE_ROOT/python"
echo "  xattr -dr com.apple.quarantine $BUNDLE_ROOT/uv"
echo ""
read -p "Do you want to remove the quarantine flag from these folders? (y/n): " quarantine_choice

if [[ "$quarantine_choice" != "y" && "$quarantine_choice" != "Y" ]]; then
    echo "Quarantine flags will not be removed. Python may not run."
    exit 0
fi

echo ""
echo "Removing quarantine flags..."
xattr -dr com.apple.quarantine $BUNDLE_ROOT/pyinst
xattr -dr com.apple.quarantine $BUNDLE_ROOT/python
xattr -dr com.apple.quarantine $BUNDLE_ROOT/uv

echo ""
echo "Done! Tools are ready to use."