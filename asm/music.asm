@asar 1.37

; repoint header unpack to one further up
org $01B0B2
  JSL $108B16

; modify table of packed header bits to include unused 5 byte
org $108B05
  db $05, $04, $05, $05
  db $06, $06, $06, $07
  db $04, $05, $06, $05
  db $05, $04, $02, $05, $00

  REP #$10
  LDY #$0000
  LDX #$0000
  STX $99
  STZ $02
  LDA $108B05,x

CODE_108B27:
  STA $04
  LDA #$00

CODE_108B2B:
  DEC $02
  BPL CODE_108B40
  PHA
  LDA #$07
  STA $02
  PHY
  LDY $99
  LDA [$32],y
  STA $06
  INY
  STY $99
  PLY
  PLA

CODE_108B40:
  ASL $06
  ROL A
  DEC $0004
  BNE CODE_108B2B
  STA $0134,y
  INY
  INY
  INX
  LDA $108B05,x
  BNE CODE_108B27
  LDA $0150
  STA $03BE
  SEP #$10
  RTL

; clean up & repoint another call
  NOP
  JSL $108B16

; hijack
org $008549
  autoclean JML music_hijack

; table replacements
org $00855F
  LDA.l SPC_blocks-1,x

org $00856C
  LDA.l SPC_block_sets,x

org $008583
  LDA.l SPC_ptr-1,x
  STA $0000,y
  LDA.l SPC_ptr,x
  STA $0001,y
  LDA.l SPC_ptr+1,x

org $01B269
  LDA.l SPC_tracks-1,x

freecode $FF

SPC_ptr:
  dl $4E0000
  dl $4E169C
  dl $4E23BF
  dl $4E2C39
  dl $4E38D2
  dl $4ED0FE
  dl $4ED5D0
  dl $4EE279
  dl $4EEC85
  dl $4F4122
  dl $4F5C48
  dl $4F6E5A
  dl $4F82E6
  dl $4FFCB2
  dl $500342
  dl $4F33F0
  dl $4EFEC1
  dl $4F205D
  dl $4E3E90
  dl $4EBBEC
  dl $A38500

SPC_block_sets:
  db $2B, $FF, $FF, $FF
  db $25, $22, $2E, $FF
  db $25, $22, $1C, $FF
  db $25, $19, $13, $FF
  db $25, $16, $10, $FF
  db $25, $16, $0D, $FF
  db $25, $22, $28, $FF
  db $25, $16, $0A, $FF
  db $25, $19, $07, $FF
  db $25, $19, $1F, $FF
  db $25, $01, $04, $FF
  db $31, $34, $FF, $FF
  db $37, $3A, $FF, $FF
  db $25, $01, $3D, $FF

item_music:
  db $00, $00, $00, $01, $00, $01, $00, $01
  db $01, $01, $00, $00, $01, $00, $00, $00
  db $FF, $00, $FF, $00, $00, $00, $00, $00

SPC_blocks:
  db $0C, $10, $18, $1C, $14
  db $1C, $20, $24, $24, $24
  db $28, $28, $2C, $1C, $00
  db $00, $00, $04, $08, $30
  db $34

SPC_tracks:
  db $01, $01, $01, $01
  db $01, $09, $01, $01
  db $09, $0C, $01, $02
  db $00, $01, $00, $00
  db $00, $02, $01
  db $01, $01, $01, $01

; shift unused header and combine with music to make:
; uuuummmm
music_hijack:
  LDA $0152
  ASL A
  ASL A
  ASL A
  ASL A
  ORA $014E
  STA $014E
  TAX

  ; load item music value
  LDA.l item_music,x
  JML $00854D

; 1-1 header
org $1681CF
  db $32, $01

; new block
org $238500
  incbin mml.bin