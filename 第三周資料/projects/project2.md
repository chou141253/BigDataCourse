# 專案二｜館員共用預約紀錄

今天是 **2026-10-16**，明天是 **2026-10-17**。這是教材固定日期，與實際上課日期無關。Amy 與 Ben 兩位館員輪流處理讀者預約，你負責維護共用檔案，協助館員查書、登記預約，並在接班前確認交接說明與明天要準備的書籍數。

## 資料夾與檔案

教材 `project2/` 提供四個起始檔案，以及教師使用的 `setup.sh`。教師已將四個檔案放到 Linux 的共用資料夾：

```text
/srv/course-library/
├── books.csv
├── reservations.csv
├── internal.txt
└── handover.txt
```

| 檔案 | 內容與用途 |
|---|---|
| `books.csv` | 五本書的書號、書名、是否接受預約。`yes` 可預約，`no` 不可預約。 |
| `reservations.csv` | 今天與明天已有的預約，每行是一筆日期、書號、讀者。 |
| `internal.txt` | 管理員的內部備註。 |
| `handover.txt` | 明天的館員班表與交接說明。 |

`books.csv` 的第一行是 `book_id,title,reservable`，依序代表書號、書名、是否接受預約。例如 `B001,Linux入門,yes` 是《Linux入門》接受預約。

`reservations.csv` 的第一行是 `date,book_id,reader`，依序代表預約日期、書號、讀者。例如 `2026-10-16,B001,小安` 是小安今天預約 B001。第一行的欄位名稱不算預約。

同一本書同一天只接受一筆預約。辦理前先查書目是否接受預約，再查同一日期、同一本書是否已有預約。

## 操作身分

全程在你原本具備 sudo 授權的 Terminal 輸入指令，不需要另開館員 Terminal。教師已準備 `clerk_amy`、`clerk_ben` 兩個示範帳號；兩人都屬於 `library_staff` 群組。

`sudo -u clerk_amy 指令` 表示只有後面這個指令由 Amy 執行。指令結束後，仍由你原本的帳號輸入下一行，Ben 的寫法相同。

開始前先確認本人身分與資料位置：

```bash
whoami
cd /srv/course-library
pwd
ls
```

## Question 1｜Amy 可以讀哪些檔案？

Amy 開始處理預約前，想先看書目與管理員備註。請查 Amy 的帳號與群組，列出共用資料夾及四個檔案的權限，再讓她分別讀取 books.csv、internal.txt，說明讀取結果。接著請她用 awk 查出 B001 的書名，以及這本書是否接受預約。

## Question 2｜替小明預約明天的書

小明想在明天（2026-10-17）借《Linux入門》（B001）。請 Amy 查詢這一天、這本書是否已有預約。如果可以接受，請用 nano 把小明的預約加到 reservations.csv。若無法儲存，先查明原因，由管理員補上館員需要的權限，再讓 Amy 完成記錄。最後確認原有預約與新增紀錄都在。

## Question 3｜Ben 接到同一本書的預約

Ben 接班後，小華也想在明天（2026-10-17）借《Linux入門》（B001）。請 Ben 用 awk 查詢目前的預約紀錄，回答能否接受小華的請求，以及這本書明天已經預約給誰。沿用上一題的檔案，依查到的結果處理。

## Question 4｜讓 Ben 讀到交接說明

Ben 接著要讀 handover.txt，卻發現無法讀取。請查 Ben 所屬的群組，再看這份檔案的群組與權限。交接說明要讓 Amy、Ben 共同閱讀，請管理員將 handover.txt 的群組改成 library_staff，再由 Ben 讀取並確認內容。

## Question 5｜更正交接說明中的姓名

Ben 讀到交接說明後，發現上午館員的姓名誤寫成 Ami，正確姓名是 Amy。請用 sed 預覽更正結果，再另存為自己家目錄中的 handover-fixed.txt。確認內容正確後，由管理員把更正內容複製回原本的 handover.txt，並請 Ben 再讀一次。

## Question 6｜明天需要準備幾本書？

交接前，Ben 還要依目前的預約紀錄準備明天要取的書。請用 awk 統計 2026-10-17 共有幾筆預約，確認是否已包含 Amy 剛才替小明新增的紀錄。每筆預約需要準備一本書。

## 繳交

請以 Markdown 檔案繳交。繳交方式與內容格式於課堂說明。

## 教師準備

在可還原的 Ubuntu VM，以具備 sudo 授權的帳號進入教材 `example_data/`，執行：

```bash
sudo bash project2/setup.sh
```

此腳本建立 `/srv/course-library`、兩個館員示範帳號及 `library_staff` 群組。若示範帳號已存在，會確認它已屬於館員群組，不修改學生本人的群組、不設定登入密碼。再次執行會將四個練習檔案與權限還原到題目起點，**作答途中不要重跑**。

館員透過 `sudo -u` 執行單一指令，不需登入館員帳號。課程不需要另外安裝套件。
