  org $04FDC1
autoclean JSL lockhijack
NOP #2    ;jsl           = 4    4 bytes
          ;original code = 3*2  6 bytes

freecode
  lockhijack:
LDA $7FD007   ;load !lockx in arena code
BEQ .return   ;if not set, returnerino

STA $6094     ;store value in $7FD007 to the camera x


  .return
LDA $6094       ;restore original code
LDY $0C1E
RTL