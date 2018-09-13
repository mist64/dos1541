;**********************************************
;*                                            *
;*   commodore business machines software     *
;*                                            *
;**********************************************
;
;**********************************************
;*                                            *
;*   disk operating system and                *
;*   controller routines                      *
;*   for the following cbm models:            *
;*     vs170 serial disk                      *
;*     with single sa390 drive                *
;*     released as:                           *
;*       901636-01 $c000-$dfff                *
;*       904637-01 $e000-$ffff                *
;*   copyright (c) 1981 by                    *
;*   commodore business machines (cbm)        *
;*                                            *
;**********************************************
; ****listing date --10:00 06 may    1981 ****
;**********************************************
;*   this software is furnished for use in    *
;*  the single drive floppy disk unit only.   *
;*                                            *
;*   copies thereof may not be provided or    *
;*  made available for use on any other       *
;*  system.                                   *
;*                                            *
;*   the information in this document is      *
;*  subject to change without notice.         *
;*                                            *
;*   no responsibility is assumed for         *
;*  reliability of this software. rsr         *
;*                                            *
;**********************************************
; common area defines
.segment "S0000" : zeropage
jobs	.res 6          ; job que
hdrs	.res 12         ; job headers
dskid	.res 4          ;master copy of disk id
header	.res 5          ;image of last header
actjob	.res 1          ;controller's active job
wpsw	.res 2          ;write protect change flag
lwpt	.res 2          ;last state of wp switch
;
;
; rsr
