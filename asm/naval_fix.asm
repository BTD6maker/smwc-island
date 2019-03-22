org $01A27F
dw $0006	; State "Naval Closer"
dw $FFFF	; Timer
dw $02B0	; X Pos
dw $07A0	; Y Pos
dw $0004	; 6 - Blocks to place

dw $0002	; State "Adjust Camera 2"
dw $FFFF	; Timer
dw $00C0	; Fraction to Add
dw $02B0	; Final camera position
dw $0001	; Move camera

dw $0003	; State "Set Screen Border"
dw $0001	; Timer
dw $02B0	; Left Side
dw $02F0	; Right Side

; Map16 table
org $01A478
dw $90BE,$90A9
dw $90D6,$90C7
dw $90D7,$90C5
dw $90D6,$90C5
dw $90D7,$90C4

; Don't add additional blocks
org $01A4C3
NOP #4

; Disable OH,MY
org $05A087
db $6B