#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# PortableHermes Linux Runtime Launcher
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${SCRIPT_DIR}/environment.sh"

###############################################################################
# Banner
###############################################################################

print_banner() {
    echo
    echo "==============================================="
    echo "     PortableHermes Linux Runtime (DEBUG)"
    echo "==============================================="
    echo
}

print_banner

###############################################################################
# Debug info
###############################################################################

echo "[DEBUG] SCRIPT_DIR   = ${SCRIPT_DIR}"
echo "[DEBUG] PROJECT_ROOT = ${PROJECT_ROOT}"
echo "[DEBUG] USER         = $(whoami)"
echo "[DEBUG] PWD          = $(pwd)"
echo

###############################################################################
# Environment setup
###############################################################################

ph_create_directories
ph_print_environment

###############################################################################
# Python check
###############################################################################

echo
echo "[STAGE] Python availability check"

if ! command -v python3 >/dev/null 2>&1; then
    echo "[FATAL] python3 is not installed in WSL"
    exit 1
fi

python3 --version

###############################################################################
# Project validation
###############################################################################

echo
echo "[STAGE] Listing project structure"

ls -la "${PROJECT_ROOT}" || {
    echo "[ERROR] Cannot list project root"
    exit 1
}

###############################################################################
# Agent validation
###############################################################################

echo
echo "[STAGE] Checking agent path"

AGENT_PATH="${PROJECT_ROOT}/agent/main.py"

if [[ ! -f "${AGENT_PATH}" ]]; then
    echo "[FATAL] agent/main.py NOT FOUND at:"
    echo "        ${AGENT_PATH}"
    exit 1
fi

echo "[OK] Found agent: ${AGENT_PATH}"

###############################################################################
# Agent execution
###############################################################################

echo
echo "[STAGE] Running agent..."

set +e
python3 "${AGENT_PATH}"
AGENT_EXIT=$?
set -e

echo
echo "[STAGE] Agent finished execution"
echo "[INFO] Agent exit code: ${AGENT_EXIT}"

###############################################################################
# Final output
###############################################################################

echo
echo "==============================================="
echo "Runtime completed"
echo "==============================================="

exit ${AGENT_EXIT}
