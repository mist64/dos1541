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
	*=0
jobs	*=*+6           ; job que
hdrs	*=*+12          ; job headers
dskid	*=*+4           ;master copy of disk id
header	*=*+5           ;image of last header
actjob	*=*+1           ;controller's active job
wpsw	*=*+2           ;write protect change flag
lwpt	*=*+2           ;last state of wp switch
;
;
; rsr
