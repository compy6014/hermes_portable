#!/usr/bin/env bash

###############################################################################
# PortableHermes
#
# Shared Environment
#
# Every Linux script MUST source this file.
#
# Example:
#
# source "${SCRIPT_DIR}/environment.sh"
#
###############################################################################

set -euo pipefail

###############################################################################
# Locate project root
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

###############################################################################
# PortableHermes paths
###############################################################################

export PH_ROOT="${PROJECT_ROOT}"

export PH_RUNTIME="${PH_ROOT}/runtime"
export PH_WORKSPACE="${PH_ROOT}/workspace"

export PH_CACHE="${PH_ROOT}/cache"
export PH_STATE="${PH_ROOT}/state"
export PH_TMP="${PH_ROOT}/tmp"

export PH_LOGS="${PH_ROOT}/logs"

export PH_TOOLS="${PH_ROOT}/tools"

export PH_DOWNLOADS="${PH_ROOT}/downloads"

export PH_BACKUPS="${PH_ROOT}/backups"

###############################################################################
# Runtime directories
###############################################################################

export HOME="${PH_RUNTIME}"

export XDG_CONFIG_HOME="${HOME}/config"

export XDG_CACHE_HOME="${PH_CACHE}"

export XDG_STATE_HOME="${PH_STATE}"

export XDG_DATA_HOME="${HOME}/share"

export TMPDIR="${PH_TMP}"

###############################################################################
# PATH
###############################################################################

export PATH="${PH_TOOLS}/bin:${PATH}"

###############################################################################
# Helper functions
###############################################################################

ph_print_environment() {

    echo
    echo "PortableHermes Environment"
    echo "--------------------------"

    printf "%-18s %s\n" "PH_ROOT" "$PH_ROOT"
    printf "%-18s %s\n" "PH_RUNTIME" "$PH_RUNTIME"
    printf "%-18s %s\n" "PH_WORKSPACE" "$PH_WORKSPACE"
    printf "%-18s %s\n" "PH_CACHE" "$PH_CACHE"
    printf "%-18s %s\n" "PH_STATE" "$PH_STATE"
    printf "%-18s %s\n" "PH_TMP" "$PH_TMP"
    printf "%-18s %s\n" "PH_LOGS" "$PH_LOGS"
    printf "%-18s %s\n" "HOME" "$HOME"

    echo

}

ph_create_directories() {

    mkdir -p "${PH_RUNTIME}"
    mkdir -p "${PH_WORKSPACE}"
    mkdir -p "${PH_CACHE}"
    mkdir -p "${PH_STATE}"
    mkdir -p "${PH_TMP}"
    mkdir -p "${PH_LOGS}"
    mkdir -p "${PH_TOOLS}"
    mkdir -p "${PH_DOWNLOADS}"
    mkdir -p "${PH_BACKUPS}"

    mkdir -p "${XDG_CONFIG_HOME}"
    mkdir -p "${XDG_DATA_HOME}"

}
