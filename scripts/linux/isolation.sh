#!/usr/bin/env bash

###############################################################################
# PortableHermes
#
# Filesystem Isolation Verification
#
# Verifies that Hermes is running inside the expected isolated environment.
#
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

###############################################################################
# Verify project root
###############################################################################

if [[ -d "${PH_ROOT}" ]]; then
    pass "Project root exists"
else
    fail "Project root missing"
fi

###############################################################################
# Verify HOME
###############################################################################

case "${HOME}" in
    "${PH_ROOT}"/*)
        pass "HOME is inside PortableHermes"
        ;;
    *)
        fail "HOME is outside PortableHermes"
        ;;
esac

###############################################################################
# Verify workspace
###############################################################################

case "${PH_WORKSPACE}" in
    "${PH_ROOT}"/*)
        pass "Workspace is inside PortableHermes"
        ;;
    *)
        fail "Workspace is outside PortableHermes"
        ;;
esac

###############################################################################
# Verify writable runtime
###############################################################################

touch "${PH_TMP}/.__write_test" 2>/dev/null || fail "TMP not writable"

rm -f "${PH_TMP}/.__write_test" 2>/dev/null || true

if [[ "$FAILED" -eq 0 ]]; then
    pass "Temporary directory writable"
fi

###############################################################################
# Detect mounted Windows drives
###############################################################################

echo
echo "Mounted Windows drives"

if [[ -d /mnt ]]; then

    found=0

    for drive in /mnt/*; do

        [[ -d "$drive" ]] || continue

        name="$(basename "$drive")"

        printf "  %s\n" "$name"

        found=1

    done

    if [[ "$found" -eq 0 ]]; then
        echo "  none"
    fi

else

    echo "  /mnt does not exist"

fi

###############################################################################
# Summary
###############################################################################

echo

if [[ "$FAILED" -eq 0 ]]; then

    echo "Filesystem verification PASSED."

else

    echo "Filesystem verification FAILED."

    exit 1

fi

exit 0
