# sezemi-2014-readable-code-1

## 使い方

  Usage: manage-recipe [options]
          --recipe-id=ID               Specify recipe ID
          --recipe-files=FILE1,FILE2,FILE3
                                       Specify recipe data file
          --user-id=ID                 User ID

## データの形式

YAML を使う。

~~~
---
kou:
  1:
    - オムライス
    - https://example.com/1
  2:
    - 親子丼
    - https://example.com/2
  3:
    - 杏仁豆腐
    - https://example.com/3
~~~

のような形式とする。
