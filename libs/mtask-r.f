\ мультизадачность, удобно использовать для ожидания события без подвисания программы
\ iva 18.02.2013
\ когда задача вызывает Ago! в списке задач сохраняется адрес возврата в эту задачу
\ и управление передается в задачу вызвавшую текущую задачу
\ когда вызывается Ago@, управление прередается в очередную задачу из списка задач
\ индексы Rid и Wid играют в догонялки в кольцевом буфере, если Rid догнал Wid, значит все отложенные задачи выполнены,
\ если Wid догнал Rid - значит буфер мал и отложенные задачи пропадают
\ ==================== ресурсы ==============================================
\ (...r15)  register: (0)  \ 0 в регистре
\ (...r15)  register: tRid \ индекс чтения списка задач
\ (...r15)  register: tWid \ индекс записи списка задач 
\ 8 constant taskSize \ размер списка задач, кольцевой буфер (кратен степени двойки)
\ ============================================================================

RAM[ taskSize take Tasks \ список адресов  отложенных задач, кольцевой буфер (кратен степени двойки) 
    ]RAM

code Ago! ( ) \ запомнить адрес возврата
\ используются регистры: R, X, XH
\ портится SREG
\ 17 тактов + ret
    mov r,tWid                          \ получить индекс списка задач
    ldiW X,Tasks add xL,tWid adc xH,(0) \ получить адрес свободного места
    addi r,2 andi r,taskSize 1- mov tWid,r        \ сдвинуть индекс записи
    pop r st x+,r  pop r st x+,r        \ сохранить адрес возврата в списке задач
    ret c;                              \ возврат в задачу вызвавшую отложенную
\ ago! val?

code Ago@ ( ) \ вызвать отложенную задачу
\ используются регистры: R, RH, X, XH
\ портится SREG
\ 5 или 22 такта + ret
    \ получить индексы списка задач
    mov r,tRid cp tRid,tWid if= ret then   \ нет отложенных задач    
    ldiW X,Tasks add xL,r adc xH,(0)        \ получить адрес места
    addi r,2 andi r,taskSize 1- mov tRid,r  \ сохранит индекс
    ld rH,x+ ld rL,x+ pushW r               \ подменить адрес возврата
    ret c;                                 \ возврат в отложенную задачу
\ Ago@ val?

