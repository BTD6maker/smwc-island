incsrc reg_vars.asm
incsrc ram_vars.asm
incsrc sram_vars.asm
incsrc sprite_table_vars.asm

; change raph's intro scene to be funnier
org $0FB004
CODE_0FB004:
  RTS

raphael_init_lunging:
  TYX
  SEP #$20
  LDA !r_frame_counter_global
  AND #$07
  TAY
  LDA $B48D,y
  STA $1064
  LDA $B495,y
  STA $1065
  REP #$20
  LDY !s_spr_timer_1,x
  BNE CODE_0FB004
  LDA !r_frame_counter_global
  AND #$0001
  BNE CODE_0FB05C
  LDA #$01DF
  JSL $008B21
  LDA !s_spr_x_pixel_pos,x
  CLC
  ADC #$0010
  STA $70A2,y
  LDA !s_spr_y_pixel_pos,x
  CLC
  ADC #$0012
  STA $7142,y
  LDA #$0005
  STA $7E4C,y
  STA $73C2,y
  LDA #$0004
  STA $7782,y
  LDA #$0000
  STA $7462,y

CODE_0FB05C:
  LDA #$FB80
  STA !s_spr_x_speed_lo,x
  LDY !s_spr_collision_id,x
  BPL CODE_0FB0B3
  LDA #$0800
  STA !s_spr_x_speed_lo,x
  LDA #$001E
  STA !s_player_state
  JSL $03BFF7
  LDA #$FC00
  STA !s_player_x_speed_prev
  LDA #$FE00
  STA !s_player_y_speed
  INC !s_spr_wildcard_4_lo_dp,x
  LDA #$0013
  JSL $0085D2
  LDA #$01E6
  JSL $008B21
  LDA !s_player_x
  CLC
  ADC #$0008
  STA $70A2,y
  LDA !s_player_y
  CLC
  ADC #$0008
  STA $7142,y
  LDA #$0004
  STA $7782,y
  LDA #$0007
  STA $73C2,y
  STA $7E4C,y

CODE_0FB0B3:
  RTS

; make him a SPAZZ
org $0FB56B
  AND #$03

org $0FB536
  ADC #$20

; guarantee he won't land on a pillar
org $0FB4DA
  AND #$3F
  CMP #$20

; move quickly after turning
org $0FB57B
  LDA #$06

; change his stomping velocity
!raph_stomp_velocity = #$10
org $0FB2FF
  LDA !raph_stomp_velocity

org $0FB561
  LDA !raph_stomp_velocity

org $0FB5A9
  LDA !raph_stomp_velocity
