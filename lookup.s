.page 'lookup-optsch'
;optsch  optimal search for lookup
;  and fndfil
.skip
optsch	lda #0          ;determine optimal search
	sta temp        ;init drive mask
	sta drvflg
	pha
	ldx f2cnt
os10	pla
	ora temp
	pha
	lda #1
	sta temp
	dex
	bmi os30
	lda fildrv,x
	bpl os15
	asl temp
	asl temp
.skip
os15	lsr a
	bcc os10
	asl temp
	bne os10        ;(branch)
.skip
os30	pla
	tax
	lda schtbl-1,x
	pha
	and #3
	sta drvcnt
	pla
	asl a
	bpl os40
	lda fildrv
os35	and #1
	sta drvnum
;
	lda drvcnt
	beq os60        ;only one drive addressed
;
	jsr autoi       ;check drive for autoinit
	beq os50        ;drive is active
;
	jsr togdrv
	lda #0          ;set 1 drive addressed
	sta drvcnt
	jsr autoi       ;check drive for autoinit
	beq os70        ;drive is active
os45
	lda #nodriv
	jsr cmderr
os50
	jsr togdrv
	jsr autoi       ;check drive for autoinit
	php
	jsr togdrv
	plp
	beq os70        ;drive is active
;
	lda #0          ;set 1 drive addressed
	sta drvcnt
	beq os70        ;bra
os60
	jsr autoi       ;check drive for autoinit
	bne os45        ;drive is not active
os70
	jmp setlds
.skip
os40	rol a
	jmp os35
.skip
schtbl	.byt 0,$80,$41
	.byt 1,1,1,1
	.byt $81,$81,$81,$81
	.byt $42,$42,$42,$42
.page 'lookup/fndfil'
; look up all files in stream
;   and fill tables w/ info
.skip
lookup	jsr optsch
lk05	lda #0
	sta delind
	jsr srchst      ;start search
	bne lk25
lk10	dec drvcnt
	bpl lk15
	rts             ;no more drive searches
lk15	lda #1          ;toggle drive #
	sta drvflg
	jsr togdrv
	jsr setlds      ; turn on led
	jmp lk05
lk20	jsr search      ;find valid fn
	beq lk30        ;end of search
lk25	jsr compar      ;compare dir w/ table
	lda found       ;found flag
	beq lk26        ;all fn's not found, yet
	rts
.skip
lk26	lda entfnd
	bmi lk20
	bpl lk25
.skip
lk30	lda found
	beq lk10
	rts
.skip 2
; find next file name matching
;  any file in stream & return
;  with entry found stuffed into
;  tables
ffre	jsr srre        ;find file re-entry
	beq ff10
	bne ff25
.skip
ff15	lda #1
	sta drvflg
	jsr togdrv
	jsr setlds
.skip
ffst	lda #0          ;find file start entry
	sta delind
	jsr srchst
	bne ff25
	sta found
ff10	lda found
	bne ff40
	dec drvcnt
	bpl ff15
	rts
.skip
fndfil	jsr search      ;find file continuous...
	beq ff10        ;... re-entry, no channel activity
ff25	jsr compar      ;compare file names
	ldx entfnd
	bpl ff30
	lda found
	beq fndfil
	bne ff40
.skip
ff30	lda typflg
	beq ff40        ;no type restriction
	lda pattyp,x
	and #typmsk
	cmp typflg
	bne fndfil
ff40	rts
.page 'lookup-compar'
;compare all filenames in stream table
;  with each valid entry in the 
;  directory.  matches are tabulated
.skip
compar	ldx #$ff
	stx entfnd
	inx
	stx patflg
	jsr cmpchk
	beq cp10
cp02	rts             ;all are found
.skip
cp05	jsr cc10
	bne cp02
cp10	lda drvnum
	eor fildrv,x
	lsr a
	bcc cp20        ;right drive
	and #$40
	beq cp05        ;no default
	lda #2
	cmp drvcnt
	beq cp05        ;don't use default
.skip
cp20	lda filtbl,x    ;good drive match
	tax
	jsr fndlmt
	ldy #3
	jmp cp33
cp30
	lda cmdbuf,x
	cmp (dirbuf)y
	beq cp32        ;chars are =
;
	cmp #'?
	bne cp05        ;no single pattern
	lda (dirbuf)y
	cmp #$a0
	beq cp05        ;end of filename
cp32
	inx
	iny
cp33
	cpx limit
	bcs cp34        ;end of pattern
;
	lda cmdbuf,x
	cmp #'*
	beq cp40        ;star matches all
	bne cp30        ;keep checking
cp34
	cpy #19
	bcs cp40        ;end of filename
;
	lda (dirbuf)y
	cmp #$a0
	bne cp05
.skip
cp40	ldx f2ptr       ;filenames match
	stx entfnd
	lda pattyp,x    ;store info in tables
	and #$80
	sta patflg
	lda index
	sta entind,x
	lda sector
	sta entsec,x
	ldy #0
	lda (dirbuf),y
	iny
	pha
	and #$40
	sta temp
	pla
	and #$ff-$20
	bmi cp42
;
	ora #$20
cp42
	and #$27
	ora temp
	sta temp
	lda #$80
	and pattyp,x
	ora temp
	sta pattyp,x
	lda fildrv,x
	and #$80
	ora drvnum
	sta fildrv,x
;
	lda (dirbuf),y
	sta filtrk,x
	iny
	lda (dirbuf),y
	sta filsec,x
	lda rec
	bne cp50
	ldy #21
	lda (dirbuf)y
	sta rec
cp50
;jmp cmpchk
;rts
.skip
;check table for unfound files
.skip
cmpchk	lda #$ff
	sta found
	lda f2cnt
	sta f2ptr
.skip
cc10	dec f2ptr
	bpl cc15
	rts             ;table exhausted
.skip
cc15	ldx f2ptr
	lda pattyp,x
	bmi cc20
	lda filtrk,x
	bne cc10
cc20	lda #0
	sta found
	rts
.page 'lookup-search'
;search directory 
;  returns with valid entry w/ delind=0
;  or returns w/ 1st deleted entry
;  w/ delind=1 
;
;  srchst will initiate a search
;  search will continue a search
.skip
srchst
	ldy #0          ;init deleted sector
	sty delsec
	dey
	sty entfnd
.skip
	lda dirtrk      ;start search at beginning
	sta track
	lda #1
	sta sector
	sta lstbuf
	jsr opnird      ;open internal read chnl
.skip
sr10	lda lstbuf      ;last buffer if 0
	bne sr15
	rts             ;(z=1)
.skip
sr15	lda #7
	sta filcnt
	lda #0          ;read track #
	jsr drdbyt
	sta lstbuf      ;update end flag
.skip
sr20	jsr getpnt
	dec filcnt
	ldy #0
	lda (dirbuf),y  ;read file type
	bne sr30
.skip
	lda delsec      ;deleted entry found
	bne search      ;deleted entry already found
	jsr curblk      ;get current sector
	lda sector
	sta delsec
.skip
	lda dirbuf      ;get current index
	ldx delind      ;bit1: want deleted entry
	sta delind
	beq search      ;need valid entry
	rts             ;(z=0)
.skip
sr30	ldx #1
	cpx delind      ;?looking for deleted?
	bne sr50        ; no!
	beq search
.skip
srre	lda dirtrk
	sta track
	lda dirsec
	sta sector
	jsr opnird
	lda index
	jsr setpnt
.skip
search	lda #$ff
	sta entfnd
	lda filcnt      ;adjust file count
	bmi sr40
	lda #32         ;incr by 32
	jsr incptr
	jmp sr20
.skip
sr40	jsr nxtbuf      ;new buffer
	jmp sr10        ;(branch)
.skip
sr50	lda dirbuf      ;found valid entry
	sta index       ;save index
	jsr curblk      ;get sector
	lda sector
	sta dirsec
.skip
	rts             ;(z=0)
autoi
;  check drive for active diskette
;  init if needed
;   return nodrv status
;
	lda autofg
	bne auto2       ;auto-init is disabled
;
	ldx drvnum
	lsr wpsw,x      ;test & clear wpsw
	bcc auto2       ;no change in diskette
;
	lda #$ff
	sta jobrtn      ;set error return code
	jsr itrial      ;init-seek test
	ldy #$ff        ; .y= true
	cmp #2
	beq auto1       ;no sync= no diskette
;
	cmp #3
	beq auto1       ;no header= no directory
;
	cmp #$f
	beq auto1       ;no drive!!!!
;
	ldy #0          ;set .y false
auto1
	ldx drvnum
	tya
	sta nodrv,x     ;set condn of no-drive
	bne auto2       ;no need to init crud!
;
	jsr initdr      ;init that drive
auto2
	ldx drvnum
	lda nodrv,x     ;return no-drive condn
	rts
.skip
.end
