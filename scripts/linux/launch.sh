#!/usr/bin/env bash

###############################################################################
# PortableHermes
#
# Linux Runtime Launcher
#
# This script is the main Linux entry point.
# It assumes bootstrap.sh has already initialized the environment.
###############################################################################

set -euo pipefail

source "${SCRIPT_DIR}/environment.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BOOTSTRAP_SCRIPT="${SCRIPT_DIR}/bootstrap.sh"
CHECK_SCRIPT="${SCRIPT_DIR}/check_environment.sh"

###############################################################################
# Helpers
###############################################################################

print_banner() {

    echo
    echo "==============================================="
    echo "         PortableHermes Runtime"
    echo "==============================================="
    echo

}

run_stage() {

    local NAME="$1"
    local SCRIPT="$2"

    echo
    echo "------------------------------------------------"
    echo "Stage : ${NAME}"
    echo "------------------------------------------------"

    if [[ ! -f "${SCRIPT}" ]]; then
        echo "ERROR: Missing script:"
        echo "       ${SCRIPT}"
        exit 1
    fi

    chmod +x "${SCRIPT}"

    "${SCRIPT}"

}

###############################################################################
# Startup
###############################################################################

print_banner

run_stage \
    "Bootstrap" \
    "${BOOTSTRAP_SCRIPT}"

run_stage \
    "Environment Verification" \
    "${CHECK_SCRIPT}"

###############################################################################
# Future stages
###############################################################################

echo
echo "------------------------------------------------"
echo "Runtime initialization complete."
echo
echo "Future stages:"
echo "  - Python runtime"
echo "  - Node.js runtime"
echo "  - Hermes Agent"
echo "  - MCP Servers"
echo "  - Local LLM"
echo
echo "Nothing else has been started yet."
echo

exit 0
