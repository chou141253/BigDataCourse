#!/bin/bash
# macOS 原生版本：真正的非登入示範帳號與 Unix 權限，無須 VM 或 Homebrew。
set -euo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
HERE=$(cd -P "$(dirname "$0")" && pwd)
. "$HERE/macos-common.sh"
umask 077
mac_require
[ "$#" -eq 0 ] || stop '本腳本不接受參數；請執行 sudo bash setup.sh。'
for file in $FILES; do
    [ -f "$HERE/$file" ] && [ ! -L "$HERE/$file" ] || stop "教材缺少一般檔案 ${file}。"
done

FRESH=0 BASE_CREATED=0 NEW_STAFF=0 NEW_AMY=0 NEW_BEN=0 DONE=0
REPLACED=

# 只回復本次建立、且仍有本次唯一標記的記錄。半完成記錄可以尚無 ID / UUID。
rollback_record() {
    local record uuid key expected actual names
    record=$1 uuid=$2
    if ! actual=$(mac_value "$record" Comment 2>/dev/null); then
        # 建立命令可能在真正建立前就失敗；必須成功列舉，才能把不存在視為已回復。
        names=$(dscl "$NODE" -list "${record%/*}") || return 1
        if printf '%s\n' "$names" | grep -Fxq "${record##*/}"; then return 1; fi
        return 0
    fi
    [ "$actual" = "BigDataCourse-project2-macos-$uuid" ] || return 1
    for key in GeneratedUID "$3"; do
        case "$key" in GeneratedUID) expected=$uuid ;; *) expected=$4 ;; esac
        actual=$(mac_value "$record" "$key" 2>/dev/null) || actual=
        [ -z "$actual" ] || [ "$actual" = "$expected" ] || return 1
    done
    dscl "$NODE" -delete "$record"
}

finish() {
    local status=$?
    local file ok
    trap - EXIT HUP INT TERM
    set +e
    if [ "$DONE" != 1 ]; then
        # 舊版 Bash 的展開錯誤可能讓 EXIT trap 看見 0；未完成初始化不能回報成功。
        [ "$status" -ne 0 ] || status=1
        ok=1
        for file in $REPLACED; do
            if [ -f "$LOCK/backup/$file" ]; then
                mv -f "$LOCK/backup/$file" "$BASE/$file" || ok=0
            else
                rm -f "$BASE/$file" || ok=0
            fi
        done
        [ "$NEW_BEN" = 0 ] || rollback_record "/Users/$BEN" "$BEN_UUID" UniqueID "$BEN_UID" || ok=0
        [ "$NEW_AMY" = 0 ] || rollback_record "/Users/$AMY" "$AMY_UUID" UniqueID "$AMY_UID" || ok=0
        if [ "$NEW_STAFF" = 1 ] && [ "$ok" = 1 ]; then
            rollback_record "/Groups/$STAFF" "$STAFF_UUID" PrimaryGroupID "$STAFF_GID" || ok=0
        fi
        if [ "$BASE_CREATED" = 1 ] && [ "$ok" = 1 ]; then
            rm -f "$MANIFEST"
            rmdir "$BASE" || ok=0
        fi
        if [ "$NEW_STAFF" = 1 ] || [ "$NEW_AMY" = 1 ] || [ "$NEW_BEN" = 1 ]; then
            dscacheutil -flushcache || ok=0
        fi
        if [ "$ok" != 1 ]; then
            KEEP_LOCK=1
            printf '初始化未完成，部分回復失敗；請教師檢查 %s 及暫存備份後再處理。\n' "$BASE" >&2
        fi
    fi
    mac_unlock
    exit "$status"
}

mac_lock
trap finish EXIT
trap 'exit 130' INT
trap 'exit 129' HUP
trap 'exit 143' TERM

# 在建立帳號或練習目錄前，先完成檔案、同名資源及全部可查身份的檢查。
mac_snapshot
if [ -e "$BASE" ] || [ -L "$BASE" ]; then
    mac_check_base
    mac_load_manifest
    mac_validate_identities no
else
    mac_assert_unused_names
    mac_choose_ids
    FRESH=1
fi

mkdir "$LOCK/new" "$LOCK/backup"
for file in $FILES; do
    cp "$HERE/$file" "$LOCK/new/$file"
    chmod -N "$LOCK/new/$file"
    case "$file" in
        books.csv|reservations.csv) chown "0:$STAFF_GID" "$LOCK/new/$file"; chmod 640 "$LOCK/new/$file" ;;
        internal.txt) chown root:wheel "$LOCK/new/$file"; chmod 600 "$LOCK/new/$file" ;;
        handover.txt) chown root:wheel "$LOCK/new/$file"; chmod 640 "$LOCK/new/$file" ;;
    esac
    if [ "$FRESH" = 0 ] && [ -f "$BASE/$file" ]; then cp -p "$BASE/$file" "$LOCK/backup/$file"; fi
done

create_user() {
    local account uid uuid
    account=$1 uid=$2 uuid=$3
    # 先寫唯一標記、拒絕登入屬性，最後才給 UID。
    dscl "$NODE" -create "/Users/$account" Comment "BigDataCourse-project2-macos-$uuid"
    dscl "$NODE" -create "/Users/$account" AuthenticationAuthority ';DisabledUser;'
    dscl "$NODE" -create "/Users/$account" Password '*'
    dscl "$NODE" -create "/Users/$account" UserShell /usr/bin/false
    dscl "$NODE" -create "/Users/$account" NFSHomeDirectory /var/empty
    dscl "$NODE" -create "/Users/$account" IsHidden 1
    dscl "$NODE" -create "/Users/$account" GeneratedUID "$uuid"
    dscl "$NODE" -create "/Users/$account" PrimaryGroupID "$STAFF_GID"
    dscl "$NODE" -create "/Users/$account" UniqueID "$uid"
    dscl "$NODE" -create "/Users/$account" RealName "BigDataCourse project2 $account"
    # 清除初始化前的「查無帳號」快取，讓群組工具可立即找到新記錄。
    dscacheutil -flushcache
    dseditgroup -o edit -n "$NODE" -a "$account" -t user "$STAFF"
}

if [ "$FRESH" = 1 ]; then
    mkdir -m 700 "$BASE"
    BASE_CREATED=1
    chmod -N "$BASE"
    chown root:wheel "$BASE"
    mac_write_manifest
    NEW_STAFF=1
    dscl "$NODE" -create "/Groups/$STAFF" Comment "BigDataCourse-project2-macos-$STAFF_UUID"
    dscl "$NODE" -create "/Groups/$STAFF" GeneratedUID "$STAFF_UUID"
    dscl "$NODE" -create "/Groups/$STAFF" PrimaryGroupID "$STAFF_GID"
    dscl "$NODE" -create "/Groups/$STAFF" Password '*'
    dscl "$NODE" -create "/Groups/$STAFF" RealName 'BigDataCourse project2 library staff'
    NEW_AMY=1
    create_user "$AMY" "$AMY_UID" "$AMY_UUID"
    NEW_BEN=1
    create_user "$BEN" "$BEN_UID" "$BEN_UUID"
fi

# 查驗解析結果，而非僅相信建立指令的退出碼。
dscacheutil -flushcache
mac_snapshot
mac_validate_identities no
[ "$(id -u "$AMY")" = "$AMY_UID" ] && [ "$(id -u "$BEN")" = "$BEN_UID" ] || stop '示範帳號解析結果不符。'
[ "$(id -g "$AMY")" = "$STAFF_GID" ] && [ "$(id -g "$BEN")" = "$STAFF_GID" ] || stop '館員主群組解析結果不符。'
for file in $FILES; do
    REPLACED="$REPLACED $file"
    mv -f "$LOCK/new/$file" "$BASE/$file"
done
chmod 755 "$BASE"
DONE=1
printf '專案二已準備在 %s\n' "$BASE"
printf '示範帳號：%s、%s；共同群組：%s\n' "$AMY" "$BEN" "$STAFF"
printf '%s\n' '這是真正的 macOS 本機非登入帳號；未修改本人帳號、本人群組或 sudoers。' \
    '再次執行會還原四個練習檔案與權限，作答途中請勿重跑。' \
    '完成作業並另存結果後，回到教材的 project2 目錄，再執行 sudo bash cleanup-macos.sh --confirm。'
