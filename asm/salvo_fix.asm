; Yoshi position to start the closer scene
org $068202
  CMP #$03E0

; coords for lemon sprite that turns into Salvo
org $06824D
  LDA #$0440
  STA $70E2,y
  LDA #$0630
  STA $7182,y

; Y coord for salvo himself
org $0682B4
  LDA #$0628
  STA $7182,x
  STA $1076
  LDA #$06B0
  STA $108A

; coords for slimes that spawn when you run out of eggs
org $06870B
  ADC #$03C8
  STA $70E2,y
  LDA #$0630
  STA $7182,y
