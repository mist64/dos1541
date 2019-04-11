;
;
;
acptr	lda #8          ; set byte bit count
	sta cont
;
acp00a	jsr tstatn
	jsr debnc
	and #clkin
	bne acp00a
;
	jsr dathi       ; make data line hi
;
	lda #1          ; wait 255 us
;
;------rom -05 8/18/83-------------
	jmp patch6
;----------------------------------
;
acp00	jsr tstatn
	lda ifr1
	and #$40        ; test if time out
	bne acp00b      ; ran out,its an eoi
;
	jsr debnc       ; test clock low
	and #clkin
	beq acp00       ; no
	bne acp01       ; yes
;
acp00b	jsr datlow      ; set data line low as response
;
	ldx #10         ; delay for talker turnaround
acp02	dex
	bne acp02
;
	jsr dathi       ; set data line hi
;
acp02a	jsr tstatn
	jsr debnc       ; wait for low clock
	and #clkin
	beq acp02a
;
	lda #0          ; set eoi received
	sta eoiflg
;
acp01
acp03	lda pb          ; wait for clock high
	eor #01        ; complement datain
	lsr a          ; shift into carry
	and #$02       ; clkin/2
	bne acp03
;
	nop     	; fill space left by speed-up
	nop     	; to fix pal vc20
	nop     	;  901229-02 rom
	ror data
;
acp03a	jsr tstatn
	jsr debnc
	and #clkin      ; wait for clock low
	beq acp03a
;
	dec cont        ; more to do?
	bne acp03
;
	jsr datlow      ; set data line low
	lda data
	rts
;
;
;
listen	sei
;
	jsr fndwch      ; test if active write channel
	bcs lsn15
;
	lda chnrdy,x
	ror a
	bcs lsn30
;
lsn15	lda orgsa       ; test if open
	and #$f0
	cmp #$f0
	beq lsn30       ; its an open
;
	jmp ilerr       ; not active channel
;
lsn30	jsr acptr       ; get a byte
;
	cli
	jsr put         ; put(data,eoiflg,sa)
;
	jmp listen      ; and keep on listen
;
;
frmerr
iterr
ilerr	lda #00         ; release all bus lines
	sta pb
	jmp idle
;
;
;
atnlow	jmp atnsrv
;
;
; tstatn()
; [
;  if(atnmod)
;  [
;   if(pb & $80) atns20();
;   else return ;
;  ]
;  else
;  [
;   if(pb&$80) return;
;   else atnsrv();
;  ]
; ]
;
;
tstatn	lda atnmod      ; test if in atn mode
	beq tsta50      ; no
;
	lda pb          ; in atnmod
	bpl tatn20      ; atn gone,do what we are told to do
tstrtn	rts             ; still in atn  mode
;
tsta50	lda pb          ; not atnmode
	bpl tstrtn      ; no atn present
;
	jmp atnsrv      ; do atn command
;
tatn20	jmp atns20
;
;
;
