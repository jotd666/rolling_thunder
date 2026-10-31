	.ifndef	CPU1_OPTIONS_INC
CPU1_OPTIONS_INC = 1
	
	.include	"cpu_shared_options.inc"
	
* makes random routines return 0. Can lock up the game
*OPT_FIX_RANDOM = 1

CPU1_RAM_START = 0x0000
CPU1_ROM_START = 0x8000

	.ifdef	RELEASE

	.else
	
LOG_BUFFER_SIZE = 0x8000
	* amiga specific
	.endif
	
	.macro	CPU1_GET_MEMORY_START_IN_A6
	.ifeq	OPT_ALIGNED_MEMORY
	lea		cpu1_ram_buffer-CPU1_RAM_START,a6
	.else
	move.l		cpu1_ram_start_0000,a6
	* adjust offset to avoid subbing at run-time
	.ifne	CPU1_RAM_START
	sub.w	#CPU1_RAM_START,a6
	.endif
	.endif	
	.endm
	
	.macro	CPU1_GET_MEMORY_START_AND_DP
	move.l	cpu1_m6809_direct_page_pointer,a5
	move.l	cpu1_bank_base,a1
	CPU1_GET_MEMORY_START_IN_A6
	.endm
	
	.endif
