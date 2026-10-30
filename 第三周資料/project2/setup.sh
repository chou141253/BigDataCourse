#!/bin/bash
# 教師準備：只使用 Ubuntu 原有基本命令，不修改學生本人群組。
# 再次執行會把本練習的四個檔案與權限還原到起點。
# 固定教材日期：今天2026-10-16、明天2026-10-17；載入書目與既有預約。
set -eu
export PATH=/usr/sbin:/usr/bin:/sbin:/bin

# macOS 使用本機 Directory Services；Linux 保留原有教學環境。
case "$(uname -s)" in
    Darwin) exec /bin/bash "$(dirname "$0")/setup-macos.sh" "$@" ;;
    Linux) ;;
    *) echo '停止：本教材的初始化僅支援 Ubuntu／Debian Linux 與 macOS。' >&2; exit 1 ;;
esac

BASE=/srv/course-library
STAFF=library_staff
AMY=clerk_amy
BEN=clerk_ben
HERE=$(cd -- "$(dirname -- "$0")" && pwd)

stop() { echo "停止：$*" >&2; exit 1; }
[ "$(id -u)" -eq 0 ] || stop '請由具備 sudo 授權的教師執行：sudo bash project2/setup.sh'
[ "$#" -eq 0 ] || stop '本腳本不接受參數。'

for file in books.csv reservations.csv internal.txt handover.txt; do
    [ -f "$HERE/$file" ] || stop "教材缺少 $file"
done

# 不接手同名的陌生目錄，也不沿著符號連結改其他位置。
if [ -e "$BASE" ] || [ -L "$BASE" ]; then
    [ -d "$BASE" ] && [ ! -L "$BASE" ] || stop "$BASE 不是一般資料夾。"
    [ -f "$BASE/.course-library-exercise" ] || stop "$BASE 已存在，且不是本練習建立的資料夾。"
    [ "$(cat "$BASE/.course-library-exercise")" = course-library-exercise ] || stop '練習標記不符。'
    [ "$(stat -c %U "$BASE")" = root ] || stop '練習資料夾的擁有者不是 root。'
fi
for file in books.csv reservations.csv internal.txt handover.txt .course-library-exercise; do
    [ ! -L "$BASE/$file" ] || stop "$BASE/$file 是符號連結。"
done

getent group "$STAFF" >/dev/null || groupadd "$STAFF"
for account in "$AMY" "$BEN"; do
    if id "$account" >/dev/null 2>&1; then
        # 既有示範帳號可沿用，但先確認它已是館員群組成員。
        id -nG "$account" | tr ' ' '\n' | grep -qx "$STAFF" || stop "$account 已存在，但不是 $STAFF 的成員。"
    else
        useradd --create-home --gid "$STAFF" --shell /usr/sbin/nologin "$account"
    fi
done

mkdir -p "$BASE"
chown root:root "$BASE"
chmod 755 "$BASE"
for file in books.csv reservations.csv internal.txt handover.txt; do
    cp "$HERE/$file" "$BASE/$file"
done
chown root:"$STAFF" "$BASE/books.csv" "$BASE/reservations.csv"
chmod 640 "$BASE/books.csv" "$BASE/reservations.csv"
chown root:root "$BASE/internal.txt" "$BASE/handover.txt"
chmod 600 "$BASE/internal.txt"
chmod 640 "$BASE/handover.txt"
echo course-library-exercise > "$BASE/.course-library-exercise"
chown root:root "$BASE/.course-library-exercise"
chmod 600 "$BASE/.course-library-exercise"

echo "專案二已準備在 $BASE"
echo "示範帳號：$AMY、$BEN；共同群組：$STAFF"
echo '本人帳號與本人群組均未變更。'
echo '再次執行本腳本會還原四個練習檔案，請勿在作答途中重跑。'
