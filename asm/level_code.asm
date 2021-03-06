incsrc smwci.asm

level0:
level1:
level2:
level3:
level4:
    RTS
level5:
    LDA #$0002
    STA $7000AE
    RTS
levelD2:
level6:
    SEP #$10
    LDA $30
    AND #$0007
    BNE .skip_animations

    LDX #$06            ; get the current colors in scratch ram
-   LDA $7020D0,x
    STA $00,x
    LDA $7020A6,x
    STA $0C,x
    DEX
    DEX
    BPL -

    LDA $00             ; make the animation loop
    STA $08
    LDA $12
    STA $0A

    LDX #$06            ; apply the animation
-   LDA $02,x
    STA $7020D0,x
    LDA $0A,x
    STA $7020A6,x
    DEX
    DEX
    BPL -

.skip_animations
    LDA $7FFF12
    BNE .shared
    LDA.w #.gradient>>16
    STA $3000
    LDA.w #.gradient
    STA $3002
    LDX #$08            ; call GSU routine $0890E7
    LDA #$90E7
    JSL $7EDE44
    LDA #$56DE          ; WRAM dst addr
    STA $20
    LDY #$7F            ; WRAM dst bank
    STY $22
    LDA #$5800          ; src addr
    STA $23
    LDY #$70            ; src bank
    STY $25
    LDA #$0522          ; data size
    JSL $008288         ; DMA $705800 -> $7F56DE, $0522 bytes
    LDA #$0001
    STA $7FFF12         ; don't run again

.shared

; 60C6 (counts to 3) and 60FA are nonzero when swimming

    LDA $61B0           ; check pause flags
    ORA $0B55
    ORA $0398
    ORA $0B0F
    BNE .return

    LDA $61B2           ; if baby mario is off, don't do shit
    BEQ +
    LDA $60FA
    BNE .swimming
+
    LDA !watertime_2_init     ; just fell into water, init
    STA !gastimer
    LDA $03B6
    DEC
    DEC
    STA !gasstars
.return
    RTS

.swimming
    JMP starcount_decay

.gradient
    dw $46F5,$3AF0,$2AC8,$2A66
    dw $25E4,$2583,$2922,$20C1
    dw $1861,$1421,$1C22,$2424
    dw $3028,$382C,$4030,$4053
    dw $3877,$349A,$2CFB,$2D7B
    dw $3A3B,$46BB,$4EFB,$5B5B

level7:
level8:
level9:
levelA:
levelB:
levelC:
levelD:
levelE:
levelF:
level10:
level11:
level12:
level13:
level14:
level15:
level16:
level17:
level18:
level19:
    RTS
level1A:
    JSR HOT_LIPS_HIDEOUT
    RTS

level1B:
level1C:
level1D:
level1E:
level1F:
level20:
level21:
    RTS

level59:
    SEP #$10
    LDA $6090
    CMP #$0300
    BCC .good_enough
    JMP ++
.good_enough

    LDA $7FFF10
    BNE +
    INC
    STA $7FFF10

    ; decompress file $1F
    ; to $706800
    ; must be uploaded to $D200
    ; also it's $0400 bytes long
    ; note: $00B753 decompresses files from the other table

    LDA #$0400>>6       ; the size of the decompressed file
    STA $3006
    LDA $06FC79+($2B*3) ; get the vram address
    STA $3002
    LDA $06FC7B+($2B*3)
    AND #$00FF
    STA $3000
    LDX #$0A        ; call $0A8000 (GSU)
    LDA #$8000
    JSL $7EDE44

    ; random notes
    ; $0000,y -> $2116 (dst)
    ; $0004,y -> $4301 (src lo, $18 = stuff?)
    ; $0006,y -> $4303 (src bank, src hi)
    ; $0008,y -> $4305 (size)
    ; $0002,y -> $2115 ($80)
    ; $0003,y -> $4300 ($01 = ?)

    REP #$10
    LDA #$7058      ; src bank, hi
    STA $00
    LDX #$5800      ; src lo
    LDY #$D200      ; dst
    LDA #$0400      ; size
    JSL $00BEA6
    SEP #$10
    BRA ++

+   CMP #$0001
    BNE ++
    INC
    STA $7FFF10

    LDA #$0400>>6       ; the size of the decompressed file
    STA $3006
    LDA $06FC79+($47*3) ; get the vram address
    STA $3002
    LDA $06FC7B+($47*3)
    AND #$00FF
    STA $3000
    LDX #$0A        ; call $0A8000 (GSU)
    LDA #$8000
    JSL $7EDE44

    REP #$10
    LDA #$7058      ; src bank, hi
    STA $00
    LDX #$5800      ; src lo
    LDY #$D400      ; dst
    LDA #$0400      ; size
    JSL $00BEA6
    SEP #$10
++

level22:
    SEP #$10
    LDX #$5C
.loop
    LDA $7360,x     ; check if any sprite is a climbing grinder
    CMP #$01A7
    BEQ .grinder
    CMP #$01A9
    BNE .skip
.grinder
    LDA $6F00,x     ; check if the sprite is active
    CMP #$0010
    BNE .skip
    LDA $70E0,x     ; if the position was fixed, don't do it again
    AND #$FF00
    BNE .skip
    LDA $7400,x     ; move the sprite in the opposite direction
    TAY
    LDA $70E2,x
    CLC
    ADC .x_disp,y
    STA $70E2,x
    LDA $70E0,x     ; set as fixed
    ADC #$0100
    STA $70E0,x
.skip
    DEX
    DEX
    DEX
    DEX
    BPL .loop
    RTS

.x_disp
    dw $0010,$FFF0

level23:
    JMP level5A

level24:
level25:
level26:
level27:
level28:
level29:
level2A:
level2B:
level2C:
level2D:
level2E:
level2F:
level30:
level31:
level32:
level33:
level34:
level35:
level36:
level37:
level38:
level39:
level3A:
level3B:
level3C:
    RTS
level3D:
    SEP #$10
    JSR BurtBoss
    RTS
level3E:
    LDA $700090
    CMP #$0300
    BCS CarMorph
    RTS

CarMorph:
    LDA #$0002
    STA $7000AE
    RTS
level3F:
    ; 602f is 98 when stepping on waterfalls
; 6117 is 3000-6000
; 61EA is 8-7-6-5-4-3-2-1
    SEP #$10

    ; LDA #$1A82
    ; STA $702002
    ; LDA #$1DA2
    ; STA $702004
    ; LDA #$3770
    ; STA $702006

    LDA $30
    AND #$0007
    BNE .skip1

    LDX #$06            ; get the current colors in scratch ram
-   LDA $7020A6,x
    STA $02,x
    DEX
    DEX
    BPL -

    LDA $08             ; make the animation loop
    STA $00


    LDX #$06            ; apply the animation
-   LDA $00,x
    STA $7020A6,x
    DEX
    DEX
    BPL -

.skip1

    LDA $30
    AND #$0003
    BNE .skip2

    LDX #$0E            ; another animation
-   LDA $7020F0,x
    STA $02,x
    DEX
    DEX
    BPL -

    LDA $10
    STA $00

    LDX #$0E
-   LDA $00,x
    STA $7020F0,x
    DEX
    DEX
    BPL -

.skip2

    JMP level6_shared
level40:
level41:
level42:
level43:
level44:
level45:
level46:
level47:
level48:
level49:
level4A:
level4B:
level4C:
level4D:
level4E:
level4F:
    ; JSR animate_sewage
    ; RTS

level50:
level51:
level52:
level53:
level54:
level55:
level56:
    RTS
level57:
!translength = $0004      ;how long transformations last
;this caps the transformation length

    LDA $61F4
    CMP #!translength
    BCC .kcool
    LDA #!translength-1
    STA $61F4

.kcool
    RTS

level58:
    RTS

level5A:
    SEP #$10
    JSR GRAVITY_NONSENSE
    RTS

level5B:
level5C:
level5D:
    RTS

level5E:
    ; decay starcounter
    JSR starcount_decay
    RTS

level5F:
level60:
level61:
level62:
level63:
level64:
    RTS

level65:
    SEP #$10
    JSL SpriteRain
    RTS

level66:
level67:
level68:
level69:
level6A:
level6B:
level6C:
level6D:
    RTS
level6E:
    SEP #$10
    JSR Coliseum       ;jump to the coliseum mechanics
    RTS

level6F:
    LDA #$0002
    STA $7000AE
    RTS
level70:
    SEP #$10

    ; make all Slime Drops inedible
    LDX #$5C
.loop
    LDA $7360,x
    CMP #$0132
    BNE .skip
    LDA $6FA2,x
    ORA #$1000
    STA $6FA2,x

.skip
    DEX
    DEX
    DEX
    DEX
    BPL .loop
    RTS

level71:
level72:
level73:
level74:
level75:
level76:
level77:
level78:
level79:
level7A:
level7B:
level7C:
level7D:
    ; JSR animate_sewage
    ; RTS

level7E:
level7F:
level80:
level81:
level82:
level83:
level84:
level85:
level86:
level87:
level88:
level89:
level8A:
level8B:
level8C:
level8D:
level8E:
level8F:
level90:
    RTS
level91:
    SEP #$10
    JSL SpriteRain
    RTS

level92:
level93:
level94:
level95:
level96:
level97:
    RTS
level98:
!piroindex = $711000
;counts the amount of piro dangles on screen

!Pirodist = $711002
;temp store for one half of the distance (x)

    SEP #$10

    LDA $0B55
    ORA $0398
    ORA $0B0F
    BEQ .execute    ;check for pause flags

.return2
    RTS

.execute
    ;-----  piro darkness control
    LDA #$0000
    STA !piroindex


    LDX #$17      ;init sprite loop

.PiroLoop
    PHX

    TXA
    CMP #$0006    ;dont loop through reserved sprites
    BCC .Pironext
    ASL
    ASL
    TAX           ;index *4 for all the weird-ass tables

    LDA $6F00,x   ;check sprite state
    BEQ .Pironext ;if dead, skip

    LDA $7360,x   ;sprite ID
    CMP #$0076    ;piro 1
    BEQ .Piroinc  ;if a piro, increase piro counter
    CMP #$0077    ;piro 2
    BNE .Pironext ;if not a piro, don't increase piro counter

.Piroinc
    ;calculate how far away the sprite is
    LDA $70E2,x
    CMP $608C       ;check if the sprite is to the left or the right
    BCS .xisbigger

    ;and do math accordingly to get the distance positive
    LDA $608c
    SEC
    SBC $70E2,x

    BRA .donex

.xisbigger

    SEC
    SBC $608C

.donex
    STA !Pirodist ;store x distance

    LDA $7182,x
    CMP $6090       ;check if the sprite is above or below
    BCS .yisbigger

    ;and do math accordingly to get the distance positive
    LDA $6090
    SEC
    SBC $7182,x

    BRA .doney

.yisbigger
    SEC
    SBC $6090

.doney
    CLC           ;add the previously calculated x distance
    ADC !Pirodist
    STA !Pirodist ;store the total distance

    LDX #$1A

.DistLoop

    LDA !Pirodist
    CMP .Piroranges,x
    BCC .foundrange

    DEX
    DEX
    BPL .DistLoop

.foundrange
    LDA #$0000
    TXA
    LSR

    CLC
    ADC !piroindex  ;add current index with other dangles' indexes
    CMP #$000E      ;maximum index of 0D
    BCC .Pirostore

    LDA #$000D

.Pirostore
    STA !piroindex

.Pironext
    PLX
    DEX           ;keep running
    BPL .PiroLoop

    SEP #$20
    LDA $0200
    AND #$80
    CLC
    ADC !piroindex
    ADC #$02
    STA $0200
    REP #$20

    RTS

.Piroranges
    dw $0400,$00A8,$0090,$0078,$0060,$0058,$0050,$0048,$0040,$0038,$0030,$0028,$0020,$0018

level99:
level9A:
level9B:
level9C:
level9D:
level9E:
level9F:
levelA0:
levelA1:
levelA2:
levelA3:
levelA4:
levelA5:
levelA6:
levelA7:
levelA8:
levelA9:
levelAA:
levelAB:
levelAC:
levelAD:
levelAE:
levelAF:
    RTS
levelB0:
    ; exception for a (needed) midring room here
    ; just check X coordinate
    LDA $608C
    CMP #$0390
    BCS .ret

    JSR starcount_decay
.ret
    RTS
levelB1:
levelB2:
levelB3:
levelB4:
levelB5:
levelB6:
levelB7:
levelB8:
    RTS
levelB9:
    SEP #$10

    LDA $711000
    BEQ .switchfile
    RTS

.switchfile
    INC
    STA $711000

    LDX #$01            ;slot 1 (gusty)
    LDY #$2D            ;horizontal cloud drop file
    JSR ChangeSprGFXFile    ;jump to imamelia's code
    RTS
levelBA:
levelBB:
levelBC:
levelBD:
levelBE:
levelBF:
levelC0:
levelC1:
levelC2:
levelC3:
levelC4:
levelC5:
levelC6:
levelC7:
levelC8:
    RTS

!acid_ID = #$013B
!acid_wave_amount = #$0010
!acid_threshold_right = #$0100
!acid_threshold_left = #$FF00

levelC9:
    SEP #$10
    ; loop through sprite tables
    LDX #$5C

.loop_sprite
    ; make sure this slot is spawned in
    LDA $6F00,x
    BEQ .next_sprite

    ; is this sprite not froggy acid? don't do anything
    LDA $7360,x
    CMP !acid_ID
    BNE .next_sprite

    ; 0 means no direction yet
    LDA $7900,x
    BNE .check_direction

    ; otherwise, random direction
    LDA $10
    STA $7900,x

.check_direction
    BMI .check_left

    ; if past threshold, start moving left
    LDA $7220,x
    CMP !acid_threshold_right
    BPL .move_left

    ; otherwise, continue moving right
.move_right
    CLC
    ADC !acid_wave_amount
    STA $7220,x
    LDA #$0001
    STA $7900,x
    BRA .next_sprite

.check_left
    LDA $7220,x
    CMP !acid_threshold_left
    BMI .move_right

    ; otherwise, continue moving left
.move_left
    SEC
    SBC !acid_wave_amount
    STA $7220,x
    LDA #$FFFF
    STA $7900,x

.next_sprite
    DEX
    DEX
    DEX
    DEX
    BNE .loop_sprite
    RTS
levelCA:
levelCB:
levelCC:
levelCD:
levelCE:
levelCF:
levelD0:
    RTS



levelD1:
;     ; animate sewage palette
;     INC !sewage_timer
;     LDA !sewage_timer
;     CMP #$0004
;     BCC .poison_water

;     STZ !sewage_timer

;     LDX !sewage_animate
;     LDA sewage_colors,x
;     STA $7020A6
;     JSR sewage_inc_mod

;     LDA sewage_colors,x
;     STA $7020A8
;     JSR sewage_inc_mod

;     LDA sewage_colors,x
;     STA $7020AA
;     JSR sewage_inc_mod

;     LDA sewage_colors,x
;     STA $7020AC

;     LDA !sewage_animate
;     DEC A
;     DEC A
;     AND #$0007
;     STA !sewage_animate

; .poison_water
    ; check pause flags
    LDA $61B0
    ORA $0B55
    ORA $0398
    ORA $0B0F
    BNE .ret

    ; check safe zone
    LDA $6090
    CMP #$0600
    BCC .ret

    ; 60C6 (counts to 3) and 60FA are nonzero when swimming
    LDA $61B2           ; if baby mario is off, don't do shit
    BEQ .reset_timer
    LDA $60FA
    BNE .ret_safe_swimming

    JSR starcount_decay
    BRA .ret

.ret_safe_swimming
    LDA !gasstars
    STA $03B6
    RTS

.reset_timer
    LDA !gastime_2
    STA !gastimer
    LDA $03B6
    DEC A
    DEC A
    STA !gasstars

.ret
    RTS

levelD3:
levelD4:
levelD5:
levelD6:
levelD7:
levelD8:
    RTS
levelD9:
    SEP #$30
    LDA $7000AC           ;is Yoshi entering a door?
    CMP #$0A
    BNE .end_removing_item_memory
    LDA $70008D           ;is this the right X-screen number?
    CMP #$0C
    BNE .end_removing_item_memory
.removing_item_memory
    LDX #$00
.item_memory_loop
    STZ $0540,x           ;clear page 3 of Item Memory
    INX
    CPX #$7F              ;Has it finished?
    BNE .item_memory_loop
.end_removing_item_memory
    RTS
levelDA:
levelDB:
levelDC:
levelDD:
    RTS
