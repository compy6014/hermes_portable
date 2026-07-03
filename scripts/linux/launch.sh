#!/usr/bin/env bash

###############################################################################
# PortableHermes
#
# Linux Runtime Launcher
#
# Main Linux entry point executed via WSL.
# Assumes bootstrap.sh has already prepared environment.
###############################################################################

set -euo pipefail

###############################################################################
# Resolve script directory FIRST (important)
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

BOOTSTRAP_SCRIPT="${SCRIPT_DIR}/bootstrap.sh"
CHECK_SCRIPT="${SCRIPT_DIR}/check_environment.sh"

###############################################################################
# Load shared environment
###############################################################################

if [[ ! -f "${SCRIPT_DIR}/environment.sh" ]]; then
    echo "[FATAL] Missing environment.sh in: ${SCRIPT_DIR}"
    exit 1
fi

source "${SCRIPT_DIR}/environment.sh"

###############################################################################
# Banner
###############################################################################

print_banner() {

    echo
    echo "==============================================="
    echo "         PortableHermes Linux Runtime"
    echo "==============================================="
    echo

}

###############################################################################
# Stage runner
###############################################################################

run_stage() {

    local NAME="$1"
    local COMMAND="$2"

    echo
    echo "------------------------------------------------"
    echo "Stage: ${NAME}"
    echo "------------------------------------------------"

    eval "${COMMAND}"

    echo "[OK] ${NAME}"
}

###############################################################################
# Start
###############################################################################

print_banner

echo "[INFO] Project root: ${PROJECT_ROOT}"

###############################################################################
# Ensure environment directories exist
###############################################################################

run_stage "Environment Initialization" "ph_create_directories"

###############################################################################
# Show environment
###############################################################################

run_stage "Environment Overview" "ph_print_environment"

###############################################################################
# Check Python availability
###############################################################################

run_stage "Python Check" "python3 --version"

###############################################################################
# Launch Agent (FIRST REAL RUNTIME STEP)
###############################################################################

AGENT_PATH="${PROJECT_ROOT}/agent/main.py"

if [[ ! -f "${AGENT_PATH}" ]]; then
    echo "[FATAL] Missing agent entrypoint: ${AGENT_PATH}"
    exit 1
fi

run_stage "Launching Hermes Agent" "python3 ${AGENT_PATH}"

###############################################################################
# Shutdown
###############################################################################

echo
echo "------------------------------------------------"
echo "PortableHermes runtime completed successfully."
echo "------------------------------------------------"
echo

exit 0
