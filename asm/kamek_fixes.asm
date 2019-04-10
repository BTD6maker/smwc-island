org $0CDA76
  db $02, $02, $04, $04, $02, $04, $04, $04
  db $02, $04, $04, $04

  db $35, $35, $33, $33, $35, $33, $33, $B3
  db $35, $33, $33, $33

  db $04, $04, $01, $01, $04, $01, $01, $01
  db $04, $01, $01, $01

  dw $00D8  ; burt
  dw $00D8  ; salvo
  dw $00FA  ; boo
  dw $00FA  ; roger
  dw $00D8  ; froggy
  dw $00FA  ; naval piranha
  dw $00FA  ; milde
  dw $00FA  ; hookbill
  dw $00D8  ; sluggy
  dw $00FA  ; raphael
  dw $00FA  ; tap tap
  dw $00FA  ; bowser

org $0CE569
; boss palette pointers (after transformation)
  dl $5FA5CA  ; 1-4
  dl $702122  ; 1-8
  dl $7021A2  ; 2-4
  dl $5FA58E  ; 2-8
  dl $702182  ; 3-4
  dl $702122  ; 3-8
  dl $5FA642  ; 4-4
  dl $702122  ; 4-8
  dl $702122  ; 5-4
  dl $7021C2  ; 5-8
  dl $5FA642  ; 6-4
  dl $7021C2  ; 6-8

; boss palette pointers (before transformation)
  dl $702102  ; 1-4
  dl $702122  ; 1-8
  dl $702122  ; 2-4
  dl $702142  ; 2-8
  dl $702182  ; 3-4
  dl $702122  ; 3-8
  dl $702142  ; 4-4
  dl $702122  ; 4-8
  dl $702182  ; 5-4
  dl $702102  ; 5-8
  dl $702142  ; 6-4
  dl $702102  ; 6-8
