;permanent address variables
;
;
vnmi	.res 2          ;indirect for nmi
nmiflg	.res 1
autofg	.res 1
secinc	.res 1          ;sector inc for seq
revcnt	.res 1          ; error recovery count
;bufs	= $300          ; start of data bufs
fbufs	= bufs          ;format download image
;*
;*********************************
;*
;*      zero page variables
;*
;*********************************
;*
usrjmp	.res 2          ; user jmp table ptr
bmpnt	.res 2          ; bit map pointer
temp	.res 6          ; temp work space
ip	.res 2          ; indirect ptr variable
lsnadr	.res 1          ; listen address
tlkadr	.res 1          ;talker address
lsnact	.res 1          ; active listener flag
tlkact	.res 1          ; active talker flag
adrsed	.res 1          ; addressed flag
atnpnd	.res 1          ;attention pending flag
atnmod	.res 1          ;in atn mode
prgtrk	.res 1          ;last prog accessed
drvnum	.res 1          ;current drive #
track	.res 1          ;current track
sector	.res 1          ;current sector
lindx	.res 1          ;logical index
sa	.res 1          ;secondary address
orgsa	.res 1          ;original sa
data	.res 1          ; temp data byte
;*
;*
t0	=temp
t1	=temp+1
t2	=temp+2
t3	=temp+3
t4	=temp+4
r0	.res 1
r1	.res 1
r2	.res 1
r3	.res 1
r4	.res 1
result	.res 4
accum	.res 5
dirbuf	.res 2
icmd	.res 1          ;ieee cmd in
mypa	.res 1          ; my pa flag
cont	.res 1          ; bit counter for ser
;*
;*********************
;*
;*  zero page array
;*
;***********************
;*
buftab	.res cbptr+4    ; buffer byte pointers
cb=buftab+cbptr
buf0	.res mxchns+1
buf1	.res mxchns+1
nbkl
recl	.res mxchns
nbkh
rech	.res mxchns
nr	.res mxchns
rs	.res mxchns
ss	.res mxchns
f1ptr	.res 1          ; file stream 1 pointer
;
;***********************
; $4300 vars moved to zp
;
recptr	.res 1
ssnum	.res 1
ssind	.res 1
relptr	.res 1
entsec	.res mxfils     ; sector of directory entry
entind	.res mxfils     ; index of directory entry
fildrv	.res mxfils     ; default flag, drive #
pattyp	.res mxfils     ; pattern,replace,closed-flags,type
filtyp	.res mxchns     ; channel file type
chnrdy	.res mxchns     ; channel status
eoiflg	.res 1          ; temp eoi
jobnum	.res 1          ; current job #
lrutbl	.res mxchns-1   ;least recently used table
nodrv	.res 2          ; no drive flag
;XXXdskver	.res 2          ; disk version from 18.0
dskver=$101
zpend=*
.segment "S0200"
cmdbuf	.res cmdlen+1
cmdnum	.res 1          ; command #
lintab	.res maxsa+1    ; sa:lindx table
chndat	.res mxchns     ; channel data byte
lstchr	.res mxchns     ; channel last char ptr
type	.res 1          ; active file type
;
;*
;*******************
;*
;* ram variables in $4300
;*
;*******************
;*
;  *=$4300
strsiz	.res 1
;zp:  recptr .res 1
;zp:  ssnum  .res 1
;zp:  ssind  .res 1
;zp:  relptr .res 1
tempsa	.res 1          ; temporary sa
;zp:  eoiflg .res 1          ; temp eoi
cmd	.res 1          ; temp job command
lstsec	.res 1          ;
bufuse	.res 2          ; buffer allocation
;zp:  jobnum .res 1          ; current job #
mdirty	.res 2          ;bam 0 & 1 dirty flags
entfnd	.res 1          ;dir-entry found flag
dirlst	.res 1          ;dir listing flag
cmdwat	.res 1          ;command waiting flag
linuse	.res 1          ;lindx use word
lbused	.res 1          ;last buffer used
rec	.res 1
trkss	.res 1
secss	.res 1
;*
;********************************
;*
;*  ram array area
;*
;********************************
;*
lstjob	.res bfcnt      ; last job
;zp:  lintab .res maxsa+1    ; sa:lindx table
;zp:  chndat .res mxchns     ; channel data byte
dsec	.res mxchns     ; sector of directory entry
dind	.res mxchns     ; index of directory entry
erword	.res 1          ; error word for recovery
erled	.res 1          ; error led mask for flashing
prgdrv	.res 1          ; last program drive
prgsec	.res 1          ; last program sector
wlindx	.res 1          ; write lindx
rlindx	.res 1          ; read lindx
nbtemp	.res 2          ; # blocks temp
cmdsiz	.res 1          ; command string size
char	.res 1          ; char under parser
limit	.res 1          ; ptr limit in compar
f1cnt	.res 1          ; file stream 1 count
f2cnt	.res 1          ; file stream 2 count
f2ptr	.res 1          ; file stream 2 pointer
;  parser tables
filtbl	.res mxfils+1   ; filename pointer
;zp:   filent .res mxfils     ; directory entry
;zp:   fildat .res mxfils     ; drive #, pattern
filtrk	.res mxfils     ; 1st link/track
filsec	.res mxfils     ;         /sector
;  channel tables
;zp:  filtyp .res mxchns; channel file type
;zp:  chnrdy .res mxchns     ; channel status
;zp:   lstchr .res mxchns     ; channel last char ptr
patflg	.res 1          ; pattern presence flag
image	.res 1          ; file stream image
drvcnt	.res 1          ; number of drv searches
drvflg	.res 1          ; drive search flag
lstdrv	.res 1          ; last drive w/o error
found	.res 1          ; found flag in dir searches
dirsec	.res 1          ; directory sector
delsec	.res 1          ; sector of 1st avail entry
delind	.res 1          ; index  "
lstbuf	.res 1          ; =0 if last block
index	.res 1          ; current index in buffer
filcnt	.res 1          ; counter, file entries
typflg	.res 1          ; match by type flag
mode	.res 1          ; active file mode (r,w)
;zp:  type   .res 1          ; active file type
jobrtn	.res 1          ;job return flag
eptr	.res 1          ;ptr for recovery
toff	.res 1          ;total track offset
ubam	.res 2          ; last bam update ptr
tbam	.res 4          ; track # of bam image
bam	.res 16         ; bam images
;*
;*****************************************
;*
;*   output buffers
;*
;********************************************
;*
;    *=$4400-36-36
nambuf	.res 36         ; directory buffer
errbuf	.res 36         ; error msg buffer
wbam	.res 1          ; don't-write-bam flag
ndbl	.res 2          ; # of disk blocks free
ndbh	.res 2
phase	.res 2
ramend=*
