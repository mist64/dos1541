;
;
;
;
;     defs for low cost controller
;
;
;     written by glenn stark
;     4/1/80
;
;
;   (c) commodore business machines
;
timer1	=$1805          ; timer 1 counter
;
;
;
;   mos 6522
;   address $1c00
;
.segment "S1C00"
;
dskcnt	.res 1          ; port b
; disk i/o control lines
; bit 0: step in
; bit 1: step out
; bit 2: -motor on
; bit 3: act led
; bit 4: write protect sense
; bit 5: density select 0
; bit 6: density select 1
; bit 7: sync detect
;
;
data2	.res 1          ; port a
; gcr data input and output port
;
ddrb2	.res 1          ; data direction control
ddra2	.res 1          ; data direction control
;
t1lc2	.res 1          ; timer 1 low counter
t1hc2	.res 1          ; timer 1 hi countr
;
t1ll2	.res 1          ; timer 1 low latch
t1hl2	.res 1          ; timer 1 hi latch
;
t2ll2	.res 1          ; timer two low latch
t2lh2	.res 1          ; timer two hi latch
;
sr2	.res 1          ; shift register
;
acr2	.res 1
;
pcr2	.res 1
;
ifr2	.res 1
;
ier2	.res 1
;
;
;
;
;
