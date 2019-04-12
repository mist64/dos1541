echksm	.byt 0          ;$e-$f checksum
nmi	jmp (vnmi)
;
patch	;patch area
pea7a	sta ledprt      ;patch for power-on errors
	sta ledout      ;turn ddrb to output
	jmp rea7d       ;return to led blink code
;
;---------------------------------------------------
; patch area for 1541 disk with slow serial receive
;
slowd	txa     	; only affect .a
	ldx #5         ; insert 40us of delay with this routine
slowe	dex
	bne slowe
	tax
	rts
;
;---------------------------------------------------
;
clkdat	jsr clklow     ; new clock low and...
	jmp dathi      ; data hi for patch area
;
;---------------------------------------------------
;
nnmi	lda cmdbuf+2   ; new nmi routine check for
	cmp #'-'
	beq nnmi10     ; if ui- then no delay
	sec
	sbc #'+'
	bne nmi        ; if not ui+ then must be a real ui command
nnmi10  sta drvtrk+1
	rts
;
;
;---------------------------------------------------
;      patch 5   *rom-05 8/18/83*
;
;clock line hi on pwr on
;
patch5	stx ddra1      ; set direction
	lda #$02       ; set clock high
;
	sta pb
;
ptch22r	lda #$1a       ; set ddra reg b
	sta ddrb1
	jmp dkit10     ; return
;
;
;---------------------------------------------------
;      patch 6   *rom ds 8/18/83*
;
;fix eoi timing to wait all devices
;
;
patch6 	lda pb         ; test data line
	and #$01       ; every one rdy ?
	bne patch6
	lda #$01       ; wait 255 usec
	sta t1hc1      ; set timer
	jmp acp00      ; return
;
;
;---------------------------------------------------
;     patch 7   *** rom ds 03/15/85 ***
;
;
patch7	lda #$ff       ; clear format flags
	sta ftnum      ;
	jmp format     ; transfer format to ram
;
;
;----------------------------------------------------
;     patch 11  *rom ds 01/21/85*
;
ptch11	sta nodrv       ; clr nodrv
	jmp setlds	; set leds
;
;
;----------------------------------------------------
;
;     patch 54
;
ptch54  cmp #2		; error ?
	bcc pth541
;
	cmp #15		; no drv condition ?
	beq pth541
;
	jmp rtch54	; bad, try another
pth541	jmp stl50	; ok
;
;
;----------------------------------------------------
;
;     patch 31
;
ptch31	sei
	ldx  #topwrt	; set stack pointer
	txs
	jmp  rtch31
;
;
;----------------------------------------------------
;
;     patch 30
;
ptch30	bit pa1
	jmp atnsrv

;
;
;----------------------------------------------------
;
;     patch 50
;
ptch50	lda a:nodrv,x
	rts
;
;----------------------------------------------------
;
;     patch 52
;
ptch52	ldx  drvnum	; get offset
	lda a:nodrv,x
	jmp  rtch52
;
;
;----------------------------------------------------
;
;     patch 43
;
;
ptch43  lda #0		; clr nodrv
	sta a:nodrv,x
	jmp  rtch43
;
;
;----------------------------------------------------
;
;     patch 44
;
;
ptch44  tya		; set/clr nodrv
	sta a:nodrv,x
	jmp rtch44
;
;
;----------------------------------------------------
;
;     patch 51
;
ptch51	sta wpsw,x	; clr wp switch
	sta a:nodrv,x
	jmp rtch51

;
;default table for user command
;
.segment "SFFE6"
	.word format
	.word trnoff
ublock	.word ublkrd
	.word ublkwt
	.word $0500     ;links to buffer #2
	.word $0503
	.word $0506
	.word $0509
	.word $050c
	.word $050f
.segment "SFFFA"
	.word nnmi
	.word dskint
	.word sysirq
