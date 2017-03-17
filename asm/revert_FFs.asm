incsrc bank21.asm

org $008CFC
  db $FF, $FF, $FF, $FF

org $09ABC3
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $09ABC2 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $09ABCA |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $09ABD2 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $09ABDA |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $09ABE2 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $12A8AF
  dw $FFFF, $FFFF, $FFFF, $FFFF             ; $12A8AF |
  dw $0D09, $0E09, $FF16, $0417             ; $12A8B7 |
  dw $0E09, $100F, $0D11, $0E09             ; $12A8BF |
  dw $100F, $0417, $0209, $0D0A             ; $12A8C7 |
  dw $FFFF, $FFFF, $FFFF, $FFFF             ; $12A8CF |
  dw $0A02, $1202, $0313, $1918             ; $12A8D7 |
  dw $1202, $0313, $1514, $1202             ; $12A8DF |
  dw $0313, $1918, $090D, $0A02             ; $12A8E7 |
  dw $FFFF, $FFFF, $FFFF, $FFFF             ; $12A8EF |

  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A8F7 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A8FF |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A907 |
  db $FF, $FF, $0B, $FF, $06, $08, $07, $37 ; $12A90F |
  db $FF, $FF, $00, $FF, $FF, $FF, $FF, $FF ; $12A917 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A91F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A927 |
  db $FF, $FF, $FF, $FF, $0D, $09, $0D, $38 ; $12A92F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A937 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A93F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A947 |
  db $FF, $FF, $FF, $FF, $FF, $02, $0A, $FF ; $12A94F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A957 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A95F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A967 |
  db $FF, $FF, $FF, $FF, $36, $09, $0D, $38 ; $12A96F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A977 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A97F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A987 |
  db $FF, $FF, $FF, $FF, $FF, $0D, $09, $FF ; $12A98F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A997 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A99F |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9A7 |
  db $FF, $FF, $FF, $FF, $36, $0A, $0D, $09 ; $12A9AF |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9B7 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9BF |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9C7 |
  db $FF, $FF, $FF, $FF, $FF, $0D, $09, $0D ; $12A9CF |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9D7 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9DF |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9E7 |
  db $FF, $FF, $FF, $FF, $36, $09, $02, $0A ; $12A9EF |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9F7 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $12A9FF |
  db $FF, $2C, $2D, $01, $07, $0C, $05, $0B ; $12AA07 |
  db $00, $2A, $2B, $2C, $2D, $00, $06, $08 ; $12AA0F |
  db $FF, $FF, $FF, $FF, $35, $07, $0C, $37 ; $12AA17 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $0B ; $12AA1F |
  db $00, $17, $04, $09, $02, $0A, $0D, $09 ; $12AA27 |
  db $0E, $0F, $10, $17, $04, $09, $02, $0A ; $12AA2F |
  db $FF, $FF, $FF, $FF, $FF, $02, $0A, $FF ; $12AA37 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $11 ; $12AA3F |
  db $03, $18, $19, $0D, $09, $02, $0A, $02 ; $12AA47 |
  db $12, $13, $03, $18, $19, $0D, $09, $02 ; $12AA4F |
  db $FF, $FF, $FF, $FF, $36, $09, $02, $38 ; $12AA57 |
  db $FF, $FF, $FF, $FF, $FF, $FF, $03, $14 ; $12AA5F |
  db $15, $1C, $1D, $1E, $0D, $09, $02, $0A ; $12AA67 |
  db $0E, $1A, $1B, $1C, $1D, $1E, $0D, $09 ; $12AA6F |