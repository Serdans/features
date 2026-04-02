#!/bin/bash
set -e

VERSION=${VERSION:-"latest"}
PACKAGE="mistral-vibe"

echo "Activating Mistral Vibe installation..."

# 1. Manually add common uv installation paths to the current script's PATH
export PATH="/usr/local/bin:/root/.local/bin:$HOME/.local/bin:$PATH"

# 2. Verify uv is actually there now
if ! command -v uv >/dev/null 2>&1; then
    echo "ERROR: uv is still not found in PATH ($PATH)."
    echo "Ensure the uv feature is installed correctly."
    exit 1
fi

# 3. Construct the package string
if [ "${VERSION}" = "latest" ]; then
    INSTALL_SPEC="${PACKAGE}"
else
    INSTALL_SPEC="${PACKAGE}==${VERSION}"
fi

echo "Installing ${INSTALL_SPEC} using $(command -v uv)..."

# 4. Install the tool
# Using --force to handle reinstalls/updates
uv tool install "${INSTALL_SPEC}" --force

echo "Installation successful!"