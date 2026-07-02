#!/usr/bin/env bash

###############################################################################
# PortableHermes
#
# Linux Bootstrap
#
# Initializes the portable runtime environment inside WSL.
#
# Compatible with:
#   Ubuntu 22.04+
#   Ubuntu 24.04+
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "==============================================="
echo "      PortableHermes Linux Bootstrap"
echo "==============================================="
echo

###############################################################################
# Verify WSL
###############################################################################

if [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    echo "ERROR: Not running inside WSL."
    exit 1
fi

###############################################################################
# Runtime directories
###############################################################################

export PH_ROOT="${PROJECT_ROOT}"

export PH_RUNTIME="${PH_ROOT}/runtime"
export PH_WORKSPACE="${PH_ROOT}/workspace"

export PH_CACHE="${PH_ROOT}/cache"
export PH_STATE="${PH_ROOT}/state"
export PH_TMP="${PH_ROOT}/tmp"

export PH_LOGS="${PH_ROOT}/logs"

mkdir -p "${PH_RUNTIME}"
mkdir -p "${PH_WORKSPACE}"
mkdir -p "${PH_CACHE}"
mkdir -p "${PH_STATE}"
mkdir -p "${PH_TMP}"
mkdir -p "${PH_LOGS}"

###############################################################################
# XDG
###############################################################################

export HOME="${PH_RUNTIME}"

export XDG_CONFIG_HOME="${PH_RUNTIME}/config"
export XDG_CACHE_HOME="${PH_CACHE}"
export XDG_STATE_HOME="${PH_STATE}"
export XDG_DATA_HOME="${PH_RUNTIME}/share"

mkdir -p "${XDG_CONFIG_HOME}"
mkdir -p "${XDG_DATA_HOME}"

###############################################################################
# Temporary directory
###############################################################################

export TMPDIR="${PH_TMP}"

###############################################################################
# Runtime information
###############################################################################

echo "Project Root : ${PH_ROOT}"
echo "HOME         : ${HOME}"
echo "Workspace    : ${PH_WORKSPACE}"
echo "Cache        : ${PH_CACHE}"
echo "State        : ${PH_STATE}"
echo "Tmp          : ${PH_TMP}"
echo

echo "Linux bootstrap completed successfully."

exit 0
