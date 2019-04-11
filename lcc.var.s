;
drvst	.res 2
drvtrk	.res 2
stab	.res 10
;    variables
;
; pointers
savpnt	.res 2
bufpnt	.res 2
hdrpnt	.res 2
;
;
gcrpnt	.res 1
gcrerr	.res 1          ; indicates gcr decode error
bytcnt	.res 1
bitcnt	.res 1
bid	.res 1
hbid	.res 1
chksum	.res 1
hinib	.res 1
byte	.res 1
drive	.res 1
cdrive	.res 1
jobn	.res 1
tracc	.res 1
nxtjob	.res 1
nxtrk	.res 1
sectr	.res 1
work	.res 1
job	.res 1
ctrack	.res 1
dbid	.res 1          ; data block id
acltim	.res 1          ; acel time delay
savsp	.res 1          ; save stack pointer
steps	.res 1          ; steps to desired track
tmp	.res 1
csect	.res 1
nexts	.res 1
nxtbf	.res 1          ; pointer at next gcr source buffer
nxtpnt	.res 1          ; and next gcr byte location in buffer
gcrflg	.res 1          ; buffer in gcr image
ftnum	.res 1          ; current format track
btab	.res 4
gtab	.res 8
;
as	.res 1          ; # of steps to acel
af	.res 1          ; acel. factor
aclstp	.res 1          ; steps to go
rsteps	.res 1          ; # of run steps
nxtst	.res 2
minstp	.res 1          ; min reqired to acel
;
;
;
;  constants
;
ovrbuf	=$0100          ; top of stack
numjob	=6 ; number of jobs
jmpc	=$50            ; jump command
bumpc	=$40            ; bump command
execd	=$60            ; execute command
bufs	=$0300          ; start of buffers
buff0	=bufs
buff1	=bufs+$100
buff2	=bufs+$200
tolong	=$2             ; format errors
tomany	=$3
tobig	=$4
tosmal	=$5
notfnd	=$6
skip2	=$2c            ; bit abs
toprd	=69             ; top of read overflo buffer on a read
topwrt	=69             ; top of write overflo buffer on a write
numsyn	= 5             ; gcr byte count for size of sync area
gap1	= 11            ; gap after header to  clear erase in gcr bytes
gap2	= 2             ; gap after data block min size
rdmax	= 6             ; sector distance wait
wrtmin	= 9
wrtmax	= 12
tim	=58             ;irq rate for 15ms
;
;
;
;
;
;
