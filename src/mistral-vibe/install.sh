#!/bin/bash
set -e

VERSION=${VERSION:-"latest"}
PACKAGE="mistral-vibe"

echo "(*) Installing Mistral Vibe..."

# 1. Ensure the current script can see uv
# Standard features usually put uv in /usr/local/bin or the user's .local/bin
export PATH="/usr/local/bin:/root/.local/bin:$HOME/.local/bin:$PATH"

# 2. Verify uv exists
if ! command -v uv >/dev/null 2>&1; then
    echo "(!) uv not found in PATH. Attempting quick local install..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# 3. Handle the User Context
# In standard images, _REMOTE_USER is usually 'vscode'. 
# We want the 'vibe' tool available in their specific PATH.
USERNAME=${_REMOTE_USER:-"root"}
USER_HOME=$(getent passwd "$USERNAME" | cut -d: -f6)

# 4. Define the version specifier
if [ "${VERSION}" = "latest" ]; then
    INSTALL_SPEC="${PACKAGE}"
else
    INSTALL_SPEC="${PACKAGE}==${VERSION}"
fi

# 5. Install the tool
echo "(*) Installing ${INSTALL_SPEC} for user: ${USERNAME}"

if [ "$USERNAME" != "root" ]; then
    # We run as the user to ensure the tool is installed in their home (~/.local/bin)
    # and that they own the resulting files.
    su "$USERNAME" -c "export PATH=\$PATH; uv tool install ${INSTALL_SPEC} --force"
else
    uv tool install "${INSTALL_SPEC}" --force
fi

echo "(*) Mistral Vibe installation complete!"