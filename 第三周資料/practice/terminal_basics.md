# Linux Terminal 基礎操作練習

請依序操作：先做一個小步驟，觀察結果，再使用下一個命令。下方 Bash 區塊都沒有提示符，可以直接複製。實際完整路徑、工具版本、日期與時間，會依帳號及執行環境不同。

環境準備適用 Ubuntu／Debian。標示「管理員操作」的 sudo 步驟，請由具 sudo 授權的帳號完成；其餘練習使用自己的普通帳號。若本人帳號已用 sudo 完成安裝，直接沿用原 Terminal 即可。首次練習使用新的空目錄；重做時請對照留下的檔案。

大部分步驟沿用同一個 Terminal。到了「新 Terminal」一節，再開另一個 Terminal，親自觀察變數需要重新設定，而已儲存的檔案仍在。後續沿用已恢復位置的 Terminal。

進入 nano 後，依該節說明實際按鍵；回到 Terminal 才輸入下一條 Bash 命令。

### WSL 的 Windows 檔案入口（選用）

使用 WSL 時，可以在 Windows 檔案總管的網址列輸入 `\\wsl$`，選自己的 Linux 發行版本，進入 `home` 和自己的帳號目錄。Linux 的 `/home/student` 就是 student 的家目錄；實際帳號以自己的結果為準。

這只是從 Windows 查看 Linux 檔案的入口，課堂命令仍在 Linux Terminal 執行。使用一般 Linux VM 的同學，直接在 VM 內操作即可，不需要這個入口。

## 1. Terminal：輸入命令並讀取結果

在自己的 Terminal 輸入 pwd，按 Enter 看目前位置。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：** 提示符後輸入命令

````bash
pwd
````

**預期看到（範例）：**

````text
/home/lab_teacher
````

- **行首 $ 是提示符：** 只輸入 pwd，再按 Enter
- **每次回到 $ 才輸入下一條：** 命令下方是結果，不是要重打的文字

**結果判讀：** 看到完整路徑，再確認系統種類。

**說明：** 先辨認提示符、命令與結果。接下來先確認作業系統並完成工具安裝。只有標示環境準備的 sudo 步驟使用具授權的管理員帳號；之後回到自己的普通帳號練習。

## 2. cat：確認目前的 Linux 系統

先不換目錄，用 cat 讀取系統版本，確認安裝方式。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：** cat /etc/os-release

````bash
cat /etc/os-release
````

**預期看到（節錄）：**

````text
PRETTY_NAME="Ubuntu 24.04.2 LTS"
ID=ubuntu
ID_LIKE=debian
````

- **cat 讀取檔案：** /etc/os-release 記錄系統名稱與版本
- **輸出節錄：** 本課安裝命令適用 Ubuntu／Debian

**結果判讀：** 看到 Ubuntu 與 Debian 系列資訊。

**說明：** 這個命令使用以 / 開頭的完整路徑，所以從任何目錄都能讀取 /etc/os-release。完整輸出還有其他欄位，本頁只節錄辨識需要的欄位。本課安裝命令適用 Ubuntu／Debian。下一頁先確認 sudo 授權。

## 3. sudo：先確認管理員授權

接下來要安裝工具，先用有 sudo 授權的帳號確認權限。

**操作身分：** 具 sudo 授權帳號。 **畫面與位置：** 任意目錄。

**管理員操作：** 使用具 sudo 授權的帳號；這是 sudo 授權操作，不需要另開 root Terminal。

**語法：** sudo -v

````bash
sudo -v
````

- **sudo -v：** 確認授權；仍使用本人帳號
- **輸入自己的登入密碼：** 畫面不顯示字元；輸入後按 Enter

**結果判讀：** 驗證後沿用此視窗，繼續安裝工具。

**說明：** 在目前的 Terminal 以 sudo 確認授權，再執行安裝。需要驗證時輸入目前帳號自己的登入密碼，不顯示星號是正常現象。授權尚有效時可能不再詢問。若目前帳號沒有 sudo 授權，請由管理員完成這一頁及後面的兩頁安裝。

## 4. apt update：更新可安裝的套件清單

沿用剛才有 sudo 授權的帳號，先更新套件清單。

**操作身分：** 具 sudo 授權帳號。 **畫面與位置：** 任意目錄。

**管理員操作：** 使用具 sudo 授權的帳號；這是 sudo 授權操作，不需要另開 root Terminal。

**語法：** sudo apt update

````bash
sudo apt update
````

**預期看到（節錄）：**

````text
Reading package lists...
Building dependency tree...
Reading state information...
````

- **update 更新清單：** 先更新套件資訊，再安裝工具
- **輸出節錄：** 來源與訊息依當時環境不同

**結果判讀：** 命令結束且沒有 E: 錯誤，再進行安裝。

**說明：** 仍由具 sudo 授權的帳號操作。本頁輸出節錄自實測；套件來源、進度與可升級數會因環境改變。若網路或套件來源報錯，先由管理員處理後再重試。update 是更新清單，不是把所有套件升級。

## 5. apt install：安裝課程會使用的工具

清單更新完成後，安裝 git 與 nano。

**操作身分：** 具 sudo 授權帳號。 **畫面與位置：** 任意目錄。

**管理員操作：** 使用具 sudo 授權的帳號；這是 sudo 授權操作，不需要另開 root Terminal。

**語法：** sudo apt install 套件名稱

````bash
sudo apt install git nano
````

**預期看到（節錄）：**

````text
git is already the newest version
nano is already the newest version
````

- **畫面為輸出節錄：** 只保留安裝狀態；版本另頁查看
- **已安裝也可再執行：** 出現確認詢問時，閱讀後輸入 Y

**結果判讀：** 回到提示符後，沿用此帳號查版本。

**說明：** 本頁由具sudo授權的帳號操作。git 取得教材，nano 編輯文字。畫面節錄已安裝時的輸出；新環境依提示輸入Y並按Enter，等安裝結束。後續資料檢查使用Linux原有的基本命令。

## 6. git：確認工具能正常啟動

安裝已完成，現在用本人帳號確認 git 能顯示版本。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：** git --version

````bash
git --version
````

**預期看到：**

````text
git version 2.43.0
````

- **用途：** 取得與管理教材的工具
- **觀察版本：** 版本數字依安裝時間不同

**結果判讀：** 能顯示版本，表示已找到這個工具。

**說明：** 使用自己的普通帳號檢查即可。下一頁繼續確認另一個工具。

## 7. nano：確認工具能正常啟動

上一個工具已確認，接著檢查 nano 的版本。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：** nano --version

````bash
nano --version
````

**預期看到（節錄）：**

````text
 GNU nano, version 7.2
````

- **用途：** 稍後要操作的文字編輯器
- **輸出節錄：** 版本數字依安裝時間不同

**結果判讀：** 能顯示版本，表示已找到這個工具。

**說明：** 使用自己的普通帳號檢查即可。原命令會輸出更多資訊，本頁只節錄版本行，不使用管線截斷。下一頁繼續確認另一個工具。

## 8. pwd：確認目前操作位置

工具已備妥，沿用本人帳號的 Terminal，先看目前位置。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：** pwd

````bash
pwd
````

**預期看到（範例）：**

````text
/home/lab_teacher
````

- **完整路徑：** 從 / 開始，指出目前所在目錄

**結果判讀：** 這是目前目錄，還沒有建立獨立練習目錄。

**說明：** 以下只使用自己的普通帳號。pwd 顯示目前目錄，可能是家目錄，也可能是其他位置。教材路徑只是範例。下一頁用 echo 讀出 HOME，再用它設定練習位置。

## 9. echo：讀出家目錄的位置

pwd 剛才顯示目前位置；現在讀出自己的家目錄。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：** echo "$HOME"

````bash
echo "$HOME"
````

**預期看到（範例）：**

````text
/home/lab_teacher
````

- **HOME 是系統已有的變數：** 保存本人家目錄；系統已設定
- **echo "$HOME"：** $HOME 取值；echo 顯示結果

**結果判讀：** 這個路徑是家目錄，不會因 echo 而切換目錄。

**說明：** 對照 pwd 與 echo "$HOME"：前者顯示目前目錄，後者顯示帳號的家目錄，兩者不一定相同。HOME 是系統已有的變數；本課不修改它。雙引號把整個值當成一個路徑。下一頁用它設定另一個變數 PROJECT。

## 10. PROJECT：保存這次練習的目錄

用剛才的 HOME，為本次練習保存一個目錄路徑。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：**

````bash
PROJECT="目錄"
echo "$PROJECT"
````
````bash
PROJECT="$HOME/linux-lab"
echo "$PROJECT"
````

**預期看到：**

````text
/home/lab_teacher/linux-lab
````

- **PROJECT 是自己取的名稱：** 設定時寫 PROJECT；取值時寫 $PROJECT
- **等號兩旁不加空白：** 先設定第一行，再用第二行讀回
- **目前只保存一段路徑文字：** 尚未建立資料夾，也尚未進入它

**結果判讀：** echo 顯示 linux-lab 路徑，下一頁才建立資料夾。

**說明：** PROJECT 是我們自己取的變數名稱，本課統一使用大寫。先輸入 PROJECT="$HOME/linux-lab"，按 Enter 後再輸入 echo "$PROJECT"。設定變數不會建立資料夾，也不會切換位置。接下來沿用這個 Terminal，把 PROJECT 的值交給 mkdir。

## 11. mkdir：建立練習資料夾

剛才只保存路徑，現在沿用同一個 Terminal 建立目錄。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄。

**語法：** mkdir -p 目錄

````bash
mkdir -p "$PROJECT"
````

成功時通常沒有文字輸出，接著觀察後續的核對結果。

- **-p：** 不存在就建立，已存在則沿用

**結果判讀：** 沒有錯誤就代表建立完成，目前位置仍未改變。

**說明：** 沿用上一頁設定的 PROJECT。mkdir 讀取這個值建立資料夾；-p 在已存在時沿用，不清空檔案。成功時通常沒有輸出，下一頁再進入確認。

## 12. cd：進入練習資料夾

目錄已建立，現在用 cd 切換目前位置。

**操作身分：** 本人 Terminal。 **畫面與位置：** 任意目錄 → 獨立練習目錄。

**語法：** cd 目錄

````bash
cd "$PROJECT"
````

成功時通常沒有文字輸出，接著觀察後續的核對結果。

- **cd "$PROJECT"：** 使用剛才保存的路徑，進入已建立的目錄
- **成功時沒有文字輸出：** 下一頁用 pwd 核對切換結果

**結果判讀：** cd 成功時通常沒有文字輸出。

**說明：** 先實際執行 cd "$PROJECT"。沒有錯誤時通常不顯示文字，下一頁立即用已學過的 pwd 確認切換結果。

## 13. pwd：確認已進入練習目錄

剛才 cd 沒有顯示文字，現在用 pwd 核對。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** pwd

````bash
pwd
````

**預期看到（範例）：**

````text
/home/lab_teacher/linux-lab
````

- **比對剛才的 PROJECT：** pwd 應顯示相同的完整路徑

**結果判讀：** 看到 linux-lab 的完整路徑，之後的小檔案都建在這裡。

**說明：** 先核對實際位置，再使用下頁的 ls 查看檔案。後面都在這個私人練習目錄操作。

## 14. ls：先查看目錄內容

已確認在 linux-lab，先用 ls 看裡面有沒有檔案。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** ls

````bash
ls
````

成功時通常沒有文字輸出，接著觀察後續的核對結果。

- **第一次練習使用新目錄：** 本例沒有檔案，所以 ls 沒有文字輸出

**結果判讀：** 若沒有檔案，接著建立第一份 sample.txt。

**說明：** 先觀察空目錄的結果，再引出建立第一個檔案。重做課程時可能看到上次留下的檔案，不需要刪除整個練習區。

## 15. touch：建立檔案後確認名稱

目錄是空的，如何加入第一個檔案？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** touch 檔名

````bash
touch sample.txt
ls
````

**預期看到：**

````text
sample.txt
````

- **用 ls 核對：** touch 建立空檔，再列出檔名

**結果判讀：** 已看到 sample.txt，還不知道內容。

**說明：** 先建立檔案，再用上一頁的 ls 核對。下一個問題：有了檔名，檔案裡是否已經有文字？

## 16. cat：讀取空白檔案

已看到檔名，裡面是否有文字？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** cat 檔名

````bash
cat sample.txt
````

成功時通常沒有文字輸出，接著觀察後續的核對結果。

- **觀察結果：** cat 顯示檔案內容；空檔沒有文字

**結果判讀：** sample.txt 存在，但內容是空的。

**說明：** 承接 touch 與 ls 的結果。下一頁先用 echo 顯示一句文字，再回來檢查檔案，確認顯示與存檔的差別。

## 17. echo：畫面有文字，檔案有嗎？

先顯示一句文字，再檢查剛才的空檔。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** echo '文字'

````bash
echo 'Hello Linux'
cat sample.txt
````

**預期看到：**

````text
Hello Linux
````

- **單引號包住要顯示的文字：** Hello Linux 只出現在畫面，還沒存檔
- **cat 再讀 sample.txt：** 仍沒有文字，因為檔案還是空的

**結果判讀：** echo 顯示文字，還沒存入檔案。

**說明：** 兩個命令都已學過。這頁透過實際觀察提出下一個問題：如何將 echo 的文字寫入 sample.txt？

## 18. >：把文字存入檔案

畫面顯示過文字，如何讓檔案也有內容？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 命令 > 檔名

````bash
echo 'First line' > sample.txt
cat sample.txt
````

**預期看到：**

````text
First line
````

- **> 指定輸出檔案：** 目標已存在時，先清空再寫入

**結果判讀：** cat 現在讀到了 First line。

**說明：** 承接上一頁未存檔的觀察，只增加 >。先寫入再讀回。下一個問題：還要加第二行時，如何保留第一行？

## 19. >>：追加文字後讀回確認

還要加入第二行，如何保留原有內容？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 命令 >> 檔名

````bash
echo 'Second line' >> sample.txt
cat sample.txt
````

**預期看到：**

````text
First line
Second line
````

- **>> 追加到末尾：** 新文字接在既有內容後面

**結果判讀：** 第一行仍在，第二行已追加。

**說明：** 只新增 >> 用法，並以 cat 看見兩行結果。下一頁處理檔名，不改檔案內容。

## 20. mv：比較改名前後的檔名

檔案已有內容，如何換成較清楚的名稱？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** mv 原檔名 新檔名

````bash
ls
mv sample.txt renamed.txt
ls
````

**預期看到：**

````text
sample.txt
renamed.txt
````

- **mv 來源檔名 新檔名：** 本例在同一目錄改名，文字內容不變
- **用 ls 比較前後：** sample.txt 消失，renamed.txt 出現

**結果判讀：** 內容不變，檔名改為 renamed.txt。

**說明：** 先 ls、再 mv、最後 ls。只教同一目錄內重新命名這一種用法。下一頁保留原檔，另複製一份。

## 21. cp：複製後多出哪個檔案？

改名後只有一份，如何保留原檔再做副本？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** cp 來源檔 副本檔

````bash
ls
cp renamed.txt copy.txt
ls
````

**預期看到：**

````text
renamed.txt
copy.txt
renamed.txt
````

- **觀察前後名稱：** 複製後，來源與副本都存在

**結果判讀：** 目錄中現在有兩份檔案。

**說明：** 承接改名後的一份檔案。這頁只增加 cp，前後都用已學過的 ls 核對。下一頁移除不再需要的副本。

## 22. rm：刪除後還剩哪些檔案？

副本已用完，如何只移除這一份？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** rm 檔名

````bash
ls
rm copy.txt
ls
````

**預期看到：**

````text
copy.txt
renamed.txt
renamed.txt
````

- **只指定一個檔名：** 本頁刪 copy.txt，保留 renamed.txt

**結果判讀：** 刪除後只剩 renamed.txt。

**說明：** 先看清楚檔名，再只刪自己建立的副本。不使用萬用字元或刪除目錄。下一頁觀察點開頭名稱的顯示方式。

## 23. ls -a：剛建立的檔案為何沒列出？

建立 .hidden 後，先看一般 ls 的結果。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** ls -a

````bash
touch .hidden
ls
ls -a
````

**預期看到：**

````text
renamed.txt
.
..
.hidden
renamed.txt
````

- **-a 顯示隱藏名稱：** 以 . 開頭的名稱，一般 ls 不會列出
- **畫面裡的 . 與 ..：** . 是目前目錄；.. 是上一層目錄

**結果判讀：** 加上 -a 後，才看到 .hidden。

**說明：** 依序建立、列一般名稱、再列全部名稱，讓隱藏檔的差異可以直接看見。後續回到 renamed.txt 的內容。

## 24. head：只讀開頭一行

renamed.txt 仍有原來兩行，現在只讀開頭第一行。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** head -n 行數 檔名

````bash
head -n 1 renamed.txt
````

**預期看到：**

````text
First line
````

- **-n 1：** 只顯示開頭一行

**結果判讀：** 看到 First line，原檔仍有兩行。

**說明：** 先前 cat 已展示完整兩行，因此本頁只新增 head。下一頁改看最後一行。

## 25. tail：只讀最後一行

第一行看到了，如何確認最後一行？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** tail -n 行數 檔名

````bash
tail -n 1 renamed.txt
````

**預期看到：**

````text
Second line
````

- **-n 1：** 只顯示最後一行

**結果判讀：** 最後一行是 Second line。

**說明：** 沿用同一份兩行資料，只新增 tail。下一頁用計數確認檔案共有幾行。

## 26. wc -l：把看到的行數數出來

先看全文，再確認命令算出的行數。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** wc -l 檔名

````bash
cat renamed.txt
wc -l renamed.txt
````

**預期看到：**

````text
First line
Second line
2 renamed.txt
````

- **-l 計算換行：** 本例每行都有結尾換行

**結果判讀：** 看到兩行，計算結果也是 2。

**說明：** 以完整內容核對計數。接下來練習中途重開 Terminal 時，如何重新設定 PROJECT 並回到剛才的資料夾。

## 27. 新 Terminal：重設 PROJECT 並回到目錄

先開另一個新 Terminal；本頁做完後，後續都沿用它。

**操作身分：** 本人 Terminal。 **畫面與位置：** 新 Terminal → 獨立練習目錄。

**語法：** 先重設 PROJECT，再用 cd

**先開另一個新的 Terminal。** 第一次讀取 PROJECT 時，應沒有文字輸出；接著重新設定，回到原練習位置：

````bash
echo "$PROJECT"
PROJECT="$HOME/linux-lab"
echo "$PROJECT"
cd "$PROJECT"
pwd
````

**預期看到：**

````text

/home/lab_teacher/linux-lab
/home/lab_teacher/linux-lab
````

- **第一次 echo 應是空白：** PROJECT 尚未設定，不是檔案消失了
- **重新設定後再 cd：** 用同一路徑，回到原有的練習檔案

**結果判讀：** pwd 回到 linux-lab；接下來只用這個新 Terminal。

**說明：** 先另外開一個新的 Terminal，原視窗可留著不用。這個新 Terminal 尚未設定 PROJECT；先 echo 觀察空白，再重新賦值、echo、cd、pwd。PROJECT 的值只在設定它的 Shell 有效，其他 Terminal 不會自動同步；關閉 Shell 後，這個設定不會自動保留。檔案已存在磁碟，不需要再 mkdir。從下一頁起，全部沿用這個新 Terminal。

## 28. nano：開啟一份新文字檔

沿用剛才的新 Terminal，開啟 nano 輸入一份文字。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄 → nano。

**語法：** nano 檔名

````bash
nano nano_note.txt
````

開啟後先辨認文字區與下方快捷鍵，沿用此畫面進入下一節。

- **目前進入 nano 編輯器：** 不要在文字區輸入其他 Shell 命令
- **畫面下方的 ^ 代表 Ctrl：** 例如 ^O 表示按住 Ctrl 再按 O

**結果判讀：** 畫面已進入 nano，還沒有儲存。

**說明：** 先進入 nano，下一頁才輸入並儲存。nano 可直接輸入文字。本課以 Ctrl+O 儲存、Ctrl+X 離開。

## 29. nano：輸入文字並儲存

沿用上一頁的 nano，不要重新開檔，直接輸入文字。

**操作身分：** 本人 Terminal。 **畫面與位置：** nano 編輯畫面。

**語法：** Ctrl+O，再按 Enter

1. 直接輸入 `Nano practice`。
2. 按住 Ctrl 再按 O，放開按鍵。
3. 檔名顯示為 `nano_note.txt` 時，按 Enter 確認寫入。

目前仍在 nano，下一節再離開。

- **先輸入 Nano practice：** 直接在文字區輸入這一行
- **Ctrl+O → Enter：** 指定原檔名並完成寫入

**結果判讀：** 已寫入檔案，但畫面仍在 nano，下一頁才離開。

**說明：** 沿用上一頁 nano 畫面。輸入 Nano practice；按住 Ctrl 再按 O，放開後按 Enter 確認 nano_note.txt 檔名。此時仍在 nano，下一頁離開後讀回。

## 30. nano：離開後用 cat 核對

先按 Ctrl+X 離開 nano，看到 $ 後再用 cat 讀回。

**操作身分：** 本人 Terminal。 **畫面與位置：** nano → 獨立練習目錄。

**語法：** Ctrl+X 離開；再執行 cat

先按 Ctrl+X 離開 nano，回到 Terminal 後執行：

````bash
cat nano_note.txt
````

**預期看到：**

````text
Nano practice
````

- **Ctrl+X：** 離開 nano，回到 Terminal

**結果判讀：** 回到 $ 並讀到 Nano practice，接著建立 Markdown 紀錄。

**說明：** 先按 Ctrl+X 離開，回到 Terminal 才輸入 cat nano_note.txt。接下來使用相同的 nano 操作方式，建立 Markdown 紀錄。

## 31. Markdown：建立一份完整操作紀錄

回到 Terminal 後，用 nano 建立 report.md。Markdown 是純文字，可以用標題和程式碼區塊整理操作紀錄。

```bash
nano report.md
```

在 nano 直接逐行輸入以下七行。輸出區塊內的路徑請換成自己先前 `echo "$PROJECT"` 實際得到的結果。

````text
# 操作紀錄
```bash
echo "$PROJECT"
```
```text
/home/lab_teacher/linux-lab
```
````

輸入完成後按 Ctrl+O，按 Enter 確認 report.md 檔名，再按 Ctrl+X 離開 nano。最後一行打完即可儲存，不用另加空白行。

- `#` 後留一個空白，再寫標題。
- 成對的三個反引號包住一個程式碼區塊。bash 放命令，text 放輸出。
- 這些是寫進 report.md 的紀錄文字，編輯時不會執行 echo。

## 32. cat：檢查 Markdown 的命令與輸出區塊

上一節已儲存並離開 nano。看到 Terminal 提示符後，才輸入：

```bash
cat report.md
```

預期讀到完整標題與兩個區塊：

````text
# 操作紀錄
```bash
echo "$PROJECT"
```
```text
/home/lab_teacher/linux-lab
```
````

核對每個區塊都有開始與結束的三個反引號。cat 顯示原文，不會再次執行紀錄中的 echo。

### 預覽自己的 Markdown

沿用同一份 report.md，用 cat 讀出並複製完整原文。在自己可編輯的 GitHub 儲存庫選 Add file → Create new file，輸入 report.md、貼上原文，再點 Preview。已有同名檔時開啟該檔的編輯頁。要修改時回 Linux 編輯原檔，再重新貼上預覽。完整步驟見[教材入口的查看 Markdown](../README.md#查看-markdown)。

## 33. echo：建立六行練習資料

Markdown 紀錄已完成；仍在 linux-lab，建立六行水果資料。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 第一行用 >，後續行用 >>

````bash
echo 'apple' > fruits.txt
echo 'banana' >> fruits.txt
echo 'apple' >> fruits.txt
echo 'orange' >> fruits.txt
echo 'banana' >> fruits.txt
echo 'banana' >> fruits.txt
````

成功時通常沒有文字輸出，接著觀察後續的核對結果。

- **沿用已學的寫法：** > 建立內容；>> 依序追加

**結果判讀：** 先寫入六行，下一頁完整讀回。

**說明：** 這頁只組合已練習過的 echo、>、>>，不用任何新參數。下一頁先用 cat 看完整原文，再決定怎麼整理重複資料。

## 34. cat：重複名稱目前排在哪裡？

先讀原文，看看相同水果是否集中在一起。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** cat fruits.txt

````bash
cat fruits.txt
````

**預期看到：**

````text
apple
banana
apple
orange
banana
banana
````

- **每行一個水果：** 六行中有三種不同名稱

**結果判讀：** 相同名稱分散在不同位置。

**說明：** 先看全部原文。學生可以看到 apple 與 banana 分散在不同位置。下一頁先練習找指定文字，然後再整理完整資料的順序。

## 35. grep：只想看 apple 的行

全文已看過，如何只留下含 apple 的行？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** grep '文字' 檔名

````bash
grep 'apple' fruits.txt
````

**預期看到：**

````text
apple
apple
````

- **比對文字：** 只顯示含 apple 的行

**結果判讀：** 結果列出兩行 apple。

**說明：** 只增加 grep。這次查指定水果；下一頁回到整份 fruits.txt，把所有水果排好，為每種水果計數作準備。

## 36. sort：排好後仍有什麼問題？

相同名稱分散，先把完整資料排在一起。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** sort 檔名

````bash
sort fruits.txt
````

**預期看到：**

````text
apple
apple
banana
banana
banana
orange
````

- **觀察排序結果：** 只改輸出順序，不改原始檔案

**結果判讀：** 名稱已相鄰，但仍有六行。

**說明：** 完整顯示排序後的六行。接著要把這個輸出交給另一個命令，因此下一頁先練習 | 如何傳遞資料。

## 37. 管線：下一個命令如何接到文字？

cat 已能列出六行，能直接交給 wc 計數嗎？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 命令一 | 命令二

````bash
cat fruits.txt | wc -l
````

**預期看到：**

````text
6
````

- **| 把左邊輸出交給右邊：** cat 送出六行；wc 不指定檔名，直接接收
- **這裡只有結果 6：** cat 的六行已交給 wc，不另外顯示

**結果判讀：** wc 收到六行，所以顯示 6。

**說明：** 前面 cat 與 wc -l 都已單獨操作過，本頁只新增 |。左邊標準輸出交給右邊標準輸入。下一頁把已排好的六行交給 uniq -c，計算每種水果的次數。

## 38. uniq -c：相鄰重複能合成次數嗎？

sort 已讓同名水果相鄰，現在接上 uniq -c 計數。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** sort 檔名 | uniq -c

````bash
sort fruits.txt | uniq -c
````

**預期看到：**

````text
      2 apple
      3 banana
      1 orange
````

- **-c 顯示次數：** uniq 合併相鄰相同行，前面先 sort

**結果判讀：** 左欄是次數、右欄是水果；目前為 2、3、1。

**說明：** 只在已學的 sort 後新增 uniq -c，保留上頁說明過的管線連接。必須先讓相同名稱相鄰。學生看到次數是 2、3、1，下一頁再用次數決定排列順序。

## 39. sort -nr：按次數由多到少

已算出次數，為何 3 沒排在最前面？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 前面結果 | sort -nr

````bash
sort fruits.txt | uniq -c | sort -nr
````

**預期看到：**

````text
      3 banana
      2 apple
      1 orange
````

- **-n 與 -r：** -n 比較數值，例如 10 大於 2；-r 反轉順序，讓次數由多到少

**結果判讀：** banana 3 次，現在排在最前面。

**說明：** 本頁只在上一條管線後加 sort -nr。對照上一頁 2、3、1，現在變成 3、2、1，banana 排到最前面。下一頁將結果存檔，再讀回核對。
教學對照：文字反向排序會是2、10；數值反向排序是10、2。現有水果次數只有個位數，單看結果無法辨認-n的作用，請用這個對照確認理解。

## 40. 換行續寫：長命令分行輸入

管線變長了，如何分行輸入同一條命令？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 行尾 \ 接到下一行

````bash
sort fruits.txt \
  | uniq -c \
  | sort -nr
````

**預期看到：**

````text
      3 banana
      2 apple
      1 orange
````

- **行尾 \：** 接到下一行；\ 後直接按 Enter
- **行首 >：** Bash 的續行提示符，不需輸入
- **何時執行？：** 最後一行不加 \，按 Enter 執行

**結果判讀：** 同一條管線，結果仍為 3、2、1。

**說明：** 沿用上一頁完整管線，只將長命令拆成三行。前兩行以反斜線作為最後一個字元，再按 Enter；反斜線後不要加空白。Bash 顯示行首 > 等待續行，這個 > 是提示符，不是先前寫入檔案的重導向符號，不需輸入。最後一行不加反斜線，按 Enter 後才執行整條管線，得到相同的水果次數。下一頁再把結果存檔。

## 41. >：管線結果存檔後還能讀回嗎？

目前結果只在畫面，如何保存這張計數表？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 完整管線 > 檔名

````bash
sort fruits.txt | uniq -c | sort -nr > counts.txt
cat counts.txt
````

**預期看到：**

````text
      3 banana
      2 apple
      1 orange
````

- **沿用 >：** 把最後一段輸出寫入 counts.txt

**結果判讀：** 管線存檔時沒有畫面輸出，cat 才讀出三行。

**說明：** 這頁只把前面練習過的 > 放到整條管線最後。接下來換一種有欄位名稱的資料格式，用 cat 先看原文再找閱讀工具。
課堂檢核：先暫停示範，請學生說出判斷依據，再執行命令核對。先回答：畫面沒有結果，怎麼確認輸出已寫進檔案？

## 42. CSV：用逗號分開欄位

建立水果名稱與數量兩欄，再讀回內容。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 欄位用逗號分隔；第一行是標題

````bash
echo "name,count" > fruit.csv
echo "apple,2" >> fruit.csv
echo "banana,10" >> fruit.csv
cat fruit.csv
````

**預期看到：**

````text
name,count
apple,2
banana,10
````

- **第一行是欄位名稱：** name 是名稱，count 是數量
- **後面每行是一筆資料：** 本例欄位內沒有逗號或換行

**結果判讀：** 三行中有一行標題、兩筆資料。

**說明：** 這是最簡單的CSV練習。資料值不含逗號、雙引號或換行，因此每個逗號都代表分欄。接下來先分清標題與資料。

## 43. tail -n +2：從第二行開始讀

第一行是標題；先只看真正的兩筆資料。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** tail -n +2 檔名

````bash
tail -n +2 fruit.csv
````

**預期看到：**

````text
apple,2
banana,10
````

- **-n +2：** 從第2行開始，讀到檔案結尾
- **與 tail -n 1 比較：** -n 1 讀最後1行；+2 是起始行

**結果判讀：** 標題沒有出現在結果中。

**說明：** wc -l會連標題一起計算。之後計算資料筆數時，先排除標題，再數行數。

## 44. grep -n：找出資料並顯示行號

沿用同一份 CSV，找出第一欄是 apple 的那一筆。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** grep -n '^apple,' 檔名

````bash
grep -n '^apple,' fruit.csv
````

**預期看到：**

````text
2:apple,2
````

- **-n 顯示原檔行號：** 2: 表示這筆在第2行
- **^apple,：** 從行首比對 apple 與後面的逗號

**結果判讀：** 第2行是 apple 的資料。

**說明：** 先前grep顯示符合的整行；-n再加上原檔行號。^要求從行首開始，逗號標明第一欄結束。本課每檔第一行是標題，所以apple位於第2行。

## 45. cut：只讀取名稱欄

已能選整行；現在只讀取每行的第一欄。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** cut -d, -f1 檔名

````bash
tail -n +2 fruit.csv | cut -d, -f1
````

**預期看到：**

````text
apple
banana
````

- **-d,：** 使用逗號分欄
- **-f1：** 選出第1欄；欄號從1開始

**結果判讀：** 只剩名稱，數量不再顯示。

**說明：** 先讀懂tail輸出仍有兩欄，再接到cut。cut只讀資料，不會改寫fruit.csv。

## 46. cut：改讀數量欄

只把欄號改成 2，比較結果變成什麼。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** cut -d, -f2 檔名

````bash
tail -n +2 fruit.csv | cut -d, -f2
````

**預期看到：**

````text
2
10
````

- **-f2：** 選出第2欄
- **保持同一份資料：** 改欄號，不改原檔內容

**結果判讀：** 這次只看到數量 2 與 10。

**說明：** 先請學生預測哪一行會得到2、哪一行得到10，再執行。下一頁接上已學的數值排序。

## 47. 管線：把數量由大到小排列

把剛選出的數量，再交給數值排序。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** 讀資料 | 選欄位 | 排序

````bash
tail -n +2 fruit.csv | cut -d, -f2 | sort -nr
````

**預期看到：**

````text
10
2
````

- **沿用前一頁的輸出：** 2 與 10 交給 sort -nr
- **-n 與 -r：** 以數值比較，再反轉為由大到小

**結果判讀：** 10 排在 2 前面。

**說明：** 這次能看到-n的必要性。數值排序是10、2；若只用文字反向排序，會是2、10。請學生先說出管線中間結果，再看最後排序。

## 48. date：查看現在的日期與時間

腳本要留下執行時間，先試試 date 會顯示什麼。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** date

````bash
date
````

**預期看到（範例）：**

````text
Thu Oct 15 19:53:16 CST 2026
````

- **日期、時間與時區：** 畫面依實際執行時刻顯示

**結果判讀：** 這是一個時間範例，不必與教材相同。

**說明：** CSV練習完成後，現在先認識date，再把已學命令寫成簡單腳本。日期與時間依自己的環境為準。

## 49. nano：把五個步驟寫成腳本

在 linux-lab 用 nano 新建 hello_tools.sh，寫入已學過的命令。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄 → nano → 原目錄。

**語法：** nano hello_tools.sh

````bash
nano hello_tools.sh
````

在 nano 逐行輸入以下內容。第一行指定以 Bash 執行，後面是五個已學過的命令：

````bash
#!/bin/bash
echo "開始執行"
date
pwd
nano demo_note.txt
echo "執行結束"
````

按 Ctrl+O、Enter 儲存，再按 Ctrl+X 離開。

- **.sh 是這份腳本的檔名結尾：** 先寫入指定 Bash 的第一行，再輸入五個命令，先不執行
- **儲存後先離開 nano：** Ctrl+O → Enter → Ctrl+X，回到 $

**結果判讀：** 目前只是存好文字檔，下一頁用 cat 先檢查。

**說明：** 每個命令都已先操作過。用 nano hello_tools.sh 開啟，寫入指定 Bash 的第一行與五個命令，再 Ctrl+O、Enter、Ctrl+X。腳本不使用 PROJECT，直接在執行時的目前目錄操作。下一頁先用 cat 檢查內容。

## 50. cat：先確認腳本內容

腳本已存好，執行前先讀回第一行與五個命令。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** cat hello_tools.sh

````bash
cat hello_tools.sh
````

**預期看到：**

````text
#!/bin/bash
echo "開始執行"
date
pwd
nano demo_note.txt
echo "執行結束"
````

- **cat 只讀取文字：** 此時不會顯示時間，也不會開 nano

**結果判讀：** 第一行與五個命令都正確，接著才用 bash 執行同一檔案。

**說明：** 對照上一頁輸入的內容，第一行應為 #!/bin/bash，確認檔名、大小寫與引號。cat 只顯示原文，下一頁用 bash 執行同一個檔案。

## 51. bash：執行到 nano 時會怎樣？

在 $ 後輸入 bash hello_tools.sh，觀察它自動開啟 nano。

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄 → nano。

**語法：** bash hello_tools.sh

````bash
bash hello_tools.sh
````

觀察前三行命令的輸出，接著會自動開啟 nano demo_note.txt。先停在編輯畫面，沿用下一節繼續。

**預期看到（範例）：**

````text
開始執行
Thu Oct 15 19:53:16 CST 2026
/home/lab_teacher/linux-lab
````

- **bash 依序執行檔案裡的命令：** 先顯示開始、時間與目前目錄
- **這種執行方式：** 檔案可讀即可，不需要執行權 x；稍後再比較直接執行
- **現在停在 nano，腳本還沒完成：** 不要再輸入 bash；下一頁完成編輯

**結果判讀：** 仍在 nano，腳本尚未結束。

**說明：** 執行後先看到開始訊息、date 與 pwd 的輸出，再自動開啟 nano demo_note.txt。腳本會等待這次互動，下一頁儲存並離開 nano 後才會繼續最後一行。時間以實際執行時刻為準。

## 52. nano：離開後，腳本繼續執行

沿用剛才腳本開啟的 nano，完成輸入、存檔並離開。

**操作身分：** 本人 Terminal。 **畫面與位置：** nano → 獨立練習目錄。

**語法：** Ctrl+O、Enter、Ctrl+X

沿用腳本自動開啟的 nano：

1. 輸入 `From script`。
2. Ctrl+O，再按 Enter 儲存。
3. Ctrl+X 離開。

離開後，腳本自動顯示「執行結束」。回到提示符後才輸入：

````bash
cat demo_note.txt
````

**預期看到：**

````text
執行結束
From script
````

- **先在 nano 輸入 From script：** Ctrl+O、Enter 儲存；Ctrl+X 離開
- **看到執行結束與 $ 後：** 才輸入 cat demo_note.txt 讀回檔案

**結果判讀：** 看到 $ 才表示腳本結束；cat 讀到新檔文字。

**說明：** 沿用上一頁自動開啟的 nano，輸入 From script，再 Ctrl+O、Enter、Ctrl+X。離開編輯器後，腳本自動執行最後一行 echo，顯示執行結束；回到提示符後才輸入 cat demo_note.txt。
課堂檢核：先暫停示範，請學生說出判斷依據，再執行命令核對。先回答：離開 nano 後，腳本接著會執行哪一行？

## 53. ls -l：直接執行前先看權限

上一節已離開 nano，看到「執行結束」並回到 Terminal。接下來比較另一種執行方式。

```bash
ls -l hello_tools.sh
```

先看最左邊的權限字串。剛由編輯器建立的腳本通常沒有 `x`，例如 `-rw-r--r--`。其中 `r` 表示可讀、`w` 表示可寫、`x` 表示可執行。

前面用 `bash hello_tools.sh` 是請 Bash 讀取檔案，無須 x。現在試著把檔案本身當成程式執行：

```bash
./hello_tools.sh
echo "$?"
```

沒有執行權時，預期看到：

```text
bash: ./hello_tools.sh: Permission denied
126
```

`./` 表示目前目錄。這次沒有開啟 nano；先保留拒絕訊息與退出狀態，再處理權限。

## 54. chmod：加上本人執行權後再試

這是自己建立的 hello_tools.sh，用 chmod 為擁有者增加執行權。

```bash
chmod u+x hello_tools.sh
```

`u` 表示檔案擁有者，`+x` 表示增加執行權，不會改寫腳本內容。成功通常沒有輸出，再列一次確認：

```bash
ls -l hello_tools.sh
```

擁有者那組現在應包含 x，例如 `-rwxr--r--`。接著再直接執行：

```bash
./hello_tools.sh
```

這次會顯示開始、日期與目錄，再次開啟 nano 的 demo_note.txt。原來的 From script 已存在，不需要重複輸入。按 Ctrl+X 離開 nano，腳本才會繼續顯示「執行結束」並回到 Terminal。

腳本第一行 `#!/bin/bash` 指定以 Bash 執行。兩種方式都會執行相同命令；只有直接使用 `./hello_tools.sh` 時，檔案還必須有執行權。

## 55. find：檔案多了，如何按名稱找？

目錄已有幾種檔案，如何只找 .txt 結尾的？

**操作身分：** 本人 Terminal。 **畫面與位置：** 獨立練習目錄。

**語法：** find 起點 -name '名稱條件'

````bash
find . -name '*.txt'
````

**預期看到：**

````text
./renamed.txt
./nano_note.txt
./fruits.txt
./counts.txt
./demo_note.txt
````

- **. 與名稱條件：** . 從目前目錄開始；*.txt 是 .txt 結尾

**結果判讀：** 找到五份文字檔，順序可能不同。

**說明：** 用 find 找出前面實際建立的文字檔。順序可能不同，應包含 renamed、nano_note、fruits、counts、demo_note 這五份 .txt 檔。完成後對照講義最後的檔案清單。

## 56. 這些指令在專案中怎麼用？

把小檔案練習的方法，用在每日備份、借閱統計與預約。

| 指令 | 專案一的用途 |
|---|---|
| ls、find、wc -l、head | 核對檔名、資料筆數與標題。 |
| cat、grep、cut | 讀取內容、找紀錄與欄位。 |
| bash | 執行已放好的 daily.sh 備份腳本。 |
| cp、mv | 讀懂 daily.sh 如何複製資料，再將副本改名。 |
| nano | 編輯 Markdown，寫下自己的命令、結果與解釋。 |

先完成今天的備份，再用 backup/ 裡的八天資料統計借閱，最後查詢並新增預約。

## 57. 從指令練習進入專案

剛才在 linux-lab 練習指令。接下來閱讀 example_data 教材，再依各專案的共同準備進入操作位置。

### linux-lab：剛才的練習目錄

放 renamed.txt、fruits.txt、report.md 等練習檔。
PROJECT 仍指向這裡，不會自動改成教材位置。

### example_data：下載的課程教材

放專案資料、題目與 daily.sh；專案二另有教師準備腳本。
下一段會先查看資料夾與檔案用途。

### 各專案的操作位置

專案一在 $HOME/example_data/project1；專案二在 Linux 的 /srv/course-library。Mac 原生專案二使用 /Users/Shared/course-library，準備方式見 [macOS 指南](../project2/MACOS.md)。
後面會先確認位置與身分，再開始實作。

## 58. 取得課程教材

先取得整份課程儲存庫，再將其中的「第三周資料」準備成課堂使用的工作副本。以下供已能使用 Git 的同學操作；已有儲存庫時沿用，不必再次 clone。Mac 同學也可依 [macOS 指南](../project2/MACOS.md) 下載 ZIP，無須為專案二另外安裝 Git。

```bash
cd "$HOME"
git clone https://github.com/chou141253/BigDataCourse.git
cd "$HOME/BigDataCourse"
```

本儲存庫的 project1/、project2/ 位於「第三周資料」內，沒有直接放在儲存庫根目錄。請依 [教材入口的取得本週教材](../README.md#取得本週教材)，將「第三周資料」複製為 `$HOME/example_data`；已有這份工作副本時，確認內容並沿用。

準備完成後，應能找到 `$HOME/example_data/project1/daily.sh`，再依專案說明進入 project1/。不要把整份儲存庫直接命名為 example_data，否則會多出「第三周資料」這一層。PROJECT 仍是之前的 linux-lab 練習目錄，不會自動改成教材位置。

## 完成後留下的練習檔案

以下檔案都在 PROJECT 指定的 linux-lab 目錄。sample.txt 已重新命名為 renamed.txt；copy.txt 已在練習中刪除。

| 檔案 | 內容與用途 |
| --- | --- |
| .hidden | 空檔，用於觀察隱藏名稱 |
| renamed.txt | First line、Second line 兩行文字 |
| nano_note.txt | Nano practice，一行 nano 儲存練習 |
| report.md | 標題、Bash 命令區塊與實際輸出區塊 |
| fruits.txt | 六行水果名稱，包含重複資料 |
| counts.txt | banana 3 次、apple 2 次、orange 1 次 |
| fruit.csv | name/count標題與apple/2、banana/10兩筆資料 |
| hello_tools.sh | 顯示開始、日期、目錄，開啟 nano，再顯示結束 |
| demo_note.txt | 腳本執行時，用 nano 儲存的 From script |

PROJECT 是目前 Terminal 自訂的變數。新開的 Terminal 不會自動取得這個值；依「新 Terminal」那一節重設 PROJECT，再進入原目錄。磁碟上的檔案仍然保留。

## 補充練習：一次讀取多份檔案

先回到前面的 linux-lab 練習目錄。

```bash
cd "$HOME/linux-lab"
echo red > color_a.txt
echo blue > color_b.txt
cat color_*.txt
```

`*` 代表檔名的可變部分。這裡會讀取 color_a.txt、color_b.txt，顯示 red、blue。

## 補充練習：排除 CSV 表頭

```bash
echo 'name,amount' > csv_demo.csv
echo 'apple,2' >> csv_demo.csv
echo 'banana,3' >> csv_demo.csv
grep -v '^name,' csv_demo.csv
```

`-v` 留下不符合的行，`^` 表示行首。結果只有 apple,2 與 banana,3，沒有表頭。

## 補充練習：列出檔名再計數

```bash
mkdir count_demo
touch count_demo/red.txt count_demo/blue.txt
ls count_demo
ls count_demo | wc -l
```

這個目錄只有兩個一般檔案。接管線時，ls 每個檔名輸出一行，wc -l 得到 2。
