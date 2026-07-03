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

###############################################################################
# Resolve script directory FIRST (critical for portability)
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/environment.sh"

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
# Startup pipeline
###############################################################################

print_banner

run_stage \
    "Bootstrap" \
    "${BOOTSTRAP_SCRIPT}"

run_stage \
    "Environment Verification" \
    "${CHECK_SCRIPT}"

run_stage \
    "Filesystem Isolation" \
    "${SCRIPT_DIR}/isolation.sh"

###############################################################################
# Backend execution layer (NEW ARCHITECTURE)
###############################################################################

echo
echo "------------------------------------------------"
echo "Launching PortableHermes backend..."
echo "------------------------------------------------"

BACKEND_RUNNER="${PROJECT_ROOT}/launcher/backend_runner.py"

if [[ ! -f "${BACKEND_RUNNER}" ]]; then
    echo "[ERROR] Missing backend runner:"
    echo "        ${BACKEND_RUNNER}"
    exit 1
fi

python3 "${BACKEND_RUNNER}"

EXIT_CODE=$?

echo
echo "------------------------------------------------"
echo "[Hermes] Backend execution finished"
echo "[Hermes] Exit code: ${EXIT_CODE}"
echo "------------------------------------------------"
echo

exit "${EXIT_CODE}"
