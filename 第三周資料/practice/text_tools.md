# sed 與 awk 操作練習

這 20 個步驟先說明下指令的形式，再使用同一份水果銷售資料逐步操作。sed 處理文字；awk 先判斷條件，再處理欄位或計算。

使用本人的普通帳號，不需 sudo。第 2 步會在自己的家目錄建立 `text-lab`。之後沿用同一個 Terminal，位置都是 `$HOME/text-lab`。若中途重開 Terminal，先執行 `cd "$HOME/text-lab"`。

整章保留同一份 `fruit.csv`：一行欄名、五筆資料、數量總和 58。sed 另存的 `cleaned.csv` 用來比對；後面的 awk 仍然讀原本的 `fruit.csv`。

下方 Bash 區塊可複製執行；「語法形式」區塊用來閱讀，先不要執行中文字模板。

## 1. sed 與 awk：先看指令怎麼寫

sed 依規則處理文字；awk 先判斷條件，再對欄位執行動作。先記住兩種形式。

**語法形式（閱讀用）：**

```text
sed '操作規則' fruit.csv
awk -F',' '條件 {動作}' fruit.csv
```

- **sed：規則放在單引號內**：例如選行、刪除輸出列、取代文字。
- **awk：條件在前，動作在後**：符合條件的那一列，才執行 { } 內的動作。
- **-F','：逗號分欄**：fruit.csv 是要讀的檔案；下一頁建立它。

這裡的「操作規則」「條件」「動作」是說明用的文字，後面會換成實際語法。單引號把規則原樣交給指令，不是檔案內容的一部分。

## 2. 建立水果銷售練習檔

建立 fruit.csv：第 1 行是欄名，後面 5 行是銷售資料。每列記錄水果名稱、數量與單價。

```bash
mkdir -p "$HOME/text-lab"
cd "$HOME/text-lab"
echo "name,qty,price" > fruit.csv
echo "apple,10,30" >> fruit.csv
echo "banana,20,15" >> fruit.csv
echo "orange,5,25" >> fruit.csv
echo "apple,15,30" >> fruit.csv
echo "grape,8,40" >> fruit.csv
cat fruit.csv
```

**依指令順序出現的輸出：**

```text
name,qty,price
apple,10,30
banana,20,15
orange,5,25
apple,15,30
grape,8,40
```

- **三個欄位**：name 是水果名稱；qty 是數量；price 是單價。
- **同一檔案，依序練習**：之後都在這個 Terminal、這個資料夾操作。
- **先覆寫，再追加**：第一個 > 重新建立檔案；後面的 >> 依序加到檔尾。

若要重新建立資料，請完整重做本步，讓第一個 > 先重設檔案。只重跑 >> 會造成重複資料。每一欄都沒有逗號或換行，所以後面可直接以逗號分欄。

## 3. sed：規則要寫在哪裡？

sed 的單引號內寫「選哪些行、做什麼」。先認識 p、d、s，接著逐頁實作。

**語法形式（閱讀用）：**

```text
sed '操作規則' fruit.csv
```

**先看一個實例：**

```bash
sed -n '2p' fruit.csv
```

```text
apple,10,30
```

-n 關閉預設輸出，2p 只印第 2 行；下一頁比較有沒有 -n。

- **操作規則**：寫在單引號內，檔名寫在後面。
- **p、d、s**：p 印出；d 刪除輸出列；s 取代文字。
- **每次讀一行**：sed 逐行處理，預設會把每行的處理結果印出。

這裡先認識規則的寫法。實例中的 2p 表示印出第 2 行，-n 讓其他行不自動印出；下一步會比較有沒有 -n 的差別。

## 4. sed：為什麼 p 要搭配 -n？

先執行 2p，觀察第 2 行出現兩次；再加上 -n，讓畫面只留下指定行。

```bash
sed '2p' fruit.csv
sed -n '2p' fruit.csv
```

**依指令順序出現的輸出：**

```text
name,qty,price
apple,10,30
apple,10,30
banana,20,15
orange,5,25
apple,15,30
grape,8,40
apple,10,30
```

- **2p：另外印一次第 2 行**：sed 原本會印所有行；p 又印一次，因此重複。
- **-n：關閉預設輸出**：再由 p 指定要印哪些行。

第一個命令有 7 行輸出：原本 6 行都會印出，第 2 行又被 p 額外印一次。第二個命令只輸出 1 行。兩次都沒有改動 fruit.csv。

## 5. sed：連續三行，還是指定兩行？

先看第 2 至 4 行，再只看第 2 與第 4 行。逗號與分號的意思不同。

```bash
sed -n '2,4p' fruit.csv
sed -n '2p;4p' fruit.csv
```

**依指令順序出現的輸出：**

```text
apple,10,30
banana,20,15
orange,5,25
apple,10,30
orange,5,25
```

- **2,4p：連續範圍**：顯示第 2、3、4 行，包含頭尾。
- **2p;4p：分開的操作**：只顯示第 2 與第 4 行；分號隔開兩個 p。

本練習所有行號都從欄名開始算。第 2、3、4 行分別是 apple、banana、orange。逗號表示連續範圍，分號隔開兩個操作。

## 6. sed：刪掉輸出中的欄名

只要資料列時，可以用 1d 略過第 1 行。接著讀回原檔，確認欄名仍然存在。

```bash
sed '1d' fruit.csv
sed -n '1p' fruit.csv
```

**依指令順序出現的輸出：**

```text
apple,10,30
banana,20,15
orange,5,25
apple,15,30
grape,8,40
name,qty,price
```

- **1d：不輸出第 1 行**：d 處理的是這次輸出的內容。
- **再讀一次原檔**：name,qty,price 仍在，原始資料沒有刪除。

d 讓目前這一行不出現在這次輸出中，其他行仍照常顯示，因此這裡不用 -n。回讀原檔時，欄名仍然存在。

## 7. sed：先預覽文字取代

想把水果名稱 apple 顯示成 mango，先用 s 取代，再讀回原檔確認。

```bash
sed 's/apple/mango/' fruit.csv
sed -n '2p' fruit.csv
```

**依指令順序出現的輸出：**

```text
name,qty,price
mango,10,30
banana,20,15
orange,5,25
mango,15,30
grape,8,40
apple,10,30
```

- **s/原文字/新文字/**：每一行的第一處 apple 改成 mango。
- **先看結果，再決定是否儲存**：畫面上的兩行 apple 已換成 mango；原檔仍是 apple。

s 是 substitute（取代）。每一行都套用相同規則，所以兩筆 apple 都顯示成 mango；不是整份檔案只改一處。這份檔案每行最多一個 apple。

## 8. sed：g 是每行全部取代

同一行出現三次 apple。比較有沒有 g，確認取代範圍。

```bash
echo 'apple apple apple' | sed 's/apple/mango/'
echo 'apple apple apple' | sed 's/apple/mango/g'
```

**依指令順序出現的輸出：**

```text
mango apple apple
mango mango mango
```

- **不加 g**：每一行只取代第一處符合文字。
- **加上 g**：每一行內，所有符合文字都取代。
- **沿用管線 |**：echo 的文字交給 sed，這次不讀 fruit.csv。

g 控制的是每一行內要取代幾處。不加 g 時，每一行也都會處理，只是每行僅取代第一處。本步用 echo 產生單行文字，沒有改動 fruit.csv。

## 9. sed：從行首、行尾比對

先找以 apple, 開頭的資料，再找以 ,30 結尾的資料。

```bash
sed -n '/^apple,/p' fruit.csv
sed -n '/,30$/p' fruit.csv
```

**依指令順序出現的輸出：**

```text
apple,10,30
apple,15,30
apple,10,30
apple,15,30
```

- **^：行首**：^apple, 表示從開頭起，必須是 apple 加逗號。
- **$：行尾**：,30$ 表示這一行必須以逗號加 30 結束。
- **/模式/p**：斜線內寫比對模式；p 印出符合的行。

這裡的 ^、$ 都放在 /模式/ 中，表示行首與行尾。^apple, 不會選到 pineapple 或 applepie 開頭的資料；,30$ 則不會選到以 ,300 結尾的資料。外層單引號讓 Bash 不先解讀這些符號。

## 10. sed：另存結果，保留原檔

把替換結果存成 cleaned.csv，讀回新舊檔；再比較 > 與 >> 如何寫入檔案。

```bash
sed 's/apple/mango/g' fruit.csv > cleaned.csv
sed -n '2p' cleaned.csv
sed -n '2p' fruit.csv
echo "apple" > note.txt
echo "banana" >> note.txt
cat note.txt
```

**依指令順序出現的輸出：**

```text
mango,10,30
apple,10,30
apple
banana
```

- **>：覆寫整個目標檔案**：cleaned.csv 若已有內容，舊內容會全部清除。
- **>>：追加到目標檔尾**：note.txt 先寫 apple，再追加 banana。
- **原檔與輸出檔用不同檔名**：這次讀 fruit.csv，寫 cleaned.csv；原檔仍保留。

sed 負責取代文字，> 負責把全部輸出寫到目標檔案。它不是覆寫某個欄位。第一個命令沒有畫面輸出是正常現象。請使用不同的輸入、輸出檔名；不要把 fruit.csv 同時當輸入檔案及 > 的目標，以免原檔先被清空。

## 11. awk：先寫條件，再寫動作

接下來讀回原本的 fruit.csv，名稱仍是 apple。記住「符合哪些資料，就做什麼」。

**語法形式（閱讀用）：**

```text
awk -F',' '條件 {動作}' fruit.csv
```

**先看一個實例：**

```bash
awk -F',' '$1 == "apple" {print $0}' fruit.csv
```

```text
apple,10,30
apple,15,30
```

先看第 1 欄是否等於 apple；符合才印整行。下一頁拆解 $1 與 $0。

- **awk -F','**：awk 讀檔；-F 指定輸入用逗號分成欄位。
- **'條件 {動作}'**：條件寫前面，動作放 { }；整段放在單引號內。
- **fruit.csv**：最後寫要讀取的檔案。省略條件時，每行都做動作。

awk 的規則放在單引號中，因此 $1 會原樣交給 awk，不是由 Bash 解讀。若省略條件，每行都執行動作。接下來先認識欄位，再逐步加入條件與計算。

## 12. awk：整行與各欄怎麼表示？

先用 $0 讀整行，再用 $1 只讀水果名稱。觀察欄名也會一起印出。

```bash
awk -F',' '{print $0}' fruit.csv
awk -F',' '{print $1}' fruit.csv
```

**依指令順序出現的輸出：**

```text
name,qty,price
apple,10,30
banana,20,15
orange,5,25
apple,15,30
grape,8,40
name
apple
banana
orange
apple
grape
```

- **$0：整行**：保留這一行的原始文字，例如 apple,10,30。
- **$1、$2、$3：第幾欄**：$1 是名稱；$2 是數量；$3 是單價。
- **沒有寫條件**：每行都執行 print，包含欄名；awk 不需加 -n。

$0 是整行，不是「第 0 欄」。對 apple,10,30 這一行來說，$1 是 apple，$2 是 10，$3 是 30。awk 有寫動作時，只執行該動作，不會像 sed 一樣另外自動印出整份資料，所以這裡不用 -n。

## 13. awk：第 1、3 欄與第 1 到 3 欄

先印名稱和單價，再把數量也加進來。比較兩個 print 列了哪些欄位。

```bash
awk -F',' '{print $1,$3}' fruit.csv
awk -F',' '{print $1,$2,$3}' fruit.csv
```

**依指令順序出現的輸出：**

```text
name price
apple 30
banana 15
orange 25
apple 30
grape 40
name qty price
apple 10 30
banana 20 15
orange 5 25
apple 15 30
grape 8 40
```

- **print $1,$3**：印第 1 與第 3 欄，輸出欄位之間預設是空格。
- **print $1,$2,$3**：印第 1 到第 3 欄，要把三欄逐一列出。
- **不要寫 $1-$3 表示範圍**：- 在 awk 裡是減法，不能表示連續欄位。

輸入的 -F',' 只決定讀檔時怎麼分欄。print 的逗號分隔輸出項目，項目之間預設是空格。若需要逗號，可以把逗號當成文字印出。

若希望第 1、3 欄之間仍是逗號，將逗號當成輸出文字：

```bash
awk -F',' '{print $1 "," $3}' fruit.csv
```

```text
name,price
apple,30
banana,15
orange,25
apple,30
grape,40
```

## 14. awk：NR 決定選哪一行

先印行號與整行，再用 NR > 1 略過欄名。行號選列，$1、$2 選欄。

```bash
awk -F',' '{print NR,$0}' fruit.csv
awk -F',' 'NR > 1 {print $1}' fruit.csv
```

**依指令順序出現的輸出：**

```text
1 name,qty,price
2 apple,10,30
3 banana,20,15
4 orange,5,25
5 apple,15,30
6 grape,8,40
apple
banana
orange
apple
grape
```

- **NR：目前讀到第幾行**：第 1 行是欄名；第一筆銷售資料在第 2 行。
- **NR > 1：只選資料列**：先判斷行號，再執行 {print $1}。
- **行與欄要分開看**：NR 決定處理哪一列；$1 決定印哪一欄。

一般文字檔每行一筆紀錄，所以這裡 NR 對應行號。條件 NR > 1 寫在大括號之前，第一行不執行 print。若改成 NR == 3，就只處理第 3 行。

## 15. awk：完全相等，還是包含文字？

查詢水果名稱時，先決定要「第一欄完全相等」，還是「第一欄包含這段文字」。

```bash
awk -F',' '$1 == "apple" {print $0}' fruit.csv
awk -F',' '$1 ~ /app/ {print $0}' fruit.csv
```

**依指令順序出現的輸出：**

```text
apple,10,30
apple,15,30
apple,10,30
apple,15,30
```

- **== "apple"：文字完全相等**：第 1 欄必須剛好是 apple；文字放雙引號內。
- **~ /app/：符合文字模式**：第 1 欄只要包含 app 就符合，也會選到 pineapple。
- **沿用 ^ 與 $**：/^apple$/ 才限定整個欄位剛好是 apple。

兩個命令在這份資料中剛好得到相同結果，但條件不同。假設水果名稱是 pineapple，它不等於 apple，卻包含 app，因此只符合第二個條件。這個例子只用來比較意思，不需要追加到原檔。

## 16. awk：兩個條件怎麼組合？

先找「apple 而且數量是 15」，再選「第 2 行或者第 4 行」。條件可以選資料，也可以選行號。

```bash
awk -F',' '$1 == "apple" && $2 == 15 {print $0}' fruit.csv
awk -F',' 'NR == 2 || NR == 4 {print $1}' fruit.csv
```

**依指令順序出現的輸出：**

```text
apple,15,30
apple
orange
```

- **&&：兩個都成立**：水果是 apple，而且數量是 15；只選到其中一筆 apple。
- **||：至少一個成立**：行號是 2 或 4，才印出該行第 1 欄。
- **判斷完，才執行動作**：符合整個條件的那一列，才執行大括號內的 print。

&& 與 || 放在 awk 的單引號規則內。數字 15 不用雙引號；水果名稱是文字，要使用雙引號。第二個命令用 NR 選第 2 或第 4 行，再用 $1 選要印的欄位，得到 apple 與 orange。

## 17. awk：依數量大小篩選

找數量大於 10 的銷售資料。先排除欄名，再把 qty 當成數字比較。

```bash
awk -F',' 'NR > 1 && $2 > 10 {print $0}' fruit.csv
awk -F',' 'NR > 1 && $2 >= 10 {print $1,$2}' fruit.csv
```

**依指令順序出現的輸出：**

```text
banana,20,15
apple,15,30
apple 10
banana 20
apple 15
```

- **NR > 1**：先略過第 1 行欄名，讓 qty 不參與數字比較。
- **> 與 >=**：> 10 不含 10；>= 10 包含 10。
- **比較數量，不是單價**：$2 是 qty；$3 才是 price。

先排除欄名，避免把文字 qty 拿來做數字大小比較。數量 10 不符合 > 10，但符合 >= 10；數量 20 與 15 則兩者都符合。

## 18. awk：每讀一筆，就累加一次

把每筆 qty 加進 total，並在每次加完後印出目前累計。

```bash
awk -F',' 'NR > 1 {total += $2; print total}' fruit.csv
```

**依指令順序出現的輸出：**

```text
10
30
35
50
58
```

- **total：自己命名的累計變數**：做數字運算時，初值按 0 計算。
- **total += $2**：把這一列的數量加進 total，再存回 total。
- **;：分開兩個動作**：先累加，再印出，所以看到 10、30、35、50、58。

total += $2 就是 total = total + $2。五次累計依序是 0+10、10+20、30+5、35+15、50+8。total 是這次 awk 裡的變數，不需要先在 Bash 宣告。

## 19. awk：讀完後，只印最後總數

上一頁印出每一步的累計。把 print 移到 END 後，就只印全部讀完的結果。

```bash
awk -F',' 'NR > 1 {total += $2} END {print total}' fruit.csv
```

**依指令順序出現的輸出：**

```text
58
```

- **逐列動作：{total += $2}**：符合 NR > 1 的每一列，都把 qty 加進 total。
- **最後動作：END {print total}**：等整份檔案讀完後，只執行一次。
- **58：數量總和**：10 + 20 + 5 + 15 + 8 = 58。

END 要大寫。第一組 { } 每符合一筆就執行，END 後的 { } 等整份資料讀完才執行一次。這次是新的 awk 命令，total 重新開始，不會接續上一步的 58。

## 20. awk：統計筆數，還是數量？

這份檔案有 5 筆銷售資料，總數量是 58。數資料筆數時，每符合一列只加 1。

```bash
awk -F',' 'NR > 1 {total += 1} END {print total}' fruit.csv
awk -F',' '$1 == "apple" {total += 1} END {print total}' fruit.csv
```

**依指令順序出現的輸出：**

```text
5
2
```

- **+= 1：計算資料筆數**：不讀 qty，每一列只讓 total 加 1。
- **加上條件，就只計符合的列**：第 1 欄等於 apple 的資料有 2 筆。
- **和 += $2 不同**：+= $2 算數量總和 58；+= 1 算 5 筆。

第一個命令把每筆資料算成 1，得到 5 筆；第二個命令只計兩筆 apple。每個 awk 命令都各自重新累計。先辨認問題問的是資料筆數，還是欄位的數量總和，再決定加 1 或加 $2。

## 完成後的檔案

- `fruit.csv`：六行，包含一行欄名與五筆銷售資料，名稱仍是 apple。
- `cleaned.csv`：另存的取代結果，apple 已改成 mango。
- `note.txt`：兩行文字 apple、banana，用來比較覆寫與追加。

回到專案二時，再讀專案提供的書目、預約與交接檔。請先看清每欄代表什麼，再選擇條件與動作。

## 參考資料

- [GNU sed：工具概觀](https://www.gnu.org/software/sed/manual/html_node/Overview.html)
- [GNU sed：指定行與範圍](https://www.gnu.org/software/sed/manual/html_node/Addresses.html)
- [GNU sed：文字替換](https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html)
- [GNU awk：欄位](https://www.gnu.org/software/gawk/manual/html_node/Fields.html)
- [GNU awk：條件](https://www.gnu.org/software/gawk/manual/html_node/Pattern-Overview.html)
- [GNU awk：累加與指定值](https://www.gnu.org/software/gawk/manual/html_node/Assignment-Ops.html)
- [GNU awk：END](https://www.gnu.org/software/gawk/manual/html_node/Using-BEGIN_002fEND.html)
- [Bash：輸出重新導向](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
