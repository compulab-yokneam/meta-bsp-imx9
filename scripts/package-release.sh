#!/bin/bash
# treat unset variables as an error, and fail on pipeline errors.
set -euo pipefail

BBPATH="${BBPATH:-$(pwd)}"
MACHINE="${MACHINE:-ucm-imx93}"
RELEASE="${RELEASE:-}"

if [ -z "$RELEASE" ]; then
    echo "Error: \$RELEASE environment variable is not set. Run 'export RELEASE=your_version' first." >&2
    exit 1
fi

DEPLOY_DIR="$BBPATH/tmp/deploy/images"
TARGET_DIR="$MACHINE:yocto-linux"
TREE_FILE="${TARGET_DIR}.tree"
ZIP_NAME="yocto-linux-${RELEASE}-$(date -I).zip"

cd "$DEPLOY_DIR"
echo "BBPATH:  $BBPATH"
echo "MACHINE: $MACHINE"
echo "RELEASE: $RELEASE"
echo "==================================="

echo "--- Comparing Tree Structure ---"
if [ -f "$TREE_FILE" ]; then
    # Generate temporary current tree for comparison
    tree "$TARGET_DIR" > current_tree.tmp
    if diff -u "$TREE_FILE" current_tree.tmp; then
        echo "Check: Directory structure matches $TREE_FILE."
    else
        echo "Warning: Directory structure has changed since $TREE_FILE was created."
    fi
    rm current_tree.tmp
else
    echo "Notice: $TREE_FILE not found, skipping comparison."
fi

echo "--- Cleaning Up Images ---"
WIC_FILES=$(find "$TARGET_DIR/images" -name "*.wic.zst" | sort)
WIC_COUNT=$(echo "$WIC_FILES" | wc -w)

if [ "$WIC_COUNT" -gt 1 ]; then
    FILES_TO_REMOVE=$(echo "$WIC_FILES" | head -n -1)
    for f in $FILES_TO_REMOVE; do
        echo "Removing old image: $f"
        rm "$f"
    done
fi

find "$TARGET_DIR" -name "*.tar.zst" -delete

echo "--- Creating Archive ---"
sudo zip -r "$ZIP_NAME" "$TARGET_DIR"
echo "Success! Archive ready at: $DEPLOY_DIR/$ZIP_NAME"

SERVER_IP="192.168.11.1"
REMOTE_PATH="${DEPLOY_DIR#/work/}" # remove "/work/" from the beginning of the variable
FILE_URL="http://$SERVER_IP/share/$REMOTE_PATH/$ZIP_NAME"

echo "--- Verifying Deployment Availability ---"
echo "Checking URL: $FILE_URL"

curl -I "$FILE_URL"
echo "paste to wiki page:"
cat $MACHINE\:yocto-linux/version.txt
