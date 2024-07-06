;***
;*** GB-CHIP8 Emulator ver0.6
;*** Written by Anders Granlund in 1998
;***
;*** This program is free software:
;*** you can redistribute it and/or modify it under the terms of the GNU General Public License
;*** as published by the Free Software Foundation, ;*** either version 2 of the License,
;*** or (at your option) any later version.
;*** 
;*** This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
;*** without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;*** See the GNU General Public License for more details.
;*** 
;*** You should have received a copy of the GNU General Public License along with this program.
;*** If not, see <https://www.gnu.org/licenses/>.
;***



;*** constants ***
DOUBLE_SCREEN           .EQU 1
VER1                    .EQU 0
VER2                    .EQU 6

;*** Chip8 memory ($C000 - $DBFF) ***
chipmem                 .EQU $C000
char_0                  .EQU chipmem
char_1                  .EQU chipmem+6
char_2                  .EQU chipmem+12
char_3                  .EQU chipmem+18
char_4                  .EQU chipmem+24
char_5                  .EQU chipmem+30
char_6                  .EQU chipmem+36
char_7                  .EQU chipmem+42
char_8                  .EQU chipmem+48
char_9                  .EQU chipmem+54
char_A                  .EQU chipmem+60
char_B                  .EQU chipmem+66
char_C                  .EQU chipmem+72
char_D                  .EQU chipmem+78
char_E                  .EQU chipmem+84
char_F                  .EQU chipmem+92

memvar                  .EQU $DA01
;*** Chip8 registers ***
v0                      .EQU memvar
v1                      .EQU memvar+1
v2                      .EQU memvar+2
v3                      .EQU memvar+3
v4                      .EQU memvar+4
v5                      .EQU memvar+5
v6                      .EQU memvar+6
v7                      .EQU memvar+7
v8                      .EQU memvar+8
v9                      .EQU memvar+9
vA                      .EQU memvar+10
vB                      .EQU memvar+11
vC                      .EQU memvar+12
vD                      .EQU memvar+13
vE                      .EQU memvar+14
vF                      .EQU memvar+15
DT                      .EQU memvar+16
ST                      .EQU memvar+17
I_h                     .EQU memvar+18
I_l                     .EQU memvar+19
chipSP                  .EQU memvar+20
chipPC_h                .EQU memvar+21  ;PC high byte
chipPC_l                .EQU memvar+22  ;PC low byte
chipSTACK               .EQU memvar+30  ;memvar 30 - 62
skip_next               .EQU memvar+70
keypressed              .EQU memvar+71
hpflag0                 .EQU memvar+72
hpflag1                 .EQU memvar+73
hpflag2                 .EQU memvar+74
hpflag3                 .EQU memvar+75
hpflag4                 .EQU memvar+76
hpflag5                 .EQU memvar+77
hpflag6                 .EQU memvar+78
hpflag7                 .EQU memvar+79


;*** Variables used by the emulator ***
temp1                   .EQU memvar+80
temp2                   .EQU memvar+81
temp3                   .EQU memvar+82
temp4                   .EQU memvar+83
temp5                   .EQU memvar+84
temp6                   .EQU memvar+85
temp7                   .EQU memvar+86
temp8                   .EQU memvar+87
temp9                   .EQU memvar+88

op_h                    .EQU memvar+89  ;high byte of opcode
op_l                    .EQU memvar+90  ;low byte of opcode
op1                     .EQU memvar+91  ;first 4bits
op2                     .EQU memvar+92  ;second 4bits
op3                     .EQU memvar+93  ;third 4bits
op4                     .EQU memvar+94  ;fourth 4bits
emu_running             .EQU memvar+95
yint                    .EQU memvar+96

rnd_pos                 .EQU memvar+97  ;Position in the random nr. table
menu                    .EQU memvar+98


;*** Joypad settings ***
joypad                  .EQU memvar+100
pad_A                   .EQU joypad+$1
pad_B                   .EQU joypad+$2
pad_SELECT              .EQU joypad+$4
pad_START               .EQU joypad+$8
pad_RIGHT               .EQU joypad+$10
pad_LEFT                .EQU joypad+$20
pad_UP                  .EQU joypad+$40
pad_DOWN                .EQU joypad+$80


nr_of_games             .EQU memvar+400 ;- Number of games in the menu
game_selected           .EQU memvar+401 ;-

game1                   .EQU memvar+402 ;)
game2                   .EQU memvar+410 ;)
game3                   .EQU memvar+418 ;)
game4                   .EQU memvar+426 ;)
game5                   .EQU memvar+434 ;) The names (8 chars) for the
game6                   .EQU memvar+442 ;) different games are stored
game7                   .EQU memvar+450 ;) in theese variables
game8                   .EQU memvar+458 ;)
game9                   .EQU memvar+466 ;)
game10                  .EQU memvar+474 ;)
game11                  .EQU memvar+482 ;)

cursY                   .EQU memvar+490 ;)
cursdir                 .EQU memvar+491 ;)
cursmoved               .EQU memvar+492 ;)
max_select              .EQU memvar+493 ;) Theese variables handles
menu_move_size          .EQU memvar+494 ;) the different menus in
sin_cnt                 .EQU memvar+495 ;) the emulator, as well as
cursX                   .EQU memvar+496 ;) the cursors...
selected                .EQU memvar+497 ;)
joystore                .EQU memvar+498 ;)

schip_on                .EQU memvar+500

force_schip             .EQU memvar+501 ;)
sound_on                .EQU memvar+502 ;) This is the variables for
collissions_on          .EQU memvar+503 ;) the OPTIONS menu.
chip8_delay             .EQU memvar+504 ;)






.org	0
.db "[ Anders Granlund 1998 ]"
.db 13,10

.org $40
  jp VBL_int
  reti
.org $48
  jp LCDC_int
  reti
.org $50
  reti
.org $58
  reti
.org $60
  reti


.org $100
  nop
  jp begin

;Nintendo Scrolling Title Graphic
;***********************************************
.byte	0ceh,0edh,66h,66h,0cch,13,0,11,3,73h
.byte	0,83h,0,12,0,13,0,8,17,31,88h,89h,0
.byte	14,0dch,0cch,6eh,0e6h,0ddh,0ddh,0d9h
.byte	99h,0bbh,0bbh,67h,63h,6eh,0eh,0ech,0cch
.byte	0ddh,0dch,99h,09fh,0bbh,0b9h,33h,3eh
;***********************************************

.byte   "CHIP-8 Emulator "              ;Title of the game
.byte   0,0,0                           ;Not used
.byte   1                               ;Cartridge type: Rom only
					; 0 - Rom only      3 - ROM+MBC1+RAM+Battery
					; 1 - ROM+MBC1      5 - ROM+MBC2
					; 2 - ROM+MBC1+RAM  6 - ROM+MBC2+Battery
.byte   1                               ;Rom Size:
					; 0 - 256kBit =  32kB =  2 banks
					; 1 - 512kBit =  64kB =  4 banks
					; 2 -   1MBit = 128kB =  8 banks
					; 3 -   2MBit = 256kB = 16 banks
					; 4 -   4MBit = 512kB = 32 banks
.byte   0				;Ram Size:
					; 0 - None
					; 1 -  16kBit =  2kB = 1 bank
					; 2 -  64kBit =  8kB = 1 bank
					; 3 - 256kBit = 32kB = 4 banks
.byte   "A","G"                       ;Manufacturer code:
.byte	1				;Version Number
.byte	0ah				;Complement check
.word	0				;Checksum






begin:
  di
  ld a,%01010000                ;set lcdc + vbl int
  ldh ($41),a
  ld a,%00000011
  ldh ($FF),a			;We want LCDC int + Vblank
  xor a
  ldh ($40),a			;Turn screen off
  ldh ($42),a			;Scroll X
  ldh ($43),a			;Scroll Y
  ld a,%11100100		;"normal" colours
  ldh ($47),a			;BG palette
  ldh ($48),a			;OBJ0 palette
  ldh ($49),a			;OBJ1 palette

  xor a
  ld (ST),a
  ldh ($26),a
  ld (schip_on),a
  ld (force_schip),a

  ld a,$FF
  ld (sound_on),a
  ld (collissions_on),a
  call read_pad_settings        ;read the joypad settings

;**** Delay variable for CHIP8 games ***
  ld a,150
  ld (chip8_delay),a
;***************************************

  xor a
  ld hl,$9800
  ld b,32
clrmap1:
  ld c,32
clrmap2:
  call wrAtohl
  inc hl
  dec c
  jr nz,clrmap2
  dec b
  jr nz,clrmap1

  ld hl,chip_tiles
  call load_tiles

  ld a,%11010001
  ldh ($40),a                   ;turn screen ON


;*********************************************
;*** Check if CHIP8 Multicart Menu is used ***
;*********************************************
  ld a,2
  ld ($2000),a  ;bank=2
  xor a
  ld (menu),a   ;menu = OFF
  ld hl,$4000
  ld a,(hli)
  cp 67
  jr nz,nomenu
  ld a,(hli)
  cp 72
  jr nz,nomenu
  ld a,(hli)
  cp 73
  jr nz,nomenu
  ld a,(hli)
  cp 80
  jr nz,nomenu
  ld a,(hli)
  cp 56
  jr nz,nomenu
  ld a,1
  ld (menu),a                   ;menu = ON
  ld a,(hli)
  ld (nr_of_games),a            ;load nr_of_games
  ld c,a                        ;C = number of games
  ld de,game1                   ;dest. = game1
load_game_names:
  ld b,8                        ;8 chars / name
load_one_game_name:
  ld a,(hli)
  ld (de),a
  inc de
  dec b
  jr nz,load_one_game_name
  dec c
  jr nz,load_game_names         ;All names loaded!

nomenu:
  ld a,1
  ld ($2000),a  ;BANK = 1





;**************************************
;*** Multicart detected, show menus ***
;**************************************

;*********************
;*** THE MAIN MENU ***
;*********************
MAIN_MENU:
  call readpad
  cp 0
  jr nz,MAIN_MENU
  di

  call erase_screen

  xor a
  ld (emu_running),a
  ldh ($42),a
  ld (schip_on),a

  ld a,%00000011
  ldh ($FF),a			;We want LCDC int + Vblank

  xor a
  ld hl,$FE02
  ld (hl),a
  ld hl,$FE06
  ld (hl),a
  ld hl,$FE0A
  ld (hl),a
  ld hl,$FE0E
  ld (hl),a
  ld a,%11010001
  ldh ($40),a                   ;turn sprites OFF


  ld hl,main_menu_map
  call load_map2
  ld a,16
  ld (menu_move_size),a
  xor a
  ld (cursdir),a
  ld (cursmoved),a
  ld (emu_running),a
  ld (game_selected),a
  ld a,3
  ld (max_select),a
  ld a,40
  ld (cursY),a
  xor a
  ld (yint),a
  ldh ($45),a
  ei
main_m_loop:
  ld bc,1024
main_m_wait:
  dec bc
  ld a,b
  or c
  cp 0
  jr nz,main_m_wait

  call readpad
  cp $40
  call z,m_joyup
  call readpad
  cp $80
  call z,m_joydown
  call readpad
  cp $1
  jp z,main_m_start
  cp $2
  jp z,main_m_start
  cp $8
  jp z,main_m_start
main_m_move:
  ld a,(cursmoved)
  cp 0
  jp z,main_m_loop
  ld a,(cursmoved)
  dec a
  ld (cursmoved),a
  ld a,(cursdir)
  cp 8
  call z,moveup
  ld a,(cursdir)
  cp 2
  call z,movedown
  jp main_m_loop
main_m_start:
  ld a,(cursmoved)
  cp 0
  jp nz,main_m_move
  ld a,(game_selected)
  cp 0
  jp z,GAME_MENU
  cp 1
  jp z,JOYPAD_MENU
  cp 2
  jp z,OPTIONS_MENU
  cp 3
  jp z,ABOUT_MENU
  jp main_m_loop


OPTIONS_MENU:
  call readpad
  cp 0
  jr nz,OPTIONS_MENU
  di
  ld a,0
  ldh ($42),a
  ld a,%11100100
  ldh ($47),a


  ld hl,options_menu_map
  call load_map2
  call write_opt_txt
  ld a,4
  ld (max_select),a
  ld a,40
  ld (cursY),a
  xor a
  ld (cursdir),a
  ld (cursmoved),a
  ld (emu_running),a
  ld (game_selected),a
  ld (yint),a
  ldh ($45),a
  ei
opt_m_loop:
  ld bc,1024
opt_m_wait:
  dec bc
  ld a,b
  or c
  cp 0
  jr nz,opt_m_wait

  call readpad
  cp $40
  call z,m_joyup
  call readpad
  cp $80
  call z,m_joydown

  call readpad
  cp $20
  jp z,opt_left
  cp $10
  jp z,opt_right

  call readpad
  cp $1
  jp z,opt_m_start
  cp $2
  jp z,opt_m_start
  cp $8
  jp z,opt_m_start
  cp $4
  jp z,MAIN_MENU
opt_m_move:
  ld a,(cursmoved)
  cp 0
  jp z,opt_m_loop
  ld a,(cursmoved)
  dec a
  ld (cursmoved),a
  ld a,(cursdir)
  cp 8
  call z,moveup
  ld a,(cursdir)
  cp 2
  call z,movedown
  jp opt_m_loop
opt_m_start:
  ld a,(cursmoved)
  cp 0
  jp nz,opt_m_move
  ld a,(game_selected)
  cp 0
  jp z,opt1_press
  cp 1
  jp z,opt2_press
  cp 2
  jp z,opt3_press
  cp 4
  jp z,MAIN_MENU
  jp opt_m_loop

opt1_press:
  ld a,(sound_on)
  cpl
  ld (sound_on),a
  call write_opt_txt
opt_wt_wait1:
  call readpad
  cp 0
  jr nz,opt_wt_wait1
  jp opt_m_loop
opt2_press:
  ld a,(collissions_on)
  cpl
  ld (collissions_on),a
  call write_opt_txt
opt_wt_wait2:
  call readpad
  cp 0
  jr nz,opt_wt_wait2
  jp opt_m_loop
opt3_press:
  ld a,(force_schip)
  cpl
  ld (force_schip),a
  call write_opt_txt
opt_wt_wait3:
  call readpad
  cp 0
  jr nz,opt_wt_wait3
  jp opt_m_loop

opt_left:
  ld a,(game_selected)
  cp 3
  jp nz,opt_m_loop
  ld a,250
opt_l_w:
  dec a
  jr nz,opt_l_w
  ld a,(chip8_delay)
  cp 0
  jp z,opt_m_loop
  ld b,10
  sbc a,b
  ld (chip8_delay),a
  call write_opt_txt
  jp opt_m_loop
opt_right:
  ld a,(game_selected)
  cp 3
  jp nz,opt_m_loop
  ld a,250
opt_r_w:
  dec a
  jr nz,opt_r_w
  ld a,(chip8_delay)
  cp 250
  jp z,opt_m_loop
  ld b,10
  add a,b
  ld (chip8_delay),a
  call write_opt_txt
  jp opt_m_loop


write_opt_txt:
  ld a,(sound_on)
  cp 0
  call z,offtohl
  cp $FF
  call z,ontohl
  ld d,15
  ld e,5
  ld a,3
  call writetext

  ld a,(collissions_on)
  cp 0
  call z,offtohl
  cp $FF
  call z,ontohl
  ld d,15
  ld e,7
  ld a,3
  call writetext

  ld a,(force_schip)
  cp 0
  call z,offtohl
  cp $FF
  call z,ontohl
  ld d,15
  ld e,9
  ld a,3
  call writetext

  ld hl,$9800+((32*11)+15)
  ld a,(chip8_delay)
  ld b,10
  call div
  ld d,a
  ld b,10
  call div
  ld e,a
  ld b,137
  add a,b
  call wrAtohl

  inc hl

  ld a,e
  ld b,10
  call mult
  ld b,a
  ld a,d
  sbc a,b
  ld b,137
  add a,b
  call wrAtohl

  inc hl
  xor a
  ld b,137
  add a,b
  call wrAtohl

  ret
ontohl:
  push af
  ld hl,txt_on
  pop af
  ret
offtohl:
  push af
  ld hl,txt_off
  pop af
  ret
txt_on:
.db " ON"
txt_off:
.db "OFF"





;***************************
;*** CONFIG. JOYPAD MENU ***
;***************************
JOYPAD_MENU:
  call readpad
  cp 0
  jr nz,JOYPAD_MENU
  di
  xor a                 ;Clear all sprites
  ld ($FE02),a
  ld ($FE06),a
  ld ($FE0A),a
  ld ($FE0E),a
  ld ($FE12),a
  ld ($FE16),a
  ld ($FE1A),a
  ld ($FE1E),a
  ld ($FE22),a
  ld ($FE26),a
  ld ($FE2A),a
  ld ($FE2E),a
  ld ($FE32),a
  ld ($FE36),a
  ld ($FE3A),a
  ld ($FE3E),a
  ld ($FE42),a
  ld ($FE46),a
  ld ($FE4A),a
  ld ($FE4E),a
  ld ($FE52),a
  ld ($FE56),a
  ld ($FE5A),a
  ld ($FE5E),a
  ld ($FE62),a
  ld ($FE66),a
  ld ($FE6A),a
  ld ($FE6E),a
  ld ($FE72),a
  ld ($FE76),a
  ld ($FE7A),a
  ld ($FE7E),a
  ld ($FE82),a
  ld ($FE86),a
  ld ($FE8A),a
  ld ($FE8E),a
  ld ($FE92),a
  ld ($FE96),a
  ld ($FE9A),a
  ld ($FE9E),a

  ld a,0
  ldh ($42),a
  ld a,%11100100
  ldh ($47),a
  ld a,%11010111
  ldh ($40),a           ;sprite ON

  ld a,52
  ld (cursY),a
  ld a,20
  ld (cursX),a
  ld a,0
  ld (selected),a
  ld (joystore),a

  ld hl,joypad_menu_map
  call load_map

  ld d,17
  ld e,4
  ld a,1
  ld hl,txt_questionmark
  call writetext

joy_m_loop:
  call readpad
  cp 0
  jr nz,joy_m_loop

  call waitvbl
  ld bc,1024
joy_m_wait:
  dec bc
  ld a,b
  or c
  cp 0
  jr nz,joy_m_wait
  call joy_draw_curs

  call readpad
  cp $40
  jp z,joy_up
  cp $80
  jp z,joy_down
  cp $20
  jp z,joy_left
  cp $10
  jp z,joy_right

  call readpad
  cp $4                 ;[select] ?
  jp z,MAIN_MENU        ;yes, goto main_menu
  cp $1
  jp z,joy_m_but
  cp $2
  jp z,joy_m_but
  cp $8
  jp z,joy_m_but
  jp joy_m_loop


joy_m_but:
  call readpad
  cp 0
  jr nz,joy_m_but

  ld a,(cursX)
  ld b,8
  call div
  ld d,a                ;d = xpos
  ld a,(cursY)
  ld b,8
  call div
  dec a
  ld b,a

  ld hl,$9800
  ld e,d
  ld d,0
  add hl,de             ;xpos set
  ld a,b
  cp 0
  jr z,nosetyjmcp
  ld de,32
joy_m_but_setcp:
  add hl,de
  dec b
  jr nz,joy_m_but_setcp
nosetyjmcp:
  push hl

  ld a,(selected)
  ld hl,keymap
  call add_hl_a
  ld a,(hl)
  ld b,193
  add a,b
  pop hl
  call wrAtohl


  ld a,(selected)
  ld hl,txt_keymap
  ld e,a
  ld d,0
  add hl,de             ;HL = caracter

  ld a,(joystore)
  ld b,4
  add a,b
  cp 8
  jr c,nodbljs2
  inc a
nodbljs2:
  ld e,a                ;E  = Ypos
  ld d,17               ;D  = Xpos
  ld a,1                ;A  = length
  call writetext

  ld a,(joystore)
  ld hl,joymap
  call add_hl_a
  ld a,(hl)
  ld e,a
  ld d,0
  ld hl,joypad
  add hl,de             ;HL = adress to store in
  ld b,h
  ld c,l
  ld a,(selected)
  ld hl,keymap
  ld e,a
  ld d,0
  add hl,de
  ld a,(hl)
  ld h,b
  ld l,c
  ld (hl),a
  ld a,(joystore)
  inc a
nodblinc:
  ld (joystore),a
  cp 8
  jp z,joy_config_end

  ld a,(joystore)
  ld b,4
  add a,b
  cp 8
  jr c,noincjst
  inc a

noincjst:
  ld e,a                ;E  = Ypos
  ld d,17               ;D  = Xpos
  ld hl,txt_questionmark
  ld a,1                ;A  = length
  call writetext
  jp joy_m_loop



joy_left:
  ld a,(selected)
  cp 0
  jp z,joy_m_loop
  cp 4
  jp z,joy_m_loop
  cp 8
  jp z,joy_m_loop
  cp 12
  jp z,joy_m_loop
  ld a,(selected)
  dec a
  ld (selected),a
  ld a,(cursX)
  ld b,16
  sub b
  ld (cursX),a
  jp joy_m_loop
joy_right:
  ld a,(selected)
  cp 3
  jp z,joy_m_loop
  cp 7
  jp z,joy_m_loop
  cp 11
  jp z,joy_m_loop
  cp 15
  jp z,joy_m_loop
  ld a,(selected)
  inc a
  ld (selected),a
  ld a,(cursX)
  ld b,16
  add a,b
  ld (cursX),a
  jp joy_m_loop
joy_up:
  ld a,(selected)
  cp 4
  jp c,joy_m_loop
  ld a,(selected)
  ld b,4
  sbc a,b
  ld (selected),a
  ld a,(cursY)
  ld b,16
  sbc a,b
  ld (cursY),a
  jp joy_m_loop
joy_down:
  ld a,(selected)
  cp 12
  jp nc,joy_m_loop
  ld a,(selected)
  ld b,4
  add a,b
  ld (selected),a
  ld a,(cursY)
  ld b,16
  add a,b
  ld (cursY),a
  jp joy_m_loop


joy_draw_curs:
  call waitvbl
  ld hl,$FE00
  ld a,(cursY)
  ld (hl),a
  ld hl,$FE01
  ld a,(cursX)
  ld (hl),a
  ld hl,$FE02
  ld a,210
  ld (hl),a
  ld hl,$FE03
  ld a,0
  ld (hl),a
  ld hl,$FE08
  ld a,(cursY)
  ld (hl),a
  ld hl,$FE09
  ld a,(cursX)
  ld b,8
  add a,b
  ld (hl),a
  ld hl,$FE0A
  ld a,212
  ld (hl),a
  ld hl,$FE0B
  ld a,0
  ld (hl),a
  ret

joy_config_end:
  jp MAIN_MENU


;******************
;*** ABOUT MENU ***
;******************
ABOUT_MENU:
  call readpad
  cp 0
  jr nz,ABOUT_MENU
  di
  ld a,%11100100
  ldh ($47),a
  ld hl,about_menu_map
  call load_map
  ld hl,$9800+((5 * 32 ) + 10 )
  ld a,VER1
  ld b,137
  add a,b
  call wrAtohl
  ld hl,$9800+((5 * 32 ) + 12 )
  ld a,VER2
  ld b,137
  add a,b
  call wrAtohl


about_m_loop:
  ld bc,1024
about_m_wait:
  dec bc
  ld a,b
  or c
  cp 0
  jr nz,about_m_wait
  call readpad
  cp $4
  jp z,MAIN_MENU
  jp about_m_loop




;************************
;*** SELECT-GAME MENU ***
;************************
GAME_MENU:
  call readpad
  cp 0
  jr nz,GAME_MENU

  ld a,(menu)
  cp 0
  jp z,no_menu_show

  di
  xor a
  ld (emu_running),a
  ldh ($42),a
  ld (schip_on),a

  ld a,%00000011
  ldh ($FF),a			;We want LCDC int + Vblank

  ld hl,chip_tiles
  call load_tiles
  ld hl,game_menu_map
  call load_map2
  ld a,(nr_of_games)
  ld b,a
  ld hl,game1
  ld d,6
  ld e,4
  ld a,8
writename:
  push af
  push bc
  push de
  push hl
  call writetext
  pop hl
  pop de
  pop bc
  pop af
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  inc e
  dec b
  jr nz,writename

  ld a,(nr_of_games)
  dec a
  ld (max_select),a

  ld a,8
  ld (menu_move_size),a
  xor a
  ld (cursdir),a
  ld (cursmoved),a
  ld (emu_running),a
  ld (game_selected),a
  ld a,32
  ld (cursY),a
  xor a
  ld (yint),a
  ldh ($45),a
  ei
game_menu:
  ld bc,1024
menu_wait:
  dec bc
  ld a,b
  or c
  cp 0
  jr nz,menu_wait
  call readpad
  cp $40
  call z,m_joyup
  call readpad
  cp $80
  call z,m_joydown
  call readpad
  cp $1
  jp z,menu_start
  cp $2
  jp z,menu_start
  cp $8
  jp z,menu_start
  cp $4
  jp z,MAIN_MENU
menu_move:
  ld a,(cursmoved)
  cp 0
  jp z,game_menu
  ld a,(cursmoved)
  dec a
  ld (cursmoved),a
  ld a,(cursdir)
  cp 8
  call z,moveup
  ld a,(cursdir)
  cp 2
  call z,movedown
  jp game_menu

moveup:
  ld a,(cursY)
  dec a
  ld (cursY),a
  ret
movedown:
  ld a,(cursY)
  inc a
  ld (cursY),a
  ret
m_joyup:
  ld a,(game_selected)
  cp 0
  ret z
  ld a,(cursmoved)
  cp 0
  ret nz
  ld a,8
  ld (cursdir),a
  ld a,(menu_move_size)
  ld (cursmoved),a
  ld a,(game_selected)
  dec a
  ld (game_selected),a
  ret
m_joydown:
  ld a,(game_selected)
  ld b,a
  ld a,(max_select)
  cp b
  ret z
  ld a,(cursmoved)
  cp 0
  ret nz
  ld a,2
  ld (cursdir),a

  ld a,(menu_move_size)
  ld (cursmoved),a
  ld a,(game_selected)
  inc a
  ld (game_selected),a
  ret
menu_start:
  ld a,(cursmoved)
  cp 0
  jp nz,menu_move

menu_start_wait:
  call readpad
  cp 0
  jr nz,menu_start_wait

  di
  ld a,%11100100
  ldh ($47),a


















;************************
;*** START A NEW GAME ***
;************************
no_menu_show:
  di
  call erase_screen     ;clear chip8 gamescreen

  ld hl,chip_map
  call load_map2

  ld hl,$9800+((32*17)+17)
  ld a,VER1
  ld b,137
  add a,b
  call wrAtohl
  inc hl
  inc hl
  ld a,VER2
  ld b,137
  add a,b
  call wrAtohl

  xor a
  ld (yint),a
  ldh ($45),a
  ldh ($43),a

  call reset_chip8      ;reset chip8
  call load_chip8_prog  ;load chip8-program
  ld a,1
  ld (emu_running),a    ;emulation ON

  ld a,(force_schip)
  cp 0
  jr z,noforce2
  ld a,1
  ld (schip_on),a
  ld a,%00000001
  ldh ($FF),a
noforce2:
 
  ld a,%00000001
  ldh ($FF),a
  ei
    




;                       *******************************
;                       ****** M A I N   L O O P ******
;                       *******************************


main:
  ld a,(schip_on)
  cp 1
  jr z,no_slowdown_chip8

  ld a,(chip8_delay)
  cp 0
  jr z,no_slowdown_chip8
slowdown_chip8:
  dec a
  jr nz,slowdown_chip8

no_slowdown_chip8:
  call readpad
  ld (keypressed),a
  cp 12                 ;START + SELECT PRESSED?
  jp nz,no_select_start ;no, don't bother...

  ld a,(menu)
  cp 0
  jp z,MAIN_MENU        ;single-game  -> main menu.
  jp GAME_MENU          ;multi-game   -> load new game.

no_select_start:
;**********************************
;*** See if skip_next bit is on ***
;**********************************
  ld a,(skip_next)
  cp 1
  jr nz,no_skip

  ld a,(chipPC_h)
  ld h,a
  ld a,(chipPC_l)
  ld l,a
  inc hl
  inc hl
  ld a,h
  ld (chipPC_h),a
  ld a,l
  ld (chipPC_l),a
  xor a
  ld (skip_next),a

no_skip:
;*********************************************
;*** Fetch the opcode and increase PC by 2 ***
;*********************************************
  call get_chippos_HL   ;set hl = next instruction
  ld a,(hli)
  ld b,(hl)             ;PC += 2
  inc hl
  call setPC            ;store the next PC

;*************************************
;*** Store the opcode in variables ***
;*************************************
  ld (op_h),a           ;store higher byte -> op_h
  ld a,b
  ld (op_l),a           ;store lower byte -> op_l

  ld b,%00001111
  and b
  ld (op4),a            ;store fourth 4bits -> op4
  ld a,(op_l)
  ld b,%11110000
  and b
  swap a
  ld (op3),a            ;store third 4bits -> op3
  ld a,(op_h)
  ld b,%00001111
  and b
  ld (op2),a            ;store second 4bits -> op2
  ld a,(op_h)
  ld b,%11110000
  and b
  swap a
  ld (op1),a            ;store first 4bits -> op1

;*************************************
;*** Determine opcode-group (0-15) ***
;*************************************
  cp 0
  jp z,group0
  cp 1
  jp z,group1
  cp 2
  jp z,group2
  cp 3
  jp z,group3
  cp 4
  jp z,group4
  cp 5
  jp z,group5
  cp 6
  jp z,group6
  cp 7
  jp z,group7
  cp 8
  jp z,group8
  cp 9
  jp z,group9
  cp 10
  jp z,groupA
  cp 11
  jp z,groupB
  cp 12
  jp z,groupC
  cp 13
  jp z,groupD
  cp 14
  jp z,groupE
  cp 15
  jp z,groupF
  jp main


;*********************************
;*** Opcode translation groups ***
;*********************************
group0:
  ld a,(op_l)
  cp $E0
  jp z,g0_1
  cp $EE
  jp z,g0_2
  cp $FB
  jp z,g0_4
  cp $FC
  jp z,g0_5
  cp $FD
  jp z,g0_6
  cp $FE
  jp z,g0_7
  cp $FF
  jp z,g0_8
  ld a,(op3)
  cp $C
  jp z,g0_3
  jp main


g0_3:                   ;-- SCROLL DOWN n LINES (S-CHIP) ---
  ld a,(op4)
  ld (temp1),a
  add a,a
  ld (temp2),a  ;temp2 = lines to scroll * 2
  ld c,a
  ld hl,$8010
  ld a,(temp2)
  ld b,a
  ld a,127
  sbc a,b
  ld e,a
  ld d,0
  add hl,de     ;HL = last line
  ld a,h
  ld (temp3),a
  ld a,l
  ld (temp4),a
  ld c,16
scrollupn2:
  ld a,(temp1)
  ld b,a
  ld a,64
  sbc a,b
  ld b,a
scrollupn:
  call readAhl       ;read value
  push af
  ld a,(temp2)
  ld e,a
  ld d,0
  add hl,de     ;down (lines*2)
  pop af
  call wrAtohl  ;write new value
  ld a,(temp2)
  inc a
  inc a
  neg
  ld e,a
  ld d,-1
  add hl,de     ;up (lines*2) + 2
  dec b
  jr nz,scrollupn
  ld a,(temp3)
  ld h,a
  ld a,(temp4)
  ld l,a
  ld de,128
  add hl,de
  ld a,h
  ld (temp3),a
  ld a,l
  ld (temp4),a
  dec c
  jp nz,scrollupn2
  ld hl,$8011
  ld a,(temp2)
  ld b,a
  ld a,128
  sbc a,b
  ld e,a
  ld d,0
  ld b,16
clr1row:
  ld a,(temp1)
  ld c,a
  xor a
clr2row:
  call wrAtohl
  inc hl
  inc hl
  dec c
  jr nz,clr2row
  add hl,de
  dec b
  jr nz,clr1row
  jp main
g0_4:                   ;-- SCROLL 4 PIXELS RIGHT (S-CHIP) --
  ld c,%00001111        ;mask
  ld a,0
  ld (temp3),a


scrollx2:
  ld a,(temp3)
  add a,a
  ld hl,$8011
  ld e,a
  ld d,0
  add hl,de

  ld de,128

  call readAhl
  and c
  swap a
  ld b,a

  call readAhl
  swap a
  and c
  call wrAtohl

  add hl,de

  ld a,8
  ld (temp2),a

scrollx1:
  call readAhl
  and c
  swap a
  ld (temp1),a
  call readAhl
  swap a
  and c
  or b
  call wrAtohl
  ld a,(temp2)
  dec a
  ld (temp2),a
  cp 0
  jr z,scrollx1done

  add hl,de

  call readAhl
  and c
  swap a
  ld b,a
  push bc
  ld a,(temp1)
  ld b,a
  call readAhl
  swap a
  and c
  or b
  call wrAtohl
  pop bc
  add hl,de
  jp scrollx1

scrollx1done:
  ld a,(temp3)
  inc a
  ld (temp3),a
  cp 64
  jp nz,scrollx2


  jp main

g0_5:                   ;-- SCROLL 4 PIXELS LEFT (S-CHIP) --
  ld c,%11110000        ;mask
  ld a,0
  ld (temp3),a

scrollx3:
  ld a,(temp3)
  add a,a
  ld hl,$8011+(1920)
  ld e,a
  ld d,0
  add hl,de

  ld de,-128

  call readAhl
  and c
  swap a
  ld b,a

  call readAhl
  swap a
  and c
  call wrAtohl

  add hl,de

  ld a,8
  ld (temp2),a

scrollx4:
  call readAhl
  and c
  swap a
  ld (temp1),a
  call readAhl
  swap a
  and c
  or b
  call wrAtohl

  ld a,(temp2)
  dec a
  ld (temp2),a
  cp 0
  jr z,scrollx2done

  add hl,de

  call readAhl
  and c
  swap a
  ld b,a
  push bc
  ld a,(temp1)
  ld b,a
  call readAhl
  swap a
  and c
  or b
  call wrAtohl
  pop bc
  add hl,de
  jp scrollx4

scrollx2done:
  ld a,(temp3)
  inc a
  ld (temp3),a
  cp 64
  jp nz,scrollx3

  jp main
g0_6:                   ;-- QUIT EMULATOR (S-CHIP) --
  jp GAME_MENU
  jp main
g0_7:                   ;-- SET CHIP8 MODE (S-CHIP) --
  ld a,(force_schip)
  cp 0
  jr z,noforce1
  jp g0_8
noforce1:
  xor a
  ld (schip_on),a
  ld a,%00000011
;  ldh ($FF),a
  jp main
g0_8:                   ;-- SET S-CHIP MODE (S-CHIP) --
  ld a,1
  ld (schip_on),a
  ld a,%00000001
  ldh ($FF),a
  jp main
g0_1:                   ;-- ERASE SCREEN --
  call z,erase_screen
  jp main
g0_2:                   ;-- RETURN SUBROUTINE --
  ld hl,chipSTACK
  ld a,(chipSP)
  call add_hl_a         ;HL = current stack position
  dec hl
  ld a,(hl)
  ld (chipPC_l),a       ;get PC_l
  dec hl
  ld a,(hl)
  ld (chipPC_h),a       ;get PC_l
  ld a,(chipSP)
  dec a
  dec a
  ld (chipSP),a         ;SP -= 2;
  jp main

group1:
g1_1:                   ;-- JUMP TO POSITION --
  ld a,(op2)
  ld (chipPC_h),a       ;set high byte of adress
  ld a,(op_l)
  ld (chipPC_l),a       ;set low bytes of adress
  jp main

group2:
g2_1:                   ;-- CALL SUBROUTINE --
  ld hl,chipSTACK
  ld a,(chipSP)
  call add_hl_a         ;HL = stack position
  ld a,(chipPC_h)       ;store PC_h
  ld (hli),a
  ld a,(chipPC_l)       ;store PC_l
  ld (hli),a
  ld a,(chipSP)
  inc a
  inc a
  ld (chipSP),a         ;SP += 2
  ld a,(op2)
  ld (chipPC_h),a       ;set PC_h
  ld a,(op_l)
  ld (chipPC_l),a       ;set PC_l
  jp main

group3:
g3_1:                   ;SKIP NEXT IF Vx == KK
  xor a
  ld (skip_next),a
  ld hl,v0
  ld a,(op2)
  call add_hl_a         ;HL = current Vx register
  ld a,(hl)
  ld b,a
  ld a,(op_l)
  cp b
  jp nz,main
  ld a,1
  ld (skip_next),a
  jp main

group4:
g4_1:                   ;SKIP NEXT IF Vx != KK
  xor a
  ld (skip_next),a
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld b,a
  ld a,(op_l)
  cp b
  jp z,main
  ld a,1
  ld (skip_next),a
  jp main

group5:
g5_1:                   ;SKIP NEXT IF Vx == Vy
  xor a
  ld (skip_next),a
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld b,a                ;b = Vx
  ld hl,v0
  ld a,(op3)
  call add_hl_a
  ld a,(hl)             ;a = Vy
  cp b
  jp nz,main
  ld a,1
  ld (skip_next),a
  jp main

group6:
g6_1:                   ;Vx = KK
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(op_l)
  ld (hl),a
  jp main

group7:
g7_1:                   ;Vx = Vx + KK
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld b,a
  ld a,(op_l)
  add a,b
  ld (hl),a
  jp main

group8:                 ;-- ARITHMETIC INSTRUCTIONS --
  ld hl,v0
  ld a,(op3)
  call add_hl_a
  ld a,(hl)
  ld (temp1),a          ;temp1 = Vy
  ld hl,v0
  ld a,(op2)
  call add_hl_a         ;HL is set at Vx
  ld a,(hl)
  ld (temp2),a          ;temp2 = Vx
  ld a,(op4)
  cp 0
  jp z,g8_0
  cp 1
  jp z,g8_1
  cp 2
  jp z,g8_2
  cp 3
  jp z,g8_3
  cp 4
  jp z,g8_4
  cp 5
  jp z,g8_5
  cp 6
  jp z,g8_6
  cp 7
  jp z,g8_7
  cp 14
  jp z,g8_E
  jp main
g8_0:                   ;Vx = Vy
  ld a,(temp1)
  ld (hl),a
  jp main
g8_1:                   ;Vx = Vx OR Vy
  ld a,(temp1)  ;b=Vy
  ld b,a
  ld a,(temp2)  ;a=Vx
  or b
  ld (hl),a
  jp main
g8_2:                   ;Vx = Vx AND Vy
  ld a,(temp1)  ;a=Vy
  ld b,a
  ld a,(temp2)  ;a=Vx
  and b
  ld (hl),a
  jp main
g8_3:                   ;Vx = Vy XOR Vy
  ld a,(temp1)  ;b=Vy
  ld b,a
  ld a,(temp2)  ;a=Vx
  xor b
  ld (hl),a
  jp main
g8_4:                   ;Vx = Vx + Vy, VF = carry
  xor a
  ld (vF),a

  ld a,(temp1)
  ld b,a        ;b=Vy
  ld a,(temp2)
  add a,b
  ld (hl),a
  jp c,main
  ld a,1
  ld (vF),a

  jp main
g8_5:                   ;Vx = Vx - Vy, VF = not borrow
  xor a
  ld (vF),a

  ld a,(temp1)
  ld b,a        
  ld a,(temp2)
  sub b
  ld (hl),a
  ld a,(temp1)
  ld b,a        ;b=vy
  ld a,(temp2)  ;a=vx
  cp b
  jp c,main
  ld a,1
  ld (vF),a
  jp main
g8_6:                   ;Vx = Vx / 2, VF = carry
  xor a
  ld (vF),a

  ld a,(temp2)
  ld b,2
  call div
  ld (hl),a
  jp c,main
  ld a,1
  ld (vF),a
  jp main
g8_7:                   ;Vx = Vy - Vx, VF = not borrow
  xor a
  ld (vF),a
  ld a,(temp2)
  ld b,a        ;b=Vx
  ld a,(temp1)
  sub b
  ld (hl),a

  ld a,(temp2)
  ld b,a        ;b=vx
  ld a,(temp1)  ;a=vy
  cp b
  jp c,main
  ld a,1
  ld (vF),a

  jp main
g8_E:                   ;Vx = Vx * 2, VF = carry
  xor a
  ld (vF),a
  ld a,(temp2)
  add a,a
  ld (hl),a
  jp nc,main
  ld a,1
  ld (vF),a
  jp main
group9:                 ;-- SKIP NEXT IF Vx != Vy
  xor a
  ld (skip_next),a
  ld hl,v0
  ld a,(op3)
  call add_hl_a
  ld a,(hl)
  ld b,a        ;b=Vy
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)     ;a=Vx
  cp b
  jp z,main
  ld a,1
  ld (skip_next),a
  jp main

groupA:                 ;-- I = NNN --
  ld a,(op2)
  ld (I_h),a
  ld a,(op_l)
  ld (I_l),a
  jp main

groupB:                 ;-- JUMP TO NNN + V0 --
  ld a,(op2)
  ld h,a
  ld a,(op_l)
  ld l,a                ;HL = NNN
  ld a,(v0)
  call add_hl_a         ;HL = NNN + V0
  ld a,h
  ld (chipPC_h),a       ;set PC_h
  ld a,l
  ld (chipPC_l),a       ;set PC_l
  jp main

groupC:                 ;-- Vx = Random number AND KK --
  ld a,(op_l)
  ld b,a

  ld a,(op2)
  ld hl,v0  
  call add_hl_a
  push hl               ;hl = Vx

  ld hl,rnd_table
  ld a,(rnd_pos)
  inc a
  ld (rnd_pos),a        ;a = rnd_pos
  call add_hl_a
  ld a,(hl)             ;a = random number

  pop hl

  and b
  ld (hl),a
  jp main
groupD:                 ;-- DRAW SPRITE --
  xor a
  ld (vF),a
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld (temp1),a  ;temp1 = Vx
  ld hl,v0
  ld a,(op3)
  call add_hl_a
  ld a,(hl)
  ld (temp2),a  ;temp2 = Vy
  ld a,(op4)
  cp 0
  jp z,drawspr_16_16
drawspr_8_N:            ;DRAW 8 * N SPRITE
  ld a,(op4)
  ld (temp3),a
  call draw_spr_8xN
  jp main
drawspr_16_16:          ;DRAW 16 * 16 SPRITE
  call draw_spr_16x16
  jp main
groupE:
  ld a,(op_l)
  cp $9E
  jp z,gE_1
  cp $A1
  jp z,gE_2
  jp main
gE_1:                   ;-- SKIP INSTRUCTION IF Key == Vx --
  xor a
  ld (skip_next),a

  ld a,(keypressed)
  ld hl,joypad
  call add_hl_a
  ld a,(hl)
  ld b,a                ;B=key

  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)             ;A=Vx
  cp b
  jp nz,main

  ld a,1
  ld (skip_next),a
  jp main
gE_2:                   ;-- SKIP INSTRUCTION IF Key != Vx --
  xor a
  ld (skip_next),a

  ld a,(keypressed)
  ld hl,joypad
  call add_hl_a
  ld a,(hl)
  ld b,a                ;B = key

  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)             ;A = Vx
  cp b
  jp z,main

  ld a,1
  ld (skip_next),a
  jp main
groupF:
  ld a,(op_l)
  cp $07
  jp z,gF_1
  cp $0A
  jp z,gF_2
  cp $15
  jp z,gF_3
  cp $18
  jp z,gF_4
  cp $1E
  jp z,gF_5
  cp $29
  jp z,gF_6
  cp $33
  jp z,gF_7
  cp $55
  jp z,gF_8
  cp $65
  jp z,gF_9
  cp $75
  jp z,gF_10
  cp $85
  jp z,gF_11
  cp $30
  jp z,gF_12
  jp main
gF_1:                   ;Vx = DELAY TIMER
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(DT)
  ld (hl),a
  jp main
gF_2:                   ;WAIT KEYPRESS -> Vx
  call readpad  ;read joypad
  cp 0
  jr z,gF_2

  ld hl,joypad
  call add_hl_a
  ld a,(hl)
  ld b,a        ;b = pad_status
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,b
  ld (hl),a
gf2wait:
  call readpad
  cp 0
  jr nz,gf2wait
  jp main
gF_3:                   ;DELAY TIMER = Vx
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld (DT),a
  jp main
gF_4:                   ;SOUND TIMER = Vx
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  inc a
  ld (ST),a
  jp main
gF_5:                   ;I = I + Vx
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld e,a
  ld a,(I_h)
  ld h,a
  ld a,(I_l)
  ld l,a        ;hl=I
  ld d,0        ;de=vx
  add hl,de     ;hl+=de
  ld a,h
  ld (I_h),a
  ld a,l
  ld (I_l),a
  jp main
gF_6:                   ;I POINTS TO HEX-CHAR Vx
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld b,6
  call mult
  ld (I_l),a
  xor a
  ld (I_h),a
  jp main
gF_7:                   ;STORE BCD REPRESENTATION OF Vx IN M(I) -> M(I+2)
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld b,a

  ld a,(I_h)
  ld h,a
  ld a,(I_l)
  ld l,a
  ld de,$C000
  add hl,de
  ld a,b
  ld b,100
  call div
  ld (hli),a    ;store hundred
  ld a,b
  ld b,10
  call div
  ld (hli),a    ;store ten
  ld a,b
  ld (hli),a    ;store one
  jp main


gF_8:                   ;SAVE V0 -> Vx IN MEMORY STARTING AT M(I)
  ld a,(I_h)
  ld d,a
  ld a,(I_l)
  ld e,a        ;de = I
  ld hl,$C000
  add hl,de
  ld d,h
  ld e,l

  ld a,(op2)
  ld b,a        ;b = x
  inc b
  ld hl,v0      ;hl = v0
gF8_loop1:
  ld a,(hli)
  ld (de),a
  inc de
  dec b
  jr nz,gF8_loop1
  jp main
gF_9:                   ;LOAD V0 -> Vx FROM MEMORY AT M(I)
  ld a,(I_h)
  ld d,a
  ld a,(I_l)
  ld e,a        ;de = I
  ld hl,$C000
  add hl,de
  ld d,h
  ld e,l

  ld a,(op2)
  ld b,a        ;b = x
  inc b
  ld hl,v0      ;hl = v0
gF9_loop1:
  ld a,(de)
  ld (hli),a
  inc de
  dec b
  jr nz,gF9_loop1
  jp main

gF_10:                  ;SAVE V0...VX (x<8) into HP48-flags (S-CHIP8)
  ld a,(op2)
  cp 8
  jr c,gf10_ok
  ld a,7
gf10_ok:
  ld b,a
  ld hl,hpflag0
  ld de,v0
gf_10loop1:
  ld a,(de)
  ld (hli),a
  inc de
  dec b
  jr nz,gf_10loop1
  jp main
gF_11:                  ;LOAD V0...VX (x<8) from HP48-flags (S-CHIP8)
  ld a,(op2)
  cp 8
  jr c,gf11_ok
  ld a,7
gf11_ok:
  ld b,a
  ld hl,hpflag0
  ld de,v0
gf_11loop1:
  ld a,(hli)
  ld (de),a
  inc de
  dec b
  jr nz,gf_11loop1
  jp main
gF_12:                  ;I points to 8*10 font
  ld hl,v0
  ld a,(op2)
  call add_hl_a
  ld a,(hl)
  ld b,10
  call mult
  ld b,96
  add a,b
  ld (I_l),a
  xor a
  ld (I_h),a
  jp main


;***************************
;*** DRAW THE 8xN SPRITE ***
;***************************
draw_spr_8xN:
  ld a,(I_h)
  ld d,a
  ld a,(I_l)
  ld e,a
  ld hl,$C000
  add hl,de     ;hl = character

  ld a,(temp1)
  ld (temp6),a
  ld a,(temp2)
  ld (temp7),a

  ld a,(temp3)
  ld b,a

drw_8xN:
  ld a,(hli)
  bit 7,a
  call nz,plot
  call inc_temp6        ;x++
  bit 6,a
  call nz,plot
  call inc_temp6
  bit 5,a
  call nz,plot
  call inc_temp6
  bit 4,a
  call nz,plot
  call inc_temp6
  bit 3,a
  call nz,plot
  call inc_temp6
  bit 2,a
  call nz,plot
  call inc_temp6
  bit 1,a
  call nz,plot
  call inc_temp6
  bit 0,a
  call nz,plot

  call inc_temp7        ;y++
  ld a,(temp1)
  ld (temp6),a
  dec b
  jr nz,drw_8xN
  ret

inc_temp6:
  push af
  ld a,(temp6)
  inc a
  ld (temp6),a
  pop af
  ret
inc_temp7:
  push af
  ld a,(temp7)
  inc a
  ld (temp7),a
  pop af
  ret



;*****************************
;*** DRAW THE 16x16 SPRITE ***
;*****************************
draw_spr_16x16:
  ld a,(I_h)
  ld d,a
  ld a,(I_l)
  ld e,a
  ld hl,$C000
  add hl,de     ;hl = character

  ld a,(temp1)
  ld (temp6),a
  ld a,(temp2)
  ld (temp7),a

  ld b,16
drw_16x16:
  ld a,(hli)
  bit 7,a
  call nz,plot
  call inc_temp6        ;x++
  bit 6,a
  call nz,plot
  call inc_temp6
  bit 5,a
  call nz,plot
  call inc_temp6
  bit 4,a
  call nz,plot
  call inc_temp6
  bit 3,a
  call nz,plot
  call inc_temp6
  bit 2,a
  call nz,plot
  call inc_temp6
  bit 1,a
  call nz,plot
  call inc_temp6
  bit 0,a
  call nz,plot
  call inc_temp6

  ld a,(hli)
  bit 7,a
  call nz,plot
  call inc_temp6        ;x++
  bit 6,a
  call nz,plot
  call inc_temp6
  bit 5,a
  call nz,plot
  call inc_temp6
  bit 4,a
  call nz,plot
  call inc_temp6
  bit 3,a
  call nz,plot
  call inc_temp6
  bit 2,a
  call nz,plot
  call inc_temp6
  bit 1,a
  call nz,plot
  call inc_temp6
  bit 0,a
  call nz,plot


  call inc_temp7        ;y++
  ld a,(temp1)
  ld (temp6),a
  dec b
  jp nz,drw_16x16
  ret





;********************
;*** Erase screen ***
;********************
erase_screen:
  ld hl,$8010
  ld bc,2048
  xor a
er_screen:
  xor a
  call wrAtohl
  inc hl
  dec bc
  ld a,b
  or c
  cp 0
  jr nz,er_screen
  ret



;******************************************
;*** sets HL to current chip-8 position ***
;******************************************
get_chippos_HL:
  push af
  ld a,(chipPC_h)
  ld h,a
  ld a,(chipPC_l)
  ld l,a
  ld de,chipmem
  add hl,de
  pop af
  ret
;********************************
;*** loads the chip8 PC -> HL ***
;********************************
getPC:
  push af
  ld a,(chipPC_h)
  ld h,a
  ld a,(chipPC_l)
  ld l,a
  pop af
  ret
;********************************
;*** store the chip8 PC <- HL ***
;********************************
setPC:
  push af
  ld de,-$C000
  add hl,de             ;HL = chip_PC
  ld a,h
  ld (chipPC_h),a
  ld a,l
  ld (chipPC_l),a
  pop af
  ret
;**************************************
;*** Load CHIP8 program into memory ***
;**************************************

load_chip8_prog:        ;--- Load built in hex fonts ---
  ld hl,char_data
  ld de,$C000
  ld b,255
load_chars:
  ld a,(hli)
  ld (de),a
  inc de
  dec b
  jr nz,load_chars


;****************************
;*** Data for single-game ***
;****************************
  ld hl,$4000           ;chip-program source location
  ld de,$C200           ;chip-program destination
  ld bc,$0FFF           ;program_size = 4096 bytes
  ld a,2
  ld ($2000),a          ;select bank2
  ld a,(menu)
  cp 0
  jp z,do_load_chip
;**************************
;*** Data for menu-game ***
;**************************
  ld a,1
  ld ($2000),a

  ld a,(game_selected)
  ld hl,adr_data
  call add_hl_a
  ld a,(hl)
  ld d,a
  ld a,0
  ld e,a
  ld h,d
  ld l,e                ;hl = source adress
  ld de,$C200           ;de = dest. address
  ld bc,$0FFF           ;bc = program_size = 4096 bytes

  push hl


  ld a,(game_selected)
  ld hl,bank_data
  call add_hl_a
  ld a,(hl)
  ld ($2000),a
  pop hl

do_load_chip:
  push hl
  ld a,(hli)
  cp 72         ;H  
  jr nz,no_hp_header

  ld a,(hli)
  cp 80         ;P
  jr nz,no_hp_header

  ld a,(hli)
  cp 72         ;H
  jr nz,no_hp_header

  ld a,(hli)
  cp 80         ;P
  jr nz,no_hp_header

  ld a,(hli)
  cp 52         ;4
  jr nz,no_hp_header

  ld a,(hli)
  cp 56         ;8
  jr nz,no_hp_header
;--- Skip HP-Header when loading game ---
  pop hl
  push de
  ld de,13
  add hl,de
  pop de
  jr load_chip

no_hp_header:
  pop hl

load_chip:
  ld a,(hli)
  ld (de),a
  inc de
  dec bc
  ld a,b
  or c
  cp 0
  jr nz,load_chip
  ld a,1
  ld ($2000),a
  ret
;*******************
;*** Reset CHIP8 ***
;*******************
reset_chip8:
  xor a
  ld (chipSP),a         ;stack pointer = 0
  ld (skip_next),a
  ld (I_h),a
  ld (I_l),a
  ld (DT),a
  ld (ST),a
  ld (keypressed),a


  ld hl,$200
  ld a,h
  ld (chipPC_h),a       ;set PC = $200
  ld a,l
  ld (chipPC_l),a
  ld b,16
  ld hl,v0
  xor a
reset_v_regs:           ;reset v0 - vF
  ld (hli),a
  dec b
  jr nz,reset_v_regs

  ld de,4096
  ld hl,chipmem
  xor a
reset_chipmem:          ;reset chip8 program-memory
  ld (hli),a
  dec de
  ld a,d
  or e
  cp 0
  jr nz,reset_chipmem
  ret


read_pad_settings:
  ld hl,joypad
  ld b,255
  ld a,255
clrjoyset:
  ld (hli),a
  dec b
  jr nz,clrjoyset

  ld a,3
  ld (pad_UP),a
  ld a,7
  ld (pad_LEFT),a
  ld a,8
  ld (pad_RIGHT),a
  ld a,0
  ld (pad_DOWN),a
  ld a,$0
  ld (pad_A),a
  ld a,$A
  ld (pad_B),a
  ld a,$7
  ld (pad_START),a
  ld a,$5
  ld (pad_SELECT),a
  ret






;******************
;** SUB-ROUTINES **
;******************

;*** Plot (temp6),(temp7) ***
plot:
  push af
  ld a,(schip_on)
  cp 0
  jr z,chip8test_p

  ld a,(temp7)
  cp 64
  jr c,ploty_ok_sc
  pop af
  ret
ploty_ok_sc:
  ld a,(temp6)
  cp 128
  jr c,schip8plot
  pop af
  ret

chip8test_p:
  ld a,(temp7)
  cp 32
  jr c,ploty_ok
  pop af
  ret
ploty_ok:
  ld a,(temp6)
  cp 64
  jr c,plotx_ok
  pop af
  ret
plotx_ok:
  ld a,(schip_on)
  cp 0
  jr z,chip8plot
schip8plot:             ;S-CHIP8 plot
  ld a,(temp6)
  ld (temp8),a
  ld a,(temp7)
  ld (temp9),a
  call do_plot
  pop af
  ret

chip8plot:              ;CHIP8 plot
  ld a,(temp7)
  add a,a
  ld (temp9),a
  ld a,(temp6)
  add a,a
  ld (temp8),a
  call do_plot
  inc a
  ld (temp8),a
  call do_plot
  pop af
  ret

;** X = temp 8, Y = temp9 ***
do_plot:
  push af
  push bc
  push de
  push hl

  ld hl,$8010
  ld a,(temp9)
  add a,a			;a=a*2
  ld e,a
  ld d,0
  add hl,de			;** Y is set **

  ld a,(temp8)
  cp 8
  jr c,plot1

  ld b,8
  call div
  ld b,a

  ld de,128
fixx:
  add hl,de			;One tile right on map
  dec b
  jr nz,fixx                    ;HL is set!

plot1:
  ld d,%10000000
  ld a,(temp8)                     ;a=x pos
  ld b,8
  call div
  ld a,b

  cp 0
  jr z,plot2
plotfix_x:
  srl d
  dec a
  cp 0
  jr nz,plotfix_x

plot2:
  inc hl

  ld a,(schip_on)
  cp 1
  jp z,prdAhl

;***************************
;*** This makes the pixels BLACK instead of DARK GRAY (slows down ) ***
;
;  dec hl
;prdAhly:
;  ldh a,($41)
;  bit 1,a
;  jr nz,prdAhly
;  ld a,(hl)
;  xor d
;  ld b,a
;pwrAhly
;  ldh a,($41)
;  bit 1,a
;  jr nz,pwrAhly
;  ld a,b
;  ld (hl),a
;
;  inc hl
;  call readAhl
;  xor d
;  call wrAtohl
;  inc hl
;


  call readAhl
  xor d
  call wrAtohl
  inc hl
  inc hl

prdAhl:
  ldh a,($41)
  bit 1,a
  jr nz,prdAhl

  ld a,(hl)

  ld b,a        ;b = backgrnd
  xor d
  ld c,a        ;c = backgrnd XOR sprite

pwrAhl
  ldh a,($41)
  bit 1,a
  jr nz,pwrAhl

  ld a,c
  ld (hl),a

  ld a,b
  add a,d
  cp c

  jr z,no_collision

  ld a,(collissions_on)
  cp 0
  jr z,no_collision

  ld a,1
  ld (vF),a

no_collision:
  pop hl
  pop de
  pop bc
  pop af
  ret

;*************************************
;* Reads the joypad, returns A=value *
;*************************************
readpad:
  ld a,$20
  ld ($FF00),a
  ld a,($FF00)
  ld a,($FF00)
  cpl
  and $0F
  swap a
  ld b,a
  ld a,$10
  ld ($FF00),a
  ld a,($FF00)
  ld a,($FF00)
  ld a,($FF00)
  ld a,($FF00)
  ld a,($FF00)
  ld a,($FF00)
  cpl
  and $0F
  or b
  cp $F			;Is reset pressed (A+B+Select+START)?
  jp z,begin		;yes, reset gameboy
  ret  



load_map2:
  ld de,$9800			;Mapmem location
  ld c,32			;Height=32
ldmap12:
  ld b,32			;Width=32
ldmap22:
  ld a,(hli)
  call wrAtode
  inc de
  dec b
  jr nz,ldmap22
  dec c
  jr nz,ldmap12
  ret

load_map:
  ld de,$9800			;Mapmem location
  ld c,32			;Height=32
ldmap1:
  ld b,32			;Width=32
ldmap2:
  push bc
  ld b,63
  ld a,(hli)
  add a,b
  call wrAtode
  pop bc
  inc de
  dec b
  jr nz,ldmap2
  dec c
  jr nz,ldmap1
  ret



load_tiles:
  ld de,$8000			;BG-tiles position
  ld c,255			;Nr. of tiles
loadtiles:
  ld b,16			;16 bytes per tile 
loadonetile:
  ld a,(hli)
  call wrAtode
  inc de
  dec b
  jr nz,loadonetile
  dec c
  jr nz,loadtiles
  ret


wrAtode:		;Writes A to HL at the right time
  push af		;Save reg A and flags
wral2:
  ldh a,($41)
  and 2
  jr nz,wral2
  pop af		;Restore reg A and flags
  ld (de),a		;write a to hl
  ret

wrAtohl:                ;Writes A to HL at the right time
  push af		;Save reg A and flags
wralh2:
  ldh a,($41)
  bit 1,a
  jr nz,wralh2
  pop af		;Restore reg A and flags
  ld (hl),a             ;write a to hl
  ret

readAhl:                ;Writes A to HL at the right time
  ldh a,($41)
  bit 1,a
  jr nz,readAhl
  ld a,(hl)             ;write a to hl
  ret


add_hl_a:
  push de
  ld e,a
  ld d,0
  add hl,de
  pop de
  ret

waitvbl:
  push af
  ldh a,($40)
  add a,a
  jr nc,vbl_done
waitvbl_loop:
  ldh a,($44)
  cp $98
  jr nz,waitvbl_loop
vbl_done:
  pop af
  ret



;HL = source
;D  = X-pos
;E  = Y-pos
;A  = nr. of characters
writetext:
  push hl
  push de

  ld b,e

  ld hl,$9800
  ld de,32
godownmap:
  add hl,de
  dec b
  jr nz,godownmap

  pop de
  ld c,d
  ld b,0
  add hl,bc

  ld d,h
  ld e,l                ;DE = screenpos
  pop hl                ;HL = source
  ld b,a                ;B  = nr. of chars

  ld c,82
wrchar:
  ld a,(hli)
  add a,c

  call wrAtode

  inc de
  dec b
  jr nz,wrchar

  ret


no_schip_error:
  jp main

  call readpad
  cp 0
  jr nz,no_schip_error
  call erase_screen
  ld hl,txt_noschip1
  ld d,3
  ld e,6
  ld a,13
  call writetext
  ld hl,txt_noschip2
  ld d,3
  ld e,9
  ld a,14
  call writetext
no_schip_error_wait:
  call readpad
  cp 0
  jr z,no_schip_error_wait
  jp GAME_MENU

txt_noschip1:
.db "SUPER CHIP IS"
txt_noschip2:
.db "NOT AVALIABLE",91





;*******************
;** VBL interrupt **
;*******************
VBL_int:
  push af

  ld a,(sin_cnt)
  inc a
  ld (sin_cnt),a

;  ld a,(rnd_pos)
;  inc a
;  ld (rnd_pos),a

  ld a,(DT)     ;a = delay timer
  cp 0
  jr z,nodecDT
  dec a         ;DT -= 1
  ld (DT),a
nodecDT:
  ld a,(ST)
  cp 0
  jr z,soundOFF
  dec a
  ld (ST),a
  ld a,(sound_on)
  cp 0
  jr z,soundOFF

  ld a,$78
  ldh ($10),a
  ld a,$C1
  ldh ($11),a
  ld a,$F3
  ldh ($12),a
  ld a,$DC
  ldh ($13),a
  ld a,%10000101
  ldh ($14),a
  ld a,$FF
  ldh ($26),a
  ldh ($25),a
  ldh ($24),a

nodecST:
  pop af
  reti

soundOFF:
  xor a
  ldh ($26),a   ;stop sound output!
  jr nodecST



;********************
;** LCDC interrupt **	<- !This interrupt is disabled during play!
;********************
LCDC_int:
  push af

  ld a,(yint)
  inc a
  cp 144
  jr nz,noresyint
  xor a
noresyint:
  ld (yint),a
  ldh ($45),a

  ld a,(emu_running)
  cp 1
  jr z,emu_lcdc
;*****************************************
;*** LCDC_interrupt when menu is shown ***
;*****************************************
  push bc

lcdc_draw_curs:
  ld a,(cursY)
  ld b,a
  ld a,(yint)
  cp b
  jr c,noinv
  ld a,(cursY)
  ld b,8
  add a,b
  ld b,a
  ld a,(yint)
  cp b
  jr nc,noinv

  ld a,%11111001
  ldh ($47),a
  pop bc
  pop af
  reti


noinv:
  ld a,%11100100
  ldh ($47),a
lcdc_end_menu:
  pop bc
  pop af
  reti
;*************************************
;*** LCDC_interrupt when emu is on ***		;<- !DISABLED!
;*************************************
emu_lcdc:
  ld a,(schip_on)
  cp 0
  jr z,dbl_scr  ;double only if no S-CHIP8
  pop af
  reti

dbl_scr:
  ld a,DOUBLE_SCREEN
  cp 1
  jr z,dbl_scr2
  pop af
  reti

dbl_scr2:
  push de
  push hl

  ld a,(yint)
  ld hl,screenY
  ld e,a
  ld d,0
  add hl,de
  ld a,(hl)
  neg
  ldh ($42),a

  pop hl
  pop de
  pop af
  reti






;**********
;** DATA **
;**********
chip_map:
#include "chip.map"		;PLAY-SCREEN map
chip_tiles:
#include "chip.tle"		;The tiles

main_menu_map:
#include "chipm2.map"		;}
game_menu_map:			;}
#include "chipm1.map"		;}
joypad_menu_map:		;} The maps for the menus
#include "chipm3.map"		;}
about_menu_map:			;}
#include "chipm4.map"		;}
options_menu_map:		;}
#include "chipm5.map"		;}


rnd_table:
#include "chip.rnd"		;Random number table 0-255
sin_table:
#include "chip.sin"		;Sin table
#include "chip.sin"

#include "math.h"               ;Div and Mult operations

txt_keymap:
.db 56,57,58,"C",59,60,61,"D",62,63,64,"EA",65,"BF"
keymap:
.db 1,2,3,$C,4,5,6,$D,7,8,9,$E,$A,0,$B,$F
joymap:
.db $40,$80,$20,$10,1,2,8,4

txt_questionmark:
.db 104


char_data:
;**************** CHIP8 FONTS 4x5 *****************

;*** 0 ***
.db %01100000
.db %10010000
.db %10010000
.db %10010000
.db %01100000
.db %00000000
;*** 1 ***
.db %00100000
.db %01100000
.db %00100000
.db %00100000
.db %01110000
.db %00000000
;*** 2 ***
.db %01100000
.db %10010000
.db %00010000
.db %00100000
.db %11110000
.db %00000000
;*** 3 ***
.db %01100000
.db %10010000
.db %00100000
.db %10010000
.db %01100000
.db %00000000
;*** 4 ***
.db %10000000
.db %10100000
.db %11110000
.db %00100000
.db %00100000
.db %00000000
;*** 5 ***
.db %11110000
.db %10000000
.db %11100000
.db %00010000
.db %11100000
.db %00000000
;*** 6 ***
.db %00100000
.db %01000000
.db %11100000
.db %10010000
.db %01100000
.db %00000000
;*** 7 ***
.db %11110000
.db %00010000
.db %00100000
.db %01000000
.db %10000000
.db %00000000
;*** 8 ***
.db %01100000
.db %10010000
.db %01100000
.db %10010000
.db %01100000
.db %00000000
;*** 9 ***
.db %01100000
.db %10010000
.db %01110000
.db %00100000
.db %01000000
.db %00000000
;*** A ***
.db %01100000
.db %10010000
.db %11110000
.db %10010000
.db %10010000
.db %00000000
;*** B ***
.db %11100000
.db %10010000
.db %11100000
.db %10010000
.db %11100000
.db %00000000
;*** C ***
.db %01100000
.db %10010000
.db %10000000
.db %10010000
.db %01100000
.db %00000000
;*** D ***
.db %11100000
.db %10010000
.db %10010000
.db %10010000
.db %11100000
.db %00000000
;*** E ***
.db %11110000
.db %10000000
.db %11100000
.db %10000000
.db %11110000
.db %00000000
;*** F ***
.db %11110000
.db %10000000
.db %11100000
.db %10000000
.db %10000000
.db %00000000
;************** SUPER-CHIP FONTS 8x10 ********************

;*** 0 ***
.db %01111100
.db %11111110
.db %11101110
.db %11000110
.db %11000110
.db %11000110
.db %11101110
.db %11111110
.db %01111100
.db %00000000
;*** 1 ***
.db %00011000
.db %00111000
.db %01111000
.db %00011000
.db %00011000
.db %00011000
.db %00011000
.db %00011000
.db %11111110
.db %00000000
;*** 2 ***
.db %00111100
.db %01100110
.db %11000010
.db %00000110
.db %00001100
.db %00011000
.db %00110000
.db %11111110
.db %11111110
.db %00000000
;*** 3 ***
.db %00111000
.db %01111100
.db %11000110
.db %11000110
.db %00001100
.db %11000110
.db %11000110
.db %01111100
.db %00111000
.db %00000000
;*** 4 ***
.db %11000000
.db %11000000
.db %11011000
.db %11011000
.db %11111110
.db %00011000
.db %00011000
.db %00011000
.db %00011000
.db %00000000
;*** 5 ***
.db %11111110
.db %11111110
.db %11000000
.db %11111000
.db %11111100
.db %00000110
.db %00000110
.db %11111100
.db %11111000
.db %00000000
;*** 6 ***
.db %11000000
.db %11000000
.db %11000000
.db %11111100
.db %11111110
.db %11000110
.db %11000110
.db %11111110
.db %01111100
.db %00000000
;*** 7 ***
.db %11111110
.db %11111110
.db %00000110
.db %00001100
.db %00011000
.db %00110000
.db %01100000
.db %11000000
.db %11000000
.db %00000000
;*** 8 ***
.db %01111100
.db %11101110
.db %11000110
.db %11101110
.db %01111100
.db %11101110
.db %11000110
.db %11101110
.db %01111100
.db %00000000
;*** 9 ***
.db %01111100
.db %11111110
.db %11000110
.db %11000110
.db %11111110
.db %01111110
.db %00000110
.db %00000110
.db %00000110
.db %00000000
;*** A ***
.db %01111100
.db %11111110
.db %11000110
.db %11000110
.db %11111110
.db %11000110
.db %11000110
.db %11000110
.db %11000110
.db %00000000
;*** B ***
.db %11111100
.db %11111110
.db %11000110
.db %11000110
.db %11001100
.db %11000110
.db %11000110
.db %11111110
.db %11111100
.db %00000000
;*** C ***
.db %01111100
.db %11111110
.db %11000110
.db %11000000
.db %11000000
.db %11000000
.db %11000110
.db %11111110
.db %01111100
.db %00000000
;*** D ***
.db %11111100
.db %11111110
.db %11000110
.db %11000110
.db %11000110
.db %11000110
.db %11000110
.db %11111110
.db %11111100
.db %00000000
;*** E ***
.db %11111110
.db %11111110
.db %11000000
.db %11000000
.db %11110000
.db %11000000
.db %11000000
.db %11111110
.db %11111110
.db %00000000
;*** F ***
.db %11111110
.db %11111110
.db %11000000
.db %11000000
.db %11110000
.db %11000000
.db %11000000
.db %11000000
.db %11000000
.db %00000000




screenY:
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0

.db 0,1
.db 1,2
.db 2,3
.db 3,4
.db 4,5
.db 5,6
.db 6,7
.db 7,8
.db 8,9
.db 9,10
.db 10,11
.db 11,12
.db 12,13
.db 13,14
.db 14,15
.db 15,16
.db 16,17
.db 17,18
.db 18,19
.db 19,20
.db 20,21
.db 21,22
.db 22,23
.db 23,24
.db 24,25
.db 25,26
.db 26,27
.db 27,28
.db 28,29
.db 29,30
.db 30,31
.db 31,32



.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0
.db 0,0,0,0,0,0,0,0,0,0


bank_data:
.db 2,2,2,3,3,3,3
.db 4,4,4,4
adr_data:
.db $50,$60,$70
.db $40,$50,$60,$70
.db $40,$50,$60,$70


.org $8000
.end
