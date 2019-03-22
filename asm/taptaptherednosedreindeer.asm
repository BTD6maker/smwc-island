lorom

; change timing to prepare for jump
org $0FA027
  db $00, $00, $00, $00, $00, $00, $00, $00
  db $0F, $0F, $0F, $0F
  db $FF

; change timing of lands
org $0FA105
  db $0F, $0F, $0F, $0F
  db $00, $00, $00, $00, $00, $00, $00, $00
  db $FF

; walking speed
org $0F9F10
  dw $FE00, $0200, $FC00, $0400

; beginning wait timer
org $0F9EE8
  LDA #$20

; turn around faster
org $0F9FB7
  LDA #$08

org $0F9FEE
  CPY #$04

org $0F9F18
  db $1F, $1F, $1F, $20, $20, $20, $1F, $1F, $1F

; egg hit hijack
org $0FA651
  autoclean JML tap_tap_on_egg_hit
  NOP

freecode

tap_tap_on_egg_hit:
  PHP
  PHY
  REP #$20
  
  ;Decides whether to spawn Tap-Tap. (BTD6_maker)
  LDA $021A
  CMP #$0027
  BNE return_after_tap_tap

  ; spawn hopping tap tap
  LDA #$010B
  JSL $03A34C

  ; set position to boss's (with offset)
  LDA $70E2,x
  SEC
  SBC #$0008
  STA $70E2,y

  LDA $7182,x
  SEC
  SBC #$0008
  STA $7182,y

return_after_tap_tap:
  ; return
  PLY
  PLP
  LDA #$0B
  STA $105F
  JML $0FA656

