lorom

org $04B9CA
  autoclean JML boo_growing
  NOP

; shrink for intro
org $04BD47
  LDA $7A36,x
  SEC
  SBC #$0002
  STA $7A36,x
  CMP $16,x
  BPL $2D
  LDA #$0020
  STA $7A96,x
  LDA $16,x
  SEC
  SBC #$0010     ; step value
  CMP #$0030
  BPL boo_intro_shrink
  STZ $60AC
  LDY #$00
  STY $76,x
  STZ $7A96,x
  STZ $0C1E
  STZ $1064
  LDA #$01DE
  JSL $039788
  LDA #$001E     ; size value after shrinking
boo_intro_shrink:
  STA $16,x

; getting hit
org $04B8A9
  LDA $16,x
  SEC
  SBC #$0008     ; step value to shrink by
  STA $105E
  SEC
  SBC #$0000
  CMP #$0000     ; death value
  BPL $24

; speeds
org $04BA69
  dw $FE00
  dw $0200

; acceleration
org $04BA98
  LDA #$0010

; prevent stopping & fix his direction
org $04B69B
  STZ $78,x
  LDA $7220,x
  BMI boo_face_left
  LDA #$0002
  BRA boo_face_set
boo_face_left:
  LDA #$0000
boo_face_set:
  STA $7400,x
  NOP #38

freecode

; reverse BPL's to BMI BEQ's and BMI's to BPL BEQ's
boo_growing:
  LDA $7A36,x
  CMP $16,x
  BMI boo_gr_return
  BEQ boo_gr_return
  LDY $0CE8
  BEQ $07
  LDA $1060
  BNE boo_gr_exit_1
  BRA boo_gr_exit_2
  CMP $105E
  BEQ boo_gr_equal
  BPL boo_gr_subtract
boo_gr_equal:
  LDA #$0020
  STA $0CE8
  LDA $105E
  SEC
  SBC #$0018
  CMP $16,x
  BEQ boo_gr_load
  BPL boo_gr_store
boo_gr_load:
  LDA $16,x
boo_gr_store:
  STA $105E
boo_gr_return:
  JML $04B9F8
boo_gr_subtract:
  SEC
  SBC #$0008
  STA $7A36,x
  CMP $16,x
  BEQ boo_gr_exit_0
  BPL boo_gr_exit_1
boo_gr_exit_0:
  JML $04BA04
boo_gr_exit_1:
  JML $04BA0B
boo_gr_exit_2:
  JML $04BA19
