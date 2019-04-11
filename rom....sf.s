.segment "SC000"
           ;+$300 ;rom patch
;code ;controller format code
;*=*+$3a1
cchksm	.byte 0

	.byte $46

clear	lda pcr2        ; enable write
	and #$ff-$e0
	ora #$c0
	sta pcr2
;
	lda #$ff        ; make port an output
	sta ddra2
;
	lda #$55        ; write a 1f pattern
	sta data2
;
	ldx #3
	ldy #00
cler10	bvc *
	clv
	dey
	bne cler10
;
	dex
	bne cler10
;
	rts
;
;
;----------------------------------------------------
;     patch 15  *rom ds 01/21/85*
;
ptch15	ldy  lindx
	jmp  rndget
;
;
;----------------------------------------------------
;
;     patch 41
;
ptch41  sta  nbkl,x
	sta  nbkh,x
	lda  #0
	sta  lstchr,x
	rts
;
;
;----------------------------------------------------
;
;     patch 67
;
ptch67
	php
	sei
	lda #0
	sed
pth671	cpx #0
        beq pth672

        clc
        adc #1
        dex
        jmp pth671
pth672	plp
	jmp hex5
;
;
;----------------------------------------------------
;
;     patch 66
;
ptch66
	cmp #3
	bcs pth661
;
	lda #dskful
	jsr errmsg
;
pth661	lda #1
	rts
;
	  ; track cutoffs
trackn  .byte 41,31,25,18

	.byte "COPYRIGHT (C)1985 COMMODORE ELECTRONICS, LTD.", cr
	.byte "ALL RIGHTS RESERVED", cr

freec0	.res 103        ; c0 patch space
