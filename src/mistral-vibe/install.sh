#!/bin/bash
set -e

VERSION=${VERSION:-"latest"}
PACKAGE="mistral-vibe"

echo "(*) Activating Mistral Vibe installation..."

# 1. Expand PATH to include all possible locations where uv might be
export PATH="/usr/local/bin:/root/.local/bin:$HOME/.local/bin:$PATH"

# 2. If uv is still missing, install it as a fallback
if ! command -v uv >/dev/null 2>&1; then
    echo "(!) uv not found. Installing uv automatically..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add the newly installed uv to the path for this session
    export PATH="/root/.local/bin:$PATH"
fi

# 3. Determine the user and their home directory
USERNAME=${_REMOTE_USER:-"root"}
USER_HOME=$(getent passwd "$USERNAME" | cut -d: -f6)

# 4. Perform the installation
if [ "${VERSION}" = "latest" ]; then
    INSTALL_SPEC="${PACKAGE}"
else
    INSTALL_SPEC="${PACKAGE}==${VERSION}"
fi

echo "(*) Installing ${INSTALL_SPEC}..."

# We run this through 'su' to ensure the tool is available to the remote user
if [ "$USERNAME" != "root" ]; then
    su "$USERNAME" -c "export PATH=\"$PATH\"; uv tool install ${INSTALL_SPEC} --force"
else
    uv tool install "${INSTALL_SPEC}" --force
fi

echo "(*) Mistral Vibe installation successful!"