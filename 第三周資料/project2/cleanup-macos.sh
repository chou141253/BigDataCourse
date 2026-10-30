#!/bin/bash
# 清理僅限 manifest 身份吻合的本練習資源，沒有遞迴刪除。
set -euo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
HERE=$(cd -P "$(dirname "$0")" && pwd)
. "$HERE/macos-common.sh"
umask 077
mac_require
[ "$#" -eq 1 ] && [ "$1" = --confirm ] || stop '請先另存作業，再執行 sudo bash cleanup-macos.sh --confirm。'
mac_lock
trap mac_unlock EXIT
trap 'exit 130' INT
trap 'exit 129' HUP
trap 'exit 143' TERM

# 所有檔案、額外項目、UUID / UID / GID 和群組成員檢查皆先於第一次刪除。
mac_check_base
mac_load_manifest
mac_snapshot
mac_validate_identities yes

for account in "$AMY" "$BEN"; do
    if mac_has_name "$UID_ROWS" "$account"; then dscl "$NODE" -delete "/Users/$account"; fi
done
if mac_has_name "$GID_ROWS" "$STAFF"; then dscl "$NODE" -delete "/Groups/$STAFF"; fi
dscacheutil -flushcache
for file in $FILES; do rm -f "$BASE/$file"; done
rm "$MANIFEST"
rmdir "$BASE"
printf '%s\n' '已移除本練習的兩個館員帳號、館員群組與四個資料檔。本人帳號與群組均未變更。'
