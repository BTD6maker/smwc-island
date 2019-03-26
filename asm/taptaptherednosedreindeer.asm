lorom

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

