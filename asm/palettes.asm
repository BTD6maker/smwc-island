; custom palette for ???
org $3FAEA2
db $80, $30, $E2, $30, $A4, $4D, $88, $6A
db $80, $30, $E2, $30, $A4, $4D, $88

; BG2 palette 33 for stage 4-8
org $3FBCF2
db $A4, $10, $83, $10, $62, $08, $40, $08
db $A4, $00, $82, $00, $60, $00, $6A, $10
db $41, $08, $44, $08, $22, $04, $69, $10
db $46, $08, $43, $04, $47, $0C, $47, $08
db $49, $14, $48, $10, $27, $10, $25, $0C
db $24, $0C, $23, $08, $68, $0C, $22, $04
db $44, $08, $22, $04, $69, $10, $46, $08
db $43, $04, $47, $0C

; BG2 palette 3C
org $3FBF0E
db $3B, $67, $63, $2C, $C9, $5C, $AA, $59
db $51, $5A, $F2, $5E, $36, $67, $4E, $31
db $B1, $45, $56, $52, $BA, $62, $87, $51
db $C9, $69, $4B, $6A, $F0, $7E, $EF, $41
db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
db $C6, $1C, $8C, $35, $FF, $7F, $FF, $7F
db $FF, $7F, $FF, $7F

; BG2 palette 3E for stage 5-4
org $3FBF86
dw $0000, $1884, $2928, $614F, $69B1, $75F3, $7E55, $140D
dw $2010, $2813, $3416, $00E0, $0180, $57F5, $5FFE, $0000
dw $140D, $3416, $006E, $0091, $0094, $00B7, $1884, $1CC5
dw $24E7, $2928, $0000, $354D, $6A99, $5FFE

; BG2 palette 3F for stage 1-6
db $7F, $00, $BF, $00, $FF, $00, $3F, $01
db $7F, $01, $BF, $01, $FF, $01, $3F, $02
db $7F, $02, $BF, $02, $FF, $02, $3F, $03
db $7F, $03, $BF, $03, $FF, $03, $FF, $7F
db $FF, $03, $39, $03, $73, $02, $8C, $01
db $C6, $00

; level icon
org $17DC4F
  dw $0C00     ; 1-1
  dw $0C00     ; 1-2
  dw $0C00     ; 1-3
  dw $0C00     ; 1-4
  dw $1000     ; 1-5
  dw $0C00     ; 1-6
  dw $0C00     ; 1-7
  dw $0C00     ; 1-8
  dw $1000     ; 1-E
  dw $0C00     ; 1-Bonus
  dw $1800     ; 1-Controller
  dw $1800     ; 1-Score
  dw $0C00     ; 2-1
  dw $1000     ; 2-2
  dw $0C00     ; 2-3
  dw $1000     ; 2-4
  dw $0C00     ; 2-5
  dw $1000     ; 2-6
  dw $0C00     ; 2-7
  dw $0C00     ; 2-8
  dw $1000     ; 2-E
  dw $0C00     ; 2-Bonus
  dw $1800     ; 2-Controller
  dw $1800     ; 2-Score
  dw $1000     ; 3-1
  dw $1000     ; 3-2
  dw $0C00     ; 3-3
  dw $0C00     ; 3-4
  dw $0C00     ; 3-5
  dw $1000     ; 3-6
  dw $0C00     ; 3-7
  dw $1000     ; 3-8
  dw $0C00     ; 3-E
  dw $1000     ; 3-Bonus
  dw $1800     ; 3-Controller
  dw $1800     ; 3-Score
  dw $0C00     ; 4-1
  dw $1000     ; 4-2
  dw $0C00     ; 4-3
  dw $1000     ; 4-4
  dw $0C00     ; 4-5
  dw $1000     ; 4-6
  dw $1000     ; 4-7
  dw $0C00     ; 4-8
  dw $0C00     ; 4-E
  dw $0C00     ; 4-Bonus
  dw $1800     ; 4-Controller
  dw $1800     ; 4-Score
  dw $0C00     ; 5-1
  dw $0C00     ; 5-2
  dw $0C00     ; 5-3
  dw $0C00     ; 5-4
  dw $0C00     ; 5-5
  dw $0C00     ; 5-6
  dw $1000     ; 5-7
  dw $0C00     ; 5-8
  dw $0C00     ; 5-E
  dw $1000     ; 5-Bonus
  dw $1800     ; 5-Controller
  dw $1800     ; 5-Score
  dw $0C00     ; 6-1
  dw $0C00     ; 6-2
  dw $1000     ; 6-3
  dw $1000     ; 6-4
  dw $0C00     ; 6-5
  dw $0C00     ; 6-6
  dw $1000     ; 6-7
  dw $0C00     ; 6-8
  dw $0C00     ; 6-E
  dw $0C00     ; 6-Bonus
  dw $1800     ; 6-Controller
  dw $1800     ; 6-Score
