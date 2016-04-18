\ слова для работы с данными, таблицы, строки, константы и пр.

: AS> ( adr u <name> -- ) \ скопировать данные в текущий сегмент,
    \ запомнить под именем name
    DataType label:
    DUP 1 AND + \ увеличить до чётного количества байт
    OVER + SWAP DO I C@ C>SEG LOOP ;
    
\ манипуляции с байтами на стеке
: |4 ( u --b0 b1 b2 b3 ) \ рассыпать число на 4 байта ( младший ниже по стеку)
    word-split swap byte-split rot byte-split 
    ;
: |3 ( u -- b0 b1 b2 ) \ рассыпать число на 3 байта ( младший ниже по стеку)
    |4 DROP
    ;
: |2 ( u -- b0 b1 ) \ рассыпать число на 2 байта ( младший ниже по стеку)
    byte-split
    ;
 
0 VALUE Deepold \ хранилище глубины стека
: t{ DEPTH TO Deepold ;
: }bytes  DataType label: DEPTH Deepold - 0 SWAP 1-  DO I  ROLL C>SEG -1 +LOOP fingerAlign ; 
: }words  DataType label: DEPTH Deepold - 0 SWAP 1-  DO I  ROLL W>SEG -1 +LOOP fingerAlign ; 
: }cells  DataType label: DEPTH Deepold - 0 SWAP 1-  DO I  ROLL  >SEG -1 +LOOP fingerAlign ; 

\ применение
\ t{ 1 2 3 4 }bytes Счёт \ под именем Счёт в текущем сегменте запишутся байты

