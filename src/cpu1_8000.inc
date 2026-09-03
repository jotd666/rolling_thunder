* Converted with 6809to68k v1.12 by JOTD
*
* make sure you call "cpu_init" first so all bits of data registers
* are zeroed out so we can use add.l dy,ax with dy > 0x7FFF
* without systematic masking
*
* WARNING: you also have to call "cpu_init_cpu1"
* at start of any interrupt you could hook
*
* the GET_ADDRESS macro can just call get_address or it can also use
* conditional compilation to select the proper memory banks at compile time
* (see my burger time 6502 conversion which does that in RELEASE mode)

	.include 	"cpu1_options.inc"
	.ifdef	__amiga__
	* to define BREAKPOINT
	.include 	"amiga/utility_macros.inc"
	.else
	.macro	BREAKPOINT	arg
	.endm
	.endif


	.macro	ERROR	arg
	.error	"\arg"     | comment out or replace by ".warning" to disable errors
	.endm

	.macro	VIDEO_BYTE_DIRTY
	| called when a byte write was done in a0
	jbsr	osd_video_byte_dirty_cpu1
	.endm

	.macro	VIDEO_WORD_DIRTY
	| called when a word write was done in a0
	jbsr	osd_video_word_dirty_cpu1
	.endm

* the function that accesses all memory (except banks)
* without any check
	.macro	GET_UNCHECKED_ADDRESS_FUNC
	lea	(a6,a0.l),a0
	.endm

	.ifdef	RELEASE
	* release mode: don't check
	.macro	GET_ADDRESS_FUNC
	GET_UNCHECKED_ADDRESS_FUNC
	.endm
	.macro	GET_BANK_ADDRESS_FUNC
	GET_UNCHECKED_BANK_ADDRESS_FUNC
	.endm

	.else
	* debug mode, using a function
	.macro	GET_ADDRESS_FUNC
	jbsr	get_address
	.endm
	.macro	GET_BANK_ADDRESS_FUNC
	jbsr	get_bank_address
	.endm
	.endif

	.macro	ABX
	PUSH_SR
	moveq	#0,d6
	move.b	d1,d6
	add.w	d6,d2
	POP_SR
	.endm

	.macro	ABA
	add.b	d1,d0
	.endm

	.macro	TBA
	move.b	d1,d0
	.endm

	.macro	CHECK_MAX	reg,arg
	.ifndef	RELEASE
	cmp.b	#\arg*2,\reg
	jcs		okay\@
	BREAKPOINT	"\reg exceeds \arg*2"
okay\@:
	.endif
	.endm

	.macro	COM	reg
	not.b	\reg
	SET_XC_FLAGS
	.endm

	.macro	SEX
	ext.w	d1
	MAKE_A
	.endm

	.macro	MAKE_D
* add value of A in B MSB so D&0xFF == B
	rol.w	#8,d1
	move.b	d0,d1
	rol.w	#8,d1
	.endm

	.macro	MAKE_A
	rol.w	#8,d1
	move.b	d1,d0
	rol.w	#8,d1
	.endm

	.macro	BIT	reg,arg
	move.b	\reg,d6
	and.b	\arg,d6
	.endm


	.macro	LOAD_D
	move.b	(a0),d0
	move.b	(1,a0),d1
	MAKE_D
	.endm

	.macro CLR_XC_FLAGS
	and.b	#0xEE,ccr	| bit 4 = X, bit 0 = C
	.endm

	.macro SET_XC_FLAGS
	or.b	#0x11,ccr	| bit 4 = X, bit 0 = C
	.endm



	.macro INVERT_XC_FLAGS
	eor.b	#0x11,ccr
	.endm

* useful to recall C from X (add then move then bcx)
	.macro	SET_C_FROM_X
	PUSH_SR
	move.w	(sp),d6
	bset	#0,d6   | set C
	btst	#4,d6
	jne	0f
	bclr	#0,d6   | X is clear: clear C
0:
	move.w	d6,(sp)
	POP_SR
	.endm

* useful to store X from C (store cmp result)
	.macro	SET_X_FROM_C
	PUSH_SR
	move.w	(sp),d6
	bset	#4,d6   | set X
	btst	#0,d6
	bne.b	0f
	bclr	#4,d6   | C is clear: clear X
0:
	move.w	d6,(sp)
	POP_SR
	.endm

	.macro	SET_X_FROM_CLEARED_C
	PUSH_SR
	move.w	(sp),d6
	bset	#4,d6   | set X
	btst	#0,d6
	jeq	0f
	bclr	#4,d6   | C is set: clear X
0:
	move.w	d6,(sp)
	POP_SR
	.endm


	.macro SET_I_FLAG
	moveq	#0,d7
	jbsr	osd_disable_interrupts
	.endm
	.macro CLR_I_FLAG
	moveq	#0,d7
	jbsr	osd_enable_interrupts
	.endm

	.ifdef	MC68020


* 68020 compliant & optimized

    .macro    JXX_X_INDEXED    inst,reg,nb_cases,ab
    moveq    #0,d6
    move.b    \ab,d6  | mask 8 bits
    CHECK_MAX    d6,\nb_cases
    \inst    ([\reg,d6.W*2])
    .endm


	.macro DO_EXTB	reg
	extb.l	\reg
	.endm

	.macro PUSH_SR
	move.w	ccr,-(sp)
	.endm

	.macro    INST_W_TO_REG    inst,src,dest
	\inst\().w    (\src),\dest
	.endm


	.macro	MOVE_W_FROM_REG    src,dest
	move.w	\src,(\dest)
	.endm

	.macro	MOVE_W_FROM_REG_PREDEC	src,dest
	move.w	\src,-(\dest)
	.endm

	.macro	MOVE_W_TO_REG_POSTINC	src,dest
	move.w	(\src)+,\dest
	.endm


	.macro READ_BE_WORD	srcreg
	moveq	#0,d6
	move.w	(\srcreg),d6
	move.l	d6,\srcreg
	.endm

	.else

* 68000 compliant

   .macro    JXX_X_INDEXED    inst,reg,nb_cases,ab
    moveq    #0,d6   | scratch register
    move.b   \ab,d6  | mask 8 bits
    CHECK_MAX    d6,\nb_cases
    * original register is not changed (could cause issues)
    add.w    d6,d6    | *2 (16 -> 32 bits)
    move.l    (\reg,d6.w),\reg
    \inst    (\reg)
    .endm



	.macro DO_EXTB	reg
	ext	\reg
	ext.l	\reg
	.endm

	.macro PUSH_SR
	move.w	sr,-(sp)
	.endm



	.macro	MOVE_W_FROM_REG    src,dest
	ror.w	#8,\src
	move.b	\src,(\dest)
	ror.w	#8,\src
	move.b	\src,(1,\dest)
	tst.w	\src
	.endm

	.macro	MOVE_W_FROM_REG_PREDEC	src,dest
	subq	#2,\dest
	MOVE_W_FROM_REG	\src,\dest
	.endm

    .macro    INST_W_TO_REG    inst,src,dest
    move.b    (\src),d6
    ror.w    #8,d6
    move.b    (1,\src),d6
    \inst\().w    d6,\dest
    .endm

	.macro	MOVE_W_TO_REG_POSTINC	src,dest
	MOVE_W_TO_REG	\src,\dest
	addq.w	#2,\dest
	.endm


	.macro READ_BE_WORD	srcreg
	moveq	#0,d6
	move.b	(\srcreg),d6
	lsl.w	#8,d6
	move.b	(1,\srcreg),d6
	move.l	d6,\srcreg
	.endm

	.endif

* same for 68000 and 68020+
	.macro POP_SR
	move.w	(sp)+,ccr
	.endm

    .macro    MOVE_W_TO_REG    src,dest
    INST_W_TO_REG   move,\src,\dest
    .endm


    .macro    SUB_W_TO_REG    src,dest
    INST_W_TO_REG   sub,\src,\dest
    .endm

    .macro    ADD_W_TO_REG    src,dest
    INST_W_TO_REG   add,\src,\dest
    .endm

    .macro    CMP_W_TO_REG    src,dest
    INST_W_TO_REG   cmp,\src,\dest
    .endm

    .macro    JXX_A_INDEXED    inst,reg,nb_cases
    JXX_X_INDEXED    \inst,\reg,\nb_cases,d0
    .endm

    .macro    JXX_B_INDEXED    inst,reg,nb_cases
    JXX_X_INDEXED    \inst,\reg,\nb_cases,d1
    .endm

    .macro    JSR_A_INDEXED    reg,nb_cases
    JXX_A_INDEXED	jsr,\reg,\nb_cases
    .endm
    .macro    JMP_A_INDEXED    reg,nb_cases
    JXX_A_INDEXED	jmp,\reg,\nb_cases
    .endm
    .macro    JSR_B_INDEXED    reg,nb_cases
    JXX_B_INDEXED	jsr,\reg,\nb_cases
    .endm
    .macro    JMP_B_INDEXED    reg,nb_cases
    JXX_B_INDEXED	jmp,\reg,\nb_cases
    .endm


* registers must be masked out to proper size before use
	.macro	GET_INDIRECT_ADDRESS_REGS	reg1,reg2,destreg
	move.l	\reg1,a0
	lea	(a0,\reg2\().l),a0
	GET_ADDRESS_FUNC
	MOVE_W_TO_REG	a0,\destreg
	.endm


	.macro GET_DP_ADDRESS	offset
	.if	\offset>0xFF
	.error	"offset \offset > 0xFF"
	.endif
	lea	(a5,\offset\().W),a0
	.endm

* optimized DP operations
	.macro OP_1_ON_DP_ADDRESS    inst,offset
	\inst\().b    (a5,\offset\().W)
	.endm

	.macro OP_R_ON_DP_ADDRESS    inst,offset,reg
	\inst\().b    (a5,\offset\().W),\reg
	.endm

	.macro OP_W_ON_DP_ADDRESS    inst,offset,reg
	\inst\().b    \reg,(a5,\offset\().W)
	.endm

* you can remove PUSH/POP if you don't need them, but on
* Double Dragon, the move corrupted CC and it led to nasty bugs
	.macro	STORE_DP_IN_MEMORY
	PUSH_SR
	move.l	a5,cpu1_m6809_direct_page_pointer
	POP_SR
	.endm

	.macro SET_DP_FROM_A
	swap	d0    | would be catastrophic if D0 msw != 0
	clr.w	d0   | can happen with the use of subq
	swap	d0    | even if now I have set .w on all addq/subq
	lsl.w    #8,d0
	move.l    d0,a0  | remove MSB clear & change to move.w if always < 0x8000
	GET_ADDRESS_FUNC
	move.l	a0,a5
	STORE_DP_IN_MEMORY
	lsr.w    #8,d0
	.endm



	.macro SET_DP_FROM    reg
	exg	d0,\reg
	SET_DP_FROM_A

	exg	d0,\reg
	.endm

	.macro GET_REG_ADDRESS	offset,reg
	.ifeq	\offset
	move.l	\reg,a0
	.else
	lea	\offset,a0
	lea	(a0,\reg\().l),a0
	.endif
	GET_ADDRESS_FUNC
	.endm

	.macro	GET_SELECT_ADDRESS_FUNC
	* checks address, slower but can auto-select rom, ram or bank
	cmp.w	#0x6000,a0
	jcc		1f
	cmp.w	#0x4000,a0
	jcs		1f
	GET_BANK_ADDRESS_FUNC
	jra		2f
1:
	GET_ADDRESS_FUNC
2:	
	.endm
	.macro GET_REG_SELECT_ADDRESS	offset,reg
	.ifeq	\offset
	move.l	\reg,a0
	.else
	lea	\offset,a0
	lea	(a0,\reg\().l),a0
	.endif
	GET_SELECT_ADDRESS_FUNC
	.endm

	.macro GET_REG_INDIRECT_ADDRESS	offset,reg
	GET_REG_ADDRESS	\offset,\reg
	READ_BE_WORD	a0
	GET_ADDRESS_FUNC
	.endm
	.macro GET_REG_INDIRECT_BANK_ADDRESS	offset,reg
	GET_REG_ADDRESS	\offset,\reg
	READ_BE_WORD	a0
	GET_BANK_ADDRESS_FUNC
	.endm

	.macro    GET_REG_REG_INDIRECT_ADDRESS reg1,reg2
	GET_INDIRECT_ADDRESS_REGS	\reg1,\reg2,d6
	and.l	#0xFFFF,d6
	move.l	d6,a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_REG_ADDRESS_FROM_REG	reg,reg2
	move.l	\reg,a0
	lea	(a0,\reg2\().l),a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_REG_SELECT_ADDRESS_FROM_REG	reg,reg2
	move.l	\reg,a0
	lea	(a0,\reg2\().l),a0
	GET_SELECT_ADDRESS_FUNC
	.endm
	.macro GET_ADDRESS	offset
	lea	\offset,a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_INDIRECT_ADDRESS	offset
	GET_ADDRESS	\offset
	READ_BE_WORD	a0
	GET_ADDRESS_FUNC
	.endm
	.macro GET_REG_UNCHECKED_ADDRESS	offset,reg
	.ifeq	\offset
	move.l	\reg,a0
	.else
	lea	\offset,a0
	lea	(a0,\reg\().l),a0
	.endif
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	***** bank access *****
	.macro GET_BANK_ADDRESS	offset
	lea	\offset,a0
	GET_BANK_ADDRESS_FUNC
	.endm
	.macro GET_INDIRECT_BANK_ADDRESS	offset
	GET_ADDRESS	\offset
	READ_BE_WORD	a0
	GET_BANK_ADDRESS_FUNC
	.endm
	.macro	GET_UNCHECKED_BANK_ADDRESS_FUNC
	lea		(a1,a0.w),a0		| a0 < 0x8000
	.endm
	.macro GET_REG_BANK_ADDRESS	offset,reg
	.ifeq	\offset
	move.l	\reg,a0
	.else
	lea	\offset,a0
	lea	(a0,\reg\().w),a0
	.endif
	GET_BANK_ADDRESS_FUNC
	.endm
	.macro GET_REG_UNCHECKED_BANK_ADDRESS	offset,reg
	.ifeq	\offset
	move.l	\reg,a0
	.else
	lea	\offset,a0
	lea	(a0,\reg\().w),a0
	.endif
	GET_UNCHECKED_BANK_ADDRESS_FUNC
	.endm
	.macro GET_REG_BANK_ADDRESS_FROM_REG	reg,reg2
	move.l	\reg,a0
	lea	(a0,\reg2\().w),a0
	GET_BANK_ADDRESS_FUNC
	.endm
	***** end bank access *****

	.macro GET_REG_INDIRECT_UNCHECKED_ADDRESS	offset,reg
	GET_REG_ADDRESS	\offset,\reg
	READ_BE_WORD	a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro    GET_REG_REG_UNCHECKED_INDIRECT_ADDRESS reg1,reg2
	GET_INDIRECT_ADDRESS_REGS	\reg1,\reg2,d6
	and.l	#0xFFFF,d6
	move.l	d6,a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro GET_REG_UNCHECKED_ADDRESS_FROM_REG	reg,reg2
	move.l	\reg,a0
	lea	(a0,\reg2\().l),a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro GET_UNCHECKED_ADDRESS	offset
	lea	\offset,a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro GET_INDIRECT_UNCHECKED_ADDRESS	offset
	GET_ADDRESS	\offset
	READ_BE_WORD	a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm


multiply_ab:
	and.w	#0xFF,d0
	and.w	#0xFF,d1
	mulu	d0,d1
	ror.w	#8,d1
	move.b	d1,d0
	ror.w	#8,d1
	rts
	
	
	.ifndef	RELEASE
get_address:
	cmp.w	#0x4000,a0
	jcc		1f		| above 0x4000
	jbsr	osd_get_last_known_pc
	BREAKPOINT	"accessing videoram 0x0000-0x3FFF, PC in D6"
	jra		0f
1:
	cmp.w	#0x6000,a0
	jcs		0f		| below 0x6000: RAM: OK

	cmp.l	#0x8000,a0
	jcc		0f		| above 0x8000: ROM: OK
	
	jbsr	osd_get_last_known_pc
	BREAKPOINT	"CPU1: accessing bank memory 0x6000-0x7FFF, PC in D6"
	jra		0f
0:
	GET_UNCHECKED_ADDRESS_FUNC
	rts
get_bank_address:
	cmp.w	#0x6000,a0
	jcs		0f			| lower than 0x6000: error
	cmp.l	#0x8000,a0
	jcs		1f			| lower than 0x8000: OK
0:
	jbsr	osd_get_last_known_pc
	BREAKPOINT	"CPU1: get_bank_address out of 0x6000-0x7FFF range, PC in D6"	
1:
	GET_UNCHECKED_BANK_ADDRESS_FUNC
	rts
	
	.macro	ENABLE_LOG_REGS
	moveq	#1,d6		| enable
	moveq	#0,d7		| cpu 1
	jbsr	osd_cpu_logging_control	
	.endm
	.macro	DISABLE_LOG_REGS
	moveq	#0,d6		| disable
	moveq	#0,d7		| cpu 1
	jbsr	osd_cpu_logging_control	
	.endm	
	.macro	REENABLE_LOG_REGS
	moveq	#2,d6		| enable
	moveq	#0,d7		| cpu 1
	jbsr	osd_cpu_logging_control	
	.endm
	* to trace at some virtual PCs, insert this macro
	.macro	LOG_REGS	the_pc
	move.w	sr,-(a7)
	move.w	#0x\the_pc,-(a7)
	move.w	#0,-(a7)		| cpu #1
	jbsr	osd_log_cpu
	addq.w	#4,a7
	move.w	(a7)+,sr
	.endm
	.macro	LOG_REGS_QUICK	the_pc
	move.w	sr,-(a7)
	move.w	#0x\the_pc,0x100
	move.w	#0,0x102
	move.w	(a7)+,sr
	.endm
	.endif
