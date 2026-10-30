#!/bin/bash
# Integration tests for disposable GitHub-hosted VMs only, not student setup.
# These tests create local accounts and alter system-owned exercise files.
# Never run this script on a personal machine or a self-hosted runner.
set -eu
set -o pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
pass() { printf 'ok - %s\n' "$*"; }
equal() {
    [ "$1" = "$2" ] || fail "$3: expected [$2], received [$1]"
}

# This is an accidental-use guard, not a security boundary.
[ "${GITHUB_ACTIONS:-}" = true ] &&
    [ "${RUNNER_ENVIRONMENT:-}" = github-hosted ] ||
    fail 'Run only in the project2 workflow on a disposable GitHub-hosted VM.'
[ "$(id -u)" -ne 0 ] || fail 'Start as the ordinary runner account, not root.'
sudo -n true || fail 'The hosted runner must have passwordless sudo.'

REPO=$(cd -- "$(dirname -- "$0")/.." && pwd)
SOURCE="$REPO/第三周資料/project2"
SETUP="$SOURCE/setup.sh"
CLEANUP="$SOURCE/cleanup-macos.sh"
AMY=clerk_amy
BEN=clerk_ben
STAFF=library_staff
SYSTEM=$(uname -s)
case "$SYSTEM" in
    Linux) BASE=/srv/course-library ;;
    Darwin) BASE=/Users/Shared/course-library ;;
    *) fail "Unsupported test OS: $SYSTEM" ;;
esac

TEST_TMP=$(mktemp -d "${RUNNER_TEMP:?}/course-library-test.XXXXXX")
trap 'rm -rf "$TEST_TMP"' EXIT

expect_failure() {
    if "$@" > "$TEST_TMP/expected-failure.log" 2>&1; then
        cat "$TEST_TMP/expected-failure.log" >&2
        fail "Expected rejection: $*"
    fi
}

absent_path() {
    [ ! -e "$1" ] && [ ! -L "$1" ] || fail "Unexpected existing path: $1"
}

absent_user() {
    if id "$1" >/dev/null 2>&1; then
        fail "Unexpected existing user: $1"
    fi
}

absent_group() {
    if [ "$SYSTEM" = Darwin ]; then
        if dscl . -read "/Groups/$STAFF" >/dev/null 2>&1; then
            fail "Unexpected existing group: $STAFF"
        fi
    elif getent group "$STAFF" >/dev/null; then
        fail "Unexpected existing group: $STAFF"
    fi
}

group_ids() { id -G "$1" | tr ' ' '\n' | sort -n | uniq; }

metadata() {
    if [ "$SYSTEM" = Darwin ]; then
        /usr/bin/stat -f '%Lp:%u:%g' "$1"
    else
        /usr/bin/stat -c '%a:%u:%g' "$1"
    fi
}

identities() {
    for account in "$AMY" "$BEN"; do
        printf '%s:%s:%s\n' "$account" "$(id -u "$account")" "$(id -g "$account")"
        group_ids "$account"
        if [ "$SYSTEM" = Darwin ]; then
            dscl . -read "/Users/$account" GeneratedUID
        fi
    done
    if [ "$SYSTEM" = Darwin ]; then
        dscl . -read "/Groups/$STAFF" PrimaryGroupID GeneratedUID
    else
        getent group "$STAFF"
    fi
}

assert_initial_files() {
    equal "$(metadata "$BASE")" '755:0:0' 'Exercise directory permissions'
    for file in books.csv reservations.csv internal.txt handover.txt; do
        sudo -n cmp "$SOURCE/$file" "$BASE/$file" || fail "Unexpected initial content: $file"
    done
    equal "$(metadata "$BASE/books.csv")" "640:0:$STAFF_GID" 'Book permissions'
    equal "$(metadata "$BASE/reservations.csv")" "640:0:$STAFF_GID" 'Reservation permissions'
    equal "$(metadata "$BASE/internal.txt")" '600:0:0' 'Internal-note permissions'
    equal "$(metadata "$BASE/handover.txt")" '640:0:0' 'Handover permissions'
}

RUNNER_ACCOUNT=$(id -un)
RUNNER_GROUPS=$(group_ids "$RUNNER_ACCOUNT")
absent_path "$BASE"
absent_user "$AMY"
absent_user "$BEN"
absent_group

# Refusing the wrong location must happen before account creation or copying.
sudo -n mkdir "$BASE"
printf 'unrelated directory\n' | sudo -n tee "$BASE/sentinel.txt" >/dev/null
expect_failure sudo -n /bin/bash "$SETUP"
equal "$(sudo -n cat "$BASE/sentinel.txt")" 'unrelated directory' 'Unknown directory preserved'
absent_user "$AMY"
absent_user "$BEN"
absent_group
sudo -n rm "$BASE/sentinel.txt"
sudo -n rmdir "$BASE"

mkdir "$TEST_TMP/link-target"
printf 'unrelated target\n' > "$TEST_TMP/link-target/sentinel.txt"
sudo -n ln -s "$TEST_TMP/link-target" "$BASE"
expect_failure sudo -n /bin/bash "$SETUP"
equal "$(cat "$TEST_TMP/link-target/sentinel.txt")" 'unrelated target' 'Directory symlink target preserved'
[ -L "$BASE" ] || fail 'Setup replaced the directory symlink.'
sudo -n rm "$BASE"
pass 'Unknown directories and directory symlinks are rejected without changes'

if [ "$SYSTEM" = Darwin ]; then
    # A matching name does not establish ownership of a pre-existing Mac account.
    FIXTURE_UID=61000
    while dscl . -list /Users UniqueID | awk -v n="$FIXTURE_UID" '$2 == n {found=1} END {exit !found}'; do
        FIXTURE_UID=$((FIXTURE_UID + 1))
    done
    sudo -n dscl . -create "/Users/$AMY"
    sudo -n dscl . -create "/Users/$AMY" UniqueID "$FIXTURE_UID"
    sudo -n dscl . -create "/Users/$AMY" PrimaryGroupID "$(id -g)"
    sudo -n dscl . -create "/Users/$AMY" UserShell /usr/bin/false
    sudo -n dscl . -create "/Users/$AMY" NFSHomeDirectory /var/empty
    sudo -n dscl . -create "/Users/$AMY" RealName 'Foreign CI account'
    sudo -n dscl . -create "/Users/$AMY" Password '*'
    sudo -n dscacheutil -flushcache
    FOREIGN_USER=$(dscl . -read "/Users/$AMY")
    expect_failure sudo -n /bin/bash "$SETUP"
    equal "$(dscl . -read "/Users/$AMY")" "$FOREIGN_USER" 'Foreign Mac account preserved'
    absent_path "$BASE"
    absent_user "$BEN"
    absent_group
    equal "$(id -u "$AMY")" "$FIXTURE_UID" 'Foreign fixture identity before removing fixture'
    sudo -n dscl . -delete "/Users/$AMY"
    sudo -n dscacheutil -flushcache

    FIXTURE_GID=61000
    while dscl . -list /Groups PrimaryGroupID | awk -v n="$FIXTURE_GID" '$2 == n {found=1} END {exit !found}'; do
        FIXTURE_GID=$((FIXTURE_GID + 1))
    done
    sudo -n dscl . -create "/Groups/$STAFF"
    sudo -n dscl . -create "/Groups/$STAFF" PrimaryGroupID "$FIXTURE_GID"
    sudo -n dscl . -create "/Groups/$STAFF" RealName 'Foreign CI group'
    FOREIGN_GROUP=$(dscl . -read "/Groups/$STAFF")
    expect_failure sudo -n /bin/bash "$SETUP"
    equal "$(dscl . -read "/Groups/$STAFF")" "$FOREIGN_GROUP" 'Foreign Mac group preserved'
    absent_path "$BASE"
    absent_user "$AMY"
    absent_user "$BEN"
    sudo -n dscl . -delete "/Groups/$STAFF"
    sudo -n dscacheutil -flushcache
    pass 'Unrelated Mac accounts and groups are not adopted or modified'
fi

expect_failure /bin/bash "$SETUP"
absent_path "$BASE"
sudo -n /bin/bash "$SETUP"
cd "$BASE"

if [ "$SYSTEM" = Darwin ]; then
    STAFF_GID=$(dscl . -read "/Groups/$STAFF" PrimaryGroupID | awk '{print $2}')
else
    STAFF_GID=$(getent group "$STAFF" | cut -d: -f3)
fi
[ -n "$STAFF_GID" ] || fail 'Missing library_staff numeric GID.'
for account in "$AMY" "$BEN"; do
    [ "$(id -u "$account")" -ne 0 ] || fail "$account must not be root."
    equal "$(id -g "$account")" "$STAFF_GID" "$account primary group"
    equal "$(sudo -n -u "$account" id -un)" "$account" "$account sudo name resolution"
    equal "$(sudo -n -u "$account" id -g)" "$STAFF_GID" "$account effective primary group"
    if [ "$SYSTEM" = Darwin ]; then
        equal "$(dscl . -read "/Users/$account" IsHidden | awk '{print $2}')" 1 "$account hidden account"
        equal "$(dscl . -read "/Users/$account" UserShell | awk '{print $2}')" /usr/bin/false "$account noninteractive shell"
        equal "$(dscl . -read "/Users/$account" NFSHomeDirectory | awk '{print $2}')" /var/empty "$account home"
    fi
done
ORIGINAL_IDENTITIES=$(identities)
equal "$(group_ids "$RUNNER_ACCOUNT")" "$RUNNER_GROUPS" 'Operator groups after setup'
assert_initial_files
pass 'Real accounts, sudo identity resolution, initial content and permissions'

# Q1: readable book metadata and deliberately unreadable administrator notes.
equal "$(sudo -n -u "$AMY" awk -F, '$1=="B001" {print $2 "," $3}' "$BASE/books.csv")" 'Linux入門,yes' 'Q1 book lookup'
sudo -n -u "$AMY" cat "$BASE/reservations.csv" >/dev/null
expect_failure sudo -n -u "$AMY" cat "$BASE/internal.txt"
expect_failure sudo -n -u "$BEN" cat "$BASE/handover.txt"
expect_failure sudo -n -u "$AMY" touch "$BASE/unexpected.txt"
absent_path "$BASE/unexpected.txt"

# Q2: exercise the same write permission as nano without automating its UI.
# Redirection is inside Amy's shell, so the invoking runner cannot write for her.
equal "$(sudo -n -u "$AMY" awk -F, '$1=="2026-10-17" && $2=="B001"' "$BASE/reservations.csv")" '' 'Q2 initially available'
expect_failure sudo -n -u "$AMY" /bin/sh -c 'printf "%s\n" "2026-10-17,B001,小明" >> "$1"' project2-test "$BASE/reservations.csv"
sudo -n cmp "$SOURCE/reservations.csv" "$BASE/reservations.csv"
sudo -n chmod g+w "$BASE/reservations.csv"
equal "$(metadata "$BASE/reservations.csv")" "660:0:$STAFF_GID" 'Q2 only group write added'
sudo -n -u "$AMY" /bin/sh -c 'printf "%s\n" "2026-10-17,B001,小明" >> "$1"' project2-test "$BASE/reservations.csv"

# Q3: Ben reads the same reservation and rejects the duplicate request.
equal "$(sudo -n -u "$BEN" awk -F, '$1=="2026-10-17" && $2=="B001" {print $3}' "$BASE/reservations.csv")" '小明' 'Q3 shared reservation'
equal "$(sudo -n -u "$BEN" awk -F, '$1=="2026-10-17" && $2=="B001" {n++} END {print n+0}' "$BASE/reservations.csv")" 1 'Q3 one reservation for the date and book'

# Q4 and Q5: shared read access, preview, a separate output, and an admin copy.
sudo -n chgrp "$STAFF" "$BASE/handover.txt"
equal "$(metadata "$BASE/handover.txt")" "640:0:$STAFF_GID" 'Q4 only handover group changed'
sudo -n -u "$BEN" cat "$BASE/handover.txt" >/dev/null
sudo -n -u "$BEN" sed 's/Ami/Amy/g' "$BASE/handover.txt" > "$TEST_TMP/handover-fixed.txt"
sudo -n cmp "$SOURCE/handover.txt" "$BASE/handover.txt"
EXPECTED_HANDOVER=$(sed 's/Ami/Amy/g' "$SOURCE/handover.txt")
equal "$(cat "$TEST_TMP/handover-fixed.txt")" "$EXPECTED_HANDOVER" 'Q5 preview and separate output'
sudo -n cp "$TEST_TMP/handover-fixed.txt" "$BASE/handover.txt"
equal "$(sudo -n -u "$BEN" cat "$BASE/handover.txt")" "$EXPECTED_HANDOVER" 'Q5 final read by Ben'

# Q6: the three original bookings plus Xiaoming, with the header excluded.
equal "$(sudo -n -u "$BEN" awk -F, '$1=="2026-10-17" {n++} END {print n+0}' "$BASE/reservations.csv")" 4 'Q6 tomorrow total'
equal "$(sudo -n -u "$BEN" awk 'END {print NR}' "$BASE/reservations.csv")" 9 'Original and new reservations retained'
pass 'All six exercise outcomes, including permission denials and four books'

sudo -n /bin/bash "$SETUP"
equal "$(identities)" "$ORIGINAL_IDENTITIES" 'Reset retains account and group identities'
equal "$(group_ids "$RUNNER_ACCOUNT")" "$RUNNER_GROUPS" 'Reset leaves operator groups unchanged'
assert_initial_files
equal "$(sudo -n -u "$BEN" awk -F, '$1=="2026-10-17" {n++} END {print n+0}' "$BASE/reservations.csv")" 3 'Reset restores three tomorrow bookings'
pass 'Rerun restores the exercise while preserving identities and operator groups'

# The target must remain untouched when a managed file is replaced by a symlink.
sudo -n mv "$BASE/books.csv" "$BASE/books.csv.test-backup"
sudo -n ln -s "$TEST_TMP/link-target/sentinel.txt" "$BASE/books.csv"
expect_failure sudo -n /bin/bash "$SETUP"
[ -L "$BASE/books.csv" ] || fail 'Setup replaced the file symlink.'
equal "$(cat "$TEST_TMP/link-target/sentinel.txt")" 'unrelated target' 'File symlink target preserved'
sudo -n rm "$BASE/books.csv"
sudo -n mv "$BASE/books.csv.test-backup" "$BASE/books.csv"
assert_initial_files
pass 'Managed-file symlinks are rejected without changing their targets'

if [ "$SYSTEM" = Darwin ]; then
    # macOS prints @ instead of + when an object has both xattrs and an ACL.
    # Inspecting only the permission suffix would miss this write-access ACL.
    sudo -n chmod +a "user:$RUNNER_ACCOUNT allow add_file" "$BASE"
    sudo -n xattr -w org.bigdatacourse.ci acl-regression "$BASE"
    case "$(ls -ld "$BASE" | awk 'NR == 1 {print $1}')" in
        *@) ;;
        *) fail 'ACL regression requires the xattr permission suffix.' ;;
    esac
    expect_failure sudo -n /bin/bash "$SETUP"
    expect_failure sudo -n /bin/bash "$CLEANUP" --confirm
    equal "$(identities)" "$ORIGINAL_IDENTITIES" 'ACL refusal preserves account identities'
    sudo -n chmod -N "$BASE"
    sudo -n xattr -d org.bigdatacourse.ci "$BASE"
    assert_initial_files
    pass 'An ACL hidden behind an xattr suffix blocks reset and cleanup'

    expect_failure sudo -n /bin/bash "$CLEANUP"
    equal "$(identities)" "$ORIGINAL_IDENTITIES" 'Cleanup requires explicit confirmation'
    pass 'Mac cleanup requires explicit confirmation'

    printf 'keep this extra file\n' | sudo -n tee "$BASE/extra.txt" >/dev/null
    expect_failure sudo -n /bin/bash "$CLEANUP" --confirm
    equal "$(sudo -n cat "$BASE/extra.txt")" 'keep this extra file' 'Cleanup preserves unknown files'
    equal "$(identities)" "$ORIGINAL_IDENTITIES" 'Rejected cleanup does not remove accounts'
    sudo -n rm "$BASE/extra.txt"
    pass 'Mac cleanup preserves extra files and all account identities'

    # Test an identity mismatch without rewriting a macOS-protected GeneratedUID.
    # Only the root-owned manifest's expected Amy UUID changes; real accounts stay intact.
    MAC_MANIFEST="$BASE/.course-library-macos"
    sudo -n cat "$MAC_MANIFEST" > "$TEST_TMP/manifest-original"
    awk -v account="$AMY" -v uuid="$(uuidgen)" '
        $1 == account { $3=uuid; changed++ }
        { print }
        END { if (changed != 1) exit 1 }
    ' "$TEST_TMP/manifest-original" > "$TEST_TMP/manifest-mismatched"
    sudo -n cp "$TEST_TMP/manifest-mismatched" "$MAC_MANIFEST"
    equal "$(metadata "$MAC_MANIFEST")" '600:0:0' 'Mismatched manifest retains protected permissions'
    expect_failure sudo -n /bin/bash "$CLEANUP" --confirm
    equal "$(identities)" "$ORIGINAL_IDENTITIES" 'Manifest mismatch preserves real account identities'
    [ -d "$BASE" ] || fail 'Rejected cleanup removed the exercise directory.'
    sudo -n cp "$TEST_TMP/manifest-original" "$MAC_MANIFEST"
    sudo -n cmp "$TEST_TMP/manifest-original" "$MAC_MANIFEST"
    pass 'Mac cleanup rejects a manifest identity mismatch without deleting accounts'

    cd /
    sudo -n /bin/bash "$CLEANUP" --confirm
    absent_path "$BASE"
    absent_user "$AMY"
    absent_user "$BEN"
    absent_group
    equal "$(group_ids "$RUNNER_ACCOUNT")" "$RUNNER_GROUPS" 'Cleanup leaves operator groups unchanged'
    equal "$(cat "$TEST_TMP/link-target/sentinel.txt")" 'unrelated target' 'Cleanup preserves external data'
    pass 'Mac cleanup rejects unrelated resources and removes only its own exercise'
fi

pass "Completed on $SYSTEM using /bin/bash $BASH_VERSION"
