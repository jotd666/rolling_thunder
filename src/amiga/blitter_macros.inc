	.include "hardware/custom.i"

* how to use in double buffering mode with a "drawn" and a "displayed" buffer
*
* - set OPT_BLIT_CHAIN_MODE to 0 or 1: 0 classic blit+waitblit, 1 blit in interrupts
* - replace all blit writes by WRITE_BLITTER_REG_xxx macros. When writing bltsize
*   use WRITE_BLITTER_REG_SIZE instead of WRITE_BLITTER_REG_WORD
*
* mode 0: classic mode. WAIT_BLIT is active, all operations are synchronous so
* in vblank (top of frame) or copper interrupt (set at bottom of frame):
* - blit in "drawn" buffer 
* - switch buffer pointers
* - show "displayed" buffer in copperlist
*
* mode 1: with blitter interrupt chain.
* - use DECL_BLITLISTS with an arbitrary size. Error will trigger if too small
* - setup level 1 interrupt at end of copperlist (instead of copper interrupt)
*   so it can be interrupted by blitter
* - setup level 3 interrupt with vblank and blitter (copper isn't useful)
* - on level 1 interrupt:
*   - call NEW_BLITLIST
*   - set bitplanes
*   - switch screen pointers (note the reversed order vs synchronous mode!)
*   - call PROCESS_BLITS to process the previous blits
*   - call the routine to perform the "blits" (fake blits now, fills filled_blitter_list instead)
*   - call COMMIT_BLITLIST to end the list (by setting -2 in it)
*
*   that's it. PROCESS_BLITS started the chain reaction, and there are not blitwaits
*   anymore in the code
*
*   In most games, for memory considerations, we use in-place mirroring, so no problem with
*   option 0. But option 1 needs more work. So we introduce a new virtual blitter command if OPT_VBLIT_MIRROR_MODE=1
*   in the WRITE_VIRTUAL_MIRROR_COMMAND, mirror_function expects the bitplane data in A2 and the height minus 1 in D1
*
*   Game that scroll and that can't use dual playfield for sprites also need a command to store the current scroll value
*   else if the screen moves a lot, the scroll offset added to the bobs doesn't match the current scroll offset
*
*   it's however ideal on games that need a lot of blitting and exclusively use
*   static source data. Interleaved mode would trigger less interrupts too.
*
*   most macros do nothing in mode 0, so it allows to lay them out and compare speed
*   with mode 0 or 1 without changing the code
*   only the screen switch order and location changes (in double buffered mode, if
*   you race the beam, there's nothing to do)
*
******************
* blitter macros *
******************

*DEBUG_BLIT_WAIT = 1

	.macro	CHECK_A5_IS_CUSTOM
	.ifndef	RELEASE
	cmp.l	#_custom,a5
	jeq		s0\@
	BREAKPOINT	"custom should be set in A5"
s0\@:
	.endif		
	.endm



********************
* classic handling *
********************

	.if		OPT_BLIT_CHAIN_MODE==0
	.macro	REALLY_WAIT_BLIT
	CHECK_A5_IS_CUSTOM
	* game uses fastmem, we can run with blthog set
	*move.w	#0x8400,(dmacon,a5)		| blitter high priority
wait\@:
	BTST	#6,(dmaconr,a5)
	BNE.S	wait\@
	*move.w	#0x0400,(dmacon,a5)		| blitter normal priority
	.endm
	
	.macro	WAIT_BLIT
	REALLY_WAIT_BLIT
	.endm
	
	.macro	NEW_BLITLIST
	.endm
	
	.macro	PROCESS_ONE_BLIT
	.endm
	
	.macro	PROCESS_BLITS
	.endm
	
	.macro	FORCE_PROCESS_BLITS
	.endm
	
	.macro	COMMIT_BLITLIST
	.endm
	
	.macro	BLIT_LIST_BEGIN
	lea		_custom,a5
	.endm
	.macro	BLIT_LIST_END
	.endm
	
	.macro	WRITE_BLITTER_REG_LONG	value,offset
	CHECK_A5_IS_CUSTOM
	move.l	\value,\offset(a5)
	.endm
	.macro	WRITE_BLITTER_REG_WORD	value,offset
	CHECK_A5_IS_CUSTOM
	move.w	\value,\offset(a5)
	.endm
	.macro	WRITE_BLITTER_REG_SIZE	value
	WRITE_BLITTER_REG_WORD	\value,bltsize
	.endm
	
	.if		OPT_VBLIT_MIRROR_MODE==1
	.macro	WRITE_BLITTER_VIRTUAL_MIRROR	height,mirror_function,bitplane
	move.w	\height,d1		| height
	subq	#1,d1		| minus one for dbf
	jsr		(\mirror_function)	  | in: A2 bitplane (parameter is ignored it is already a2), D1: height-1
	.endm
	.endif
	
	.if		OPT_VBLIT_SCROLL_MODE==1
	.macro	WRITE_BLITTER_SCROLL_VALUES	scroll_x,scroll_y
	* the blits are synchronous, the scrolling is updated at the same time
	move.l	\scroll_x,blitter_scroll_x
	move.w	\scroll_y,blitter_scroll_y
	.endm
	.endif
	
	* no blitlists, empty
	.macro	DECL_BLITLISTS	size
	.endm
	
	.endif
	
******************
* queue handling *
******************

	.if		OPT_BLIT_CHAIN_MODE==1
	.macro	WAIT_BLIT
	* do nothing!
	.endm
	
	.macro	REALLY_WAIT_BLIT
	.ifdef	DEBUG_BLIT_WAIT
sw\@:
	* if blitter isn't finished, then we wait
	* this is called from level 1 interrupt so
	* blitter interrupts can interrupt
	tst.b	blitter_chain_running
	jeq		snw\@
	COLOR0_FLASH	0xF00
	jra		sw\@
snw\@:
	.else
	.ifndef	RELEASE
	* did last frame's chain fail to finish inside its frame?  if this climbs
	* every frame the blitter is over budget and no scheduling change can help
	tst.b	blitter_chain_running
	jeq		sn\@
	addq.w	#1,nb_chain_overruns
sn\@:
	.endif
sw\@:
	* if blitter isn't finished, then we wait
	* this is called from level 1 interrupt so
	* blitter interrupts can interrupt
	tst.b	blitter_chain_running
	jne		sw\@
	.endif
	.endm

	
	.macro	NEW_BLITLIST
	lea		blitter_list_1,a0
	lea		blitter_list_2,a1
	REALLY_WAIT_BLIT
	
	.ifndef	RELEASE
	* REALLY_WAIT_BLIT has just guaranteed the chain is drained, so every
	* mirror queued during the previous frame must have been executed by now.
	* A difference means those flips went missing while their flags were
	* already written - the only way a plane can end up permanently out of
	* step with its orientation word.  a0/a1 are already loaded above, so
	* only d0 is borrowed.
	move.w	d0,-(a7)
	move.w	nb_mirrors_queued,d0
	sub.w	nb_mirrors_executed,d0
	jeq		sm\@
	add.w	d0,nb_lost_mirrors
	BREAKPOINT	"mirror flips lost (D0 = lost this frame)"
sm\@:
	move.w	(a7)+,d0
	clr.w	nb_mirrors_queued
	clr.w	nb_mirrors_executed
	.endif
	
	* blitter chain has completed: we can switch lists
	eor.b	#1,blitter_list_toggle
	jne		s0\@
	move.l	a0,drawn_blitter_list_ptr
	move.l	a1,filled_blitter_list_ptr
	jra		s1\@
s0\@:
	move.l	a1,drawn_blitter_list_ptr
	move.l	a0,filled_blitter_list_ptr
s1\@:
	.endm
	
	.macro	PROCESS_BLITS
	* The list can hold virtual commands with no bltsize behind them - a frame
	* where every BOB was rejected on Y still queues its mirrors, and the flags
	* were already updated when they were queued.  Walk it regardless: with no
	* bltsize, PROCESS_ONE_BLIT runs the mirrors and falls out on the -2.
	* so we still need to do something even if no size command is issued
	
	* signal that the blitter chain is now running
	st.b	blitter_chain_running
	* start first blit from outside the blitter interrupt to
	* start the chain reaction reading from drawn_blitter_list_ptr
	PROCESS_ONE_BLIT
	* clear size command issued for next blitlist creation
	clr.b	size_command_issued
	.endm

	* we know that size_command_issued is set
	.macro	FORCE_PROCESS_BLITS
	* signal that the blitter chain is now running
	st.b	blitter_chain_running
	* start first blit from outside the blitter interrupt to
	* start the chain reaction reading from drawn_blitter_list_ptr
	PROCESS_ONE_BLIT
	* clear size command issued for next blitlist creation
	clr.b	size_command_issued
	.endm

	.macro	DECL_BLITLISTS	size
blitter_scroll_x:
	.long	0
blitter_scroll_y:
	.word	0
drawn_blitter_list_ptr:
	.long	0
filled_blitter_list_ptr:
	.long	0
blitter_list_1:
	.word	0
	.skip	\size
	.long	0
	.long	0
	.long	0
blitter_list_2:
	.word	0
	.skip	\size
	.long	0
	.long	0
	.long	0
blitter_chain_running:
	.byte	0
size_command_issued:
	.byte	0
blitter_list_toggle:	
	.byte	0
	.align	2
	.ifndef	RELEASE
* Mirror accounting.  A plane's orientation flag is written on the CPU when
* the mirror is QUEUED, but the flip only happens when the list is walked.
* If the list is ever lost - skipped, overflowed, terminated early, or simply
* not the one that gets kicked - the flip is discarded while the flag has
* already been updated, and that plane's orientation word lies about its
* pixels for the rest of the level.  These two counters make that visible.
nb_mirrors_queued:
	.word	0
nb_mirrors_executed:
	.word	0
* Sticky total of flips lost since reset.  Never cleared, so it can be read
* off the overlay during play instead of having to catch the breakpoint.
nb_lost_mirrors:
	.word	0
	.endif
	.endm
	
	.macro	COMMIT_BLITLIST
	* complete filled list
	move.l	filled_blitter_list_ptr,a0
	move.w	#0xFFFE,(a0)
	.endm

	.macro	PROCESS_ONE_BLIT
	* process blit command, first one (outside blitter int)
	* or others (inside blitter int)
	CHECK_A5_IS_CUSTOM
	move.l	drawn_blitter_list_ptr,a0

	move.w	#-1,d2
b0\@:
	move.w	(a0)+,d0		| blitter register
	jmi		b1\@			| end of command or end of list

	bclr	#14,d0
	jne		b2\@
	* word or virtual mirror command
	.if	OPT_VBLIT_MIRROR_MODE==1
	cmp.w	#deniseid,d0
	jne		nv0\@
	* mirror command
	movem.l	d0-d2/a0-a2,-(a7)
	lea		mirror_table,a1
	move.w	(a0)+,d1
	subq	#1,d1			| height minus one
	.ifndef	RELEASE
	jpl		pos\@
	BREAKPOINT	"zero height for mirror"
pos\@:
	.endif
	move.l	(a0)+,a2
	.ifndef	MC68020
	move.l	(a0),a0
	jsr		(a0)
	.else
	jsr		([a0])
	.endif
	movem.l	(a7)+,d0-d2/a0-a2
	.ifndef	RELEASE
	* memory operand: no register to save, we are past the movem restore
	addq.w	#1,nb_mirrors_executed
	.endif
	add.w	#10,a0		| advance to next command
	jra		b0\@		| not size: continue parsing list
nv0\@:
	.endif
	.if		OPT_VBLIT_SCROLL_MODE==1
	cmp.w	#dsksync,d0
	jne		nv1\@
	* store scrolling command
	move.l	(a0)+,blitter_scroll_x
	move.w	(a0)+,blitter_scroll_y
	jra		b0\@		| not size: continue parsing list
nv1\@:
	.endif
	* word command, check bounds
	.ifndef	RELEASE
	cmp.w	#bltcon0,d0		| sanity check for commands!
	jcc		f1\@
f0\@:
	lea		(-2,a0),a1
	BREAKPOINT	"word command: not a blitter register (in A1)"
	illegal
f1\@:
	cmp.w	#deniseid,d0
	jcc		f0\@
	.endif
	
	* bit not set: word command
	move.w	(a0)+,d1		| word value
	
	
	move.w	d1,(a5,d0.w)
	jra		b0\@		| not size: continue parsing list
	* long write command
b2\@:
	.ifndef	RELEASE
	cmp.w	#bltcon0,d0		| sanity check for commands!
	jcc		g1\@
g0\@:
	BREAKPOINT	"long command: not a blitter register !!"
	illegal
g1\@:
	cmp.w	#deniseid,d0
	jcc		g0\@
	.endif


	* bit 14 set: long command
	move.l	(a0)+,d1		| long value

	
	move.l	d1,(a5,d0.w)
	jra		b0\@		| not size: continue parsing list
b1\@:
	cmp.w	d2,d0
	jeq		b3\@		| -1: end of command
	* -2: end of list: nothing to do, we're done for that frame
	clr.b	blitter_chain_running
	.ifndef	RELEASE
	* how many scanlines the whole chain took.  312 is a PAL frame.
	moveq	#0,d0
	move.b	0xdff006,d0
	sub.w	blit_start_vpos,d0
	jpl		bv\@
	add.w	#0x100,d0		| vpos is 8 bit, it wrapped
bv\@:
	move.w	d0,blit_busy_lines
	.endif
b3\@:
	move.l	a0,drawn_blitter_list_ptr
	.endm
	
	.macro	LOAD_FILLED_LIST
	move.l	filled_blitter_list_ptr,a5
	.ifndef	RELEASE
	cmp.w	#0xdead,(a5)
	jne		c0\@
	BREAKPOINT	"Blitter list overflow"
c0\@:
	.endif
	.endm
	
	.macro	STORE_FILLED_LIST
	move.l	a5,filled_blitter_list_ptr
	.endm
	
	.if		OPT_VBLIT_MIRROR_MODE==1
	.macro	WRITE_BLITTER_VIRTUAL_MIRROR	height,mirror_function,bitplane
	.ifndef	RELEASE
	* counted here rather than in mirror_sprite_planes_32x32 so the counter
	* cannot drift from the number of commands actually written
	addq.w	#1,nb_mirrors_queued
	.endif
	move.l	a5,-(a7)
	LOAD_FILLED_LIST
	move.w	#deniseid,(a5)+		| fake custom reg,(a5)+
	move.w	\height,(a5)+
	move.l	\bitplane,(a5)+
	move.l	\mirror_function,(a5)+
	STORE_FILLED_LIST
	move.l	(a7)+,a5
	.endm
	.endif

	.if		OPT_VBLIT_SCROLL_MODE==1
	.macro	WRITE_BLITTER_SCROLL_VALUES	scroll_x,scroll_y
	move.l	a5,-(a7)
	LOAD_FILLED_LIST
	move.w	#dsksync,(a5)+		| fake custom reg,(a5)+
	move.l	\scroll_x,(a5)+		| here we adapted to long for convenience (HI/LO)
	move.w	\scroll_y,(a5)+
	STORE_FILLED_LIST
	move.l	(a7)+,a5
	.endm
	.endif

	* a5 holds the command list cursor for the whole of an emitting routine,
	* bracketed by BLIT_LIST_BEGIN / BLIT_LIST_END, so appending a field is
	* two instructions instead of ten.  Nothing else needs a5 in this mode:
	* WAIT_BLIT is a no-op and CHECK_A5_IS_CUSTOM only exists in mode 0.
	*
	* Note the +0x4000 rather than |0x4000 for the long-command bit: the
	* pipe is this assembler's comment character and would eat the line.
	* Every custom register offset has bit 14 clear, so adding is the same.
	.macro	BLIT_LIST_BEGIN
	move.l	filled_blitter_list_ptr,a5
	.endm
	
	.macro	BLIT_LIST_END
	move.l	a5,filled_blitter_list_ptr
	.ifndef	RELEASE
	cmp.w	#0xdead,(a5)
	jne		ble\@
	BREAKPOINT	"Blitter list overflow"
ble\@:
	.endif
	.endm
	
	.macro	WRITE_BLITTER_REG_LONG	value,offset
	move.w	#(\offset)+0x4000,(a5)+	| bit 14: long command
	move.l	\value,(a5)+
	.endm
	
	.macro	WRITE_BLITTER_REG_WORD	value,offset
	move.w	#\offset,(a5)+
	move.w	\value,(a5)+
	.endm
	
	.macro	WRITE_BLITTER_REG_SIZE	value
	move.w	#bltsize,(a5)+
	move.w	\value,(a5)+
	move.w	#-1,(a5)+		| end of command
	st.b	size_command_issued
	.endm
	.endif
	