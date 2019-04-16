;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yoshi's Island Font Expansion Patch, by Mattrizzle
; 
; This patch adds adds characters to the font which normally 
; only appear in the Game Boy Advance version, as well as some
; new custom characters. Additionally, characters that weren't
; aligned correctly have been fixed.
;
; The new characters are:
; 0A=/ (slash)
; 0B=(ligature oe)
; 0C=# (pound sign)
; 0D=� (copyright symbol)
; 0E=+ (plus sign)
; 4C=� (E with diaeresis)
; 4D=� (U with circumflex)
; 4E=� (A with acute)
; 4F=� (I with acute)
; 50=� (N with tilde)
; 51=� (O with acute)
; 52=� (I with grave)
; 53=� (O with grave)
; 54=� (e with diaeresis)
; 55=� (o with grave)
; 56=� (a with acute)
; 57=� (i with acute)
; 58=� (n with tilde)
; 59=� (o with acute)
; 5A=� (i with grave)
; 5B=� (masculine ordinal indicatior)
; 5C=� (feminine ordinal indicatior)
; 5D=� (inverted exclamation mark)
; 5E=� (inverted question mark)
; 5F=� (u with acute)
; C4=( (left parenthesis)
; C5=) (right parenthesis)
; C8=_ (underscore)
; CC=@ (at symbol)
; CD=* (asterisk)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lorom

org $09BC2F ; PC $4BE2F
Chr_Width:			; This table determines the width of each character in the variable-width font.
	db $08,$08,$08,$08,$08,$08,$05,$08,$08,$08,$08,$08,$08,$08,$07,$08
	db $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$08,$08,$04,$04,$08,$08,$08,$05,$08,$08,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$04,$06,$03,$07,$06,$07,$06,$07,$03
	db $08,$08,$08,$08,$08,$08,$06,$08,$08,$08,$06,$05,$08,$08,$08,$06
	db $08,$08,$08,$08,$08,$08,$08,$05,$08,$08,$05,$07,$08,$07,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$07
	db $08,$08,$05,$08,$08,$07,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$05,$05,$08,$08,$08,$08,$08,$08,$08,$07,$08,$08
	db $04,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$07,$08,$08
	db $04,$07,$08,$04,$08,$08,$08,$08,$08,$07,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08

; org $09BD2F ; PC $4BF2F
Font_Gfx:
	incbin font.bin		; Font graphics (1BPP)

org $0DF43F ; PC $6F63F
Ending_Fix:
	db $D0,$D0		; Optional; this fixes an issue with the message that appears right after
				; rescuing baby Luigi and the stork. Remove the semicolon prior to the
				; db to enable it.