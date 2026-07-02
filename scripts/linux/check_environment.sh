#!/usr/bin/env bash

###############################################################################
# PortableHermes
#
# Environment Verification
#
# Verifies that the runtime environment is correctly configured before Hermes
# starts.
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/environment.sh"

FAILED=0

###############################################################################
# Helpers
###############################################################################

pass() {
    printf "[PASS] %s\n" "$1"
}

fail() {
    printf "[FAIL] %s\n" "$1"
    FAILED=1
}

check_directory() {

    local DIR="$1"
    local NAME="$2"

    if [[ -d "$DIR" ]]; then
        pass "$NAME exists"
    else
        fail "$NAME missing ($DIR)"
    fi

}

check_writable() {

    local DIR="$1"
    local NAME="$2"

    if [[ -w "$DIR" ]]; then
        pass "$NAME writable"
    else
        fail "$NAME is not writable"
    fi

}

###############################################################################
# HOME
###############################################################################

if [[ -z "${HOME:-}" ]]; then
    fail "HOME is not set"
else
    pass "HOME is set"
fi

###############################################################################
# XDG
###############################################################################

if [[ -z "${XDG_CONFIG_HOME:-}" ]]; then
    fail "XDG_CONFIG_HOME not set"
else
    pass "XDG_CONFIG_HOME"
fi

if [[ -z "${XDG_CACHE_HOME:-}" ]]; then
    fail "XDG_CACHE_HOME not set"
else
    pass "XDG_CACHE_HOME"
fi

if [[ -z "${XDG_STATE_HOME:-}" ]]; then
    fail "XDG_STATE_HOME not set"
else
    pass "XDG_STATE_HOME"
fi

if [[ -z "${XDG_DATA_HOME:-}" ]]; then
    fail "XDG_DATA_HOME not set"
else
    pass "XDG_DATA_HOME"
fi

###############################################################################
# PortableHermes variables
###############################################################################

for VAR in \
    PH_ROOT \
    PH_RUNTIME \
    PH_WORKSPACE \
    PH_CACHE \
    PH_STATE \
    PH_TMP \
    PH_LOGS
do

    VALUE="${!VAR:-}"

    if [[ -z "$VALUE" ]]; then
        fail "$VAR is not defined"
    else
        pass "$VAR"
    fi

done

###############################################################################
# Directory checks
###############################################################################

check_directory "$PH_ROOT" "Project root"
check_directory "$PH_RUNTIME" "Runtime"
check_directory "$PH_WORKSPACE" "Workspace"
check_directory "$PH_CACHE" "Cache"
check_directory "$PH_STATE" "State"
check_directory "$PH_TMP" "Temporary"
check_directory "$PH_LOGS" "Logs"

###############################################################################
# Writable checks
###############################################################################

check_writable "$PH_RUNTIME" "Runtime"
check_writable "$PH_WORKSPACE" "Workspace"
check_writable "$PH_CACHE" "Cache"
check_writable "$PH_STATE" "State"
check_writable "$PH_TMP" "Temporary"
check_writable "$PH_LOGS" "Logs"

###############################################################################
# Verify HOME
###############################################################################

case "$HOME" in
    "$PH_ROOT"/*)
        pass "HOME is inside project"
        ;;
    *)
        fail "HOME is outside project ($HOME)"
        ;;
esac

###############################################################################
# Result
###############################################################################

echo

if [[ "$FAILED" -eq 0 ]]; then
    echo "PortableHermes environment verification PASSED."
    exit 0
else
    echo "PortableHermes environment verification FAILED."
    exit 1
fi
