; acceleration (movement forward)
org $02D4A3
  dw $0140, $0000

; delay time of non-motion
org $02D48A
  LDA #$0040

; health
org $02D5B7
  CMP #$0005

; number of hits after which egg plants turn into Needlenose plants
!needlenose_hits = #$0003

; elasticity
org $02D218
  LDA #$FF50

; faked health index for heart animation stuff
org $02D54D
  LDA #$0003

org $02D843
  LDA #$0003

;hijack the code for egg plants specifically to turn into a Needlenose plant when detecting Sluggy at low health
org $078425
  autoclean JSL test_sluggy
  NOP
  NOP

freecode

;detect whether there is a Sluggy here
test_sluggy:
  ;clean up hijack
  LDA #$0040
  STA $7542,x

  ;store X
  PHX

  ;loop through all sprites
  LDX #$5C
  sluggy_loop:
    LDA $7360,x
    CMP #$00D7
    BNE .next

    ;At this point, a sprite ID == $00D7 (Sluggy)
    BRA test_sluggy_health

    .next
    DEX
    DEX
    DEX
    DEX
    BNE sluggy_loop

;If it didn't find a low-health Sluggy
test_sluggy_return:
  PLX
  RTL

;If it's found a Sluggy, check health
test_sluggy_health:
  LDA $7A38,x
  CMP !needlenose_hits
  BCC test_sluggy_return

  ;At this point, Sluggy has low health so turn into a Needlenose plant and return
  PLX
  SEP #$20
  LDA #$02
  STA $7900,x
  LDA $6FA3,x
  AND $9F
  STA $6FA3,x
  REP #$20
  RTL