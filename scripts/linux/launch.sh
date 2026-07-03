#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${SCRIPT_DIR}/environment.sh"

print_banner() {
    echo
    echo "==============================================="
    echo "     PortableHermes Linux Runtime (DEBUG)"
    echo "==============================================="
    echo
}

print_banner

echo "[DEBUG] SCRIPT_DIR   = ${SCRIPT_DIR}"
echo "[DEBUG] PROJECT_ROOT = ${PROJECT_ROOT}"
echo "[DEBUG] USER         = $(whoami)"
echo "[DEBUG] PWD          = $(pwd)"
echo

ph_create_directories
ph_print_environment

echo
echo "[STAGE] Python availability check"
python3 --version || echo "[ERROR] Python missing"

echo
echo "[STAGE] Listing project structure"
ls -la "${PROJECT_ROOT}" || echo "[ERROR] Cannot list project root"

echo
echo "[STAGE] Checking agent path"

AGENT_PATH="${PROJECT_ROOT}/agent/main.py"

if [[ ! -f "${AGENT_PATH}" ]]; then
    echo "[FATAL] agent/main.py NOT FOUND at:"
    echo "        ${AGENT_PATH}"
    exit 1
fi

echo "[OK] Found agent: ${AGENT_PATH}"

echo
echo "[STAGE] Running agent..."

python3 "${AGENT_PATH}"

echo
echo "[STAGE] Agent finished execution"

echo
echo "==============================================="
echo "Runtime completed"
echo "==============================================="
