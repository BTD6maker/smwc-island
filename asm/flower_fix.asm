lorom

org $0EB379
autoclean JML FixFlower1

org $0EB37F
JML FixFlower2

freecode

FixFlower1:
JSL $03D400
BEQ .notCollected
JML $03A31E
.notCollected
JML $0EB383

FixFlower2:
JSL $03D3F8
BEQ .notCollected
JML $03A31E
.notCollected
JML $0EB383
