# 巨量資料分析課程參考資料

本儲存庫是本次巨量資料分析課程的參考資料，包含課堂使用的練習資料、指令講義與範例腳本，供同學上課操作與課後複習。

## 資料夾說明

- [第三周資料](第三周資料/README.md)：Linux 基本指令、檔案權限與群組、sed 與 awk 練習，以及兩個專案的資料與題目。

## 使用方式

依課堂提供的 GitHub 網址取得本儲存庫，再閱讀各週資料夾內的 README，按照課堂簡報進行練習。

| 操作環境 | 開始方式 |
|---|---|
| 課程指定的 Ubuntu／Debian | 依 [第三周資料 README](第三周資料/README.md) 準備教材與工具。 |
| Mac 原生 Terminal：專案二 | 依 [macOS 專案二準備指南](第三周資料/project2/MACOS.md) 執行新版 `setup.sh`，完成後閱讀原本的六道題目。 |

專案二支援在 macOS 原生 Terminal 執行，不需要安裝 Ubuntu、Homebrew 或 Xcode。可直接下載整份儲存庫 ZIP，解壓縮後使用；已有 Git 的同學也可 clone。原有 Ubuntu／Debian 的操作方式仍然適用，`apt` 安裝步驟只用於該 Linux 環境。

第三週的課堂簡報使用 `$HOME/example_data` 作為教材位置。這個目錄應對應本儲存庫裡的 **`第三周資料` 資料夾**，不是儲存庫根目錄。依 [取得本週教材](第三周資料/README.md#取得本週教材) 準備工作副本；已有工作副本時，確認內容後沿用。

專案二的四個工作檔案由初始化腳本另行建立在共用位置：macOS 為 `/Users/Shared/course-library`，Linux 為 `/srv/course-library`。下載的 `project2/` 是起始教材，作答時請使用共用位置。重新執行初始化會重設進度，作答途中不要重跑。
