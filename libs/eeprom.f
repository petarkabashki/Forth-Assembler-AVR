\ работа с EEPROM
\ 
finger CONSTANT StartEeprom

code e2RW ( c  ADDR t -- c'  ADDR+1 ) \ запись в EPROM
    \       r0  Z        r0   Z 
    \ t=0 запись
    \ t=1 чтение
    begin wait_nb eepe   \ ждать готовности
[FOUND?] eearH  [IF] out eearH,Zh  [THEN] \ установка адреса   
[FOUND?] eearL  [IF] out eearL,zL  [ELSE] out eear,zL [THEN] \ установка адреса   
    adiW Z,1
    if_t \ чтение
        set_b eere
        in  r0,eedr
    else \ запись
        out eedr,r0   \ установка  байта
        mov r0, SREG cli \ запретить прерывания
           set_b  eempe   set_b  eepe \ запись
        mov SREG,r0  \ вернуть как было
    then
    ret c; \ e2RW val?


code RAM2EE ( X=AddrRam Z=AddrE2 r=n --) \ 
\ скопировать n байт из RAM в EEPROM
\ портит r0
    clt
    for ld r0,x+
        rcall e2RW 
    next r 
    ret c;

code EE2RAM ( Z=AddrE2 X=AddrRam r=n --)
\ скопировать n байт из EEPROM в RAM 
\ портит r0
    set
    for 
        rcall e2RW st x+,r0   
    next r
    ret c;

finger StartEeprom - . .( <==== размер eeprom.f) CR

