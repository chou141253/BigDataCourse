# 在 Mac 原生 Terminal 準備專案二

本指南協助你在自己的 Mac 建立專案二所需的帳號與共用資料。使用新版教材與 macOS 內建工具即可，不需要安裝 Ubuntu、Homebrew 或 Xcode。初始化完成後，回到 [專案二題目](../projects/project2.md) 依序作答；本頁不提供六題的解答。

請使用本人具備管理員權限、可執行 `sudo` 的 Mac 帳號。如果電腦由學校或公司管理，且本人沒有授權，請由管理員或教師協助準備。

## 1. 取得完整教材並確認位置

### 下載 ZIP：不需要 Git

1. 開啟 [課程儲存庫](https://github.com/chou141253/BigDataCourse)。
2. 選 Code → Download ZIP，完成下載後解壓縮。
3. 保留整份教材，尤其是 `project2/` 裡的腳本與四個起始檔案。不要只下載或複製 `setup.sh`。

若解壓縮後位於預設的 Downloads，開啟 Terminal，輸入：

```bash
cd "$HOME/Downloads/BigDataCourse-main/第三周資料"
pwd
ls -l project2/setup.sh project2/cleanup-macos.sh
```

此時應能列出兩個腳本。若資料夾被重新命名，或系統為重複下載的資料夾加上編號，請先在 Finder 或用 `ls "$HOME/Downloads"` 確認實際名稱，再修改 `cd` 的路徑。

如果已有舊版教材，請保留原本作答，另外取得包含本指南的新版教材。舊版僅供 Linux 使用的 `setup.sh` 不能直接拿來初始化 Mac。

### 已能使用 Git 的同學：另一種取得方式

```bash
cd "$HOME"
git clone https://github.com/chou141253/BigDataCourse.git
cd "$HOME/BigDataCourse/第三周資料"
```

ZIP 與 Git 選一種即可。已有這份儲存庫時先確認位置，不必再次 clone。若 Mac 執行 Git 時要求安裝開發工具，可改用前面的 ZIP 方式。

課堂簡報中的 `$HOME/example_data` 對應的是「第三周資料」這一層。依本指南做專案二，可以直接使用目前的下載位置，不必改名或另做副本。

## 2. 初始化一次

先確認這個 Terminal 正在操作 Mac：

```bash
uname -s
```

原生 macOS 會顯示 `Darwin`。接著在「第三周資料」目錄執行：

```bash
sudo bash project2/setup.sh
```

若目前已經進入 `project2/`，則改用下面這行；兩種寫法只選一種：

```bash
sudo bash setup.sh
```

`sudo` 需要驗證時，輸入目前本人帳號的 Mac 登入密碼。輸入密碼時畫面不顯示字元或星號是正常現象。若看到 `Sorry, try again.`，代表該次驗證沒有通過，尚不能用它判斷腳本是否成功。

腳本會自動辨認 macOS，使用系統的帳號管理工具準備以下項目：

| 項目 | 用途 |
|---|---|
| `clerk_amy`、`clerk_ben` | 讓指定的單一指令以兩位館員的身分執行。 |
| `library_staff` | 兩位館員共用的群組。 |
| `/Users/Shared/course-library` | 專案二四份工作檔案與權限所在的位置。 |

館員是隱藏帳號，家目錄設為 `/var/empty`，登入 shell 為 `/usr/bin/false`，沒有可用的登入密碼。你不需要登入館員帳號；後續透過 `sudo -u` 執行題目指定的操作即可。初始化不會把本人加入 `library_staff`，也不會更改本人的群組。

**重新執行初始化會把四份工作檔案及權限還原為題目起點。開始作答後不要重跑。** 若腳本尚未完成，先查看最前面的錯誤訊息、修正原因，再繼續；若遇到同名帳號、群組或不屬於本練習的資料夾，請保留訊息並請教師協助。

## 3. 確認環境準備成功

初始化結束後，在同一個 Terminal 執行：

```bash
id clerk_amy
id clerk_ben
sudo -u clerk_amy whoami
sudo -u clerk_ben whoami
```

兩個 `id` 都應能查到帳號及 `library_staff` 群組；數字 UID、GID 依電腦而異，不必與別人相同。兩個 `whoami` 應分別顯示 `clerk_amy`、`clerk_ben`。

再設定本次 Terminal 的資料位置：

```bash
LIBRARY=/Users/Shared/course-library
cd "$LIBRARY"
pwd
ls -ld .
ls -l
```

確認 `pwd` 是 `/Users/Shared/course-library`，並能列出 `books.csv`、`reservations.csv`、`internal.txt`、`handover.txt`。macOS 的管理員檔案群組使用 `wheel`；不要因為它與 Linux 範例中的 `root` 不同，就自行更改群組。

**PPT 或舊版解答中的 `/srv/course-library`，在 Mac 請替換成 `/Users/Shared/course-library`，也可用 `"$LIBRARY"` 表示這個目錄、用 `"$LIBRARY/檔名"` 表示其中的檔案。** 不需要在 Mac 建立 `/srv`。

下載的 `project2/` 只提供初始化來源。**作答使用這裡的共用檔案。** 修改下載資料夾的同名檔案，不會同步修改這裡的內容。

## 4. 開始作答：位置、角色與指令格式

閱讀 [專案二的六道題目](../projects/project2.md)，依順序操作，後一題沿用前一題留下的共用檔案。教材的今天、明天是題目指定日期，無須調整電腦的日期。

### 同一個 Terminal，分清楚執行者

```bash
whoami
sudo -u clerk_amy whoami
whoami
```

這會依序顯示本人、Amy、本人。`sudo -u` 只改變後面那個指令的執行身分，下一行仍由本人輸入。題目要求 Amy 或 Ben 操作時，使用對應的 `sudo -u`；管理員只在題目需要修正權限或更新檔案時執行管理步驟。請勿用整個 root Terminal 代替館員操作，否則觀察不到題目要你分析的權限限制。

`Amy=clerk_amy` 只是在 shell 設定字串變數，不會建立系統帳號。`staff` 與 `library_staff` 也是兩個不同的群組名稱。

### 指令、選項與檔名之間要留空白

列出檔案資訊的寫法是 `ls -l`，不是 `ls-l`。awk 的一般形式是：

```text
awk -F, '條件 {動作}' 檔案.csv
```

單引號結束後，到檔名之前仍要有空白。例如，只查看預約檔表頭、確認欄位順序：

```bash
sudo -u clerk_amy awk -F, 'NR == 1 {print}' "$LIBRARY/reservations.csv"
```

這個檔案的欄位是 `date,book_id,reader`。專案一與專案二的欄位順序不同，作答前請先確認本題資料。

### 觀察權限限制並保留作答紀錄

初始化故意讓部分館員操作受權限限制。遇到 `Permission denied` 時，先依題目查執行身分、檔案群組與讀寫權限，再決定題目要求的處理方式。不要把所有操作改成管理員身分，也不要一次放寬整個資料夾的權限。

相對地，`no such user`、`unknown user` 代表指定帳號尚未建立或無法查到，必須先回頭檢查初始化，才能進行權限題目。

在 nano 編輯時，使用 **Control** 鍵：`Ctrl+O`、Enter 儲存，`Ctrl+X` 離開；不是 Command 鍵。畫面裡能輸入文字，不代表檔案一定能儲存。請觀察儲存結果，離開編輯器後再讀回確認。

依 nano 版本或設定，可能看到無法建立 lock file（鎖檔）的提示。鎖檔是編輯器在目錄裡建立的輔助檔，與既有檔案內容的寫入權是不同問題。若編輯器仍能開啟，請以實際儲存與讀回結果判斷，不要只為消除鎖檔提示就修改共用目錄權限。

題目需要另存文字處理結果時，輸入檔和輸出檔應使用不同名稱。`>` 由目前本人的 shell 處理，`sudo -u` 只指定前面程式的執行者；請分清楚由誰讀來源檔、由誰寫出結果，並將個人作業保存在本人的家目錄。

## 5. 常見問題

| 訊息或現象 | 先檢查什麼 |
|---|---|
| `sh: project2/setup.sh: No such file or directory` | `pwd` 與 `ls` 是否顯示正在「第三周資料」這一層；若已在 `project2/`，使用 `sudo bash setup.sh`。 |
| `getent: command not found` 或 `groupadd: command not found` | 是否仍在使用舊版 Linux 專用腳本。重新取得完整新版教材，不要在 Mac 上補裝這些 Linux 帳號管理指令。 |
| 腳本要求管理員或 sudo 授權 | 確認使用本人的管理員帳號，並以 `sudo bash` 執行初始化。 |
| `id: clerk_amy: no such user` 或 `sudo: unknown user clerk_amy` | 初始化是否中途停止；先查看前面的第一個錯誤，不要用設定 shell 變數代替建立帳號。 |
| awk 顯示語法錯誤 | 檢查半形單引號、雙引號、條件內容，以及規則結束後與檔名之間的空白。 |
| awk 查詢沒有輸出 | 先確認沒有其他錯誤訊息、路徑與欄位正確，再判斷是否真的沒有符合的紀錄。 |
| 編輯過檔案，但下一題查不到改動 | 是否改到下載的模板、是否實際儲存成功，或是否又重跑了初始化。 |

若需要請教師協助，提供 `uname -s`、`pwd`、執行的完整指令與從第一個錯誤開始的訊息。請將實際觀察與解釋記錄在作業 Markdown 中；提示與解答仍參考教師另提供的簡報。

## 6. 新開 Terminal 或重新開始

關閉 Terminal 不會刪掉帳號與檔案。重新開啟後，只需再次設定變數並回到共用資料夾：

```bash
LIBRARY=/Users/Shared/course-library
cd "$LIBRARY"
```

只有確定要把整個專案二回到起點時，才回到教材來源重新執行 `setup.sh`。它會覆寫已登記的預約、交接文字與權限變更；先保留需要的作業紀錄。

## 移除 Mac 練習環境

作業完成且需要的紀錄已存到本人家目錄或繳交位置後，可以移除這次練習建立的項目。以 ZIP 的預設位置為例：

```bash
cd "$HOME/Downloads/BigDataCourse-main/第三周資料"
sudo bash project2/cleanup-macos.sh --confirm
```

若使用 Git 或 `example_data` 副本，先進入自己的實際教材位置再執行。同樣地，若已在 `project2/` 目錄，指令是 `sudo bash cleanup-macos.sh --confirm`。

清理會移除本練習所建立的館員帳號、群組與共用練習資料，不刪除下載的教材或本人家目錄。若共用資料夾有額外檔案，或無法確認項目屬於本練習，腳本會停止；先將需要保留的檔案移到本人可管理的位置，閱讀錯誤訊息再處理，不要直接刪除不明帳號或資料夾。
