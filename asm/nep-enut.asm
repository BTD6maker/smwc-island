lorom

org $02C07E
	autoclean JML hijack

freecode $FF

hijack:
	LDA $015F
	CMP #$003F*2
	BEQ .ok
	LDA $BF09,y
	STA $702002
	JML $02C085

.ok
	LDA #$0A8A
	STA $702002
	STA $702D6E
	LDA #$09E5
	STA $702004
	STA $702D70
	LDA #$0B94
	STA $702006
	STA $702D72
	RTL
