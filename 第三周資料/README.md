# 第三週 Linux 指令與專案練習

先用小檔案學習指令，再完成前後相連的專案問題。學生版簡報提供資料說明、情境與題目；提示與逐步解答放在另一份簡報。

## 環境與工具

### Ubuntu／Debian

Linux 課堂練習使用課程指定、可還原的 Ubuntu／Debian VM。以本人已獲 sudo 授權的帳號操作 Terminal。以下安裝指令只在 Ubuntu／Debian 執行：

```bash
sudo apt update
sudo apt install git nano
```

其他練習使用課程 Linux VM 原有的基本命令，包含 sed 與 awk。

### macOS 原生 Terminal：專案二

專案二也可在 Mac 自己的 Terminal 完成。使用本儲存庫新版 `project2/setup.sh`，由具備管理員權限且可使用 `sudo` 的帳號準備環境；作答時仍使用本人原本的 Terminal。

請先閱讀 [macOS 專案二準備指南](project2/MACOS.md)。可透過 GitHub 的 Code → Download ZIP 取得完整教材，不需要為專案二安裝 Git、Homebrew、Xcode 或 Ubuntu。macOS 不執行上面的 `apt` 指令。互動式 Terminal 使用 zsh 也可以，初始化腳本仍明確用 `sudo bash` 執行。

## 取得本週教材

先依教師提供的 GitHub 網址取得整份課程儲存庫。本週教材位於儲存庫中的「第三周資料」資料夾。

課堂簡報使用 `$HOME/example_data`。請將「第三周資料」複製到自己的家目錄，並將副本命名為 `example_data`。已有這份工作副本時，先確認內容並沿用，避免再次複製成巢狀目錄或蓋掉作答內容。

若已能使用 Git，可先取得整份儲存庫：

```bash
cd "$HOME"
git clone https://github.com/chou141253/BigDataCourse.git
cd "$HOME/BigDataCourse"
```

也可下載 ZIP 並解壓縮。Mac 下載到預設位置時，儲存庫根目錄通常是 `$HOME/Downloads/BigDataCourse-main`。先進入實際的儲存庫根目錄，再於 **`example_data` 尚不存在時** 建立課堂工作副本：

```bash
if [ -e "$HOME/example_data" ] || [ -L "$HOME/example_data" ]; then
    printf '%s\n' 'example_data 已存在；請確認內容並沿用，不要再次複製。'
else
    cp -R "第三周資料" "$HOME/example_data"
fi
```

複製後應有下列結構；如果看到 `example_data/第三周資料/project1`，表示多了一層，請先依自己的實際位置調整。只做專案二的 Mac 同學也可依準備指南直接使用下載資料夾，不必另做副本。

```text
example_data/
├── practice/          指令小練習
├── projects/          專案情境與題目
├── project1/          每日備份、借閱紀錄與預約檔
└── project2/          館員共用資料與環境準備腳本
```

## 學習順序

1. 完成 [Terminal 基礎練習](practice/terminal_basics.md)。
2. 閱讀 [專案一](projects/project1.md)，在同一份資料依序完成四個 Question。
3. 完成 [權限與群組練習](practice/permissions.md)。
4. 完成 [sed 與 awk 文字處理練習](practice/text_tools.md)：先看指令形式，再建立同一份 `fruit.csv`，依序練習選行、取代、另存、選欄、條件與統計；對應簡報中的 20 頁教學。
5. 閱讀 [專案二](projects/project2.md)，依序完成各題，沿用專案二上一題留下的預約與權限，接著完成交接檔修正及預約統計。

兩個專案都以 Markdown 檔案繳交，細節於課堂說明。

專案一與專案二使用各自的起始資料，預約 CSV 的欄位順序也不同。不要把專案一的預約檔複製到專案二；專案二的各題則必須接續同一份共用資料操作。

## 課前準備（授課者或已獲授權的學生）

專案一已放好七份舊備份、新收到的 `261015.csv` 與 `daily.sh`。學生在 `project1/` 執行腳本，接著完成統計與預約。題目日期固定為 2026-10-15，明天是 2026-10-16。

在開始專案二的指令練習前，由授課者或本人電腦上具管理員權限、已獲授權的學生執行一次。使用 `example_data` 工作副本時：

```bash
cd "$HOME/example_data/project2"
sudo bash setup.sh
```

若直接在儲存庫的「第三周資料」內操作，則執行 `sudo bash project2/setup.sh`。兩種寫法只差在目前目錄，選一種執行即可。

腳本會辨認平台，建立 `clerk_amy`、`clerk_ben`、`library_staff` 群組與四份共用練習檔：

| 平台 | 共用練習資料位置 |
|---|---|
| Ubuntu／Debian | `/srv/course-library` |
| macOS | `/Users/Shared/course-library` |

學生仍使用本人的 Terminal，以 `sudo -u 帳號 命令` 測試館員操作。腳本不修改學生本人的群組，也不替館員設定可用的登入密碼；不需要另外登入館員帳號。

初始化後先確認帳號存在，再依 [專案二的操作身分與位置](projects/project2.md#操作身分與位置) 進入共用資料夾：

```bash
id clerk_amy
id clerk_ben
sudo -u clerk_amy whoami
sudo -u clerk_ben whoami
```

重新執行 `setup.sh` 會把四份檔案與權限恢復為題目起點，因此開始作答後沿用現有進度。新開 Terminal 只需重新設定路徑，不要為此重跑初始化。Linux 重做整個課程時可還原課前 VM；Mac 的移除方式見 [macOS 指南的清理章節](project2/MACOS.md#移除-mac-練習環境)。

## 查看 Markdown

先在自己的練習環境用 nano 編輯 `.md`，將作業保存在本人的家目錄。要看排版效果，可在自己可編輯的 GitHub 儲存庫選 Add file、Create new file，填入 `.md` 檔名，貼上完整內容，再點 Preview。

## 從 Windows 查看 WSL 檔案（選用）

在 Windows 檔案總管位址列輸入 `\\wsl$`，選與 Terminal 相同的發行版本，再進入 `home` 與自己的帳號。課堂命令仍在 Linux Terminal 輸入。

Terminal 行首的 `$` 是提示符，不必輸入。新開 Terminal 後，自訂變數需重新設定；檔案仍留在原目錄。
