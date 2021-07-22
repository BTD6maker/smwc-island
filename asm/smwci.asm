; common routines called in SMWCI by multiple sublevels

; used in 5-4, the "toxic gas" that constantly depletes star counter
starcount_decay:
    ; $12C = 300 frames = 5 seconds
    !gastime_1 = #$012C
    !gastime_2 = #$0078
    !gastime_3 = #$008C
    !watertime_1_init = #$0003
    !watertime_1_reset = #$000C
    !watertime_2_init = #$001E
    !watertime_2_reset = #$005A

    ;sound to play every time it depletes
    ;list can be found here http://yoshidis.wikia.com/wiki/Sound_IDs
    !gassound = #$0052
    !watersound = #$0062

    ;how much time left till next star depletion
    !gastimer = $7F0000

    ;is written to the star value every frame to fight the regen
    !gasstars = $0290

    !decaytime_reset = $7F0004
    !decaysound = $7F0006

    ;----------------------------------------

    ;make stars always show
    LDA #$0061
    STA $0B7D

    ; check for pause flags
    LDA $61B0
    ORA $0B55
    ORA $0398
    ORA $0B0F
    BNE .ret

    LDA #$0002
    STA $0B7F

    LDA $03B6
    SEC              ;substract gasstars from real stars
    SBC !gasstars

    CMP #$0009       ;check how much the difference is
    BCC .nochange    ;if not more than 09, then it's just regenning
    CMP #$000C
    BCS .quickdeplete ;but if more than 0C, it has to be baby mario flying around

    LDA $7F1337

    LDA !gasstars
    CLC              ;add the stars
    ADC #$000A
    STA !gasstars

.nochange
    LDA $03B6
    CMP #$0009
    BCC .killyoster  ;death at 0 stars
    BMI .killyoster  ;death at negative stars
    BRA .goon

.quickdeplete
    DEC !gasstars

.goon
    LDA !gastimer
    DEC             ;tick frame counter
    BMI .takestar
    STA !gastimer
    BRA .writestars

.takestar
    LDA !decaytime_reset
    STA !gastimer   ;reset timer

    LDA !gasstars
    SEC
    SBC #$000A      ;decrease a single star
    STA !gasstars

    LDA !decaysound
    JSL $0085D2         ;sound into sound buffer

.writestars
    LDA !gasstars
    BPL .storethem

    LDA #$0000
    STA !gasstars   ;never go <0

.storethem
    STA $03B6       ;transfer our stars to the game's stars

.ret
    RTS

.killyoster
    REP #$10
    JSL $04AC9C
    RTS

; Input:
; X = GFX file index (should be 00-05)
; Y = GFX file number
; Used:
; $00-$01 - pointer offset
; $02-$03 - VRAM address
ChangeSprGFXFile:
    PHP
    SEP #$30            ;
    TYA                 ;
    STA $6EB6,x         ; put graphics file # into sprite slot SRAM
    STY $00             ; and into $00

    REP #$30            ;
    AND #$00FF          ; clear high byte
    ASL                 ;
    ADC $00             ; GFX file number * 3
    STA $00             ;

    TXA                 ;
    XBA                 ;
    AND #$FF00          ;
    ASL                 ; X * 0x200 + 0xD000
    ADC #$D000          ; VRAM destination address
    STA $02             ;

    LDA #$0010          ; the size of the file decompressed >> 6 (in this case, 0x400 >> 6 = 0x10)
    STA $3006           ;

    LDX $00             ;
    LDA $06FC79,x       ; get the address of the file to decompress
    STA $3002           ; from the pointer table
    LDA $06FC7B,x       ;
    AND #$00FF          ;
    STA $3000           ;

    SEP #$10
    LDX #$0A            ; call GSU LC_LZ16 decompression routine ($0A8000)
    LDA #$8000          ; it'll decompress to $705800 (and man is it fast)
    PEI ($02)           ;
    JSL $7EDE44         ;
    REP #$10            ;
    LDA #$7058          ; source address bank and high byte
    STA $00             ;
    LDX #$5800          ; source address low byte
    PLY                 ; VRAM destination + $8000
    LDA #$0400          ; data size
    JSL $00BEA6         ; set up the info for the VRAM upload that will be done in the next blank
    PLP
    RTS

;how to use:  in init, do the following:
;store the sprite number to !srID
;store the interval (in frames) to !srint
;store the limit of how many of your sprite can exist at once to !srlimit
;store the length of your range table to !srlen
;upload your table to !srranges
;--
;then JSL SpriteRain every frame in main
SpriteRain:
;-----------
;dont touch these, used in the other level as well:

!srframe = $0282
;(active) frame counter

!srcounter = $0284
;counts how many shyguys are on right now

!srID = $0286
;sprite number to spawn

!srint = $0288
;how often to summon a sprite

!srlimit = $028A
;how many sprites can coexist

!srlen = $028C
;length of range table -1

!srranges = $028E
;where the table gets uploaded to

;------------

    LDA $61B0
    ORA $0B55
    ORA $0398
    ORA $0B0F
    BEQ .execute    ;check for pause flags

.noexecute
    RTL

.execute
    INC !srframe

    LDA !srframe
    AND !srint
    BNE .noexecute

    LDA !srranges

    ;-----  check for shyguy amount
    LDA #$0000
    STA !srcounter

    LDX #$17      ;init sprite loop

.ShyLoop
    PHX

    TXA
    CMP #$0006    ;dont loop through reserved sprites
    BCC .Shynext
    ASL
    ASL
    TAX           ;index *4 for all the weird-ass tables

    LDA $6F00,x   ;check sprite state
    BEQ .Shynext  ;if dead, skip

    LDA $7360,x   ;sprite ID
    CMP !srID     ;shyguy
    BNE .Shynext  ;if not a shyguy, don't increase shyguy counter

    INC !srcounter

.Shynext
    PLX
    DEX           ;keep running
    BPL .ShyLoop

    LDA !srcounter
    CMP !srlimit      ;check if we had more shyguys than allowed
    BCC .ShyXCheck
    RTL

    ;-----  check if cam is in range

.ShyXCheck
    LDX #$00

.XCheckloop

    LDA $6094
    CLC
    ADC #$0100        ;right edge of screen
    CMP !srranges,x     ;compare to current left edge of range
    BCC .endXloop     ;if it's less, stop the loop, we aren't at this range yet and aren't gonna be at any following ranges

    SEC
    SBC #$0100        ;back to left edge (ugly but for good cause)
    CMP !srranges+$2,x  ;compare to current right edge of range
    BCC .Shyspawn     ;if we are above the left edge and below the right edge, ayyyy
    ;if we are to the right of this range in total, go on to the next range


    INX : INX : INX : INX       ;check next range
    TXA
    AND #$00FF
    CMP !srlen                  ;if that wasn't the last one
    BCC .XCheckloop
    RTL                         ;if not inside of any of the ranges, return

.endXloop
    RTL


;-----  spawn the shyguy
.Shyspawn
    LDA !srID    ;shyguy
    JSL $03A34C   ;spawn a sprite (with init) (and get its index into y)

    LDA $609C
    SEC
    SBC #$0018
    STA $7182,y   ;store to sprite y

    LDA $7970     ;load what appears to be rng
    AND #$000F
    CMP #$000D
    BCS .noadd2
    CLC           ;set range
    ADC #$0002

.noadd2
    ASL
    ASL
    ASL           ;turn 000x into 00x0
    ASL
    CLC
    ADC $6094     ;add x camera

    CMP !srranges+$2,x    ;compare to end range
    BCC .inrange        ;if the spawn coord is within range, sure, go ahead and spawn

    SEC           ;if not in range, remove screen x again
    SBC $6094
    LSR           ;halve it
    EOR #$FFFF    ;invert and add the range end, to make it be in range with a slight offset
    CLC
    ADC !srranges+$2,x
    BRA .storex

.inrange
    CMP !srranges,x       ;compare to start range
    BCC .notinrange
    BRA .storex

.notinrange
    SEC           ;if not in range, remove screen x again
    SBC $6094
    LSR           ;halve it
    EOR #$FFFF    ;invert and add the range end, to make it be in range with a slight offset
    SEC
    SBC !srranges+$2,x

.storex
    STA $70E2,y   ;store to sprite x
    RTL

;-------------------------------

HOT_LIPS_HIDEOUT:
  LDA $7E2A
  ORA $0B10
  BNE FUCKLUI

  REP #$20
 !translength = $0400      ;how long transformations last
  LDA $61F4
  CMP #!translength
  BCC .kcool
  LDA #!translength-1
  STA $61F4

.kcool

!framecounter = $026A
!soundflag = $026C      ;can overlap with other levelasm, not with any global asm you might add though

;alternates ! blocks every x frames
  INC !framecounter
  LDA !framecounter

!delayframes = $0080    ;this gets ANDed from the frame counter

  AND #!delayframes
  BNE .noblocks

  LDA #$0008
  STA $7E08

  LDA !soundflag      ;if the soundflag isnt on, play a sound
  BNE .nosoundon

  LDA #$0032
  JSL $0085D2         ;sound 32 into sound buffer
  LDA #$0001          ;turn on flag
  STA !soundflag

.nosoundon
  RTS

.noblocks
  LDA #$0000
  STA $7E08

  LDA !soundflag      ;if the soundflag isnt off, play a sound
  BEQ .nosoundoff

  LDA #$0032
  JSL $0085D2         ;sound 32 into sound buffer
  LDA #$0000          ;turn off flag
  STA !soundflag

.nosoundoff
FUCKLUI:
  RTS

;----- spear guy generator for burt the bashful

!burtflippybit = $026A
!burtimer = $026C
!burtcountdown = $026E
!burtcounter = $0270
!burtgate = $0272

;-----

BurtBoss:
    LDA $61B0
    ORA $0B55
    ORA $0398
    ORA $0B0F
    BEQ .execute    ;check for pause flags
.noexecute
    RTS
.execute

    LDA !burtcountdown
    BEQ .nocount
    DEC             ;dont do anything during the kamek cutscene
    STA !burtcountdown

    RTS
.nocount
    INC !burtimer
    LDA !burtimer
    AND #$00FF      ;only spawn every x something
    BNE .noexecute

    LDA $6094
    CMP #$0058      ;only spawn if you can see the entrance
    BCC .noexecute

    ;-----  check for shyguy amount
    LDA #$0000
    STA !burtcounter

    LDX #$17      ;init sprite loop

.spearLoop
    PHX

    TXA
    CMP #$0006    ;dont loop through reserved sprites
    BCC .spearnext
    ASL
    ASL
    TAX           ;index *4 for all the weird-ass tables

    LDA $6F00,x     ;check sprite state
    BEQ .spearnext  ;if dead, skip

    LDA $7360,x    ;sprite ID
    CMP #$00FB     ;shyguy
    BEQ .spearinc  ;if a shyguy, increase shyguy counter

    CMP #$00FC     ;shyguy
    BNE .spearnext ;if not a shyguy, don't increase shyguy counter

.spearinc
    INC !burtcounter

.spearnext
    PLX
    DEX           ;keep running
    BPL .spearLoop

    LDA !burtcounter
    CMP #$0002      ;check if we had more shyguys than allowed
    BCC .spawnspears
    RTS

.spawnspears
    LDA !burtflippybit
    EOR #$0001      ;switch around and load the flippy bit for the guy picker
    STA !burtflippybit
    ASL
    TAX

    LDA .Guys,x
    JSL $03A34C

    LDA #$0180
    STA $70E2,y   ;store to sprite x

    LDA #$07A0
    STA $7182,y   ;store to sprite y
    RTS

.Guys
    dw $00FB,$00FC


;---------------------------------------
;coliseum mechanics - leod - for level6E
!arenastage = $0278    ;determines which stage of the arena we're at
                    ;format: xxyy    where xx = which arena location and yy = which stage
!arenahistage = $0279  ;to grab only the high byte
!arenastate = $027C    ;state the arena mechanic is in
                    ;0000;  arena idles, hasnt started/is over
                    ;0001;  arena in progress, keep checking if enemies are dead
                    ;0002;  arena wave over, timer till next one
                    ;0003;  arena cooldown over, reset timer and spawn sprites (lasts 1 frame)

!arenaframes = $026A    ;a framecounter
!arenalockx = $026C    ;while arena is on, keep camera locked  (no need to reset)
!arenatimer = $026E    ;the timer used between waves
!arenasindex = $0270    ;which sprite are we even at to spawn??
!arenascount = $0272    ;countdown for how many more sprites to spawn during this wave
!arenaprevminimum = $0274  ; stored minimum value for camera X lower boundary
!arenaprevmaximum = $0276  ; stored maximum value for camera X upper boundary

!specialsprbuffer = $027E

;----------------------------------------------------------------------------------------

Coliseum:
    LDA $61B0
    ORA $0B55
    ORA $0398
    ORA $0B0F
    BEQ .execute    ;check for pause flags

.return2
    RTS

.execute
    INC !arenaframes

    LDA !arenastate    ;take state
    BEQ .NoCamLock

    LDA !arenalockx    ;lock cam if state isn't 0
    STA $7E18
    STA $7E1A

    LDA !arenastate    ;take state again

.NoCamLock
    ASL           ;*2
    TAX           ;index jump by state*2
    JMP (.ArenaStates,x)

.ArenaStates
    dw .Idle,.CheckEnemies,.Clock,.Spawn

.ArenaX           ;arena positions
    dw $0400,$0B00,$0E00,$0F00
    ;first should be 0400
    ;second should be 0B00
    ;third should be 0E00

.Prize
    dw $00A0,$00FA,$00BE
    ;tulip, flower, 1-up cloud

.PrizeX
    dw $0070,$0020,$00B0

.PrizeY
    dw $0260,$02C0,$0240

.SpritesInWave    ;how many sprites per wave minus 1, FFFF ends the current arena and allows progress
    dw $0000,$0001,$0003,$0001,$0002,$FFFF
    dw $0000,$0001,$0003,$0002,$0002,$0004,$FFFF
    dw $0001,$0002,$0001,$0004,$0001,$0001,$FFFF

.XPos             ;x position of the sprite, in the current arena screen
    dw $0040,$0010 : dw $00E0,$0040,$00B0 : dw $0040,$00E0 : dw $00A0,$0010 : dw $0070,$00D0,$00E0
    dw $00C0 : dw $002A,$0034 : dw $00A8,$00B0,$00B8 : dw $00C0,$002A : dw $0032,$00B8 : dw $00BA,$0030 : dw $002E,$00BC,$00C8,$0034,$002A,$0060
    dw $0020,$00B0 : dw $00B5,$0058,$009A : dw $00BF,$0050 : dw $0040,$0080,$0060,$00B0,$00C0 : dw $00B0,$0020 : dw $0030,$00A0

.YPos             ;y position of the sprite, not relative to the arena
    dw $02C0 : dw $0270,$0260 : dw $02C0,$02B0,$02C0,$02B0 : dw $02C0,$0270 : dw $0240,$0220,$0260
    dw $0280 : dw $0280,$0280 : dw $0280,$0280,$0280 : dw $0280,$0280 : dw $0280,$0210 : dw $0280,$0210 : dw $0280,$0280,$0280,$0280,$0280,$02B0
    dw $02B0,$0220 : dw $02C0,$0250,$0280 : dw $0250,$0280 : dw $0220,$0250,$02A0,$02C0,$0250 : dw $0220,$0230 : dw $0280,$0220

.ArrowType        ;how the arrows are spawned
    dw $0000 : dw $0000,$0000 : dw $0000,$0000,$0000,$0000 : dw $0004,$0000 : dw $0000,$0002,$0000
    dw $0000 : dw $0000,$0000 : dw $0000,$0000,$0000 : dw $0000,$0000 : dw $0000,$0002 : dw $0000,$0002 : dw $0000,$0000,$0000,$0000,$0000,$0000
    dw $0000,$0002 : dw $0000,$0000,$0000 : dw $0000,$0000 : dw $0002,$0000,$0000,$0000,$0000 : dw $0002,$0002 : dw $0000,$0002


	;0000 = downwards
	;0002 = upwards
	;0004 = two arrows (for twin burt)

.Numbers          ;sprite ID of the sprite, some sprites listed below, more in Golden Egg
    dw $001E : dw $0159,$0159 : dw $0066,$009E,$0115,$0113 : dw $00E7,$0113 : dw $015E,$00FA,$009B
    ;lone shyguy, double grunt, ptooie + chomp rock + red coin + snifit, twin burt + snifit, shyguy wheel + flower + mace guy
    dw $00FB : dw $00FC,$00FC : dw $00FC,$00FB,$00FC : dw $00FB,$00FC : dw $00FC,$00E7 : dw $0113,$00E7 : dw $0159,$00FC,$00FB,$00FC,$00FB,$015B
    ;spearguy * 8, spearguy * 2 + burt, 1 burt + snifit + grunt, spearguy * 4 + dancing guy * 2
    dw $0113,$0113 : dw $009F,$009E,$010E : dw $00FB,$00FC : dw $010E,$0003,$010E,$0113,$015A : dw $0159,$015A : dw $001E,$0115
    ;snifit * 2, spitty plant + rock + crate (star), spear guy * 2 , crate (star) * 2 + crate (key) + snifit + grunt, grunt * 2, lone shyguy + red coin


    ;001E = shyguy
    ;0159 = grunt (walk)
    ;015A = grunt (run)
    ;00E7 = buRTS LOLLLLLLLLLLLL
    ;0066 = piranha
    ;009F = ptooie piranha
    ;0113 = snifit
    ;009B = mace guy
    ;015E = shyguy wheel
    ;00FB = spear guy (long)
    ;00FC = spear guy (short)
    ;015B = dancing spear guy
    ;01E2 = dancing spear guy trigger

    ;00A0 = tulip
    ;0065 = red coin
    ;00C0 = cloud (3 stars)
    ;00C1 = cloud (5 stars)
    ;009E = chomp rock
    ;00FA = flower
    ;0003 = crate (key)
    ;010E = crate (stars)

.Idle
.NoArena
    LDA !arenahistage
    ASL           ;index by current arena *2
    AND #$00FF
    TAX

    LDY #$5C
.FlowerLoop
	LDA $6F00,y
	CMP #$0010
	BCC .Next
	LDA $7360,y
	CMP #$00FA
	BNE .Next
	LDA $70E2,y
	AND #$FF00
	CMP .ArenaX,x
	BNE .Next
	LDA $74A0,y
	STA !specialsprbuffer
	PHX
	PHY
	TYX
	JSL $03A32E
	PLY
	PLX
.Next
	DEY #4
	BPL .FlowerLoop

    LDA $6094     ;camera x
    INC A
    INC A
    INC A
    INC A
    CMP .ArenaX,x ;check if he's in the arena area
    BCC .return3  ;if not, RTS

    LDA #$0002   ;invoke first wave by setting it to the timer state
    STA !arenastate

    LDA #$0048   ;set the clock
    STA !arenatimer

    LDA .ArenaX,x     ;store current x camera to keep it precisely focused
    STA !arenalockx

    ; save current camera minimum and maximum
    LDA $7E18
    STA !arenaprevminimum
    LDA $7E1A
    STA !arenaprevmaximum

	LDA #$0001
    STA $0B48     ;disable items

	SEP #$10
	PHD
	LDA $0150
	ASL
	TAX
	LDA $03D3C3,x
	PHA
	PLD

	PLD
	REP #$10

.return3
    RTS

.WhiteList    ;which sprites to allow by the end of a round
    dw $0027,$010E,$0003,$013C,$015B,$015E,$0115,$0114,$00A0,$009E,$0065,$00C0,$00C1,$01A2,$00FA,$0023,$0024,$0025
    ;key, crate, crate, down flippers, dancing spear guy, shyguy wheel, coin, snifit bullet, tulip, chomp rock, red coin, cloud (3 stars), cloud (5 stars), star, flower, egg, egg, egg

.ClearList    ;which sprites to clear at the end of a round
    dw $015B,$015E,$0114,$009E
    ;dancing spear guy, shyguy wheel, snifit bullet, chomp rock

.CheckEnemies
    LDA !arenaframes
    AND #$0007        ;only do it every 8th frame to reduce SOME lag (if there is any)
    BNE .return3


    ;-------- CHECK IF ENEMIES ARE ALIVE
    LDX #$17      ;init sprite loop

.Checkloop
    PHX

    TXA
    CMP #$0006    ;dont loop through reserved sprites
    BCC .next
    ASL
    ASL
    TAX           ;index *4 for all the weird-ass tables

    LDA $6F00,x   ;check sprite state
    BEQ .next     ;if dead, skip


    LDA $7360,x   ;sprite ID
    LDY #$22      ;get length of whitelist table

.WhiteLoop
    CMP .WhiteList,y
    BEQ .next

    DEY
    DEY

    BPL .WhiteLoop


    LDA !arenahistage
    ASL           ;index by current arena *2
    TAY           ;into y
    LDA $70E2,x   ;check sprite x
    CLC
    ADC #$0018
    AND #$FF00    ;only check screen
    CMP .ArenaX,y ;check if yoshi's in the current arena area
    BEQ .returnPLX
    LDA $70E2,x   ;check sprite x again
    SEC
    SBC #$0018
    AND #$FF00    ;only check screen
    CMP .ArenaX,y ;check if yoshi's in the current arena area
    BEQ .returnPLX

.next
    PLX
    DEX          ;decrease loop index
    BPL .Checkloop    ;if not done, keep going

    ;if no enemies are found, proceed to the cooldown state
    LDA #$0002
    STA !arenastate   ;clock state

    LDA #$0038   ;set the clock
    STA !arenatimer


    ;------ clears out unwanted sprites
    LDX #$17      ;init sprite loop

.Cleanloop
    PHX

    TXA
    CMP #$0006    ;dont loop through reserved sprites
    BCC .cleannext
    ASL
    ASL
    TAX           ;index *4 for all the weird-ass tables

    LDY #$06

.Deleteloop ;ID checking loop

    LDA .ClearList,y
    CMP $7360,x   ;sprite ID
    BNE .Deletenext


    LDA #$000C     ;explodes the sprite
    STA $6F00,x

    ;PHY
    ;PHX
    ;JSL $03A32E   ;despawn sprite (needs index*4 in x)
    ;PLX
    ;PLY

.Deletenext
    DEY
    DEY
    BPL .Deleteloop

.cleannext
    PLX
    DEX          ;decrease loop index
    BPL .Cleanloop    ;if not done, keep going

.return
    RTS          ;return

.returnPLX
    PLX
    RTS

.Spawn
    LDA !arenastage          ;get stage #
    ASL
    AND #$00FF          ;rid of B
    TAX                 ;into x


    LDA .SpritesInWave,x
    BPL .startarena         ;if entry is FFFF, end arena
    JMP .endarena

.startarena
    STA !arenascount      ;how many sprites to summon this time around
    CLC
    ADC !arenasindex

    ASL
    TAX

    LDA #$0004          ;load spit sound
    JSL $0085D2         ;sound into sound buffer

.Spawnloop
    LDA .Numbers,x
    JSL $03A34C   ;spawn a sprite (with init) (and get its index into y)

    PHX
    LDA !arenahistage
    ASL           ;index by current arena *2
    AND #$00FF
    TAX
    LDA .ArenaX,x ;load arena position high byte
    PLX
    ORA .XPos,x   ;add in sprite x offset
    STA $70E2,y   ;store to sprite x
	STA $00

    LDA .YPos,x
    STA $7182,y   ;store to sprite y
	STA $02

	LDA $7360,y   ; If a flower: Put level ID back.
	CMP #$00FA
	BNE .NotFlower
	LDA !specialsprbuffer
	STA $74A0,y
.NotFlower

	LDA $7360,y   ; If a moving coin: Make it red
	CMP #$0115
	BNE .NotCoin
	LDA $7042,y
	AND #$FFF1
	ORA #$0002
	STA $7042,y
.NotCoin

	LDA #$01D4
    JSL $008B21   ;spawn an ambient sprite (with init) (and get its index into y)
	LDA $00
	STA $70A2,y
	LDA $02
	STA $7142,y
	LDA #$0006
	STA $7782,y
	LDA #$000B
	STA $7E4C,y

    DEX
    DEX           ;decrease index by 2 (tables = words)

    INC !arenasindex
    DEC !arenascount
    BPL .Spawnloop  ;if negative, stop spawning


    LDA #$0001      ;if spawning over, go into checking state
    STA !arenastate

    INC !arenastage

    RTS

.endarena
    LDA #$008F          ;load correct sound
    JSL $0085D2         ;sound into sound buffer

    ;---- spawn prize
    LDA !arenahistage
    ASL           ;index by current arena *2
    AND #$00FF
    TAX

    LDA .Prize,x  ;load prize sprite
    PHX
    JSL $03A34C   ;spawn a sprite (with init) (and get its index into y)
    PLX

    LDA .ArenaX,x ;load arena screen
    ORA .PrizeX,x ;add prize offset
    STA $70E2,y   ;store to sprite x
	STA $00       ;also preserve it

    LDA .PrizeY,x ;load prize sprite's y pos
    STA $7182,y   ;store to sprite y
	STA $02       ;also preserve it

	LDA $7360,y   ; If a flower: Put level ID back.
	CMP #$00FA
	BNE .NotFlowerPrize
	LDA !specialsprbuffer
	STA $74A0,y
.NotFlowerPrize

	LDA #$01D4
    JSL $008B21   ;spawn an ambient sprite (with init) (and get its index into y)
	LDA $00
	STA $70A2,y
	LDA $02
	STA $7142,y
	LDA #$0006
	STA $7782,y
	LDA #$000B
	STA $7E4C,y

    STZ $0B48     ;reenable items

    ;---- delete all loaded flippers on the next and previous screen
    ;LDX #$17      ;init sprite loop
    ;  .Flipperloop
    ;PHX

    ;TXA
    ;CMP #$0006    ;dont loop through reserved sprites
    ;BCC .flippernext
    ;ASL
    ;ASL
    ;TAX           ;index *4 for all the weird-ass tables

    ;LDA $7360,x
    ;CMP #$0144          ;check if it's a flipper
    ;BNE .flippernext

    ;LDA $70E2,x         ;check sprite x
    ;AND #$FF00          ;only check screen
    ;STA !tempx          ;store temporarily

    ;LDA !arenahistage
    ;ASL           ;index by current arena *2
    ;AND #$00FF
    ;TAX
    ;LDA .ArenaX,x ;load current arena x
    ;CLC
    ;ADC #$0100          ;add 0100 for next screen
    ;CMP !tempx          ;compare to flipper screen
    ;BEQ .killflipper    ;if the same, kill the flipper
    ;SEC
    ;SBC #$0200          ;substract 0200 for previous screen
    ;CMP !tempx          ;compare to flipper screen
    ;BNE .flippernext    ;if not the same, next sprite


    ;.killflipper
    ;PLX                 ;get back sprite index
    ;PHX
    ;TXA
    ;ASL
    ;ASL                 ;*4
    ;TAX
    ;JSL $03A2DE         ;kill sprite (needs index*4 in x)
    ;LDA #$0012          ;explode flippers
    ;STA $6F00,x

    ;.flippernext
    ;PLX
    ;DEX          ;decrease loop index
    ;BPL .Flipperloop    ;if not done, keep going



    ;----- prep next arena
    LDA #$0000
    STA !arenastate

    LDA !arenastage
    CLC
    ADC #$0101          ;add 1 to arena index
    STA !arenastage

    LDA #$0000
    STA !arenalockx

    ; end camera lock
    LDA !arenaprevminimum
    STA $7E18
    LDA !arenaprevmaximum
    STA $7E1A
    RTS

.Clock
; Display arrows
    LDA !arenatimer
    AND #$0008      ;every 8 frames
    BNE .noarrow

    LDA !arenastage          ;get stage #
    ASL
    AND #$00FF          ;rid of B
    TAX                 ;into x


    LDA .SpritesInWave,x
    BMI .noarrow          ;if entry is FFFF, no arrow
    STA !arenascount      ;how many arrows to summon this time around
    CLC
    ADC !arenasindex

    ASL
    TAX

..loop
	LDA #$0224
	JSL $008B21

    PHX
    LDA !arenahistage
    ASL           ;index by current arena *2
    AND #$00FF
    TAX
    LDA .ArenaX,x ;load arena position high byte
    PLX
    ORA .XPos,x   ;add in sprite x offset
	STA $00

    LDA .YPos,x
	STA $02

	PHX
	LDA .ArrowType,x
	TAX
	JSR.w (.ArrowSpawning,x)
	PLX

	LDA #$0001
	STA $7782,y

	DEX : DEX
    DEC !arenascount
	BPL ..loop

; Handle timer
.noarrow
    DEC !arenatimer
    BNE .tick     ;if timer is over,

    LDA #$0003
    STA !arenastate
    RTS

.tick
    LDA !arenatimer
    AND #$000F      ;every 10 frames
    BNE .notick

    LDA #$001B          ;load tick sound
    JSL $0085D2         ;sound into sound buffer

.notick
    RTS

.ArrowSpawning
dw ..DownArrow
dw ..UpArrow
dw ..TwoArrows

..DownArrow
	LDA $00
    STA $70A2,y   ;store to sprite x
	LDA $02
	CLC : ADC #$0008
    STA $7142,y   ;store to sprite y

	LDA #$0002    ;arrow direction
	STA $73C2,y
RTS

..UpArrow
	LDA $00
    STA $70A2,y   ;store to sprite x
	LDA $02
	SEC : SBC #$0008
    STA $7142,y   ;store to sprite y

	LDA #$0003    ;arrow direction
	STA $73C2,y
RTS

..TwoArrows
	LDA $00
    STA $70A2,y   ;store to sprite x
	LDA $02
	CLC : ADC #$0008
    STA $7142,y   ;store to sprite y

	LDA #$0002    ;arrow direction
	STA $73C2,y

	LDA #$0001
	STA $7782,y

	LDA #$0224    ;spawn a second arrow
	JSL $008B21

	LDA $00
	CLC : ADC #$0030
    STA $70A2,y   ;store to sprite x
	LDA $02
	CLC : ADC #$0008
    STA $7142,y   ;store to sprite y

	LDA #$0002    ;arrow direction
	STA $73C2,y
RTS


;----------------------------------------------
!gravity_frame = $026A
!scratchspeed = $026C     ;temp stores halved speeds to do math
;leod's level - gravity shenignogans

GRAVITY_NONSENSE:
  LDA $0B0F
  BEQ .docode1
  RTS           ;only do any code if the game is NOT paused
.docode1

  LDA $61B0
  ORA $0B55
  ORA $0398
  BEQ .docode2     ;check for pause flag
  RTS
.docode2
         ;TODO: FIND FLAG FOR "MARIO IS GETTING BACK ON YOSHI, GAME IS FROZEN"

  INC !gravity_frame

  LDX #$17      ;init loop
.loop
  PHX

  TXA
  CMP #$0006    ;dont loop through reserved sprites
  BCS .go
  JMP .next
.go
  ASL
  ASL
  TAX           ;index *4 for all the weird-ass tables

  LDA $7E08     ;check !-timer
  BEQ .yesphysics

  LDA #$0400    ;if on, switch to normal gravity
  STA $75E2,x
  JMP .next

.nogravtable
dw $0094,$010B,$00E5,$009E,$0158,$0022,$0023,$0024,$0025,$01A2,$019A,$00F3,$00F4
;branch to .nograv
;hopping taptap, green needlenose, chomp rock, goonie, egg, egg, egg, egg, star, ghosts, woozy, eggplant

.halvetable
dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$010A,$0109,$013D,$013E
;branch to .halve
;ledge taptap, normal taptap, bat, bat

.floattable
dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$01A3,$0146,$0145,$0133,$0030,$0163
;branch to .floaty
;sluggy, sluggy, lantern ghost, mouser, green needlenose

.yesphysics
  LDA $6F00,x       ;check sprite state
  CMP #$000E        ;if 0E (jumped on)
  BEQ .nofloaties   ;run upward floating code


  LDA $7F1337

  LDY #$16        ;loop init
  LDA $7360,x     ;sprite #
.spriteloop

  CMP .nogravtable,y    ;check if sprite has no gravity
  BEQ .nograv

  CMP .floattable,y     ;check if sprite should float
  BEQ .floaty

  CMP .halvetable,y     ;check if sprite's speed should be halved
  BEQ .halvey

  DEY
  DEY
  BPL .spriteloop

  JMP .next              ;if none of these, go next

.floaty
  LDA $7D38,x
  BEQ .notspat  ;check if sprite was spat out by yoshi

  JMP .dogfloaties ;if so, dogfloat

.notspat
  LDA $7222,x     ;only halve y if speed is positive
  BEQ .nextJMP
  SEC
  SBC #$0020
  STA $7222,x
  BPL .dofloat
  JMP .next
  LDA $7222,x     ;only halve y if speed is positive
  BEQ .nextJMP
  BPL .dofloat
.nextJMP
  JMP .next

.dofloat
  JSR .halveystuff
  JMP .next


.nograv
  JMP .dogfloaties  ;test for jumped on was earlier already

.nofloaties
  LDA #$FF00    ;if it is 0E (jumped on by yoshster)
  STA $75E2,x   ;store a specific value to the sprite speed
  BRA .next


.halve
        LDY #$00
        LDA $7220,x
        BEQ .halvey
        BPL .isposx
        EOR #$FFFF
        LSR
        LDY #$01
        BRA .donehalvex

.isposx
        LSR
        EOR #$FFFF

.donehalvex
        CLC
        ADC $70E1,x
        STA $70E1,x

        SEP #$20
        LDA $70E3,x
        ADC .yFixes,y
        STA $70E3,x
        REP #$20


.halvey
  JSR .halveystuff

  BRA .next

.halveyprep
  LDA $7D38,x
  BNE .nohalvey  ;check if sprite was spat out by yoshi
  JMP .halvey

.nohalvey
  JMP .dogfloaties ;if so, dogfloat

.xFixes
db $00,$FF

.yFixes
db $FF,$00

.halveystuff
        LDY #$00
        LDA $7222,x
        BEQ .exithalve
        BPL .isposy
        EOR #$FFFF
        LSR
        LDY #$01
        BRA .donehalvey

.isposy
        LSR
        EOR #$FFFF

.donehalvey
        CLC
        ADC $7181,x
        STA $7181,x

        SEP #$20
        LDA $7183,x
        ADC .yFixes,y
        STA $7183,x
        REP #$20
.exithalve
        RTS


.dogfloaties
  PHX
  LDA $026A
  LSR
  LSR
  LSR
  AND #$0007
  ASL
  TAX

  LDA GravTable,x
  PLX
  STA $75E2,x

.next
  PLX
  DEX
  BMI .break
  JMP .loop

.break

;yoshi code
  LDA $7E08       ;if ! switch is on, dont float
  BNE .noyosh


  LDA $60AA
  BEQ .noyosh     ;dont do anything if on floor
  BMI .once       ;if rising, only do once

  SEC
  SBC #$0008
  STA $60AA

  LDA $6070
  AND #$8000    ;check if B is pressed
  BNE .once     ;if yes, dont go there

  LDA $60AA
  SEC
  SBC #$0048
  STA $60AA

.once
  LDA $60AA
  SEC
  SBC #$000F
  STA $60AA

.noyosh
    RTS

GravTable:
dw $0000,$0001,$0001,$0000,$FFFF,$FFFE,$FFFE,$FFFF

!sewage_animate = $00CC
!sewage_timer = $00CE
sewage_colors:
dw $0020, $10E4, $124F, $43C2

sewage_inc_mod:
    TXA
    INC A
    INC A
    AND #$0007
    TAX
    RTS

animate_sewage:
    ; animate sewage palette
    INC !sewage_timer
    LDA !sewage_timer
    CMP #$0004
    BCC .ret

    STZ !sewage_timer

    LDX !sewage_animate
    LDA sewage_colors,x
    STA $7020A6
    JSR sewage_inc_mod

    LDA sewage_colors,x
    STA $7020A8
    JSR sewage_inc_mod

    LDA sewage_colors,x
    STA $7020AA
    JSR sewage_inc_mod

    LDA sewage_colors,x
    STA $7020AC

    LDA !sewage_animate
    DEC A
    DEC A
    AND #$0007
    STA !sewage_animate

.ret
    RTS

init_sewer:
    ; sewer water color
    LDA #$00E0
    STA $7020A2

    ; sewer platforms
    LDA #$25D4
    STA $7020B2

    ; sewer shading
    LDA #$192A
    STA $702098
    LDA #$1509
    STA $70209A
    LDA #$10C9
    STA $70209C
    LDA #$0CA5
    STA $70209E
    RTS

; removes all but keys from inventory
remove_egg_inventory:
    ; if size is 0 just get out
    LDA $7DF6
    BEQ .ret

    ; begin at first slot
    LDY #$00

.loop
    ; load sprite slot of current item
    LDX $7DF8,y

    ; if key, move onto next
    LDA $7360,x
    CMP #$0027
    BEQ .next

    ; if not key, despawn sprite
    LDA #$0000
    STA $6F00,x
    ; make OAM "invisible"
    LDA #$00F0
    STA $7682,x

    ; shuffle all further items up to this slot
    TYX
..shuffle_loop
    ; shuffle next one in here
    INX
    INX
    CPX $7DF6
    BEQ .dec_inv
    LDA $7DF8,x
    STA $7DF6,x
    BRA ..shuffle_loop

.dec_inv
    ; decrement inventory count
    DEC $7DF6
    DEC $7DF6

    ; did we catch up with count?
    CPY $7DF6
    BEQ .ret
    BRA .loop

.next
    ; go until reached count
    INY
    INY
    CPY $7DF6
    BNE .loop

.ret
    RTS

!koopa_ID = #$016C
!beach_ID = #$016A
!shell_ID = #$0168
!koopa_num = #$03

hookbill_count_koopas:
    ; start out count at 0
    PHX
    PHY
    LDX #$00

    ; loop through sprite tables
    LDY #$5C

.loop_sprite
    ; make sure this slot is spawned in
    LDA $6F00,y
    BEQ .next_sprite

    ; is this sprite not a koopa or shell? don't count
    LDA $7360,y
    CMP !koopa_ID
    BEQ .increase_koopa_count
    CMP !beach_ID
    BEQ .increase_koopa_count
    CMP !shell_ID
    BEQ .increase_koopa_count
    BRA .next_sprite

.increase_koopa_count
    ; koopa? count
    INX

.next_sprite
    DEY
    DEY
    DEY
    DEY
    BNE .loop_sprite

    PLY

    ; limit koopas to a number
    CPX !koopa_num
    BCS .spawn_ambient

    ; spawn koopa
    PLX
    JML $019077

.spawn_ambient
    ; jump to spawning ambient sprite instead of koopa
    PLX
    JML $019050
