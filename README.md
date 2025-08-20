# Tile_S AviUtl ExEdit2 スクリプト

規則的なパターン模様を生成するスクリプトです．動画の背景素材などとして利用できます．

[ダウンロードはこちら．](https://github.com/sigma-axis/aviutl2_script_Tile_S/releases)

次のオブジェクトが追加されます:

1.  [四角タイルσ](#四角タイルσ)
1.  [三角タイルσ](#三角タイルσ)
1.  [六角タイルσ](#六角タイルσ)
1.  [菱形タイルσ](#菱形タイルσ)

![使用例](TODO: )

##  動作要件

- AviUtl ExEdit2

  http://spring-fragrance.mints.ne.jp/aviutl

  - `beta7` で動作確認済み．

## 導入方法

以下のフォルダのいずれかに `Tile_S.anm2` をコピーしてください．

1.  スクリプトフォルダ
    - AviUtl2 のメニューの「その他」 :arrow_right: 「アプリケーションデータ」 :arrow_right: 「スクリプトフォルダ」で表示されます．
1.  (1) のフォルダにある任意の名前のフォルダ

初期状態だと「オブジェクトを追加」メニューの「カスタムオブジェクト」に「～タイルσ@Tile_S」が追加されています．
- 「オブジェクト追加メニューの設定」の「ラベル」項目で分類を変更できます．

##  オブジェクトの種類

4種類のオブジェクトが追加されます．

### 四角タイルσ

長方形を並べたパターン模様です．4色に塗り分けられます．

![四角タイルの例](TODO: )

### 三角タイルσ

正三角形を並べたパターン模様です．6色に塗り分けられます．

![三角タイルの例](TODO: )

### 六角タイルσ

正六角形を並べたパターン模様です．3色に塗り分けられます．

![六角タイルの例](TODO: )


### 菱形タイルσ

菱形を並べたパターン模様です．4色に塗り分けられます．

![菱形タイルの例](TODO: )

##  パラメタの説明

![六角タイルのGUI](TODO: )

各オブジェクトごとにパラメタの名前や効果，初期値が微妙に違いますが，基本的な部分は同じです．

### `幅`, `高さ`, `背景サイズ`

オブジェクトのサイズを指定します．`背景サイズ` が ON の場合は，シーンのサイズと同じになり，`幅` と `高さ` は無視されます．

`幅` と `高さ` はピクセル単位で指定，最小値は `0`, 最大値は `4000`, 初期値は `320`.

`背景サイズ` の初期値は OFF.

### `色1`, `色2`, ...

タイル部分の色を，各タイルでそれぞれ指定します．[`ライン幅`](#ライン幅) が指定されている場合は，縁部分の色です．

指定できる色の数は以下の通りです:

| スクリプト名 | 色の数 |
|:---:|:---:|
| [四角タイルσ](#四角タイルσ) | 4 |
| [三角タイルσ](#三角タイルσ) | 6 |
| [六角タイルσ](#六角タイルσ) | 3 |
| [菱形タイルσ](#菱形タイルσ) | 4 |

色の順序は基本的には，[`X`, `Y`](#x-y) で指定した位置の真上から時計回りに並んでいます．

### `内部色1`, `内部色2`, ...

タイル部分の内側の色を，各タイルでそれぞれ指定します．[`ライン幅`](#ライン幅) が指定されている場合の，縁部分より内側の色です．

- 初期状態だと `ライン幅` でタイル全体が覆われているためこの設定は反映されません．`ライン幅` を [`マス幅`](#マス幅-マス高さ) に比べて小さい値を指定してください．

### `透明度1`, `透明度2`, ...

タイル部分の透明度を，各タイルでそれぞれ指定します．透明度を `100` にすると「穴」が空いたような画像になります．

% 単位で指定，最小値は `0.00`, 最大値は `100.00`, 初期値は `0.00`.

### `マス幅`, `マス高さ`, `マス正方形(幅のみで指定)`

各タイルのサイズを指定します．

- `マス高さ` は[四角タイルσ](#四角タイルσ)と[菱形タイルσ](#菱形タイルσ)のみ．
- `マス正方形(幅のみで指定)` は[四角タイルσ](#四角タイルσ)のみ．

正確な意味は以下の通り:

| スクリプト名 | `マス幅` | `マス高さ` |
|:---:|:---|:---|
| [四角タイルσ](#四角タイルσ) | 長方形の横の辺の長さ | 長方形の縦の辺の長さ |
| [三角タイルσ](#三角タイルσ) | 三角形1辺の長さ | - |
| [六角タイルσ](#六角タイルσ) | 六角形の最長の対角線の長さ | - |
| [菱形タイルσ](#菱形タイルσ) | 菱形の横の対角線の長さ | 菱形の縦の対角線の長さ |

`マス正方形(幅のみで指定)` が ON の場合，`マス高さ` が無視され，代わりに `マス幅` が適用されます．

`マス幅` と `マス高さ` はピクセル単位で指定，最小値は `1.0`, 最大値は `2000.0`, 初期値は原則 `64.0` ([菱形タイルσ](#菱形タイルσ)の `マス幅` のみ `96`).

`マス正方形(幅のみで指定)` の初期値は ON.

### `ライン幅`

各タイル部分の縁部分のサイズを指定します．縁部分の色は [`色1` や `色2` など](#色1-色2-)で，内部の色は [`内部色1` や `内部色2` など](#内部色1-内部色2-)で指定します．

[`PI`](#pi) を利用すれば，各タイルごとに個別に指定できます．

ピクセル単位で指定，最小値は `0.0`, 最大値は `1000.0`, 初期値は `1000.0`.

### `角半径`

各タイル部分の角部分を丸めます．丸める場合の曲率半径を指定します．

- 各タイルが真円になる半径が上限で，これ以上は真円のままです．

[`PI`](#pi) を利用すれば，各タイルごとに個別に指定できます．

ピクセル単位で指定，最小値は `0.0`, 最大値は `500.0`, 初期値は `500.0`.

### `余白色`

[`角半径`](#角半径) や [`余白幅`](#余白幅-余白高さ) を指定したときに見える，各タイル間の「隙間」の色を指定します．

初期値は `000000` (黒).

### `余白透明度`

[`角半径`](#角半径) や [`余白幅`](#余白幅-余白高さ) を指定したときに見える，各タイル間の「隙間」の透明度を指定します．

- 各タイルの [`透明度1` など](#透明度1-透明度2-)が高い場合，そこには `余白色` が見えるのではなく，「穴」が空いたような画像になります．

% 単位で指定，最小値は `0.00`, 最大値は `100.00`, 初期値は `100.00`.

### `余白幅`, `余白高さ`

各タイル間の「隙間」のサイズを指定します．余白部分の色や透明度は [`余白色`](#余白色) と [`余白透明度`](#余白透明度) で指定します．

- `余白高さ` は[四角タイルσ](#四角タイルσ)のみ．

[`PI`](#pi) を利用すれば，各タイルごとに個別に指定できます．

ピクセル単位で指定，最小値は `0.0`, 最大値は `2000.0`, 初期値は `0.0`.

### `回転`

タイル模様全体を指定した角度だけ回転できます．回転中心は [`X`, `Y`](#x-y) で指定します．

単位は度数法，最小値は `-720.00`, 最大値は `720.00`, 初期値は `0.00`.

### `X`, `Y`

タイル模様全体を平行移動できます．プレビュー画面のアンカー操作でも設定できます．

ピクセル単位で指定，最小値は `-4000.0`, 最大値は `4000.0`, 初期値は `0.0`.

### `アンチエイリアス`

タイル模様の描画にアンチエイリアスを適用します．[`角半径`](#角半径) や [`回転`](#回転) を適用した際にジャギーさが軽減されます．

初期値は，[四角タイルσ](#四角タイルσ)の場合は OFF, それ以外で ON.

### `PI`

パラメタインジェクション (parameter injection) です．初期値は空欄. テーブル型の中身として解釈され，各種パラメタの代替値として使用されます．また，任意のスクリプトコードを実行する記述領域にもなります．

[`ライン幅`](#ライン幅), [`角半径`](#角半径), [`余白幅`, `余白高さ`](#余白幅-余白高さ) に関しては，タイルごとに個別の設定ができるようにもなります．

- 各タイルごとに指定可能な設定値については，次の記述ができます．

  1.  `line = 3.5` (number 型を指定)

      `ライン幅` をタイル全体で一律に指定．

  1.  `line = { 1.5, 2.5, 3.5, 4.5 }` (table 型で配列を指定)

      `ライン幅` を，1番目のタイルが `1.5`, 2番目が `2.5`, ... と，個別に指定．

  この指定が可能なフィールドには，以下の形式のコメントを記述してあります．
  ```lua
  -- number 型で "色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  ```


####  四角タイルσ の `PI`
```lua
{
  width = width,               -- number 型で "幅" の項目を上書き，または nil.
  height = height,             -- number 型で "高さ" の項目を上書き，または nil.
  screen_size = screen_size,   -- boolean 型で "背景サイズ" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  col = col,                   -- number 型で "色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_inner = col_inner,       -- number 型で "内部色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  alpha = alpha,               -- number 型で "透明度*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  block_w = block_w,           -- number 型で "マス幅" の項目を上書き，または nil.
  block_h = block_h,           -- number 型で "マス高さ" の項目を上書き，または nil.
  block_square = block_square, -- boolean 型で "マス正方形(幅のみで指定)" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  line = line,                 -- number 型で "ライン幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  radius = radius,             -- number 型で "角半径" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_back = col_back,         -- number 型で "余白色" の項目を上書き，または nil.
  alpha_back = alpha_back,     -- number 型で "余白透明度" の項目を上書き，または nil.
  back_w = back_w,             -- number 型で "余白幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  back_h = back_h,             -- number 型で "余白高さ" の項目を上書き，table 型で各タイルごとに指定，または nil.
  rotate = rotate,             -- number 型で "回転" の項目を上書き，または nil.
  X = X,                       -- number 型で "X" の項目を上書き，または nil.
  Y = Y,                       -- number 型で "Y" の項目を上書き，または nil.
  antialias = antialias,       -- boolean 型で "アンチエイリアス" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．


####  三角タイルσ の `PI`
```lua
{
  width = width,             -- number 型で "幅" の項目を上書き，または nil.
  height = height,           -- number 型で "高さ" の項目を上書き，または nil.
  screen_size = screen_size, -- boolean 型で "背景サイズ" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  col = col,                 -- number 型で "色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_inner = col_inner,     -- number 型で "内部色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  alpha = alpha,             -- number 型で "透明度*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  block = block,             -- number 型で "マス幅" の項目を上書き，または nil.
  line = line,               -- number 型で "ライン幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  radius = radius,           -- number 型で "角半径" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_back = col_back,       -- number 型で "余白色" の項目を上書き，または nil.
  alpha_back = alpha_back,   -- number 型で "余白透明度" の項目を上書き，または nil.
  back = back,               -- number 型で "余白幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  rotate = rotate,           -- number 型で "回転" の項目を上書き，または nil.
  X = X,                     -- number 型で "X" の項目を上書き，または nil.
  Y = Y,                     -- number 型で "Y" の項目を上書き，または nil.
  antialias = antialias,     -- boolean 型で "アンチエイリアス" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．


####  六角タイルσ の `PI`
```lua
{
  width = width,             -- number 型で "幅" の項目を上書き，または nil.
  height = height,           -- number 型で "高さ" の項目を上書き，または nil.
  screen_size = screen_size, -- boolean 型で "背景サイズ" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  col = col,                 -- number 型で "色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_inner = col_inner,     -- number 型で "内部色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  alpha = alpha,             -- number 型で "透明度*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  block = block,             -- number 型で "マス幅" の項目を上書き，または nil.
  line = line,               -- number 型で "ライン幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  radius = radius,           -- number 型で "角半径" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_back = col_back,       -- number 型で "余白色" の項目を上書き，または nil.
  alpha_back = alpha_back,   -- number 型で "余白透明度" の項目を上書き，または nil.
  back = back,               -- number 型で "余白幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  rotate = rotate,           -- number 型で "回転" の項目を上書き，または nil.
  X = X,                     -- number 型で "X" の項目を上書き，または nil.
  Y = Y,                     -- number 型で "Y" の項目を上書き，または nil.
  antialias = antialias,     -- boolean 型で "アンチエイリアス" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．


####  菱形タイルσ の `PI`
```lua
{
  width = width,             -- number 型で "幅" の項目を上書き，または nil.
  height = height,           -- number 型で "高さ" の項目を上書き，または nil.
  screen_size = screen_size, -- boolean 型で "背景サイズ" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  col = col,                 -- number 型で "色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_inner = col_inner,     -- number 型で "内部色*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  alpha = alpha,             -- number 型で "透明度*" の項目を上書き，table 型で各タイルごとに指定，または nil.
  block_w = block_w,         -- number 型で "マス幅" の項目を上書き，または nil.
  block_h = block_h,         -- number 型で "マス高さ" の項目を上書き，または nil.
  line = line,               -- number 型で "ライン幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  radius = radius,           -- number 型で "角半径" の項目を上書き，table 型で各タイルごとに指定，または nil.
  col_back = col_back,       -- number 型で "余白色" の項目を上書き，または nil.
  alpha_back = alpha_back,   -- number 型で "余白透明度" の項目を上書き，または nil.
  back = back,               -- number 型で "余白幅" の項目を上書き，table 型で各タイルごとに指定，または nil.
  rotate = rotate,           -- number 型で "回転" の項目を上書き，または nil.
  X = X,                     -- number 型で "X" の項目を上書き，または nil.
  Y = Y,                     -- number 型で "Y" の項目を上書き，または nil.
  antialias = antialias,     -- boolean 型で "アンチエイリアス" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．

##  TIPS

1.  「常に一定方向に流れる背景」を置きたい場合，[`X` や `Y`](#x-y) を「直線移動」で動かすこともできますが，`±4000.0` が範囲限界でそれ以上動かなかったり，流れるスピードがオブジェクトの長さに依存してしまいます．この場合，[`PI`](#pi) に次のように記述すると，範囲限界の影響を受けず，動画やオブジェクトの長さによらず一定のスピードで流すことができます:

    ```lua
    X=20*obj.time+obj.track0,Y=10*obj.time+obj.track1,
    ```

    ここで `20` や `10` には1秒間あたりに流れる移動量を指定します．

##  改版履歴

- **v1.00 (for beta7)** (2025-08-??)

  - 初版．


## ライセンス

このプログラムの利用・改変・再頒布等に関しては MIT ライセンスに従うものとします．

---

The MIT License (MIT)

Copyright (C) 2025 sigma-axis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://mit-license.org/


#  連絡・バグ報告

- GitHub: https://github.com/sigma-axis
- Twitter: https://x.com/sigma_axis
- nicovideo: https://www.nicovideo.jp/user/51492481
- Misskey.io: https://misskey.io/@sigma_axis
- Bluesky: https://bsky.app/profile/sigma-axis.bsky.social
