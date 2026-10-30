#!/bin/bash
# 僅供 setup-macos.sh / cleanup-macos.sh 載入；相容 macOS 的 Bash 3.2。
# 此檔案是程式碼。磁碟上的 manifest 只讀取資料，絕不 source / eval。
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
BASE=/Users/Shared/course-library
MANIFEST=$BASE/.course-library-macos
LOCK=/private/var/run/course-library-project2.lock
NODE=/Local/Default
STAFF=library_staff
AMY=clerk_amy
BEN=clerk_ben
FILES='books.csv reservations.csv internal.txt handover.txt'
LOCKED=0
KEEP_LOCK=0

stop() { printf '停止：%s\n' "$*" >&2; exit 1; }

mac_require() {
    [ "$(uname -s)" = Darwin ] || stop '此腳本僅適用於 macOS。'
    [ "$(id -u)" -eq 0 ] || stop '請用有管理員授權的帳號執行 sudo bash setup.sh（清理請使用 cleanup-macos.sh --confirm）。'
    for cmd in dscl dseditgroup dscacheutil uuidgen stat awk grep sort tr sed ls cp mv rm mkdir rmdir chmod chown; do
        command -v "$cmd" >/dev/null 2>&1 || stop "環境缺少 $cmd。"
    done
    [ -x /usr/bin/false ] && [ -d /var/empty ] || stop '找不到 macOS 的非登入帳號基本環境。'
    [ -d /Users/Shared ] && [ ! -L /Users/Shared ] || stop '/Users/Shared 必須是一般目錄。'
    [ "$(stat -f %u /Users/Shared)" = 0 ] || stop '/Users/Shared 的擁有者不是 root。'
}

mac_lock() {
    # 父目錄由系統 root 管理；setup 和 cleanup 共用一把鎖。
    mkdir -m 700 "$LOCK" 2>/dev/null ||
        stop "已有初始化／清理工作，或上次被強制中止留下鎖：$LOCK。請先由教師確認沒有執行中的工作。"
    LOCKED=1
}

mac_unlock() {
    if [ "$KEEP_LOCK" = 1 ]; then
        printf '回復未完成，暫存資料與鎖保留在 %s，請教師檢查。\n' "$LOCK" >&2
        return 0
    fi
    if [ "$LOCKED" = 1 ]; then
        for part in new backup; do
            for file in $FILES; do rm -f "$LOCK/$part/$file"; done
            [ ! -d "$LOCK/$part" ] || rmdir "$LOCK/$part"
        done
        rmdir "$LOCK" || printf '請檢查殘留鎖目錄：%s\n' "$LOCK" >&2
    fi
}

# 輸出 Directory Services 的一個屬性，各值一行；本程式驗證的值均不含空白。
mac_values() {
    local output
    output=$(dscl "$NODE" -read "$1" "$2") || return 1
    printf '%s\n' "$output" | awk -v key="$2:" '
        NR == 1 { if ($1 != key) exit 1; first = 2 }
        NR > 1 { first = 1 }
        { for (i = first; i <= NF; i++) print $i }
    '
}

mac_value() {
    local value
    value=$(mac_values "$1" "$2") || return 1
    case "$value" in ''|*'
'*) return 1 ;; esac
    printf '%s\n' "$value"
}

mac_expect() {
    local value
    value=$(mac_value "$1" "$2" 2>/dev/null) || stop "$1 的 $2 缺少或格式不符；未變更該記錄。"
    [ "$value" = "$3" ] || stop "$1 的 $2 不符合本練習記錄；未變更該記錄。"
}

mac_snapshot() {
    # 同時查本機與完整驗證搜尋路徑；任何列舉失敗都停止，不把錯誤當成「沒有人使用」。
    local node rows
    UID_ROWS= GID_ROWS= PRIMARY_ROWS=
    for node in "$NODE" /Search; do
        rows=$(dscl "$node" -list /Users UniqueID) || stop "無法列舉 $node 的使用者 UID。"
        UID_ROWS="$UID_ROWS
$rows"
        rows=$(dscl "$node" -list /Groups PrimaryGroupID) || stop "無法列舉 $node 的群組 GID。"
        GID_ROWS="$GID_ROWS
$rows"
        rows=$(dscl "$node" -list /Users PrimaryGroupID) || stop "無法列舉 $node 的使用者主群組。"
        PRIMARY_ROWS="$PRIMARY_ROWS
$rows"
    done
}

mac_has_name() {
    printf '%s\n' "$1" | awk -v name="$2" '$1 == name { found = 1 } END { exit !found }'
}

mac_assert_unused_names() {
    local account result
    for account in "$AMY" "$BEN"; do
        if mac_has_name "$UID_ROWS" "$account" || id "$account" >/dev/null 2>&1; then
            stop "$account 已存在，卻沒有本練習的 manifest；不接手既有帳號。"
        fi
    done
    result=$(dscacheutil -q group -a name "$STAFF") || stop '無法查詢既有群組。'
    if mac_has_name "$GID_ROWS" "$STAFF" || [ -n "$result" ]; then
        stop "$STAFF 已存在，卻沒有本練習的 manifest；不接手既有群組。"
    fi
}

mac_choose_ids() {
    # 60000–60999 是本教材的有界搜尋範圍，並非 Apple 保留的 ID 區段。
    local used candidate selected result
    used=$(printf '%s\n' "$UID_ROWS" "$GID_ROWS" "$PRIMARY_ROWS" |
        awk '{ for (i=2; i<=NF; i++) if ($i ~ /^-?[0-9]+$/) print $i }' | sort -nu)
    selected=0
    candidate=60000
    while [ "$candidate" -le 60999 ] && [ "$selected" -lt 3 ]; do
        if ! printf '%s\n' "$used" | grep -qx "$candidate" && ! id "$candidate" >/dev/null 2>&1; then
            result=$(dscacheutil -q group -a gid "$candidate") || stop '無法查詢候選 GID。'
            if [ -z "$result" ]; then
                case "$selected" in
                    0) STAFF_GID=$candidate ;;
                    1) AMY_UID=$candidate ;;
                    2) BEN_UID=$candidate ;;
                esac
                selected=$((selected + 1))
            fi
        fi
        candidate=$((candidate + 1))
    done
    [ "$selected" -eq 3 ] || stop '60000–60999 沒有足夠未使用 ID；請由教師確認環境。'
    STAFF_UUID=$(uuidgen)
    AMY_UUID=$(uuidgen)
    BEN_UUID=$(uuidgen)
}

mac_regular_root_file() {
    [ -f "$1" ] && [ ! -L "$1" ] || stop "$1 不是一般檔案。"
    [ "$(stat -f %u "$1")" = 0 ] || stop "$1 的擁有者不是 root。"
    [ "$(stat -f %l "$1")" = 1 ] || stop "$1 有其他硬連結；停止處理。"
}

mac_check_base() {
    local path name mode
    [ -d "$BASE" ] && [ ! -L "$BASE" ] || stop "$BASE 不是一般資料夾。"
    [ "$(stat -f %u "$BASE")" = 0 ] || stop '練習目錄的擁有者不是 root。'
    mode=$(stat -f %Lp "$BASE")
    case "$mode" in 700|755) ;; *) stop '練習目錄須由 root 保持 700 或 755 權限。' ;; esac
    # manifest 不可透過 ACL 向其他帳號開放寫入。
    mac_regular_root_file "$MANIFEST"
    [ "$(stat -f %Lp "$MANIFEST")" = 600 ] || stop 'manifest 權限必須是 600。'
    # 有 xattr 時 ls 的 @ 會遮住 +，所以也檢查 -e 列出的編號 ACL 條目。
    ls -lde "$BASE" "$MANIFEST" | awk '$1 ~ /\+/ || $1 ~ /^[0-9]+:$/ { exit 1 }' || stop '練習目錄或 manifest 有額外 ACL，請教師先確認。'
    for path in "$BASE"/* "$BASE"/.[!.]* "$BASE"/..?*; do
        [ -e "$path" ] || [ -L "$path" ] || continue
        name=${path##*/}
        case "$name" in
            books.csv|reservations.csv|internal.txt|handover.txt|.course-library-macos)
                mac_regular_root_file "$path" ;;
            *) stop "練習目錄有額外項目 $name；請先移出保存，未變更任何練習資源。" ;;
        esac
    done
}

mac_load_manifest() {
    local header name extra idvalue uuid
    {
        IFS= read -r header || stop 'manifest 不完整。'
        [ "$header" = course-library-macos-v1 ] || stop 'manifest 版本不符。'
        read -r name STAFF_GID STAFF_UUID extra || stop 'manifest 缺少群組資料。'
        [ "$name" = "$STAFF" ] && [ -z "$extra" ] || stop 'manifest 群組格式錯誤。'
        read -r name AMY_UID AMY_UUID extra || stop 'manifest 缺少 Amy 資料。'
        [ "$name" = "$AMY" ] && [ -z "$extra" ] || stop 'manifest Amy 格式錯誤。'
        read -r name BEN_UID BEN_UUID extra || stop 'manifest 缺少 Ben 資料。'
        [ "$name" = "$BEN" ] && [ -z "$extra" ] || stop 'manifest Ben 格式錯誤。'
        if IFS= read -r extra || [ -n "$extra" ]; then stop 'manifest 有額外內容。'; fi
    } < "$MANIFEST"
    for idvalue in "$STAFF_GID" "$AMY_UID" "$BEN_UID"; do
        case "$idvalue" in 60[0-9][0-9][0-9]) ;; *) stop 'manifest ID 不在允許範圍。' ;; esac
    done
    [ "$STAFF_GID" != "$AMY_UID" ] && [ "$STAFF_GID" != "$BEN_UID" ] && [ "$AMY_UID" != "$BEN_UID" ] || stop 'manifest ID 重複。'
    for uuid in "$STAFF_UUID" "$AMY_UUID" "$BEN_UUID"; do
        printf '%s\n' "$uuid" | grep -Eq '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$' || stop 'manifest UUID 格式錯誤。'
    done
}

mac_write_manifest() {
    printf '%s\n' course-library-macos-v1 \
        "$STAFF $STAFF_GID $STAFF_UUID" "$AMY $AMY_UID $AMY_UUID" "$BEN $BEN_UID $BEN_UUID" > "$MANIFEST"
    chown root:wheel "$MANIFEST"
    chmod 600 "$MANIFEST"
}

mac_identity_collision_check() {
    printf '%s\n' "$UID_ROWS" | awk -v a="$AMY_UID" -v b="$BEN_UID" -v an="$AMY" -v bn="$BEN" '
        $NF == a && (NF != 2 || $1 != an) { exit 1 }
        $NF == b && (NF != 2 || $1 != bn) { exit 1 }
    ' || stop '示範 UID 也被其他帳號使用。'
    printf '%s\n' "$GID_ROWS" | awk -v id="$STAFF_GID" -v name="$STAFF" '
        $NF == id && (NF != 2 || $1 != name) { exit 1 }
    ' || stop '館員 GID 也被其他群組使用。'
    printf '%s\n' "$PRIMARY_ROWS" | awk -v id="$STAFF_GID" -v a="$AMY" -v b="$BEN" '
        $NF == id && (NF != 2 || ($1 != a && $1 != b)) { exit 1 }
    ' || stop '其他帳號使用館員群組作為主群組。'
}

mac_validate_identities() {
    # cleanup 可重試先前已刪除部分資源的狀態；所有仍存在的身份都須完全吻合。
    local allow_missing account uid uuid record values value
    allow_missing=$1
    mac_identity_collision_check
    for account in "$AMY" "$BEN"; do
        case "$account" in "$AMY") uid=$AMY_UID; uuid=$AMY_UUID ;; *) uid=$BEN_UID; uuid=$BEN_UUID ;; esac
        if ! mac_has_name "$UID_ROWS" "$account"; then
            [ "$allow_missing" = yes ] || stop "$account 已遺失；請由教師檢查。"
            continue
        fi
        record=/Users/$account
        mac_expect "$record" RecordName "$account"
        mac_expect "$record" Comment "BigDataCourse-project2-macos-$uuid"
        mac_expect "$record" UniqueID "$uid"
        mac_expect "$record" GeneratedUID "$uuid"
        mac_expect "$record" PrimaryGroupID "$STAFF_GID"
        mac_expect "$record" UserShell /usr/bin/false
        mac_expect "$record" NFSHomeDirectory /var/empty
        mac_expect "$record" AuthenticationAuthority ';DisabledUser;'
        mac_expect "$record" Password '*'
        mac_expect "$record" IsHidden 1
        id -Gn "$account" | tr ' ' '\n' | grep -qx admin && stop "$account 意外具有管理員權限。"
    done
    if ! mac_has_name "$GID_ROWS" "$STAFF"; then
        [ "$allow_missing" = yes ] || stop '館員群組已遺失。'
        return 0
    fi
    record=/Groups/$STAFF
    mac_expect "$record" RecordName "$STAFF"
    mac_expect "$record" Comment "BigDataCourse-project2-macos-$STAFF_UUID"
    mac_expect "$record" PrimaryGroupID "$STAFF_GID"
    mac_expect "$record" GeneratedUID "$STAFF_UUID"
    values=$(mac_values "$record" GroupMembership 2>/dev/null) || values=
    for value in $values; do
        case "$value" in "$AMY"|"$BEN") ;; *) stop '館員群組有其他使用者；不變更該群組。' ;; esac
    done
    values=$(mac_values "$record" GroupMembers 2>/dev/null) || values=
    for value in $values; do
        case "$value" in "$AMY_UUID"|"$BEN_UUID") ;; *) stop '館員群組有其他使用者 UUID；不變更該群組。' ;; esac
    done
    values=$(mac_values "$record" NestedGroups 2>/dev/null) || values=
    [ -z "$values" ] || stop '館員群組有巢狀群組；不變更該群組。'
}
