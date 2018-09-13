	*= $bf00
	sei
	ldx #$ff
	txs
	cld
	lda #0
	sta cchksm
	cmp cchksm
chkpro
	bne chkpro
	lda #$c0
	jsr genchk
	sta cchksm
	lda #0
	sta echksm
	cmp echksm
	bne chkpro
	lda #$e0
	jsr genchk
	sta echksm
	jmp *
;
genchk	;.a=address
	clc
	pha
	sta temp+1
	lda #0
	sta temp
	ldx #32
	ldy #0
chk1
	adc (temp),y
	iny
	bne chk1
;
	inc temp+1
	dex
	bne chk1
;
	adc #0
	sta temp+1
	pla
	sec
	sbc temp+1
	sbc #0          ;.a=checksum byte
	rts
