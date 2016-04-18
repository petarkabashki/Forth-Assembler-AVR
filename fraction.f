\ fraction действия над простыми дробями
\ дроби представляются парой целых чисел, 
\ порядок на стеке: числитель знаменатель --

: (.) ( u -- ) \ печать числа без пробела в конце
    0 <# #S #> TYPE ;
: NOD ( u1 u2 -- u) \ наибольший общий делитель
   \ ." ."
    TUCK MOD ?DUP IF RECURSE ELSE EXIT THEN ;
    
: NORM ( u1 u2 -- u3 u4) \ нормализация дроби
    2DUP NOD ( u1 u2 d)
    ROT OVER  /
    -ROT / ;
: ./, ( ч з --) \ печать дроби
    DUP 1 = 
    IF DROP . \ целое число    
    ELSE SWAP (.)  ." /" (.) 
    THEN ;
: ./. ( ч з --) \ печать дроби с пробелом
    ./, SPACE ;
: /.  ( ч з --) \ печать нормализованной дроби 
    NORM ./. ;    
: INT/. ( ч з --) \ печать дроби с выделенной целой частью   
    DUP -ROT /MOD 
    ?DUP 
    IF  OVER  
        IF     ." [" (.) ." +" SWAP NORM ./, ." ]"
        ELSE   . 2DROP \ остаток=0
        THEN 
    ELSE SWAP /. \ целое=0
    THEN ;
: /+ ( ч1 з1 ч2 з2 -- сумма-дробь )
    ROT DUP >R -ROT DUP R> =    \ сравнение знаменателей
    IF DROP ROT + SWAP \ частный случай, знаменатели равны
    ELSE ROT 2DUP * >R ROT * >R * R> + R> \ общий случай
    THEN ;
: /- ( ч1 з1 ч2 з2 -- разность-дробь )
    ROT DUP >R -ROT DUP R> =    \ сравнение знаменателей
    IF DROP ROT - SWAP \ частный случай, знаменатели равны
    ELSE ROT 2DUP * >R ROT * >R * R> - R> \ общий случай
    THEN ;
: /* ( ч1 з1 ч2 з2 -- произведение-дробь )
    ROT * >R * R> ;    
: /: ( ч1 з1 ч2 з2 -- частное-дробь )    
    SWAP /* ;
    
 
