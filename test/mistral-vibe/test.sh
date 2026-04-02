#!/bin/bash
set -e

# Import test library helpers
source dev-container-features-test-lib

# Check if 'vibe' (the command) is available
check "vibe-exists" vibe --version

# Check if uv is still working
check "uv-exists" uv --version

# Report results
reportResults