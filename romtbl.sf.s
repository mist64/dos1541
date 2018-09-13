dirtrk	.byt 18         ;directory track #
bamsiz	.byt 4          ;# bytes/track in bam
mapoff	.byt 4          ;offset of bam in sector
dsknam	.byt $90        ;offset of disk name in bam sector
;
;   command search table
cmdtbl	.byt "vidmbup&crsn"
; validate-dir init-drive duplicate
; memory-op block-op user
; position dskcpy utlodr rename scratch new
ncmds	=*-cmdtbl
;  jump table low
cjumpl	.byt <verdir,<intdrv,<duplct
	.byt <mem,<block,<user
	.byt <record
	.byt <utlodr
	.byt <dskcpy
	.byt <rename,<scrtch,<new
	*=cjumpl+ncmds
;  jump table high
cjumph	.byt >verdir,>intdrv,>duplct
	.byt >mem,>block,>user
	.byt >record
	.byt >utlodr
	.byt >dskcpy
	.byt >rename,>scrtch,>new
	*=cjumph+ncmds
val=0 ;validate (verify) cmd #
; structure images for cmds
pcmd	=9
	.byt %01010001  ; dskcpy
struct	=*-pcmd         ; cmds not parsed
	.byt %11011101  ; rename
	.byt %00011100  ; scratch
	.byt %10011110  ; new
ldcmd	=*-struct       ; load cmd image
	.byt %00011100  ; load
;            --- ---
;            pgdrpgdr
;            fs1 fs2
;   bit reps:  not pattern
;              not greater than one file 
;              not default drive(s) 
;              required filename
modlst	.byt "rwam"     ; mode table
nmodes	=*-modlst
;file type table
tplst	.byt "dspul"
typlst	.byt "dspur"    ;del, seq, prog, user, relative
ntypes	=*-typlst
tp1lst	.byt "eerse"
tp2lst	.byt "lqgrl"
ledmsk	.byt led0,led1
;
; error flag vars for bit
;
er00	.byt 0
er0	.byt $3f
er1	.byt $7f
er2	.byt $bf
er3	.byt $ff
;
numsec	;(4) sectors/track
	.byte 17,18,19,21
vernum	.byt fm4040     ;format type
nzones	.byt 4          ;# of zones
maxtrk	;maximum track #  +1
trknum	;zone boundaries track numbers
	.byte 36,31,25,18
offset	;for recovery
	.byte 1,$ff,$ff,1,0
;
bufind
	.byte $03,$04,$05,$06,$07,$07
;
