.page 'block command'
;  rom 1.1 additions
; user commands
.skip
user	ldy cmdbuf+1
	cpy #'0
	bne us10        ;0 resets pntr
.skip
usrint	lda #<ublock    ;set default block add
	sta usrjmp
	lda #>ublock
	sta usrjmp+1
	rts
.skip
us10	jsr usrexc      ;execute code by table
	jmp endcmd
.skip
usrexc	dey             ;entry is(((index-1)and$f)*2)
	tya
	and #$f
	asl a
	tay
	lda (usrjmp)y
	sta ip
	iny
	lda (usrjmp)y
	sta ip+1
	jmp (ip)
.page 'block commands'
; open direct access buffer
;  from open "#"
.skip
opnblk	lda lstdrv
	sta drvnum
	lda sa          ;sa is destroyed by this patch
	pha
	jsr autoi       ;init disk for proper channel assignment
	pla             ;restore sa
	sta sa
	ldx cmdsiz
	dex
	bne ob10
.ski
	lda #1          ;get any buffer
	jsr getrch
	jmp ob30
.skip
ob05	lda #nochnl
	jmp cmderr
.skip
ob10	ldy #1          ;buffer # is requested
	jsr bp05
	ldx filsec
	cpx #bfcnt      ;must be less than 13.
	bcs ob05
.ski
	lda #0
	sta temp
	sta temp+1
	sec
.ski
ob15
	rol temp
	rol temp+1
	dex
	bpl ob15
.ski
	lda temp
	and bufuse
	bne ob05        ;buffer is used
	lda temp+1
	and bufuse+1
	bne ob05        ;buf is used
.ski
	lda temp
	ora bufuse      ;set buffer as used
	sta bufuse
	lda temp+1
	ora bufuse+1
	sta bufuse+1
.ski
	lda #0          ;set up channel
	jsr getrch
	ldx lindx
	lda filsec
	sta buf0,x
	tax
	lda drvnum
	sta jobs,x
	sta lstjob,x
.ski
ob30	ldx sa
	lda lintab,x    ;set lindx table
	ora #$40
	sta lintab,x
.ski
	ldy lindx
	lda #$ff
	sta lstchr,y
.skip
	lda #rndrdy
	sta chnrdy,y    ;set channel ready
.skip
	lda buf0,y
	sta chndat,y    ;buffer # as 1st char
	asl a
	tax
	lda #1
	sta buftab,x
	lda #dirtyp+dirtyp
	sta filtyp,y    ;set direct file type
	jmp endcmd
.page
; block commands
block	ldy #0
	ldx #0
	lda #'-         ;"-" separates cmd from subcmd
	jsr parse       ;locate sub-cmd
	bne blk40
.ski
blk10	lda #badcmd
	jmp cmderr
.ski
blk30	lda #badsyn
	jmp cmderr
.ski
blk40	txa
	bne blk30
.ski
	ldx #nbcmds-1   ;find command
	lda cmdbuf,y
blk50	cmp bctab,x
	beq blk60
	dex
	bpl blk50
	bmi blk10
.ski
blk60
	txa
	ora #$80
	sta cmdnum
	jsr blkpar      ;parse parms
.ski
	lda cmdnum
	asl a
	tax
	lda bcjmp+1,x
	sta temp+1
	lda bcjmp,x
	sta temp
.ski
	jmp (temp)      ;goto command
.ski
bctab	.byt 'afrwep'
nbcmds	=*-bctab
.skip
bcjmp	.word blkalc    ;block-allocate
	.word blkfre    ;block-free
	.word blkrd     ;block-read
	.word blkwt     ;block-write
	.word blkexc    ;block-execute
	.word blkptr    ;block-pointer
.skip
blkpar	ldy #0          ;parse block parms
	ldx #0
	lda #':
	jsr parse
	bne bp05        ;found ":"
.skip
	ldy #3          ;else char #3 is beginning
bp05	lda cmdbuf,y
	cmp #' 
	beq bp10
.ski
	cmp #29         ;skip character
	beq bp10
.ski
	cmp #',
	bne bp20
.skip
bp10	iny
	cpy cmdsiz
	bcc bp05
.skip
	rts             ;that's all
.skip
bp20	jsr aschex
	inc f1cnt
	ldy f2ptr
	cpx #mxfils-1
	bcc bp10
.skip
	bcs blk30       ;bad syntax
.skip
; convert ascii to hex (binary)
;  & store conversion in tables
;  .y= ptr into cmdbuf
aschex	lda #0
	sta temp
	sta temp+1
	sta temp+3
.skip
	ldx #$ff
ah10	lda cmdbuf,y    ;test for dec #
	cmp #$40
	bcs ah20        ;non-numeric terminates
	cmp #$30
	bcc ah20        ;non-numeric
.skip
	and #$f
	pha
	lda temp+1      ;shift digits (*10)
	sta temp+2
	lda temp
	sta temp+1
	pla
	sta temp
	iny
	cpy cmdsiz
	bcc ah10        ;still in string
.skip
ah20	sty f2ptr       ;convert digits to...
	clc             ;...binary by dec table
	lda #0
.skip
ah30	inx
	cpx #3
	bcs ah40
.skip
	ldy temp,x
ah35	dey
	bmi ah30
.skip
	adc dectab,x
	bcc ah35
.skip
	clc
	inc temp+3
	bne ah35
.skip
ah40	pha
	ldx f1cnt
	lda temp+3
	sta filtrk,x    ;store result in table
	pla
	sta filsec,x
	rts
.skip
dectab	.byt 1,10,100   ;decimal table
.skip
;block-free
blkfre	jsr blktst
	jsr frets
	jmp endcmd
.skip
;block-allocate
	lda #1
	sta wbam
blkalc
	jsr blktst
.skip
ba10
	lda sector
	pha
	jsr getsec
	beq ba15        ;none greater on this track
	pla
	cmp sector
	bne ba30        ;requested sector not avail
	jsr wused
	jmp endcmd
;
ba15
	pla             ;pop stack
ba20
	lda #0
	sta sector
	inc track
	lda track
	cmp maxtrk
	bcs ba40        ;gone all the way
;
	jsr getsec
	beq ba20
ba30
	lda #noblk
	jsr cmder2
ba40
	lda #noblk
	jsr cmderr      ;t=0,s=0 :none left
;
.skip
; block read subs
blkrd2	jsr bkotst      ;test parms
	jmp drtrd
.skip
getsim	jsr getpre      ;get byte w/o inc
	lda (buftab,x)
	rts
.skip
; block read
blkrd3	jsr blkrd2
	lda #0
	jsr setpnt
	jsr getsim      ;y=lindx

.skip
	sta lstchr,y
	lda #rndrdy
	sta chnrdy,y
	rts
blkrd
	jsr blkrd3
	jsr rnget1
	jmp endcmd
.skip
;user direct read, lstchr=$ff
ublkrd
	jsr blkpar
	jsr blkrd3
	lda lstchr,y
	sta chndat,y
	lda #$ff
	sta lstchr,y
	jmp endcmd      ;(rts)
.skip 2
;block-write
blkwt	jsr bkotst
.skip
	jsr getpnt
	tay
	dey
	cmp #2
	bcs bw10
	ldy #1
.skip
bw10	lda #0          ;set record size
	jsr setpnt
	tya
	jsr putbyt
	txa
	pha
.skip
bw20	jsr drtwrt      ;write block
	pla
	tax
	jsr rnget2
	jmp endcmd
.skip
;user dirct write, no lstchr
ublkwt	jsr blkpar
	jsr bkotst
	jsr drtwrt
	jmp endcmd
.skip
;in .file vector:
;*=$fffa-6 ;user direct access
;ublock .word ublkrd
;       .word ublkwt
.skip 2
;block-execute
blkexc
	jsr killp       ;kill protect
	jsr blkrd2      ;read block & execute
	lda #0
.skip
be05	sta temp
	ldx jobnum
	lda bufind,x
	sta temp+1
	jsr be10        ;indirect jsr
	jmp endcmd
.skip
be10	jmp (temp)
.skip 2
;buffer-pointer, set buffer pointer 
blkptr	jsr buftst
	lda jobnum
	asl a
	tax
	lda filsec+1
	sta buftab,x
	jsr getpre
	jsr rnget2      ;set up get
	jmp endcmd
.skip
;test for allocated buffer..
;  ..related to sa
buftst	ldx f1ptr
	inc f1ptr
	lda filsec,x
	tay
	dey
	dey
	cpy #$c         ; set limit to # of sas
	bcc bt20
.skip
bt15	lda #nochnl
	jmp cmderr
.skip
bt20	sta sa
	jsr fndrch
	bcs bt15
	jsr getact
	sta jobnum
	rts
.skip
;test block operation parms
bkotst	jsr buftst
;
;test for legal block &..
;  ..set up drv, trk, sec
blktst	ldx f1ptr
	lda filsec,x
	and #1
	sta drvnum
	lda filsec+2,x
	sta sector
	lda filsec+1,x
	sta track
bt05
	jsr tschk
	jmp setlds      ;(rts)
.skip
.end
; rsr 1/19/80 add autoi to #cmd
