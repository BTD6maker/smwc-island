; dark world appearing on title
org $178150
  CPX #$04

; show flags from previous worlds on title
org $178523
  CMP #$08

; trigger transport to dark world
org $178C94
  CPX #$10

; disable bonus tiles from loading bonus games
org $17B4AE
  db $80  ; BRA

; point bonus tiles to Secret levels
org $17F3E7
  dw $0000                                  ; $17F3E7 | 1-1
  dw $0004                                  ; $17F3E9 | 1-2
  dw $0008                                  ; $17F3EB | 1-3
  dw $000C                                  ; $17F3ED | 1-4
  dw $0010                                  ; $17F3EF | 1-5
  dw $0014                                  ; $17F3F1 | 1-6
  dw $0018                                  ; $17F3F3 | 1-7
  dw $001C                                  ; $17F3F5 | 1-8
  dw $0020                                  ; $17F3F7 | 1-E
  dw $00B4                                  ; $17F3F9 | 1-S
  dw $00D8                                  ; $17F3FB | 1-Controller
  dw $00DC                                  ; $17F3FD | 1-Score
  dw $0024                                  ; $17F3FF | 2-1
  dw $0028                                  ; $17F401 | 2-2
  dw $002C                                  ; $17F403 | 2-3
  dw $0030                                  ; $17F405 | 2-4
  dw $0034                                  ; $17F407 | 2-5
  dw $0038                                  ; $17F409 | 2-6
  dw $003C                                  ; $17F40B | 2-7
  dw $0040                                  ; $17F40D | 2-8
  dw $0044                                  ; $17F40F | 2-E
  dw $00B8                                  ; $17F411 | 2-S
  dw $0000                                  ; $17F413 | 2-Controller
  dw $0000                                  ; $17F415 | 2-Score
  dw $0048                                  ; $17F417 | 3-1
  dw $004C                                  ; $17F419 | 3-2
  dw $0050                                  ; $17F41B | 3-3
  dw $0054                                  ; $17F41D | 3-4
  dw $0058                                  ; $17F41F | 3-5
  dw $005C                                  ; $17F421 | 3-6
  dw $0060                                  ; $17F423 | 3-7
  dw $0064                                  ; $17F425 | 3-8
  dw $0068                                  ; $17F427 | 3-E
  dw $00BC                                  ; $17F429 | 3-S
  dw $0000                                  ; $17F42B | 3-Controller
  dw $0000                                  ; $17F42D | 3-Score
  dw $006C                                  ; $17F42F | 4-1
  dw $0070                                  ; $17F431 | 4-2
  dw $0074                                  ; $17F433 | 4-3
  dw $0078                                  ; $17F435 | 4-4
  dw $007C                                  ; $17F437 | 4-5
  dw $0080                                  ; $17F439 | 4-6
  dw $0084                                  ; $17F43B | 4-7
  dw $0088                                  ; $17F43D | 4-8
  dw $008C                                  ; $17F43F | 4-E
  dw $00C0                                  ; $17F441 | 4-S
  dw $0000                                  ; $17F443 | 4-Controller
  dw $0000                                  ; $17F445 | 4-Score
  dw $0090                                  ; $17F447 | 5-1
  dw $0094                                  ; $17F449 | 5-2
  dw $0098                                  ; $17F44B | 5-3
  dw $009C                                  ; $17F44D | 5-4
  dw $00A0                                  ; $17F44F | 5-5
  dw $00A4                                  ; $17F451 | 5-6
  dw $00A8                                  ; $17F453 | 5-7
  dw $00AC                                  ; $17F455 | 5-8
  dw $00B0                                  ; $17F457 | 5-E
  dw $00C4                                  ; $17F459 | 5-S

; correct side effects of changing bonus to secret
org $17D0ED
  db $0E, $0B, $16, $0B, $1E, $0B, $26, $0B, $2E, $0B, $36, $0B
  db $4E, $0C, $56, $0C, $5E, $0C, $66, $0C, $70, $0C, $78, $0C
  db $4E, $0B, $56, $0B, $5E, $0B, $66, $0B, $6E, $0B, $76, $0B
  db $8E, $0C, $96, $0C, $9E, $0C, $A6, $0C, $B0, $0C, $B8, $0C
  db $8E, $0B, $96, $0B, $9E, $0B, $A6, $0B, $AE, $0B, $B6, $0B
  db $CE, $0C, $D6, $0C, $DE, $0C, $E6, $0C, $F0, $0C, $F8, $0C

org $17D164
  LDY $0E
  LDA $DCEF,y
  STA $00
  LDA $D0ED,y
  STA $02
  LDA $D105,y
  STA $04
  LDA $D11D,y

; how many tiles flip over after beating a level
org $17A6F1
  CPX #$0A

; how many icons have a border when flipped over
org $17D1E0
  CMP #$0014

; chalkboard stuff
org $17D199
  db $30

org $17D7E6
  db $30

org $17D477
  db $30

org $17D4AF
  db $30

; how many icons flash if the high score is 100
org $17D587
  CPX #$14

; how many icons flip for score button
org $17D2FE
  db $0A

org $17D65D
  db $0A

; save high score after completing 5-8
org $0DFC3E
  db $EF

org $0DFC43
  db $EF

org $0DFC49
  db $EF