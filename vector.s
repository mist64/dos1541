.pag vector
echksm	.byt 0          ;$e-$f checksum
nmi	jmp (vnmi)
;
patch	;patch area
pea7a	sta ledprt      ;patch for power-on errors
	sta ledout      ;turn ddrb to output
	jmp rea7d       ;return to led blink code
;
;default table for user command
;
	*= $ffe6
	.word format
	.word trnoff
ublock	.word ublkrd
	.word ublkwt
.skip
	.word $0500     ;links to buffer #2
	.word $0503
	.word $0506
	.word $0509
	.word $050c
	.word $050f
	*= $fffa
	.word nmi
	.word dskint
	.word sysirq
.end
