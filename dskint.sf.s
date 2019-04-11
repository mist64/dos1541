;
; error display routine
; blinks the (error #)+1 in all three leds
;
pezro	ldx #0          ;error #1 for zero page
	.byte $2c       ;skip next two bytes
perr	ldx temp        ;get error #
	txs             ;use stack as storage reg.
pe20	tsx             ;restore error #
pe30	lda #led0+led1
	ora ledprt
	jmp pea7a       ;turn on led !!!!patch so ddrb led is output!!!!
rea7d	tya             ;clear inner ctr !!!!patch return!!!!
pd10	clc
pd20	adc #1          ;count inner ctr
	bne pd20
	dey             ;done ?
	bne pd10        ;no
;
	lda ledprt
	and #$ff-led0-led1
	sta ledprt      ;turn off all leds
pe40	;wait
	tya             ;clear inner ctr
pd11	clc
pd21	adc #1          ;count inner ctr
	bne pd21
	dey             ;done ?
	bne pd11        ;no
;
	dex             ;blinked # ?
	bpl pe30        ;no - blink again
	cpx #$fc        ;waited between counts ?
	bne pe40        ;no
	beq pe20        ;always - all again
dskint
	sei
	cld
	ldx #$ff
	jmp patch5      ; *** rom ds 8/18/83 ***
dkit10	inx		; fill
;
;
;*********************************
;
; power up diagnostic
;
;*********************************
;
	ldy #0
	ldx #0
pu10	txa             ;fill z-page accend pattern
	sta $0,x
	inx
	bne pu10
pu20	txa             ;check pattern by inc...
	cmp $0,x        ;...back to orig #
	bne pezro       ;bad bits
pu30
	inc $0,x        ;bump contents
	iny
	bne pu30        ;not done
;
	cmp $0,x        ;check for good count
	bne pezro       ;something's wrong
;
	sty $0,x        ;leave z-page zeroed
	lda $0,x        ;check it
	bne pezro       ;wrong
;
	inx             ;next!
	bne pu20        ;not all done
;
;
; test two 64k-bit roms
;
; enter x=start page
; exit if ok
;
rm10	inc temp        ;next error #
	stx ip+1        ;save page, start x=0
	lda #0
	sta ip          ;zero lo indirect
	tay
	ldx #32         ;32 pages in 8k rom
	clc
rt10	dec ip+1        ;do it backwards
rt20	adc (ip),y      ;total checksum in a
	iny
	bne rt20
	dex
	bne rt10
	adc #0          ;add in last carry
	tax             ;save lower page in x
	cmp ip+1        ;correct ?
	bne perr2       ;no - show error number
;
	cpx #$c0        ;done both roms ?
	bne rm10        ;no
; test all common ram
;
cr20	lda #$01        ;start of 1st block
cr30	sta ip+1        ;save page #
	inc temp        ;bump error #
; enter x=# of pages in block
;  ip ptr to first page in block
; exit if ok
;
ramtst	ldx #7          ;save page count
ra10	tya             ;fill with adr sensitive pattern
	clc
	adc ip+1
	sta (ip),y
	iny
	bne ra10
	inc ip+1
	dex
	bne ra10
	ldx #7          ;restore page count
ra30	dec ip+1        ;check pattern backwards
ra40	dey
	tya             ;gen pattern again
	clc
	adc ip+1
	cmp (ip),y      ;ok ?
	bne perr2       ;no - show error #
	eor #$ff        ;yes - test inverse pattern
	sta (ip),y
	eor (ip),y      ;ok ?
	sta (ip),y      ;leave memory zero
	bne perr2       ;no - show error #
	tya
	bne ra40
	dex
	bne ra30
;
	beq diagok
;
perr2	jmp perr
;
diagok
	ldx #topwrt
	txs
	lda ledprt      ;clear leds
	and #$ff-led0-led1
	sta ledprt
;
	lda #1          ; neg edge of atn
	sta pcr1
	lda #%10000010
	sta ifr1
	sta ier1
	lda pb          ;compute primary addr
	and #%01100000  ;pb5 and pb6 are unused line
	asl a           ;shift to lower
	rol a
	rol a
	rol a
	ora #$48        ;talk address
	sta tlkadr
	eor #$60        ;listen address
	sta lsnadr
;
; initialize buffer pntr table
;
inttab	ldx #0
	ldy #0
intt1	lda #0
	sta buftab,x
	inx
	lda bufind,y
	sta buftab,x
	inx
	iny
	cpy #bfcnt
	bne intt1
;
	lda #<cmdbuf    ;set pntr to cmdbuf
	sta buftab,x
	inx
	lda #>cmdbuf
	sta buftab,x
	inx
	lda #<errbuf    ;set pntr to errbuf
	sta buftab,x
	inx
	lda #>errbuf
	sta buftab,x
;
	lda #$ff
	ldx #maxsa
dskin1	sta lintab,x
	dex
	bpl dskin1
;
	ldx #mxchns-1
dskin2
	sta buf0,x      ;set buffers as unused
	sta buf1,x
	sta ss,x
	dex
	bpl dskin2
;
	lda #bfcnt      ;set buffer pointers
	sta buf0+cmdchn
	lda #bfcnt+1
	sta buf0+errchn
	lda #$ff
	sta buf0+blindx
	sta buf1+blindx
	lda #errchn
	sta lintab+errsa
	lda #cmdchn+$80
	sta lintab+cmdsa
	lda #lxint      ;lindx 0 to 5 free
	sta linuse
	lda #rdylst
	sta chnrdy+cmdchn
	lda #rdytlk
	sta chnrdy+errchn
	lda #$e0
	sta bufuse
	lda #$ff
	sta bufuse+1
	lda #1
	sta wpsw
	sta wpsw+1
	jsr usrint      ;init user jmp
	jsr lruint
;
;**********************************
;
; controller initialization
;
;**********************************
;
	jsr cntint
; set indirect vectors
	lda #<diagok
	sta vnmi
	lda #>diagok
	sta vnmi+1
;
	lda #10         ;set up sector offset
	sta secinc
	lda #5
	sta revcnt      ;set up recovery count
;*
;*******************************
;*
;*    seterr
;*    set up power on error msg
;*
;*    cbm dos v2.0 (c)1979
;*
;*******************************
;*
;*
;
seterr	lda #$73
	jsr errts0
;
;
;must be contiguous to .file idle
;
;********************************
; init the serial bus
;
;********************************
;
;-------rom -05 8/18/83-----------------
	lda #$00       ;  data hi, clock hi,atna hi
	sta pb
	lda #%00011010 ;  atna,clkout,datout
	sta ddrb1
;---------------------------------------
	jsr boot
;
