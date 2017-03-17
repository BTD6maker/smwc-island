; Better Middle Rings
; by Raidenthequick
; (modified to work with SPASM)

lorom

!sublevel = $015F

; middle ring entrance data changed, so read differently
org $01E656
  ; set hardcoded screen exit to 0
  STZ $038E

  ; set X to be sublevel
  PHX
  REP #$30
  LDX !sublevel

  ; set bank to 7F since it's more frequent now
  LDY #$7F7F
  PHY
  PLB
  PLB

  ; grab X, Y coords
  LDA $17F551,x
  STA $7E01

  ; use sublevel directly
  TXA
  LSR A
  SEP #$30
  STA $7E00

  ; and finally, just use 0 for entrance type
  STZ $7E03
  PLX

  PLB
  PLB
  RTL

; use this as freespace since I freed up some room
; store sublevel * 2 for easier indexing
set_level:
  AND #$00FF
  ASL A
  STA !sublevel
  JML $01B088

; extra freespace
  db $FF, $FF

incsrc better_midrings_data.asm
