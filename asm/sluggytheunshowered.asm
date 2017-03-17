; acceleration (movement forward)
org $02D4A3
  dw $0100, $0000

; delay time of non-motion
org $02D48A
  LDA #$0040

; health
org $02D5B7
  CMP #$0007

; elasticity
org $02D218
  LDA #$FF50

; faked health index for heart animation stuff
org $02D54D
  LDA #$0003

org $02D843
  LDA #$0003