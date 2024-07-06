;MATH.H
;Simple math library for TASM by Anders Granlund
;- - - - - - - - - - - - - - - - - - - - - - - -
; mult		- Multiply A  * B  -> A
; mult16_8	- Multiply HL * A  -> HL
; div		- Divide   A  / B  -> A
;		- Modula   A  % B  -> B
; div16_8	- Divide   HL / A  -> A
;		- Modula   HL / A  -> B

;*****************************************
;MULT - Multiply A*B and store result in A
;*****************************************
mult:
  push de
  ld d,a		;D = x
  cp 0
  jr z,multzero
  ld a,b		;A = y
  cp 0
  jr nz,multok1
multzero:
  ld a,0
  pop de
  ret
multok1:
  ld a,d		;A = x, D = x, B = y
multloop:
  dec b
  jr z,multdone
  add a,d
  jr multloop
multdone:
  pop de
  ret
;**************************************
;DIV - Divide A/B and store result in A
;      returns modula (A%B) -> B
;      Destroys C !!!
;**************************************
div:
  cp b
  jr nc,dodiv1
  ld b,a
  ld a,0
  ret
dodiv1:
  ld c,0
dodiv:
  inc c			; c = c + 1
  sub b			; a = a - b
  cp b
  jr nc,dodiv
  ld b,a
  ld a,c
  ret


;******************************
;MULT16	- Multiply HL * A -> HL
;******************************
mult16_8:
  cp 0			;A = 0?
  jr nz,mult16_8_test2
  ld hl,0
  ret
mult16_8_test2:
  push bc
  ld b,a
  ld a,h
  or l
  cp 0			;HL = 0?
  jr nz,domult16_8a	;No, go on
  pop bc
  ret			;Yes, return
domult16_8a:
  push de
  ld d,h
  ld e,l		;DE=HL
domult16_8b:
  dec b
  jr z,mult16_8done
  add hl,de
  jr domult16_8b
mult16_8done:
  pop de
  pop bc
  ret

;***********************************
;DIV16_8	- Divide HL / A -> A
;		- Modula HL % A -> B
;Destroys C!!!
;***********************************
div16_8:
  push de
  ld b,0
  ld c,a
  neg
  ld e,a
  ld d,-1	;DE = -A
div16_8loop:
  inc b
  add hl,de	;HL = HL - DE
  ld a,h
  cp 0
  jr nz,div16_8loop   
  ld a,l
  cp c
  jr nc,div16_8loop
  ld a,b
  ld b,l
  pop de
  ret
  
   
  



  



  
