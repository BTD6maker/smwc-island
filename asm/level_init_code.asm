levelinit0:
    RTS
levelinit1:
    RTS
levelinit2:
    RTS
levelinit3:
    LDA #$0000
    STA $710000     ;reset arena stage
    STA $710001     ;reset arena stage
    STA $710003     ;reset "amount of sprites spawned so far"
    STA $710005     ;reset state
    RTS
levelinit4:
    RTS
levelinit5:
    RTS
levelinitD2:
    SEP #$10
    LDX #$02
    LDY #$52
    JSR ChangeSprGFXFile

levelinit6:
    SEP #$10
    LDA #$0001      ; bg sparkles
    STA $7020D8
    STA $7020DA
    STA $7020DC
    STA $7020DE

    LDA #$00C2      ; BG2 colors
    STA $7020D0
    LDA #$0104
    STA $7020D2
    LDA #$0168
    STA $7020D4
    LDA #$060D
    STA $7020D6

    LDA #$0668      ; BG1 lava colors
    STA $7020A6
    LDA #$074D
    STA $7020A8
    LDA #$07D7
    STA $7020AA
    LDA #$13FD
    STA $7020AC

.shared
    LDA #$000C      ; yoshi color fix
    STA $6116

    LDA #$0962      ; water colors
    STA $702070
    LDA #$0A08
    STA $702072
    LDA #$0A8F
    STA $702074
    LDA #$0B55
    STA $702076

    LDA #$0000      ; for the gradient upload
    STA $7FFF12

    ; init time
    LDA !watertime_2_init
    STA !gastimer

    ; reset time
    LDA !watertime_2_reset
    STA !decaytime_reset

    LDA !watersound
    STA !decaysound
    RTS

tbh:
    incbin "a.mw3":62-A0

levelinit7:
levelinit8:
levelinit9:
levelinitA:
levelinitB:
levelinitC:
levelinitD:
levelinitE:
levelinitF:
levelinit10:
levelinit11:
    RTS
levelinit12:
levelinit13:
levelinit14:
levelinit15:
levelinit16:
levelinit17:
levelinit18:
levelinit19:
levelinit1A:
levelinit1B:
levelinit1C:
levelinit1D:
levelinit1E:
levelinit1F:
levelinit20:
levelinit21:
levelinit22:
levelinit23:
levelinit24:
levelinit25:
levelinit26:
levelinit27:
levelinit28:
levelinit29:
levelinit2A:
levelinit2B:
    RTS
levelinit2C:
    SEP #$10

    ; disable items
    LDA #$0001
    STA $0B48

    JSR remove_egg_inventory
    RTS

levelinit2D:
levelinit2E:
levelinit2F:
levelinit30:
levelinit31:
levelinit32:
levelinit33:
levelinit34:
levelinit35:
levelinit36:
levelinit37:
levelinit38:
levelinit39:
    RTS
levelinit3A:
    LDA #$0A
    STA $03B4
    RTS
levelinit3B:
    RTS
levelinit3C:
    RTS
levelinit3D:
    SEP #$10
    LDX #$04            ;slot 4   (3 is the bandit!)
    LDY #$35            ;dance guy file
    JSR ChangeSprGFXFile    ;jump to imamelia's code

    LDA #$0460          ;prep the countdown till yoshi is in control
    STA !burtcountdown

    ; init some variables
    STZ !burtflippybit
    STZ !burtimer
    STZ !burtcounter
    STZ !burtgate
    RTS
levelinit3E:
    RTS
levelinit3F:
    SEP #$10
    LDA #$0962      ; water colors
    STA $702070
    LDA #$0A08
    STA $702072
    LDA #$0A8F
    STA $702074
    LDA #$0B55
    STA $702076

    LDA #$0A46      ; waterfall colors
    STA $7020A6
    LDA #$06EE
    STA $7020A8
    LDA #$0796
    STA $7020AA
    LDA #$23FD
    STA $7020AC

    LDX #$3E
.loop
    LDA tbh,x
    STA $7020C2,x
    DEX
    DEX
    BPL .loop

    JMP levelinit6_shared

levelinit40:
    RTS
levelinit41:
    LDA #$0001
    STA $0B48   ; Disable items
    RTS

levelinit42:
levelinit43:
levelinit44:
levelinit45:
    RTS
levelinit46:
    LDA #$0001
    STA $0B48   ; Disable items
    RTS

levelinit47:
levelinit48:
levelinit49:
levelinit4A:
levelinit4B:
levelinit4C:
levelinit4D:
levelinit4E:
levelinit4F:
    ; JSR init_sewer
    ; RTS

levelinit50:
levelinit51:
levelinit52:
levelinit53:
levelinit54:
levelinit55:
levelinit56:
levelinit57:
levelinit58:
    RTS

levelinit59:
    LDA $6090
    CMP #$0300
    BCS .not_high_enough
    LDA #$0000      ; sprite gfx upload stuff
    STA $7FFF10
    LDA #$472B
    STA $6EB7
.not_high_enough
    RTS

levelinit5A:
levelinit5B:
levelinit5C:
levelinit5D:
    RTS
levelinit5E:
    ; init & reset times
    LDA !gastime_1
    STA !gastimer
    STA !decaytime_reset

    LDA !gassound
    STA !decaysound

    LDA $03B6
    DEC A
    DEC A
    STA !gasstars

    ; lock menu items
    LDA #$0001
    STA $0B48
    RTS

levelinit5F:
levelinit60:
levelinit61:
levelinit62:
    RTS

levelinit63:
    LDA #$0001
    STA $0B48   ; Disable items
    RTS

levelinit64:
    RTS

levelinit65:
!shysprite = $001E
;sprite number (1E is shyguy)

!shyinterval = $003F
;how often to generate, has to be a multiple of 2 (-1)
;eg 01, 03, 07, 0F, 1F etc

!shylimit = $0007
;how many shyguys can be on screen at once +1 (currently 6)

    SEP #$10
    LDA #!shysprite
    STA !srID
    LDA #!shyinterval
    STA !srint
    LDA #!shylimit
    STA !srlimit
    SEP #$20
    LDA.b #.RangesEnd-.Ranges-$2
    STA !srlen
    REP #$20

    LDA $7f1337

    LDX.b #.RangesEnd-.Ranges-$2
      .uploadloop

    LDA .Ranges,x
    STA !srranges,x

    DEX
    DEX
    BPL .uploadloop

    RTS

;start of range (right edge of screen), end of range (left edge of screen)
;that means that the above first entry will span across the entire second screen
;little blech but it needs to be like that

.Ranges
    dw $0170,$0220
    dw $0310,$0340
    dw $03D0,$0430
    dw $0520,$05E0
.RangesEnd

    RTS
levelinit66:
levelinit67:
levelinit68:
levelinit69:
levelinit6A:
levelinit6B:
levelinit6C:
levelinit6D:
    RTS
levelinit6E:
print "Level 6E Init: $",pc
	JSR .SetItemMemory

    ; first entrance to room?
    LDA $6094
    AND #$FF00
    CMP #$0200
    BNE .check_midring

    ; on first entrance, init all vars
    STZ !arenahistage
    STZ !arenastage
    STZ !arenastate
    STZ !arenasindex
    STZ !arenaframes
    STZ !arenalockx
    STZ !arenatimer
    STZ !arenasindex
    STZ !arenascount
    RTS

    ; midring entrance?
.check_midring
    CMP #$0B00
    BNE .ret

    ;STZ !arenahistage
    LDA #$020D
    STA !arenastage

    STZ !arenastate

    LDA #$001E
    STA !arenasindex

    ; other entrances should do nothing special
.ret
    RTS

.SetItemMemory	; This one prevents red coins and flowers from an arena to spawn until an arena starts -- activated arenas don't reset the item memory.
	PHD
	LDA $0150
	ASL
	TAX
	LDA $03D3C3,x
	PHA
	PLD

	SEP #$10
	LDA #$0002
	SEC : SBC !arenahistage
	TAY
.Loop
	LDX .ArenaScreen,y
	LDA $6CAA,x
	AND #$003F
	ASL
	TAX
	LDA #$FFFF
	STA $00,x
	DEY
	BPL .Loop
	REP #$10

	PLD
RTS

.ArenaScreen:
db $2E,$2B,$24

levelinit6F:
levelinit70:
    SEP #$10

    ; disable items
    LDA #$0001
    STA $0B48

    JSR remove_egg_inventory
    RTS

levelinit71:
levelinit72:
levelinit73:
levelinit74:
levelinit75:
levelinit76:
levelinit77:
levelinit78:
levelinit79:
levelinit7A:
levelinit7B:
levelinit7C:
levelinit7D:
    ; JSR init_sewer
    ; RTS

levelinit7E:
levelinit7F:
levelinit80:
levelinit81:
levelinit82:
levelinit83:
levelinit84:
levelinit85:
levelinit86:
levelinit87:
levelinit88:
levelinit89:
    RTS

levelinit8A:
; palette fix for BG3 clouds Sluggy fight 5-4
    LDA #$1773
    STA $702004
    RTS

levelinit8B:
levelinit8C:
levelinit8D:
levelinit8E:
    RTS

levelinit8F:
    LDA #$0001
    STA $0B48   ; Disable items
    RTS

levelinit90:
    RTS

levelinit91:
!poochyzsprite = $00FF
;sprite number (1E is shyguy)

!poochyzinterval = $003F
;how often to generate, has to be a multiple of 2 (-1)
;eg 01, 03, 07, 0F, 1F etc

!poochyzlimit = $0002
;how many shyguys can be on screen at once +1 (currently 6)

    SEP #$10
    LDA #!poochyzsprite
    STA !srID
    LDA #!poochyzinterval
    STA !srint
    LDA #!poochyzlimit
    STA !srlimit
    SEP #$20
    LDA.b #.RangesEnd-.Ranges-$2
    STA !srlen
    REP #$20

    LDA $7f1337

    LDX.b #.RangesEnd-.Ranges-$2
.uploadloop

    LDA .Ranges,x
    STA !srranges,x

    DEX
    DEX
    BPL .uploadloop

    RTS

;start of range (right edge of screen), end of range (left edge of screen)
;that means that the above first entry will span across the entire second screen
;little blech but it needs to be like that
.Ranges
    dw $0400,$0780

.RangesEnd
    RTS
levelinit92:
    RTS
levelinit93:
    RTS
levelinit94:
    RTS
levelinit95:
    RTS
levelinit96:
    RTS
levelinit97:
    RTS
levelinit98:
    SEP #$10

    LDA $6094
    CMP #$0500
    BCS .piroon

.piroon
    LDX #$05            ;slot 5
    LDY #$45            ;sparky file
    JSR ChangeSprGFXFile    ;jump to imamelia's code
    RTS
levelinit99:
levelinit9A:
levelinit9B:
levelinit9C:
levelinit9D:
levelinit9E:
    RTS

levelinit9F:
    LDA #$0001
    STA $0B48   ; Disable items
    RTS
levelinitA0:
levelinitA1:
levelinitA2:
levelinitA3:
levelinitA4:
levelinitA5:
levelinitA6:
levelinitA7:
levelinitA8:
levelinitA9:
levelinitAA:
levelinitAB:
levelinitAC:
levelinitAD:
levelinitAE:
levelinitAF:
    RTS

levelinitB0:
    ; init & reset times
    LDA !gastime_2

.load_decay
    STA !gastimer
    STA !decaytime_reset

    LDA !gassound
    STA !decaysound

    LDA $03B6
    DEC A
    DEC A
    STA !gasstars

    ; lock menu items
    LDA #$0001
    STA $0B48
    RTS

levelinitB1:
levelinitB2:
levelinitB3:
    RTS

levelinitB4:
    LDA #$0001
    STA $0B48   ; Disable items
    RTS

levelinitB5:
levelinitB6:
levelinitB7:
levelinitB8:
    RTS

levelinitB9:
    SEP #$10

    LDA #$0000
    STA $711000

    LDX #$05            ;slot 5
    LDY #$2E            ;ski lift file
    JSR ChangeSprGFXFile    ;jump to imamelia's code
    RTS

levelinitBA:
    LDA #$0001
    STA $0B48   ; Disable items
    RTS

levelinitBB:
levelinitBC:
levelinitBD:
levelinitBE:
levelinitBF:
levelinitC0:
levelinitC1:
levelinitC2:
levelinitC3:
levelinitC4:
levelinitC5:
levelinitC6:
levelinitC7:
levelinitC8:
levelinitC9:
levelinitCA:
levelinitCB:
levelinitCC:
levelinitCD:
levelinitCE:
levelinitCF:
levelinitD0:
    RTS
levelinitD1:
    LDA !gastime_3
    JMP levelinitB0_load_decay
    ; ; sewer water color
    ; LDA #$00E0
    ; STA $7020A2

    ; ; sewer platforms
    ; LDA #$25D4
    ; STA $7020B2

    ; ; sewer shading
    ; LDA #$192A
    ; STA $702098
    ; LDA #$1509
    ; STA $70209A
    ; LDA #$10C9
    ; STA $70209C
    ; LDA #$0CA5
    ; STA $70209E
levelinitD3:
levelinitD4:
levelinitD5:
levelinitD6:
levelinitD7:
levelinitD8:
levelinitD9:
levelinitDA:
levelinitDB:
levelinitDC:
levelinitDD:
    RTS