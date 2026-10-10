; GnG AGA slave
	INCDIR	Include:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i

;CHIP_ONLY


CHIPSIZE = $200000
	IFD	DEV_MODE
EXPMEM = $800000
SAVEGAME_SIZE = $2800    ; size needed for savegame code, not save game data itself
	ELSE
EXPMEM = $200000
SAVEGAME_SIZE = $0
	ENDC

SAVEGAME_FILE_SIZE = $6000

; lowest chip possible. CD32 version must fit in $1E0000 bytes
; including stack, which is very close. Why wasting precious kbs?
BASE_CHIP = $200

START_CHIP = BASE_CHIP+SAVEGAME_SIZE


_base	SLAVE_HEADER					; ws_security + ws_id
	dc.w	17					; ws_version (was 10)
	dc.w	WHDLF_NoError|WHDLF_ReqAGA|WHDLF_Req68020
	dc.l	CHIPSIZE
	dc.l	0					; ws_execinstall
	dc.w	start-_base		; ws_gameloader
	dc.w	_data-_base					; ws_currentdir
	dc.w	0					; ws_dontcache
_keydebug
	dc.b	$0					; ws_keydebug
_keyexit
	dc.b	$59					; ws_keyexit
_expmem
	dc.l	EXPMEM					; ws_expmem
	dc.w	_name-_base				; ws_name
	dc.w	_copy-_base				; ws_copy
	dc.w	_info-_base				; ws_info
    dc.w    0     ; kickstart name
    dc.l    $0         ; kicksize
    dc.w    $0         ; kickcrc
    dc.w    _config-_base
;---
_config
	dc.b	"C1:X:invincible:0;"
	dc.b	"C1:X:infinite lives:1;"
	dc.b	"C1:X:infinite time:2;"
	dc.b	"C1:X:cheat keys:4;"
	dc.b	"C2:X:50 Hz update:0;"
	*dc.b	"C2:X:no level music:2;"
	*dc.b	"C2:X:use up for jump:4;"
	*dc.b	"C2:X:startup menu:5;"

	dc.b	"C3:L:difficulty level:easy,normal,difficult,very difficult;"
	dc.b	"C4:L:lives:3,4,5,7;"
	dc.b	"C5:L:start level:graveyard,town,cave,bridge,tower 1,tower 2,boss;"
	dc.b	0

	IFD BARFLY
	DOSCMD	"WDate  >T:date"
	ENDC


DECL_VERSION:MACRO
	dc.b	"1.0"
	IFD BARFLY
		dc.b	" "
		INCBIN	"T:date"
	ENDC
	IFD	DATETIME
		dc.b	" "
		incbin	datetime
	ENDC
	ENDM
_data   dc.b    "data",0
_name	dc.b	"Rolling Thunder (arcade)"
	IFD	CD32_SLAVE
	dc.b	" (CD32)"
	ENDC
	dc.b	0
_copy	dc.b	'2026 JOTD',0
_info
    ;dc.b    "Music by no9",10
    dc.b    "Original 1986 Namco",0
	dc.b	0
_kickname   dc.b    0
;--- version id

    dc.b	0
    even

start:
	LEA	_resload(PC),A1
	MOVE.L	A0,(A1)
	move.l	a0,a2
    
    IFEQ EXPMEM
    lea  _expmem(pc),a0
    move.l  #START_CHIP,(a0)
    ENDC
    lea progstart(pc),a0
    move.l  _expmem(pc),(a0)

	lea	exe(pc),a0
	move.l  progstart(pc),a1
	jsr	(resload_LoadFileDecrunch,a2)
	move.l  progstart(pc),a0
    bsr   _Relocate
	lea		_resload(pc),a0		; note: address of pointer on resload+_savegame_func+_loadgame_func
	IFD	DEV_MODE
	lea	loadgame(pc),a1
	move.l	a1,(4,a0)
	lea	savegame(pc),a1
	move.l	a1,(8,a0)
	ENDC
    move.l  #'WHDL',d0
    move.b  _keyexit(pc),d1
	move.l  progstart(pc),-(a7)
    
    lea  _custom,a1
    move.w  #$1200,bplcon0(a1)
    move.w  #$0024,bplcon2(a1)
    rts
	
_Relocate	movem.l	d0-d1/a0-a2,-(sp)
        clr.l   -(a7)                   ;TAG_DONE
;        pea     -1                      ;true
;        pea     WHDLTAG_LOADSEG
		IFNE		EXPMEM
        move.l  #START_CHIP,-(a7)       ;chip area
        pea     WHDLTAG_CHIPPTR        
        pea     8                       ;8 byte alignment
        pea     WHDLTAG_ALIGN
		ENDC
        move.l  a7,a1                   ;tags	
		move.l	_resload(pc),a2
		jsr	resload_Relocate(a2)
		IFNE		EXPMEM
        add.w   #5*4,a7
		ELSE
		addq.w	#4,a7
		ENDC
		
        movem.l	(sp)+,d0-d1/a0-a2
		rts

	IFD	DEV_MODE
; < A0: game RAM
loadgame
    movem.l a0/a2,-(a7)
	move.l	#SAVEGAME_FILE_SIZE,d0	; size of RAM
	lea	BASE_CHIP,a1
	bsr	_sg_load
    movem.l (a7)+,a0/a2
	; D0 success
	rts
; < A0: game ram
savegame
    movem.l a2,-(a7)
;	move.l	trainer(PC),d0
;	bne.s	.skip		;no save on trainer
	lea	BASE_CHIP,a1
	move.l	#SAVEGAME_FILE_SIZE,d0	; size of RAM
	bsr	_sg_save
.skip
    movem.l (a7)+,a2
	rts
	ENDC
_exit:
	pea	TDREASON_OK
	move.l	_resload(pc),-(a7)
	addq.l	#resload_Abort,(a7)
	rts
_resload:
	dc.l	0	; resload
	dc.l	0	; load game function
	dc.l	0	; save game function
progstart
    dc.l    0
exe
	IFD	CD32_SLAVE
	dc.b	"GhostsNGoblins_cd32",0
	ELSE
	dc.b	"RollingThunder_AGA",0
	ENDC
	IFD	DEV_MODE

	even
	include	savegame.s
	ENDC