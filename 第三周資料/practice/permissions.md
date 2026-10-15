# 指令練習｜檔案權限與群組

全程在本人具備 sudo 授權的 Terminal 練習，使用 `$HOME/permissions-lab` 的小筆記，不使用專案資料。教師課前已準備 `clerk_amy`、`clerk_ben` 示範帳號及共同群組 `library_staff`。

Terminal 範例中的 `lab_teacher` 是示範帳號，請以自己實際的帳號與群組為準。行首 `$` 是提示符號，不需輸入。建立檔案與成功追加的步驟只做一次，後續沿用既有檔案。

## 建立工作筆記

先留下原文，再補上一行；每次寫入後都讀回確認。

```bash
mkdir -p "$HOME/permissions-lab"
cd "$HOME/permissions-lab"
echo "My notes" > note.txt
echo "First addition" >> note.txt
cat note.txt
```

Terminal 範例：

```text
$ mkdir -p "$HOME/permissions-lab"
$ cd "$HOME/permissions-lab"
$ echo "My notes" > note.txt
$ echo "First addition" >> note.txt
$ cat note.txt
My notes
First addition
```

> 建立或覆寫；>> 在檔案末端追加。以下沿用這一份筆記。

同一個 Terminal 會記住目前目錄；接下來都留在 `permissions-lab`。

## ls -l：查看檔案資訊

先看擁有者、群組與最左邊的權限字串。

```bash
ls -l note.txt
```

Terminal 範例：

```text
$ ls -l note.txt
-rw-r--r-- 1 lab_teacher lab_teacher 24 Oct 15 09:00 note.txt
```

由左到右：權限、連結數、擁有者、群組、大小、修改時間、檔名。

## chmod：取消自己的寫入權

把這份筆記設成自己只能讀取，觀察下一次追加會發生什麼。

```bash
chmod u-w note.txt
ls -l note.txt
```

Terminal 範例：

```text
$ chmod u-w note.txt
$ ls -l note.txt
-r--r--r-- 1 lab_teacher lab_teacher 24 Oct 15 09:00 note.txt
```

u 是檔案擁有者；-w 取消寫入權。其他兩組權限保持原樣。

## 讀取與追加

同一個帳號、同一份檔案，先讀原文，再試著補上新一行。

```bash
cat note.txt
echo "Second addition" >> note.txt
```

Terminal 範例：

```text
$ cat note.txt
My notes
First addition
$ echo "Second addition" >> note.txt
bash: note.txt: Permission denied
```

能讀不代表能寫。剛才取消了擁有者的 w，所以追加遭到拒絕。

## chmod：恢復自己的寫入權

恢復寫入權，再完成剛才沒有成功的追加。

```bash
chmod u+w note.txt
echo "Second addition" >> note.txt
cat note.txt
```

Terminal 範例：

```text
$ chmod u+w note.txt
$ echo "Second addition" >> note.txt
$ cat note.txt
My notes
First addition
Second addition
```

u+w 增加擁有者的寫入權；原有兩行仍然保留。

## 檔案權限的三組對象

### -rw-r-----

- 第一個 -：一般檔案
- u：擁有者 rw-
- g：檔案群組 r--
- o：其他人 ---

### 依執行帳號選一組

- 是擁有者：看 u
- 不是擁有者，但屬於檔案群組：看 g
- 以上都不是：看 o
- r 可讀；w 可寫；x 可執行

一般帳號依身分選用一組權限；不要把三組權限相加。

## 群組

同一個群組可以包含多個帳號，讓這些帳號共用同一組檔案權限。

- **本課已準備的示範帳號**：Amy：clerk_amy；Ben：clerk_ben。兩人都是 library_staff 的成員。
- **檔案也有自己的群組**：檔案群組是 library_staff 時，這兩位館員都用 g 這一組權限判斷能否讀寫。

## id、groups：查詢帳號與群組

先查本人，再查教師準備好的 Amy 帳號。

```bash
id -un
groups
id -un clerk_amy
groups clerk_amy
```

Terminal 範例：

```text
$ id -un
lab_teacher
$ groups
lab_teacher sudo
$ id -un clerk_amy
clerk_amy
$ groups clerk_amy
clerk_amy : library_staff
```

不加帳號查本人；加帳號查指定的人。群組名稱以實際輸出為準。

## sudo：以管理身分執行一個指令

本課使用已具備 sudo 授權的本人帳號。先查授權，再比較執行身分。

```bash
sudo -l
sudo whoami
whoami
```

Terminal 範例：

```text
$ sudo -l
    (ALL : ALL) ALL
$ sudo whoami
root
$ whoami
lab_teacher
```

sudo -l 的清單因環境而異；上方只顯示其中一種授權行。

## 建立管理員的筆記副本

用管理身分複製剛才的筆記，再取消群組與其他人的讀寫權。

```bash
sudo cp note.txt admin-note.txt
sudo chmod go-rw admin-note.txt
ls -l admin-note.txt
```

Terminal 範例：

```text
$ sudo cp note.txt admin-note.txt
$ sudo chmod go-rw admin-note.txt
$ ls -l admin-note.txt
-rw------- 1 root root 40 Oct 15 09:00 admin-note.txt
```

新的副本由 root 建立，所以擁有者是 root。go-rw 取消群組及其他人的讀寫權。

## 讀取管理員的筆記

先用本人身分讀取，再由有授權的管理員讀取同一份副本。

```bash
cat admin-note.txt
sudo cat admin-note.txt
```

Terminal 範例：

```text
$ cat admin-note.txt
cat: admin-note.txt: Permission denied
$ sudo cat admin-note.txt
My notes
First addition
Second addition
```

本人不是擁有者，g 和 o 都沒有 r；sudo cat 由 root 讀取。

## chgrp：更改檔案的群組

這份副本接下來要交給館員群組。先看群組，再由管理員更改。

```bash
ls -l admin-note.txt
sudo chgrp library_staff admin-note.txt
ls -l admin-note.txt
```

Terminal 範例：

```text
$ ls -l admin-note.txt
-rw------- 1 root root 40 Oct 15 09:00 admin-note.txt
$ sudo chgrp library_staff admin-note.txt
$ ls -l admin-note.txt
-rw------- 1 root library_staff 40 Oct 15 09:00 admin-note.txt
```

chgrp 改的是檔案的群組欄位；不會把使用者加入群組，也不會自動增加 r 或 w。

## chmod：增加群組的讀取權

群組已改成 library_staff，再給這個群組讀取權。

```bash
sudo chmod g+r admin-note.txt
ls -l admin-note.txt
```

Terminal 範例：

```text
$ sudo chmod g+r admin-note.txt
$ ls -l admin-note.txt
-rw-r----- 1 root library_staff 40 Oct 15 09:00 admin-note.txt
```

g+r 增加群組的 r；g+w 才是增加群組的寫入權。

## ls -ld：查看資料夾本身

檔案有讀取權時，也要能通過它所在的每一層資料夾。

```bash
ls -ld .
```

Terminal 範例：

```text
$ ls -ld .
drwxr-xr-x 2 lab_teacher lab_teacher 4096 Oct 15 09:00 .
```

資料夾 x：通過；w：新增或刪除檔名。
已有檔案的內容能否寫，另看該檔案的 w。

## sudo -u：讓指定帳號執行一個指令

仍由你在同一個 Terminal 輸入。指定 Amy 後，只影響後面這一個指令。

```bash
sudo -u clerk_amy whoami
sudo -u clerk_amy groups
whoami
```

Terminal 範例：

```text
$ sudo -u clerk_amy whoami
clerk_amy
$ sudo -u clerk_amy groups
library_staff
$ whoami
lab_teacher
```

格式：sudo -u 帳號 指令。指令結束後，下一行仍由本人輸入。

## nano：開啟唯讀檔案

回到本人筆記。先取消自己的寫入權，再以 nano 補上一行。

```bash
chmod u-w note.txt
ls -l note.txt
nano note.txt
```

Terminal 範例：

```text
$ chmod u-w note.txt
$ ls -l note.txt
-r--r--r-- 1 lab_teacher lab_teacher 40 Oct 15 09:00 note.txt
$ nano note.txt
[ File 'note.txt' is unwritable ]
```

在末尾輸入 Nano addition；下一頁試著儲存。

## nano：確認儲存被拒絕

畫面裡能輸入文字，仍然需要檔案的寫入權才能儲存。

- **嘗試儲存**：按 Ctrl+O，再按 Enter。預期看到 Permission denied，代表檔案還沒更新。
- **離開本次編輯**：按 Ctrl+X；詢問是否儲存時按 N，放棄這次未成功的修改。

## nano：取得寫入權後重新儲存

恢復本人寫入權，再補上剛才沒有存進去的一行。

```bash
chmod u+w note.txt
nano note.txt
cat note.txt
```

Terminal 範例：

```text
$ chmod u+w note.txt
$ nano note.txt
$ cat note.txt
My notes
First addition
Second addition
Nano addition
```

nano 內新增 Nano addition；Ctrl+O、Enter 儲存，Ctrl+X 離開，才輸入 cat。

先在 nano 新增一行，完成儲存與離開後才輸入 `cat`。

接著完成 [sed 與 awk 文字處理練習](text_tools.md)，再閱讀 [專案二題目](../projects/project2.md)。
