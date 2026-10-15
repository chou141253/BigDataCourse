# 第三週 Linux 指令與專案練習

先用小檔案學習指令，再完成前後相連的專案問題。學生版簡報提供資料說明、情境與題目；提示與逐步解答放在另一份簡報。

## 環境與工具

使用課程指定、可還原的 Ubuntu／Debian VM。以本人已獲 sudo 授權的帳號操作 Bash Terminal。

```bash
sudo apt update
sudo apt install git nano
```

其他練習使用課程 Linux VM 原有的基本命令，包含 sed 與 awk。

## 取得本週教材

先依教師提供的 GitHub 網址取得整份課程儲存庫。本週教材位於儲存庫中的「第三周資料」資料夾。

課堂簡報與下列指令使用 `$HOME/example_data`。請將「第三周資料」複製到 Linux 家目錄，並將副本命名為 `example_data`。已有這份工作副本時，沿用原資料夾即可。

```text
example_data/
├── practice/          指令小練習
├── projects/          專案情境與題目
├── project1/          每日備份、借閱紀錄與預約檔
└── project2/          館員共用資料與教師準備腳本
```

## 學習順序

1. 完成 [Terminal 基礎練習](practice/terminal_basics.md)。
2. 閱讀 [專案一](projects/project1.md)，在同一份資料依序完成四個 Question。
3. 完成 [權限與群組練習](practice/permissions.md)。
4. 完成 [sed 與 awk 文字處理練習](practice/text_tools.md)：先看指令形式，再建立同一份 `fruit.csv`，依序練習選行、取代、另存、選欄、條件與統計；對應簡報中的 20 頁教學。
5. 閱讀 [專案二](projects/project2.md)，沿用上一題留下的預約與權限，接著完成交接檔修正及預約統計。

兩個專案都以 Markdown 檔案繳交，細節於課堂說明。

## 課前準備（授課者）

專案一已放好七份舊備份、新收到的 `261015.csv` 與 `daily.sh`。學生在 `project1/` 執行腳本，接著完成統計與預約。題目日期固定為 2026-10-15，明天是 2026-10-16。

在開始專案二的指令練習前，由授課者以具 sudo 授權的帳號執行一次：

```bash
cd "$HOME/example_data/project2"
sudo bash setup.sh
```

這會準備 `clerk_amy`、`clerk_ben`、`library_staff` 群組與 `/srv/course-library/` 的四份練習檔。學生仍使用本人的 Terminal，以 `sudo -u 帳號 命令` 測試館員的操作。

重新執行 setup.sh 會把這四份檔案恢復為題目起點，因此開始作答後沿用現有進度。重做整個課程時，請還原課前 VM，再準備教材。

## 查看 Markdown

先在 Linux 用 nano 編輯 `.md`。要看排版效果，可在自己可編輯的 GitHub 儲存庫選 Add file、Create new file，填入 `.md` 檔名，貼上完整內容，再點 Preview。

## 從 Windows 查看 WSL 檔案（選用）

在 Windows 檔案總管位址列輸入 `\\wsl$`，選與 Terminal 相同的發行版本，再進入 `home` 與自己的帳號。課堂命令仍在 Linux Terminal 輸入。

Terminal 行首的 `$` 是提示符，不必輸入。新開 Terminal 後，自訂變數需重新設定；檔案仍留在原目錄。
