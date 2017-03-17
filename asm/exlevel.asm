org $3ED800

Coliseum:
PHB                     ; \
PHK                     ;  | The same old
PLB                     ; /
JSR RunColiseum
PLB                     ; Yep
RTL

;coliseum mechanics - leod - for level6E
!arenastage = $710000    ;determines which stage of the arena we're at
                    ;format: xxyy    where xx = which arena location and yy = which stage
!arenahistage = $710001  ;to grab only the high byte

!arenastate = $710005    ;state the arena mechanic is in
                    ;0000;  arena idles, hasnt started/is over
                    ;0001;  arena in progress, keep checking if enemies are dead
                    ;0002;  arena wave over, timer till next one
                    ;0003;  arena cooldown over, reset timer and spawn sprites (lasts 1 frame)

!arenaframes = $7FD005    ;a framecounter

!arenalockx = $7FD007    ;while arena is on, keep camera locked  (no need to reset)

!arenatimer = $7FD009    ;the timer used between waves

!arenasindex = $710003    ;which sprite are we even at to spawn??

!arenascount = $7FD00A    ;countdown for how many more sprites to spawn during this wave

;----------------------------------------------------------------------------------------

  RunColiseum:
LDA $61B0
ORA $0B55
ORA $0398
ORA $0B0F
BEQ .execute    ;check for pause flags
.return2
RTS
.execute

LDA !arenaframes
INC           ;inc frames
STA !arenaframes

LDA !arenastate    ;take state
BEQ .NoCamLock

LDA !arenalockx    ;lock cam if state isn't 0
STA $6094

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
dw $0040,$0010,$00E0,$0040,$00B0,$0040,$00E0,$00A0,$0010,$0070,$00D0,$00E0
dw $00C0,$002A,$0034,$00A8,$00B0,$00B8,$00C0,$002A,$0032,$00B8,$00BA,$0030,$002E,$00BC,$00C8,$0034,$002A,$0060
dw $0020,$00B0 : dw $00B5,$0058,$009A : dw $00BF,$0050 : dw $0040,$0080,$0060,$00B0,$00C0 : dw $00B0,$0020 : dw $0030,$00B0

.YPos             ;y position of the sprite, not relative to the arena
dw $02C0,$0270,$0260,$02C0,$02B0,$02C0,$02B0,$02C0,$0270,$0240,$0220,$0260
dw $0280,$0280,$0280,$0280,$0280,$0280,$0280,$0280,$0280,$0210,$0280,$0210,$0280,$0280,$0280,$0280,$0280,$02B0
dw $02B0,$0220 : dw $02C0,$0250,$0280 : dw $0250,$0280 : dw $0220,$0250,$02A0,$02C0,$0250 : dw $0220,$0230 : dw $0280,$0220

.Numbers          ;sprite ID of the sprite, some sprites listed below, more in Golden Egg
dw $001E,$0159,$0159,$0066,$009E,$0065,$0113,$00E7,$0113,$015E,$00FA,$009B
;lone shyguy, double grunt, ptooie + chomp rock + red coin + snifit, twin burt + snifit, shyguy wheel + flower + mace guy
dw $00FB,$00FC,$00FC,$00FC,$00FB,$00FC,$00FB,$00FC,$00FC,$00E7,$0113,$00E7,$0159,$00FC,$00FB,$00FC,$00FB,$015B
;spearguy * 8, spearguy * 2 + burt, 1 burt + snifit + grunt, spearguy * 4 + dancing guy * 2
dw $0113,$0113 : dw $009F,$009E,$010E : dw $00FB,$00FC : dw $010E,$0003,$010E,$0113,$015A : dw $0159,$015A : dw $001E,$0065
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
;------------ wait and see if yoshi enters arenas
LDA !arenahistage
ASL           ;index by current arena *2
AND #$00FF
TAX

LDA $6094     ;camera x
CMP .ArenaX,x ;check if he's in the arena area
BCC .return3  ;if not, RTS

LDA #$0002   ;invoke first wave by setting it to the timer state
STA !arenastate

LDA #$0048   ;set the clock
STA !arenatimer

LDA .ArenaX,x     ;store current x camera to keep it precisely focused
STA !arenalockx

  .return3
RTS





.WhiteList    ;which sprites to allow by the end of a round
dw $0027,$010E,$0003,$013C,$015B,$015E,$0115,$0114,$00A0,$009E,$0065,$00C0,$00C1,$01A2,$0023,$0024,$0025
;key, crate, crate, down flippers, dancing spear guy, shyguy wheel, coin, snifit bullet, tulip, chomp rock, red coin, cloud (3 stars), cloud (5 stars), star, egg, egg, egg

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
LDY #$20      ;get length of whitelist table
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
BMI .endarena         ;if entry is FFFF, end arena
STA !arenascount      ;how many sprites to summon this time around
CLC
ADC !arenasindex

ASL
TAX

LDA #$003A          ;load stompy sound
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

LDA .YPos,x
STA $7182,y   ;store to sprite y


DEX
DEX           ;decrease index by 2 (tables = words)

LDA !arenasindex
INC             ;increase total amount
STA !arenasindex

LDA !arenascount
DEC             ;decrease spritecount
STA !arenascount
BPL .Spawnloop  ;if negative, stop spawning


LDA #$0001      ;if spawning over, go into checking state
STA !arenastate

LDA !arenastage
INC             ;and increase the stage
STA !arenastage

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

LDA .PrizeY,x ;load prize sprite's y pos
STA $7182,y   ;store to sprite y


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
;TODO BUG LEXIE ABOUT HSCROLL LOCK
RTS




  .Clock
LDA !arenatimer
DEC           ;decrease timer
STA !arenatimer

BNE .tick     ;if timer is over,

LDA #$0003
STA !arenastate
RTS

  .tick
LDA !arenatimer
AND #$000F      ;every 10 frames
BNE .notick

LDA #$001B	        ;load tick sound
JSL $0085D2         ;sound into sound buffer

  .notick
RTS


BurtBoss:
PHB                     ; \
PHK                     ;  | The same old
PLB                     ; /
JSR RunBurt
PLB                     ; Yep
RTL


;----- spear guy generator for burt the bashful

!burtflippybit = $7FD000

!burtimer = $7FD002

!burtcountdown = $7FD004

!burtcounter = $7FD006

!burtgate = $7FD008

;-----

RunBurt:

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
LDA !burtimer
INC
STA !burtimer

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
LDA !burtcounter
INC
STA !burtcounter

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

!srframe = $7FD000
;(active) frame counter

!srcounter = $711000
;counts how many shyguys are on right now

!srID = $711002
;sprite number to spawn

!srint = $711004
;how often to summon a sprite

!srlimit = $711006
;how many sprites can coexist

!srlen = $711008
;length of range table -1

!srranges = $711020
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

LDA !srframe
INC           ;framecounter
STA !srframe

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

LDA !srcounter
INC
STA !srcounter

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
LDA #$001E    ;shyguy
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



;=====================================================================================================================




GRAVITY_NONSENSE:
!scratchspeed = $026C     ;temp stores halved speeds to do math
;leod's level - gravity shenignogans

PHB                     ; \
PHK                     ;  | The same old
PLB                     ; /
JSR .gravstuff
PLB                     ; Yep
RTL
;above stuff to fix bank



.gravstuff
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

  LDA $7FA000
  INC           ;frame counter
  STA $7FA000

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
  LDA $7FA000
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


;=====================================================================================================================



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


!framecounter = $7FA000
!soundflag = $7FF002      ;can overlap with other levelasm, not with any global asm you might add though


;alternates ! blocks every x frames
  LDA !framecounter
  INC           ;frame counter
  STA !framecounter

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

;======================================================================================================================

;leod - alternating ! block code
!framecounter = $7FA000
!soundflag = $7FA002      ;can overlap with other levelasm, not with any global asm you might add though


;alternates ! blocks every x frames
  LDA !framecounter
  INC           ;frame counter
  STA !framecounter

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
RTS


ALTERNATING_BLOCK_SHIT:
;transformation code
; DONT FORGET THE INIT CODE
  LDA $7E08     ;check the ! switch state
  BEQ .noswitch ;if there's no ! switch running, dont inc the freeram

  LDA #$0000
  STA $7E08     ;turn off switch
  LDA #$0001    ;2 empty rams
  STA $7FA000   ;store

.noswitch

  LDA $7FA000
  BEQ .notransform  ;check if yoshi has one stored up and if not, dont transform

  JSR .renderheli

  LDA $6070
  AND #$0040        ;check if X is pressed
  BEQ .notransform

  LDA $60AE
  CMP #$0006
  BEQ .notransform  ;dont spawn one while in heli form (specifically, in case someone wants to use this while a car or smth)

  LDA #$0000    ;reset ram
  STA $7FA000

  LDA #$00A0
  JSL $0085D2         ;sound A0 into sound buffer (ice sound)

  LDA #$00B1
  ;JSL $03A364   ;spawn a sprite routine
  JSL $03A34C   ;spawn a sprite (with init)

  LDA $7F1337

  LDA $608C     ;load yoshi x
  ORA #$0010
  STA $70E2,y   ;store to sprite x
  LDA $6090     ;load yoshi y
  AND #$0010^$FFFF
  STA $7182,y   ;store to sprite y

.notransform      ;this caps the transformation length

  LDX #$17      ;init loop
.loop
  PHX

  TXA
  CMP #$0006    ;dont loop through reserved sprites
  BCC .next
  ASL
  ASL
  TAX           ;index *4 for all the weird-ass tables

  LDA $7360,x   ;load sprite number
  CMP #$00B1    ;compare to heli bubble
  BNE .next     ;if not, skip


  LDA #$0000      ;doing SOMETHING that makes  the sprite not show some garbley graphics for a frame
  STA $7A38,x     ;found entirely by accident


  LDA $61F4
  CMP #$0001        ;check the timer for the transformation, if it's 01 (so shortly before ending a transformation), clear all bubbles that are loaded
  BNE .next

  LDA #$0000
  STA $6F00,x   ;kill if it's bubble

  LDA #$0000
  STA $74A2,x   ;also kill its graphics

.next
  PLX
  DEX
  BPL .loop
	RTS


.renderheli

  PHD       ;backup direct page
  LDA #$6000
  TCD       ;set new direct page

  SEP #$20
  PHB
  LDA #$70  ;set new data bank
  PHA
  PLB
  REP #$20


  LDA $7F1337

  LDA #$0040
  STA ($92)   ;x position on screen
  INC $92
  INC $92

  LDA #$0040
  STA ($92)   ;y position on screen
  INC $92
  INC $92

  LDA #$646A  ;yxppccct tttttttt
  STA ($92)   ;tile and yxppccct
  INC $92
  INC $92

  LDA #$4202  ;-p----sx------sx
  STA ($92)   ;priority and size
  INC $92
  INC $92


  PLB       ;restore bank
  PLD       ;restore direct page

  RTS



