#!/bin/sh
set -e

# The 'version' option from devcontainer-feature.json is passed as the VERSION env var
TARGET_VERSION=${VERSION:-"latest"}

echo "Activating Mistral Vibe installation..."
echo "Selected version: ${TARGET_VERSION}"

# 1. Ensure uv is available in the path
export UV_PYTHON_INSTALL_DIR="/usr/local/python"
export PATH="$HOME/.local/bin:$PATH"

# 2. Construct the package string
if [ "${TARGET_VERSION}" = "latest" ]; then
    PACKAGE="mistral-vibe"
else
    PACKAGE="mistral-vibe@${TARGET_VERSION}"
fi

# 3. Install using uv tool
# We use --force to ensure we overwrite if a version already exists
uv tool install "${PACKAGE}" --force

echo "Done!"