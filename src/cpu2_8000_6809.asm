
;=============================================================================
; ROLLING THUNDER (Namco, 1986) - Namco System 86
;
; Three processors share memory:
;   CPU1  HD6809  main   - game logic, tilemaps, scroll, state machine
;   CPU2  HD6809  sub    - sprites, enemies, collisions
;   MCU   HD63701 CUS60  - inputs, coins/credits, sound (YM2151 + CUS30 + 63701X)
;
; ---------------------------------------------------------------------------
; THE THREE ADDRESS SPACES OVER THE SAME PHYSICAL RAM
; ---------------------------------------------------------------------------
; The same chips appear at different addresses on each bus.  When porting,
; pick ONE flat layout and translate every address; do NOT keep three views.
;
;   physical block   size    CPU1        CPU2        MCU
;   --------------   -----   ---------   ---------   ---------
;   videoram1        $2000   $0000       $2000       -          layers 0 and 1
;   videoram2        $2000   $2000       $4000       -          layers 2 and 3
;   spriteram        $2000   $4000*      $0000       -          objects + shared
;   CUS30 sound RAM  $0400   $4000       -           $1000      main <-> MCU
;
;   * CPU1 cannot see spriteram $0000-$03FF: on its bus that window is
;     replaced by the CUS30 sound RAM.  Those 1024 bytes belong to CPU2 alone.
;
; So, to convert an address:
;     CPU2 addr = CPU1 addr + $2000   (for the two tilemap blocks)
;     CPU2 addr = CPU1 addr - $4000   (for spriteram, CPU1 $4400-$5FFF only)
;     MCU  addr = CPU1 addr - $3000   (for the CUS30 window $4000-$43FF)
;
; Consequences that matter:
;   - CPU1 direct page $5600 and CPU2 direct page $1600 are THE SAME 256 bytes.
;     Every DP variable is shared.  That is the main IPC channel.
;   - CPU1's stack lives at $5700-$57FF, i.e. spriteram $1700-$17FF, which is
;     immediately below the sprite display list CPU2 writes at $1800.
;   - The sprite display list is at spriteram $1800-$1FFF = CPU1 $5800-$5FFF
;     = CPU2 $1800-$1FFF.  CPU2 builds it; CPU1 never touches it.
;
; ---------------------------------------------------------------------------
; SYNC 1 - THE BOOT BARRIER  (spriteram $1FF0 = CPU1 $5FF0 = CPU2 $1FF0)
; ---------------------------------------------------------------------------
; Power-on RAM test.  CPU1 fills a block with ROM data, CPU2 complements every
; byte of the same block, CPU1 then verifies that RAM == NOT(ROM) by checking
; that (rom_byte EOR ram_byte) == $FF.  The two CPUs rendezvous on a shared
; counter after each block.
;
;   counter  CPU1                              CPU2
;   -------  --------------------------------  ------------------------------
;      0     CLR $5FF0                         spins until $1FF0 == 0
;            fill videoram1 from ROM $8000
;      1     INC -> 1, wait for 2              COM videoram1, INC -> 2
;      2     verify block, fill videoram2      wait for 3
;      3     INC -> 3, wait for 4              COM videoram2, INC -> 4
;      4     verify, fill spriteram $4400+     wait for 5
;      5     INC -> 5, wait for 6              COM spriteram, INC -> 6
;      6     verify, ROM checksum, INC -> 7    ROM checksum
;      7     MCU handshake, CLR $5FF0          set $1FF3 = 1, wait for 2
;
; *** THIS IS A RACE, BY DESIGN. ***  CPU1's fill loop is ~14 cycles/byte and
; CPU2's complement loop is ~24 cycles/byte, so CPU1 stays ahead of CPU2
; inside each block and every byte is written before it is complemented.  The
; test only passes if both CPUs run concurrently at roughly the original
; speeds.  This is why MAME needs an interleave factor of 800 here.
;
; FOR A PORT: do not try to reproduce this.  Run the test on one core, or skip
; it entirely and leave post_errors_5ff1 = 0.  Any single-threaded conversion
; that runs CPU1 to completion before CPU2 will fail the check and drop into
; the error screen at $8147.
;
; ---------------------------------------------------------------------------
; SYNC 2 - THE PER-FRAME GAME-STATE BARRIER  (the one you need for gameplay)
; ---------------------------------------------------------------------------
; Shared direct-page bytes:
;   $02 CPU1 main state     $03 CPU2 main state
;   $04 CPU1 sub state      $05 CPU2 sub state
;   $06 CPU1 semaphore      $07 CPU2 semaphore
;
; Both IRQ handlers start with the same guard:
;
;   CPU1 ($8579):  LDA $02 / CMPA $03 / BHI skip_dispatch
;   CPU2 ($817B):  LDA $03 / CMPA $02 / BHI skip_dispatch
;
; Read it as: "only run my state handler if I am not ahead of the other CPU".
; Whichever CPU advances its state first then idles (it still acks the IRQ and
; re-arms its ROM bank) until the other one catches up.  There is no lock and
; no spin in the main loop - the barrier is purely these two comparisons,
; evaluated once per frame inside the IRQ.
;
; State changes are done in pairs, e.g. at $85C2:
;       INC $02 / CLR $04 / CLR $06      <- advance CPU1
;       INC $03 / CLR $05 / CLR $07      <- advance CPU2 as well
; so a transition performed by one CPU drags the other one along.
;
; The MAME driver note about a semaphore at 5606/5607 (CPU1) and 1606/1607
; (CPU2) refers to $06/$07 above - same bytes, two address spaces.
;
; FOR A PORT: if you run both 6809 streams as cooperative tasks, switch tasks
; at least once per frame and evaluate each guard with the other task's
; current value.  If you merge both programs into one 68000 thread, run CPU1's
; IRQ body then CPU2's IRQ body every frame and the guards resolve naturally.
;
; $00 bit 0 is a frame-parity flag: when set, both IRQ handlers take the short
; path and skip the state dispatch entirely, halving the logic rate.
;
; ---------------------------------------------------------------------------
; SYNC 3 - SPRITE LIST DOUBLE BUFFERING
; ---------------------------------------------------------------------------
; CPU2 writes the sprite list to offsets 4-9 of every 16-byte record, then
; writes ANY value to spriteram $1FF2 (CPU1 $5FF2).  On the next VBLANK the
; sprite chip copies bytes 4-9 to bytes 10-15 of each record, and only those
; copied bytes are displayed.  Sprites are therefore one frame late.
; CPU2 does this at the end of its IRQ ($819E).
;
; ---------------------------------------------------------------------------
; MCU INTERFACE - INPUTS
; ---------------------------------------------------------------------------
; The MCU never exposes raw ports.  It samples five sources:
;     $2030 DSW0    $2031 DSW1    $2020 IN0    $2021 IN1    port1 IN2
; scatters them one-bit-per-byte into its private RAM at $1400, remaps them
; through a 37-entry permutation table in the sub-ROM at $807F, inverts the
; active-low ones (all except the two coin inputs), debounces each bit, and
; publishes a 2-byte record per switch.
;
;   CPU1 $423C + 2*L + 0  =  rising edge, set for exactly one frame
;   CPU1 $423C + 2*L + 1  =  debounced level, 1 while held
;
; L is the LOGICAL index below.  This ordering is what the game code uses;
; it is not the bit order of the ports.
;
;    L  source        meaning                L  source        meaning
;   --  ------------  ---------------------  --  ------------  ------------------
;    0  DSWA bit7     SWA:1 service mode     19  IN0  bit6     START1
;    1  DSWA bit6     SWA:2 coin A           20  IN1  bit5     COIN2   (not inverted)
;    2  DSWA bit5     SWA:3 coin A           21  IN0  bit5     COIN1   (not inverted)
;    3  DSWA bit4     SWA:4 demo sounds      22  IN1  bit4     SERVICE1 (service coin)
;    4  DSWA bit3     SWA:5 invulnerability  23  IN1  bit1     BUTTON2 p2  (jump)
;    5  DSWA bit2     SWA:6 freeze           24  IN2  bit6     BUTTON1 p2  (shoot)
;    6  DSWA bit1     SWA:7 coin B           25  IN1  bit3     UP    p2
;    7  DSWA bit0     SWA:8 coin B           26  IN0  bit3     DOWN  p2
;    8  DSWB bit7     SWB:1 lives            27  IN0  bit4     RIGHT p2
;    9  DSWB bit6     SWB:2 bonus life       28  IN2  bit7     LEFT  p2
;   10  DSWB bit5     SWB:3 timer value      29  IN0  bit1     BUTTON2 p1  (jump)
;   11  DSWB bit4     SWB:4 difficulty       30  IN2  bit3     BUTTON1 p1  (shoot)
;   12  DSWB bit3     SWB:5 level select     31  IN1  bit2     UP    p1
;   13  DSWB bit2     SWB:6 cabinet          32  IN0  bit2     DOWN  p1
;   14  DSWB bit1     SWB:7 cabinet          33  IN2  bit5     RIGHT p1
;   15  DSWB bit0     SWB:8 continues        34  IN2  bit4     LEFT  p1
;   16  IN1  bit7     unused                 35  IN0  bit0     button3 p2 (unused)
;   17  IN0  bit7     SERVICE (edge conn)    36  IN1  bit0     button3 p1 (unused)
;   18  IN1  bit6     START2
;
; Handy absolute addresses (levels are the odd byte, edges the even one):
;   $423D service dip     $4261 START2 level   $4263 START1 level
;   $4276 p1 jump edge    $4277 p1 jump level
;   $4278 p1 shoot edge   $4279 p1 shoot level
;   $427B p1 UP  $427D p1 DOWN  $427F p1 RIGHT  $4281 p1 LEFT   (levels)
;   $426B p2 jump level   $426D p2 shoot level
;   $426F p2 UP  $4271 p2 DOWN  $4273 p2 RIGHT  $4275 p2 LEFT   (levels)
;
; read_player_input ($82B8) picks p1 at $4276 or p2 at $426A depending on DP
; $1E (cocktail / active side) and packs UP/DOWN/LEFT/RIGHT + jump into $0A.
;
; FOR A PORT: you do not need to emulate the MCU.  Read your host's controls,
; debounce them, and write the 37 two-byte records yourself.  The edge byte
; must be true for one frame only.  Note SWA:1 (L0) is OR-ed with the edge
; connector service switch (L17) inside the MCU before publication.
;
; ---------------------------------------------------------------------------
; MCU INTERFACE - BOOT HANDSHAKE AND CREDITS
; ---------------------------------------------------------------------------
;   $4182  <- MCU  writes $A6 when its kernel is alive
;   $4183  -> MCU  $FF = run self-test; non-zero also means "test mode", which
;                  disables the 9-credit coin lockout inside the MCU
;   $4184  <- MCU  writes $A6 after acting on $4183
;   $4185  <- MCU  self-test result, 0 = pass
;   $4181  -> MCU  CPU1 writes $A6 to report that the MCU failed its test
;   $4189  <- MCU  coin/credit status
;   $418A  <- MCU  credit count; as soon as it is non-zero the "press start"
;                  screen appears
;
; Boot sequence performed by CPU1 at $8107:
;     wait $4182 == $A6
;     wait $4183 == 0
;     write $FF to $4183
;     wait $4184 == $A6
;     if $4185 != 0 -> write $A6 to $4181 and set bit 5 of post_errors_5ff1
;
; FOR A PORT: stub this by presetting $4182 = $4184 = $A6 and $4185 = 0, then
; honouring the $4183 write.  wait_mcu_ready1/2 ($8547/$854F) spin forever
; otherwise.
;
; ---------------------------------------------------------------------------
; IF THE PORT BOOTS BUT MISBEHAVES, CHECK THESE IN ORDER
; ---------------------------------------------------------------------------
;   1. post_errors_5ff1 must be 0, or CPU1 dead-loops in the error screen.
;   2. Both IRQ handlers must re-arm their ROM bank latch every frame
;      (CPU1 $8587 writes DP $19 to $6800, CPU2 $8189 writes DP $1A to $D803).
;      Miss this and the banked window $6000-$7FFF reads the wrong ROM.
;   3. CPU2 must write $1FF2 once per frame or no sprite ever appears.
;   4. The watchdog at $8000 is written from inside long loops; if you keep a
;      real watchdog, keep those writes.
;   5. DP $00 bit 0 must toggle, or the game runs at half or double rate.
;=============================================================================

;=============================================================================
; CPU2 (sub 6809) - memory map as seen from this bus
;=============================================================================
;   $0000-$03FF  work RAM that CPU1 cannot reach (sound RAM covers it there)
;   $0400-$15FF  work RAM shared with CPU1 ($4400-$55FF on that bus)
;   $1600-$16FF  direct page (same bytes as CPU1 $5600)
;   $1700-$17FF  CPU1's stack - do not use
;   $1800-$1FEF  sprite display list, owned by this CPU
;   $1FF0-$1FFF  sync and control bytes
;   $2000-$2FFF  layer 0 tilemap      (CPU1 $0000)
;   $3000-$3FFF  layer 1 tilemap      (CPU1 $1000)
;   $4000-$4FFF  layer 2 tilemap      (CPU1 $2000)
;   $5000-$5FFF  layer 3 tilemap      (CPU1 $3000)
;   $6000-$7FFF  banked ROM
;   $8000-$FFFF  ROM
;
; Write-only hardware:
;   $8000 watchdog   $8800 irq ack   $D803 ROM bank select
;   CPU2 has no scroll registers wired up on this board.
;
; Sprite record layout (16 bytes each, $1800 + 16*n):
;   +0..+3   scratch
;   +4..+9   CPU2 writes here; the chip copies them to +10..+15 at VBLANK
;   +10  xx------ X size (16,8,32,4)   --x----- X flip
;        ---xx--- X offset in 32x32    -----xxx tile bank
;   +11  tile number
;   +12  xxxxxxx- colour               -------x X position bit 8
;   +13  X position low
;   +14  xxx----- priority             ---xx--- Y offset in 32x32
;        -----xx- Y size (16,8,32,4)   -------x Y flip
;   +15  Y position (inverted, bottom anchored)
;
; Screen Y = ((-(+15) - sizeY - yoffs + 1 + 16) & $FF) - 16,  range -16..239.
; Control bytes inside the list: $1FF4/$1FF5 sprite X offset (9 bits),
; $1FF6 bit0 flip screen, $1FF7 sprite Y offset.
;=============================================================================


; ---------------------------------------------------------------- equates
boot_barrier_1ff0            = $1FF0		; boot barrier counter, shared with CPU1 ($5FF0)
post_errors_1ff1             = $1FF1		; POST error bits (same byte as CPU1 $5FF1)
sprite_latch_1ff2            = $1FF2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
cpu2_ready_1ff3              = $1FF3		; CPU2 -> CPU1 'POST finished' handshake ($5FF3)
flip_screen_1ff6             = $1FF6		; screen flip flag ($5FF6)
;watchdog_8000               = $8000		; watchdog reset   (already defined above)
;irq_ack_8800                = $8800		; IRQ acknowledge   (already defined above)
bank2_select_d803            = $D803		; CPU2 ROM bank select ($6000-$7FFF)

dp_frame_parity_00           = $00		; DP $1600 - frame parity / update-rate flag (bit0 halves the IRQ work)
dp_state_cpu1_02             = $02		; DP $1602 - CPU1 main game state
dp_state_cpu2_03             = $03		; DP $1603 - CPU2 main game state
dp_sub_cpu1_04               = $04		; DP $1604 - CPU1 sub-state
dp_sub_cpu2_05               = $05		; DP $1605 - CPU2 sub-state
dp_sem_cpu1_06               = $06		; DP $1606 - CPU1 semaphore / step within sub-state
dp_sem_cpu2_07               = $07		; DP $1607 - CPU2 semaphore / step within sub-state
dp_irqcount1_0e              = $0E		; DP $160E - CPU1 IRQ/frame counter
dp_irqcount2_0f              = $0F		; DP $160F - CPU2 IRQ/frame counter
dp_bank1_shadow_19           = $19		; DP $1619 - shadow of CPU1 ROM bank latch, re-armed every IRQ
dp_bank2_shadow_1a           = $1A		; DP $161A - shadow of CPU2 ROM bank latch, re-armed every IRQ

;	map(0x0000, 0x1fff).ram().w(FUNC(namcos86_state::spriteram_w)).share("spriteram");   shared with 0x4000-0x5FFF of maincpu
;	map(0x2000, 0x3fff).ram().w(FUNC(namcos86_state::videoram1_w)).share("videoram1");   shared with map(0x0000, 0x1fff) maincpu
;	map(0x4000, 0x5fff).ram().w(FUNC(namcos86_state::videoram2_w)).share("videoram2");   shared with map(0x2000, 0x3fff) maincpu



;	map(0x6000, 0x7fff).bankr("bank2");
;	map(0x8000, 0xffff).rom();
;	map(0x8000, 0x8000).w(FUNC(namcos86_state::watchdog2_w));
;	map(0x8800, 0x8800).w(FUNC(namcos86_state::int_ack2_w));   // IRQ acknowledge
;//  { 0xd800, 0xd802 } layer 2 scroll registers would be here
;	map(0xd803, 0xd803).w(FUNC(namcos86_state::bankswitch2_w));
;//  { 0xd804, 0xd806 } layer 3 scroll registers would be here

watchdog_8000 = $8000

irq_ack_8800 = $8800

; page $16
bullets_cb = $cb


;--------------------------------------------------------------------------
; CPU2 reset entry.
; Waits for CPU1 to clear boot_barrier_1ff0, then plays its half of the
; cooperative RAM test: complement every byte of the block CPU1 just filled, bump
; the barrier, wait for CPU1's verify, repeat. Then its own ROM checksum, then
; sets cpu2_ready_1ff3 = 1 and waits for CPU1 to make it 2.
; NOTE the deliberate race: CPU1's fill loop is faster per byte than this
; complement loop, so CPU1 stays ahead inside each block. Do not serialise.
;--------------------------------------------------------------------------
cpu2_boot_8000:  ; [global]
8000: 1A 10       ORCC   #$10		; disable interrupts
8002: 10 CE 04 00 LDS    #$0400		; set stack
8006: 86 16       LDA    #$16		; set DP at $16xx
8008: 1F 8B       TFR    A,DP
800A: 4F          CLRA
800B: B7 80 00    STA    watchdog_8000
800E: 4A          DECA
800F: 26 FA       BNE    $800B
8011: B7 80 00    STA    watchdog_8000
; sync with other cpu
8014: B6 1F F0    LDA    boot_barrier_1ff0
8017: 26 F8       BNE    $8011
8019: 8E 20 00    LDX    #$2000		; layer 0 tilemap
801C: A6 84       LDA    ,X
801E: 43          COMA
801F: A7 80       STA    ,X+
8021: B7 80 00    STA    watchdog_8000
8024: 8C 40 00    CMPX   #$4000
8027: 25 F3       BCS    $801C
8029: 7C 1F F0    INC    boot_barrier_1ff0
802C: B7 80 00    STA    watchdog_8000
; sync with other cpu
802F: B6 1F F0    LDA    boot_barrier_1ff0
8032: 81 03       CMPA   #$03
8034: 26 F6       BNE    $802C
8036: 8E 40 00    LDX    #$4000		; layer 2 tilemap
8039: A6 84       LDA    ,X
803B: 43          COMA
803C: A7 80       STA    ,X+
803E: B7 80 00    STA    watchdog_8000
8041: 8C 60 00    CMPX   #$6000
8044: 26 F3       BNE    $8039
8046: 7C 1F F0    INC    boot_barrier_1ff0
8049: B7 80 00    STA    watchdog_8000
; sync with other cpu
804C: B6 1F F0    LDA    boot_barrier_1ff0
804F: 81 05       CMPA   #$05
8051: 26 F6       BNE    $8049
8053: 8E 04 00    LDX    #$0400		; work RAM (shared with CPU1 $4400)
8056: A6 84       LDA    ,X
8058: 43          COMA
8059: A7 80       STA    ,X+
805B: B7 80 00    STA    watchdog_8000
805E: 8C 1F F0    CMPX   #boot_barrier_1ff0
8061: 26 F3       BNE    $8056
8063: 7C 1F F0    INC    boot_barrier_1ff0
8066: B7 80 00    STA    watchdog_8000
8069: B6 1F F0    LDA    boot_barrier_1ff0
806C: 81 07       CMPA   #$07
806E: 26 F6       BNE    $8066
; rom checksum
8070: 8E 80 00    LDX    #watchdog_8000
8073: 5F          CLRB
8074: EB 80       ADDB   ,X+
8076: B7 80 00    STA    watchdog_8000
8079: 8C 00 00    CMPX   #$0000
807C: 26 F6       BNE    $8074
807E: C1 01       CMPB   #$01
8080: 27 08       BEQ    $808A
8082: B6 1F F1    LDA    post_errors_1ff1		; POST error bits (same byte as CPU1 $5FF1)
8085: 8A 02       ORA    #$02
8087: B7 1F F1    STA    post_errors_1ff1
808A: 86 01       LDA    #$01
808C: B7 1F F3    STA    cpu2_ready_1ff3
808F: B7 80 00    STA    watchdog_8000
8092: B6 1F F3    LDA    cpu2_ready_1ff3
8095: 81 02       CMPA   #$02
8097: 26 F6       BNE    $808F
8099: 0F 00       CLR    dp_frame_parity_00		; frame parity / update-rate flag (bit0 halves the IRQ work)
809B: 0F 03       CLR    dp_state_cpu2_03
809D: 0F 05       CLR    dp_sub_cpu2_05		; CPU2 sub-state
809F: 0F 07       CLR    dp_sem_cpu2_07
80A1: 1C EF       ANDCC  #$EF		; enable interrupts

; jumped-to 1x  from $80A6
;--------------------------------------------------------------------------
; CPU2 main loop: one call, forever. All real work happens in the IRQ.
;--------------------------------------------------------------------------
mainloop_80a3:
80A3: BD B0 BF    JSR    process_event_b0bf
80A6: 20 FB       BRA    mainloop_80a3


; 1 jump-table ref
cpu2_reset_all_tables_80a8:
80A8: BD 80 BE    JSR    clear_sprite_list_80be
80AB: BD 80 E9    JSR    clear_workram_0000_0300_80e9
80AE: BD 80 FE    JSR    clear_workram_0400_0910_80fe
80B1: BD 81 35    JSR    clear_workram_0900_1000_8135
80B4: BD 81 60    JSR    clear_workram_1300_1320_8160
80B7: 0C 03       INC    dp_state_cpu2_03
80B9: 0F 05       CLR    dp_sub_cpu2_05		; CPU2 sub-state
80BB: 0F 07       CLR    dp_sem_cpu2_07
80BD: 39          RTS


; called 19x  from $80A8, $853F, $857B, $85CB, $87F4, $881F, $8840, $8892, ...
;--------------------------------------------------------------------------
; Blank the sprite display list: zero $1800-$1FF0 and $1FF8-$2000, then
; force byte +9 of every 16-byte record to $E0 so unused sprites sit off-screen.
;--------------------------------------------------------------------------
clear_sprite_list_80be:
80BE: 8E 18 00    LDX    #$1800		; sprite display list (CPU2 owns this)
80C1: CC 00 00    LDD    #$0000
80C4: 97 24       STA    $24
80C6: ED 81       STD    ,X++
80C8: 8C 1F F0    CMPX   #boot_barrier_1ff0
80CB: 25 F9       BCS    $80C6
80CD: 30 08       LEAX   $8,X
80CF: ED 81       STD    ,X++
80D1: 8C 20 00    CMPX   #$2000
80D4: 25 F9       BCS    $80CF
80D6: 8E 18 09    LDX    #$1809
80D9: 86 E0       LDA    #$E0
80DB: A7 84       STA    ,X
80DD: 30 88 10    LEAX   $10,X
80E0: 8C 20 00    CMPX   #$2000
80E3: 25 F6       BCS    $80DB
80E5: B7 80 00    STA    watchdog_8000
80E8: 39          RTS

; called 19x  from $80AB, $8542, $857E, $85CE, $87F7, $8822, $8843, $888F, ...
clear_workram_0000_0300_80e9:
80E9: 8E 00 00    LDX    #$0000		; work RAM (CPU2 only - hidden behind sound RAM on CPU1)
80EC: CC 00 00    LDD    #$0000
80EF: 97 20       STA    $20
80F1: 97 21       STA    $21
80F3: ED 81       STD    ,X++
80F5: 8C 03 00    CMPX   #$0300
80F8: 25 F9       BCS    $80F3
80FA: B7 80 00    STA    watchdog_8000
80FD: 39          RTS

; called 15x; jumped-to 4x  from $80AE, $8545, $8581, $85D1, $87FA, $8825, $8846, $8895, ...
clear_workram_0400_0910_80fe:
80FE: 8E 04 00    LDX    #$0400		; work RAM (shared with CPU1 $4400)
8101: CC 00 00    LDD    #$0000
8104: 97 30       STA    $30
8106: 97 31       STA    $31
8108: 97 34       STA    $34
810A: 97 35       STA    $35
810C: 97 36       STA    $36
810E: 97 37       STA    $37
8110: 97 3A       STA    $3A
8112: 97 3B       STA    $3B
8114: 97 32       STA    $32
8116: 97 33       STA    $33
8118: 97 38       STA    $38
811A: 97 39       STA    $39
811C: ED 81       STD    ,X++
811E: 8C 09 10    CMPX   #$0910
8121: 25 F9       BCS    $811C
8123: 8E 04 10    LDX    #$0410
8126: CC 28 FF    LDD    #$28FF
8129: E7 84       STB    ,X
812B: 30 88 20    LEAX   $20,X
812E: 4A          DECA
812F: 26 F8       BNE    $8129
8131: B7 80 00    STA    watchdog_8000
8134: 39          RTS

; called 11x; jumped-to 4x  from $80B1, $8548, $8584, $85D4, $87FD, $8828, $8849, $88E2, ...
clear_workram_0900_1000_8135:
8135: 8E 09 00    LDX    #$0900		; work RAM (shared with CPU1 $4400)
8138: CC 00 00    LDD    #$0000
813B: 97 40       STA    $40
813D: 97 42       STA    $42
813F: 97 41       STA    $41
8141: 97 45       STA    $45
8143: 97 47       STA    $47
8145: 97 46       STA    $46
8147: ED 81       STD    ,X++
8149: 8C 10 00    CMPX   #$1000
814C: 25 F9       BCS    $8147
814E: 8E 09 00    LDX    #$0900
8151: CC 70 FF    LDD    #$70FF
8154: E7 84       STB    ,X
8156: 30 88 10    LEAX   $10,X
8159: 4A          DECA
815A: 26 F8       BNE    $8154
815C: B7 80 00    STA    watchdog_8000
815F: 39          RTS

; called 5x; jumped-to 8x  from $80B4, $854B, $8587, $85D7, $87EC, $882B, $88E5, $89B1, ...
clear_workram_1300_1320_8160:
8160: 8E 13 00    LDX    #$1300		; work RAM (shared with CPU1 $4400)
8163: CC 00 00    LDD    #$0000
8166: DD 67       STD    $67
8168: ED 81       STD    ,X++
816A: 8C 13 20    CMPX   #$1320
816D: 25 F9       BCS    $8168
816F: B7 80 00    STA    watchdog_8000
8172: 39          RTS


;--------------------------------------------------------------------------
; CPU2 IRQ (once per frame).
; Short path when dp_frame_parity_00 bit0 is set: rebuild the sprite list,
; trigger the sprite latch, re-arm the bank, ack.
; Long path: GAME STATE BARRIER
; LDA dp_state_cpu2_03 / CMPA dp_state_cpu1_02 / BHI skip
; then dispatch the CPU2 state handler through jump_table_81ad.
; $819E writes sprite_latch_1ff2 - that write is what makes the sprite chip
; copy bytes 4-9 to 10-15 of every record at the next VBLANK. Without it
; nothing is ever displayed.
;--------------------------------------------------------------------------
cpu2_irq_8173:  ; [global]
8173: 0C 0F       INC    dp_irqcount2_0f		; CPU2 IRQ/frame counter
8175: 96 00       LDA    dp_frame_parity_00		; frame parity / update-rate flag (bit0 halves the IRQ work)
8177: 84 01       ANDA   #$01
8179: 26 1A       BNE    $8195
817B: 96 03       LDA    dp_state_cpu2_03
817D: 91 02       CMPA   dp_state_cpu1_02
817F: 22 08       BHI    $8189
; wait until game states are "synchronized" on both cpus
8181: 8E 81 AD    LDX    #jump_table_81ad
8184: 96 03       LDA    dp_state_cpu2_03
8186: 48          ASLA
8187: AD 96       JSR    [A,X]		; [indirect_jump] [nb_entries=9]
8189: 96 1A       LDA    dp_bank2_shadow_1a		; shadow of CPU2 ROM bank latch, re-armed every IRQ
818B: B7 D8 03    STA    bank2_select_d803
818E: B7 80 00    STA    watchdog_8000
8191: B7 88 00    STA    irq_ack_8800
8194: 3B          RTI
8195: BD 81 BB    JSR    build_sprite_list_81bb
8198: BD 83 0D    JSR    function_830d
819B: BD 84 8B    JSR    function_848b
819E: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
81A1: 96 1A       LDA    dp_bank2_shadow_1a
81A3: B7 D8 03    STA    bank2_select_d803
81A6: B7 80 00    STA    watchdog_8000
81A9: B7 88 00    STA    irq_ack_8800
81AC: 3B          RTI


; called 9x  from $8195, $859C, $87CC, $885C, $896B, $8982, $8A37, $8AE3, ...
;--------------------------------------------------------------------------
; Walk the four object tables ($1000, $0410, $0900, ...) and emit visible
; objects into the sprite display list at $1800. DP $20/$21 hold the running
; sprite count; the list is capped and the routine bails out at $8260 when full.
;--------------------------------------------------------------------------
build_sprite_list_81bb:
81BB: 96 52       LDA    $52
81BD: 9B 53       ADDA   $53
81BF: 9B 32       ADDA   $32
81C1: 9B 33       ADDA   $33
81C3: 9B 41       ADDA   $41
81C5: 9B 46       ADDA   $46
81C7: 97 20       STA    $20
81C9: 26 01       BNE    $81CC
81CB: 39          RTS
81CC: 97 21       STA    $21
81CE: 8E 18 00    LDX    #$1800		; sprite display list (CPU2 owns this)
81D1: CC 00 00    LDD    #$0000
81D4: E7 86       STB    A,X
81D6: 8B 10       ADDA   #$10
81D8: 2A FA       BPL    $81D4
81DA: 96 52       LDA    $52
81DC: 9B 53       ADDA   $53
81DE: 27 1B       BEQ    $81FB
81E0: CE 10 00    LDU    #$1000		; work RAM (shared with CPU1 $4400)
81E3: 97 55       STA    $55
81E5: E6 C4       LDB    ,U
81E7: 2B 0D       BMI    $81F6
81E9: A6 44       LDA    $4,U
81EB: 44          LSRA
81EC: 6C 86       INC    A,X
81EE: 0A 21       DEC    $21
81F0: 27 6E       BEQ    $8260
81F2: 0A 55       DEC    $55
81F4: 27 05       BEQ    $81FB
81F6: 33 C8 10    LEAU   $10,U
81F9: 20 EA       BRA    $81E5
81FB: 96 32       LDA    $32
81FD: 9B 33       ADDA   $33
81FF: 27 21       BEQ    $8222
8201: CE 04 10    LDU    #$0410
8204: 97 35       STA    $35
8206: E6 C4       LDB    ,U
8208: 2B 0D       BMI    $8217
820A: A6 45       LDA    $5,U
820C: 44          LSRA
820D: 6C 86       INC    A,X
820F: 0A 21       DEC    $21
8211: 27 4D       BEQ    $8260
8213: 0A 35       DEC    $35
8215: 27 0B       BEQ    $8222
8217: 33 C8 20    LEAU   $20,U
821A: 11 83 09 00 CMPU   #$0900
821E: 25 E6       BCS    $8206
8220: 20 FE       BRA    $8220
8222: 96 41       LDA    $41
8224: 27 1B       BEQ    $8241
8226: CE 09 00    LDU    #$0900
8229: 97 42       STA    $42
822B: E6 C4       LDB    ,U
822D: 2B 0D       BMI    $823C
822F: A6 44       LDA    $4,U
8231: 44          LSRA
8232: 6C 86       INC    A,X
8234: 0A 21       DEC    $21
8236: 27 28       BEQ    $8260
8238: 0A 42       DEC    $42
823A: 27 05       BEQ    $8241
823C: 33 C8 10    LEAU   $10,U
823F: 20 EA       BRA    $822B
8241: 96 46       LDA    $46
8243: 27 1B       BEQ    $8260
8245: CE 0C 00    LDU    #$0C00
8248: 97 47       STA    $47
824A: E6 C4       LDB    ,U
824C: 2B 0D       BMI    $825B
824E: A6 44       LDA    $4,U
8250: 44          LSRA
8251: 6C 86       INC    A,X
8253: 0A 21       DEC    $21
8255: 27 09       BEQ    $8260
8257: 0A 47       DEC    $47
8259: 27 05       BEQ    $8260
825B: 33 C8 10    LEAU   $10,U
825E: 20 EA       BRA    $824A
8260: CC 00 08    LDD    #$0008
8263: A7 01       STA    $1,X
8265: AB 84       ADDA   ,X
8267: 30 88 10    LEAX   $10,X
826A: A7 01       STA    $1,X
826C: 5A          DECB
826D: 26 F6       BNE    $8265
826F: 8E 00 00    LDX    #$0000		; work RAM (CPU2 only - hidden behind sound RAM on CPU1)
8272: 10 8E 18 01 LDY    #$1801
8276: 96 20       LDA    $20
8278: 97 21       STA    $21
827A: 96 52       LDA    $52
827C: 9B 53       ADDA   $53
827E: 27 21       BEQ    $82A1
8280: CE 10 00    LDU    #$1000
8283: 97 55       STA    $55
8285: A6 C4       LDA    ,U
8287: 2B 13       BMI    $829C
8289: A6 44       LDA    $4,U
828B: 44          LSRA
828C: E6 A6       LDB    A,Y
828E: 58          ASLB
828F: EF 85       STU    B,X
8291: 6C A6       INC    A,Y
8293: 0A 21       DEC    $21
8295: 26 01       BNE    $8298
8297: 39          RTS
8298: 0A 55       DEC    $55
829A: 27 05       BEQ    $82A1
829C: 33 C8 10    LEAU   $10,U
829F: 20 E4       BRA    $8285
82A1: 96 32       LDA    $32
82A3: 9B 33       ADDA   $33
82A5: 27 20       BEQ    $82C7
82A7: CE 04 10    LDU    #$0410
82AA: 97 35       STA    $35
82AC: A6 C4       LDA    ,U
82AE: 2B 12       BMI    $82C2
82B0: A6 45       LDA    $5,U
82B2: 44          LSRA
82B3: E6 A6       LDB    A,Y
82B5: 58          ASLB
82B6: EF 85       STU    B,X
82B8: 6C A6       INC    A,Y
82BA: 0A 21       DEC    $21
82BC: 27 4B       BEQ    $8309
82BE: 0A 35       DEC    $35
82C0: 27 05       BEQ    $82C7
82C2: 33 C8 20    LEAU   $20,U
82C5: 20 E5       BRA    $82AC
82C7: 96 41       LDA    $41
82C9: 27 20       BEQ    $82EB
82CB: CE 09 00    LDU    #$0900
82CE: 97 42       STA    $42
82D0: A6 C4       LDA    ,U
82D2: 2B 12       BMI    $82E6
82D4: A6 44       LDA    $4,U
82D6: 44          LSRA
82D7: E6 A6       LDB    A,Y
82D9: 58          ASLB
82DA: EF 85       STU    B,X
82DC: 6C A6       INC    A,Y
82DE: 0A 21       DEC    $21
82E0: 27 27       BEQ    $8309
82E2: 0A 42       DEC    $42
82E4: 27 05       BEQ    $82EB
82E6: 33 C8 10    LEAU   $10,U
82E9: 20 E5       BRA    $82D0
82EB: CE 0C 00    LDU    #$0C00
82EE: 96 46       LDA    $46
82F0: 97 47       STA    $47
82F2: A6 C4       LDA    ,U
82F4: 2B 0E       BMI    $8304
82F6: A6 44       LDA    $4,U
82F8: 44          LSRA
82F9: E6 A6       LDB    A,Y
82FB: 58          ASLB
82FC: EF 85       STU    B,X
82FE: 6C A6       INC    A,Y
8300: 0A 21       DEC    $21
8302: 27 05       BEQ    $8309
8304: 33 C8 10    LEAU   $10,U
8307: 20 E9       BRA    $82F2
8309: B7 80 00    STA    watchdog_8000
830C: 39          RTS

; called 9x  from $8198, $859F, $87CF, $885F, $896E, $8985, $8A3A, $8AE6, ...
function_830d:
830D: 8E 00 00    LDX    #$0000		; work RAM (CPU2 only - hidden behind sound RAM on CPU1)
8310: 10 8E 18 00 LDY    #$1800		; sprite display list (CPU2 owns this)
8314: 96 20       LDA    $20
8316: 26 01       BNE    $8319
8318: 39          RTS
8319: 97 21       STA    $21
831B: 0F 24       CLR    $24
831D: CE 83 33    LDU    #jump_table_8333
8320: A6 94       LDA    [,X]
8322: 84 70       ANDA   #$70
8324: 44          LSRA
8325: 44          LSRA
8326: 44          LSRA
8327: AD D6       JSR    [A,U]		; [indirect_jump] [nb_entries=8]
8329: 30 02       LEAX   $2,X
832B: 0A 21       DEC    $21
832D: 26 EE       BNE    $831D
832F: B7 80 00    STA    watchdog_8000
8332: 39          RTS


; 4 jump-table ref
function_8343:
8343: 34 10       PSHS   X
8345: EE 84       LDU    ,X
8347: 8E 84 9B    LDX    #$849B		; ROM
834A: A6 C4       LDA    ,U
834C: 44          LSRA
834D: 44          LSRA
834E: A6 86       LDA    A,X		; [rom_address]
8350: B7 D8 03    STA    bank2_select_d803
8353: AE 5E       LDX    -$2,U
8355: A6 80       LDA    ,X+
8357: 97 25       STA    $25
8359: EC 5A       LDD    -$6,U
835B: 47          ASRA
835C: 56          RORB
835D: 47          ASRA
835E: 56          RORB
835F: 47          ASRA
8360: 56          RORB
8361: 47          ASRA
8362: 56          RORB
8363: DD 26       STD    $26
8365: EC 5C       LDD    -$4,U
8367: 47          ASRA
8368: 56          RORB
8369: 47          ASRA
836A: 56          RORB
836B: 47          ASRA
836C: 56          RORB
836D: 47          ASRA
836E: 56          RORB
836F: DD 28       STD    $28
8371: A6 41       LDA    $1,U
8373: 84 02       ANDA   #$02
8375: 26 1D       BNE    $8394
8377: EC 84       LDD    ,X
8379: ED 24       STD    $4,Y
837B: E6 03       LDB    $3,X
837D: 1D          SEX
837E: D3 26       ADDD   $26
8380: 10 83 01 40 CMPD   #$0140
8384: 2C 47       BGE    $83CD
8386: 10 83 FF E0 CMPD   #$FFE0
838A: 2D 41       BLT    $83CD
838C: 84 01       ANDA   #$01
838E: AA 44       ORA    $4,U
8390: ED 26       STD    $6,Y
8392: 20 1D       BRA    $83B1
8394: EC 84       LDD    ,X
8396: 88 20       EORA   #$20
8398: ED 24       STD    $4,Y
839A: E6 04       LDB    $4,X
839C: 1D          SEX
839D: D3 26       ADDD   $26
839F: 10 83 01 40 CMPD   #$0140
83A3: 2C 28       BGE    $83CD
83A5: 10 83 FF E0 CMPD   #$FFE0
83A9: 2D 22       BLT    $83CD
83AB: 84 01       ANDA   #$01
83AD: AA 44       ORA    $4,U
83AF: ED 26       STD    $6,Y
83B1: E6 05       LDB    $5,X
83B3: 1D          SEX
83B4: D3 28       ADDD   $28
83B6: 10 83 00 E0 CMPD   #$00E0
83BA: 2C 11       BGE    $83CD
83BC: 10 83 FF E0 CMPD   #$FFE0
83C0: 2D 0B       BLT    $83CD
83C2: A6 02       LDA    $2,X
83C4: AA 45       ORA    $5,U
83C6: ED 28       STD    $8,Y
83C8: 0C 24       INC    $24
83CA: 31 A8 10    LEAY   $10,Y
83CD: 30 06       LEAX   $6,X
83CF: 0A 25       DEC    $25
83D1: 26 9E       BNE    $8371
83D3: 35 90       PULS   X,PC

; 2 jump-table ref
function_83d5:
83D5: EE 84       LDU    ,X
83D7: 34 10       PSHS   X
83D9: 86 01       LDA    #$01
83DB: B7 D8 03    STA    bank2_select_d803
83DE: AE 4E       LDX    $E,U
83E0: 27 3F       BEQ    $8421
83E2: EC 84       LDD    ,X
83E4: ED 24       STD    $4,Y
83E6: EC 4A       LDD    $A,U
83E8: 10 83 FE 00 CMPD   #$FE00
83EC: 2D 33       BLT    $8421
83EE: 10 83 14 00 CMPD   #$1400
83F2: 2C 2D       BGE    $8421
83F4: 44          LSRA
83F5: 56          RORB
83F6: 44          LSRA
83F7: 56          RORB
83F8: 44          LSRA
83F9: 56          RORB
83FA: 44          LSRA
83FB: 56          RORB
83FC: 84 01       ANDA   #$01
83FE: AA 03       ORA    $3,X
8400: AB 45       ADDA   $5,U
8402: ED 26       STD    $6,Y
8404: EC 4C       LDD    $C,U
8406: 2B 19       BMI    $8421
8408: 10 83 10 00 CMPD   #$1000
840C: 2C 13       BGE    $8421
840E: 44          LSRA
840F: 56          RORB
8410: 44          LSRA
8411: 56          RORB
8412: 44          LSRA
8413: 56          RORB
8414: 44          LSRA
8415: 56          RORB
8416: A6 02       LDA    $2,X
8418: AA 44       ORA    $4,U
841A: ED 28       STD    $8,Y
841C: 0C 24       INC    $24
841E: 31 A8 10    LEAY   $10,Y
8421: 35 90       PULS   X,PC

; 2 jump-table ref
function_8423:
8423: EE 84       LDU    ,X
8425: 34 10       PSHS   X
8427: 86 01       LDA    #$01
8429: B7 D8 03    STA    bank2_select_d803
842C: AE 4E       LDX    $E,U
842E: 27 59       BEQ    $8489
8430: A6 80       LDA    ,X+		; [bank_address]
8432: 97 25       STA    $25
8434: EC 4A       LDD    $A,U
8436: 47          ASRA
8437: 56          RORB
8438: 47          ASRA
8439: 56          RORB
843A: 47          ASRA
843B: 56          RORB
843C: 47          ASRA
843D: 56          RORB
843E: DD 26       STD    $26
8440: EC 4C       LDD    $C,U
8442: 47          ASRA
8443: 56          RORB
8444: 47          ASRA
8445: 56          RORB
8446: 47          ASRA
8447: 56          RORB
8448: 47          ASRA
8449: 56          RORB
844A: DD 28       STD    $28
844C: EC 84       LDD    ,X		; [bank_address]
844E: ED 24       STD    $4,Y
8450: E6 03       LDB    $3,X		; [bank_address]
8452: 1D          SEX
8453: D3 26       ADDD   $26
8455: 10 83 01 1F CMPD   #$011F
8459: 2E 28       BGT    $8483
845B: 10 83 FF E1 CMPD   #$FFE1
845F: 2D 22       BLT    $8483
8461: 84 01       ANDA   #$01
8463: AA 45       ORA    $5,U
8465: ED 26       STD    $6,Y
8467: E6 04       LDB    $4,X		; [bank_address]
8469: 1D          SEX
846A: D3 28       ADDD   $28
846C: 10 83 00 DF CMPD   #$00DF
8470: 2E 11       BGT    $8483
8472: 10 83 FF E1 CMPD   #$FFE1
8476: 2D 0B       BLT    $8483
8478: A6 02       LDA    $2,X		; [bank_address]
847A: AA 44       ORA    $4,U
847C: ED 28       STD    $8,Y
847E: 0C 24       INC    $24
8480: 31 A8 10    LEAY   $10,Y
8483: 30 05       LEAX   $5,X		; [bank_address]
8485: 0A 25       DEC    $25
8487: 26 C3       BNE    $844C
8489: 35 90       PULS   X,PC


; called 9x  from $819B, $85A2, $87D2, $8862, $8971, $8988, $8A3D, $8AE9, ...
function_848b:
848B: 31 29       LEAY   $9,Y
848D: 86 E0       LDA    #$E0
848F: A7 A4       STA    ,Y
8491: 31 A8 10    LEAY   $10,Y
8494: 10 8C 1F F0 CMPY   #boot_barrier_1ff0
8498: 25 F5       BCS    $848F
849A: 39          RTS


; 2 jump-table ref
function_84a7:
84A7: 8E 04 10    LDX    #$0410		; work RAM (shared with CPU1 $4400)
84AA: 96 03       LDA    dp_state_cpu2_03
84AC: 81 03       CMPA   #$03
84AE: 26 06       BNE    $84B6
84B0: 10 8E 85 0F LDY    #$850F		; ROM
84B4: 20 13       BRA    $84C9
84B6: 10 8E 84 E3 LDY    #$84E3
84BA: 96 C2       LDA    $C2
84BC: 48          ASLA
84BD: 10 AE A6    LDY    A,Y
84C0: 96 C4       LDA    $C4
84C2: 48          ASLA
84C3: 9B CF       ADDA   $CF
84C5: 48          ASLA
84C6: 10 AE A6    LDY    A,Y
84C9: BD 8D 9E    JSR    function_8d9e
84CC: 6F 04       CLR    $4,X
84CE: EC A1       LDD    ,Y++		; [rom_address]
84D0: ED 1A       STD    -$6,X
84D2: EC A4       LDD    ,Y		; [rom_address]
84D4: ED 1C       STD    -$4,X
84D6: CC FF F8    LDD    #$FFF8
84D9: ED 12       STD    -$E,X
84DB: BD B0 35    JSR    function_b035
84DE: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
84E0: 0F 07       CLR    dp_sem_cpu2_07
84E2: 39          RTS


; 1 jump-table ref
function_852a:
852A: 96 05       LDA    dp_sub_cpu2_05		; CPU2 sub-state
852C: 91 04       CMPA   dp_sub_cpu1_04		; CPU1 sub-state
852E: 23 01       BLS    $8531
8530: 39          RTS
8531: CE 85 37    LDU    #jump_table_8537
8534: 48          ASLA
8535: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]


; 1 jump-table ref
function_853b:
853B: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
853D: 0F 07       CLR    dp_sem_cpu2_07
853F: BD 80 BE    JSR    clear_sprite_list_80be
8542: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8545: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8548: BD 81 35    JSR    clear_workram_0900_1000_8135
854B: 7E 81 60    JMP    clear_workram_1300_1320_8160

; 1 jump-table ref
function_854e:
854E: 39          RTS

; 1 jump-table ref
function_854f:
854F: 96 05       LDA    dp_sub_cpu2_05		; CPU2 sub-state
8551: 91 04       CMPA   dp_sub_cpu1_04		; CPU1 sub-state
8553: 23 01       BLS    $8556
8555: 39          RTS
8556: 0D 18       TST    $18
8558: 27 01       BEQ    $855B
855A: 39          RTS
855B: CE 85 61    LDU    #jump_table_8561
855E: 48          ASLA
855F: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]


; 1 jump-table ref
function_8567:
8567: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
8569: 0F 07       CLR    dp_sem_cpu2_07
856B: CC 00 00    LDD    #$0000
856E: DD 80       STD    $80
8570: C6 08       LDB    #$08
8572: DD 82       STD    $82
8574: CC 00 08    LDD    #$0008
8577: DD 11       STD    $11
8579: 0F 13       CLR    $13
857B: BD 80 BE    JSR    clear_sprite_list_80be
857E: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8581: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8584: BD 81 35    JSR    clear_workram_0900_1000_8135
8587: BD 81 60    JSR    clear_workram_1300_1320_8160
858A: 7E B0 9A    JMP    $B09A
; wait for sync from cpu1 (during irq, argh)

; 1 jump-table ref  from $858F
function_858d:
858D: 96 06       LDA    dp_sem_cpu1_06
858F: 26 FC       BNE    function_858d		; [semwait]
8591: 0F 07       CLR    dp_sem_cpu2_07
8593: 96 06       LDA    dp_sem_cpu1_06
8595: 81 01       CMPA   #$01
8597: 26 FA       BNE    $8593		; [semwait]
8599: BD 85 DA    JSR    function_85da
859C: BD 81 BB    JSR    build_sprite_list_81bb
859F: BD 83 0D    JSR    function_830d
85A2: BD 84 8B    JSR    function_848b
85A5: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
85A8: 96 13       LDA    $13
85AA: 4C          INCA
85AB: 84 3F       ANDA   #$3F
85AD: 97 13       STA    $13
85AF: 27 03       BEQ    $85B4
85B1: 0C 07       INC    dp_sem_cpu2_07
85B3: 39          RTS
85B4: CE 16 11    LDU    #$1611		; direct page (shared with CPU1 $5600)
85B7: CC 99 99    LDD    #$9999
85BA: BD 88 B2    JSR    function_88b2
85BD: DC 11       LDD    $11
85BF: 27 03       BEQ    $85C4
85C1: 0C 07       INC    dp_sem_cpu2_07
85C3: 39          RTS
85C4: 0C 04       INC    dp_sub_cpu1_04		; CPU1 sub-state
85C6: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
85C8: 0C 07       INC    dp_sem_cpu2_07
85CA: 39          RTS

; 1 jump-table ref
function_85cb:
85CB: BD 80 BE    JSR    clear_sprite_list_80be
85CE: BD 80 E9    JSR    clear_workram_0000_0300_80e9
85D1: BD 80 FE    JSR    clear_workram_0400_0910_80fe
85D4: BD 81 35    JSR    clear_workram_0900_1000_8135
85D7: 7E 81 60    JMP    clear_workram_1300_1320_8160

; called 5x  from $8599, $8859, $8A34, $8AE0, $8B8E
function_85da:
85DA: 96 37       LDA    $37
85DC: 26 05       BNE    $85E3
85DE: 97 33       STA    $33
85E0: 97 39       STA    $39
85E2: 39          RTS
85E3: 8E 04 30    LDX    #$0430		; work RAM (shared with CPU1 $4400)
85E6: 97 3B       STA    $3B
85E8: 0F 33       CLR    $33
85EA: 0F 39       CLR    $39
85EC: A6 84       LDA    ,X
85EE: 81 FF       CMPA   #$FF
85F0: 27 5C       BEQ    $864E
85F2: 84 7F       ANDA   #$7F
85F4: 81 20       CMPA   #$20
85F6: 24 56       BCC    $864E
85F8: 8D 60       BSR    function_865a
85FA: A6 84       LDA    ,X
85FC: 2B 4B       BMI    $8649
85FE: CE 86 93    LDU    #$8693		; ROM
8601: 81 13       CMPA   #$13
8603: 26 03       BNE    $8608
8605: CE 86 FD    LDU    #jump_table_86fd
8608: E6 01       LDB    $1,X
860A: C4 FC       ANDB   #$FC
860C: 54          LSRB
860D: AD D5       JSR    [B,U]		; [indirect_jump] [nb_entries=53]
860F: A6 84       LDA    ,X
8611: 2B 36       BMI    $8649
8613: A6 14       LDA    -$C,X
8615: 27 32       BEQ    $8649
8617: CE EB 27    LDU    #$EB27
861A: A6 02       LDA    $2,X
861C: 84 7C       ANDA   #$7C
861E: 44          LSRA
861F: EE C6       LDU    A,U
8621: A6 15       LDA    -$B,X
8623: 4C          INCA
8624: 84 0F       ANDA   #$0F
8626: A7 15       STA    -$B,X
8628: E6 C6       LDB    A,U
862A: C1 FF       CMPB   #$FF
862C: 27 12       BEQ    $8640
862E: C1 F0       CMPB   #$F0
8630: 25 12       BCS    $8644
8632: 10 8E 86 53 LDY    #$8653
8636: C4 0F       ANDB   #$0F
8638: A6 A5       LDA    B,Y
863A: A7 0A       STA    $A,X
863C: 6F 14       CLR    -$C,X
863E: 20 09       BRA    $8649
8640: 6F 15       CLR    -$B,X
8642: E6 C4       LDB    ,U
8644: BD B4 29    JSR    function_b429
8647: 6F 14       CLR    -$C,X
8649: 0A 3B       DEC    $3B
864B: 26 01       BNE    $864E
864D: 39          RTS
864E: 30 88 20    LEAX   $20,X
8651: 20 99       BRA    $85EC


; called 1x  from $85F8
function_865a:
865A: EC 1C       LDD    -$4,X
865C: 10 83 FC 00 CMPD   #$FC00
8660: 2D 28       BLT    $868A
8662: 10 83 10 00 CMPD   #$1000
8666: 2C 22       BGE    $868A
8668: EC 1A       LDD    -$6,X
866A: 10 83 15 00 CMPD   #$1500
866E: 2C 1A       BGE    $868A
8670: 10 83 FD 00 CMPD   #$FD00
8674: 2D 14       BLT    $868A
8676: A6 84       LDA    ,X
8678: 84 7F       ANDA   #$7F
867A: A7 84       STA    ,X
867C: 0C 33       INC    $33
867E: 0C 39       INC    $39
8680: E6 07       LDB    $7,X
8682: E1 01       CMPB   $1,X
8684: 26 01       BNE    $8687
8686: 39          RTS
8687: 7E B4 29    JMP    function_b429
868A: 86 FF       LDA    #$FF
868C: A7 84       STA    ,X
868E: 0A 31       DEC    $31
8690: 0A 37       DEC    $37
8692: 39          RTS


; 13 jump-table ref
function_8767:
8767: 39          RTS


; 1 jump-table ref
function_8768:
8768: 96 05       LDA    dp_sub_cpu2_05		; CPU2 sub-state
876A: 91 04       CMPA   dp_sub_cpu1_04		; CPU1 sub-state
876C: 23 01       BLS    $876F
876E: 39          RTS
876F: CE 87 75    LDU    #jump_table_8775
8772: 48          ASLA
8773: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=10]


; 1 jump-table ref
function_8789:
8789: 0F 91       CLR    $91
878B: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
878D: 0F 07       CLR    dp_sem_cpu2_07
878F: 39          RTS

; 1 jump-table ref
function_8790:
8790: 86 03       LDA    #$03
8792: B7 04 10    STA    $0410		; work RAM (shared with CPU1 $4400)
8795: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
8797: 0F 07       CLR    dp_sem_cpu2_07
8799: 39          RTS

; 1 jump-table ref
function_879a:
879A: 0F 07       CLR    dp_sem_cpu2_07
879C: 96 06       LDA    dp_sem_cpu1_06
879E: 81 01       CMPA   #$01
87A0: 26 FA       BNE    $879C		; [semwait]
87A2: BD 98 9D    JSR    function_989d
87A5: 0C 07       INC    dp_sem_cpu2_07
87A7: 0D 18       TST    $18
87A9: 27 01       BEQ    $87AC
87AB: 39          RTS
87AC: BD B2 78    JSR    function_b278
87AF: 0C 07       INC    dp_sem_cpu2_07
87B1: BD CE A3    JSR    function_cea3
87B4: 0C 07       INC    dp_sem_cpu2_07
87B6: 96 06       LDA    dp_sem_cpu1_06
87B8: 81 02       CMPA   #$02
87BA: 25 FA       BCS    $87B6		; [semwait]
87BC: BD D1 B2    JSR    function_d1b2
87BF: 0C 07       INC    dp_sem_cpu2_07
87C1: BD AC AC    JSR    function_acac
87C4: 0C 07       INC    dp_sem_cpu2_07
87C6: 96 06       LDA    dp_sem_cpu1_06
87C8: 81 03       CMPA   #$03
87CA: 25 FA       BCS    $87C6		; [semwait]
87CC: BD 81 BB    JSR    build_sprite_list_81bb
87CF: BD 83 0D    JSR    function_830d
87D2: BD 84 8B    JSR    function_848b
87D5: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
87D8: 0C 07       INC    dp_sem_cpu2_07
87DA: BD AD C0    JSR    function_adc0
87DD: 7E AD 08    JMP    function_ad08

; 1 jump-table ref
function_87e0:
87E0: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
87E2: 0F 07       CLR    dp_sem_cpu2_07
87E4: 39          RTS

; 1 jump-table ref
function_87e5:
87E5: 96 67       LDA    $67
87E7: 91 68       CMPA   $68
87E9: 27 01       BEQ    $87EC
87EB: 39          RTS
87EC: BD 81 60    JSR    clear_workram_1300_1320_8160
87EF: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
87F1: 0F 07       CLR    dp_sem_cpu2_07
87F3: 39          RTS

; 1 jump-table ref
function_87f4:
87F4: BD 80 BE    JSR    clear_sprite_list_80be
87F7: BD 80 E9    JSR    clear_workram_0000_0300_80e9
87FA: BD 80 FE    JSR    clear_workram_0400_0910_80fe
87FD: 7E 81 35    JMP    clear_workram_0900_1000_8135


; 1 jump-table ref
function_8800:
8800: 96 05       LDA    dp_sub_cpu2_05		; CPU2 sub-state
8802: 91 04       CMPA   dp_sub_cpu1_04		; CPU1 sub-state
8804: 23 01       BLS    $8807
8806: 39          RTS
8807: CE 88 0D    LDU    #jump_table_880d
880A: 48          ASLA
880B: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=7]


; 1 jump-table ref
function_881b:
881B: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
881D: 0F 07       CLR    dp_sem_cpu2_07
881F: BD 80 BE    JSR    clear_sprite_list_80be
8822: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8825: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8828: BD 81 35    JSR    clear_workram_0900_1000_8135
882B: 7E 81 60    JMP    clear_workram_1300_1320_8160

; 1 jump-table ref
function_882e:
882E: 39          RTS

; 1 jump-table ref
function_882f:
882F: 39          RTS

; 1 jump-table ref
function_8830:
8830: CC 00 00    LDD    #$0000
8833: DD 80       STD    $80
8835: C6 08       LDB    #$08
8837: DD 82       STD    $82
8839: CC 00 03    LDD    #$0003
883C: DD 11       STD    $11
883E: 0F 13       CLR    $13
8840: BD 80 BE    JSR    clear_sprite_list_80be
8843: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8846: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8849: BD 81 35    JSR    clear_workram_0900_1000_8135
884C: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
884E: 0F 07       CLR    dp_sem_cpu2_07
8850: 7E B0 9A    JMP    $B09A

; 1 jump-table ref  from $8857
function_8853:
8853: 96 D2       LDA    $D2
8855: 81 01       CMPA   #$01
8857: 26 FA       BNE    function_8853		; [semwait]
8859: BD 85 DA    JSR    function_85da
885C: BD 81 BB    JSR    build_sprite_list_81bb
885F: BD 83 0D    JSR    function_830d
8862: BD 84 8B    JSR    function_848b
8865: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
8868: 96 13       LDA    $13
886A: 4C          INCA
886B: 84 3F       ANDA   #$3F
886D: 97 13       STA    $13
886F: 27 03       BEQ    $8874
8871: 0C D2       INC    $D2
8873: 39          RTS
8874: CE 16 11    LDU    #$1611		; direct page (shared with CPU1 $5600)
8877: CC 99 99    LDD    #$9999
887A: BD 88 B2    JSR    function_88b2
887D: DC 11       LDD    $11
887F: 27 03       BEQ    $8884
8881: 0C D2       INC    $D2
8883: 39          RTS
8884: 0C 04       INC    dp_sub_cpu1_04		; CPU1 sub-state
8886: 0F 06       CLR    dp_sem_cpu1_06
8888: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
888A: 0F 07       CLR    dp_sem_cpu2_07
888C: 0C D2       INC    $D2
888E: 39          RTS

; 1 jump-table ref
function_888f:
888F: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8892: BD 80 BE    JSR    clear_sprite_list_80be
8895: 7E 80 FE    JMP    clear_workram_0400_0910_80fe

; 1 jump-table ref
function_8898:
8898: 39          RTS

8899: 34 06       PSHS   D		; [manual_stack_push]
889B: A6 42       LDA    $2,U
889D: AB 61       ADDA   $1,S		; [local]
889F: 19          DAA
88A0: A7 42       STA    $2,U
88A2: A6 41       LDA    $1,U
88A4: A9 E4       ADCA   ,S		; [local]
88A6: 19          DAA
88A7: A7 41       STA    $1,U
88A9: A6 C4       LDA    ,U
88AB: 89 00       ADCA   #$00
88AD: 19          DAA
88AE: A7 C4       STA    ,U
88B0: 35 86       PULS   D,PC		; [manual_stack_pull]


; called 7x; jumped-to 2x  from $85BA, $887A, $8A55, $8B01, $9F5A, $9F68, $A31B, $A68B, ...
function_88b2:
88B2: 34 06       PSHS   D		; [manual_stack_push]
88B4: A6 41       LDA    $1,U
88B6: AB 61       ADDA   $1,S		; [local]
88B8: 19          DAA
88B9: A7 41       STA    $1,U
88BB: A6 C4       LDA    ,U
88BD: A9 E4       ADCA   ,S		; [local]
88BF: 19          DAA
88C0: A7 C4       STA    ,U
88C2: 35 86       PULS   D,PC		; [manual_stack_pull]


; 1 jump-table ref
function_88c4:
88C4: 96 05       LDA    dp_sub_cpu2_05		; CPU2 sub-state
88C6: 91 04       CMPA   dp_sub_cpu1_04		; CPU1 sub-state
88C8: 23 01       BLS    $88CB
88CA: 39          RTS
88CB: CE 88 D1    LDU    #jump_table_88d1
88CE: 48          ASLA
88CF: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]


; 1 jump-table ref
function_88d5:
88D5: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
88D7: 0F 07       CLR    dp_sem_cpu2_07
88D9: BD 80 BE    JSR    clear_sprite_list_80be
88DC: BD 80 E9    JSR    clear_workram_0000_0300_80e9
88DF: BD 80 FE    JSR    clear_workram_0400_0910_80fe
88E2: BD 81 35    JSR    clear_workram_0900_1000_8135
88E5: 7E 81 60    JMP    clear_workram_1300_1320_8160

; 1 jump-table ref
function_88e8:
88E8: 39          RTS

; 1 jump-table ref
function_88e9:
88E9: 96 05       LDA    dp_sub_cpu2_05		; CPU2 sub-state
88EB: 91 04       CMPA   dp_sub_cpu1_04		; CPU1 sub-state
88ED: 23 01       BLS    $88F0
88EF: 39          RTS
88F0: CE 88 F6    LDU    #jump_table_88f6
88F3: 48          ASLA
88F4: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=13]


; 1 jump-table ref
function_8910:
8910: 0F 91       CLR    $91
8912: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
8914: 0F 07       CLR    dp_sem_cpu2_07
8916: 39          RTS

; 1 jump-table ref
function_8917:
8917: 86 FF       LDA    #$FF
8919: 97 07       STA    dp_sem_cpu2_07
891B: B7 80 00    STA    watchdog_8000
891E: 96 06       LDA    dp_sem_cpu1_06
8920: 2A F9       BPL    $891B		; [semwait]
8922: 0F 06       CLR    dp_sem_cpu1_06
8924: 0D 07       TST    dp_sem_cpu2_07
8926: 26 FC       BNE    $8924		; [semwait]
8928: B7 80 00    STA    watchdog_8000
892B: 96 06       LDA    dp_sem_cpu1_06
892D: 81 01       CMPA   #$01
892F: 25 F7       BCS    $8928		; [semwait]
8931: BD 98 9D    JSR    function_989d
8934: 0C 07       INC    dp_sem_cpu2_07
8936: B6 04 10    LDA    $0410		; work RAM (shared with CPU1 $4400)
8939: 81 FF       CMPA   #$FF
893B: 27 45       BEQ    $8982
893D: 0D 1F       TST    $1F
893F: 2B 41       BMI    $8982
8941: 0D 91       TST    $91
8943: 26 3D       BNE    $8982
8945: BD B2 78    JSR    function_b278
8948: 0C 07       INC    dp_sem_cpu2_07
894A: BD CE A3    JSR    function_cea3
894D: 0C 07       INC    dp_sem_cpu2_07
894F: B7 80 00    STA    watchdog_8000
8952: 96 06       LDA    dp_sem_cpu1_06
8954: 81 02       CMPA   #$02
8956: 25 F7       BCS    $894F		; [semwait]
8958: BD D1 B2    JSR    function_d1b2
895B: 0C 07       INC    dp_sem_cpu2_07
895D: BD AC AC    JSR    function_acac
8960: 0C 07       INC    dp_sem_cpu2_07
8962: B7 80 00    STA    watchdog_8000
8965: 96 06       LDA    dp_sem_cpu1_06
8967: 81 04       CMPA   #$04
8969: 25 F7       BCS    $8962		; [semwait]
896B: BD 81 BB    JSR    build_sprite_list_81bb
896E: BD 83 0D    JSR    function_830d
8971: BD 84 8B    JSR    function_848b
8974: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
8977: 0C 07       INC    dp_sem_cpu2_07
8979: BD AD C0    JSR    function_adc0
897C: BD AD 08    JSR    function_ad08
897F: 0C 07       INC    dp_sem_cpu2_07
8981: 39          RTS
8982: BD 81 BB    JSR    build_sprite_list_81bb
8985: BD 83 0D    JSR    function_830d
8988: BD 84 8B    JSR    function_848b
898B: B7 1F F2    STA    sprite_latch_1ff2
898E: 39          RTS

; 1 jump-table ref
function_898f:
898F: 39          RTS

; 1 jump-table ref
function_8990:
8990: CE 89 9D    LDU    #jump_table_899d
8993: 96 07       LDA    dp_sem_cpu2_07
8995: 91 06       CMPA   dp_sem_cpu1_06
8997: 23 01       BLS    $899A		; [no_semwait]
8999: 39          RTS
899A: 48          ASLA
899B: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]


; 1 jump-table ref
function_89a5:
89A5: 0C 07       INC    dp_sem_cpu2_07
89A7: 39          RTS

; 1 jump-table ref
function_89a8:
89A8: 96 67       LDA    $67
89AA: 91 68       CMPA   $68
89AC: 27 01       BEQ    $89AF
89AE: 39          RTS
89AF: 0C 07       INC    dp_sem_cpu2_07
89B1: 7E 81 60    JMP    clear_workram_1300_1320_8160

; 1 jump-table ref
function_89b4:
89B4: 0C 07       INC    dp_sem_cpu2_07
89B6: BD 80 E9    JSR    clear_workram_0000_0300_80e9
89B9: BD 80 BE    JSR    clear_sprite_list_80be
89BC: BD 80 FE    JSR    clear_workram_0400_0910_80fe
89BF: 7E 81 35    JMP    clear_workram_0900_1000_8135

; 1 jump-table ref
function_89c2:
89C2: 39          RTS

; 1 jump-table ref
function_89c3:
89C3: 39          RTS

; 2 jump-table ref
function_89c4:
89C4: 39          RTS

; 2 jump-table ref
function_89c5:
89C5: 0C 05       INC    dp_sub_cpu2_05		; CPU2 sub-state
89C7: 0F 07       CLR    dp_sem_cpu2_07
89C9: 39          RTS

; 1 jump-table ref
function_89ca:
89CA: 96 07       LDA    dp_sem_cpu2_07
89CC: 91 06       CMPA   dp_sem_cpu1_06
89CE: 23 01       BLS    $89D1		; [no_semwait]
89D0: 39          RTS
89D1: CE 89 D7    LDU    #jump_table_89d7
89D4: 48          ASLA
89D5: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=10]


; 1 jump-table ref
function_89eb:
89EB: 0C 07       INC    dp_sem_cpu2_07
89ED: 39          RTS

; 1 jump-table ref
function_89ee:
89EE: 96 67       LDA    $67
89F0: 91 68       CMPA   $68
89F2: 27 01       BEQ    $89F5
89F4: 39          RTS
89F5: 0C 07       INC    dp_sem_cpu2_07
89F7: 7E 81 60    JMP    clear_workram_1300_1320_8160

; 1 jump-table ref
function_89fa:
89FA: 0C 07       INC    dp_sem_cpu2_07
89FC: BD 80 E9    JSR    clear_workram_0000_0300_80e9
89FF: BD 80 BE    JSR    clear_sprite_list_80be
8A02: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8A05: 7E 81 35    JMP    clear_workram_0900_1000_8135

; 1 jump-table ref
function_8a08:
8A08: 39          RTS

; 1 jump-table ref
function_8a09:
8A09: 39          RTS

; 1 jump-table ref
function_8a0a:
8A0A: 0C 07       INC    dp_sem_cpu2_07
8A0C: CC 00 00    LDD    #$0000
8A0F: DD 80       STD    $80
8A11: C6 08       LDB    #$08
8A13: DD 82       STD    $82
8A15: CC 00 08    LDD    #$0008
8A18: DD 11       STD    $11
8A1A: 0F 13       CLR    $13
8A1C: BD 80 BE    JSR    clear_sprite_list_80be
8A1F: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8A22: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8A25: BD 81 35    JSR    clear_workram_0900_1000_8135
8A28: BD 81 60    JSR    clear_workram_1300_1320_8160
8A2B: 7E B0 9A    JMP    $B09A

; 1 jump-table ref  from $8A32
function_8a2e:
8A2E: 96 D2       LDA    $D2
8A30: 81 01       CMPA   #$01
8A32: 26 FA       BNE    function_8a2e		; [semwait]
8A34: BD 85 DA    JSR    function_85da
8A37: BD 81 BB    JSR    build_sprite_list_81bb
8A3A: BD 83 0D    JSR    function_830d
8A3D: BD 84 8B    JSR    function_848b
8A40: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
8A43: 96 13       LDA    $13
8A45: 4C          INCA
8A46: 84 3F       ANDA   #$3F
8A48: 97 13       STA    $13
8A4A: 27 03       BEQ    $8A4F
8A4C: 0C D2       INC    $D2
8A4E: 39          RTS
8A4F: CE 16 11    LDU    #$1611		; direct page (shared with CPU1 $5600)
8A52: CC 99 99    LDD    #$9999
8A55: BD 88 B2    JSR    function_88b2
8A58: DC 11       LDD    $11
8A5A: 27 03       BEQ    $8A5F
8A5C: 0C D2       INC    $D2
8A5E: 39          RTS
8A5F: 0C 06       INC    dp_sem_cpu1_06
8A61: 0C 07       INC    dp_sem_cpu2_07
8A63: 0C D2       INC    $D2
8A65: 39          RTS

; 1 jump-table ref
function_8a66:
8A66: BD 80 BE    JSR    clear_sprite_list_80be
8A69: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8A6C: 7E 80 FE    JMP    clear_workram_0400_0910_80fe

; 1 jump-table ref
function_8a6f:
8A6F: 39          RTS

; 1 jump-table ref
function_8a70:
8A70: 39          RTS

; 2 jump-table ref
function_8a71:
8A71: 96 07       LDA    dp_sem_cpu2_07
8A73: 91 06       CMPA   dp_sem_cpu1_06
8A75: 23 01       BLS    $8A78		; [no_semwait]
8A77: 39          RTS
8A78: CE 8A 7E    LDU    #jump_table_8a7e
8A7B: 48          ASLA
8A7C: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]


; 1 jump-table ref
function_8a82:
8A82: 0C 07       INC    dp_sem_cpu2_07
8A84: BD 80 BE    JSR    clear_sprite_list_80be
8A87: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8A8A: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8A8D: BD 81 35    JSR    clear_workram_0900_1000_8135
8A90: 7E 81 60    JMP    clear_workram_1300_1320_8160

; 1 jump-table ref
function_8a93:
8A93: 39          RTS

; 1 jump-table ref
function_8a94:
8A94: 39          RTS

; 1 jump-table ref
function_8a95:
8A95: 96 07       LDA    dp_sem_cpu2_07
8A97: 91 06       CMPA   dp_sem_cpu1_06
8A99: 23 01       BLS    $8A9C		; [no_semwait]
8A9B: 39          RTS
8A9C: CE 8A A2    LDU    #jump_table_8aa2
8A9F: 48          ASLA
8AA0: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=10]


; 1 jump-table ref
function_8ab6:
8AB6: 39          RTS

; 1 jump-table ref
function_8ab7:
8AB7: 39          RTS

; 1 jump-table ref
function_8ab8:
8AB8: 39          RTS

; 1 jump-table ref
function_8ab9:
8AB9: 0C 07       INC    dp_sem_cpu2_07
8ABB: CC 00 00    LDD    #$0000
8ABE: DD 80       STD    $80
8AC0: C6 08       LDB    #$08
8AC2: DD 82       STD    $82
8AC4: CC 00 03    LDD    #$0003
8AC7: DD 11       STD    $11
8AC9: 0F 13       CLR    $13
8ACB: BD 80 BE    JSR    clear_sprite_list_80be
8ACE: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8AD1: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8AD4: BD 81 35    JSR    clear_workram_0900_1000_8135
8AD7: 7E B0 9A    JMP    $B09A

; 1 jump-table ref  from $8ADE
function_8ada:
8ADA: 96 D2       LDA    $D2
8ADC: 81 01       CMPA   #$01
8ADE: 26 FA       BNE    function_8ada
8AE0: BD 85 DA    JSR    function_85da
8AE3: BD 81 BB    JSR    build_sprite_list_81bb
8AE6: BD 83 0D    JSR    function_830d
8AE9: BD 84 8B    JSR    function_848b
8AEC: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
8AEF: 96 13       LDA    $13
8AF1: 4C          INCA
8AF2: 84 3F       ANDA   #$3F
8AF4: 97 13       STA    $13
8AF6: 27 03       BEQ    $8AFB
8AF8: 0C D2       INC    $D2
8AFA: 39          RTS
8AFB: CE 16 11    LDU    #$1611		; direct page (shared with CPU1 $5600)
8AFE: CC 99 99    LDD    #$9999
8B01: BD 88 B2    JSR    function_88b2
8B04: DC 11       LDD    $11
8B06: 27 03       BEQ    $8B0B
8B08: 0C D2       INC    $D2
8B0A: 39          RTS
8B0B: 0C 06       INC    dp_sem_cpu1_06
8B0D: 0C 07       INC    dp_sem_cpu2_07
8B0F: 0C D2       INC    $D2
8B11: 39          RTS

; 1 jump-table ref
function_8b12:
8B12: BD 80 BE    JSR    clear_sprite_list_80be
8B15: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8B18: 7E 80 FE    JMP    clear_workram_0400_0910_80fe

; 1 jump-table ref
function_8b1b:
8B1B: 39          RTS

; 1 jump-table ref
function_8b1c:
8B1C: 39          RTS

; 1 jump-table ref
function_8b1d:
8B1D: 39          RTS

; 1 jump-table ref
function_8b1e:
8B1E: 39          RTS


; 1 jump-table ref
function_8b1f:
8B1F: 96 07       LDA    dp_sem_cpu2_07
8B21: 91 06       CMPA   dp_sem_cpu1_06
8B23: 23 01       BLS    $8B26		; [no_semwait] Branch taken when semaphore_07 <= semaphore_06
8B25: 39          RTS
8B26: CE 8B 2C    LDU    #jump_table_8b2c
8B29: 48          ASLA
8B2A: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=12]


; 1 jump-table ref
function_8b44:
8B44: 0C 07       INC    dp_sem_cpu2_07
8B46: 39          RTS


; 1 jump-table ref
function_8b47:
8B47: 96 67       LDA    $67
8B49: 91 68       CMPA   $68
8B4B: 27 01       BEQ    $8B4E
8B4D: 39          RTS
8B4E: 0C 07       INC    dp_sem_cpu2_07
8B50: 7E 81 60    JMP    clear_workram_1300_1320_8160


; 1 jump-table ref
function_8b53:
8B53: 0C 07       INC    dp_sem_cpu2_07
8B55: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8B58: BD 80 BE    JSR    clear_sprite_list_80be
8B5B: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8B5E: 7E 81 35    JMP    clear_workram_0900_1000_8135

; 1 jump-table ref
function_8b61:
8B61: 39          RTS

; 1 jump-table ref
function_8b62:
8B62: 39          RTS

; 1 jump-table ref
function_8b63:
8B63: 39          RTS


; 1 jump-table ref
function_8b64:
8B64: 0C 07       INC    dp_sem_cpu2_07
8B66: CC 00 00    LDD    #$0000
8B69: DD 80       STD    $80
8B6B: C6 08       LDB    #$08
8B6D: DD 82       STD    $82
8B6F: CC 00 08    LDD    #$0008
8B72: DD 11       STD    $11
8B74: 0F 13       CLR    $13
8B76: BD 80 BE    JSR    clear_sprite_list_80be
8B79: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8B7C: BD 80 FE    JSR    clear_workram_0400_0910_80fe
8B7F: BD 81 35    JSR    clear_workram_0900_1000_8135
8B82: BD 81 60    JSR    clear_workram_1300_1320_8160
8B85: 7E B0 9A    JMP    $B09A

; 1 jump-table ref  from $8B8C
function_8b88:
8B88: 96 D2       LDA    $D2
8B8A: 81 01       CMPA   #$01
8B8C: 26 FA       BNE    function_8b88		; [semwait]
8B8E: BD 85 DA    JSR    function_85da
8B91: BD 81 BB    JSR    build_sprite_list_81bb
8B94: BD 83 0D    JSR    function_830d
8B97: BD 84 8B    JSR    function_848b
8B9A: B7 1F F2    STA    sprite_latch_1ff2		; write = tell sprite chip to buffer the list (CPU1 $5FF2)
8B9D: 0C D2       INC    $D2
8B9F: 39          RTS

; 1 jump-table ref
function_8ba0:
8BA0: BD 80 BE    JSR    clear_sprite_list_80be
8BA3: BD 80 E9    JSR    clear_workram_0000_0300_80e9
8BA6: 7E 80 FE    JMP    clear_workram_0400_0910_80fe

; 1 jump-table ref
function_8ba9:
8BA9: 39          RTS

; 1 jump-table ref
function_8baa:
8BAA: 39          RTS

; 1 jump-table ref
function_8bab:
8BAB: 39          RTS

8D90: 04 10       LSR    $10
8D92: CC 28 FF    LDD    #$28FF
8D95: E7 84       STB    ,X
8D97: 30 88 20    LEAX   $20,X
8D9A: 4A          DECA
8D9B: 26 F8       BNE    $8D95
8D9D: 39          RTS

; called 1x; jumped-to 1x  from $84C9, $8DA7
function_8d9e:
8D9E: A6 84       LDA    ,X
8DA0: 81 FF       CMPA   #$FF
8DA2: 27 05       BEQ    $8DA9
8DA4: 30 88 20    LEAX   $20,X
8DA7: 20 F5       BRA    function_8d9e
8DA9: EC A1       LDD    ,Y++		; [rom_address]
8DAB: 8A 80       ORA    #$80
8DAD: A7 84       STA    ,X
8DAF: E7 07       STB    $7,X
8DB1: EC A1       LDD    ,Y++		; [rom_address]
8DB3: ED 02       STD    $2,X
8DB5: A6 A0       LDA    ,Y+		; [rom_address]
8DB7: A7 05       STA    $5,X
8DB9: 86 80       LDA    #$80
8DBB: A7 01       STA    $1,X
8DBD: 6F 0C       CLR    $C,X
8DBF: 6F 09       CLR    $9,X
8DC1: 6F 0D       CLR    $D,X
8DC3: 6F 0E       CLR    $E,X
8DC5: 0C 31       INC    $31
8DC7: 39          RTS


; 167 jump-table ref; jumped-to 70x  from $9A25, $9A57, $9A5F, $9BA8, $9BB5, $9BE3, $9BED, $9DC6, ...
function_8dc8:
8DC8: 6F 09       CLR    $9,X
8DCA: CE 8D FB    LDU    #$8DFB		; ROM
8DCD: A6 84       LDA    ,X
8DCF: 84 7C       ANDA   #$7C
8DD1: 44          LSRA
8DD2: EE C6       LDU    A,U		; [rom_address]
8DD4: E6 07       LDB    $7,X
8DD6: E7 01       STB    $1,X
8DD8: C4 FC       ANDB   #$FC
8DDA: 54          LSRB
8DDB: EE C5       LDU    B,U		; [rom_address]
8DDD: EC C1       LDD    ,U++		; [rom_address]
8DDF: A7 0A       STA    $A,X
8DE1: E7 0B       STB    $B,X
8DE3: EC C4       LDD    ,U		; [rom_address]
8DE5: ED 1E       STD    -$2,X
8DE7: 39          RTS


; called 1x; jumped-to 191x  from $9AB8, $9ACF, $9B83, $9BBB, $9BF3, $9E89, $9EA7, $9FB8, ...
function_8de8:
8DE8: 6C 09       INC    $9,X
8DEA: E6 09       LDB    $9,X
8DEC: 58          ASLB
8DED: 58          ASLB
8DEE: 33 C5       LEAU   B,U
8DF0: EC C1       LDD    ,U++		; [rom_address]
8DF2: A7 0A       STA    $A,X
8DF4: E7 0B       STB    $B,X
8DF6: EC C4       LDD    ,U		; [rom_address]
8DF8: ED 1E       STD    -$2,X
8DFA: 39          RTS


; called 8x  from $9A90, $A877, $A88E, $A8A3, $AAF2, $AC4E, $AC6C, $AC88
function_8e05:
8E05: DC 84       LDD    $84
8E07: C4 F0       ANDB   #$F0
8E09: ED E3       STD    ,--S		; [local]
8E0B: DC 84       LDD    $84
8E0D: E3 16       ADDD   -$A,X
8E0F: DD 84       STD    $84
8E11: C4 F0       ANDB   #$F0
8E13: A3 E1       SUBD   ,S++		; [local]
8E15: 47          ASRA
8E16: 56          RORB
8E17: 57          ASRB
8E18: 57          ASRB
8E19: 57          ASRB
8E1A: 2A 01       BPL    $8E1D
8E1C: 50          NEGB
8E1D: D7 90       STB    $90
8E1F: 26 01       BNE    $8E22
8E21: 39          RTS
8E22: 6D 16       TST    -$A,X
8E24: 2A 03       BPL    $8E29
8E26: 7E 8F 51    JMP    $8F51
8E29: EC 1A       LDD    -$6,X
8E2B: 10 83 06 00 CMPD   #$0600
8E2F: 25 11       BCS    $8E42
8E31: 8D 3B       BSR    function_8e6e
8E33: 27 0D       BEQ    $8E42
8E35: BD 8E BF    JSR    function_8ebf
8E38: 26 21       BNE    $8E5B
8E3A: BD 8E EF    JSR    function_8eef
8E3D: 0A 90       DEC    $90
8E3F: 26 E8       BNE    $8E29
8E41: 39          RTS
8E42: EC 1A       LDD    -$6,X
8E44: 10 83 11 00 CMPD   #$1100
8E48: 2C 11       BGE    $8E5B
8E4A: BD 8E D1    JSR    function_8ed1
8E4D: 26 0C       BNE    $8E5B
8E4F: EC 1A       LDD    -$6,X
8E51: C3 00 10    ADDD   #$0010
8E54: ED 1A       STD    -$6,X
8E56: 0A 90       DEC    $90
8E58: 26 CF       BNE    $8E29
8E5A: 39          RTS
8E5B: DC 80       LDD    $80
8E5D: 58          ASLB
8E5E: 49          ROLA
8E5F: 58          ASLB
8E60: 49          ROLA
8E61: 58          ASLB
8E62: 49          ROLA
8E63: 58          ASLB
8E64: 49          ROLA
8E65: DD 84       STD    $84
8E67: A6 1B       LDA    -$5,X
8E69: 84 F0       ANDA   #$F0
8E6B: A7 1B       STA    -$5,X
8E6D: 39          RTS

; called 2x  from $8E31, $93E6
function_8e6e:
8E6E: 96 81       LDA    $81
8E70: 84 07       ANDA   #$07
8E72: 26 4A       BNE    $8EBE
8E74: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
8E77: E6 45       LDB    $5,U
8E79: CB 50       ADDB   #$50
8E7B: C4 7E       ANDB   #$7E
8E7D: E7 E2       STB    ,-S		; [local]
8E7F: EC 46       LDD    $6,U
8E81: C3 0E 80    ADDD   #$0E80
8E84: 84 0F       ANDA   #$0F
8E86: EB E0       ADDB   ,S+		; [local]
8E88: CE 40 00    LDU    #$4000		; layer 2 tilemap
8E8B: ED E3       STD    ,--S		; [local]
8E8D: EC CB       LDD    D,U
8E8F: C4 07       ANDB   #$07
8E91: 10 83 FF 03 CMPD   #$FF03
8E95: 26 02       BNE    $8E99
8E97: 35 86       PULS   D,PC

8E99: 96 83       LDA    $83
8E9B: 84 07       ANDA   #$07
8E9D: 26 10       BNE    $8EAF
8E9F: EC E1       LDD    ,S++		; [local]
8EA1: 83 0D 80    SUBD   #$0D80
8EA4: 84 0F       ANDA   #$0F
8EA6: EC CB       LDD    D,U
8EA8: C4 07       ANDB   #$07
8EAA: 10 83 FF 03 CMPD   #$FF03
8EAE: 39          RTS
8EAF: EC E1       LDD    ,S++		; [local]
8EB1: 83 0E 00    SUBD   #$0E00
8EB4: 84 0F       ANDA   #$0F
8EB6: EC CB       LDD    D,U
8EB8: C4 03       ANDB   #$03
8EBA: 10 83 FF 03 CMPD   #$FF03
8EBE: 39          RTS

; called 1x  from $8E35
function_8ebf:
8EBF: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
8EC2: A6 41       LDA    $1,U
8EC4: 84 70       ANDA   #$70
8EC6: 26 25       BNE    $8EED
8EC8: CC 01 00    LDD    #$0100
8ECB: BD 93 02    JSR    function_9302
8ECE: C4 01       ANDB   #$01
8ED0: 39          RTS

; called 1x  from $8E4A
function_8ed1:
8ED1: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
8ED4: A6 1B       LDA    -$5,X
8ED6: 84 70       ANDA   #$70
8ED8: A7 E2       STA    ,-S		; [local]
8EDA: A6 41       LDA    $1,U
8EDC: 84 70       ANDA   #$70
8EDE: AB E0       ADDA   ,S+		; [local]
8EE0: 84 70       ANDA   #$70
8EE2: 26 09       BNE    $8EED
8EE4: CC 01 00    LDD    #$0100
8EE7: BD 93 02    JSR    function_9302
8EEA: C4 01       ANDB   #$01
8EEC: 39          RTS
8EED: 5F          CLRB
8EEE: 39          RTS

; called 1x; jumped-to 1x  from $8E3A, $93EB
function_8eef:
8EEF: 34 10       PSHS   X
8EF1: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
8EF4: DC 80       LDD    $80
8EF6: C3 00 01    ADDD   #$0001
8EF9: DD 80       STD    $80
8EFB: DC 88       LDD    $88
8EFD: 83 00 10    SUBD   #$0010
8F00: DD 88       STD    $88
8F02: A6 41       LDA    $1,U
8F04: 84 80       ANDA   #$80
8F06: A7 E2       STA    ,-S		; [local]
8F08: E6 48       LDB    $8,U
8F0A: 1D          SEX
8F0B: E3 C4       ADDD   ,U
8F0D: ED C4       STD    ,U
8F0F: ED 50       STD    -$10,U
8F11: ED C8 E0    STD    -$20,U
8F14: C4 80       ANDB   #$80
8F16: E0 E0       SUBB   ,S+		; [local]
8F18: 27 35       BEQ    $8F4F
8F1A: 8E 15 00    LDX    #$1500
8F1D: D6 B3       LDB    $B3
8F1F: 58          ASLB
8F20: 58          ASLB
8F21: 58          ASLB
8F22: 3A          ABX
8F23: A6 84       LDA    ,X
8F25: 27 01       BEQ    $8F28
8F27: 12          NOP
8F28: DC 80       LDD    $80
8F2A: ED 01       STD    $1,X
8F2C: DC 82       LDD    $82
8F2E: ED 03       STD    $3,X
8F30: A6 45       LDA    $5,U
8F32: 8B 58       ADDA   #$58
8F34: 84 7E       ANDA   #$7E
8F36: A7 05       STA    $5,X
8F38: EC 46       LDD    $6,U
8F3A: ED 06       STD    $6,X
8F3C: A6 45       LDA    $5,U
8F3E: 8B 02       ADDA   #$02
8F40: 84 7E       ANDA   #$7E
8F42: A7 45       STA    $5,U
8F44: A7 55       STA    -$B,U
8F46: A7 C8 E5    STA    -$1B,U
8F49: 86 06       LDA    #$06
8F4B: A7 84       STA    ,X
8F4D: 0C B3       INC    $B3
8F4F: 35 90       PULS   X,PC

8F51: EC 1A       LDD    -$6,X
8F53: 10 83 06 00 CMPD   #$0600
8F57: 22 11       BHI    $8F6A
8F59: 8D 3B       BSR    function_8f96
8F5B: 27 0D       BEQ    $8F6A
8F5D: BD 8F E9    JSR    function_8fe9
8F60: 26 21       BNE    $8F83
8F62: BD 90 19    JSR    function_9019
8F65: 0A 90       DEC    $90
8F67: 26 E8       BNE    $8F51
8F69: 39          RTS
8F6A: EC 1A       LDD    -$6,X
8F6C: 10 83 00 10 CMPD   #$0010
8F70: 2D 11       BLT    $8F83
8F72: BD 8F FB    JSR    function_8ffb
8F75: 26 0C       BNE    $8F83
8F77: EC 1A       LDD    -$6,X
8F79: 83 00 10    SUBD   #$0010
8F7C: ED 1A       STD    -$6,X
8F7E: 0A 90       DEC    $90
8F80: 26 CF       BNE    $8F51
8F82: 39          RTS
8F83: DC 80       LDD    $80
8F85: 58          ASLB
8F86: 49          ROLA
8F87: 58          ASLB
8F88: 49          ROLA
8F89: 58          ASLB
8F8A: 49          ROLA
8F8B: 58          ASLB
8F8C: 49          ROLA
8F8D: DD 84       STD    $84
8F8F: A6 1B       LDA    -$5,X
8F91: 84 F0       ANDA   #$F0
8F93: A7 1B       STA    -$5,X
8F95: 39          RTS

; called 2x  from $8F59, $941D
function_8f96:
8F96: 96 81       LDA    $81
8F98: 84 07       ANDA   #$07
8F9A: 26 4C       BNE    $8FE8
8F9C: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
8F9F: E6 45       LDB    $5,U
8FA1: CB 06       ADDB   #$06
8FA3: C4 7F       ANDB   #$7F
8FA5: E7 E2       STB    ,-S		; [local]
8FA7: EC 46       LDD    $6,U
8FA9: C3 0E 80    ADDD   #$0E80
8FAC: 84 0F       ANDA   #$0F
8FAE: C4 80       ANDB   #$80
8FB0: EB E0       ADDB   ,S+		; [local]
8FB2: CE 40 00    LDU    #$4000		; layer 2 tilemap
8FB5: ED E3       STD    ,--S		; [local]
8FB7: EC CB       LDD    D,U
8FB9: C4 03       ANDB   #$03
8FBB: 10 83 FF 03 CMPD   #$FF03
8FBF: 26 02       BNE    $8FC3
8FC1: 35 86       PULS   D,PC
8FC3: 96 83       LDA    $83
8FC5: 84 07       ANDA   #$07
8FC7: 26 10       BNE    $8FD9
8FC9: EC E1       LDD    ,S++		; [local]
8FCB: 83 0D 80    SUBD   #$0D80
8FCE: 84 0F       ANDA   #$0F
8FD0: EC CB       LDD    D,U
8FD2: C4 03       ANDB   #$03
8FD4: 10 83 FF 03 CMPD   #$FF03
8FD8: 39          RTS
8FD9: EC E1       LDD    ,S++		; [local]
8FDB: 83 0E 00    SUBD   #$0E00
8FDE: 84 0F       ANDA   #$0F
8FE0: EC CB       LDD    D,U
8FE2: C4 03       ANDB   #$03
8FE4: 10 83 FF 03 CMPD   #$FF03
8FE8: 39          RTS

; called 1x  from $8F5D
function_8fe9:
8FE9: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
8FEC: A6 41       LDA    $1,U
8FEE: 84 70       ANDA   #$70
8FF0: 26 25       BNE    $9017
8FF2: CC FE 00    LDD    #$FE00
8FF5: BD 93 02    JSR    function_9302
8FF8: C4 01       ANDB   #$01
8FFA: 39          RTS

; called 1x  from $8F72
function_8ffb:
8FFB: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
8FFE: A6 1B       LDA    -$5,X
9000: 84 70       ANDA   #$70
9002: A7 E2       STA    ,-S		; [local]
9004: A6 41       LDA    $1,U
9006: 84 70       ANDA   #$70
9008: AB E0       ADDA   ,S+		; [local]
900A: 84 70       ANDA   #$70
900C: 26 09       BNE    $9017
900E: CC FE 00    LDD    #$FE00
9011: BD 93 02    JSR    function_9302
9014: C4 01       ANDB   #$01
9016: 39          RTS
9017: 5F          CLRB
9018: 39          RTS

; called 1x; jumped-to 1x  from $8F62, $9422
function_9019:
9019: 34 10       PSHS   X
901B: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
901E: DC 80       LDD    $80
9020: 83 00 01    SUBD   #$0001
9023: DD 80       STD    $80
9025: DC 88       LDD    $88
9027: C3 00 10    ADDD   #$0010
902A: DD 88       STD    $88
902C: A6 41       LDA    $1,U
902E: 84 80       ANDA   #$80
9030: A7 E2       STA    ,-S		; [local]
9032: E6 48       LDB    $8,U
9034: 50          NEGB
9035: 1D          SEX
9036: E3 C4       ADDD   ,U
9038: ED C4       STD    ,U
903A: ED 50       STD    -$10,U
903C: ED C8 E0    STD    -$20,U
903F: C4 80       ANDB   #$80
9041: E0 E0       SUBB   ,S+		; [local]
9043: 27 2F       BEQ    $9074
9045: 8E 15 00    LDX    #$1500
9048: D6 B3       LDB    $B3
904A: 58          ASLB
904B: 58          ASLB
904C: 58          ASLB
904D: 3A          ABX
904E: A6 84       LDA    ,X
9050: 27 01       BEQ    $9053
9052: 12          NOP
9053: DC 80       LDD    $80
9055: ED 01       STD    $1,X
9057: DC 82       LDD    $82
9059: ED 03       STD    $3,X
905B: A6 45       LDA    $5,U
905D: 80 02       SUBA   #$02
905F: 84 7E       ANDA   #$7E
9061: A7 45       STA    $5,U
9063: A7 55       STA    -$B,U
9065: A7 C8 E5    STA    -$1B,U
9068: A7 05       STA    $5,X
906A: EC 46       LDD    $6,U
906C: ED 06       STD    $6,X
906E: 86 0A       LDA    #$0A
9070: A7 84       STA    ,X
9072: 0C B3       INC    $B3
9074: 35 90       PULS   X,PC

; called 11x  from $A87A, $A891, $A8A6, $A927, $A943, $A9B8, $AA9D, $AAF5, ...
function_9076:
9076: DC 86       LDD    $86
9078: C4 F0       ANDB   #$F0
907A: ED E3       STD    ,--S		; [local]
907C: DC 86       LDD    $86
907E: E3 18       ADDD   -$8,X
9080: DD 86       STD    $86
9082: C4 F0       ANDB   #$F0
9084: A3 E1       SUBD   ,S++		; [local]
9086: 27 29       BEQ    $90B1
9088: 47          ASRA
9089: 56          RORB
908A: 57          ASRB
908B: 57          ASRB
908C: 57          ASRB
908D: 2A 01       BPL    $9090
908F: 50          NEGB
9090: D7 90       STB    $90
9092: A6 18       LDA    -$8,X
9094: 2A 03       BPL    $9099
9096: 7E 91 D4    JMP    $91D4
9099: EC 1C       LDD    -$4,X
909B: 10 83 07 80 CMPD   #$0780
909F: 23 18       BLS    $90B9
90A1: 8D 4B       BSR    function_90ee
90A3: 27 14       BEQ    $90B9
90A5: BD 91 3D    JSR    function_913d
90A8: 26 29       BNE    $90D3
90AA: BD 91 77    JSR    function_9177
90AD: 0A 90       DEC    $90
90AF: 26 E8       BNE    $9099
90B1: EC 18       LDD    -$8,X
90B3: E3 12       ADDD   -$E,X
90B5: ED 18       STD    -$8,X
90B7: 4F          CLRA
90B8: 39          RTS
90B9: BD 91 57    JSR    function_9157
90BC: 26 15       BNE    $90D3
90BE: EC 1C       LDD    -$4,X
90C0: 10 83 0E 00 CMPD   #$0E00
90C4: 2C 22       BGE    $90E8
90C6: EC 1C       LDD    -$4,X
90C8: C3 00 10    ADDD   #$0010
90CB: ED 1C       STD    -$4,X
90CD: 0A 90       DEC    $90
90CF: 26 C8       BNE    $9099
90D1: 20 DE       BRA    $90B1
90D3: DC 82       LDD    $82
90D5: 58          ASLB
90D6: 49          ROLA
90D7: 58          ASLB
90D8: 49          ROLA
90D9: 58          ASLB
90DA: 49          ROLA
90DB: 58          ASLB
90DC: 49          ROLA
90DD: DD 86       STD    $86
90DF: A6 1D       LDA    -$3,X
90E1: 84 F0       ANDA   #$F0
90E3: A7 1D       STA    -$3,X
90E5: 86 01       LDA    #$01
90E7: 39          RTS
90E8: CC 00 00    LDD    #$0000
90EB: ED 18       STD    -$8,X
90ED: 39          RTS

; called 2x  from $90A1, $9458
function_90ee:
90EE: 96 83       LDA    $83
90F0: 84 07       ANDA   #$07
90F2: 27 01       BEQ    $90F5
90F4: 39          RTS
90F5: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
90F8: 10 8E 40 00 LDY    #$4000		; layer 2 tilemap
90FC: EC 46       LDD    $6,U
90FE: C3 00 80    ADDD   #$0080
9101: 84 0F       ANDA   #$0F
9103: C4 80       ANDB   #$80
9105: 31 AB       LEAY   D,Y
9107: E6 45       LDB    $5,U
9109: CB 08       ADDB   #$08
910B: C4 7F       ANDB   #$7F
910D: E7 E2       STB    ,-S		; [local]
910F: EC A5       LDD    B,Y
9111: C4 03       ANDB   #$03
9113: 10 83 FF 03 CMPD   #$FF03
9117: 26 02       BNE    $911B
9119: 35 82       PULS   A,PC		; [manual_stack_pull]
911B: E6 E0       LDB    ,S+		; [local]
911D: 96 81       LDA    $81
911F: 84 07       ANDA   #$07
9121: 26 0D       BNE    $9130
9123: CB 46       ADDB   #$46
9125: C4 7F       ANDB   #$7F
9127: EC A5       LDD    B,Y
9129: C4 03       ANDB   #$03
912B: 10 83 FF 03 CMPD   #$FF03
912F: 39          RTS
9130: CB 48       ADDB   #$48
9132: C4 7F       ANDB   #$7F
9134: EC A5       LDD    B,Y
9136: C4 03       ANDB   #$03
9138: 10 83 FF 03 CMPD   #$FF03
913C: 39          RTS

; called 1x  from $90A5
function_913d:
913D: A6 01       LDA    $1,X
913F: 84 FC       ANDA   #$FC
9141: 81 28       CMPA   #$28
9143: 26 30       BNE    $9175
9145: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9148: A6 43       LDA    $3,U
914A: 84 70       ANDA   #$70
914C: 26 27       BNE    $9175
914E: CC 00 03    LDD    #$0003
9151: BD 93 02    JSR    function_9302
9154: C4 08       ANDB   #$08
9156: 39          RTS

; called 1x  from $90B9
function_9157:
9157: A6 01       LDA    $1,X
9159: 84 FC       ANDA   #$FC
915B: 81 28       CMPA   #$28
915D: 26 16       BNE    $9175
915F: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9162: A6 43       LDA    $3,U
9164: 84 70       ANDA   #$70
9166: AB 1C       ADDA   -$4,X
9168: 84 70       ANDA   #$70
916A: 26 09       BNE    $9175
916C: CC 00 03    LDD    #$0003
916F: BD 93 02    JSR    function_9302
9172: C4 08       ANDB   #$08
9174: 39          RTS
9175: 5F          CLRB
9176: 39          RTS

; called 1x; jumped-to 1x  from $90AA, $945D
function_9177:
9177: 34 10       PSHS   X
9179: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
917C: DC 82       LDD    $82
917E: C3 00 01    ADDD   #$0001
9181: DD 82       STD    $82
9183: DC 8A       LDD    $8A
9185: 83 00 10    SUBD   #$0010
9188: DD 8A       STD    $8A
918A: A6 43       LDA    $3,U
918C: 84 80       ANDA   #$80
918E: A7 E2       STA    ,-S		; [local]
9190: E6 49       LDB    $9,U
9192: 1D          SEX
9193: E3 42       ADDD   $2,U
9195: ED 42       STD    $2,U
9197: ED 52       STD    -$E,U
9199: ED C8 E2    STD    -$1E,U
919C: C4 80       ANDB   #$80
919E: E0 E0       SUBB   ,S+		; [local]
91A0: 27 30       BEQ    $91D2
91A2: 8E 15 00    LDX    #$1500
91A5: D6 B3       LDB    $B3
91A7: 58          ASLB
91A8: 58          ASLB
91A9: 58          ASLB
91AA: 3A          ABX
91AB: A6 84       LDA    ,X
91AD: 27 01       BEQ    $91B0
91AF: 12          NOP
91B0: DC 80       LDD    $80
91B2: ED 01       STD    $1,X
91B4: DC 82       LDD    $82
91B6: ED 03       STD    $3,X
91B8: EC 46       LDD    $6,U
91BA: 83 00 80    SUBD   #$0080
91BD: 84 0F       ANDA   #$0F
91BF: ED 46       STD    $6,U
91C1: ED 56       STD    -$A,U
91C3: ED C8 E6    STD    -$1A,U
91C6: ED 06       STD    $6,X
91C8: A6 45       LDA    $5,U
91CA: A7 05       STA    $5,X
91CC: 86 0E       LDA    #$0E
91CE: A7 84       STA    ,X
91D0: 0C B3       INC    $B3
91D2: 35 90       PULS   X,PC
91D4: EC 1C       LDD    -$4,X
91D6: 10 83 07 80 CMPD   #$0780
91DA: 24 1E       BCC    $91FA
91DC: 8D 78       BSR    function_9256
91DE: 27 1A       BEQ    $91FA
91E0: BD 92 A5    JSR    function_92a5
91E3: 26 15       BNE    $91FA
91E5: BD 93 55    JSR    function_9355
91E8: 0A 90       DEC    $90
91EA: 26 E8       BNE    $91D4
91EC: EC 18       LDD    -$8,X
91EE: 10 83 FF C0 CMPD   #$FFC0
91F2: 2F 04       BLE    $91F8
91F4: E3 12       ADDD   -$E,X
91F6: ED 18       STD    -$8,X
91F8: 4F          CLRA
91F9: 39          RTS
91FA: EC 1C       LDD    -$4,X
91FC: 10 83 FC 00 CMPD   #$FC00
9200: 2F 18       BLE    $921A
9202: 10 83 FF 00 CMPD   #$FF00
9206: 2F 05       BLE    $920D
9208: BD 92 D6    JSR    function_92d6
920B: 26 30       BNE    $923D
920D: EC 1C       LDD    -$4,X
920F: 83 00 10    SUBD   #$0010
9212: ED 1C       STD    -$4,X
9214: 0A 90       DEC    $90
9216: 26 BC       BNE    $91D4
9218: 20 D2       BRA    $91EC
921A: 86 40       LDA    #$40
921C: 97 15       STA    $15
921E: C6 60       LDB    #$60
9220: E7 07       STB    $7,X
9222: 35 C0       PULS   U,PC
9224: 10 8E 13 60 LDY    #$1360
9228: 96 E4       LDA    $E4
922A: C6 0B       LDB    #$0B
922C: E7 A6       STB    A,Y
922E: 4C          INCA
922F: 84 1F       ANDA   #$1F
9231: 97 E4       STA    $E4
9233: C6 FF       LDB    #$FF
9235: E7 84       STB    ,X
9237: 0A 31       DEC    $31
9239: 0A 33       DEC    $33
923B: 35 C0       PULS   U,PC
923D: C4 C0       ANDB   #$C0
923F: E7 05       STB    $5,X
9241: DC 82       LDD    $82
9243: 58          ASLB
9244: 49          ROLA
9245: 58          ASLB
9246: 49          ROLA
9247: 58          ASLB
9248: 49          ROLA
9249: 58          ASLB
924A: 49          ROLA
924B: DD 86       STD    $86
924D: A6 1D       LDA    -$3,X
924F: 84 F0       ANDA   #$F0
9251: A7 1D       STA    -$3,X
9253: 86 01       LDA    #$01
9255: 39          RTS

; called 2x  from $91DC, $948F
function_9256:
9256: 96 83       LDA    $83
9258: 84 07       ANDA   #$07
925A: 27 01       BEQ    $925D
925C: 39          RTS
925D: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9260: 10 8E 40 00 LDY    #$4000		; layer 2 tilemap
9264: EC 46       LDD    $6,U
9266: C3 0F 00    ADDD   #$0F00
9269: 84 0F       ANDA   #$0F
926B: C4 80       ANDB   #$80
926D: 31 AB       LEAY   D,Y
926F: E6 45       LDB    $5,U
9271: CB 08       ADDB   #$08
9273: C4 7F       ANDB   #$7F
9275: E7 E2       STB    ,-S		; [local]
9277: EC A5       LDD    B,Y
9279: C4 03       ANDB   #$03
927B: 10 83 FF 03 CMPD   #$FF03
927F: 26 02       BNE    $9283
9281: 35 82       PULS   A,PC		; [manual_stack_pull]
9283: E6 E0       LDB    ,S+		; [local]
9285: 96 81       LDA    $81
9287: 84 07       ANDA   #$07
9289: 26 0D       BNE    $9298
928B: CB 46       ADDB   #$46
928D: C4 7F       ANDB   #$7F
928F: EC A5       LDD    B,Y
9291: C4 03       ANDB   #$03
9293: 10 83 FF 03 CMPD   #$FF03
9297: 39          RTS
9298: CB 48       ADDB   #$48
929A: C4 7F       ANDB   #$7F
929C: EC A5       LDD    B,Y
929E: C4 03       ANDB   #$03
92A0: 10 83 FF 03 CMPD   #$FF03
92A4: 39          RTS

; called 1x  from $91E0
function_92a5:
92A5: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
92A8: A6 43       LDA    $3,U
92AA: 84 70       ANDA   #$70
92AC: 26 52       BNE    $9300
92AE: CC 00 FF    LDD    #$00FF
92B1: 8D 4F       BSR    function_9302
92B3: C5 06       BITB   #$06
92B5: 27 49       BEQ    $9300
92B7: A7 E2       STA    ,-S		; [local]
92B9: 84 EE       ANDA   #$EE
92BB: 81 20       CMPA   #$20
92BD: 27 10       BEQ    $92CF
92BF: A6 01       LDA    $1,X
92C1: 84 FC       ANDA   #$FC
92C3: 81 2C       CMPA   #$2C
92C5: 27 04       BEQ    $92CB
92C7: C5 02       BITB   #$02
92C9: 35 82       PULS   A,PC		; [manual_stack_pull]
92CB: C5 04       BITB   #$04
92CD: 35 82       PULS   A,PC		; [manual_stack_pull]
92CF: C4 C0       ANDB   #$C0
92D1: E7 05       STB    $5,X
92D3: 5F          CLRB
92D4: 35 82       PULS   A,PC		; [manual_stack_pull]


; called 1x  from $9208
function_92d6:
92D6: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
92D9: A6 1D       LDA    -$3,X
92DB: 84 70       ANDA   #$70
92DD: AB 43       ADDA   $3,U
92DF: 84 70       ANDA   #$70
92E1: 26 1D       BNE    $9300
92E3: CC 00 FF    LDD    #$00FF
92E6: 8D 1A       BSR    function_9302
92E8: C5 06       BITB   #$06
92EA: 27 14       BEQ    $9300
92EC: A7 E2       STA    ,-S		; [local]
92EE: 84 EE       ANDA   #$EE
92F0: 81 20       CMPA   #$20
92F2: 27 DB       BEQ    $92CF
92F4: A6 01       LDA    $1,X
92F6: 84 FC       ANDA   #$FC
92F8: 81 2C       CMPA   #$2C
92FA: 27 CF       BEQ    $92CB
92FC: C5 02       BITB   #$02
92FE: 35 82       PULS   A,PC		; [manual_stack_pull]
9300: 5F          CLRB
9301: 39          RTS

; called 25x  from $8ECB, $8EE7, $8FF5, $9011, $9151, $916F, $92B1, $92E6, ...
function_9302:
9302: 8D 20       BSR    function_9324
9304: CE 40 00    LDU    #$4000		; layer 2 tilemap
9307: EC CB       LDD    D,U
9309: C4 03       ANDB   #$03
930B: C1 03       CMPB   #$03
930D: 27 02       BEQ    $9311
930F: 5F          CLRB
9310: 39          RTS
9311: CE E6 7C    LDU    #$E67C		; ROM
9314: 44          LSRA
9315: 44          LSRA
9316: E6 05       LDB    $5,X
9318: C4 C0       ANDB   #$C0
931A: 54          LSRB
931B: 54          LSRB
931C: 54          LSRB
931D: 54          LSRB
931E: 54          LSRB
931F: EE C5       LDU    B,U
9321: E6 C6       LDB    A,U
9323: 39          RTS

; called 1x  from $9302
function_9324:
9324: ED E3       STD    ,--S		; [local]
9326: E6 41       LDB    $1,U
9328: C4 70       ANDB   #$70
932A: 1D          SEX
932B: E3 1A       ADDD   -$6,X
932D: 58          ASLB
932E: 49          ROLA
932F: AB E0       ADDA   ,S+		; [local]
9331: 8B 04       ADDA   #$04
9333: 48          ASLA
9334: AB 45       ADDA   $5,U
9336: 84 7E       ANDA   #$7E
9338: A7 E2       STA    ,-S		; [local]
933A: E6 43       LDB    $3,U
933C: C4 70       ANDB   #$70
933E: 1D          SEX
933F: E3 1C       ADDD   -$4,X
9341: 58          ASLB
9342: 49          ROLA
9343: AB 61       ADDA   $1,S		; [local]
9345: A7 E2       STA    ,-S		; [local]
9347: 86 1D       LDA    #$1D
9349: A0 E0       SUBA   ,S+		; [local]
934B: C6 80       LDB    #$80
934D: 3D          MUL
934E: E3 46       ADDD   $6,U
9350: 84 0F       ANDA   #$0F
9352: EB E1       ADDB   ,S++		; [local]
9354: 39          RTS

; called 1x; jumped-to 1x  from $91E5, $9494
function_9355:
9355: 34 10       PSHS   X
9357: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
935A: DC 82       LDD    $82
935C: 83 00 01    SUBD   #$0001
935F: DD 82       STD    $82
9361: DC 8A       LDD    $8A
9363: C3 00 10    ADDD   #$0010
9366: DD 8A       STD    $8A
9368: A6 43       LDA    $3,U
936A: 84 80       ANDA   #$80
936C: A7 E2       STA    ,-S		; [local]
936E: E6 49       LDB    $9,U
9370: 50          NEGB
9371: 1D          SEX
9372: E3 42       ADDD   $2,U
9374: ED 42       STD    $2,U
9376: ED 52       STD    -$E,U
9378: ED C8 E2    STD    -$1E,U
937B: C4 80       ANDB   #$80
937D: E0 E0       SUBB   ,S+		; [local]
937F: 27 30       BEQ    $93B1
9381: 8E 15 00    LDX    #$1500
9384: D6 B3       LDB    $B3
9386: 58          ASLB
9387: 58          ASLB
9388: 58          ASLB
9389: 3A          ABX
938A: A6 84       LDA    ,X
938C: 27 01       BEQ    $938F
938E: 12          NOP
938F: DC 80       LDD    $80
9391: ED 01       STD    $1,X
9393: DC 82       LDD    $82
9395: ED 03       STD    $3,X
9397: EC 46       LDD    $6,U
9399: ED 06       STD    $6,X
939B: C3 00 80    ADDD   #$0080
939E: 84 0F       ANDA   #$0F
93A0: ED 46       STD    $6,U
93A2: ED 56       STD    -$A,U
93A4: ED C8 E6    STD    -$1A,U
93A7: A6 45       LDA    $5,U
93A9: A7 05       STA    $5,X
93AB: 86 12       LDA    #$12
93AD: A7 84       STA    ,X
93AF: 0C B3       INC    $B3
93B1: 35 90       PULS   X,PC

; called 2x  from $9BF6, $9CE3
function_93b3:
93B3: A6 16       LDA    -$A,X
93B5: 2B 37       BMI    $93EE
93B7: CC 00 10    LDD    #$0010
93BA: DD 8C       STD    $8C
93BC: A6 0E       LDA    $E,X
93BE: 84 01       ANDA   #$01
93C0: 26 16       BNE    $93D8
93C2: EC 1A       LDD    -$6,X
93C4: 10 83 06 00 CMPD   #$0600
93C8: 24 1C       BCC    $93E6
93CA: A6 0E       LDA    $E,X
93CC: 8A 01       ORA    #$01
93CE: ED 0E       STD    $E,X
93D0: EC 1A       LDD    -$6,X
93D2: C3 00 10    ADDD   #$0010
93D5: ED 1A       STD    -$6,X
93D7: 39          RTS
93D8: EC 1A       LDD    -$6,X
93DA: 10 83 0A 00 CMPD   #$0A00
93DE: 25 F0       BCS    $93D0
93E0: A6 0E       LDA    $E,X
93E2: 84 02       ANDA   #$02
93E4: A7 0E       STA    $E,X
93E6: BD 8E 6E    JSR    function_8e6e
93E9: 27 E5       BEQ    $93D0
93EB: 7E 8E EF    JMP    function_8eef
93EE: CC FF F0    LDD    #$FFF0
93F1: DD 8C       STD    $8C
93F3: A6 0E       LDA    $E,X
93F5: 84 01       ANDA   #$01
93F7: 26 16       BNE    $940F
93F9: EC 1A       LDD    -$6,X
93FB: 10 83 0A 00 CMPD   #$0A00
93FF: 25 1C       BCS    $941D
9401: A6 0E       LDA    $E,X
9403: 8A 01       ORA    #$01
9405: A7 0E       STA    $E,X
9407: EC 1A       LDD    -$6,X
9409: 83 00 10    SUBD   #$0010
940C: ED 1A       STD    -$6,X
940E: 39          RTS
940F: EC 1A       LDD    -$6,X
9411: 10 83 06 00 CMPD   #$0600
9415: 22 F0       BHI    $9407
9417: A6 0E       LDA    $E,X
9419: 84 02       ANDA   #$02
941B: A7 0E       STA    $E,X
941D: BD 8F 96    JSR    function_8f96
9420: 27 E5       BEQ    $9407
9422: 7E 90 19    JMP    function_9019

; called 2x  from $9BFF, $9CEC
function_9425:
9425: A6 18       LDA    -$8,X
9427: 2B 37       BMI    $9460
9429: CC 00 10    LDD    #$0010
942C: DD 8E       STD    $8E
942E: A6 0E       LDA    $E,X
9430: 84 02       ANDA   #$02
9432: 26 16       BNE    $944A
9434: EC 1C       LDD    -$4,X
9436: 10 83 04 00 CMPD   #$0400
943A: 24 1C       BCC    $9458
943C: A6 0E       LDA    $E,X
943E: 8A 02       ORA    #$02
9440: A7 0E       STA    $E,X
9442: EC 1C       LDD    -$4,X
9444: C3 00 10    ADDD   #$0010
9447: ED 1C       STD    -$4,X
9449: 39          RTS
944A: EC 1C       LDD    -$4,X
944C: 10 83 08 00 CMPD   #$0800
9450: 25 F0       BCS    $9442
9452: A6 0E       LDA    $E,X
9454: 84 01       ANDA   #$01
9456: E7 0E       STB    $E,X
9458: BD 90 EE    JSR    function_90ee
945B: 27 E5       BEQ    $9442
945D: 7E 91 77    JMP    function_9177
9460: CC FF F0    LDD    #$FFF0
9463: DD 8E       STD    $8E
9465: A6 0E       LDA    $E,X
9467: 84 02       ANDA   #$02
9469: 26 16       BNE    $9481
946B: EC 1C       LDD    -$4,X
946D: 10 83 08 00 CMPD   #$0800
9471: 25 1C       BCS    $948F
9473: A6 0E       LDA    $E,X
9475: 8A 02       ORA    #$02
9477: A7 0E       STA    $E,X
9479: EC 1C       LDD    -$4,X
947B: 83 00 10    SUBD   #$0010
947E: ED 1C       STD    -$4,X
9480: 39          RTS
9481: EC 1C       LDD    -$4,X
9483: 10 83 04 00 CMPD   #$0400
9487: 22 F0       BHI    $9479
9489: A6 0E       LDA    $E,X
948B: 84 01       ANDA   #$01
948D: A7 0E       STA    $E,X
948F: BD 92 56    JSR    function_9256
9492: 27 E5       BEQ    $9479
9494: 7E 93 55    JMP    function_9355

; called 15x  from $B5A3, $B6EB, $B8CC, $BB8D, $BBA1, $C45B, $C483, $C503, ...
function_9497:
9497: EC 16       LDD    -$A,X
9499: 2B 74       BMI    $950F
949B: E3 1A       ADDD   -$6,X
949D: 10 83 14 00 CMPD   #$1400
94A1: 2C 36       BGE    $94D9
94A3: 32 7D       LEAS   -$3,S		; [alloc_locals]
94A5: ED E4       STD    ,S		; [local]
94A7: EC 1A       LDD    -$6,X
94A9: A6 84       LDA    ,X
94AB: 81 10       CMPA   #$10
94AD: 24 17       BCC    $94C6
94AF: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
94B2: C4 70       ANDB   #$70
94B4: EB 41       ADDB   $1,U
94B6: C4 70       ANDB   #$70
94B8: 26 0C       BNE    $94C6
94BA: CC 01 00    LDD    #$0100
94BD: BD 93 02    JSR    function_9302
94C0: A7 62       STA    $2,S		; [local]
94C2: C4 01       ANDB   #$01
94C4: 26 20       BNE    $94E6
94C6: EC 1A       LDD    -$6,X
94C8: C3 00 10    ADDD   #$0010
94CB: ED 1A       STD    -$6,X
94CD: 10 A3 E4    CMPD   ,S		; [local]
94D0: 2F D7       BLE    $94A9
94D2: EC E1       LDD    ,S++		; [local]
94D4: ED 1A       STD    -$6,X
94D6: 5F          CLRB
94D7: 35 82       PULS   A,PC		; [manual_stack_pull]
94D9: 0A 31       DEC    $31
94DB: 0A 37       DEC    $37
94DD: 0A 33       DEC    $33
94DF: 0A 39       DEC    $39
94E1: C6 FF       LDB    #$FF
94E3: E7 84       STB    ,X
94E5: 39          RTS

94E6: 32 62       LEAS   $2,S		; [free_locals]
94E8: E6 1B       LDB    -$5,X
94EA: C4 F0       ANDB   #$F0
94EC: E7 1B       STB    -$5,X
94EE: E6 0C       LDB    $C,X
94F0: CA 01       ORB    #$01
94F2: E7 0C       STB    $C,X
94F4: CE 95 4D    LDU    #$954D		; ROM
94F7: 6D 03       TST    $3,X
94F9: 2A 03       BPL    $94FE
94FB: 33 C8 10    LEAU   $10,U		; => 955D
94FE: C6 08       LDB    #$08
9500: A6 E0       LDA    ,S+		; [local]
9502: A1 C1       CMPA   ,U++
9504: 27 06       BEQ    $950C
9506: 5A          DECB
9507: 26 F9       BNE    $9502
9509: C6 24       LDB    #$24
950B: 39          RTS
950C: E6 5F       LDB    -$1,U
950E: 39          RTS
950F: E3 1A       ADDD   -$6,X
9511: 10 83 FE 00 CMPD   #$FE00
9515: 2D C2       BLT    $94D9
9517: 32 7D       LEAS   -$3,S		; [alloc_locals]
9519: ED E4       STD    ,S		; [local]
951B: EC 1A       LDD    -$6,X
951D: A6 84       LDA    ,X
951F: 81 10       CMPA   #$10
9521: 24 17       BCC    $953A
9523: CE 13 E0    LDU    #$13E0
9526: C4 70       ANDB   #$70
9528: EB 41       ADDB   $1,U
952A: C4 70       ANDB   #$70
952C: 26 0C       BNE    $953A
952E: CC FE 00    LDD    #$FE00
9531: BD 93 02    JSR    function_9302
9534: A7 62       STA    $2,S		; [local]
9536: C4 01       ANDB   #$01
9538: 26 AC       BNE    $94E6
953A: EC 1A       LDD    -$6,X
953C: C3 FF F0    ADDD   #$FFF0
953F: ED 1A       STD    -$6,X
9541: 10 A3 E4    CMPD   ,S		; [local]
9544: 2C D7       BGE    $951D
9546: EC E1       LDD    ,S++		; [local]
9548: ED 1A       STD    -$6,X
954A: 5F          CLRB
954B: 35 82       PULS   A,PC		; [manual_stack_pull]


; called 20x  from $B6F1, $B73E, $B75A, $B7CF, $B855, $B86F, $B887, $B8D2, ...
function_956d:
956D: EC 18       LDD    -$8,X
956F: 2F 63       BLE    $95D4
9571: E3 1C       ADDD   -$4,X
9573: 10 83 0F 80 CMPD   #$0F80
9577: 2C 3E       BGE    $95B7
9579: 32 7D       LEAS   -$3,S		; [alloc_locals]
957B: ED E4       STD    ,S		; [local]
957D: A6 01       LDA    $1,X
957F: 84 FC       ANDA   #$FC
9581: 81 28       CMPA   #$28
9583: 26 25       BNE    $95AA
9585: EC 1C       LDD    -$4,X
9587: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
958A: C4 70       ANDB   #$70
958C: EB 43       ADDB   $3,U
958E: C4 70       ANDB   #$70
9590: 26 0C       BNE    $959E
9592: CC 00 03    LDD    #$0003
9595: BD 93 02    JSR    function_9302
9598: A7 62       STA    $2,S		; [local]
959A: C4 08       ANDB   #$08
959C: 26 26       BNE    $95C4
959E: EC 1C       LDD    -$4,X
95A0: C3 00 10    ADDD   #$0010
95A3: ED 1C       STD    -$4,X
95A5: 10 A3 E4    CMPD   ,S		; [local]
95A8: 2F DD       BLE    $9587
95AA: EC E1       LDD    ,S++		; [local]
95AC: ED 1C       STD    -$4,X
95AE: EC 18       LDD    -$8,X
95B0: E3 12       ADDD   -$E,X
95B2: ED 18       STD    -$8,X
95B4: 5F          CLRB
95B5: 35 82       PULS   A,PC		; [manual_stack_pull]
95B7: 0A 31       DEC    $31
95B9: 0A 37       DEC    $37
95BB: 0A 33       DEC    $33
95BD: 0A 39       DEC    $39
95BF: C6 FF       LDB    #$FF
95C1: E7 84       STB    ,X
95C3: 39          RTS
95C4: 32 62       LEAS   $2,S		; [free_locals]
95C6: A6 1D       LDA    -$3,X
95C8: 84 F0       ANDA   #$F0
95CA: A7 1D       STA    -$3,X
95CC: A6 0C       LDA    $C,X
95CE: 8A 02       ORA    #$02
95D0: A7 0C       STA    $C,X
95D2: 35 82       PULS   A,PC		; [manual_stack_pull]

95D4: E3 1C       ADDD   -$4,X
95D6: 10 83 FC 80 CMPD   #$FC80
95DA: 2D DB       BLT    $95B7
95DC: 32 7D       LEAS   -$3,S		; [alloc_locals]
95DE: ED E4       STD    ,S		; [local]
95E0: EC 1C       LDD    -$4,X
95E2: CE 13 E0    LDU    #$13E0
95E5: C4 70       ANDB   #$70
95E7: EB 43       ADDB   $3,U
95E9: C4 70       ANDB   #$70
95EB: 26 24       BNE    $9611
95ED: CC 00 FF    LDD    #$00FF
95F0: BD 93 02    JSR    function_9302
95F3: A7 62       STA    $2,S		; [local]
95F5: C5 06       BITB   #$06
95F7: 27 18       BEQ    $9611
95F9: A6 01       LDA    $1,X
95FB: 84 FC       ANDA   #$FC
95FD: 81 2C       CMPA   #$2C
95FF: 26 04       BNE    $9605
9601: C5 04       BITB   #$04
9603: 27 0C       BEQ    $9611
9605: C4 C0       ANDB   #$C0
9607: E7 05       STB    $5,X
9609: A6 62       LDA    $2,S		; [local]
960B: 84 EE       ANDA   #$EE
960D: 81 20       CMPA   #$20
960F: 26 B3       BNE    $95C4
9611: EC 1C       LDD    -$4,X
9613: C3 FF F0    ADDD   #$FFF0
9616: ED 1C       STD    -$4,X
9618: 10 A3 E4    CMPD   ,S		; [local]
961B: 2C C5       BGE    $95E2
961D: EC E1       LDD    ,S++		; [local]
961F: ED 1C       STD    -$4,X
9621: EC 18       LDD    -$8,X
9623: E3 12       ADDD   -$E,X
9625: ED 18       STD    -$8,X
9627: 5F          CLRB
9628: 35 82       PULS   A,PC		; [manual_stack_pull]

; called 1x  from $B298
function_962a:
962A: E6 0D       LDB    $D,X
962C: 58          ASLB
962D: EA 0D       ORB    $D,X
962F: C4 02       ANDB   #$02
9631: E7 0D       STB    $D,X
9633: 10 8E E1 40 LDY    #$E140		; ROM
9637: F6 04 1B    LDB    $041B		; work RAM (shared with CPU1 $4400)
963A: C4 7F       ANDB   #$7F
963C: 4F          CLRA
963D: 58          ASLB
963E: 49          ROLA
963F: ED E3       STD    ,--S		; [local]
9641: 58          ASLB
9642: 49          ROLA
9643: 58          ASLB
9644: 49          ROLA
9645: E3 E1       ADDD   ,S++		; [local]
9647: 31 AB       LEAY   D,Y
9649: CE E1 40    LDU    #$E140
964C: E6 0B       LDB    $B,X
964E: C4 7F       ANDB   #$7F
9650: 4F          CLRA
9651: 58          ASLB

; 1 jump-table ref
function_9652:
9652: 49          ROLA
9653: ED E3       STD    ,--S		; [local]
9655: 58          ASLB
9656: 49          ROLA
9657: 58          ASLB
9658: 49          ROLA
9659: E3 E1       ADDD   ,S++		; [local]
965B: 33 CB       LEAU   D,U
965D: 8D 5D       BSR    function_96bc
965F: C5 40       BITB   #$40
9661: 26 01       BNE    $9664
9663: 39          RTS
9664: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
9667: 6D 4B       TST    $B,U
9669: 2B 49       BMI    $96B4
966B: 6D 0B       TST    $B,X
966D: 2B 45       BMI    $96B4
966F: 6D 4D       TST    $D,U
9671: 26 3C       BNE    $96AF
9673: 96 15       LDA    $15
9675: 8B 20       ADDA   #$20
9677: 97 15       STA    $15
9679: 9B 14       ADDA   $14
967B: A7 E2       STA    ,-S		; [local]
967D: 96 C1       LDA    $C1
967F: A0 E0       SUBA   ,S+		; [local]
9681: 23 18       BLS    $969B
9683: 10 8E 13 60 LDY    #$1360
9687: 96 E4       LDA    $E4
9689: C6 02       LDB    #$02
968B: E7 A6       STB    A,Y
968D: 4C          INCA
968E: 84 1F       ANDA   #$1F
9690: 97 E4       STA    $E4
9692: A6 0D       LDA    $D,X
9694: A7 4D       STA    $D,U
9696: C6 78       LDB    #$78
9698: E7 47       STB    $7,U
969A: 39          RTS
969B: 10 8E 13 60 LDY    #$1360
969F: 96 E4       LDA    $E4
96A1: C6 02       LDB    #$02
96A3: E7 A6       STB    A,Y
96A5: 4C          INCA
96A6: 84 1F       ANDA   #$1F
96A8: 97 E4       STA    $E4
96AA: C6 60       LDB    #$60
96AC: E7 47       STB    $7,U
96AE: 39          RTS
96AF: C6 78       LDB    #$78
96B1: 7E B4 29    JMP    function_b429
96B4: E6 0D       LDB    $D,X
96B6: C4 FE       ANDB   #$FE
96B8: E7 0D       STB    $D,X
96BA: 5F          CLRB
96BB: 39          RTS

; called 1x  from $965D
function_96bc:
96BC: FC 04 0C    LDD    $040C		; work RAM (shared with CPU1 $4400)
96BF: E3 A4       ADDD   ,Y		; [rom_address]
96C1: A3 1C       SUBD   -$4,X
96C3: A3 C4       SUBD   ,U		; [rom_address]
96C5: 2B 23       BMI    $96EA
96C7: 10 83 05 00 CMPD   #$0500
96CB: 2E 15       BGT    $96E2
96CD: 10 A3 42    CMPD   $2,U		; [rom_address]
96D0: 2E 08       BGT    $96DA
96D2: E6 0D       LDB    $D,X
96D4: CA 61       ORB    #$61
96D6: E7 0D       STB    $D,X
96D8: 20 20       BRA    $96FA
96DA: E6 0D       LDB    $D,X
96DC: CA 21       ORB    #$21
96DE: E7 0D       STB    $D,X
96E0: 20 18       BRA    $96FA
96E2: E6 0D       LDB    $D,X
96E4: CA 08       ORB    #$08
96E6: E7 0D       STB    $D,X
96E8: 20 10       BRA    $96FA
96EA: 53          COMB
96EB: 43          COMA
96EC: C3 00 01    ADDD   #$0001
96EF: 10 A3 22    CMPD   $2,Y		; [rom_address]
96F2: 2E 06       BGT    $96FA
96F4: E6 0D       LDB    $D,X
96F6: CA 61       ORB    #$61
96F8: E7 0D       STB    $D,X
96FA: B6 04 11    LDA    $0411
96FD: 84 02       ANDA   #$02
96FF: 26 20       BNE    $9721
9701: A6 01       LDA    $1,X
9703: 84 02       ANDA   #$02
9705: 26 0D       BNE    $9714
9707: FC 04 0A    LDD    $040A
970A: E3 24       ADDD   $4,Y
970C: A3 1A       SUBD   -$6,X
970E: A3 44       SUBD   $4,U
9710: 2B 75       BMI    $9787
9712: 20 2B       BRA    $973F
9714: FC 04 0A    LDD    $040A
9717: E3 24       ADDD   $4,Y		; [rom_address]
9719: A3 1A       SUBD   -$6,X
971B: A3 46       SUBD   $6,U		; [rom_address]
971D: 2B 68       BMI    $9787
971F: 20 1E       BRA    $973F
9721: A6 01       LDA    $1,X
9723: 84 02       ANDA   #$02
9725: 26 0D       BNE    $9734
9727: FC 04 0A    LDD    $040A
972A: E3 26       ADDD   $6,Y		; [rom_address]
972C: A3 1A       SUBD   -$6,X
972E: A3 44       SUBD   $4,U		; [rom_address]
9730: 2B 55       BMI    $9787
9732: 20 0B       BRA    $973F
9734: FC 04 0A    LDD    $040A
9737: E3 26       ADDD   $6,Y		; [rom_address]
9739: A3 1A       SUBD   -$6,X
973B: A3 46       SUBD   $6,U		; [rom_address]
973D: 2B 48       BMI    $9787
973F: 10 A3 48    CMPD   $8,U		; [rom_address]
9742: 2E 19       BGT    $975D
9744: CE 04 10    LDU    #$0410
9747: A6 05       LDA    $5,X
9749: A1 45       CMPA   $5,U		; [rom_address]
974B: 26 07       BNE    $9754
974D: E6 0D       LDB    $D,X
974F: CA 14       ORB    #$14
9751: E7 0D       STB    $D,X
9753: 39          RTS
9754: E6 0D       LDB    $D,X
9756: CA 94       ORB    #$94
9758: C4 BE       ANDB   #$BE
975A: E7 0D       STB    $D,X
975C: 39          RTS
975D: CE 04 10    LDU    #$0410
9760: A6 01       LDA    $1,X
9762: 84 01       ANDA   #$01
9764: 27 18       BEQ    $977E
9766: A6 05       LDA    $5,X
9768: A1 45       CMPA   $5,U
976A: 26 09       BNE    $9775
976C: E6 0D       LDB    $D,X
976E: CA 04       ORB    #$04
9770: C4 2F       ANDB   #$2F
9772: E7 0D       STB    $D,X
9774: 39          RTS
9775: E6 0D       LDB    $D,X
9777: CA 84       ORB    #$84
9779: C4 AE       ANDB   #$AE
977B: E7 0D       STB    $D,X
977D: 39          RTS
977E: E6 0D       LDB    $D,X
9780: CA 04       ORB    #$04
9782: C4 2E       ANDB   #$2E
9784: E7 0D       STB    $D,X
9786: 39          RTS
9787: 53          COMB
9788: 43          COMA
9789: C3 00 01    ADDD   #$0001
978C: 10 A3 28    CMPD   $8,Y		; [rom_address]
978F: 2E 19       BGT    $97AA
9791: CE 04 10    LDU    #$0410
9794: A6 05       LDA    $5,X
9796: A1 45       CMPA   $5,U
9798: 26 07       BNE    $97A1
979A: E6 0D       LDB    $D,X
979C: CA 10       ORB    #$10
979E: E7 0D       STB    $D,X
97A0: 39          RTS
97A1: E6 0D       LDB    $D,X
97A3: CA 80       ORB    #$80
97A5: C4 BA       ANDB   #$BA
97A7: E7 0D       STB    $D,X
97A9: 39          RTS
97AA: CE 04 10    LDU    #$0410
97AD: A6 01       LDA    $1,X
97AF: 84 02       ANDA   #$02
97B1: 27 16       BEQ    $97C9
97B3: A6 05       LDA    $5,X
97B5: A1 45       CMPA   $5,U
97B7: 26 07       BNE    $97C0
97B9: E6 0D       LDB    $D,X
97BB: C4 2F       ANDB   #$2F
97BD: E7 0D       STB    $D,X
97BF: 39          RTS
97C0: E6 0D       LDB    $D,X
97C2: CA 80       ORB    #$80
97C4: C4 AA       ANDB   #$AA
97C6: E7 0D       STB    $D,X
97C8: 39          RTS
97C9: E6 0D       LDB    $D,X
97CB: C4 2A       ANDB   #$2A
97CD: E7 0D       STB    $D,X
97CF: 39          RTS

; called 1x  from $CBB2
function_97d0:
97D0: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
97D3: A6 C4       LDA    ,U
97D5: 2B 38       BMI    $980F
97D7: E6 4B       LDB    $B,U
97D9: 2B 34       BMI    $980F
97DB: A6 45       LDA    $5,U
97DD: A1 05       CMPA   $5,X
97DF: 26 2E       BNE    $980F
97E1: 4F          CLRA
97E2: 58          ASLB
97E3: 49          ROLA
97E4: ED E3       STD    ,--S		; [local]
97E6: 58          ASLB
97E7: 49          ROLA
97E8: 58          ASLB
97E9: 49          ROLA
97EA: E3 E1       ADDD   ,S++		; [local]
97EC: 10 8E E1 40 LDY    #$E140		; ROM
97F0: 31 AB       LEAY   D,Y
97F2: 8D 20       BSR    function_9814
97F4: 26 01       BNE    $97F7
97F6: 39          RTS
97F7: 6D 4D       TST    $D,U
97F9: 26 16       BNE    $9811
97FB: 96 15       LDA    $15
97FD: 8B 20       ADDA   #$20
97FF: 97 15       STA    $15
9801: 9B 14       ADDA   $14
9803: 91 C1       CMPA   $C1
9805: 25 02       BCS    $9809
9807: C6 60       LDB    #$60
9809: E7 47       STB    $7,U
980B: A6 0D       LDA    $D,X
980D: A7 4D       STA    $D,U
980F: 5F          CLRB
9810: 39          RTS
9811: 7E B4 29    JMP    function_b429

; called 1x  from $97F2
function_9814:
9814: EC 5C       LDD    -$4,U
9816: E3 A4       ADDD   ,Y
9818: A3 1C       SUBD   -$4,X
981A: B3 E6 5E    SUBD   $E65E		; ROM
981D: 2B 08       BMI    $9827
981F: 10 B3 E6 60 CMPD   $E660
9823: 23 0C       BLS    $9831
9825: 4F          CLRA
9826: 39          RTS
9827: 53          COMB
9828: 43          COMA
9829: C3 00 01    ADDD   #$0001
982C: 10 A3 22    CMPD   $2,Y
982F: 22 F4       BHI    $9825
9831: A6 01       LDA    $1,X
9833: 84 02       ANDA   #$02
9835: 26 34       BNE    $986B
9837: A6 41       LDA    $1,U
9839: 84 02       ANDA   #$02
983B: 26 14       BNE    $9851
983D: EC 5A       LDD    -$6,U
983F: E3 24       ADDD   $4,Y
9841: A3 1A       SUBD   -$6,X
9843: B3 E6 62    SUBD   $E662
9846: 2B 14       BMI    $985C
9848: 10 B3 E6 66 CMPD   $E666
984C: 22 1B       BHI    $9869
984E: C6 78       LDB    #$78
9850: 39          RTS
9851: EC 5A       LDD    -$6,U
9853: E3 26       ADDD   $6,Y
9855: A3 1A       SUBD   -$6,X
9857: B3 E6 62    SUBD   $E662
985A: 2A EC       BPL    $9848
985C: 53          COMB
985D: 43          COMA
985E: C3 00 01    ADDD   #$0001
9861: 10 A3 28    CMPD   $8,Y
9864: 22 03       BHI    $9869
9866: C6 78       LDB    #$78
9868: 39          RTS
9869: 4F          CLRA
986A: 39          RTS
986B: A6 41       LDA    $1,U
986D: 84 02       ANDA   #$02
986F: 26 14       BNE    $9885
9871: EC 5A       LDD    -$6,U
9873: E3 24       ADDD   $4,Y
9875: A3 1A       SUBD   -$6,X
9877: B3 E6 64    SUBD   $E664
987A: 2B 14       BMI    $9890
987C: 10 B3 E6 66 CMPD   $E666
9880: 22 E7       BHI    $9869
9882: C6 78       LDB    #$78
9884: 39          RTS
9885: EC 5A       LDD    -$6,U
9887: E3 26       ADDD   $6,Y
9889: A3 1A       SUBD   -$6,X
988B: B3 E6 64    SUBD   $E664
988E: 2A EC       BPL    $987C
9890: 53          COMB
9891: 43          COMA
9892: C3 00 01    ADDD   #$0001
9895: 10 A3 28    CMPD   $8,Y
9898: 22 CF       BHI    $9869
989A: C6 78       LDB    #$78
989C: 39          RTS

; called 2x  from $87A2, $8931
function_989d:
989D: 8E 04 10    LDX    #$0410		; work RAM (shared with CPU1 $4400)
98A0: 0F 33       CLR    $33
98A2: A6 84       LDA    ,X
98A4: 2A 0B       BPL    $98B1
98A6: 81 FF       CMPA   #$FF
98A8: 26 01       BNE    $98AB
98AA: 39          RTS
98AB: 84 7F       ANDA   #$7F
98AD: A7 84       STA    ,X
98AF: 20 06       BRA    $98B7
98B1: E6 01       LDB    $1,X
98B3: E1 07       CMPB   $7,X
98B5: 27 05       BEQ    $98BC
98B7: E6 07       LDB    $7,X
98B9: BD 99 3B    JSR    function_993b
98BC: 0C 33       INC    $33
98BE: CE 99 51    LDU    #jump_table_9951
98C1: E6 01       LDB    $1,X
98C3: C4 FC       ANDB   #$FC
98C5: 54          LSRB
98C6: AD D5       JSR    [B,U]		; [indirect_jump] [nb_entries=106]
98C8: 8D 03       BSR    function_98cd
98CA: 7E 98 F0    JMP    $98F0

; called 1x  from $98C8
function_98cd:
98CD: A6 84       LDA    ,X
98CF: 85 03       BITA   #$03
98D1: 26 01       BNE    $98D4
98D3: 39          RTS
98D4: 6D 14       TST    -$C,X
98D6: 26 01       BNE    $98D9
98D8: 39          RTS
98D9: CE EB 00    LDU    #$EB00		; ROM
98DC: A6 15       LDA    -$B,X
98DE: 4C          INCA
98DF: 84 7F       ANDA   #$7F
98E1: A7 15       STA    -$B,X
98E3: E6 C6       LDB    A,U
98E5: 2A 04       BPL    $98EB
98E7: 6F 15       CLR    -$B,X
98E9: E6 C4       LDB    ,U
98EB: 8D 4E       BSR    function_993b
98ED: 6F 14       CLR    -$C,X
98EF: 39          RTS
98F0: 0D 91       TST    $91
98F2: 27 01       BEQ    $98F5
98F4: 39          RTS
98F5: 96 C2       LDA    $C2
98F7: 27 19       BEQ    $9912
98F9: 96 C4       LDA    $C4
98FB: 81 04       CMPA   #$04
98FD: 26 13       BNE    $9912
98FF: 0D 1F       TST    $1F
9901: 26 01       BNE    $9904
9903: 39          RTS
9904: EC 1A       LDD    -$6,X
9906: 10 83 09 00 CMPD   #$0900
990A: 2C 01       BGE    $990D
990C: 39          RTS
990D: 86 80       LDA    #$80
990F: 97 1F       STA    $1F
9911: 39          RTS
9912: DC C8       LDD    $C8
9914: 83 01 01    SUBD   #$0101
9917: 10 93 7E    CMPD   $7E
991A: 27 01       BEQ    $991D
991C: 39          RTS
991D: EC 1A       LDD    -$6,X
991F: 10 83 0D 00 CMPD   #$0D00
9923: 2C 01       BGE    $9926
9925: 39          RTS
9926: BD 9A 62    JSR    function_9a62
9929: 27 01       BEQ    $992C
992B: 39          RTS
992C: 0C 91       INC    $91
992E: 86 40       LDA    #$40
9930: A7 05       STA    $5,X
9932: C6 9C       LDB    #$9C
9934: 7E 99 3B    JMP    function_993b
9937: 96 0A       LDA    $0A
9939: E6 C6       LDB    A,U

; called 2x; jumped-to 9x  from $98B9, $98EB, $9934, $9A95, $9A9B, $9DBE, $9DC3, $9E3B, ...
function_993b:
993B: E7 07       STB    $7,X
993D: C5 03       BITB   #$03
993F: 26 08       BNE    $9949
9941: E6 01       LDB    $1,X
9943: C4 03       ANDB   #$03
9945: EB 07       ADDB   $7,X
9947: E7 07       STB    $7,X
9949: C4 FC       ANDB   #$FC
994B: 54          LSRB
994C: CE 99 BB    LDU    #jump_table_99bb
994F: 6E D5       JMP    [B,U]		; [indirect_jump] [nb_entries=53]


; 2 jump-table ref
function_9a25:
9A25: 7E 8D C8    JMP    function_8dc8

; 20 jump-table ref
function_9a28:
9A28: 6A 0A       DEC    $A,X
9A2A: 27 01       BEQ    $9A2D
9A2C: 39          RTS
9A2D: A6 84       LDA    ,X
9A2F: 84 03       ANDA   #$03
9A31: 26 06       BNE    $9A39
9A33: CE E0 14    LDU    #$E014		; ROM
9A36: 7E 99 37    JMP    $9937
9A39: 6C 14       INC    -$C,X
9A3B: 39          RTS

; 6 jump-table ref
function_9a3c:
9A3C: A6 84       LDA    ,X
9A3E: 84 03       ANDA   #$03
9A40: 26 07       BNE    $9A49
9A42: A6 07       LDA    $7,X
9A44: A1 01       CMPA   $1,X
9A46: 26 01       BNE    $9A49
9A48: 39          RTS
9A49: BD 9A D5    JSR    function_9ad5
9A4C: A6 07       LDA    $7,X
9A4E: 84 02       ANDA   #$02
9A50: 26 08       BNE    $9A5A
9A52: CC 00 20    LDD    #$0020
9A55: ED 16       STD    -$A,X
9A57: 7E 8D C8    JMP    function_8dc8
9A5A: CC FF E0    LDD    #$FFE0
9A5D: ED 16       STD    -$A,X
9A5F: 7E 8D C8    JMP    function_8dc8

; called 3x  from $9926, $9A99, $B565
function_9a62:
9A62: EC 1A       LDD    -$6,X
9A64: 10 83 FF 00 CMPD   #$FF00
9A68: 2D 21       BLT    $9A8B
9A6A: 10 83 13 00 CMPD   #$1300
9A6E: 2E 1B       BGT    $9A8B
9A70: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9A73: CC 00 FF    LDD    #$00FF
9A76: BD 93 02    JSR    function_9302
9A79: C5 20       BITB   #$20
9A7B: 26 0A       BNE    $9A87
9A7D: C5 02       BITB   #$02
9A7F: 27 0C       BEQ    $9A8D
9A81: 84 EE       ANDA   #$EE
9A83: 81 20       CMPA   #$20
9A85: 27 06       BEQ    $9A8D
9A87: C4 C0       ANDB   #$C0
9A89: E7 05       STB    $5,X
9A8B: 5F          CLRB
9A8C: 39          RTS
9A8D: C6 30       LDB    #$30
9A8F: 39          RTS

; 2 jump-table ref
function_9a90:
9A90: BD 8E 05    JSR    function_8e05
9A93: 8D 65       BSR    function_9afa
9A95: 10 26 FE A2 LBNE   function_993b
9A99: 8D C7       BSR    function_9a62
9A9B: 10 26 FE 9C LBNE   function_993b
9A9F: A6 84       LDA    ,X
9AA1: 84 03       ANDA   #$03
9AA3: 26 1C       BNE    $9AC1
9AA5: 6A 0A       DEC    $A,X
9AA7: 26 12       BNE    $9ABB
9AA9: A6 09       LDA    $9,X
9AAB: 81 05       CMPA   #$05
9AAD: 26 06       BNE    $9AB5
9AAF: 86 FF       LDA    #$FF
9AB1: A7 09       STA    $9,X
9AB3: 8D 20       BSR    function_9ad5
9AB5: CE D9 50    LDU    #$D950		; ROM
9AB8: BD 8D E8    JSR    function_8de8
9ABB: CE E0 14    LDU    #$E014
9ABE: 7E 99 37    JMP    $9937
9AC1: 6A 0A       DEC    $A,X
9AC3: 27 01       BEQ    $9AC6
9AC5: 39          RTS
9AC6: A6 09       LDA    $9,X
9AC8: 81 05       CMPA   #$05
9ACA: 27 06       BEQ    $9AD2
9ACC: CE D9 50    LDU    #$D950
9ACF: 7E 8D E8    JMP    function_8de8
9AD2: 6C 14       INC    -$C,X
9AD4: 39          RTS

; called 3x  from $9A49, $9AB3, $9B7D
function_9ad5:
9AD5: CE 9A F0    LDU    #$9AF0		; ROM
9AD8: 96 C2       LDA    $C2
9ADA: 48          ASLA
9ADB: 48          ASLA
9ADC: 9B C2       ADDA   $C2
9ADE: 9B C4       ADDA   $C4
9AE0: E6 C6       LDB    A,U
9AE2: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
9AE6: 96 E6       LDA    $E6
9AE8: E7 A6       STB    A,Y
9AEA: 4C          INCA
9AEB: 84 1F       ANDA   #$1F
9AED: 97 E6       STA    $E6
9AEF: 39          RTS
9AF0: 08 08       ASL    $08
9AF2: 0C 0C       INC    $0C
9AF4: 08 08       ASL    $08
9AF6: 08 0C       ASL    $0C
9AF8: 08 08       ASL    $08

; called 2x  from $9A93, $B55E
function_9afa:
9AFA: A6 01       LDA    $1,X
9AFC: 84 02       ANDA   #$02
9AFE: 26 2C       BNE    $9B2C
9B00: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9B03: CC FF FF    LDD    #$FFFF
9B06: BD 93 02    JSR    function_9302
9B09: C4 20       ANDB   #$20
9B0B: 27 07       BEQ    $9B14
9B0D: 84 01       ANDA   #$01
9B0F: 26 03       BNE    $9B14
9B11: C6 51       LDB    #$51
9B13: 39          RTS
9B14: CE 13 E0    LDU    #$13E0
9B17: CC 01 00    LDD    #$0100
9B1A: BD 93 02    JSR    function_9302
9B1D: C4 20       ANDB   #$20
9B1F: 26 01       BNE    $9B22
9B21: 39          RTS
9B22: 84 01       ANDA   #$01
9B24: 26 01       BNE    $9B27
9B26: 39          RTS
9B27: C6 4D       LDB    #$4D
9B29: 39          RTS
9B2A: 4F          CLRA
9B2B: 39          RTS
9B2C: CE 13 E0    LDU    #$13E0
9B2F: CC FF 00    LDD    #$FF00
9B32: BD 93 02    JSR    function_9302
9B35: C4 20       ANDB   #$20
9B37: 27 07       BEQ    $9B40
9B39: 84 01       ANDA   #$01
9B3B: 26 03       BNE    $9B40
9B3D: C6 4E       LDB    #$4E
9B3F: 39          RTS
9B40: CE 13 E0    LDU    #$13E0
9B43: CC 01 FF    LDD    #$01FF
9B46: BD 93 02    JSR    function_9302
9B49: C4 20       ANDB   #$20
9B4B: 26 01       BNE    $9B4E
9B4D: 39          RTS
9B4E: 84 01       ANDA   #$01
9B50: 26 01       BNE    function_9b53
9B52: 39          RTS

; 1 jump-table ref  from $9B50
function_9b53:
9B53: C6 52       LDB    #$52
9B55: 39          RTS

; 1 jump-table ref
function_9b56:
9B56: A6 0B       LDA    $B,X
9B58: 8A 80       ORA    #$80
9B5A: A7 0B       STA    $B,X
9B5C: EC 1A       LDD    -$6,X
9B5E: 10 83 12 80 CMPD   #$1280
9B62: 2D 01       BLT    $9B65
9B64: 39          RTS
9B65: C3 00 10    ADDD   #$0010
9B68: ED 1A       STD    -$6,X
9B6A: 86 40       LDA    #$40
9B6C: A7 05       STA    $5,X
9B6E: 6A 0A       DEC    $A,X
9B70: 27 01       BEQ    $9B73
9B72: 39          RTS
9B73: A6 09       LDA    $9,X
9B75: 81 05       CMPA   #$05
9B77: 26 07       BNE    $9B80
9B79: 86 FF       LDA    #$FF
9B7B: A7 09       STA    $9,X
9B7D: BD 9A D5    JSR    function_9ad5
9B80: CE D9 50    LDU    #$D950		; ROM
9B83: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_9b86:
9B86: A6 07       LDA    $7,X
9B88: A1 01       CMPA   $1,X
9B8A: 27 2C       BEQ    $9BB8
9B8C: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
9B90: 96 E6       LDA    $E6
9B92: C6 48       LDB    #$48
9B94: E7 A6       STB    A,Y
9B96: 4C          INCA
9B97: 84 1F       ANDA   #$1F
9B99: 97 E6       STA    $E6
9B9B: A6 07       LDA    $7,X
9B9D: 84 02       ANDA   #$02
9B9F: 26 0A       BNE    $9BAB
9BA1: CC 00 10    LDD    #$0010
9BA4: ED 16       STD    -$A,X
9BA6: ED 18       STD    -$8,X
9BA8: 7E 8D C8    JMP    function_8dc8
9BAB: CC FF F0    LDD    #$FFF0
9BAE: ED 16       STD    -$A,X
9BB0: CC 00 10    LDD    #$0010
9BB3: ED 18       STD    -$8,X
9BB5: 7E 8D C8    JMP    function_8dc8
9BB8: CE DA 1C    LDU    #$DA1C		; ROM
9BBB: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_9bbe:
9BBE: A6 07       LDA    $7,X
9BC0: A1 01       CMPA   $1,X
9BC2: 27 2C       BEQ    $9BF0
9BC4: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
9BC8: 96 E6       LDA    $E6
9BCA: C6 48       LDB    #$48
9BCC: E7 A6       STB    A,Y
9BCE: 4C          INCA
9BCF: 84 1F       ANDA   #$1F
9BD1: 97 E6       STA    $E6
9BD3: A6 07       LDA    $7,X
9BD5: 84 02       ANDA   #$02
9BD7: 26 0D       BNE    $9BE6
9BD9: CC 00 10    LDD    #$0010
9BDC: ED 16       STD    -$A,X
9BDE: CC FF F0    LDD    #$FFF0
9BE1: ED 18       STD    -$8,X
9BE3: 7E 8D C8    JMP    function_8dc8
9BE6: CC FF F0    LDD    #$FFF0
9BE9: ED 18       STD    -$8,X
9BEB: ED 18       STD    -$8,X
9BED: 7E 8D C8    JMP    function_8dc8
9BF0: CE DA 34    LDU    #$DA34		; ROM
9BF3: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_9bf6:
9BF6: BD 93 B3    JSR    function_93b3
9BF9: EC 1A       LDD    -$6,X
9BFB: 93 8C       SUBD   $8C
9BFD: ED 1A       STD    -$6,X
9BFF: BD 94 25    JSR    function_9425
9C02: EC 1C       LDD    -$4,X
9C04: 93 8E       SUBD   $8E
9C06: ED 1C       STD    -$4,X
9C08: 6A 0A       DEC    $A,X
9C0A: 27 01       BEQ    $9C0D
9C0C: 39          RTS
9C0D: A6 01       LDA    $1,X
9C0F: 84 02       ANDA   #$02
9C11: 26 08       BNE    $9C1B
9C13: CE 9C 23    LDU    #jump_table_9c23
9C16: A6 09       LDA    $9,X
9C18: 48          ASLA
9C19: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=12]
9C1B: CE 9C 2F    LDU    #jump_table_9c2f
9C1E: A6 09       LDA    $9,X
9C20: 48          ASLA
9C21: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]


; 1 jump-table ref
function_9c3b:
9C3B: EC 1A       LDD    -$6,X
9C3D: C3 00 C0    ADDD   #$00C0
9C40: ED 1A       STD    -$6,X
9C42: EC 1C       LDD    -$4,X
9C44: C3 00 80    ADDD   #$0080
9C47: ED 1C       STD    -$4,X
9C49: 8D 76       BSR    function_9cc1
9C4B: 27 6E       BEQ    $9CBB

; 4 jump-table ref
function_9c4d:
9C4D: CE E0 F0    LDU    #$E0F0		; ROM
9C50: 7E 99 37    JMP    $9937

; 2 jump-table ref
function_9c53:
9C53: EC 1A       LDD    -$6,X
9C55: 83 00 C0    SUBD   #$00C0
9C58: ED 1A       STD    -$6,X
9C5A: EC 1C       LDD    -$4,X
9C5C: C3 00 80    ADDD   #$0080
9C5F: ED 1C       STD    -$4,X
9C61: 8D 6F       BSR    function_9cd2
9C63: 27 56       BEQ    $9CBB

; 8 jump-table ref  from $9CB9
function_9c65:
9C65: CE E1 04    LDU    #$E104		; ROM
9C68: 7E 99 37    JMP    $9937

; 1 jump-table ref
function_9c6b:
9C6B: EC 1A       LDD    -$6,X
9C6D: C3 00 C0    ADDD   #$00C0
9C70: ED 1A       STD    -$6,X
9C72: EC 1C       LDD    -$4,X
9C74: C3 00 80    ADDD   #$0080
9C77: ED 1C       STD    -$4,X
9C79: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
9C7D: 96 E6       LDA    $E6
9C7F: C6 48       LDB    #$48
9C81: E7 A6       STB    A,Y
9C83: 4C          INCA
9C84: 84 1F       ANDA   #$1F
9C86: 97 E6       STA    $E6
9C88: 86 FF       LDA    #$FF
9C8A: A7 09       STA    $9,X
9C8C: 8D 33       BSR    function_9cc1
9C8E: 27 2B       BEQ    $9CBB
9C90: CE E0 F0    LDU    #$E0F0		; ROM
9C93: 7E 99 37    JMP    $9937

; 2 jump-table ref
function_9c96:
9C96: EC 1A       LDD    -$6,X
9C98: 83 00 C0    SUBD   #$00C0
9C9B: ED 1A       STD    -$6,X
9C9D: EC 1C       LDD    -$4,X
9C9F: C3 00 80    ADDD   #$0080
9CA2: ED 1C       STD    -$4,X
9CA4: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
9CA8: 96 E6       LDA    $E6
9CAA: C6 48       LDB    #$48
9CAC: E7 A6       STB    A,Y
9CAE: 4C          INCA
9CAF: 84 1F       ANDA   #$1F
9CB1: 97 E6       STA    $E6
9CB3: 86 FF       LDA    #$FF
9CB5: A7 09       STA    $9,X
9CB7: 8D 19       BSR    function_9cd2
9CB9: 26 AA       BNE    function_9c65
9CBB: CE E0 14    LDU    #$E014		; ROM
9CBE: 7E 99 37    JMP    $9937

; called 4x  from $9C49, $9C8C, $BF85, $BFE5
function_9cc1:
9CC1: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9CC4: CC 01 00    LDD    #$0100
9CC7: BD 93 02    JSR    function_9302
9CCA: C4 20       ANDB   #$20
9CCC: 26 01       BNE    $9CCF
9CCE: 39          RTS
9CCF: C6 4D       LDB    #$4D
9CD1: 39          RTS

; called 4x  from $9C61, $9CB7, $BFAA, $C00E
function_9cd2:
9CD2: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9CD5: CC FF 00    LDD    #$FF00
9CD8: BD 93 02    JSR    function_9302
9CDB: C4 20       ANDB   #$20
9CDD: 26 01       BNE    $9CE0
9CDF: 39          RTS
9CE0: C6 4E       LDB    #$4E
9CE2: 39          RTS

; 1 jump-table ref
function_9ce3:
9CE3: BD 93 B3    JSR    function_93b3
9CE6: EC 1A       LDD    -$6,X
9CE8: 93 8C       SUBD   $8C
9CEA: ED 1A       STD    -$6,X
9CEC: BD 94 25    JSR    function_9425
9CEF: EC 1C       LDD    -$4,X
9CF1: 93 8E       SUBD   $8E
9CF3: ED 1C       STD    -$4,X
9CF5: 6A 0A       DEC    $A,X
9CF7: 27 01       BEQ    $9CFA
9CF9: 39          RTS
9CFA: A6 01       LDA    $1,X
9CFC: 84 02       ANDA   #$02
9CFE: 26 08       BNE    $9D08
9D00: CE 9D 10    LDU    #jump_table_9d10
9D03: A6 09       LDA    $9,X
9D05: 48          ASLA
9D06: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=12]

9D08: CE 9D 1C    LDU    #jump_table_9d1c
9D0B: A6 09       LDA    $9,X
9D0D: 48          ASLA
9D0E: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]


; 2 jump-table ref
function_9d28:
9D28: EC 1A       LDD    -$6,X
9D2A: C3 00 C0    ADDD   #$00C0
9D2D: ED 1A       STD    -$6,X
9D2F: EC 1C       LDD    -$4,X
9D31: 83 00 80    SUBD   #$0080
9D34: ED 1C       STD    -$4,X
9D36: 8D 58       BSR    function_9d90
9D38: 27 1E       BEQ    $9D58

; 3 jump-table ref
function_9d3a:
9D3A: CE E1 18    LDU    #$E118		; ROM
9D3D: 7E 99 37    JMP    $9937

; 4 jump-table ref
function_9d40:
9D40: EC 1A       LDD    -$6,X
9D42: 83 00 C0    SUBD   #$00C0
9D45: ED 1A       STD    -$6,X
9D47: EC 1C       LDD    -$4,X
9D49: 83 00 80    SUBD   #$0080
9D4C: ED 1C       STD    -$4,X
9D4E: 8D 51       BSR    function_9da1
9D50: 27 06       BEQ    $9D58

; 6 jump-table ref
function_9d52:
9D52: CE E1 2C    LDU    #$E12C		; ROM
9D55: 7E 99 37    JMP    $9937
9D58: CE E0 14    LDU    #$E014
9D5B: 7E 99 37    JMP    $9937

; 1 jump-table ref
function_9d5e:
9D5E: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
9D62: 96 E6       LDA    $E6
9D64: C6 48       LDB    #$48
9D66: E7 A6       STB    A,Y
9D68: 4C          INCA
9D69: 84 1F       ANDA   #$1F
9D6B: 97 E6       STA    $E6
9D6D: 86 FF       LDA    #$FF
9D6F: A7 09       STA    $9,X
9D71: CE E1 18    LDU    #$E118		; ROM
9D74: 7E 99 37    JMP    $9937

; 2 jump-table ref
function_9d77:
9D77: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
9D7B: 96 E6       LDA    $E6
9D7D: C6 48       LDB    #$48
9D7F: E7 A6       STB    A,Y
9D81: 4C          INCA
9D82: 84 1F       ANDA   #$1F
9D84: 97 E6       STA    $E6
9D86: 86 FF       LDA    #$FF
9D88: A7 09       STA    $9,X
9D8A: CE E1 2C    LDU    #$E12C		; ROM
9D8D: 7E 99 37    JMP    $9937

; called 2x  from $9D36, $C081
function_9d90:
9D90: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9D93: CC FF FF    LDD    #$FFFF
9D96: BD 93 02    JSR    function_9302
9D99: C4 20       ANDB   #$20
9D9B: 26 01       BNE    $9D9E
9D9D: 39          RTS
9D9E: C6 51       LDB    #$51
9DA0: 39          RTS

; called 2x  from $9D4E, $C0AB
function_9da1:
9DA1: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
9DA4: CC 01 FF    LDD    #$01FF
9DA7: BD 93 02    JSR    function_9302
9DAA: C4 20       ANDB   #$20
9DAC: 26 01       BNE    $9DAF
9DAE: 39          RTS
9DAF: C6 52       LDB    #$52
9DB1: 39          RTS

; 2 jump-table ref
function_9db2:
9DB2: 8D 15       BSR    function_9dc9
9DB4: 27 10       BEQ    $9DC6
9DB6: A6 C4       LDA    ,U
9DB8: 81 43       CMPA   #$43
9DBA: 27 05       BEQ    $9DC1
9DBC: C6 58       LDB    #$58
9DBE: 7E 99 3B    JMP    function_993b
9DC1: C6 A8       LDB    #$A8
9DC3: 7E 99 3B    JMP    function_993b
9DC6: 7E 8D C8    JMP    function_8dc8

; called 2x  from $9DB2, $9E2F
function_9dc9:
9DC9: 96 53       LDA    $53
9DCB: 26 01       BNE    $9DCE
9DCD: 39          RTS
9DCE: 97 55       STA    $55
9DD0: CE 10 00    LDU    #$1000		; work RAM (shared with CPU1 $4400)
9DD3: A6 C4       LDA    ,U
9DD5: 2B 4F       BMI    $9E26
9DD7: 84 7C       ANDA   #$7C
9DD9: 81 40       CMPA   #$40
9DDB: 26 49       BNE    $9E26
9DDD: EC 4A       LDD    $A,U
9DDF: C3 00 E0    ADDD   #$00E0
9DE2: A3 1A       SUBD   -$6,X
9DE4: 2A 05       BPL    $9DEB
9DE6: 53          COMB
9DE7: 43          COMA
9DE8: C3 00 01    ADDD   #$0001
9DEB: 10 83 00 80 CMPD   #$0080
9DEF: 24 30       BCC    $9E21
9DF1: A6 07       LDA    $7,X
9DF3: 84 FC       ANDA   #$FC
9DF5: 81 08       CMPA   #$08
9DF7: 27 0C       BEQ    $9E05
9DF9: A6 44       LDA    $4,U
9DFB: A1 05       CMPA   $5,X
9DFD: 27 22       BEQ    $9E21
9DFF: 10 8E 9E 2D LDY    #$9E2D		; ROM
9E03: 20 11       BRA    $9E16
9E05: A6 44       LDA    $4,U
9E07: A1 05       CMPA   $5,X
9E09: 26 16       BNE    $9E21
9E0B: 10 8E 9E 2B LDY    #$9E2B
9E0F: A6 41       LDA    $1,U
9E11: 84 04       ANDA   #$04
9E13: 44          LSRA
9E14: 31 A6       LEAY   A,Y
9E16: EC 4C       LDD    $C,U
9E18: A3 1C       SUBD   -$4,X
9E1A: A3 A4       SUBD   ,Y
9E1C: 26 03       BNE    $9E21
9E1E: EF 10       STU    -$10,X
9E20: 39          RTS
9E21: 0A 55       DEC    $55
9E23: 26 01       BNE    $9E26
9E25: 39          RTS
9E26: 33 C8 10    LEAU   $10,U
9E29: 20 A8       BRA    $9DD3
9E2B: 04 70       LSR    $70
9E2D: 03 F0       COM    $F0

; 2 jump-table ref
function_9e2f:
9E2F: 8D 98       BSR    function_9dc9
9E31: 27 10       BEQ    $9E43
9E33: A6 C4       LDA    ,U
9E35: 81 43       CMPA   #$43
9E37: 27 05       BEQ    $9E3E
9E39: C6 5C       LDB    #$5C
9E3B: 7E 99 3B    JMP    function_993b
9E3E: C6 AC       LDB    #$AC
9E40: 7E 99 3B    JMP    function_993b
9E43: 7E 8D C8    JMP    function_8dc8

; 1 jump-table ref
function_9e46:
9E46: A6 09       LDA    $9,X
9E48: 81 05       CMPA   #$05
9E4A: 22 1F       BHI    $9E6B
9E4C: 96 0A       LDA    $0A
9E4E: 84 1C       ANDA   #$1C
9E50: 81 10       CMPA   #$10
9E52: 26 17       BNE    $9E6B
9E54: A6 01       LDA    $1,X
9E56: 8B 04       ADDA   #$04
9E58: A7 01       STA    $1,X
9E5A: A7 07       STA    $7,X
9E5C: CE 9E 73    LDU    #$9E73		; ROM
9E5F: A6 09       LDA    $9,X
9E61: A6 C6       LDA    A,U
9E63: A7 09       STA    $9,X
9E65: CE DA 64    LDU    #$DA64
9E68: 7E 8D EA    JMP    $8DEA
9E6B: CE A0 13    LDU    #jump_table_a013
9E6E: A6 09       LDA    $9,X
9E70: 48          ASLA
9E71: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=14]


; 1 jump-table ref
function_9e79:
9E79: EE 10       LDU    -$10,X
9E7B: A6 41       LDA    $1,U
9E7D: 8A 01       ORA    #$01
9E7F: A7 41       STA    $1,U
9E81: 6A 0A       DEC    $A,X
9E83: 27 01       BEQ    $9E86
9E85: 39          RTS
9E86: CE DA 4C    LDU    #$DA4C		; ROM
9E89: 7E 8D E8    JMP    function_8de8

; 3 jump-table ref
function_9e8c:
9E8C: EE 10       LDU    -$10,X
9E8E: A6 41       LDA    $1,U
9E90: 8A 01       ORA    #$01
9E92: A7 41       STA    $1,U
9E94: 6A 0A       DEC    $A,X
9E96: 27 01       BEQ    $9E99
9E98: 39          RTS
9E99: 84 04       ANDA   #$04
9E9B: 26 07       BNE    $9EA4
9E9D: EC 1C       LDD    -$4,X
9E9F: C3 00 20    ADDD   #$0020
9EA2: ED 1C       STD    -$4,X
9EA4: CE DA 4C    LDU    #$DA4C		; ROM
9EA7: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_9eaa:
9EAA: EE 10       LDU    -$10,X
9EAC: A6 41       LDA    $1,U
9EAE: 8A 01       ORA    #$01
9EB0: A7 41       STA    $1,U
9EB2: 6A 0A       DEC    $A,X
9EB4: 27 01       BEQ    $9EB7
9EB6: 39          RTS
9EB7: 85 04       BITA   #$04
9EB9: 26 07       BNE    $9EC2
9EBB: EC 1C       LDD    -$4,X
9EBD: C3 00 20    ADDD   #$0020
9EC0: ED 1C       STD    -$4,X
9EC2: 6F 05       CLR    $5,X
9EC4: 86 20       LDA    #$20
9EC6: A7 0A       STA    $A,X
9EC8: 6C 09       INC    $9,X
9ECA: 39          RTS

; 1 jump-table ref
function_9ecb:
9ECB: 6D 0A       TST    $A,X
9ECD: 27 03       BEQ    $9ED2
9ECF: 6A 0A       DEC    $A,X
9ED1: 39          RTS
9ED2: EE 10       LDU    -$10,X
9ED4: A6 41       LDA    $1,U
9ED6: 84 18       ANDA   #$18
9ED8: 26 05       BNE    $9EDF
9EDA: C6 5C       LDB    #$5C
9EDC: 7E 99 3B    JMP    function_993b
9EDF: 6C 09       INC    $9,X
9EE1: 39          RTS

; 1 jump-table ref
function_9ee2:
9EE2: EE 10       LDU    -$10,X
9EE4: A6 41       LDA    $1,U
9EE6: 85 20       BITA   #$20
9EE8: 26 1F       BNE    $9F09
9EEA: 10 8E 9F 40 LDY    #$9F40		; ROM
9EEE: 84 18       ANDA   #$18
9EF0: 44          LSRA
9EF1: 44          LSRA
9EF2: 44          LSRA
9EF3: A6 A6       LDA    A,Y		; [rom_address]
9EF5: A7 0A       STA    $A,X
9EF7: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
9EFB: 96 E4       LDA    $E4
9EFD: C6 0F       LDB    #$0F
9EFF: E7 A6       STB    A,Y
9F01: 4C          INCA
9F02: 84 1F       ANDA   #$1F
9F04: 97 E4       STA    $E4
9F06: 6C 09       INC    $9,X
9F08: 39          RTS
9F09: 10 8E 9F 44 LDY    #$9F44
9F0D: 84 18       ANDA   #$18
9F0F: 44          LSRA
9F10: 44          LSRA
9F11: EC A6       LDD    A,Y		; [rom_address]
9F13: 97 CE       STA    $CE
9F15: E7 0A       STB    $A,X
9F17: CE 8C E9    LDU    #$8CE9
9F1A: 10 8E 5F 08 LDY    #$5F08		; layer 3 tilemap / HUD
9F1E: C6 FC       LDB    #$FC
9F20: A6 C0       LDA    ,U+		; [rom_address]
9F22: A7 E2       STA    ,-S		; [local]
9F24: A6 C0       LDA    ,U+		; [rom_address]
9F26: ED A1       STD    ,Y++
9F28: 6A E4       DEC    ,S		; [local]
9F2A: 26 F8       BNE    $9F24
9F2C: A6 E0       LDA    ,S+		; [local]
9F2E: 10 8E 13 60 LDY    #$1360
9F32: 96 E4       LDA    $E4
9F34: C6 04       LDB    #$04
9F36: E7 A6       STB    A,Y
9F38: 4C          INCA
9F39: 84 1F       ANDA   #$1F
9F3B: 97 E4       STA    $E4
9F3D: 6C 09       INC    $9,X
9F3F: 39          RTS


; 1 jump-table ref
function_9f4c:
9F4C: EE 10       LDU    -$10,X
9F4E: A6 41       LDA    $1,U
9F50: 85 20       BITA   #$20
9F52: 26 0E       BNE    $9F62
9F54: CE 16 CA    LDU    #$16CA		; direct page (shared with CPU1 $5600)
9F57: CC 00 01    LDD    #$0001
9F5A: BD 88 B2    JSR    function_88b2
9F5D: 6A 0A       DEC    $A,X
9F5F: 27 0F       BEQ    $9F70
9F61: 39          RTS
9F62: CE 16 CC    LDU    #$16CC
9F65: CC 00 01    LDD    #$0001
9F68: BD 88 B2    JSR    function_88b2
9F6B: 6A 0A       DEC    $A,X
9F6D: 27 01       BEQ    $9F70
9F6F: 39          RTS
9F70: EE 10       LDU    -$10,X
9F72: A6 41       LDA    $1,U
9F74: 84 07       ANDA   #$07
9F76: 8A 20       ORA    #$20
9F78: A7 41       STA    $1,U
9F7A: C6 5C       LDB    #$5C
9F7C: 7E 99 3B    JMP    function_993b

; 1 jump-table ref
function_9f7f:
9F7F: 96 0A       LDA    $0A
9F81: 84 1C       ANDA   #$1C
9F83: 81 0C       CMPA   #$0C
9F85: 26 17       BNE    $9F9E
9F87: A6 01       LDA    $1,X
9F89: 80 04       SUBA   #$04
9F8B: A7 01       STA    $1,X
9F8D: A7 07       STA    $7,X
9F8F: CE 9E 73    LDU    #$9E73		; ROM
9F92: A6 09       LDA    $9,X
9F94: A6 C6       LDA    A,U
9F96: A7 09       STA    $9,X
9F98: CE DA 4C    LDU    #$DA4C
9F9B: 7E 8D EA    JMP    $8DEA
9F9E: CE A0 23    LDU    #jump_table_a023
9FA1: A6 09       LDA    $9,X
9FA3: 48          ASLA
9FA4: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]

; 2 jump-table ref
function_9fa6:
9FA6: EE 10       LDU    -$10,X
9FA8: A6 41       LDA    $1,U
9FAA: 8A 01       ORA    #$01
9FAC: A7 41       STA    $1,U
9FAE: A6 42       LDA    $2,U
9FB0: 81 04       CMPA   #$04
9FB2: 27 01       BEQ    $9FB5
9FB4: 39          RTS
9FB5: CE DA 64    LDU    #$DA64		; ROM
9FB8: 7E 8D E8    JMP    function_8de8

; 8 jump-table ref
function_9fbb:
9FBB: EE 10       LDU    -$10,X
9FBD: A6 41       LDA    $1,U
9FBF: 8A 01       ORA    #$01
9FC1: A7 41       STA    $1,U
9FC3: 6A 0A       DEC    $A,X
9FC5: 27 01       BEQ    $9FC8
9FC7: 39          RTS
9FC8: A6 44       LDA    $4,U
9FCA: A7 05       STA    $5,X
9FCC: A6 41       LDA    $1,U
9FCE: 84 04       ANDA   #$04
9FD0: 26 07       BNE    $9FD9
9FD2: EC 1C       LDD    -$4,X
9FD4: 83 00 20    SUBD   #$0020
9FD7: ED 1C       STD    -$4,X
9FD9: CE DA 64    LDU    #$DA64		; ROM
9FDC: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_9fdf:
9FDF: 6A 0A       DEC    $A,X
9FE1: 27 01       BEQ    $9FE4
9FE3: 39          RTS
9FE4: 6F 0D       CLR    $D,X
9FE6: 0F 0B       CLR    $0B
9FE8: 0F 0D       CLR    $0D
9FEA: 96 0A       LDA    $0A
9FEC: 84 FC       ANDA   #$FC
9FEE: 97 0A       STA    $0A
9FF0: EE 10       LDU    -$10,X
9FF2: A6 41       LDA    $1,U
9FF4: 85 20       BITA   #$20
9FF6: 27 0C       BEQ    $A004
9FF8: 85 18       BITA   #$18
9FFA: 26 08       BNE    $A004
9FFC: 84 07       ANDA   #$07
9FFE: A7 41       STA    $1,U
A000: 86 BF       LDA    #$BF
A002: A7 46       STA    $6,U
A004: A6 84       LDA    ,X
A006: 84 03       ANDA   #$03
A008: 26 06       BNE    $A010
A00A: CE E0 14    LDU    #$E014		; ROM
A00D: 7E 99 37    JMP    $9937
A010: 6C 14       INC    -$C,X
A012: 39          RTS


; 1 jump-table ref
function_a02f:
A02F: 96 0A       LDA    $0A
A031: 84 1C       ANDA   #$1C
A033: 81 10       CMPA   #$10
A035: 26 17       BNE    $A04E
A037: A6 01       LDA    $1,X
A039: 8B 04       ADDA   #$04
A03B: A7 01       STA    $1,X
A03D: A7 07       STA    $7,X
A03F: CE A0 5B    LDU    #$A05B		; ROM
A042: A6 09       LDA    $9,X
A044: A6 C6       LDA    A,U
A046: A7 09       STA    $9,X
A048: CE DA 7C    LDU    #$DA7C
A04B: 7E 8D EA    JMP    $8DEA
A04E: 6A 0A       DEC    $A,X
A050: 27 01       BEQ    $A053
A052: 39          RTS
A053: CE A1 19    LDU    #jump_table_a119
A056: A6 09       LDA    $9,X
A058: 48          ASLA
A059: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=12]


; 1 jump-table ref
function_a061:
A061: CE DA 4C    LDU    #$DA4C		; ROM
A064: 7E 8D E8    JMP    function_8de8

; 3 jump-table ref
function_a067:
A067: EE 10       LDU    -$10,X
A069: A6 41       LDA    $1,U
A06B: 84 04       ANDA   #$04
A06D: 26 07       BNE    $A076
A06F: EC 1C       LDD    -$4,X
A071: C3 00 20    ADDD   #$0020
A074: ED 1C       STD    -$4,X
A076: CE DA 4C    LDU    #$DA4C		; ROM
A079: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a07c:
A07C: EE 10       LDU    -$10,X
A07E: A6 41       LDA    $1,U
A080: 84 04       ANDA   #$04
A082: 26 07       BNE    $A08B
A084: EC 1C       LDD    -$4,X
A086: C3 00 20    ADDD   #$0020
A089: ED 1C       STD    -$4,X
A08B: 86 40       LDA    #$40
A08D: A7 05       STA    $5,X
A08F: CE DA 4C    LDU    #$DA4C		; ROM
A092: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a095:
A095: 6F 0D       CLR    $D,X
A097: 0F 0B       CLR    $0B
A099: 0F 0D       CLR    $0D
A09B: 96 0A       LDA    $0A
A09D: 84 FC       ANDA   #$FC
A09F: 97 0A       STA    $0A
A0A1: CE E0 14    LDU    #$E014		; ROM
A0A4: 7E 99 37    JMP    $9937

; 1 jump-table ref
function_a0a7:
A0A7: 96 0A       LDA    $0A
A0A9: 84 1C       ANDA   #$1C
A0AB: 81 0C       CMPA   #$0C
A0AD: 26 17       BNE    $A0C6
A0AF: A6 01       LDA    $1,X
A0B1: 80 04       SUBA   #$04
A0B3: A7 01       STA    $1,X
A0B5: A7 07       STA    $7,X
A0B7: CE A0 5B    LDU    #$A05B		; ROM
A0BA: A6 09       LDA    $9,X
A0BC: A6 C6       LDA    A,U
A0BE: A7 09       STA    $9,X
A0C0: CE DA 4C    LDU    #$DA4C
A0C3: 7E 8D EA    JMP    $8DEA
A0C6: 6A 0A       DEC    $A,X
A0C8: 27 01       BEQ    $A0CB
A0CA: 39          RTS
A0CB: CE A1 25    LDU    #jump_table_a125
A0CE: A6 09       LDA    $9,X
A0D0: 48          ASLA
A0D1: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]

; 2 jump-table ref
function_a0d3:
A0D3: CE DA 7C    LDU    #$DA7C		; ROM
A0D6: 7E 8D E8    JMP    function_8de8

; 6 jump-table ref
function_a0d9:
A0D9: EE 10       LDU    -$10,X
A0DB: A6 44       LDA    $4,U
A0DD: A7 05       STA    $5,X
A0DF: A6 41       LDA    $1,U
A0E1: 84 04       ANDA   #$04
A0E3: 26 07       BNE    $A0EC
A0E5: EC 1C       LDD    -$4,X
A0E7: 83 00 20    SUBD   #$0020
A0EA: ED 1C       STD    -$4,X
A0EC: CE DA 7C    LDU    #$DA7C		; ROM
A0EF: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_a0f2:
A0F2: EE 10       LDU    -$10,X
A0F4: A6 41       LDA    $1,U
A0F6: 84 04       ANDA   #$04
A0F8: 26 07       BNE    $A101
A0FA: EC 1C       LDD    -$4,X
A0FC: 83 00 20    SUBD   #$0020
A0FF: ED 1C       STD    -$4,X
A101: CE DA 7C    LDU    #$DA7C		; ROM
A104: 7E 8D E8    JMP    function_8de8

; 4 jump-table ref
function_a107:
A107: 6F 0D       CLR    $D,X
A109: 0F 0B       CLR    $0B
A10B: 0F 0D       CLR    $0D
A10D: 96 0A       LDA    $0A
A10F: 84 FC       ANDA   #$FC
A111: 97 0A       STA    $0A
A113: CE E0 14    LDU    #$E014		; ROM
A116: 7E 99 37    JMP    $9937


; 2 jump-table ref
function_a131:
A131: 7E 8D C8    JMP    function_8dc8

; 2 jump-table ref
function_a134:
A134: 7E 8D C8    JMP    function_8dc8

; 1 jump-table ref
function_a137:
A137: 6A 0A       DEC    $A,X
A139: 27 01       BEQ    $A13C
A13B: 39          RTS
A13C: A6 84       LDA    ,X
A13E: 84 03       ANDA   #$03
A140: 26 06       BNE    $A148
A142: CE E0 28    LDU    #$E028		; ROM
A145: 7E 99 37    JMP    $9937
A148: 6C 14       INC    -$C,X
A14A: 39          RTS

; 1 jump-table ref
function_a14b:
A14B: 6A 0A       DEC    $A,X
A14D: 27 01       BEQ    $A150
A14F: 39          RTS
A150: A6 84       LDA    ,X
A152: 84 03       ANDA   #$03
A154: 26 06       BNE    $A15C
A156: CE E0 3C    LDU    #$E03C		; ROM
A159: 7E 99 37    JMP    $9937
A15C: 6C 14       INC    -$C,X
A15E: 39          RTS

; 1 jump-table ref
function_a15f:
A15F: 6A 0A       DEC    $A,X
A161: 27 01       BEQ    $A164
A163: 39          RTS
A164: A6 84       LDA    ,X
A166: 84 03       ANDA   #$03
A168: 26 06       BNE    $A170
A16A: CE E0 50    LDU    #$E050		; ROM
A16D: 7E 99 37    JMP    $9937
A170: 6C 14       INC    -$C,X
A172: 39          RTS


; 6 jump-table ref
player_shoots_a173:
A173: 96 CE       LDA    $CE
A175: 81 01       CMPA   #$01
A177: 27 10       BEQ    $A189
A179: A6 84       LDA    ,X
A17B: 84 03       ANDA   #$03
A17D: 27 04       BEQ    $A183
A17F: 86 01       LDA    #$01
A181: 97 0B       STA    $0B
A183: BD A2 59    JSR    function_a259
A186: 7E 8D C8    JMP    function_8dc8
A189: A6 84       LDA    ,X
A18B: 84 03       ANDA   #$03
A18D: 27 04       BEQ    $A193
A18F: 86 08       LDA    #$08
A191: 97 0B       STA    $0B
A193: BD A5 F8    JSR    function_a5f8
A196: E6 01       LDB    $1,X
A198: C4 03       ANDB   #$03
A19A: CB A0       ADDB   #$A0
A19C: E7 01       STB    $1,X
A19E: E7 07       STB    $7,X
A1A0: 7E 8D C8    JMP    function_8dc8

; 2 jump-table ref; jumped-to 1x  from $A575
function_a1a3:
A1A3: CE A1 AD    LDU    #jump_table_a1ad
A1A6: 96 0A       LDA    $0A
A1A8: 84 1C       ANDA   #$1C
A1AA: 44          LSRA
A1AB: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]


; 2 jump-table ref
function_a1b7:
A1B7: CE A3 5E    LDU    #jump_table_a35e
A1BA: A6 09       LDA    $9,X
A1BC: 48          ASLA
A1BD: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]

; 1 jump-table ref
function_a1bf:
A1BF: 86 19       LDA    #$19
A1C1: A7 01       STA    $1,X
A1C3: A7 07       STA    $7,X
A1C5: CE A3 5E    LDU    #jump_table_a35e
A1C8: A6 09       LDA    $9,X
A1CA: 48          ASLA
A1CB: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]

; 1 jump-table ref
function_a1cd:
A1CD: 86 1A       LDA    #$1A
A1CF: A7 01       STA    $1,X
A1D1: A7 07       STA    $7,X
A1D3: CE A3 5E    LDU    #jump_table_a35e
A1D6: A6 09       LDA    $9,X
A1D8: 48          ASLA
A1D9: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]

; 1 jump-table ref
function_a1db:
A1DB: A6 01       LDA    $1,X
A1DD: 84 03       ANDA   #$03
A1DF: 8B 1C       ADDA   #$1C
A1E1: A7 01       STA    $1,X
A1E3: A7 07       STA    $7,X
A1E5: CE A5 05    LDU    #jump_table_a505
A1E8: A6 09       LDA    $9,X
A1EA: 48          ASLA
A1EB: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]

; 1 jump-table ref
function_a1ed:
A1ED: 6A 0A       DEC    $A,X
A1EF: 27 01       BEQ    $A1F2
A1F1: 39          RTS
A1F2: CE D9 FC    LDU    #$D9FC		; ROM
A1F5: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a1f8:
A1F8: 96 0B       LDA    $0B
A1FA: 81 01       CMPA   #$01
A1FC: 27 0F       BEQ    $A20D
A1FE: 0A 0B       DEC    $0B
A200: BD A2 59    JSR    function_a259
A203: 86 FF       LDA    #$FF
A205: A7 09       STA    $9,X
A207: CE D9 FC    LDU    #$D9FC		; ROM
A20A: 7E 8D E8    JMP    function_8de8
A20D: 6A 0A       DEC    $A,X
A20F: 27 01       BEQ    $A212
A211: 39          RTS
A212: 0A 0B       DEC    $0B
A214: CE D9 FC    LDU    #$D9FC
A217: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a21a:
A21A: 0D 0B       TST    $0B
A21C: 27 0C       BEQ    $A22A
A21E: 8D 39       BSR    function_a259
A220: 86 FF       LDA    #$FF
A222: A7 09       STA    $9,X
A224: CE D9 FC    LDU    #$D9FC		; ROM
A227: 7E 8D E8    JMP    function_8de8
A22A: 6A 0A       DEC    $A,X
A22C: 27 01       BEQ    $A22F
A22E: 39          RTS
A22F: CE D9 FC    LDU    #$D9FC
A232: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a235:
A235: 0D 0B       TST    $0B
A237: 27 0C       BEQ    $A245
A239: 8D 1E       BSR    function_a259
A23B: 86 FF       LDA    #$FF
A23D: A7 09       STA    $9,X
A23F: CE D9 FC    LDU    #$D9FC		; ROM
A242: 7E 8D E8    JMP    function_8de8
A245: 6A 0A       DEC    $A,X
A247: 27 01       BEQ    $A24A
A249: 39          RTS
A24A: A6 84       LDA    ,X
A24C: 84 03       ANDA   #$03
A24E: 26 06       BNE    $A256
A250: CE E0 64    LDU    #$E064
A253: 7E 99 37    JMP    $9937
A256: 6C 14       INC    -$C,X
A258: 39          RTS


; called 4x  from $A183, $A200, $A21E, $A239
function_a259:
A259: DC CA       LDD    $CA
A25B: 27 17       BEQ    $A274
A25D: CE 09 00    LDU    #$0900		; work RAM (shared with CPU1 $4400)
A260: C6 FF       LDB    #$FF
A262: E1 C4       CMPB   ,U
A264: 26 05       BNE    $A26B
A266: E1 C8 10    CMPB   $10,U
A269: 27 19       BEQ    $A284
A26B: 33 C8 10    LEAU   $10,U
A26E: 11 83 0C 00 CMPU   #$0C00
A272: 25 EE       BCS    $A262
A274: 10 8E 13 A0 LDY    #$13A0
A278: 96 E6       LDA    $E6
A27A: C6 2B       LDB    #$2B
A27C: E7 A6       STB    A,Y
A27E: 4C          INCA
A27F: 84 1F       ANDA   #$1F
A281: 97 E6       STA    $E6
A283: 39          RTS
A284: DC CA       LDD    $CA
A286: 10 83 00 01 CMPD   #$0001
A28A: 27 23       BEQ    $A2AF
A28C: 10 8E 13 A0 LDY    #$13A0
A290: 96 E6       LDA    $E6
A292: C6 05       LDB    #$05
A294: E7 A6       STB    A,Y
A296: 4C          INCA
A297: 84 1F       ANDA   #$1F
A299: 97 E6       STA    $E6
A29B: A6 07       LDA    $7,X
A29D: 84 02       ANDA   #$02
A29F: 26 07       BNE    $A2A8
A2A1: 10 8E A3 1E LDY    #$A31E		; ROM
A2A5: 7E A2 D2    JMP    $A2D2
A2A8: 10 8E A3 2E LDY    #$A32E
A2AC: 7E A2 D2    JMP    $A2D2
A2AF: 10 8E 13 60 LDY    #$1360
A2B3: 96 E4       LDA    $E4
A2B5: C6 01       LDB    #$01
A2B7: E7 A6       STB    A,Y
A2B9: 4C          INCA
A2BA: 84 1F       ANDA   #$1F
A2BC: 97 E4       STA    $E4
A2BE: A6 01       LDA    $1,X
A2C0: 84 02       ANDA   #$02
A2C2: 26 07       BNE    $A2CB
A2C4: 10 8E A3 3E LDY    #$A33E
A2C8: 7E A2 D2    JMP    $A2D2
A2CB: 10 8E A3 4E LDY    #$A34E
A2CF: 7E A2 D2    JMP    $A2D2
A2D2: 86 E0       LDA    #$E0
A2D4: E6 A0       LDB    ,Y+
A2D6: ED C4       STD    ,U
A2D8: EC A1       LDD    ,Y++
A2DA: ED 4E       STD    $E,U
A2DC: EC A1       LDD    ,Y++
A2DE: ED 46       STD    $6,U
A2E0: EC 1A       LDD    -$6,X
A2E2: E3 A1       ADDD   ,Y++
A2E4: ED 4A       STD    $A,U
A2E6: EC 1C       LDD    -$4,X
A2E8: E3 A1       ADDD   ,Y++
A2EA: ED 4C       STD    $C,U
A2EC: E6 05       LDB    $5,X
A2EE: E7 44       STB    $4,U
A2F0: 6F 42       CLR    $2,U
A2F2: 6F 43       CLR    $3,U
A2F4: 0C 40       INC    $40
A2F6: 33 C8 10    LEAU   $10,U
A2F9: 86 E2       LDA    #$E2
A2FB: E6 A0       LDB    ,Y+
A2FD: ED C4       STD    ,U
A2FF: EC A1       LDD    ,Y++
A301: ED 4E       STD    $E,U
A303: EC 1A       LDD    -$6,X
A305: E3 A1       ADDD   ,Y++
A307: ED 4A       STD    $A,U
A309: EC 1C       LDD    -$4,X
A30B: E3 A1       ADDD   ,Y++
A30D: ED 4C       STD    $C,U
A30F: 6F 42       CLR    $2,U
A311: 6F 43       CLR    $3,U
A313: 0C 40       INC    $40
A315: CE 16 CA    LDU    #$16CA		; direct page (shared with CPU1 $5600)
A318: CC 99 99    LDD    #$9999
A31B: 7E 88 B2    JMP    function_88b2


; 4 jump-table ref
function_a366:
A366: 96 CE       LDA    $CE
A368: 81 01       CMPA   #$01
A36A: 27 10       BEQ    $A37C
A36C: A6 84       LDA    ,X
A36E: 84 03       ANDA   #$03
A370: 27 04       BEQ    $A376
A372: 86 01       LDA    #$01
A374: 97 0B       STA    $0B
A376: BD A4 4C    JSR    function_a44c
A379: 7E 8D C8    JMP    function_8dc8
A37C: A6 84       LDA    ,X
A37E: 84 03       ANDA   #$03
A380: 27 04       BEQ    $A386
A382: 86 08       LDA    #$08
A384: 97 0B       STA    $0B
A386: BD A7 A1    JSR    function_a7a1
A389: E6 01       LDB    $1,X
A38B: C4 03       ANDB   #$03
A38D: CB A4       ADDB   #$A4
A38F: E7 01       STB    $1,X
A391: E7 07       STB    $7,X
A393: 7E 8D C8    JMP    function_8dc8

; 1 jump-table ref; jumped-to 1x  from $A71E
function_a396:
A396: CE A3 A0    LDU    #jump_table_a3a0
A399: 96 0A       LDA    $0A
A39B: 84 1C       ANDA   #$1C
A39D: 44          LSRA
A39E: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]


; 2 jump-table ref
function_a3aa:
A3AA: CE A5 05    LDU    #jump_table_a505
A3AD: A6 09       LDA    $9,X
A3AF: 48          ASLA
A3B0: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

; 1 jump-table ref
function_a3b2:
A3B2: 86 1D       LDA    #$1D
A3B4: A7 01       STA    $1,X
A3B6: A7 07       STA    $7,X
A3B8: CE A5 05    LDU    #jump_table_a505
A3BB: A6 09       LDA    $9,X
A3BD: 48          ASLA
A3BE: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

; 1 jump-table ref
function_a3c0:
A3C0: 86 1E       LDA    #$1E
A3C2: A7 01       STA    $1,X
A3C4: A7 07       STA    $7,X
A3C6: CE A5 05    LDU    #jump_table_a505
A3C9: A6 09       LDA    $9,X
A3CB: 48          ASLA
A3CC: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

; 1 jump-table ref
function_a3ce:
A3CE: A6 01       LDA    $1,X
A3D0: 84 03       ANDA   #$03
A3D2: 8B 18       ADDA   #$18
A3D4: A7 01       STA    $1,X
A3D6: A7 07       STA    $7,X
A3D8: CE A3 5E    LDU    #jump_table_a35e
A3DB: A6 09       LDA    $9,X
A3DD: 48          ASLA
A3DE: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]

; 1 jump-table ref
function_a3e0:
A3E0: 6A 0A       DEC    $A,X
A3E2: 27 01       BEQ    $A3E5
A3E4: 39          RTS
A3E5: CE DA 0C    LDU    #$DA0C		; ROM
A3E8: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a3eb:
A3EB: 96 0B       LDA    $0B
A3ED: 81 01       CMPA   #$01
A3EF: 27 0F       BEQ    $A400
A3F1: 0A 0B       DEC    $0B
A3F3: BD A4 4C    JSR    function_a44c
A3F6: 86 FF       LDA    #$FF
A3F8: A7 09       STA    $9,X
A3FA: CE DA 0C    LDU    #$DA0C		; ROM
A3FD: 7E 8D E8    JMP    function_8de8
A400: 6A 0A       DEC    $A,X
A402: 27 01       BEQ    $A405
A404: 39          RTS
A405: 0A 0B       DEC    $0B
A407: CE DA 0C    LDU    #$DA0C
A40A: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a40d:
A40D: 0D 0B       TST    $0B
A40F: 27 0C       BEQ    $A41D
A411: 8D 39       BSR    function_a44c
A413: 86 FF       LDA    #$FF
A415: A7 09       STA    $9,X
A417: CE DA 0C    LDU    #$DA0C		; ROM
A41A: 7E 8D E8    JMP    function_8de8
A41D: 6A 0A       DEC    $A,X
A41F: 27 01       BEQ    $A422
A421: 39          RTS
A422: CE DA 0C    LDU    #$DA0C
A425: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a428:
A428: 0D 0B       TST    $0B
A42A: 27 0C       BEQ    $A438
A42C: 8D 1E       BSR    function_a44c
A42E: 86 FF       LDA    #$FF
A430: A7 09       STA    $9,X
A432: CE DA 0C    LDU    #$DA0C		; ROM
A435: 7E 8D E8    JMP    function_8de8
A438: 6A 0A       DEC    $A,X
A43A: 27 01       BEQ    $A43D
A43C: 39          RTS
A43D: A6 84       LDA    ,X
A43F: 84 03       ANDA   #$03
A441: 26 06       BNE    $A449
A443: CE E0 78    LDU    #$E078
A446: 7E 99 37    JMP    $9937
A449: 6C 14       INC    -$C,X
A44B: 39          RTS

; called 4x  from $A376, $A3F3, $A411, $A42C
function_a44c:
A44C: DC CA       LDD    $CA
A44E: 27 17       BEQ    $A467
A450: CE 09 00    LDU    #$0900		; work RAM (shared with CPU1 $4400)
A453: C6 FF       LDB    #$FF
A455: E1 C4       CMPB   ,U
A457: 26 05       BNE    $A45E
A459: E1 C8 10    CMPB   $10,U
A45C: 27 19       BEQ    $A477
A45E: 33 C8 10    LEAU   $10,U
A461: 11 83 0C 00 CMPU   #$0C00
A465: 25 EE       BCS    $A455
A467: 10 8E 13 A0 LDY    #$13A0
A46B: 96 E6       LDA    $E6
A46D: C6 2B       LDB    #$2B
A46F: E7 A6       STB    A,Y
A471: 4C          INCA
A472: 84 1F       ANDA   #$1F
A474: 97 E6       STA    $E6
A476: 39          RTS
A477: DC CA       LDD    $CA
A479: 10 83 00 01 CMPD   #$0001
A47D: 27 23       BEQ    $A4A2
A47F: 10 8E 13 A0 LDY    #$13A0
A483: 96 E6       LDA    $E6
A485: C6 05       LDB    #$05
A487: E7 A6       STB    A,Y
A489: 4C          INCA
A48A: 84 1F       ANDA   #$1F
A48C: 97 E6       STA    $E6
A48E: A6 07       LDA    $7,X
A490: 84 02       ANDA   #$02
A492: 26 07       BNE    $A49B
A494: 10 8E A4 C5 LDY    #$A4C5		; ROM
A498: 7E A2 D2    JMP    $A2D2
A49B: 10 8E A4 D5 LDY    #$A4D5
A49F: 7E A2 D2    JMP    $A2D2
A4A2: 10 8E 13 60 LDY    #$1360
A4A6: 96 E4       LDA    $E4
A4A8: C6 01       LDB    #$01
A4AA: E7 A6       STB    A,Y
A4AC: 4C          INCA
A4AD: 84 1F       ANDA   #$1F
A4AF: 97 E4       STA    $E4
A4B1: A6 01       LDA    $1,X
A4B3: 84 02       ANDA   #$02
A4B5: 26 07       BNE    $A4BE
A4B7: 10 8E A4 E5 LDY    #$A4E5
A4BB: 7E A2 D2    JMP    $A2D2
A4BE: 10 8E A4 F5 LDY    #$A4F5
A4C2: 7E A2 D2    JMP    $A2D2



; 1 jump-table ref
function_a50d:
A50D: DC CC       LDD    $CC
A50F: 27 4A       BEQ    $A55B
A511: CE A5 1B    LDU    #jump_table_a51b
A514: 96 0A       LDA    $0A
A516: 84 1C       ANDA   #$1C
A518: 44          LSRA
A519: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]


; 2 jump-table ref
function_a525:
A525: CE A6 AE    LDU    #jump_table_a6ae
A528: A6 09       LDA    $9,X
A52A: 48          ASLA
A52B: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]

; 1 jump-table ref
function_a52d:
A52D: 86 A1       LDA    #$A1
A52F: A7 01       STA    $1,X
A531: A7 07       STA    $7,X
A533: CE A6 AE    LDU    #jump_table_a6ae
A536: A6 09       LDA    $9,X
A538: 48          ASLA
A539: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]

; 1 jump-table ref
function_a53b:
A53B: 86 A2       LDA    #$A2
A53D: A7 01       STA    $1,X
A53F: A7 07       STA    $7,X
A541: CE A6 AE    LDU    #jump_table_a6ae
A544: A6 09       LDA    $9,X
A546: 48          ASLA
A547: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]

; 1 jump-table ref
function_a549:
A549: A6 01       LDA    $1,X
A54B: 84 03       ANDA   #$03
A54D: 8B A4       ADDA   #$A4
A54F: A7 01       STA    $1,X
A551: A7 07       STA    $7,X
A553: CE A8 0B    LDU    #jump_table_a80b
A556: A6 09       LDA    $9,X
A558: 48          ASLA
A559: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]
A55B: 10 8E 5F 08 LDY    #$5F08		; layer 3 tilemap / HUD
A55F: 86 FF       LDA    #$FF
A561: F6 8C E9    LDB    $8CE9		; ROM
A564: A7 A1       STA    ,Y++
A566: 5A          DECB
A567: 26 FB       BNE    $A564
A569: 0F CE       CLR    $CE
A56B: A6 01       LDA    $1,X
A56D: 84 03       ANDA   #$03
A56F: 8B 18       ADDA   #$18
A571: A7 01       STA    $1,X
A573: A7 07       STA    $7,X
A575: 7E A1 A3    JMP    function_a1a3

; 1 jump-table ref
function_a578:
A578: 6A 0A       DEC    $A,X
A57A: 27 01       BEQ    $A57D
A57C: 39          RTS
A57D: CE DA E0    LDU    #$DAE0		; ROM
A580: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a583:
A583: 96 0B       LDA    $0B
A585: 81 01       CMPA   #$01
A587: 27 0F       BEQ    $A598
A589: 0A 0B       DEC    $0B
A58B: BD A5 F8    JSR    function_a5f8
A58E: 86 FF       LDA    #$FF
A590: A7 09       STA    $9,X
A592: CE DA E0    LDU    #$DAE0		; ROM
A595: 7E 8D E8    JMP    function_8de8
A598: 6A 0A       DEC    $A,X
A59A: 27 01       BEQ    $A59D
A59C: 39          RTS
A59D: 0A 0B       DEC    $0B
A59F: CE DA E0    LDU    #$DAE0
A5A2: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a5a5:
A5A5: 0D 0B       TST    $0B
A5A7: 27 0C       BEQ    $A5B5
A5A9: 8D 4D       BSR    function_a5f8
A5AB: 86 FF       LDA    #$FF
A5AD: A7 09       STA    $9,X
A5AF: CE DA E0    LDU    #$DAE0		; ROM
A5B2: 7E 8D E8    JMP    function_8de8
A5B5: 6A 0A       DEC    $A,X
A5B7: 27 01       BEQ    $A5BA
A5B9: 39          RTS
A5BA: CE DA E0    LDU    #$DAE0
A5BD: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a5c0:
A5C0: 0D 0B       TST    $0B
A5C2: 27 0C       BEQ    $A5D0
A5C4: 8D 32       BSR    function_a5f8
A5C6: 86 FF       LDA    #$FF
A5C8: A7 09       STA    $9,X
A5CA: CE DA E0    LDU    #$DAE0		; ROM
A5CD: 7E 8D E8    JMP    function_8de8
A5D0: 6A 0A       DEC    $A,X
A5D2: 27 01       BEQ    $A5D5
A5D4: 39          RTS
A5D5: DC CC       LDD    $CC
A5D7: 26 10       BNE    $A5E9
A5D9: 0F CE       CLR    $CE
A5DB: 10 8E 5F 08 LDY    #$5F08		; layer 3 tilemap / HUD
A5DF: 86 FF       LDA    #$FF
A5E1: F6 8C E9    LDB    $8CE9
A5E4: A7 A1       STA    ,Y++
A5E6: 5A          DECB
A5E7: 26 FB       BNE    $A5E4
A5E9: A6 84       LDA    ,X
A5EB: 84 03       ANDA   #$03
A5ED: 26 06       BNE    $A5F5
A5EF: CE E0 64    LDU    #$E064
A5F2: 7E 99 37    JMP    $9937
A5F5: 6C 14       INC    -$C,X
A5F7: 39          RTS

; called 4x  from $A193, $A58B, $A5A9, $A5C4
function_a5f8:
A5F8: CE 09 00    LDU    #$0900		; work RAM (shared with CPU1 $4400)
A5FB: C6 FF       LDB    #$FF
A5FD: E1 C4       CMPB   ,U
A5FF: 26 05       BNE    $A606

; 2 jump-table ref
function_a601:
A601: E1 C8 10    CMPB   $10,U
A604: 27 19       BEQ    $A61F
A606: 33 C8 10    LEAU   $10,U
A609: 11 83 0C 00 CMPU   #$0C00
A60D: 25 EE       BCS    $A5FD
A60F: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
A613: 96 E6       LDA    $E6
A615: C6 2B       LDB    #$2B
A617: E7 A6       STB    A,Y
A619: 4C          INCA
A61A: 84 1F       ANDA   #$1F
A61C: 97 E6       STA    $E6
A61E: 39          RTS
A61F: 10 8E 13 A0 LDY    #$13A0
A623: 96 E6       LDA    $E6
A625: C6 07       LDB    #$07
A627: E7 A6       STB    A,Y
A629: 4C          INCA
A62A: 84 1F       ANDA   #$1F
A62C: 97 E6       STA    $E6
A62E: A6 07       LDA    $7,X
A630: 84 02       ANDA   #$02
A632: 26 07       BNE    $A63B
A634: 10 8E A6 8E LDY    #$A68E		; ROM
A638: 7E A6 42    JMP    $A642
A63B: 10 8E A6 9E LDY    #$A69E
A63F: 7E A6 42    JMP    $A642
A642: 86 E0       LDA    #$E0
A644: E6 A0       LDB    ,Y+
A646: ED C4       STD    ,U
A648: EC A1       LDD    ,Y++
A64A: ED 4E       STD    $E,U
A64C: EC A1       LDD    ,Y++
A64E: ED 46       STD    $6,U
A650: EC 1A       LDD    -$6,X
A652: E3 A1       ADDD   ,Y++
A654: ED 4A       STD    $A,U
A656: EC 1C       LDD    -$4,X
A658: E3 A1       ADDD   ,Y++
A65A: ED 4C       STD    $C,U
A65C: E6 05       LDB    $5,X
A65E: E7 44       STB    $4,U
A660: 6F 42       CLR    $2,U
A662: 6F 43       CLR    $3,U
A664: 0C 40       INC    $40
A666: 33 C8 10    LEAU   $10,U
A669: 86 E2       LDA    #$E2
A66B: E6 A0       LDB    ,Y+
A66D: ED C4       STD    ,U
A66F: EC A1       LDD    ,Y++
A671: ED 4E       STD    $E,U
A673: EC 1A       LDD    -$6,X
A675: E3 A1       ADDD   ,Y++
A677: ED 4A       STD    $A,U
A679: EC 1C       LDD    -$4,X
A67B: E3 A1       ADDD   ,Y++
A67D: ED 4C       STD    $C,U
A67F: 6F 42       CLR    $2,U
A681: 6F 43       CLR    $3,U
A683: 0C 40       INC    $40
A685: CE 16 CC    LDU    #$16CC		; direct page (shared with CPU1 $5600)
A688: CC 99 99    LDD    #$9999
A68B: 7E 88 B2    JMP    function_88b2


; 1 jump-table ref
function_a6b6:
A6B6: DC CC       LDD    $CC
A6B8: 27 4A       BEQ    $A704
A6BA: CE A6 C4    LDU    #jump_table_a6c4
A6BD: 96 0A       LDA    $0A
A6BF: 84 1C       ANDA   #$1C
A6C1: 44          LSRA
A6C2: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]


; 2 jump-table ref
function_a6ce:
A6CE: CE A8 0B    LDU    #jump_table_a80b
A6D1: A6 09       LDA    $9,X
A6D3: 48          ASLA
A6D4: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

; 1 jump-table ref
function_a6d6:
A6D6: 86 A5       LDA    #$A5
A6D8: A7 01       STA    $1,X
A6DA: A7 07       STA    $7,X
A6DC: CE A8 0B    LDU    #jump_table_a80b
A6DF: A6 09       LDA    $9,X
A6E1: 48          ASLA
A6E2: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

; 1 jump-table ref
function_a6e4:
A6E4: 86 A6       LDA    #$A6
A6E6: A7 01       STA    $1,X
A6E8: A7 07       STA    $7,X
A6EA: CE A8 0B    LDU    #jump_table_a80b
A6ED: A6 09       LDA    $9,X
A6EF: 48          ASLA
A6F0: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

; 1 jump-table ref
function_a6f2:
A6F2: A6 01       LDA    $1,X
A6F4: 84 03       ANDA   #$03
A6F6: 8B A0       ADDA   #$A0
A6F8: A7 01       STA    $1,X
A6FA: A7 07       STA    $7,X
A6FC: CE A6 AE    LDU    #jump_table_a6ae
A6FF: A6 09       LDA    $9,X
A701: 48          ASLA
A702: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]
A704: 10 8E 5F 08 LDY    #$5F08		; layer 3 tilemap / HUD
A708: 86 FF       LDA    #$FF
A70A: F6 8C E9    LDB    $8CE9		; ROM
A70D: A7 A1       STA    ,Y++
A70F: 5A          DECB
A710: 26 FB       BNE    $A70D
A712: 0F CE       CLR    $CE
A714: A6 01       LDA    $1,X
A716: 84 03       ANDA   #$03
A718: 8B 1C       ADDA   #$1C
A71A: A7 01       STA    $1,X
A71C: A7 07       STA    $7,X
A71E: 7E A3 96    JMP    function_a396

; 1 jump-table ref
function_a721:
A721: 6A 0A       DEC    $A,X
A723: 27 01       BEQ    $A726
A725: 39          RTS
A726: CE DA F0    LDU    #$DAF0		; ROM
A729: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a72c:
A72C: 96 0B       LDA    $0B
A72E: 81 01       CMPA   #$01
A730: 27 0F       BEQ    $A741
A732: 0A 0B       DEC    $0B
A734: BD A7 A1    JSR    function_a7a1
A737: 86 FF       LDA    #$FF
A739: A7 09       STA    $9,X
A73B: CE DA F0    LDU    #$DAF0		; ROM
A73E: 7E 8D E8    JMP    function_8de8
A741: 6A 0A       DEC    $A,X
A743: 27 01       BEQ    $A746
A745: 39          RTS
A746: 0A 0B       DEC    $0B
A748: CE DA F0    LDU    #$DAF0
A74B: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a74e:
A74E: 0D 0B       TST    $0B
A750: 27 0C       BEQ    $A75E
A752: 8D 4D       BSR    function_a7a1
A754: 86 FF       LDA    #$FF
A756: A7 09       STA    $9,X
A758: CE DA F0    LDU    #$DAF0		; ROM
A75B: 7E 8D E8    JMP    function_8de8
A75E: 6A 0A       DEC    $A,X
A760: 27 01       BEQ    $A763
A762: 39          RTS
A763: CE DA F0    LDU    #$DAF0
A766: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a769:
A769: 0D 0B       TST    $0B
A76B: 27 0C       BEQ    $A779
A76D: 8D 32       BSR    function_a7a1
A76F: 86 FF       LDA    #$FF
A771: A7 09       STA    $9,X
A773: CE DA F0    LDU    #$DAF0		; ROM
A776: 7E 8D E8    JMP    function_8de8
A779: 6A 0A       DEC    $A,X
A77B: 27 01       BEQ    $A77E
A77D: 39          RTS
A77E: DC CC       LDD    $CC
A780: 26 10       BNE    $A792
A782: 0F CE       CLR    $CE
A784: 10 8E 5F 08 LDY    #$5F08		; layer 3 tilemap / HUD
A788: 86 FF       LDA    #$FF
A78A: F6 8C E9    LDB    $8CE9
A78D: A7 A1       STA    ,Y++
A78F: 5A          DECB
A790: 26 FB       BNE    $A78D
A792: A6 84       LDA    ,X
A794: 84 03       ANDA   #$03
A796: 26 06       BNE    $A79E
A798: CE E0 78    LDU    #$E078
A79B: 7E 99 37    JMP    $9937
A79E: 6C 14       INC    -$C,X
A7A0: 39          RTS

; called 4x  from $A386, $A734, $A752, $A76D
function_a7a1:
A7A1: CE 09 00    LDU    #$0900		; work RAM (shared with CPU1 $4400)
A7A4: C6 FF       LDB    #$FF
A7A6: E1 C4       CMPB   ,U
A7A8: 26 05       BNE    $A7AF
A7AA: E1 C8 10    CMPB   $10,U
A7AD: 27 19       BEQ    $A7C8
A7AF: 33 C8 10    LEAU   $10,U
A7B2: 11 83 0C 00 CMPU   #$0C00
A7B6: 25 EE       BCS    $A7A6
A7B8: 10 8E 13 A0 LDY    #$13A0
A7BC: 96 E6       LDA    $E6
A7BE: C6 2B       LDB    #$2B
A7C0: E7 A6       STB    A,Y
A7C2: 4C          INCA
A7C3: 84 1F       ANDA   #$1F
A7C5: 97 E6       STA    $E6
A7C7: 39          RTS
A7C8: 10 8E 13 A0 LDY    #$13A0
A7CC: 96 E6       LDA    $E6
A7CE: C6 07       LDB    #$07
A7D0: E7 A6       STB    A,Y
A7D2: 4C          INCA
A7D3: 84 1F       ANDA   #$1F
A7D5: 97 E6       STA    $E6
A7D7: A6 01       LDA    $1,X
A7D9: 84 02       ANDA   #$02
A7DB: 26 07       BNE    $A7E4
A7DD: 10 8E A7 EB LDY    #$A7EB		; ROM
A7E1: 7E A6 42    JMP    $A642
A7E4: 10 8E A7 FB LDY    #$A7FB
A7E8: 7E A6 42    JMP    $A642


; 4 jump-table ref
function_a813:
A813: CC 00 70    LDD    #$0070
A816: ED 18       STD    -$8,X
A818: 7E 8D C8    JMP    function_8dc8

; 1 jump-table ref
function_a81b:
A81B: CE A8 35    LDU    #$A835		; ROM
A81E: 96 0A       LDA    $0A
A820: 84 0C       ANDA   #$0C
A822: 44          LSRA
A823: EC C6       LDD    A,U
A825: ED 16       STD    -$A,X
A827: CE A8 2F    LDU    #jump_table_a82f
A82A: A6 09       LDA    $9,X
A82C: 48          ASLA
A82D: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]


; 1 jump-table ref
function_a83d:
A83D: A6 01       LDA    $1,X
A83F: 84 02       ANDA   #$02
A841: 26 17       BNE    $A85A
A843: CE A8 35    LDU    #$A835		; ROM
A846: 96 0A       LDA    $0A
A848: 84 0C       ANDA   #$0C
A84A: 44          LSRA
A84B: EC C6       LDD    A,U
A84D: C3 00 20    ADDD   #$0020
A850: ED 16       STD    -$A,X
A852: CE A8 71    LDU    #jump_table_a871
A855: A6 09       LDA    $9,X
A857: 48          ASLA
A858: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]
A85A: CE A8 35    LDU    #$a835
A85D: 96 0A       LDA    $0A
A85F: 84 0C       ANDA   #$0C
A861: 44          LSRA
A862: EC C6       LDD    A,U
A864: C3 FF E0    ADDD   #$FFE0
A867: ED 16       STD    -$A,X
A869: CE A8 71    LDU    #jump_table_a871
A86C: A6 09       LDA    $9,X
A86E: 48          ASLA
A86F: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]


; 2 jump-table ref
function_a877:
A877: BD 8E 05    JSR    function_8e05
A87A: BD 90 76    JSR    function_9076
A87D: 26 07       BNE    $A886
A87F: A6 19       LDA    -$7,X
A881: 81 40       CMPA   #$40
A883: 2D 03       BLT    $A888
A885: 39          RTS
A886: 6C 09       INC    $9,X
A888: CE D9 80    LDU    #$D980		; ROM
A88B: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_a88e:
A88E: BD 8E 05    JSR    function_8e05
A891: BD 90 76    JSR    function_9076
A894: 26 07       BNE    $A89D
A896: A6 19       LDA    -$7,X
A898: 81 C0       CMPA   #$C0
A89A: 2F 01       BLE    $A89D
A89C: 39          RTS
A89D: CE D9 80    LDU    #$D980		; ROM
A8A0: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_a8a3:
A8A3: BD 8E 05    JSR    function_8e05
A8A6: BD 90 76    JSR    function_9076
A8A9: 26 01       BNE    $A8AC
A8AB: 39          RTS
A8AC: 0F 0B       CLR    $0B
A8AE: 0F 0D       CLR    $0D
A8B0: 96 0A       LDA    $0A
A8B2: 84 FC       ANDA   #$FC
A8B4: 97 0A       STA    $0A
A8B6: A6 84       LDA    ,X
A8B8: 84 03       ANDA   #$03
A8BA: 26 06       BNE    $A8C2
A8BC: CE E0 14    LDU    #$E014		; ROM
A8BF: 7E 99 37    JMP    $9937
A8C2: 6C 14       INC    -$C,X
A8C4: 39          RTS

; 2 jump-table ref
function_a8c5:
A8C5: A6 01       LDA    $1,X
A8C7: A1 07       CMPA   $7,X
A8C9: 27 1B       BEQ    $A8E6
A8CB: 84 FC       ANDA   #$FC
A8CD: 81 28       CMPA   #$28
A8CF: 27 08       BEQ    $A8D9
A8D1: CC 00 A0    LDD    #$00A0
A8D4: ED 18       STD    -$8,X
A8D6: 7E 8D C8    JMP    function_8dc8
A8D9: A6 07       LDA    $7,X
A8DB: A7 01       STA    $1,X
A8DD: EC 16       LDD    -$A,X
A8DF: 53          COMB
A8E0: 43          COMA
A8E1: C3 00 01    ADDD   #$0001
A8E4: ED 16       STD    -$A,X
A8E6: A6 09       LDA    $9,X
A8E8: 81 09       CMPA   #$09
A8EA: 24 E5       BCC    $A8D1
A8EC: CE D9 A0    LDU    #$D9A0		; ROM
A8EF: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_a8f2:
A8F2: A6 01       LDA    $1,X
A8F4: A1 07       CMPA   $7,X
A8F6: 27 16       BEQ    $A90E
A8F8: 84 FC       ANDA   #$FC
A8FA: 81 34       CMPA   #$34
A8FC: 27 03       BEQ    $A901
A8FE: 7E 8D C8    JMP    function_8dc8
A901: A6 07       LDA    $7,X
A903: A7 01       STA    $1,X
A905: EC 16       LDD    -$A,X
A907: 53          COMB
A908: 43          COMA
A909: C3 00 01    ADDD   #$0001
A90C: ED 16       STD    -$A,X
A90E: CE D9 F0    LDU    #$D9F0		; ROM
A911: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a914:
A914: CE A9 FE    LDU    #jump_table_a9fe
A917: A6 09       LDA    $9,X
A919: 48          ASLA
A91A: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=15]

; 1 jump-table ref
function_a91c:
A91C: 6A 0A       DEC    $A,X
A91E: 27 01       BEQ    $A921
A920: 39          RTS
A921: CE D9 A0    LDU    #$D9A0		; ROM
A924: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a927:
A927: BD 90 76    JSR    function_9076
A92A: 26 0F       BNE    $A93B
A92C: EC 18       LDD    -$8,X
A92E: 27 1D       BEQ    $A94D
A930: 6A 0A       DEC    $A,X
A932: 27 01       BEQ    $A935
A934: 39          RTS
A935: CE D9 A0    LDU    #$D9A0		; ROM
A938: 7E 8D E8    JMP    function_8de8
A93B: 6C 09       INC    $9,X
A93D: CE D9 A0    LDU    #$D9A0
A940: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a943:
A943: BD 90 76    JSR    function_9076
A946: 26 0A       BNE    $A952
A948: EC 18       LDD    -$8,X
A94A: 27 01       BEQ    $A94D
A94C: 39          RTS
A94D: C6 34       LDB    #$34
A94F: 7E 99 3B    JMP    function_993b
A952: CE D9 A0    LDU    #$D9A0		; ROM
A955: 7E 8D E8    JMP    function_8de8

; 4 jump-table ref
function_a958:
A958: 6A 0A       DEC    $A,X
A95A: 27 01       BEQ    $A95D
A95C: 39          RTS
A95D: CE D9 A0    LDU    #$D9A0		; ROM
A960: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a963:
A963: 6A 0A       DEC    $A,X
A965: 27 01       BEQ    $A968
A967: 39          RTS
A968: 0F 0D       CLR    $0D
A96A: 0F 0B       CLR    $0B
A96C: 96 0A       LDA    $0A
A96E: 84 FC       ANDA   #$FC
A970: 97 0A       STA    $0A
A972: CC 00 00    LDD    #$0000
A975: ED 18       STD    -$8,X
A977: A6 05       LDA    $5,X
A979: 81 40       CMPA   #$40
A97B: 26 0A       BNE    $A987
A97D: 86 80       LDA    #$80
A97F: A7 05       STA    $5,X
A981: CE D9 A0    LDU    #$D9A0		; ROM
A984: 7E 8D E8    JMP    function_8de8
A987: 86 40       LDA    #$40
A989: A7 05       STA    $5,X
A98B: CE D9 A0    LDU    #$D9A0
A98E: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_a991:
A991: 6A 0A       DEC    $A,X
A993: 27 01       BEQ    $A996
A995: 39          RTS
A996: CE E0 8C    LDU    #$E08C		; ROM
A999: 7E 99 37    JMP    $9937

; 1 jump-table ref
function_a99c:
A99C: 6A 0A       DEC    $A,X
A99E: 27 01       BEQ    $A9A1
A9A0: 39          RTS
A9A1: A6 84       LDA    ,X
A9A3: 84 03       ANDA   #$03
A9A5: 26 06       BNE    $A9AD
A9A7: CE E0 14    LDU    #$E014		; ROM
A9AA: 7E 99 37    JMP    $9937
A9AD: 6C 14       INC    -$C,X
A9AF: 39          RTS

; 1 jump-table ref
function_a9b0:
A9B0: CE AA 12    LDU    #jump_table_aa12
A9B3: A6 09       LDA    $9,X
A9B5: 48          ASLA
A9B6: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

; 2 jump-table ref
function_a9b8:
A9B8: BD 90 76    JSR    function_9076
A9BB: 26 01       BNE    $A9BE
A9BD: 39          RTS
A9BE: 0F 0D       CLR    $0D
A9C0: 0F 0B       CLR    $0B
A9C2: 96 0A       LDA    $0A
A9C4: 84 FC       ANDA   #$FC
A9C6: 97 0A       STA    $0A
A9C8: CC 00 00    LDD    #$0000
A9CB: ED 18       STD    -$8,X
A9CD: CE D9 F0    LDU    #$D9F0		; ROM
A9D0: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_a9d3:
A9D3: 6A 0A       DEC    $A,X
A9D5: 27 01       BEQ    $A9D8
A9D7: 39          RTS
A9D8: A6 84       LDA    ,X
A9DA: 84 03       ANDA   #$03
A9DC: 26 06       BNE    $A9E4
A9DE: CE E0 A0    LDU    #$E0A0		; ROM
A9E1: 7E 99 37    JMP    $9937
A9E4: CE D9 F0    LDU    #$D9F0
A9E7: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_a9ea:
A9EA: 6A 0A       DEC    $A,X
A9EC: 27 01       BEQ    $A9EF
A9EE: 39          RTS
A9EF: A6 84       LDA    ,X
A9F1: 84 03       ANDA   #$03
A9F3: 26 06       BNE    $A9FB
A9F5: CE E0 14    LDU    #$E014		; ROM
A9F8: 7E 99 37    JMP    $9937
A9FB: 6C 14       INC    -$C,X
A9FD: 39          RTS


; 2 jump-table ref
function_aa18:
AA18: A6 01       LDA    $1,X
AA1A: A1 07       CMPA   $7,X
AA1C: 27 23       BEQ    $AA41
AA1E: 84 FC       ANDA   #$FC
AA20: 81 2C       CMPA   #$2C
AA22: 27 10       BEQ    $AA34
AA24: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
AA27: CC 00 03    LDD    #$0003
AA2A: BD 93 02    JSR    function_9302
AA2D: C4 10       ANDB   #$10
AA2F: 27 1C       BEQ    $AA4D
AA31: 7E 8D C8    JMP    function_8dc8
AA34: A6 07       LDA    $7,X
AA36: A7 01       STA    $1,X
AA38: EC 16       LDD    -$A,X
AA3A: 53          COMB
AA3B: 43          COMA
AA3C: C3 00 01    ADDD   #$0001
AA3F: ED 16       STD    -$A,X
AA41: A6 09       LDA    $9,X
AA43: 81 06       CMPA   #$06
AA45: 24 DD       BCC    $AA24
AA47: CE D9 C8    LDU    #$D9C8		; ROM
AA4A: 7E 8D E8    JMP    function_8de8
AA4D: C6 20       LDB    #$20
AA4F: 7E 99 3B    JMP    function_993b

; 2 jump-table ref
function_aa52:
AA52: A6 01       LDA    $1,X
AA54: A1 07       CMPA   $7,X
AA56: 27 0D       BEQ    $AA65
AA58: 84 FC       ANDA   #$FC
AA5A: 81 30       CMPA   #$30
AA5C: 27 03       BEQ    $AA61
AA5E: 7E 8D C8    JMP    function_8dc8
AA61: A6 07       LDA    $7,X
AA63: A7 01       STA    $1,X
AA65: CE D9 E4    LDU    #$D9E4		; ROM
AA68: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_aa6b:
AA6B: CE AB 3B    LDU    #jump_table_ab3b
AA6E: A6 09       LDA    $9,X
AA70: 48          ASLA
AA71: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=10]

; 3 jump-table ref
function_aa73:
AA73: 6A 0A       DEC    $A,X
AA75: 27 01       BEQ    $AA78
AA77: 39          RTS
AA78: CE D9 C8    LDU    #$D9C8		; ROM
AA7B: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_aa7e:
AA7E: 6A 0A       DEC    $A,X
AA80: 27 01       BEQ    $AA83
AA82: 39          RTS
AA83: A6 05       LDA    $5,X
AA85: 81 40       CMPA   #$40
AA87: 26 0A       BNE    $AA93
AA89: 86 80       LDA    #$80
AA8B: A7 05       STA    $5,X
AA8D: CE D9 C8    LDU    #$D9C8		; ROM
AA90: 7E 8D E8    JMP    function_8de8
AA93: 86 40       LDA    #$40
AA95: A7 05       STA    $5,X
AA97: CE D9 C8    LDU    #$D9C8
AA9A: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_aa9d:
AA9D: BD 90 76    JSR    function_9076
AAA0: 26 01       BNE    $AAA3
AAA2: 39          RTS
AAA3: 0F 0B       CLR    $0B
AAA5: 0F 0D       CLR    $0D
AAA7: 96 0A       LDA    $0A
AAA9: 84 FC       ANDA   #$FC
AAAB: 97 0A       STA    $0A
AAAD: CE D9 C8    LDU    #$D9C8		; ROM
AAB0: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_aab3:
AAB3: 6A 0A       DEC    $A,X
AAB5: 27 01       BEQ    $AAB8
AAB7: 39          RTS
AAB8: A6 84       LDA    ,X
AABA: 84 03       ANDA   #$03
AABC: 26 06       BNE    $AAC4
AABE: CE E0 B4    LDU    #$E0B4		; ROM
AAC1: 7E 99 37    JMP    $9937
AAC4: CE D9 C8    LDU    #$D9C8
AAC7: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_aaca:
AACA: 6A 0A       DEC    $A,X
AACC: 27 01       BEQ    $AACF
AACE: 39          RTS
AACF: A6 84       LDA    ,X
AAD1: 84 03       ANDA   #$03
AAD3: 26 06       BNE    $AADB
AAD5: CE E0 14    LDU    #$E014		; ROM
AAD8: 7E 99 37    JMP    $9937
AADB: 6C 14       INC    -$C,X
AADD: 39          RTS

; 1 jump-table ref
function_aade:
AADE: CE A8 35    LDU    #$A835		; ROM
AAE1: 96 0A       LDA    $0A
AAE3: 84 0C       ANDA   #$0C
AAE5: 44          LSRA
AAE6: EC C6       LDD    A,U
AAE8: ED 16       STD    -$A,X
AAEA: CE AB 49    LDU    #jump_table_ab49
AAED: A6 09       LDA    $9,X
AAEF: 48          ASLA
AAF0: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]

; 2 jump-table ref
function_aaf2:
AAF2: BD 8E 05    JSR    function_8e05
AAF5: BD 90 76    JSR    function_9076
AAF8: 26 01       BNE    $AAFB
AAFA: 39          RTS
AAFB: 0F 0D       CLR    $0D
AAFD: 0F 0B       CLR    $0B
AAFF: 96 0A       LDA    $0A
AB01: 84 FC       ANDA   #$FC
AB03: 97 0A       STA    $0A
AB05: CC 00 00    LDD    #$0000
AB08: ED 18       STD    -$8,X
AB0A: CE D9 E4    LDU    #$D9E4		; ROM
AB0D: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_ab10:
AB10: 6A 0A       DEC    $A,X
AB12: 27 01       BEQ    $AB15
AB14: 39          RTS
AB15: A6 84       LDA    ,X
AB17: 84 03       ANDA   #$03
AB19: 26 06       BNE    $AB21
AB1B: CE E0 C8    LDU    #$E0C8		; ROM
AB1E: 7E 99 37    JMP    $9937
AB21: CE D9 E4    LDU    #$D9E4
AB24: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_ab27:
AB27: 6A 0A       DEC    $A,X
AB29: 27 01       BEQ    $AB2C
AB2B: 39          RTS
AB2C: A6 84       LDA    ,X
AB2E: 84 03       ANDA   #$03
AB30: 26 06       BNE    $AB38
AB32: CE E0 14    LDU    #$E014		; ROM
AB35: 7E 99 37    JMP    $9937
AB38: 6C 14       INC    -$C,X
AB3A: 39          RTS

AB4B: AB 10       ADDA   -$10,X
AB4D: AB 27       ADDA   $7,Y

; 1 jump-table ref
function_ab4f:
AB4F: 6A 0A       DEC    $A,X
AB51: 27 01       BEQ    $AB54
AB53: 39          RTS
AB54: 6C 14       INC    -$C,X
AB56: CE E0 14    LDU    #$E014		; ROM
AB59: 7E 99 37    JMP    $9937

; 1 jump-table ref
function_ab5c:
AB5C: 39          RTS

; 1 jump-table ref
function_ab5d:
AB5D: 39          RTS

; 1 jump-table ref
function_ab5e:
AB5E: 39          RTS

; 1 jump-table ref
function_ab5f:
AB5F: 39          RTS

; 8 jump-table ref
function_ab60:
AB60: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
AB64: 96 E4       LDA    $E4
AB66: C6 0B       LDB    #$0B
AB68: E7 A6       STB    A,Y
AB6A: 4C          INCA
AB6B: 84 1F       ANDA   #$1F
AB6D: 97 E4       STA    $E4
AB6F: 6C 0D       INC    $D,X
AB71: 7E 8D C8    JMP    function_8dc8

; 4 jump-table ref
function_ab74:
AB74: CE AB 7C    LDU    #jump_table_ab7c
AB77: A6 09       LDA    $9,X
AB79: 48          ASLA
AB7A: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=8]


; 1 jump-table ref
function_ab8c:
AB8C: 6A 0A       DEC    $A,X
AB8E: 27 01       BEQ    $AB91
AB90: 39          RTS
AB91: A6 01       LDA    $1,X
AB93: 8A 6C       ORA    #$6C
AB95: A7 01       STA    $1,X
AB97: A7 07       STA    $7,X
AB99: 86 02       LDA    #$02
AB9B: A7 04       STA    $4,X
AB9D: CE DA A4    LDU    #$DAA4		; ROM
ABA0: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_aba3:
ABA3: 6A 0A       DEC    $A,X
ABA5: 27 01       BEQ    $ABA8
ABA7: 39          RTS
ABA8: 6F 04       CLR    $4,X
ABAA: CE DA A4    LDU    #$DAA4		; ROM
ABAD: 7E 8D E8    JMP    function_8de8

; 4 jump-table ref
function_abb0:
ABB0: 6A 0A       DEC    $A,X
ABB2: 27 01       BEQ    $ABB5
ABB4: 39          RTS
ABB5: CE DA A4    LDU    #$DAA4		; ROM
ABB8: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_abbb:
ABBB: 6A 0A       DEC    $A,X
ABBD: 27 01       BEQ    $ABC0
ABBF: 39          RTS
ABC0: 6C 09       INC    $9,X
ABC2: 39          RTS

; 1 jump-table ref
function_abc3:
ABC3: 96 03       LDA    dp_state_cpu2_03
ABC5: 81 03       CMPA   #$03
ABC7: 27 3B       BEQ    $AC04
ABC9: 6D 1C       TST    -$4,X
ABCB: 2B 04       BMI    $ABD1
ABCD: 0D 10       TST    $10
ABCF: 26 1E       BNE    $ABEF
ABD1: 10 8E 5F 08 LDY    #$5F08		; layer 3 tilemap / HUD
ABD5: 86 FF       LDA    #$FF
ABD7: F6 8C E9    LDB    $8CE9		; ROM
ABDA: A7 A1       STA    ,Y++
ABDC: 5A          DECB
ABDD: 26 FB       BNE    $ABDA
ABDF: 0F CE       CLR    $CE
ABE1: CC 00 00    LDD    #$0000
ABE4: DD CC       STD    $CC
ABE6: 86 FF       LDA    #$FF
ABE8: A7 84       STA    ,X
ABEA: 0A 31       DEC    $31
ABEC: 0A 33       DEC    $33
ABEE: 39          RTS
ABEF: 6F 0D       CLR    $D,X
ABF1: 0F 14       CLR    $14
ABF3: 0F 15       CLR    $15
ABF5: 0F 0B       CLR    $0B
ABF7: 0F 0D       CLR    $0D
ABF9: 96 0A       LDA    $0A
ABFB: 84 FC       ANDA   #$FC
ABFD: 97 0A       STA    $0A
ABFF: C6 15       LDB    #$15
AC01: E7 07       STB    $7,X
AC03: 39          RTS
AC04: 0C 18       INC    $18
AC06: 39          RTS
AC07: A6 01       LDA    $1,X
AC09: 84 03       ANDA   #$03
AC0B: 8A 6C       ORA    #$6C
AC0D: A7 01       STA    $1,X
AC0F: A7 07       STA    $7,X
AC11: CE DA A4    LDU    #$DAA4
AC14: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_ac17:
AC17: CC 00 40    LDD    #$0040
AC1A: ED 18       STD    -$8,X
AC1C: A6 0D       LDA    $D,X
AC1E: 84 04       ANDA   #$04
AC20: 27 0F       BEQ    $AC31
AC22: CC 00 20    LDD    #$0020
AC25: ED 16       STD    -$A,X
AC27: 7E 8D C8    JMP    function_8dc8
AC2A: A6 0B       LDA    $B,X
AC2C: 8A 80       ORA    #$80
AC2E: A7 0B       STA    $B,X
AC30: 39          RTS
AC31: CC FF E0    LDD    #$FFE0
AC34: ED 16       STD    -$A,X
AC36: 7E 8D C8    JMP    function_8dc8
AC39: A6 0B       LDA    $B,X
AC3B: 8A 80       ORA    #$80
AC3D: A7 0B       STA    $B,X
AC3F: 39          RTS

; 1 jump-table ref
function_ac40:
AC40: CE AC 48    LDU    #jump_table_ac48
AC43: A6 09       LDA    $9,X
AC45: 48          ASLA
AC46: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]


; 1 jump-table ref
function_ac4e:
AC4E: BD 8E 05    JSR    function_8e05
AC51: BD 90 76    JSR    function_9076
AC54: 26 07       BNE    $AC5D
AC56: A6 19       LDA    -$7,X
AC58: 81 40       CMPA   #$40
AC5A: 2D 03       BLT    $AC5F
AC5C: 39          RTS
AC5D: 6C 09       INC    $9,X
AC5F: CE D9 80    LDU    #$D980		; ROM
AC62: 7E 8D E8    JMP    function_8de8
AC65: A6 0B       LDA    $B,X
AC67: 8A 80       ORA    #$80
AC69: A7 0B       STA    $B,X
AC6B: 39          RTS

; 1 jump-table ref
function_ac6c:
AC6C: BD 8E 05    JSR    function_8e05
AC6F: BD 90 76    JSR    function_9076
AC72: 26 07       BNE    $AC7B
AC74: A6 19       LDA    -$7,X
AC76: 81 C0       CMPA   #$C0
AC78: 2F 01       BLE    $AC7B
AC7A: 39          RTS
AC7B: CE D9 80    LDU    #$D980		; ROM
AC7E: 7E 8D E8    JMP    function_8de8
AC81: A6 0B       LDA    $B,X
AC83: 8A 80       ORA    #$80
AC85: A7 0B       STA    $B,X
AC87: 39          RTS

; 1 jump-table ref
function_ac88:
AC88: BD 8E 05    JSR    function_8e05
AC8B: BD 90 76    JSR    function_9076
AC8E: 26 01       BNE    $AC91
AC90: 39          RTS
AC91: 6F 0D       CLR    $D,X
AC93: 0F 0B       CLR    $0B
AC95: 0F 0D       CLR    $0D
AC97: 96 0A       LDA    $0A
AC99: 84 FC       ANDA   #$FC
AC9B: 97 0A       STA    $0A
AC9D: A6 84       LDA    ,X
AC9F: 84 FC       ANDA   #$FC
ACA1: 26 06       BNE    $ACA9
ACA3: CE E0 14    LDU    #$E014		; ROM
ACA6: 7E 99 37    JMP    $9937
ACA9: 6C 14       INC    -$C,X
ACAB: 39          RTS

; called 2x  from $87C1, $895D
function_acac:
ACAC: 0D 61       TST    $61
ACAE: 27 01       BEQ    $ACB1
ACB0: 39          RTS
ACB1: DC 88       LDD    $88
ACB3: 27 24       BEQ    $ACD9
ACB5: 2A 0F       BPL    $ACC6
ACB7: DC 80       LDD    $80
ACB9: C3 00 90    ADDD   #$0090
ACBC: 91 C8       CMPA   $C8
ACBE: 26 19       BNE    $ACD9
ACC0: 86 01       LDA    #$01
ACC2: 97 61       STA    $61
ACC4: 20 13       BRA    $ACD9
ACC6: 96 C8       LDA    $C8
ACC8: 80 02       SUBA   #$02
ACCA: A7 E2       STA    ,-S		; [local]
ACCC: DC 80       LDD    $80
ACCE: C3 00 90    ADDD   #$0090
ACD1: A1 E0       CMPA   ,S+		; [local]
ACD3: 26 04       BNE    $ACD9
ACD5: 86 02       LDA    #$02
ACD7: 97 61       STA    $61
ACD9: DC 8A       LDD    $8A
ACDB: 26 01       BNE    $ACDE
ACDD: 39          RTS
ACDE: 2A 11       BPL    $ACF1
ACE0: DC 82       LDD    $82
ACE2: C3 00 80    ADDD   #$0080
ACE5: 91 C9       CMPA   $C9
ACE7: 27 01       BEQ    $ACEA
ACE9: 39          RTS
ACEA: 96 61       LDA    $61
ACEC: 8A 04       ORA    #$04
ACEE: 97 61       STA    $61
ACF0: 39          RTS
ACF1: 96 C9       LDA    $C9
ACF3: 80 02       SUBA   #$02
ACF5: A7 E2       STA    ,-S		; [local]
ACF7: DC 82       LDD    $82
ACF9: C3 00 80    ADDD   #$0080
ACFC: A1 E0       CMPA   ,S+		; [local]
ACFE: 27 01       BEQ    $AD01
AD00: 39          RTS
AD01: 96 61       LDA    $61
AD03: 8A 08       ORA    #$08
AD05: 97 61       STA    $61
AD07: 39          RTS

; called 1x; jumped-to 1x  from $87DD, $897C
function_ad08:
AD08: CE AD 10    LDU    #jump_table_ad10
AD0B: 96 61       LDA    $61
AD0D: 48          ASLA
AD0E: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=16]


; 1 jump-table ref; jumped-to 2x  from $AD8F, $ADB8
function_ad30:
AD30: 8E 13 00    LDX    #$1300		; work RAM (shared with CPU1 $4400)
AD33: D6 67       LDB    $67
AD35: 58          ASLB
AD36: 58          ASLB
AD37: 3A          ABX
AD38: 86 02       LDA    #$02
AD3A: A7 84       STA    ,X
AD3C: DC C8       LDD    $C8
AD3E: ED 02       STD    $2,X
AD40: 0C C8       INC    $C8
AD42: 96 67       LDA    $67
AD44: 4C          INCA
AD45: 84 07       ANDA   #$07
AD47: 97 67       STA    $67

; 8 jump-table ref
function_ad49:
AD49: 0F 61       CLR    $61
AD4B: B7 80 00    STA    watchdog_8000
AD4E: 39          RTS

; 1 jump-table ref; jumped-to 2x  from $AD94, $ADBD
function_ad4f:
AD4F: 8E 13 00    LDX    #$1300		; work RAM (shared with CPU1 $4400)
AD52: D6 67       LDB    $67
AD54: 58          ASLB
AD55: 58          ASLB
AD56: 3A          ABX
AD57: 86 04       LDA    #$04
AD59: A7 84       STA    ,X
AD5B: DC C8       LDD    $C8
AD5D: ED 02       STD    $2,X
AD5F: 0A C8       DEC    $C8
AD61: 96 67       LDA    $67
AD63: 4C          INCA
AD64: 84 07       ANDA   #$07
AD66: 97 67       STA    $67
AD68: 0F 61       CLR    $61
AD6A: B7 80 00    STA    watchdog_8000
AD6D: 39          RTS

; called 2x; 1 jump-table ref  from $AD8D, $AD92
function_ad6e:
AD6E: 8E 13 00    LDX    #$1300		; work RAM (shared with CPU1 $4400)
AD71: D6 67       LDB    $67
AD73: 58          ASLB
AD74: 58          ASLB
AD75: 3A          ABX
AD76: 86 06       LDA    #$06
AD78: A7 84       STA    ,X
AD7A: DC C8       LDD    $C8
AD7C: ED 02       STD    $2,X
AD7E: 0C C9       INC    $C9
AD80: 96 67       LDA    $67
AD82: 4C          INCA
AD83: 84 07       ANDA   #$07
AD85: 97 67       STA    $67
AD87: 0F 61       CLR    $61
AD89: B7 80 00    STA    watchdog_8000
AD8C: 39          RTS

; 1 jump-table ref
function_ad8d:
AD8D: 8D DF       BSR    function_ad6e
AD8F: 7E AD 30    JMP    function_ad30

; 1 jump-table ref
function_ad92:
AD92: 8D DA       BSR    function_ad6e
AD94: 7E AD 4F    JMP    function_ad4f

; called 2x; 1 jump-table ref  from $ADB6, $ADBB
function_ad97:
AD97: 8E 13 00    LDX    #$1300		; work RAM (shared with CPU1 $4400)
AD9A: D6 67       LDB    $67
AD9C: 58          ASLB
AD9D: 58          ASLB
AD9E: 3A          ABX
AD9F: 86 08       LDA    #$08
ADA1: A7 84       STA    ,X
ADA3: DC C8       LDD    $C8
ADA5: ED 02       STD    $2,X
ADA7: 0A C9       DEC    $C9
ADA9: 96 67       LDA    $67
ADAB: 4C          INCA
ADAC: 84 07       ANDA   #$07
ADAE: 97 67       STA    $67
ADB0: 0F 61       CLR    $61
ADB2: B7 80 00    STA    watchdog_8000
ADB5: 39          RTS

; 1 jump-table ref
function_adb6:
ADB6: 8D DF       BSR    function_ad97
ADB8: 7E AD 30    JMP    function_ad30

; 1 jump-table ref
function_adbb:
ADBB: 8D DA       BSR    function_ad97
ADBD: 7E AD 4F    JMP    function_ad4f

; called 2x  from $87DA, $8979
function_adc0:
ADC0: 96 36       LDA    $36
ADC2: 9B 37       ADDA   $37
ADC4: 26 01       BNE    $ADC7
ADC6: 39          RTS
ADC7: 8E 04 30    LDX    #$0430		; work RAM (shared with CPU1 $4400)
ADCA: 97 3B       STA    $3B
ADCC: CE AD D4    LDU    #jump_table_add4
ADCF: 96 61       LDA    $61
ADD1: 48          ASLA
ADD2: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=16]


; 8 jump-table ref
function_adf4:
ADF4: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $AE2F
function_adf5:
ADF5: A6 84       LDA    ,X
ADF7: 2A 2F       BPL    $AE28
ADF9: 81 FF       CMPA   #$FF
ADFB: 27 2F       BEQ    $AE2C
ADFD: 84 7F       ANDA   #$7F
ADFF: 81 20       CMPA   #$20
AE01: 24 15       BCC    $AE18
AE03: EC 1A       LDD    -$6,X
AE05: 10 83 19 00 CMPD   #$1900
AE09: 2D 1D       BLT    $AE28
AE0B: BD C3 5A    JSR    function_c35a
AE0E: 86 FF       LDA    #$FF
AE10: A7 84       STA    ,X
AE12: 0A 37       DEC    $37
AE14: 0A 31       DEC    $31
AE16: 20 10       BRA    $AE28
AE18: EC 1A       LDD    -$6,X
AE1A: 10 83 19 00 CMPD   #$1900
AE1E: 2D 08       BLT    $AE28
AE20: 86 FF       LDA    #$FF
AE22: A7 84       STA    ,X
AE24: 0A 36       DEC    $36
AE26: 0A 30       DEC    $30
AE28: 0A 3B       DEC    $3B
AE2A: 27 05       BEQ    $AE31
AE2C: 30 88 20    LEAX   $20,X
AE2F: 20 C4       BRA    function_adf5
AE31: B7 80 00    STA    watchdog_8000
AE34: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $AE6F
function_ae35:
AE35: A6 84       LDA    ,X
AE37: 2A 2F       BPL    $AE68
AE39: 81 FF       CMPA   #$FF
AE3B: 27 2F       BEQ    $AE6C
AE3D: 84 7F       ANDA   #$7F
AE3F: 81 20       CMPA   #$20
AE41: 24 15       BCC    $AE58
AE43: EC 1A       LDD    -$6,X
AE45: 10 83 F9 00 CMPD   #$F900
AE49: 2C 1D       BGE    $AE68
AE4B: BD C3 5A    JSR    function_c35a
AE4E: 86 FF       LDA    #$FF
AE50: A7 84       STA    ,X
AE52: 0A 37       DEC    $37
AE54: 0A 31       DEC    $31
AE56: 20 10       BRA    $AE68
AE58: EC 1A       LDD    -$6,X
AE5A: 10 83 F9 00 CMPD   #$F900
AE5E: 2C 08       BGE    $AE68
AE60: 86 FF       LDA    #$FF
AE62: A7 84       STA    ,X
AE64: 0A 36       DEC    $36
AE66: 0A 30       DEC    $30
AE68: 0A 3B       DEC    $3B
AE6A: 27 05       BEQ    $AE71
AE6C: 30 88 20    LEAX   $20,X
AE6F: 20 C4       BRA    function_ae35
AE71: B7 80 00    STA    watchdog_8000
AE74: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $AEAF
function_ae75:
AE75: A6 84       LDA    ,X
AE77: 2A 2F       BPL    $AEA8
AE79: 81 FF       CMPA   #$FF
AE7B: 27 2F       BEQ    $AEAC
AE7D: 84 7F       ANDA   #$7F
AE7F: 81 20       CMPA   #$20
AE81: 24 15       BCC    $AE98
AE83: EC 1C       LDD    -$4,X
AE85: 10 83 18 00 CMPD   #$1800
AE89: 2D 1D       BLT    $AEA8
AE8B: BD C3 5A    JSR    function_c35a
AE8E: 86 FF       LDA    #$FF
AE90: A7 84       STA    ,X
AE92: 0A 37       DEC    $37
AE94: 0A 31       DEC    $31
AE96: 20 10       BRA    $AEA8
AE98: EC 1C       LDD    -$4,X
AE9A: 10 83 18 00 CMPD   #$1800
AE9E: 2D 08       BLT    $AEA8
AEA0: 86 FF       LDA    #$FF
AEA2: A7 84       STA    ,X
AEA4: 0A 36       DEC    $36
AEA6: 0A 30       DEC    $30
AEA8: 0A 3B       DEC    $3B
AEAA: 27 05       BEQ    $AEB1
AEAC: 30 88 20    LEAX   $20,X
AEAF: 20 C4       BRA    function_ae75
AEB1: B7 80 00    STA    watchdog_8000
AEB4: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $AEFF
function_aeb5:
AEB5: A6 84       LDA    ,X
AEB7: 2A 3F       BPL    $AEF8
AEB9: 81 FF       CMPA   #$FF
AEBB: 27 3F       BEQ    $AEFC
AEBD: 84 7F       ANDA   #$7F
AEBF: 81 20       CMPA   #$20
AEC1: 24 1D       BCC    $AEE0
AEC3: EC 1C       LDD    -$4,X
AEC5: 10 83 18 00 CMPD   #$1800
AEC9: 2C 08       BGE    $AED3
AECB: EC 1A       LDD    -$6,X
AECD: 10 83 19 00 CMPD   #$1900
AED1: 2D 25       BLT    $AEF8
AED3: BD C3 5A    JSR    function_c35a
AED6: 86 FF       LDA    #$FF
AED8: A7 84       STA    ,X
AEDA: 0A 37       DEC    $37
AEDC: 0A 31       DEC    $31
AEDE: 20 18       BRA    $AEF8
AEE0: EC 1C       LDD    -$4,X
AEE2: 10 83 18 00 CMPD   #$1800
AEE6: 2C 08       BGE    $AEF0
AEE8: EC 1A       LDD    -$6,X
AEEA: 10 83 19 00 CMPD   #$1900
AEEE: 2D 08       BLT    $AEF8
AEF0: 86 FF       LDA    #$FF
AEF2: A7 84       STA    ,X
AEF4: 0A 36       DEC    $36
AEF6: 0A 30       DEC    $30
AEF8: 0A 3B       DEC    $3B
AEFA: 27 05       BEQ    $AF01
AEFC: 30 88 20    LEAX   $20,X
AEFF: 20 B4       BRA    function_aeb5
AF01: B7 80 00    STA    watchdog_8000
AF04: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $AF4F
function_af05:
AF05: A6 84       LDA    ,X
AF07: 2A 3F       BPL    $AF48
AF09: 81 FF       CMPA   #$FF
AF0B: 27 3F       BEQ    $AF4C
AF0D: 84 7F       ANDA   #$7F
AF0F: 81 20       CMPA   #$20
AF11: 24 1D       BCC    $AF30
AF13: EC 1C       LDD    -$4,X
AF15: 10 83 18 00 CMPD   #$1800
AF19: 2C 08       BGE    $AF23
AF1B: EC 1A       LDD    -$6,X
AF1D: 10 83 F9 00 CMPD   #$F900
AF21: 2C 25       BGE    $AF48
AF23: BD C3 5A    JSR    function_c35a
AF26: 86 FF       LDA    #$FF
AF28: A7 84       STA    ,X
AF2A: 0A 37       DEC    $37
AF2C: 0A 31       DEC    $31
AF2E: 20 18       BRA    $AF48
AF30: EC 1C       LDD    -$4,X
AF32: 10 83 18 00 CMPD   #$1800
AF36: 2C 08       BGE    $AF40
AF38: EC 1A       LDD    -$6,X
AF3A: 10 83 F9 00 CMPD   #$F900
AF3E: 2C 08       BGE    $AF48
AF40: 86 FF       LDA    #$FF
AF42: A7 84       STA    ,X
AF44: 0A 36       DEC    $36
AF46: 0A 30       DEC    $30
AF48: 0A 3B       DEC    $3B
AF4A: 27 05       BEQ    $AF51
AF4C: 30 88 20    LEAX   $20,X
AF4F: 20 B4       BRA    function_af05
AF51: B7 80 00    STA    watchdog_8000
AF54: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $AF8F
function_af55:
AF55: A6 84       LDA    ,X
AF57: 2A 2F       BPL    $AF88
AF59: 81 FF       CMPA   #$FF
AF5B: 27 2F       BEQ    $AF8C
AF5D: 84 7F       ANDA   #$7F
AF5F: 81 20       CMPA   #$20
AF61: 24 15       BCC    $AF78
AF63: EC 1C       LDD    -$4,X
AF65: 10 83 F8 00 CMPD   #$F800
AF69: 2C 1D       BGE    $AF88
AF6B: BD C3 5A    JSR    function_c35a
AF6E: 86 FF       LDA    #$FF
AF70: A7 84       STA    ,X
AF72: 0A 37       DEC    $37
AF74: 0A 31       DEC    $31
AF76: 20 10       BRA    $AF88
AF78: EC 1C       LDD    -$4,X
AF7A: 10 83 F8 00 CMPD   #$F800
AF7E: 2C 08       BGE    $AF88
AF80: 86 FF       LDA    #$FF
AF82: A7 84       STA    ,X
AF84: 0A 36       DEC    $36
AF86: 0A 30       DEC    $30
AF88: 0A 3B       DEC    $3B
AF8A: 27 05       BEQ    $AF91
AF8C: 30 88 20    LEAX   $20,X
AF8F: 20 C4       BRA    function_af55
AF91: B7 80 00    STA    watchdog_8000
AF94: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $AFDF
function_af95:
AF95: A6 84       LDA    ,X
AF97: 2A 3F       BPL    $AFD8
AF99: 81 FF       CMPA   #$FF
AF9B: 27 3F       BEQ    $AFDC
AF9D: 84 7F       ANDA   #$7F
AF9F: 81 20       CMPA   #$20
AFA1: 24 1D       BCC    $AFC0
AFA3: EC 1C       LDD    -$4,X
AFA5: 10 83 F8 00 CMPD   #$F800
AFA9: 2D 08       BLT    $AFB3
AFAB: EC 1A       LDD    -$6,X
AFAD: 10 83 19 00 CMPD   #$1900
AFB1: 2D 25       BLT    $AFD8
AFB3: BD C3 5A    JSR    function_c35a
AFB6: 86 FF       LDA    #$FF
AFB8: A7 84       STA    ,X
AFBA: 0A 37       DEC    $37
AFBC: 0A 31       DEC    $31
AFBE: 20 18       BRA    $AFD8
AFC0: EC 1C       LDD    -$4,X
AFC2: 10 83 F8 00 CMPD   #$F800
AFC6: 2D 08       BLT    $AFD0
AFC8: EC 1A       LDD    -$6,X
AFCA: 10 83 19 00 CMPD   #$1900
AFCE: 2D 08       BLT    $AFD8
AFD0: 86 FF       LDA    #$FF
AFD2: A7 84       STA    ,X
AFD4: 0A 36       DEC    $36
AFD6: 0A 30       DEC    $30
AFD8: 0A 3B       DEC    $3B
AFDA: 27 05       BEQ    $AFE1
AFDC: 30 88 20    LEAX   $20,X
AFDF: 20 B4       BRA    function_af95
AFE1: B7 80 00    STA    watchdog_8000
AFE4: 39          RTS

; 1 jump-table ref; jumped-to 1x  from $B02F
function_afe5:
AFE5: A6 84       LDA    ,X
AFE7: 2A 3F       BPL    $B028
AFE9: 81 FF       CMPA   #$FF
AFEB: 27 3F       BEQ    $B02C
AFED: 84 7F       ANDA   #$7F
AFEF: 81 20       CMPA   #$20
AFF1: 24 1D       BCC    $B010
AFF3: EC 1C       LDD    -$4,X
AFF5: 10 83 F8 00 CMPD   #$F800
AFF9: 2D 08       BLT    $B003
AFFB: EC 1A       LDD    -$6,X
AFFD: 10 83 19 00 CMPD   #$1900
B001: 2D 25       BLT    $B028
B003: BD C3 5A    JSR    function_c35a
B006: 86 FF       LDA    #$FF
B008: A7 84       STA    ,X
B00A: 0A 37       DEC    $37
B00C: 0A 31       DEC    $31
B00E: 20 18       BRA    $B028
B010: EC 1C       LDD    -$4,X
B012: 10 83 F8 00 CMPD   #$F800
B016: 2D 08       BLT    $B020
B018: EC 1A       LDD    -$6,X
B01A: 10 83 19 00 CMPD   #$1900
B01E: 2D 08       BLT    $B028
B020: 86 FF       LDA    #$FF
B022: A7 84       STA    ,X
B024: 0A 36       DEC    $36
B026: 0A 30       DEC    $30
B028: 0A 3B       DEC    $3B
B02A: 27 05       BEQ    $B031
B02C: 30 88 20    LEAX   $20,X
B02F: 20 B4       BRA    function_afe5
B031: B7 80 00    STA    watchdog_8000
B034: 39          RTS

; called 1x  from $84DB
function_b035:
B035: 86 02       LDA    #$02
B037: 9B 3C       ADDA   $3C
B039: B7 D8 03    STA    bank2_select_d803
B03C: D6 C7       LDB    $C7
B03E: C0 02       SUBB   #$02
B040: D7 63       STB    $63
B042: 86 03       LDA    #$03
B044: 97 66       STA    $66
B046: D6 63       LDB    $63
B048: 2B 06       BMI    $B050
B04A: D1 79       CMPB   $79
B04C: 2C 08       BGE    $B056
B04E: 8D 07       BSR    function_b057
B050: 0C 63       INC    $63
B052: 0A 66       DEC    $66
B054: 26 F0       BNE    $B046
B056: 39          RTS

; called 1x  from $B04E
function_b057:
B057: 96 C6       LDA    $C6
B059: 80 02       SUBA   #$02
B05B: 97 62       STA    $62
B05D: 86 03       LDA    #$03
B05F: 97 65       STA    $65
B061: 96 36       LDA    $36
B063: 9B 37       ADDA   $37
B065: 81 28       CMPA   #$28
B067: 24 30       BCC    $B099
B069: D6 62       LDB    $62
B06B: 2B 26       BMI    $B093
B06D: D1 78       CMPB   $78
B06F: 24 28       BCC    $B099
B071: 1D          SEX
B072: ED E3       STD    ,--S		; [local]
B074: CE E8 B0    LDU    #$E8B0		; ROM
B077: 96 3C       LDA    $3C
B079: 48          ASLA
B07A: 9B C2       ADDA   $C2
B07C: 48          ASLA
B07D: EE C6       LDU    A,U		; [rom_address]
B07F: 96 C4       LDA    $C4
B081: 48          ASLA
B082: EE C6       LDU    A,U		; [rom_address]
B084: 96 63       LDA    $63
B086: D6 78       LDB    $78
B088: 3D          MUL
B089: E3 E1       ADDD   ,S++		; [local]
B08B: 58          ASLB
B08C: 49          ROLA
B08D: 10 AE CB    LDY    D,U		; [bank_address]
B090: BD B1 E0    JSR    function_b1e0
B093: 0C 62       INC    $62
B095: 0A 65       DEC    $65
B097: 26 C8       BNE    $B061
B099: 39          RTS
B09A: 0F 62       CLR    $62
B09C: 0F 63       CLR    $63
B09E: 86 02       LDA    #$02
B0A0: B7 D8 03    STA    bank2_select_d803
B0A3: 97 65       STA    $65
B0A5: 10 8E 78 3C LDY    #$783C		; banked ROM
B0A9: 96 D1       LDA    $D1
B0AB: 48          ASLA
B0AC: 10 AE A6    LDY    A,Y		; [bank_address]
B0AF: 96 62       LDA    $62
B0B1: 48          ASLA
B0B2: 10 AE A6    LDY    A,Y		; [bank_address]
B0B5: BD B1 E0    JSR    function_b1e0
B0B8: 0C 62       INC    $62
B0BA: 0A 65       DEC    $65
B0BC: 26 E7       BNE    $B0A5
B0BE: 39          RTS

; handle some punctual events:
; - level completed
; - various special enemies (with guns, etc..). Grunts are handled
;   by cpu1

; called 1x  from $80A3
process_event_b0bf:		; [global]
B0BF: D6 68       LDB    $68
B0C1: D1 67       CMPB   $67
B0C3: 26 01       BNE    $B0C6
B0C5: 39          RTS
B0C6: 86 02       LDA    #$02
B0C8: 9B 3C       ADDA   $3C
B0CA: 97 1A       STA    dp_bank2_shadow_1a		; shadow of CPU2 ROM bank latch, re-armed every IRQ
B0CC: B7 D8 03    STA    bank2_select_d803
B0CF: 8E 13 00    LDX    #$1300		; work RAM (shared with CPU1 $4400)
B0D2: 58          ASLB
B0D3: 58          ASLB
B0D4: 3A          ABX
B0D5: CE B0 DC    LDU    #jump_table_b0dc
B0D8: A6 84       LDA    ,X
B0DA: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]



; 1 jump-table ref
function_b0e6:
B0E6: 96 68       LDA    $68
B0E8: 4C          INCA
B0E9: 84 07       ANDA   #$07
B0EB: 97 68       STA    $68
B0ED: 39          RTS

; 1 jump-table ref
function_b0ee:
B0EE: EC 02       LDD    $2,X
B0F0: 4C          INCA
B0F1: 91 78       CMPA   $78
B0F3: 2C 17       BGE    $B10C
B0F5: C0 02       SUBB   #$02
B0F7: DD 62       STD    $62
B0F9: CE E8 B0    LDU    #$E8B0		; ROM
B0FC: 96 3C       LDA    $3C
B0FE: 48          ASLA
B0FF: 9B C2       ADDA   $C2
B101: 48          ASLA
B102: EE C6       LDU    A,U
B104: 96 C4       LDA    $C4
B106: 48          ASLA
B107: EE C6       LDU    A,U
B109: BD B1 8C    JSR    function_b18c
B10C: 6F 84       CLR    ,X
B10E: 96 68       LDA    $68
B110: 4C          INCA
B111: 84 07       ANDA   #$07
B113: 97 68       STA    $68
B115: 39          RTS

; 1 jump-table ref
function_b116:
B116: EC 02       LDD    $2,X
B118: 80 03       SUBA   #$03
B11A: 2B 17       BMI    $B133
B11C: C0 02       SUBB   #$02
B11E: DD 62       STD    $62
B120: CE E8 B0    LDU    #$E8B0		; ROM
B123: 96 3C       LDA    $3C
B125: 48          ASLA
B126: 9B C2       ADDA   $C2
B128: 48          ASLA
B129: EE C6       LDU    A,U
B12B: 96 C4       LDA    $C4
B12D: 48          ASLA
B12E: EE C6       LDU    A,U
B130: BD B1 8C    JSR    function_b18c
B133: 6F 84       CLR    ,X
B135: 96 68       LDA    $68
B137: 4C          INCA
B138: 84 07       ANDA   #$07
B13A: 97 68       STA    $68
B13C: 39          RTS

; 1 jump-table ref
function_b13d:
B13D: EC 02       LDD    $2,X
B13F: 80 02       SUBA   #$02
B141: 5C          INCB
B142: D1 79       CMPB   $79
B144: 2C 15       BGE    $B15B
B146: DD 62       STD    $62
B148: CE E8 B0    LDU    #$E8B0		; ROM
B14B: 96 3C       LDA    $3C
B14D: 48          ASLA
B14E: 9B C2       ADDA   $C2
B150: 48          ASLA
B151: EE C6       LDU    A,U
B153: 96 C4       LDA    $C4
B155: 48          ASLA
B156: EE C6       LDU    A,U
B158: BD B1 B6    JSR    function_b1b6
B15B: 6F 84       CLR    ,X
B15D: 96 68       LDA    $68
B15F: 4C          INCA
B160: 84 07       ANDA   #$07
B162: 97 68       STA    $68
B164: 39          RTS

; 1 jump-table ref
function_b165:
B165: EC 02       LDD    $2,X
B167: 80 02       SUBA   #$02
B169: C0 03       SUBB   #$03
B16B: 2B 15       BMI    $B182
B16D: DD 62       STD    $62
B16F: CE E8 B0    LDU    #$E8B0		; ROM
B172: 96 3C       LDA    $3C
B174: 48          ASLA
B175: 9B C2       ADDA   $C2
B177: 48          ASLA
B178: EE C6       LDU    A,U
B17A: 96 C4       LDA    $C4
B17C: 48          ASLA
B17D: EE C6       LDU    A,U
B17F: BD B1 B6    JSR    function_b1b6
B182: 6F 84       CLR    ,X
B184: 96 68       LDA    $68
B186: 4C          INCA
B187: 84 07       ANDA   #$07
B189: 97 68       STA    $68
B18B: 39          RTS

; called 2x  from $B109, $B130, $B1B3
function_b18c:
B18C: 96 30       LDA    $30
B18E: 9B 31       ADDA   $31
B190: 81 28       CMPA   #$28
B192: 24 21       BCC    $B1B5
B194: 96 63       LDA    $63
B196: 2B 15       BMI    $B1AD
B198: 91 79       CMPA   $79
B19A: 24 19       BCC    $B1B5
B19C: D6 78       LDB    $78
B19E: 3D          MUL
B19F: ED E3       STD    ,--S		; [local]
B1A1: D6 62       LDB    $62
B1A3: 1D          SEX
B1A4: E3 E1       ADDD   ,S++		; [local]
B1A6: 58          ASLB
B1A7: 49          ROLA
B1A8: 10 AE CB    LDY    D,U
B1AB: 8D 33       BSR    function_b1e0
B1AD: 0C 63       INC    $63
B1AF: 96 63       LDA    $63
B1B1: A1 03       CMPA   $3,X
B1B3: 2F D7       BLE    function_b18c
B1B5: 39          RTS

; called 2x  from $B158, $B17F, $B1DD
function_b1b6:
B1B6: 96 30       LDA    $30
B1B8: 9B 31       ADDA   $31
B1BA: 81 28       CMPA   #$28
B1BC: 24 21       BCC    $B1DF
B1BE: D6 62       LDB    $62
B1C0: 2B 15       BMI    $B1D7
B1C2: D1 78       CMPB   $78
B1C4: 24 19       BCC    $B1DF
B1C6: 1D          SEX
B1C7: ED E3       STD    ,--S		; [local]
B1C9: 96 63       LDA    $63
B1CB: D6 78       LDB    $78
B1CD: 3D          MUL
B1CE: E3 E1       ADDD   ,S++		; [local]
B1D0: 58          ASLB
B1D1: 49          ROLA
B1D2: 10 AE CB    LDY    D,U
B1D5: 8D 09       BSR    function_b1e0
B1D7: 0C 62       INC    $62
B1D9: D6 62       LDB    $62
B1DB: E1 02       CMPB   $2,X
B1DD: 2F D7       BLE    function_b1b6
B1DF: 39          RTS

; called 4x  from $B090, $B0B5, $B1AB, $B1D5
function_b1e0:
B1E0: A6 A0       LDA    ,Y+		; [bank_address]
B1E2: 26 01       BNE    $B1E5
B1E4: 39          RTS
B1E5: 34 50       PSHS   U,X
B1E7: 8E 04 30    LDX    #$0430		; work RAM (shared with CPU1 $4400)
B1EA: 97 64       STA    $64
B1EC: A6 84       LDA    ,X
B1EE: 81 FF       CMPA   #$FF
B1F0: 26 06       BNE    $B1F8
B1F2: 8D 11       BSR    function_b205
B1F4: 0A 64       DEC    $64
B1F6: 27 08       BEQ    $B200
B1F8: 30 88 20    LEAX   $20,X
B1FB: 8C 09 00    CMPX   #$0900
B1FE: 25 EC       BCS    $B1EC
B200: B7 80 00    STA    watchdog_8000
B203: 35 D0       PULS   X,U,PC


; called 1x  from $B1F2
function_b205:
B205: EC A1       LDD    ,Y++		; [bank_address]
B207: 8A 80       ORA    #$80
B209: A7 84       STA    ,X
B20B: E7 07       STB    $7,X
B20D: EC A1       LDD    ,Y++		; [bank_address]
B20F: ED 02       STD    $2,X
B211: A6 A0       LDA    ,Y+		; [bank_address]
B213: A7 05       STA    $5,X
B215: 86 80       LDA    #$80
B217: A7 01       STA    $1,X
B219: 6F 0C       CLR    $C,X
B21B: 6F 0D       CLR    $D,X
B21D: 6F 0E       CLR    $E,X
B21F: CE E8 E0    LDU    #$E8E0		; ROM
B222: A6 84       LDA    ,X
B224: 84 7C       ANDA   #$7C
B226: A7 E2       STA    ,-S		; [local]
B228: A6 02       LDA    $2,X
B22A: 84 03       ANDA   #$03
B22C: AB E0       ADDA   ,S+		; [local]
B22E: 48          ASLA
B22F: EC C6       LDD    A,U		; [rom_address]
B231: A7 04       STA    $4,X
B233: E7 06       STB    $6,X
B235: CE E9 40    LDU    #$E940
B238: A6 7F       LDA    -$1,S		; [local]
B23A: 44          LSRA
B23B: EC C6       LDD    A,U		; [rom_address]
B23D: ED 12       STD    -$E,X
B23F: 96 62       LDA    $62
B241: E6 A0       LDB    ,Y+		; [bank_address]
B243: 93 80       SUBD   $80
B245: 58          ASLB
B246: 49          ROLA
B247: 58          ASLB
B248: 49          ROLA
B249: 58          ASLB
B24A: 49          ROLA
B24B: 58          ASLB
B24C: 49          ROLA
B24D: ED 1A       STD    -$6,X
B24F: 96 63       LDA    $63
B251: E6 A0       LDB    ,Y+		; [bank_address]
B253: 93 82       SUBD   $82
B255: 58          ASLB
B256: 49          ROLA
B257: 58          ASLB
B258: 49          ROLA
B259: 58          ASLB
B25A: 49          ROLA
B25B: 58          ASLB
B25C: 49          ROLA
B25D: ED 1C       STD    -$4,X
B25F: CC 00 00    LDD    #$0000
B262: ED 16       STD    -$A,X
B264: ED 18       STD    -$8,X
B266: A6 84       LDA    ,X
B268: 84 7F       ANDA   #$7F
B26A: 81 20       CMPA   #$20
B26C: 24 05       BCC    $B273
B26E: 0C 31       INC    $31
B270: 0C 37       INC    $37
B272: 39          RTS
B273: 0C 30       INC    $30
B275: 0C 36       INC    $36
B277: 39          RTS

; called 2x  from $87AC, $8945
function_b278:
B278: 96 37       LDA    $37
B27A: 26 03       BNE    $B27F
B27C: 97 39       STA    $39
B27E: 39          RTS
B27F: 8E 04 30    LDX    #$0430		; work RAM (shared with CPU1 $4400)
B282: 97 3B       STA    $3B
B284: 0F 39       CLR    $39
B286: A6 84       LDA    ,X
B288: 81 FF       CMPA   #$FF
B28A: 27 2D       BEQ    $B2B9
B28C: 84 7F       ANDA   #$7F
B28E: 81 20       CMPA   #$20
B290: 24 27       BCC    $B2B9
B292: 8D 2A       BSR    function_b2be
B294: A6 84       LDA    ,X
B296: 2B 1C       BMI    $B2B4
B298: BD 96 2A    JSR    function_962a
B29B: CE B3 79    LDU    #$B379		; ROM
B29E: A6 84       LDA    ,X
B2A0: 84 FC       ANDA   #$FC
B2A2: 81 10       CMPA   #$10
B2A4: 26 03       BNE    $B2A9
B2A6: CE B3 D1    LDU    #jump_table_b3d1
B2A9: E6 01       LDB    $1,X
B2AB: C1 C0       CMPB   #$C0
B2AD: 24 05       BCC    $B2B4
B2AF: C4 FC       ANDB   #$FC
B2B1: 54          LSRB
B2B2: AD D5       JSR    [B,U]		; [indirect_jump] [nb_entries=44]
B2B4: 0A 3B       DEC    $3B
B2B6: 26 01       BNE    $B2B9
B2B8: 39          RTS
B2B9: 30 88 20    LEAX   $20,X
B2BC: 20 C8       BRA    $B286

; called 1x  from $B292
function_b2be:
B2BE: DC 8A       LDD    $8A
B2C0: E3 1C       ADDD   -$4,X
B2C2: ED 1C       STD    -$4,X
B2C4: DC 88       LDD    $88
B2C6: E3 1A       ADDD   -$6,X
B2C8: ED 1A       STD    -$6,X
B2CA: A6 01       LDA    $1,X
B2CC: 84 FC       ANDA   #$FC
B2CE: 81 80       CMPA   #$80
B2D0: 27 37       BEQ    $B309
B2D2: EC 1C       LDD    -$4,X
B2D4: 10 83 FC 00 CMPD   #$FC00
B2D8: 2D 28       BLT    $B302
B2DA: 10 83 10 00 CMPD   #$1000
B2DE: 2C 22       BGE    $B302
B2E0: EC 1A       LDD    -$6,X
B2E2: 10 83 15 00 CMPD   #$1500
B2E6: 2E 1A       BGT    $B302
B2E8: 10 83 FD 00 CMPD   #$FD00
B2EC: 2D 14       BLT    $B302
B2EE: 0C 33       INC    $33
B2F0: 0C 39       INC    $39
B2F2: A6 84       LDA    ,X
B2F4: 84 7F       ANDA   #$7F
B2F6: A7 84       STA    ,X
B2F8: E6 07       LDB    $7,X
B2FA: E1 01       CMPB   $1,X
B2FC: 26 01       BNE    $B2FF
B2FE: 39          RTS
B2FF: 7E B4 29    JMP    function_b429
B302: A6 84       LDA    ,X
B304: 8A 80       ORA    #$80
B306: A7 84       STA    ,X
B308: 39          RTS
B309: A6 07       LDA    $7,X
B30B: 84 FC       ANDA   #$FC
B30D: 81 5C       CMPA   #$5C
B30F: 27 31       BEQ    $B342
B311: 81 8C       CMPA   #$8C
B313: 27 2D       BEQ    $B342
B315: EC 1C       LDD    -$4,X
B317: 10 83 FC 00 CMPD   #$FC00
B31B: 2C 01       BGE    $B31E
B31D: 39          RTS
B31E: 10 83 10 00 CMPD   #$1000
B322: 2D 01       BLT    $B325
B324: 39          RTS
B325: A6 07       LDA    $7,X
B327: 85 02       BITA   #$02
B329: 26 09       BNE    $B334
B32B: EC 1A       LDD    -$6,X
B32D: 10 83 FD 00 CMPD   #$FD00
B331: 2D 0A       BLT    $B33D
B333: 39          RTS
B334: EC 1A       LDD    -$6,X
B336: 10 83 15 00 CMPD   #$1500
B33A: 2C 01       BGE    $B33D
B33C: 39          RTS
B33D: E6 07       LDB    $7,X
B33F: 7E B4 29    JMP    function_b429
B342: EC 1C       LDD    -$4,X
B344: 10 83 FC 00 CMPD   #$FC00
B348: 2D 28       BLT    $B372
B34A: 10 83 10 00 CMPD   #$1000
B34E: 2C 22       BGE    $B372
B350: EC 1A       LDD    -$6,X
B352: 10 83 15 00 CMPD   #$1500
B356: 2C 1A       BGE    $B372
B358: 10 83 FD 00 CMPD   #$FD00
B35C: 2D 14       BLT    $B372
B35E: 0C 33       INC    $33
B360: 0C 39       INC    $39
B362: A6 84       LDA    ,X
B364: 84 7F       ANDA   #$7F
B366: A7 84       STA    ,X
B368: E6 07       LDB    $7,X
B36A: E1 01       CMPB   $1,X
B36C: 26 01       BNE    $B36F
B36E: 39          RTS
B36F: 7E B4 29    JMP    function_b429
B372: A6 84       LDA    ,X
B374: 8A 80       ORA    #$80
B376: A7 84       STA    ,X
B378: 39          RTS

B402: 7E CE 7E    JMP    function_ce7e
B405: CE 7E CE    LDU    #$7ECE		; banked ROM
B408: 7E CD 88    JMP    function_cd88


; called 1x; jumped-to 83x  from $8644, $8687, $96B1, $9811, $B2FF, $B33F, $B36F, $B55A, ...
function_b429:
B429: E7 07       STB    $7,X
B42B: C5 03       BITB   #$03
B42D: 26 08       BNE    $B437
B42F: E6 01       LDB    $1,X
B431: C4 03       ANDB   #$03
B433: EB 07       ADDB   $7,X
B435: E7 07       STB    $7,X
B437: A6 84       LDA    ,X
B439: 84 7F       ANDA   #$7F
B43B: 81 10       CMPA   #$10
B43D: 24 08       BCC    $B447
B43F: CE B4 4F    LDU    #jump_table_b44f
B442: C4 FC       ANDB   #$FC
B444: 54          LSRB
B445: 6E D5       JMP    [B,U]		; [indirect_jump] [nb_entries=106]
B447: CE B4 B9    LDU    #jump_table_b4b9
B44A: C4 FC       ANDB   #$FC
B44C: 54          LSRB
B44D: 6E D5       JMP    [B,U]		; [indirect_jump] [nb_entries=53]


; 5 jump-table ref
function_b523:
B523: CC 00 00    LDD    #$0000
B526: ED 18       STD    -$8,X
B528: CE B5 44    LDU    #$B544		; ROM
B52B: A6 03       LDA    $3,X
B52D: 84 30       ANDA   #$30
B52F: 44          LSRA
B530: 44          LSRA
B531: A7 E2       STA    ,-S		; [local]
B533: A6 07       LDA    $7,X
B535: 84 02       ANDA   #$02
B537: AB E0       ADDA   ,S+		; [local]
B539: EC C6       LDD    A,U		; [rom_address]
B53B: A7 08       STA    $8,X
B53D: 5D          TSTB
B53E: 1D          SEX
B53F: ED 16       STD    -$A,X
B541: 7E 8D C8    JMP    function_8dc8

B557: 2A 01       BPL    $B55A
B559: 39          RTS
B55A: 10 26 FE CB LBNE   function_b429
B55E: BD 9A FA    JSR    function_9afa
B561: 10 26 FE C4 LBNE   function_b429
B565: BD 9A 62    JSR    function_9a62
B568: 10 26 FE BD LBNE   function_b429
B56C: BD B6 57    JSR    function_b657
B56F: 10 26 FE B6 LBNE   function_b429
B573: BD B5 C1    JSR    function_b5c1
B576: 10 26 FE AF LBNE   function_b429
B57A: 6A 0A       DEC    $A,X
B57C: 27 01       BEQ    $B57F
B57E: 39          RTS
B57F: A6 09       LDA    $9,X
B581: 81 05       CMPA   #$05
B583: 26 04       BNE    $B589
B585: 86 FF       LDA    #$FF
B587: A7 09       STA    $9,X
B589: A6 0C       LDA    $C,X
B58B: 84 20       ANDA   #$20
B58D: A7 0C       STA    $C,X
B58F: A6 01       LDA    $1,X
B591: 84 FC       ANDA   #$FC
B593: 81 04       CMPA   #$04
B595: 26 06       BNE    $B59D
B597: CE DB 1C    LDU    #$DB1C
B59A: 7E 8D E8    JMP    function_8de8
B59D: CE DB 34    LDU    #$DB34
B5A0: 7E 8D E8    JMP    function_8de8
B5A3: BD 94 97    JSR    function_9497
B5A6: 2A 01       BPL    $B5A9
B5A8: 39          RTS
B5A9: 10 26 FE 7C LBNE   function_b429
B5AD: 6A 0A       DEC    $A,X
B5AF: 27 01       BEQ    $B5B2
B5B1: 39          RTS
B5B2: A6 09       LDA    $9,X
B5B4: 81 05       CMPA   #$05
B5B6: 27 06       BEQ    $B5BE
B5B8: CE DB 1C    LDU    #$DB1C
B5BB: 7E 8D E8    JMP    function_8de8
B5BE: 6C 14       INC    -$C,X
B5C0: 39          RTS

; called 1x  from $B573
function_b5c1:
B5C1: A6 0C       LDA    $C,X
B5C3: 85 20       BITA   #$20
B5C5: 26 43       BNE    $B60A
B5C7: A6 0D       LDA    $D,X
B5C9: 2B 19       BMI    $B5E4
B5CB: 85 01       BITA   #$01
B5CD: 26 3D       BNE    $B60C
B5CF: E6 03       LDB    $3,X
B5D1: C5 40       BITB   #$40
B5D3: 26 13       BNE    $B5E8
B5D5: 6A 08       DEC    $8,X
B5D7: 26 31       BNE    $B60A
B5D9: C5 0C       BITB   #$0C
B5DB: 27 1F       BEQ    $B5FC
B5DD: C5 08       BITB   #$08
B5DF: 26 07       BNE    $B5E8
B5E1: C6 38       LDB    #$38
B5E3: 39          RTS
B5E4: 6A 08       DEC    $8,X
B5E6: 26 22       BNE    $B60A
B5E8: 85 20       BITA   #$20
B5EA: 26 F5       BNE    $B5E1
B5EC: E6 0C       LDB    $C,X
B5EE: C5 20       BITB   #$20
B5F0: 26 18       BNE    $B60A
B5F2: 85 08       BITA   #$08
B5F4: 26 03       BNE    $B5F9
B5F6: C6 3C       LDB    #$3C
B5F8: 39          RTS
B5F9: C6 08       LDB    #$08
B5FB: 39          RTS
B5FC: CE B5 44    LDU    #$B544		; ROM
B5FF: A6 03       LDA    $3,X
B601: 84 30       ANDA   #$30
B603: 44          LSRA
B604: 44          LSRA
B605: 44          LSRA
B606: A6 C6       LDA    A,U
B608: A7 08       STA    $8,X
B60A: 5F          CLRB
B60B: 39          RTS
B60C: EC 1A       LDD    -$6,X
B60E: B3 04 0A    SUBD   $040A		; work RAM (shared with CPU1 $4400)
B611: 2A 05       BPL    $B618
B613: 53          COMB
B614: 43          COMA
B615: C3 00 01    ADDD   #$0001
B618: 10 83 01 80 CMPD   #$0180
B61C: 25 2E       BCS    $B64C
B61E: 6A 08       DEC    $8,X
B620: 26 E8       BNE    $B60A
B622: CE B6 4F    LDU    #$B64F
B625: A6 02       LDA    $2,X
B627: 84 0C       ANDA   #$0C
B629: 27 17       BEQ    $B642
B62B: A7 E2       STA    ,-S		; [local]
B62D: 96 0E       LDA    dp_irqcount1_0e		; CPU1 IRQ/frame counter
B62F: 84 02       ANDA   #$02
B631: AB E0       ADDA   ,S+		; [local]
B633: 44          LSRA
B634: E6 C6       LDB    A,U
B636: C1 0C       CMPB   #$0C
B638: 27 01       BEQ    $B63B
B63A: 39          RTS
B63B: A6 0C       LDA    $C,X
B63D: 8A 08       ORA    #$08
B63F: A7 0C       STA    $C,X
B641: 39          RTS
B642: E6 02       LDB    $2,X
B644: C4 40       ANDB   #$40
B646: 26 01       BNE    $B649
B648: 39          RTS
B649: C6 88       LDB    #$88
B64B: 39          RTS
B64C: C6 94       LDB    #$94
B64E: 39          RTS


; called 1x  from $B56C
function_b657:
B657: A6 02       LDA    $2,X
B659: 84 20       ANDA   #$20
B65B: 26 01       BNE    $B65E
B65D: 39          RTS

B65E: 96 0F       LDA    dp_irqcount2_0f		; CPU2 IRQ/frame counter
B660: 84 0F       ANDA   #$0F
B662: 27 02       BEQ    $B666
B664: 5F          CLRB
B665: 39          RTS
B666: 96 53       LDA    $53
B668: 26 01       BNE    $B66B
B66A: 39          RTS
B66B: 97 55       STA    $55
B66D: CE 10 00    LDU    #$1000		; work RAM (shared with CPU1 $4400)
B670: A6 C4       LDA    ,U
B672: 2B 60       BMI    $B6D4
B674: 84 7C       ANDA   #$7C
B676: 81 40       CMPA   #$40
B678: 26 5A       BNE    $B6D4
B67A: A6 41       LDA    $1,U
B67C: 84 38       ANDA   #$38
B67E: 26 4F       BNE    $B6CF
B680: EC 4A       LDD    $A,U
B682: C3 00 E0    ADDD   #$00E0
B685: A3 1A       SUBD   -$6,X
B687: 2A 05       BPL    $B68E
B689: 53          COMB
B68A: 43          COMA
B68B: C3 00 01    ADDD   #$0001
B68E: 10 83 00 80 CMPD   #$0080
B692: 24 3B       BCC    $B6CF
B694: A6 44       LDA    $4,U
B696: A1 05       CMPA   $5,X
B698: 27 17       BEQ    $B6B1
B69A: 10 8E B6 DB LDY    #$B6DB		; ROM
B69E: EC 4C       LDD    $C,U
B6A0: A3 1C       SUBD   -$4,X
B6A2: A3 A4       SUBD   ,Y
B6A4: 26 29       BNE    $B6CF
B6A6: A6 C4       LDA    ,U
B6A8: 81 43       CMPA   #$43
B6AA: 27 02       BEQ    $B6AE
B6AC: 5F          CLRB
B6AD: 39          RTS
B6AE: C6 AC       LDB    #$AC
B6B0: 39          RTS
B6B1: 10 8E B6 D9 LDY    #$B6D9
B6B5: A6 41       LDA    $1,U
B6B7: 84 04       ANDA   #$04
B6B9: 44          LSRA
B6BA: 31 A6       LEAY   A,Y
B6BC: EC 4C       LDD    $C,U
B6BE: A3 1C       SUBD   -$4,X
B6C0: A3 A4       SUBD   ,Y
B6C2: 26 0B       BNE    $B6CF
B6C4: A6 C4       LDA    ,U
B6C6: 81 43       CMPA   #$43
B6C8: 27 02       BEQ    $B6CC
B6CA: 5F          CLRB
B6CB: 39          RTS
B6CC: C6 A8       LDB    #$A8
B6CE: 39          RTS
B6CF: 0A 55       DEC    $55
B6D1: 26 01       BNE    $B6D4
B6D3: 39          RTS
B6D4: 33 C8 10    LEAU   $10,U
B6D7: 20 97       BRA    $B670
B6D9: 04 70       LSR    $70
B6DB: 03 F0       COM    $F0

; 4 jump-table ref
function_b6dd:
B6DD: CC 00 70    LDD    #$0070
B6E0: ED 18       STD    -$8,X
B6E2: A6 0C       LDA    $C,X
B6E4: 84 7E       ANDA   #$7E
B6E6: A7 0C       STA    $C,X
B6E8: 7E 8D C8    JMP    function_8dc8
B6EB: BD 94 97    JSR    function_9497
B6EE: 2A 01       BPL    $B6F1
B6F0: 39          RTS
B6F1: BD 95 6D    JSR    function_956d
B6F4: 26 0B       BNE    $B701
B6F6: 6A 0A       DEC    $A,X
B6F8: 27 01       BEQ    $B6FB
B6FA: 39          RTS
B6FB: CE DB 4C    LDU    #$DB4C		; ROM
B6FE: 7E 8D E8    JMP    function_8de8
B701: C6 04       LDB    #$04
B703: 7E B4 29    JMP    function_b429

; 2 jump-table ref
function_b706:
B706: EC 1C       LDD    -$4,X
B708: 10 83 07 00 CMPD   #$0700
B70C: 2C 05       BGE    $B713
B70E: C6 28       LDB    #$28
B710: 7E B4 29    JMP    function_b429
B713: C6 2C       LDB    #$2C
B715: 7E B4 29    JMP    function_b429

; 2 jump-table ref
function_b718:
B718: CC 00 A0    LDD    #$00A0
B71B: ED 18       STD    -$8,X
B71D: 7E 8D C8    JMP    function_8dc8

; 2 jump-table ref
function_b720:
B720: 7E 8D C8    JMP    function_8dc8
B723: CE B7 F4    LDU    #jump_table_b7f4
B726: A6 09       LDA    $9,X
B728: 48          ASLA
B729: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=11]

; 1 jump-table ref
function_b72b:
B72B: 6A 0A       DEC    $A,X
B72D: 27 01       BEQ    $B730
B72F: 39          RTS
B730: A6 01       LDA    $1,X
B732: 88 03       EORA   #$03
B734: A7 01       STA    $1,X
B736: A7 07       STA    $7,X
B738: CE DB 64    LDU    #$DB64		; ROM
B73B: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b73e:
B73E: BD 95 6D    JSR    function_956d
B741: 26 0F       BNE    $B752
B743: EC 18       LDD    -$8,X
B745: 27 1D       BEQ    $B764
B747: 6A 0A       DEC    $A,X
B749: 27 01       BEQ    $B74C
B74B: 39          RTS
B74C: CE DB 64    LDU    #$DB64		; ROM
B74F: 7E 8D E8    JMP    function_8de8
B752: 6C 09       INC    $9,X
B754: CE DB 64    LDU    #$DB64
B757: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b75a:
B75A: BD 95 6D    JSR    function_956d
B75D: 26 0A       BNE    $B769
B75F: EC 18       LDD    -$8,X
B761: 27 01       BEQ    $B764
B763: 39          RTS
B764: C6 34       LDB    #$34
B766: 7E B4 29    JMP    function_b429
B769: A6 01       LDA    $1,X
B76B: 88 03       EORA   #$03
B76D: A7 01       STA    $1,X
B76F: A7 07       STA    $7,X
B771: CE DB 64    LDU    #$DB64		; ROM
B774: 7E 8D E8    JMP    function_8de8

; 3 jump-table ref
function_b777:
B777: 6A 0A       DEC    $A,X
B779: 27 01       BEQ    $B77C
B77B: 39          RTS
B77C: CE DB 64    LDU    #$DB64		; ROM
B77F: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b782:
B782: 6A 0A       DEC    $A,X
B784: 27 01       BEQ    $B787
B786: 39          RTS
B787: A6 05       LDA    $5,X
B789: 81 40       CMPA   #$40
B78B: 26 0A       BNE    $B797
B78D: 86 80       LDA    #$80
B78F: A7 05       STA    $5,X
B791: CE DB 64    LDU    #$DB64		; ROM
B794: 7E 8D E8    JMP    function_8de8
B797: 86 40       LDA    #$40
B799: A7 05       STA    $5,X
B79B: CE DB 64    LDU    #$DB64
B79E: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b7a1:
B7A1: 6A 0A       DEC    $A,X
B7A3: 27 01       BEQ    $B7A6
B7A5: 39          RTS
B7A6: CC 00 00    LDD    #$0000
B7A9: ED 18       STD    -$8,X
B7AB: A6 0C       LDA    $C,X
B7AD: 85 01       BITA   #$01
B7AF: 26 0B       BNE    $B7BC
B7B1: A6 0D       LDA    $D,X
B7B3: 85 01       BITA   #$01
B7B5: 26 05       BNE    $B7BC
B7B7: C6 38       LDB    #$38
B7B9: 7E B4 29    JMP    function_b429
B7BC: A6 0C       LDA    $C,X
B7BE: 84 FD       ANDA   #$FD
B7C0: A7 0C       STA    $C,X
B7C2: C6 04       LDB    #$04
B7C4: 7E B4 29    JMP    function_b429
B7C7: CE B8 04    LDU    #jump_table_b804
B7CA: A6 09       LDA    $9,X
B7CC: 48          ASLA
B7CD: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]

; 2 jump-table ref
function_b7cf:
B7CF: BD 95 6D    JSR    function_956d
B7D2: 26 01       BNE    $B7D5
B7D4: 39          RTS
B7D5: CE DB 8C    LDU    #$DB8C		; ROM
B7D8: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_b7db:
B7DB: 6A 0A       DEC    $A,X
B7DD: 27 01       BEQ    $B7E0
B7DF: 39          RTS
B7E0: A6 0C       LDA    $C,X
B7E2: 8A 20       ORA    #$20
B7E4: A7 0C       STA    $C,X
B7E6: 85 01       BITA   #$01
B7E8: 26 05       BNE    $B7EF
B7EA: C6 04       LDB    #$04
B7EC: 7E B4 29    JMP    function_b429
B7EF: C6 48       LDB    #$48
B7F1: 7E B4 29    JMP    function_b429


; 2 jump-table ref
function_b808:
B808: CC 00 00    LDD    #$0000
B80B: ED 18       STD    -$8,X
B80D: 7E 8D C8    JMP    function_8dc8


; 2 jump-table ref
function_b810:
B810: CC 00 20    LDD    #$0020
B813: ED 18       STD    -$8,X
B815: 7E 8D C8    JMP    function_8dc8
B818: CE B8 DE    LDU    #jump_table_b8de
B81B: A6 09       LDA    $9,X
B81D: 48          ASLA
B81E: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=10]

; 1 jump-table ref
function_b820:
B820: 6A 0A       DEC    $A,X
B822: 27 01       BEQ    $B825
B824: 39          RTS
B825: CE DD 20    LDU    #$DD20		; ROM
B828: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b82b:
B82B: 6A 0A       DEC    $A,X
B82D: 27 01       BEQ    $B830
B82F: 39          RTS
B830: A6 05       LDA    $5,X
B832: 81 40       CMPA   #$40
B834: 27 0A       BEQ    $B840
B836: 86 40       LDA    #$40
B838: A7 05       STA    $5,X
B83A: CE DD 20    LDU    #$DD20		; ROM
B83D: 7E 8D E8    JMP    function_8de8
B840: 86 80       LDA    #$80
B842: A7 05       STA    $5,X
B844: CE DD 20    LDU    #$DD20
B847: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b84a:
B84A: 6A 0A       DEC    $A,X
B84C: 27 01       BEQ    $B84F
B84E: 39          RTS
B84F: CE DD 20    LDU    #$DD20		; ROM
B852: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b855:
B855: BD 95 6D    JSR    function_956d
B858: 26 0B       BNE    $B865
B85A: 6A 0A       DEC    $A,X
B85C: 27 01       BEQ    $B85F
B85E: 39          RTS
B85F: CE DD 20    LDU    #$DD20		; ROM
B862: 7E 8D E8    JMP    function_8de8
B865: 6C 09       INC    $9,X
B867: 6C 09       INC    $9,X
B869: CE DD 20    LDU    #$DD20
B86C: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b86f:
B86F: BD 95 6D    JSR    function_956d
B872: 26 0B       BNE    $B87F
B874: 6A 0A       DEC    $A,X
B876: 27 01       BEQ    $B879
B878: 39          RTS
B879: CE DD 20    LDU    #$DD20		; ROM
B87C: 7E 8D E8    JMP    function_8de8
B87F: 6C 09       INC    $9,X
B881: CE DD 20    LDU    #$DD20
B884: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b887:
B887: BD 95 6D    JSR    function_956d
B88A: 26 01       BNE    $B88D
B88C: 39          RTS
B88D: CE DD 20    LDU    #$DD20		; ROM
B890: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b893:
B893: 6A 0A       DEC    $A,X
B895: 27 01       BEQ    $B898
B897: 39          RTS
B898: CE DD 20    LDU    #$DD20		; ROM
B89B: 7E 8D E8    JMP    function_8de8

; 3 jump-table ref
function_b89e:
B89E: 6A 0A       DEC    $A,X
B8A0: 27 01       BEQ    $B8A3
B8A2: 39          RTS
B8A3: CC 00 00    LDD    #$0000
B8A6: ED 18       STD    -$8,X
B8A8: A6 0C       LDA    $C,X
B8AA: 85 01       BITA   #$01
B8AC: 26 0B       BNE    $B8B9
B8AE: A6 0D       LDA    $D,X
B8B0: 84 01       ANDA   #$01
B8B2: 26 05       BNE    $B8B9
B8B4: C6 38       LDB    #$38
B8B6: 7E B4 29    JMP    function_b429
B8B9: A6 0C       LDA    $C,X
B8BB: 84 FD       ANDA   #$FD
B8BD: A7 0C       STA    $C,X
B8BF: C6 04       LDB    #$04
B8C1: 7E B4 29    JMP    function_b429
B8C4: CE B8 EE    LDU    #jump_table_b8ee
B8C7: A6 09       LDA    $9,X
B8C9: 48          ASLA
B8CA: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]

; 2 jump-table ref
function_b8cc:
B8CC: BD 94 97    JSR    function_9497
B8CF: 2A 01       BPL    $B8D2
B8D1: 39          RTS
B8D2: BD 95 6D    JSR    function_956d
B8D5: 26 01       BNE    $B8D8
B8D7: 39          RTS
B8D8: CE DB 84    LDU    #$DB84		; ROM
B8DB: 7E 8D E8    JMP    function_8de8

; 3 jump-table ref
function_b8f2:
B8F2: EC 1A       LDD    -$6,X
B8F4: 10 83 14 00 CMPD   #$1400
B8F8: 2C 46       BGE    function_b940
B8FA: A6 02       LDA    $2,X
B8FC: 84 10       ANDA   #$10
B8FE: 26 07       BNE    $B907
B900: 86 01       LDA    #$01
B902: A7 08       STA    $8,X
B904: 7E 8D C8    JMP    function_8dc8
B907: 86 03       LDA    #$03
B909: A7 08       STA    $8,X
B90B: 7E 8D C8    JMP    function_8dc8
B90E: 6A 0A       DEC    $A,X
B910: 27 01       BEQ    $B913
B912: 39          RTS
B913: CE B9 1B    LDU    #jump_table_b91b
B916: A6 09       LDA    $9,X
B918: 48          ASLA
B919: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]


; 2 jump-table ref
function_b925:
B925: CE DB 94    LDU    #$DB94		; ROM
B928: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b92b:
B92B: BD B9 C6    JSR    function_b9c6
B92E: CE DB 94    LDU    #$DB94		; ROM
B931: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b934:
B934: 6A 08       DEC    $8,X
B936: 27 02       BEQ    $B93A
B938: 6F 09       CLR    $9,X
B93A: CE DB 94    LDU    #$DB94		; ROM
B93D: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref  from $B8F8
function_b940:
B940: A6 0D       LDA    $D,X
B942: 84 01       ANDA   #$01
B944: 27 0A       BEQ    $B950
B946: 7D 00 02    TST    >$0002
B949: 2B 0A       BMI    $B955
B94B: C6 04       LDB    #$04
B94D: 7E B4 29    JMP    function_b429
B950: C6 70       LDB    #$70
B952: 7E B4 29    JMP    function_b429
B955: C6 00       LDB    #$00
B957: 7E B4 29    JMP    function_b429

; 3 jump-table ref
function_b95a:
B95A: A6 0C       LDA    $C,X
B95C: 8A 08       ORA    #$08
B95E: A7 0C       STA    $C,X
B960: A6 02       LDA    $2,X
B962: 84 10       ANDA   #$10
B964: 26 07       BNE    $B96D
B966: 86 01       LDA    #$01
B968: A7 08       STA    $8,X
B96A: 7E 8D C8    JMP    function_8dc8
B96D: 86 03       LDA    #$03
B96F: A7 08       STA    $8,X
B971: 7E 8D C8    JMP    function_8dc8
B974: 6A 0A       DEC    $A,X
B976: 27 01       BEQ    $B979
B978: 39          RTS
B979: CE B9 81    LDU    #jump_table_b981
B97C: A6 09       LDA    $9,X
B97E: 48          ASLA
B97F: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]


; 2 jump-table ref
function_b98b:
B98B: CE DB A8    LDU    #$DBA8		; ROM
B98E: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b991:
B991: BD BA 98    JSR    function_ba98
B994: CE DB A8    LDU    #$DBA8		; ROM
B997: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b99a:
B99A: 6A 08       DEC    $8,X
B99C: 27 02       BEQ    $B9A0
B99E: 6F 09       CLR    $9,X
B9A0: CE DB A8    LDU    #$DBA8		; ROM
B9A3: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_b9a6:
B9A6: A6 0C       LDA    $C,X
B9A8: 84 F7       ANDA   #$F7
B9AA: A7 0C       STA    $C,X
B9AC: A6 0D       LDA    $D,X
B9AE: 84 01       ANDA   #$01
B9B0: 27 0A       BEQ    $B9BC
B9B2: 7D 00 02    TST    >$0002
B9B5: 2B 0A       BMI    $B9C1
B9B7: C6 14       LDB    #$14
B9B9: 7E B4 29    JMP    function_b429
B9BC: C6 70       LDB    #$70
B9BE: 7E B4 29    JMP    function_b429
B9C1: C6 10       LDB    #$10
B9C3: 7E B4 29    JMP    function_b429

; called 1x  from $B92B
function_b9c6:
B9C6: CE 09 00    LDU    #$0900		; work RAM (shared with CPU1 $4400)
B9C9: C6 FF       LDB    #$FF
B9CB: E1 C4       CMPB   ,U
B9CD: 26 05       BNE    $B9D4
B9CF: E1 C8 10    CMPB   $10,U
B9D2: 27 19       BEQ    $B9ED
B9D4: 33 C8 10    LEAU   $10,U
B9D7: 11 83 0C 00 CMPU   #$0C00
B9DB: 25 EE       BCS    $B9CB
B9DD: 10 8E 13 A0 LDY    #$13A0
B9E1: 96 E6       LDA    $E6
B9E3: C6 2B       LDB    #$2B
B9E5: E7 A6       STB    A,Y
B9E7: 4C          INCA
B9E8: 84 1F       ANDA   #$1F
B9EA: 97 E6       STA    $E6
B9EC: 39          RTS
B9ED: 10 8E 13 60 LDY    #$1360
B9F1: 96 E4       LDA    $E4
B9F3: C6 01       LDB    #$01
B9F5: E7 A6       STB    A,Y
B9F7: 4C          INCA
B9F8: 84 1F       ANDA   #$1F
B9FA: 97 E4       STA    $E4
B9FC: A6 01       LDA    $1,X
B9FE: 84 02       ANDA   #$02
BA00: 26 4B       BNE    $BA4D
BA02: 86 E1       LDA    #$E1
BA04: C6 01       LDB    #$01
BA06: ED C4       STD    ,U
BA08: CC 7B 24    LDD    #$7B24
BA0B: ED 4E       STD    $E,U
BA0D: CC 00 2C    LDD    #$002C
BA10: ED 46       STD    $6,U
BA12: EC 1A       LDD    -$6,X
BA14: C3 00 80    ADDD   #$0080
BA17: ED 4A       STD    $A,U
BA19: EC 1C       LDD    -$4,X
BA1B: C3 02 40    ADDD   #$0240
BA1E: ED 4C       STD    $C,U
BA20: E6 05       LDB    $5,X
BA22: E7 44       STB    $4,U
BA24: 6F 42       CLR    $2,U
BA26: 6F 43       CLR    $3,U
BA28: 0C 40       INC    $40
BA2A: 33 C8 10    LEAU   $10,U
BA2D: 86 E2       LDA    #$E2
BA2F: C6 01       LDB    #$01
BA31: ED C4       STD    ,U
BA33: CC 7B 3C    LDD    #$7B3C
BA36: ED 4E       STD    $E,U
BA38: EC 1A       LDD    -$6,X
BA3A: C3 01 80    ADDD   #$0180
BA3D: ED 4A       STD    $A,U
BA3F: EC 1C       LDD    -$4,X
BA41: C3 02 40    ADDD   #$0240
BA44: ED 4C       STD    $C,U
BA46: 6F 42       CLR    $2,U
BA48: 6F 43       CLR    $3,U
BA4A: 0C 40       INC    $40
BA4C: 39          RTS
BA4D: 86 E1       LDA    #$E1
BA4F: C6 02       LDB    #$02
BA51: ED C4       STD    ,U
BA53: CC 7B 28    LDD    #$7B28
BA56: ED 4E       STD    $E,U
BA58: CC FF D4    LDD    #$FFD4
BA5B: ED 46       STD    $6,U
BA5D: EC 1A       LDD    -$6,X
BA5F: 83 01 80    SUBD   #$0180
BA62: ED 4A       STD    $A,U
BA64: EC 1C       LDD    -$4,X
BA66: C3 02 40    ADDD   #$0240
BA69: ED 4C       STD    $C,U
BA6B: E6 05       LDB    $5,X
BA6D: E7 44       STB    $4,U
BA6F: 6F 42       CLR    $2,U
BA71: 6F 43       CLR    $3,U
BA73: 0C 40       INC    $40
BA75: 33 C8 10    LEAU   $10,U
BA78: 86 E2       LDA    #$E2
BA7A: C6 02       LDB    #$02
BA7C: ED C4       STD    ,U
BA7E: CC 7B 40    LDD    #$7B40
BA81: ED 4E       STD    $E,U
BA83: EC 1A       LDD    -$6,X
BA85: 83 02 80    SUBD   #$0280
BA88: ED 4A       STD    $A,U
BA8A: EC 1C       LDD    -$4,X
BA8C: C3 02 40    ADDD   #$0240
BA8F: ED 4C       STD    $C,U
BA91: 6F 42       CLR    $2,U
BA93: 6F 43       CLR    $3,U
BA95: 0C 40       INC    $40
BA97: 39          RTS

; called 1x  from $B991
function_ba98:
BA98: CE 09 00    LDU    #$0900		; work RAM (shared with CPU1 $4400)
BA9B: C6 FF       LDB    #$FF
BA9D: E1 C4       CMPB   ,U
BA9F: 26 05       BNE    $BAA6
BAA1: E1 C8 10    CMPB   $10,U
BAA4: 27 19       BEQ    $BABF
BAA6: 33 C8 10    LEAU   $10,U
BAA9: 11 83 0C 00 CMPU   #$0C00
BAAD: 25 EE       BCS    $BA9D
BAAF: 10 8E 13 A0 LDY    #$13A0
BAB3: 96 E6       LDA    $E6
BAB5: C6 2B       LDB    #$2B
BAB7: E7 A6       STB    A,Y
BAB9: 4C          INCA
BABA: 84 1F       ANDA   #$1F
BABC: 97 E6       STA    $E6
BABE: 39          RTS
BABF: 10 8E 13 60 LDY    #$1360
BAC3: 96 E4       LDA    $E4
BAC5: C6 01       LDB    #$01
BAC7: E7 A6       STB    A,Y
BAC9: 4C          INCA
BACA: 84 1F       ANDA   #$1F
BACC: 97 E4       STA    $E4
BACE: A6 01       LDA    $1,X
BAD0: 84 02       ANDA   #$02
BAD2: 26 4B       BNE    $BB1F
BAD4: 86 E1       LDA    #$E1
BAD6: C6 01       LDB    #$01
BAD8: ED C4       STD    ,U
BADA: CC 7B 24    LDD    #$7B24
BADD: ED 4E       STD    $E,U
BADF: CC 00 2C    LDD    #$002C
BAE2: ED 46       STD    $6,U
BAE4: EC 1A       LDD    -$6,X
BAE6: 83 00 80    SUBD   #$0080
BAE9: ED 4A       STD    $A,U
BAEB: EC 1C       LDD    -$4,X
BAED: C3 00 F0    ADDD   #$00F0
BAF0: ED 4C       STD    $C,U
BAF2: E6 05       LDB    $5,X
BAF4: E7 44       STB    $4,U
BAF6: 6F 42       CLR    $2,U
BAF8: 6F 43       CLR    $3,U
BAFA: 0C 40       INC    $40
BAFC: 33 C8 10    LEAU   $10,U
BAFF: 86 E2       LDA    #$E2
BB01: C6 01       LDB    #$01
BB03: ED C4       STD    ,U
BB05: CC 7B 3C    LDD    #$7B3C
BB08: ED 4E       STD    $E,U
BB0A: EC 1A       LDD    -$6,X
BB0C: C3 00 80    ADDD   #$0080
BB0F: ED 4A       STD    $A,U
BB11: EC 1C       LDD    -$4,X
BB13: C3 00 F0    ADDD   #$00F0
BB16: ED 4C       STD    $C,U
BB18: 6F 42       CLR    $2,U
BB1A: 6F 43       CLR    $3,U
BB1C: 0C 40       INC    $40
BB1E: 39          RTS
BB1F: 86 E1       LDA    #$E1
BB21: C6 02       LDB    #$02
BB23: ED C4       STD    ,U
BB25: CC 7B 28    LDD    #$7B28
BB28: ED 4E       STD    $E,U
BB2A: CC FF D4    LDD    #$FFD4
BB2D: ED 46       STD    $6,U
BB2F: EC 1A       LDD    -$6,X
BB31: 83 00 80    SUBD   #$0080
BB34: ED 4A       STD    $A,U
BB36: EC 1C       LDD    -$4,X
BB38: C3 00 F0    ADDD   #$00F0
BB3B: ED 4C       STD    $C,U
BB3D: E6 05       LDB    $5,X
BB3F: E7 44       STB    $4,U
BB41: 6F 42       CLR    $2,U
BB43: 6F 43       CLR    $3,U
BB45: 0C 40       INC    $40
BB47: 33 C8 10    LEAU   $10,U
BB4A: 86 E2       LDA    #$E2
BB4C: C6 02       LDB    #$02
BB4E: ED C4       STD    ,U
BB50: CC 7B 40    LDD    #$7B40
BB53: ED 4E       STD    $E,U
BB55: EC 1A       LDD    -$6,X
BB57: 83 01 80    SUBD   #$0180
BB5A: ED 4A       STD    $A,U
BB5C: EC 1C       LDD    -$4,X
BB5E: C3 00 F0    ADDD   #$00F0
BB61: ED 4C       STD    $C,U
BB63: 6F 42       CLR    $2,U
BB65: 6F 43       CLR    $3,U
BB67: 0C 40       INC    $40
BB69: 39          RTS

; 2 jump-table ref
function_bb6a:
BB6A: CC 00 70    LDD    #$0070
BB6D: ED 18       STD    -$8,X
BB6F: A6 07       LDA    $7,X
BB71: 84 02       ANDA   #$02
BB73: 26 08       BNE    $BB7D
BB75: CC 00 30    LDD    #$0030
BB78: ED 16       STD    -$A,X
BB7A: 7E 8D C8    JMP    function_8dc8
BB7D: CC FF D0    LDD    #$FFD0
BB80: ED 16       STD    -$A,X
BB82: 7E 8D C8    JMP    function_8dc8
BB85: CE BB C2    LDU    #jump_table_bbc2
BB88: A6 09       LDA    $9,X
BB8A: 48          ASLA
BB8B: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]

; 1 jump-table ref
function_bb8d:
BB8D: BD 94 97    JSR    function_9497
BB90: 2A 01       BPL    $BB93
BB92: 39          RTS
BB93: BD 95 6D    JSR    function_956d
BB96: EC 18       LDD    -$8,X
BB98: 27 01       BEQ    $BB9B
BB9A: 39          RTS
BB9B: CE DB BC    LDU    #$DBBC		; ROM
BB9E: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_bba1:
BBA1: BD 94 97    JSR    function_9497
BBA4: 2A 01       BPL    $BBA7
BBA6: 39          RTS
BBA7: BD 95 6D    JSR    function_956d
BBAA: 26 01       BNE    $BBAD
BBAC: 39          RTS
BBAD: CE DB BC    LDU    #$DBBC		; ROM
BBB0: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_bbb3:
BBB3: 6A 0A       DEC    $A,X
BBB5: 27 01       BEQ    $BBB8
BBB7: 39          RTS
BBB8: CC 00 00    LDD    #$0000
BBBB: ED 18       STD    -$8,X
BBBD: C6 04       LDB    #$04
BBBF: 7E B4 29    JMP    function_b429


; 2 jump-table ref
function_bbc8:
BBC8: 7E 8D C8    JMP    function_8dc8
BBCB: 6A 0A       DEC    $A,X
BBCD: 27 01       BEQ    $BBD0
BBCF: 39          RTS

BBD0: C6 04       LDB    #$04
BBD2: 7E B4 29    JMP    function_b429
BBD5: 6A 0A       DEC    $A,X
BBD7: 27 01       BEQ    $BBDA
BBD9: 39          RTS
BBDA: 6C 14       INC    -$C,X
BBDC: 39          RTS

; 2 jump-table ref
function_bbdd:
BBDD: A6 0D       LDA    $D,X
BBDF: 85 20       BITA   #$20
BBE1: 26 12       BNE    $BBF5
BBE3: 85 01       BITA   #$01
BBE5: 26 13       BNE    $BBFA
BBE7: 85 08       BITA   #$08
BBE9: 26 05       BNE    $BBF0
BBEB: C6 3C       LDB    #$3C
BBED: 7E B4 29    JMP    function_b429
BBF0: C6 08       LDB    #$08
BBF2: 7E B4 29    JMP    function_b429
BBF5: C6 38       LDB    #$38
BBF7: 7E B4 29    JMP    function_b429
BBFA: C6 04       LDB    #$04
BBFC: 7E B4 29    JMP    function_b429
BBFF: 6A 0A       DEC    $A,X
BC01: 27 01       BEQ    $BC04
BC03: 39          RTS
BC04: CE BC 0C    LDU    #jump_table_bc0c
BC07: A6 09       LDA    $9,X
BC09: 48          ASLA
BC0A: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=9]


; 2 jump-table ref
function_bc1e:
BC1E: A6 01       LDA    $1,X
BC20: 88 03       EORA   #$03
BC22: A7 01       STA    $1,X
BC24: A7 07       STA    $7,X

; 1 jump-table ref
function_bc26:
BC26: CE DB C8    LDU    #$DBC8		; ROM
BC29: 7E 8D E8    JMP    function_8de8

; 5 jump-table ref
function_bc2c:
BC2C: A6 0D       LDA    $D,X
BC2E: 85 20       BITA   #$20
BC30: 27 1D       BEQ    $BC4F
BC32: E6 0C       LDB    $C,X
BC34: C4 FB       ANDB   #$FB
BC36: E7 0C       STB    $C,X
BC38: 85 01       BITA   #$01
BC3A: 26 0A       BNE    $BC46
BC3C: E6 01       LDB    $1,X
BC3E: C5 02       BITB   #$02
BC40: 26 09       BNE    $BC4B
BC42: 85 04       BITA   #$04
BC44: 27 09       BEQ    $BC4F
BC46: C6 54       LDB    #$54
BC48: 7E B4 29    JMP    function_b429
BC4B: 85 04       BITA   #$04
BC4D: 27 F7       BEQ    $BC46
BC4F: CE DB C8    LDU    #$DBC8		; ROM
BC52: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_bc55:
BC55: A6 0D       LDA    $D,X
BC57: 85 20       BITA   #$20
BC59: 27 0B       BEQ    $BC66
BC5B: E6 0C       LDB    $C,X
BC5D: C4 FB       ANDB   #$FB
BC5F: E7 0C       STB    $C,X
BC61: C6 04       LDB    #$04
BC63: 7E B4 29    JMP    function_b429
BC66: E6 0C       LDB    $C,X
BC68: C5 04       BITB   #$04
BC6A: 26 0C       BNE    $BC78
BC6C: C5 20       BITB   #$20
BC6E: 26 F1       BNE    $BC61
BC70: E6 03       LDB    $3,X
BC72: C4 03       ANDB   #$03
BC74: C1 01       CMPB   #$01
BC76: 27 E9       BEQ    $BC61
BC78: 85 08       BITA   #$08
BC7A: 26 05       BNE    $BC81
BC7C: C6 3C       LDB    #$3C
BC7E: 7E B4 29    JMP    function_b429
BC81: C6 08       LDB    #$08
BC83: 7E B4 29    JMP    function_b429

; 1 jump-table ref
function_bc86:
BC86: A6 03       LDA    $3,X
BC88: 84 03       ANDA   #$03
BC8A: 27 05       BEQ    $BC91
BC8C: 6F 08       CLR    $8,X
BC8E: 7E 8D C8    JMP    function_8dc8
BC91: 86 02       LDA    #$02
BC93: A7 08       STA    $8,X
BC95: A6 0C       LDA    $C,X
BC97: 8A 04       ORA    #$04
BC99: A7 0C       STA    $C,X
BC9B: 7E 8D C8    JMP    function_8dc8
BC9E: 6A 0A       DEC    $A,X
BCA0: 27 01       BEQ    $BCA3
BCA2: 39          RTS
BCA3: CE BC AB    LDU    #jump_table_bcab
BCA6: A6 09       LDA    $9,X
BCA8: 48          ASLA
BCA9: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=9]
BCAB: BC BD BC    CMPX   $BDBC		; ROM
BCAE: BD BC BD    JSR    function_bcbd
BCB1: BC BD BC    CMPX   $BDBC
BCB4: C3 BD 24    ADDD   #$BD24
BCB7: BC BD BC    CMPX   $BDBC
BCBA: BD BD 3A    JSR    function_bd3a

; called 1x; 6 jump-table ref  from $BCAE
function_bcbd:
BCBD: CE DD 94    LDU    #$DD94		; ROM
BCC0: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_bcc3:
BCC3: A6 0C       LDA    $C,X
BCC5: 85 01       BITA   #$01
BCC7: 26 39       BNE    $BD02
BCC9: A6 0D       LDA    $D,X
BCCB: 84 21       ANDA   #$21
BCCD: 26 4F       BNE    $BD1E
BCCF: A6 03       LDA    $3,X
BCD1: 85 40       BITA   #$40
BCD3: 26 2D       BNE    $BD02
BCD5: EC 1A       LDD    -$6,X
BCD7: B3 04 0A    SUBD   $040A		; work RAM (shared with CPU1 $4400)
BCDA: 10 83 FE 00 CMPD   #$FE00
BCDE: 2D 10       BLT    $BCF0
BCE0: 10 83 04 00 CMPD   #$0400
BCE4: 2C 14       BGE    $BCFA
BCE6: A6 03       LDA    $3,X
BCE8: 84 03       ANDA   #$03
BCEA: 81 02       CMPA   #$02
BCEC: 26 30       BNE    $BD1E
BCEE: 20 12       BRA    $BD02
BCF0: A6 03       LDA    $3,X
BCF2: 84 03       ANDA   #$03
BCF4: 81 01       CMPA   #$01
BCF6: 26 26       BNE    $BD1E
BCF8: 20 08       BRA    $BD02
BCFA: A6 03       LDA    $3,X
BCFC: 84 03       ANDA   #$03
BCFE: 81 03       CMPA   #$03
BD00: 26 1C       BNE    $BD1E
BD02: CE 13 E0    LDU    #$13E0
BD05: CC 00 FF    LDD    #$00FF
BD08: BD 93 02    JSR    function_9302
BD0B: 81 23       CMPA   #$23
BD0D: 27 09       BEQ    $BD18
BD0F: 81 2F       CMPA   #$2F
BD11: 27 05       BEQ    $BD18
BD13: C6 28       LDB    #$28
BD15: 7E B4 29    JMP    function_b429
BD18: A6 0C       LDA    $C,X
BD1A: 8A 20       ORA    #$20
BD1C: A7 0C       STA    $C,X
BD1E: CE DD 94    LDU    #$DD94		; ROM
BD21: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_bd24:
BD24: A6 0D       LDA    $D,X
BD26: 84 21       ANDA   #$21
BD28: 26 0A       BNE    $BD34
BD2A: 6D 08       TST    $8,X
BD2C: 27 06       BEQ    $BD34
BD2E: 6A 08       DEC    $8,X
BD30: 86 03       LDA    #$03
BD32: A7 09       STA    $9,X
BD34: CE DD 94    LDU    #$DD94		; ROM
BD37: 7E 8D E8    JMP    function_8de8

; called 1x; 1 jump-table ref  from $BCBA
function_bd3a:
BD3A: A6 0D       LDA    $D,X
BD3C: 84 01       ANDA   #$01
BD3E: 26 0B       BNE    $BD4B
BD40: A6 0C       LDA    $C,X
BD42: 85 20       BITA   #$20
BD44: 26 0B       BNE    $BD51
BD46: C6 38       LDB    #$38
BD48: 7E B4 29    JMP    function_b429
BD4B: A6 0C       LDA    $C,X
BD4D: 84 FB       ANDA   #$FB
BD4F: A7 0C       STA    $C,X
BD51: 85 01       BITA   #$01
BD53: 26 05       BNE    $BD5A
BD55: C6 04       LDB    #$04
BD57: 7E B4 29    JMP    function_b429
BD5A: C6 48       LDB    #$48
BD5C: 7E B4 29    JMP    function_b429

; 1 jump-table ref
function_bd5f:
BD5F: A6 03       LDA    $3,X
BD61: 84 03       ANDA   #$03
BD63: 27 05       BEQ    $BD6A
BD65: 6F 08       CLR    $8,X
BD67: 7E 8D C8    JMP    function_8dc8
BD6A: 86 02       LDA    #$02
BD6C: A7 08       STA    $8,X
BD6E: A6 0C       LDA    $C,X
BD70: 8A 04       ORA    #$04
BD72: A7 0C       STA    $C,X
BD74: 7E 8D C8    JMP    function_8dc8
BD77: 6A 0A       DEC    $A,X
BD79: 27 01       BEQ    $BD7C
BD7B: 39          RTS
BD7C: CE BD 84    LDU    #jump_table_bd84
BD7F: A6 09       LDA    $9,X
BD81: 48          ASLA
BD82: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=8]


; 5 jump-table ref
function_bd94:
BD94: CE DC FC    LDU    #$DCFC		; ROM
BD97: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_bd9a:
BD9A: A6 0C       LDA    $C,X
BD9C: 84 01       ANDA   #$01
BD9E: 26 4E       BNE    $BDEE
BDA0: A6 0D       LDA    $D,X
BDA2: 84 20       ANDA   #$20
BDA4: 26 60       BNE    $BE06
BDA6: A6 03       LDA    $3,X
BDA8: 85 40       BITA   #$40
BDAA: 26 42       BNE    $BDEE
BDAC: 85 03       BITA   #$03
BDAE: 27 2D       BEQ    $BDDD
BDB0: EC 1A       LDD    -$6,X
BDB2: B3 04 0A    SUBD   $040A		; work RAM (shared with CPU1 $4400)
BDB5: 10 83 FE 00 CMPD   #$FE00
BDB9: 2D 10       BLT    $BDCB
BDBB: 10 83 04 00 CMPD   #$0400
BDBF: 2C 14       BGE    $BDD5
BDC1: A6 03       LDA    $3,X
BDC3: 84 03       ANDA   #$03
BDC5: 81 02       CMPA   #$02
BDC7: 26 14       BNE    $BDDD
BDC9: 20 23       BRA    $BDEE
BDCB: A6 03       LDA    $3,X
BDCD: 84 03       ANDA   #$03
BDCF: 81 01       CMPA   #$01
BDD1: 26 0A       BNE    $BDDD
BDD3: 20 19       BRA    $BDEE
BDD5: A6 03       LDA    $3,X
BDD7: 84 03       ANDA   #$03
BDD9: 81 03       CMPA   #$03
BDDB: 27 11       BEQ    $BDEE
BDDD: A6 02       LDA    $2,X
BDDF: 84 40       ANDA   #$40
BDE1: 27 23       BEQ    $BE06
BDE3: 96 41       LDA    $41
BDE5: 81 10       CMPA   #$10
BDE7: 24 1D       BCC    $BE06
BDE9: C6 84       LDB    #$84
BDEB: 7E B4 29    JMP    function_b429
BDEE: CE 13 E0    LDU    #$13E0
BDF1: CC 00 03    LDD    #$0003
BDF4: BD 93 02    JSR    function_9302
BDF7: C4 10       ANDB   #$10
BDF9: 27 05       BEQ    $BE00
BDFB: C6 2C       LDB    #$2C
BDFD: 7E B4 29    JMP    function_b429
BE00: A6 0C       LDA    $C,X
BE02: 8A 20       ORA    #$20
BE04: A7 0C       STA    $C,X
BE06: CE DC FC    LDU    #$DCFC		; ROM
BE09: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_be0c:
BE0C: A6 0D       LDA    $D,X
BE0E: 84 21       ANDA   #$21
BE10: 26 0A       BNE    $BE1C
BE12: 6D 08       TST    $8,X
BE14: 27 06       BEQ    $BE1C
BE16: 6A 08       DEC    $8,X
BE18: 86 03       LDA    #$03
BE1A: A7 09       STA    $9,X
BE1C: CE DC FC    LDU    #$DCFC		; ROM
BE1F: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_be22:
BE22: A6 0D       LDA    $D,X
BE24: 85 01       BITA   #$01
BE26: 26 0B       BNE    $BE33
BE28: A6 0C       LDA    $C,X
BE2A: 85 20       BITA   #$20
BE2C: 26 0B       BNE    $BE39
BE2E: C6 38       LDB    #$38
BE30: 7E B4 29    JMP    function_b429
BE33: A6 0C       LDA    $C,X
BE35: 84 FB       ANDA   #$FB
BE37: A7 0C       STA    $C,X
BE39: 85 01       BITA   #$01
BE3B: 26 05       BNE    $BE42
BE3D: C6 04       LDB    #$04
BE3F: 7E B4 29    JMP    function_b429
BE42: C6 48       LDB    #$48
BE44: 7E B4 29    JMP    function_b429
BE47: 6A 0A       DEC    $A,X
BE49: 27 01       BEQ    $BE4C
BE4B: 39          RTS
BE4C: CE BE 54    LDU    #jump_table_be54
BE4F: A6 09       LDA    $9,X
BE51: 48          ASLA
BE52: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]


; 1 jump-table ref
function_be5e:
BE5E: A6 01       LDA    $1,X
BE60: 88 03       EORA   #$03
BE62: A7 01       STA    $1,X
BE64: A7 07       STA    $7,X

; 3 jump-table ref
function_be66:
BE66: CE DB EC    LDU    #$DBEC		; ROM
BE69: 7E 8D E8    JMP    function_8de8
BE6C: 6A 0A       DEC    $A,X
BE6E: 27 01       BEQ    function_be71
BE70: 39          RTS

; 1 jump-table ref  from $BE6E
function_be71:
BE71: A6 0C       LDA    $C,X
BE73: 84 FE       ANDA   #$FE
BE75: A7 0C       STA    $C,X
BE77: C6 04       LDB    #$04
BE79: 7E B4 29    JMP    function_b429
BE7C: 6A 0A       DEC    $A,X
BE7E: 27 01       BEQ    $BE81
BE80: 39          RTS
BE81: A6 09       LDA    $9,X
BE83: 81 04       CMPA   #$04
BE85: 27 12       BEQ    $BE99
BE87: 81 02       CMPA   #$02
BE89: 26 08       BNE    $BE93
BE8B: A6 01       LDA    $1,X
BE8D: 88 03       EORA   #$03
BE8F: A7 01       STA    $1,X
BE91: A7 07       STA    $7,X
BE93: CE DB EC    LDU    #$DBEC		; ROM
BE96: 7E 8D E8    JMP    function_8de8
BE99: 6C 14       INC    -$C,X
BE9B: 39          RTS
BE9C: 6A 0A       DEC    $A,X
BE9E: 27 01       BEQ    $BEA1
BEA0: 39          RTS
BEA1: A6 0C       LDA    $C,X
BEA3: 85 08       BITA   #$08
BEA5: 27 05       BEQ    $BEAC
BEA7: C6 1C       LDB    #$1C
BEA9: 7E B4 29    JMP    function_b429
BEAC: C6 10       LDB    #$10
BEAE: 7E B4 29    JMP    function_b429

; 2 jump-table ref
function_beb1:
BEB1: 86 02       LDA    #$02
BEB3: A7 08       STA    $8,X
BEB5: 7E 8D C8    JMP    function_8dc8
BEB8: 6A 0A       DEC    $A,X
BEBA: 27 01       BEQ    $BEBD
BEBC: 39          RTS
BEBD: CE BE C5    LDU    #jump_table_bec5
BEC0: A6 09       LDA    $9,X
BEC2: 48          ASLA
BEC3: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]


; 1 jump-table ref
function_bec9:
BEC9: CE DB 0C    LDU    #$DB0C		; ROM
BECC: 7E 8D E8    JMP    function_8de8


; 1 jump-table ref
function_becf:
BECF: A6 0D       LDA    $D,X
BED1: 85 01       BITA   #$01
BED3: 27 0E       BEQ    $BEE3
BED5: 6A 08       DEC    $8,X
BED7: 27 0A       BEQ    $BEE3
BED9: 86 FF       LDA    #$FF
BEDB: A7 09       STA    $9,X
BEDD: CE DB 0C    LDU    #$DB0C		; ROM
BEE0: 7E 8D E8    JMP    function_8de8
BEE3: C6 14       LDB    #$14
BEE5: 7E B4 29    JMP    function_b429
BEE8: 6A 0A       DEC    $A,X
BEEA: 27 01       BEQ    $BEED
BEEC: 39          RTS
BEED: A6 0D       LDA    $D,X
BEEF: 84 01       ANDA   #$01
BEF1: 27 1A       BEQ    $BF0D
BEF3: A6 0C       LDA    $C,X
BEF5: 84 01       ANDA   #$01
BEF7: 27 19       BEQ    $BF12
BEF9: A6 02       LDA    $2,X
BEFB: 85 0C       BITA   #$0C
BEFD: 26 04       BNE    $BF03
BEFF: 85 40       BITA   #$40
BF01: 27 14       BEQ    $BF17
BF03: C6 18       LDB    #$18
BF05: 7E B4 29    JMP    function_b429
BF08: C6 88       LDB    #$88
BF0A: 7E B4 29    JMP    function_b429
BF0D: C6 70       LDB    #$70
BF0F: 7E B4 29    JMP    function_b429
BF12: C6 04       LDB    #$04
BF14: 7E B4 29    JMP    function_b429
BF17: F6 00 24    LDB    >$0024
BF1A: 7E B4 29    JMP    function_b429

; 2 jump-table ref
function_bf1d:
BF1D: A6 07       LDA    $7,X
BF1F: 84 02       ANDA   #$02
BF21: 26 0A       BNE    $BF2D
BF23: CC 00 10    LDD    #$0010
BF26: ED 16       STD    -$A,X
BF28: ED 18       STD    -$8,X
BF2A: 7E 8D C8    JMP    function_8dc8
BF2D: CC 00 10    LDD    #$0010
BF30: ED 16       STD    -$A,X
BF32: CC FF F0    LDD    #$FFF0
BF35: ED 16       STD    -$A,X
BF37: 7E 8D C8    JMP    function_8dc8
BF3A: 6A 0A       DEC    $A,X
BF3C: 27 01       BEQ    $BF3F
BF3E: 39          RTS
BF3F: 6D 16       TST    -$A,X
BF41: 2B 08       BMI    $BF4B
BF43: CE BF 53    LDU    #jump_table_bf53
BF46: A6 09       LDA    $9,X
BF48: 48          ASLA
BF49: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=12]
BF4B: CE BF 5F    LDU    #jump_table_bf5f
BF4E: A6 09       LDA    $9,X
BF50: 48          ASLA
BF51: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]


; 1 jump-table ref
function_bf6b:
BF6B: EC 1A       LDD    -$6,X
BF6D: C3 00 C0    ADDD   #$00C0
BF70: 10 83 14 00 CMPD   #$1400
BF74: 2C 3F       BGE    $BFB5
BF76: ED 1A       STD    -$6,X
BF78: EC 1C       LDD    -$4,X
BF7A: C3 00 80    ADDD   #$0080
BF7D: 10 83 10 00 CMPD   #$1000
BF81: 2C 32       BGE    $BFB5
BF83: ED 1C       STD    -$4,X
BF85: BD 9C C1    JSR    function_9cc1
BF88: 27 38       BEQ    $BFC2

; 12 jump-table ref
function_bf8a:
BF8A: CE DC 00    LDU    #$DC00		; ROM
BF8D: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_bf90:
BF90: EC 1A       LDD    -$6,X
BF92: 83 00 C0    SUBD   #$00C0
BF95: 10 83 FE 00 CMPD   #$FE00
BF99: 2D 1A       BLT    $BFB5
BF9B: ED 1A       STD    -$6,X
BF9D: EC 1C       LDD    -$4,X
BF9F: C3 00 80    ADDD   #$0080
BFA2: 10 83 10 00 CMPD   #$1000
BFA6: 2C 0D       BGE    $BFB5
BFA8: ED 1C       STD    -$4,X
BFAA: BD 9C D2    JSR    function_9cd2
BFAD: 27 13       BEQ    $BFC2
BFAF: CE DC 00    LDU    #$DC00		; ROM
BFB2: 7E 8D E8    JMP    function_8de8
BFB5: C6 FF       LDB    #$FF
BFB7: E7 84       STB    ,X
BFB9: 0A 33       DEC    $33
BFBB: 0A 39       DEC    $39
BFBD: 0A 31       DEC    $31
BFBF: 0A 37       DEC    $37
BFC1: 39          RTS
BFC2: C6 04       LDB    #$04
BFC4: 7E B4 29    JMP    function_b429

; 1 jump-table ref
function_bfc7:
BFC7: EC 1A       LDD    -$6,X
BFC9: C3 00 C0    ADDD   #$00C0
BFCC: 10 83 14 00 CMPD   #$1400
BFD0: 2C E3       BGE    $BFB5
BFD2: ED 1A       STD    -$6,X
BFD4: EC 1C       LDD    -$4,X
BFD6: C3 00 80    ADDD   #$0080
BFD9: 10 83 10 00 CMPD   #$1000
BFDD: 2C D6       BGE    $BFB5
BFDF: ED 1C       STD    -$4,X
BFE1: 86 FF       LDA    #$FF
BFE3: A7 09       STA    $9,X
BFE5: BD 9C C1    JSR    function_9cc1
BFE8: 27 D8       BEQ    $BFC2
BFEA: CE DC 00    LDU    #$DC00		; ROM
BFED: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_bff0:
BFF0: EC 1A       LDD    -$6,X
BFF2: 83 00 C0    SUBD   #$00C0
BFF5: 10 83 FE 00 CMPD   #$FE00
BFF9: 2D BA       BLT    $BFB5
BFFB: ED 1A       STD    -$6,X
BFFD: EC 1C       LDD    -$4,X
BFFF: C3 00 80    ADDD   #$0080
C002: 10 83 10 00 CMPD   #$1000
C006: 2C AD       BGE    $BFB5
C008: ED 1C       STD    -$4,X
C00A: 86 FF       LDA    #$FF
C00C: A7 09       STA    $9,X
C00E: BD 9C D2    JSR    function_9cd2
C011: 27 AF       BEQ    $BFC2
C013: CE DC 00    LDU    #$DC00		; ROM
C016: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_c019:
C019: A6 07       LDA    $7,X
C01B: 84 02       ANDA   #$02
C01D: 26 0D       BNE    $C02C
C01F: CC 00 10    LDD    #$0010
C022: ED 16       STD    -$A,X
C024: CC FF F0    LDD    #$FFF0
C027: ED 18       STD    -$8,X
C029: 7E 8D C8    JMP    function_8dc8
C02C: CC FF F0    LDD    #$FFF0
C02F: ED 18       STD    -$8,X
C031: ED 16       STD    -$A,X
C033: 7E 8D C8    JMP    function_8dc8
C036: 6A 0A       DEC    $A,X
C038: 27 01       BEQ    $C03B
C03A: 39          RTS
C03B: 6D 16       TST    -$A,X
C03D: 2B 08       BMI    $C047
C03F: CE C0 4F    LDU    #jump_table_c04f
C042: A6 09       LDA    $9,X
C044: 48          ASLA
C045: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=12]

C047: CE C0 5B    LDU    #jump_table_c05b
C04A: A6 09       LDA    $9,X
C04C: 48          ASLA
C04D: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]


; 2 jump-table ref
function_c067:
C067: EC 1A       LDD    -$6,X
C069: C3 00 C0    ADDD   #$00C0
C06C: 10 83 12 00 CMPD   #$1200
C070: 2C 49       BGE    $C0BB
C072: ED 1A       STD    -$6,X
C074: EC 1C       LDD    -$4,X
C076: 83 00 80    SUBD   #$0080
C079: 10 83 FD 00 CMPD   #$FD00
C07D: 2D 3C       BLT    $C0BB
C07F: ED 1C       STD    -$4,X
C081: BD 9D 90    JSR    function_9d90
C084: 27 06       BEQ    $C08C
C086: CE DC 18    LDU    #$DC18		; ROM
C089: 7E 8D E8    JMP    function_8de8
C08C: C6 05       LDB    #$05
C08E: 7E B4 29    JMP    function_b429

; 4 jump-table ref
function_c091:
C091: EC 1A       LDD    -$6,X
C093: 83 00 C0    SUBD   #$00C0
C096: 10 83 FE 00 CMPD   #$FE00
C09A: 2D 1F       BLT    $C0BB
C09C: ED 1A       STD    -$6,X
C09E: EC 1C       LDD    -$4,X
C0A0: 83 00 80    SUBD   #$0080
C0A3: 10 83 FD 00 CMPD   #$FD00
C0A7: 2D 12       BLT    $C0BB
C0A9: ED 1C       STD    -$4,X
C0AB: BD 9D A1    JSR    function_9da1
C0AE: 27 06       BEQ    $C0B6

; 9 jump-table ref
function_c0b0:
C0B0: CE DC 18    LDU    #$DC18		; ROM
C0B3: 7E 8D E8    JMP    function_8de8
C0B6: C6 06       LDB    #$06
C0B8: 7E B4 29    JMP    function_b429
C0BB: C6 FF       LDB    #$FF
C0BD: E7 84       STB    ,X
C0BF: 0A 33       DEC    $33
C0C1: 0A 39       DEC    $39
C0C3: 0A 31       DEC    $31
C0C5: 0A 37       DEC    $37
C0C7: 39          RTS

; 3 jump-table ref
function_c0c8:
C0C8: 86 FF       LDA    #$FF
C0CA: A7 09       STA    $9,X
C0CC: CE DC 18    LDU    #$DC18		; ROM
C0CF: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c0d2:
C0D2: 7E 8D C8    JMP    function_8dc8

; 2 jump-table ref
function_c0d5:
C0D5: EE 10       LDU    -$10,X
C0D7: 6A 46       DEC    $6,U
C0D9: 26 2D       BNE    $C108
C0DB: A6 C4       LDA    ,U
C0DD: 2B 25       BMI    $C104
C0DF: A6 41       LDA    $1,U
C0E1: 84 01       ANDA   #$01
C0E3: AB 42       ADDA   $2,U
C0E5: 26 1D       BNE    $C104
C0E7: 96 33       LDA    $33
C0E9: 9B 32       ADDA   $32
C0EB: 81 05       CMPA   #$05
C0ED: 22 15       BHI    $C104
C0EF: EC 1A       LDD    -$6,X
C0F1: B3 04 0A    SUBD   $040A		; work RAM (shared with CPU1 $4400)
C0F4: 2A 05       BPL    $C0FB
C0F6: 53          COMB
C0F7: 43          COMA
C0F8: C3 00 01    ADDD   #$0001
C0FB: 10 83 06 00 CMPD   #$0600
C0FF: 24 03       BCC    $C104
C101: 7E 8D C8    JMP    function_8dc8
C104: 86 3E       LDA    #$3E
C106: A7 46       STA    $6,U
C108: A6 84       LDA    ,X
C10A: 8A 80       ORA    #$80
C10C: A7 84       STA    ,X
C10E: 86 80       LDA    #$80
C110: A7 01       STA    $1,X
C112: 0A 33       DEC    $33
C114: 0A 39       DEC    $39
C116: 39          RTS
C117: CE C2 5B    LDU    #jump_table_c25b
C11A: A6 09       LDA    $9,X
C11C: 48          ASLA
C11D: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=13]

; 2 jump-table ref
function_c11f:
C11F: EE 10       LDU    -$10,X
C121: A6 41       LDA    $1,U
C123: 8A 01       ORA    #$01
C125: A7 41       STA    $1,U
C127: 6A 0A       DEC    $A,X
C129: 27 01       BEQ    $C12C
C12B: 39          RTS
C12C: CE DC BC    LDU    #$DCBC		; ROM
C12F: 7E 8D E8    JMP    function_8de8

; 3 jump-table ref
function_c132:
C132: EE 10       LDU    -$10,X
C134: A6 41       LDA    $1,U
C136: 8A 01       ORA    #$01
C138: A7 41       STA    $1,U
C13A: 6A 0A       DEC    $A,X
C13C: 27 01       BEQ    $C13F
C13E: 39          RTS
C13F: A6 41       LDA    $1,U
C141: 84 04       ANDA   #$04
C143: 26 07       BNE    $C14C
C145: EC 1C       LDD    -$4,X
C147: C3 00 20    ADDD   #$0020
C14A: ED 1C       STD    -$4,X
C14C: CE DC BC    LDU    #$DCBC		; ROM
C14F: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c152:
C152: EE 10       LDU    -$10,X
C154: A6 41       LDA    $1,U
C156: 8A 01       ORA    #$01
C158: A7 41       STA    $1,U
C15A: 6A 0A       DEC    $A,X
C15C: 27 01       BEQ    $C15F
C15E: 39          RTS
C15F: A6 41       LDA    $1,U
C161: 84 04       ANDA   #$04
C163: 26 07       BNE    $C16C
C165: EC 1C       LDD    -$4,X
C167: C3 00 20    ADDD   #$0020
C16A: ED 1C       STD    -$4,X
C16C: 6F 05       CLR    $5,X
C16E: 6C 09       INC    $9,X
C170: 39          RTS

; 1 jump-table ref
function_c171:
C171: A6 41       LDA    $1,U
C173: 85 01       BITA   #$01
C175: 27 01       BEQ    $C178
C177: 39          RTS
C178: A6 42       LDA    $2,U
C17A: 27 01       BEQ    $C17D
C17C: 39          RTS
C17D: C6 FF       LDB    #$FF
C17F: E7 84       STB    ,X
C181: 0A 31       DEC    $31
C183: 0A 37       DEC    $37
C185: 0A 33       DEC    $33
C187: 0A 39       DEC    $39
C189: 39          RTS
C18A: CE C2 69    LDU    #jump_table_c269
C18D: A6 09       LDA    $9,X
C18F: 48          ASLA
C190: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]

; 2 jump-table ref
function_c192:
C192: EE 10       LDU    -$10,X
C194: A6 41       LDA    $1,U
C196: 8A 01       ORA    #$01
C198: A7 41       STA    $1,U
C19A: A6 42       LDA    $2,U
C19C: 81 04       CMPA   #$04
C19E: 27 01       BEQ    $C1A1
C1A0: 39          RTS
C1A1: 6A 0A       DEC    $A,X
C1A3: 27 01       BEQ    $C1A6
C1A5: 39          RTS
C1A6: A6 44       LDA    $4,U
C1A8: A7 05       STA    $5,X
C1AA: A6 41       LDA    $1,U
C1AC: 84 04       ANDA   #$04
C1AE: 26 07       BNE    $C1B7
C1B0: EC 1C       LDD    -$4,X
C1B2: 83 00 20    SUBD   #$0020
C1B5: ED 1C       STD    -$4,X
C1B7: CE DC E4    LDU    #$DCE4		; ROM
C1BA: 7E 8D E8    JMP    function_8de8

; 4 jump-table ref
function_c1bd:
C1BD: 6A 0A       DEC    $A,X
C1BF: 27 01       BEQ    $C1C2
C1C1: 39          RTS
C1C2: EE 10       LDU    -$10,X
C1C4: A6 41       LDA    $1,U
C1C6: 84 04       ANDA   #$04
C1C8: 26 07       BNE    $C1D1
C1CA: EC 1C       LDD    -$4,X
C1CC: 83 00 20    SUBD   #$0020
C1CF: ED 1C       STD    -$4,X
C1D1: CE DC E4    LDU    #$DCE4		; ROM
C1D4: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_c1d7:
C1D7: 6A 0A       DEC    $A,X
C1D9: 27 01       BEQ    $C1DC
C1DB: 39          RTS
C1DC: EE 10       LDU    -$10,X
C1DE: A6 41       LDA    $1,U
C1E0: 85 04       BITA   #$04
C1E2: 26 07       BNE    $C1EB
C1E4: EC 1C       LDD    -$4,X
C1E6: 83 00 20    SUBD   #$0020
C1E9: ED 1C       STD    -$4,X
C1EB: A6 0D       LDA    $D,X
C1ED: 85 01       BITA   #$01
C1EF: 26 16       BNE    $C207
C1F1: 84 30       ANDA   #$30
C1F3: 81 30       CMPA   #$30
C1F5: 27 10       BEQ    $C207
C1F7: A6 0D       LDA    $D,X
C1F9: 85 20       BITA   #$20
C1FB: 27 1C       BEQ    $C219
C1FD: 85 04       BITA   #$04
C1FF: 27 0C       BEQ    $C20D
C201: 86 5D       LDA    #$5D
C203: A7 01       STA    $1,X
C205: A7 07       STA    $7,X
C207: CE DC E4    LDU    #$DCE4		; ROM
C20A: 7E 8D E8    JMP    function_8de8
C20D: 86 5E       LDA    #$5E
C20F: A7 01       STA    $1,X
C211: A7 07       STA    $7,X
C213: CE DC E4    LDU    #$DCE4
C216: 7E 8D E8    JMP    function_8de8
C219: 85 08       BITA   #$08
C21B: 27 05       BEQ    $C222
C21D: C6 08       LDB    #$08
C21F: 7E B4 29    JMP    function_b429
C222: C6 3C       LDB    #$3C
C224: 7E B4 29    JMP    function_b429

; 2 jump-table ref
function_c227:
C227: 6A 0A       DEC    $A,X
C229: 27 01       BEQ    $C22C
C22B: 39          RTS
C22C: EE 10       LDU    -$10,X
C22E: A6 41       LDA    $1,U
C230: 84 FD       ANDA   #$FD
C232: A7 41       STA    $1,U
C234: 86 BF       LDA    #$BF
C236: A7 46       STA    $6,U
C238: CE DC E4    LDU    #$DCE4		; ROM
C23B: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_c23e:
C23E: 6A 0A       DEC    $A,X
C240: 27 01       BEQ    $C243
C242: 39          RTS
C243: A6 0D       LDA    $D,X
C245: 84 30       ANDA   #$30
C247: 81 30       CMPA   #$30
C249: 27 0B       BEQ    $C256
C24B: A6 0D       LDA    $D,X
C24D: 85 01       BITA   #$01
C24F: 26 05       BNE    $C256
C251: C6 38       LDB    #$38
C253: 7E B4 29    JMP    function_b429
C256: C6 04       LDB    #$04
C258: 7E B4 29    JMP    function_b429

; 1 jump-table ref
function_c275:
C275: 7E 8D C8    JMP    function_8dc8

; 1 jump-table ref
function_c278:
C278: 7E 8D C8    JMP    function_8dc8
C27B: 6A 0A       DEC    $A,X
C27D: 27 01       BEQ    $C280
C27F: 39          RTS
C280: CE C2 FA    LDU    #jump_table_c2fa
C283: A6 09       LDA    $9,X
C285: 48          ASLA
C286: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=8]

; 1 jump-table ref
function_c288:
C288: 86 40       LDA    #$40
C28A: A7 05       STA    $5,X

; 3 jump-table ref
function_c28c:
C28C: EC 1C       LDD    -$4,X
C28E: C3 00 20    ADDD   #$0020
C291: ED 1C       STD    -$4,X

; 3 jump-table ref
function_c293:
C293: CE DC BC    LDU    #$DCBC		; ROM
C296: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c299:
C299: C6 04       LDB    #$04
C29B: 7E B4 29    JMP    function_b429
C29E: 6A 0A       DEC    $A,X
C2A0: 27 01       BEQ    $C2A3
C2A2: 39          RTS
C2A3: CE C3 0A    LDU    #jump_table_c30a
C2A6: A6 09       LDA    $9,X
C2A8: 48          ASLA
C2A9: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=8]

; 1 jump-table ref
function_c2ab:
C2AB: 86 80       LDA    #$80
C2AD: A7 05       STA    $5,X

; 2 jump-table ref
function_c2af:
C2AF: EC 1C       LDD    -$4,X
C2B1: 83 00 20    SUBD   #$0020
C2B4: ED 1C       STD    -$4,X

; 3 jump-table ref
function_c2b6:
C2B6: CE DC DC    LDU    #$DCDC		; ROM
C2B9: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c2bc:
C2BC: EC 1C       LDD    -$4,X
C2BE: 83 00 20    SUBD   #$0020
C2C1: ED 1C       STD    -$4,X
C2C3: A6 0D       LDA    $D,X
C2C5: 85 20       BITA   #$20
C2C7: 27 1C       BEQ    $C2E5
C2C9: 85 04       BITA   #$04
C2CB: 27 0C       BEQ    $C2D9
C2CD: 86 AD       LDA    #$AD
C2CF: A7 01       STA    $1,X
C2D1: A7 07       STA    $7,X
C2D3: CE DC DC    LDU    #$DCDC		; ROM
C2D6: 7E 8D E8    JMP    function_8de8
C2D9: 86 AE       LDA    #$AE
C2DB: A7 01       STA    $1,X
C2DD: A7 07       STA    $7,X
C2DF: CE DC DC    LDU    #$DCDC
C2E2: 7E 8D E8    JMP    function_8de8
C2E5: C6 08       LDB    #$08
C2E7: 7E B4 29    JMP    function_b429

; 1 jump-table ref
function_c2ea:
C2EA: A6 0D       LDA    $D,X
C2EC: 84 01       ANDA   #$01
C2EE: 27 05       BEQ    $C2F5
C2F0: C6 04       LDB    #$04
C2F2: 7E B4 29    JMP    function_b429
C2F5: C6 38       LDB    #$38
C2F7: 7E B4 29    JMP    function_b429

; 6 jump-table ref
function_c31a:
C31A: 8D 3E       BSR    function_c35a
C31C: 6D 06       TST    $6,X
C31E: 26 12       BNE    $C332
C320: CE C3 54    LDU    #$C354		; ROM
C323: A6 84       LDA    ,X
C325: 84 FC       ANDA   #$FC
C327: 80 04       SUBA   #$04
C329: 44          LSRA
C32A: EC C6       LDD    A,U
C32C: CE 14 5E    LDU    #$145E		; work RAM (shared with CPU1 $4400)
C32F: BD 88 B2    JSR    function_88b2
C332: 6D 06       TST    $6,X
C334: 26 09       BNE    $C33F
C336: CE C3 48    LDU    #jump_table_c348
C339: 96 0F       LDA    dp_irqcount2_0f		; CPU2 IRQ/frame counter
C33B: 84 06       ANDA   #$06
C33D: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=6]
C33F: CE C3 50    LDU    #jump_table_c350
C342: 96 0F       LDA    dp_irqcount2_0f
C344: 84 02       ANDA   #$02
C346: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]


; called 10x  from $AE0B, $AE4B, $AE8B, $AED3, $AF23, $AF6B, $AFB3, $B003, ...
function_c35a:
C35A: A6 01       LDA    $1,X
C35C: 84 FC       ANDA   #$FC
C35E: 81 84       CMPA   #$84
C360: 27 1B       BEQ    $C37D
C362: 81 88       CMPA   #$88
C364: 27 23       BEQ    $C389
C366: 81 5C       CMPA   #$5C
C368: 27 01       BEQ    $C36B
C36A: 39          RTS
C36B: EE 10       LDU    -$10,X
C36D: AC 48       CMPX   $8,U
C36F: 27 01       BEQ    $C372
C371: 39          RTS
C372: A6 41       LDA    $1,U
C374: 84 FD       ANDA   #$FD
C376: A7 41       STA    $1,U
C378: 86 FF       LDA    #$FF
C37A: A7 46       STA    $6,U
C37C: 39          RTS
C37D: EE 10       LDU    -$10,X
C37F: A6 C4       LDA    ,U
C381: 81 68       CMPA   #$68
C383: 27 01       BEQ    $C386
C385: 39          RTS
C386: 6C 42       INC    $2,U
C388: 39          RTS
C389: EE 10       LDU    -$10,X
C38B: A6 C4       LDA    ,U
C38D: 81 69       CMPA   #$69
C38F: 27 01       BEQ    $C392
C391: 39          RTS
C392: 6C 42       INC    $2,U
C394: 39          RTS

; 3 jump-table ref
function_c395:
C395: 6D 06       TST    $6,X
C397: 26 0F       BNE    $C3A8
C399: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
C39D: 96 E6       LDA    $E6
C39F: C6 6A       LDB    #$6A
C3A1: E7 A6       STB    A,Y
C3A3: 4C          INCA
C3A4: 84 1F       ANDA   #$1F
C3A6: 97 E6       STA    $E6
C3A8: EC 1C       LDD    -$4,X
C3AA: C3 00 E0    ADDD   #$00E0
C3AD: ED 1C       STD    -$4,X
C3AF: CC 00 40    LDD    #$0040
C3B2: ED 18       STD    -$8,X
C3B4: E6 07       LDB    $7,X
C3B6: C4 02       ANDB   #$02
C3B8: 26 10       BNE    $C3CA
C3BA: CC 00 30    LDD    #$0030
C3BD: ED 16       STD    -$A,X
C3BF: E6 01       LDB    $1,X
C3C1: C4 03       ANDB   #$03
C3C3: CB 60       ADDB   #$60
C3C5: E7 07       STB    $7,X
C3C7: 7E 8D C8    JMP    function_8dc8
C3CA: CC FF D0    LDD    #$FFD0
C3CD: ED 16       STD    -$A,X
C3CF: E6 01       LDB    $1,X
C3D1: C4 03       ANDB   #$03
C3D3: CB 60       ADDB   #$60
C3D5: E7 07       STB    $7,X
C3D7: 7E 8D C8    JMP    function_8dc8

; 3 jump-table ref
function_c3da:
C3DA: 6D 06       TST    $6,X
C3DC: 26 0F       BNE    $C3ED
C3DE: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
C3E2: 96 E6       LDA    $E6
C3E4: C6 2E       LDB    #$2E
C3E6: E7 A6       STB    A,Y
C3E8: 4C          INCA
C3E9: 84 1F       ANDA   #$1F
C3EB: 97 E6       STA    $E6
C3ED: EC 1C       LDD    -$4,X
C3EF: C3 00 B0    ADDD   #$00B0
C3F2: ED 1C       STD    -$4,X
C3F4: CC 00 40    LDD    #$0040
C3F7: ED 18       STD    -$8,X
C3F9: E6 07       LDB    $7,X
C3FB: C4 02       ANDB   #$02
C3FD: 26 10       BNE    $C40F
C3FF: CC 00 30    LDD    #$0030
C402: ED 16       STD    -$A,X
C404: E6 01       LDB    $1,X
C406: C4 03       ANDB   #$03
C408: CB 64       ADDB   #$64
C40A: E7 07       STB    $7,X
C40C: 7E 8D C8    JMP    function_8dc8
C40F: CC FF D0    LDD    #$FFD0
C412: ED 16       STD    -$A,X
C414: E6 01       LDB    $1,X
C416: C4 03       ANDB   #$03
C418: CB 64       ADDB   #$64
C41A: E7 07       STB    $7,X
C41C: 7E 8D C8    JMP    function_8dc8

; 2 jump-table ref
function_c41f:
C41F: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
C423: 96 E6       LDA    $E6
C425: C6 6B       LDB    #$6B
C427: E7 A6       STB    A,Y
C429: 4C          INCA
C42A: 84 1F       ANDA   #$1F
C42C: 97 E6       STA    $E6
C42E: E6 01       LDB    $1,X
C430: C4 03       ANDB   #$03
C432: CB 68       ADDB   #$68
C434: E7 07       STB    $7,X
C436: 7E 8D C8    JMP    function_8dc8
C439: CE C4 41    LDU    #jump_table_c441
C43C: A6 09       LDA    $9,X
C43E: 48          ASLA
C43F: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=11]


; 1 jump-table ref
function_c457:
C457: EC 16       LDD    -$A,X
C459: 27 16       BEQ    $C471
C45B: BD 94 97    JSR    function_9497
C45E: 2A 01       BPL    $C461
C460: 39          RTS
C461: EC 16       LDD    -$A,X
C463: 2B 07       BMI    $C46C
C465: 83 00 04    SUBD   #$0004
C468: ED 16       STD    -$A,X
C46A: 20 05       BRA    $C471
C46C: C3 00 04    ADDD   #$0004
C46F: ED 16       STD    -$A,X
C471: BD 95 6D    JSR    function_956d
C474: 6A 0A       DEC    $A,X
C476: 27 01       BEQ    $C479
C478: 39          RTS
C479: CE DC 30    LDU    #$DC30		; ROM
C47C: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c47f:
C47F: EC 16       LDD    -$A,X
C481: 27 16       BEQ    $C499
C483: BD 94 97    JSR    function_9497
C486: 2A 01       BPL    $C489
C488: 39          RTS
C489: EC 16       LDD    -$A,X
C48B: 2B 07       BMI    $C494
C48D: 83 00 04    SUBD   #$0004
C490: ED 16       STD    -$A,X
C492: 20 05       BRA    $C499
C494: C3 00 04    ADDD   #$0004
C497: ED 16       STD    -$A,X
C499: BD 95 6D    JSR    function_956d
C49C: 26 01       BNE    $C49F
C49E: 39          RTS
C49F: 6D 06       TST    $6,X
C4A1: 26 06       BNE    $C4A9
C4A3: CE DC 30    LDU    #$DC30		; ROM
C4A6: 7E 8D E8    JMP    function_8de8
C4A9: C6 10       LDB    #$10
C4AB: 7E B4 29    JMP    function_b429

; 7 jump-table ref
function_c4ae:
C4AE: 6A 0A       DEC    $A,X
C4B0: 27 01       BEQ    $C4B3
C4B2: 39          RTS
C4B3: CE DC 30    LDU    #$DC30		; ROM
C4B6: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c4b9:
C4B9: 6A 0A       DEC    $A,X
C4BB: 27 01       BEQ    $C4BE
C4BD: 39          RTS
C4BE: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
C4C2: 96 E4       LDA    $E4
C4C4: C6 03       LDB    #$03
C4C6: E7 A6       STB    A,Y
C4C8: 4C          INCA
C4C9: 84 1F       ANDA   #$1F
C4CB: 97 E4       STA    $E4
C4CD: CE DC 30    LDU    #$DC30		; ROM
C4D0: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c4d3:
C4D3: 6A 0A       DEC    $A,X
C4D5: 27 01       BEQ    $C4D8
C4D7: 39          RTS
C4D8: 86 FF       LDA    #$FF
C4DA: A7 84       STA    ,X
C4DC: 0A 31       DEC    $31
C4DE: 0A 37       DEC    $37
C4E0: 0A 33       DEC    $33
C4E2: 0A 39       DEC    $39
C4E4: 39          RTS
C4E5: CE C4 ED    LDU    #jump_table_c4ed
C4E8: A6 09       LDA    $9,X
C4EA: 48          ASLA
C4EB: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=11]


; 1 jump-table ref
function_c503:
C503: BD 94 97    JSR    function_9497
C506: 2A 01       BPL    $C509
C508: 39          RTS
C509: BD 95 6D    JSR    function_956d
C50C: 6A 0A       DEC    $A,X
C50E: 27 01       BEQ    $C511
C510: 39          RTS
C511: CE DC 5C    LDU    #$DC5C		; ROM
C514: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c517:
C517: BD 94 97    JSR    function_9497
C51A: 2A 01       BPL    $C51D
C51C: 39          RTS
C51D: BD 95 6D    JSR    function_956d
C520: 26 01       BNE    $C523
C522: 39          RTS
C523: 6D 06       TST    $6,X
C525: 26 06       BNE    $C52D
C527: CE DC 5C    LDU    #$DC5C		; ROM
C52A: 7E 8D E8    JMP    function_8de8
C52D: C6 10       LDB    #$10
C52F: 7E B4 29    JMP    function_b429

; 7 jump-table ref
function_c532:
C532: 6A 0A       DEC    $A,X
C534: 27 01       BEQ    $C537
C536: 39          RTS
C537: CE DC 5C    LDU    #$DC5C		; ROM
C53A: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c53d:
C53D: 6A 0A       DEC    $A,X
C53F: 27 01       BEQ    $C542
C541: 39          RTS
C542: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
C546: 96 E4       LDA    $E4
C548: C6 03       LDB    #$03
C54A: E7 A6       STB    A,Y
C54C: 4C          INCA
C54D: 84 1F       ANDA   #$1F
C54F: 97 E4       STA    $E4
C551: CE DC 5C    LDU    #$DC5C		; ROM
C554: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c557:
C557: 6A 0A       DEC    $A,X
C559: 27 01       BEQ    $C55C
C55B: 39          RTS
C55C: 86 FF       LDA    #$FF
C55E: A7 84       STA    ,X
C560: 0A 31       DEC    $31
C562: 0A 37       DEC    $37
C564: 0A 33       DEC    $33
C566: 0A 39       DEC    $39
C568: 39          RTS
C569: CE C5 71    LDU    #jump_table_c571
C56C: A6 09       LDA    $9,X
C56E: 48          ASLA
C56F: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=13]


; 2 jump-table ref
function_c58b:
C58B: 6A 0A       DEC    $A,X
C58D: 27 01       BEQ    $C590
C58F: 39          RTS
C590: CE DC 88    LDU    #$DC88		; ROM
C593: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c596:
C596: BD 95 6D    JSR    function_956d
C599: 26 01       BNE    $C59C
C59B: 39          RTS
C59C: 6A 0A       DEC    $A,X
C59E: 27 01       BEQ    $C5A1
C5A0: 39          RTS
C5A1: CE DC 88    LDU    #$DC88		; ROM
C5A4: 7E 8D E8    JMP    function_8de8

; 8 jump-table ref
function_c5a7:
C5A7: 6A 0A       DEC    $A,X
C5A9: 27 01       BEQ    $C5AC
C5AB: 39          RTS
C5AC: CE DC 88    LDU    #$DC88		; ROM
C5AF: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c5b2:
C5B2: 6A 0A       DEC    $A,X
C5B4: 27 01       BEQ    $C5B7
C5B6: 39          RTS
C5B7: 6D 06       TST    $6,X
C5B9: 26 15       BNE    $C5D0
C5BB: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
C5BF: 96 E4       LDA    $E4
C5C1: C6 03       LDB    #$03
C5C3: E7 A6       STB    A,Y
C5C5: 4C          INCA
C5C6: 84 1F       ANDA   #$1F
C5C8: 97 E4       STA    $E4
C5CA: CE DC 88    LDU    #$DC88		; ROM
C5CD: 7E 8D E8    JMP    function_8de8
C5D0: C6 10       LDB    #$10
C5D2: 7E B4 29    JMP    function_b429

; 1 jump-table ref
function_c5d5:
C5D5: 6A 0A       DEC    $A,X
C5D7: 27 01       BEQ    $C5DA
C5D9: 39          RTS
C5DA: 86 FF       LDA    #$FF
C5DC: A7 84       STA    ,X
C5DE: 0A 31       DEC    $31
C5E0: 0A 37       DEC    $37
C5E2: 0A 33       DEC    $33
C5E4: 0A 39       DEC    $39
C5E6: 39          RTS

; 2 jump-table ref
function_c5e7:
C5E7: 7E 8D C8    JMP    function_8dc8
C5EA: 6A 0A       DEC    $A,X
C5EC: 27 01       BEQ    $C5EF
C5EE: 39          RTS
C5EF: A6 09       LDA    $9,X
C5F1: 81 04       CMPA   #$04
C5F3: 27 06       BEQ    $C5FB
C5F5: CE DE 7C    LDU    #$DE7C		; ROM
C5F8: 7E 8D E8    JMP    function_8de8
C5FB: C6 94       LDB    #$94
C5FD: 7E B4 29    JMP    function_b429

; 3 jump-table ref
function_c600:
C600: BD C3 5A    JSR    function_c35a
C603: CE C6 0C    LDU    #jump_table_c60c
C606: 96 0F       LDA    dp_irqcount2_0f		; CPU2 IRQ/frame counter
C608: 84 02       ANDA   #$02
C60A: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]


; 1 jump-table ref
function_c610:
C610: EC 1C       LDD    -$4,X
C612: C3 00 E0    ADDD   #$00E0
C615: ED 1C       STD    -$4,X
C617: CC 00 40    LDD    #$0040
C61A: ED 18       STD    -$8,X
C61C: A6 0D       LDA    $D,X
C61E: 84 04       ANDA   #$04
C620: 26 08       BNE    $C62A
C622: CC 00 30    LDD    #$0030
C625: ED 16       STD    -$A,X
C627: 7E 8D C8    JMP    function_8dc8
C62A: CC FF D0    LDD    #$FFD0
C62D: ED 16       STD    -$A,X
C62F: 7E 8D C8    JMP    function_8dc8

; 1 jump-table ref
function_c632:
C632: EC 1C       LDD    -$4,X
C634: C3 00 B0    ADDD   #$00B0
C637: ED 1C       STD    -$4,X
C639: CC 00 40    LDD    #$0040
C63C: ED 18       STD    -$8,X
C63E: A6 0D       LDA    $D,X
C640: 84 04       ANDA   #$04
C642: 26 08       BNE    $C64C
C644: CC 00 30    LDD    #$0030
C647: ED 16       STD    -$A,X
C649: 7E 8D C8    JMP    function_8dc8
C64C: CC FF D0    LDD    #$FFD0
C64F: ED 16       STD    -$A,X
C651: 7E 8D C8    JMP    function_8dc8
C654: CE C6 5C    LDU    #jump_table_c65c
C657: A6 09       LDA    $9,X
C659: 48          ASLA
C65A: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]

; 1 jump-table ref
function_c662:
C662: BD 94 97    JSR    function_9497
C665: 2A 01       BPL    $C668
C667: 39          RTS
C668: BD 95 6D    JSR    function_956d
C66B: 6A 0A       DEC    $A,X
C66D: 27 01       BEQ    $C670
C66F: 39          RTS
C670: CE DC 30    LDU    #$DC30		; ROM
C673: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c676:
C676: BD 94 97    JSR    function_9497
C679: 2A 01       BPL    $C67C
C67B: 39          RTS
C67C: BD 95 6D    JSR    function_956d
C67F: 26 01       BNE    $C682
C681: 39          RTS
C682: CE DC 30    LDU    #$DC30		; ROM
C685: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c688:
C688: 6A 0A       DEC    $A,X
C68A: 27 01       BEQ    $C68D
C68C: 39          RTS
C68D: C6 10       LDB    #$10
C68F: 7E B4 29    JMP    function_b429
C692: CE C6 9A    LDU    #jump_table_c69a
C695: A6 09       LDA    $9,X
C697: 48          ASLA
C698: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]


; 1 jump-table ref
function_c6a0:
C6A0: BD 94 97    JSR    function_9497
C6A3: 2A 01       BPL    $C6A6
C6A5: 39          RTS
C6A6: BD 95 6D    JSR    function_956d
C6A9: 6A 0A       DEC    $A,X
C6AB: 27 01       BEQ    $C6AE
C6AD: 39          RTS
C6AE: CE DC 5C    LDU    #$DC5C		; ROM
C6B1: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c6b4:
C6B4: BD 94 97    JSR    function_9497
C6B7: 2A 01       BPL    $C6BA
C6B9: 39          RTS
C6BA: BD 95 6D    JSR    function_956d
C6BD: 26 01       BNE    $C6C0
C6BF: 39          RTS
C6C0: CE DC 5C    LDU    #$DC5C		; ROM
C6C3: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c6c6:
C6C6: 6A 0A       DEC    $A,X
C6C8: 27 01       BEQ    $C6CB
C6CA: 39          RTS
C6CB: C6 10       LDB    #$10
C6CD: 7E B4 29    JMP    function_b429
C6D0: A6 07       LDA    $7,X
C6D2: A7 01       STA    $1,X
C6D4: 39          RTS
C6D5: CE C7 3E    LDU    #jump_table_c73e
C6D8: A6 07       LDA    $7,X
C6DA: 84 FC       ANDA   #$FC
C6DC: 44          LSRA
C6DD: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=39]

; 1 jump-table ref
function_c6df:
C6DF: 10 AE 10    LDY    -$10,X
C6E2: A6 21       LDA    $1,Y
C6E4: 84 01       ANDA   #$01
C6E6: AB 22       ADDA   $2,Y
C6E8: 26 25       BNE    $C70F
C6EA: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
C6ED: EC 1A       LDD    -$6,X
C6EF: A3 5A       SUBD   -$6,U
C6F1: 2A 05       BPL    $C6F8
C6F3: 53          COMB
C6F4: 43          COMA
C6F5: C3 00 01    ADDD   #$0001
C6F8: 10 83 05 00 CMPD   #$0500
C6FC: 24 11       BCC    $C70F
C6FE: 6A 26       DEC    $6,Y
C700: 26 0D       BNE    $C70F
C702: A6 21       LDA    $1,Y
C704: 84 FD       ANDA   #$FD
C706: A7 21       STA    $1,Y
C708: 86 80       LDA    #$80
C70A: A7 26       STA    $6,Y
C70C: 7E 8D C8    JMP    function_8dc8
C70F: A6 84       LDA    ,X
C711: 8A 80       ORA    #$80
C713: A7 84       STA    ,X
C715: 0A 33       DEC    $33
C717: 0A 39       DEC    $39
C719: 39          RTS

; 1 jump-table ref
function_c71a:
C71A: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
C71D: EC 1A       LDD    -$6,X
C71F: A3 5A       SUBD   -$6,U
C721: 2A 05       BPL    $C728
C723: 53          COMB
C724: 43          COMA
C725: C3 00 01    ADDD   #$0001
C728: 10 83 05 00 CMPD   #$0500
C72C: 24 0B       BCC    $C739
C72E: A6 84       LDA    ,X
C730: 8A 80       ORA    #$80
C732: A7 84       STA    ,X
C734: 0A 33       DEC    $33
C736: 0A 39       DEC    $39
C738: 39          RTS
C739: E6 07       LDB    $7,X
C73B: 7E B4 29    JMP    function_b429


; 3 jump-table ref
function_c78c:
C78C: 39          RTS


; 4 jump-table ref
function_c78d:
C78D: 7E 8D C8    JMP    function_8dc8
C790: CE C7 98    LDU    #jump_table_c798
C793: A6 09       LDA    $9,X
C795: 48          ASLA
C796: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=10]


; 5 jump-table ref
function_c7ac:
C7AC: 6A 0A       DEC    $A,X
C7AE: 27 01       BEQ    $C7B1
C7B0: 39          RTS
C7B1: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
C7B5: 96 E4       LDA    $E4
C7B7: C6 05       LDB    #$05
C7B9: E7 A6       STB    A,Y
C7BB: 4C          INCA
C7BC: 84 1F       ANDA   #$1F
C7BE: 97 E4       STA    $E4
C7C0: CE DD 40    LDU    #$DD40		; ROM
C7C3: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c7c6:
C7C6: 6A 0A       DEC    $A,X
C7C8: 27 01       BEQ    $C7CB
C7CA: 39          RTS
C7CB: E6 01       LDB    $1,X
C7CD: C5 02       BITB   #$02
C7CF: 26 1E       BNE    $C7EF
C7D1: 86 68       LDA    #$68
C7D3: BD D5 17    JSR    function_d517
C7D6: CC 7B 5C    LDD    #$7B5C
C7D9: ED 4E       STD    $E,U
C7DB: EC 1A       LDD    -$6,X
C7DD: C3 FE 90    ADDD   #$FE90
C7E0: ED 4A       STD    $A,U
C7E2: EC 1C       LDD    -$4,X
C7E4: C3 03 30    ADDD   #$0330
C7E7: ED 4C       STD    $C,U
C7E9: CE DD 40    LDU    #$DD40		; ROM
C7EC: 7E 8D E8    JMP    function_8de8
C7EF: 86 68       LDA    #$68
C7F1: BD D5 17    JSR    function_d517
C7F4: CC 7B 60    LDD    #$7B60
C7F7: ED 4E       STD    $E,U
C7F9: EC 1A       LDD    -$6,X
C7FB: C3 00 80    ADDD   #$0080
C7FE: ED 4A       STD    $A,U
C800: EC 1C       LDD    -$4,X
C802: C3 03 30    ADDD   #$0330
C805: ED 4C       STD    $C,U
C807: CE DD 40    LDU    #$DD40
C80A: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c80d:
C80D: EE 10       LDU    -$10,X
C80F: 6A 0A       DEC    $A,X
C811: 27 01       BEQ    $C814
C813: 39          RTS
C814: E6 01       LDB    $1,X
C816: C5 02       BITB   #$02
C818: 26 19       BNE    $C833
C81A: CC 7B 64    LDD    #$7B64
C81D: ED 4E       STD    $E,U
C81F: EC 1A       LDD    -$6,X
C821: C3 FF 30    ADDD   #$FF30
C824: ED 4A       STD    $A,U
C826: EC 1C       LDD    -$4,X
C828: C3 03 50    ADDD   #$0350
C82B: ED 4C       STD    $C,U
C82D: CE DD 40    LDU    #$DD40		; ROM
C830: 7E 8D E8    JMP    function_8de8
C833: CC 7B 68    LDD    #$7B68
C836: ED 4E       STD    $E,U
C838: EC 1A       LDD    -$6,X
C83A: C3 FF E0    ADDD   #$FFE0
C83D: ED 4A       STD    $A,U
C83F: EC 1C       LDD    -$4,X
C841: C3 03 50    ADDD   #$0350
C844: ED 4C       STD    $C,U
C846: CE DD 40    LDU    #$DD40
C849: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c84c:
C84C: EE 10       LDU    -$10,X
C84E: 6A 0A       DEC    $A,X
C850: 27 01       BEQ    $C853
C852: 39          RTS
C853: E6 01       LDB    $1,X
C855: C5 02       BITB   #$02
C857: 26 19       BNE    $C872
C859: CC 7B 6C    LDD    #$7B6C
C85C: ED 4E       STD    $E,U
C85E: EC 1A       LDD    -$6,X
C860: C3 FE 10    ADDD   #$FE10
C863: ED 4A       STD    $A,U
C865: EC 1C       LDD    -$4,X
C867: C3 03 20    ADDD   #$0320
C86A: ED 4C       STD    $C,U
C86C: CE DD 40    LDU    #$DD40		; ROM
C86F: 7E 8D E8    JMP    function_8de8
C872: CC 7B 70    LDD    #$7B70
C875: ED 4E       STD    $E,U
C877: EC 1A       LDD    -$6,X
C879: C3 01 00    ADDD   #$0100
C87C: ED 4A       STD    $A,U
C87E: EC 1C       LDD    -$4,X
C880: C3 03 20    ADDD   #$0320
C883: ED 4C       STD    $C,U
C885: CE DD 40    LDU    #$DD40
C888: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c88b:
C88B: 6A 0A       DEC    $A,X
C88D: 27 01       BEQ    $C890
C88F: 39          RTS
C890: EE 10       LDU    -$10,X
C892: 86 6A       LDA    #$6A
C894: A7 C4       STA    ,U
C896: CC FF D0    LDD    #$FFD0
C899: ED 48       STD    $8,U
C89B: A6 44       LDA    $4,U
C89D: 8B 40       ADDA   #$40
C89F: A7 44       STA    $4,U
C8A1: E6 01       LDB    $1,X
C8A3: C5 02       BITB   #$02
C8A5: 26 10       BNE    $C8B7
C8A7: CC 7B 9C    LDD    #$7B9C
C8AA: ED 4E       STD    $E,U
C8AC: CC 00 08    LDD    #$0008
C8AF: ED 46       STD    $6,U
C8B1: CE DD 40    LDU    #$DD40		; ROM
C8B4: 7E 8D E8    JMP    function_8de8
C8B7: CC 7B A0    LDD    #$7BA0
C8BA: ED 4E       STD    $E,U
C8BC: CC FF F8    LDD    #$FFF8
C8BF: ED 46       STD    $6,U
C8C1: CE DD 40    LDU    #$DD40
C8C4: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c8c7:
C8C7: 6A 0A       DEC    $A,X
C8C9: 27 01       BEQ    $C8CC
C8CB: 39          RTS
C8CC: A6 0D       LDA    $D,X
C8CE: 85 01       BITA   #$01
C8D0: 26 14       BNE    $C8E6
C8D2: 85 20       BITA   #$20
C8D4: 26 15       BNE    $C8EB
C8D6: A6 0C       LDA    $C,X
C8D8: 84 04       ANDA   #$04
C8DA: 26 14       BNE    $C8F0
C8DC: A6 02       LDA    $2,X
C8DE: 2A 06       BPL    $C8E6
C8E0: 96 41       LDA    $41
C8E2: 81 10       CMPA   #$10
C8E4: 25 0F       BCS    $C8F5
C8E6: C6 04       LDB    #$04
C8E8: 7E B4 29    JMP    function_b429
C8EB: C6 38       LDB    #$38
C8ED: 7E B4 29    JMP    function_b429
C8F0: C6 3C       LDB    #$3C
C8F2: 7E B4 29    JMP    function_b429
C8F5: C6 84       LDB    #$84
C8F7: 7E B4 29    JMP    function_b429
C8FA: CE C9 02    LDU    #jump_table_c902
C8FD: A6 09       LDA    $9,X
C8FF: 48          ASLA
C900: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=10]


; 3 jump-table ref
function_c916:
C916: 6A 0A       DEC    $A,X
C918: 27 01       BEQ    $C91B
C91A: 39          RTS
C91B: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
C91F: 96 E4       LDA    $E4
C921: C6 05       LDB    #$05
C923: E7 A6       STB    A,Y
C925: 4C          INCA
C926: 84 1F       ANDA   #$1F
C928: 97 E4       STA    $E4
C92A: CE DD 68    LDU    #$DD68		; ROM
C92D: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c930:
C930: 6A 0A       DEC    $A,X
C932: 27 01       BEQ    $C935
C934: 39          RTS
C935: E6 01       LDB    $1,X
C937: C5 02       BITB   #$02
C939: 26 1E       BNE    $C959
C93B: 86 69       LDA    #$69
C93D: BD D5 17    JSR    function_d517
C940: CC 7B 74    LDD    #$7B74
C943: ED 4E       STD    $E,U
C945: EC 1A       LDD    -$6,X
C947: C3 00 10    ADDD   #$0010
C94A: ED 4A       STD    $A,U
C94C: EC 1C       LDD    -$4,X
C94E: C3 01 60    ADDD   #$0160
C951: ED 4C       STD    $C,U
C953: CE DD 68    LDU    #$DD68		; ROM
C956: 7E 8D E8    JMP    function_8de8
C959: 86 69       LDA    #$69
C95B: BD D5 17    JSR    function_d517
C95E: CC 7B 78    LDD    #$7B78
C961: ED 4E       STD    $E,U
C963: EC 1A       LDD    -$6,X
C965: C3 FF 00    ADDD   #$FF00
C968: ED 4A       STD    $A,U
C96A: EC 1C       LDD    -$4,X
C96C: C3 01 60    ADDD   #$0160
C96F: ED 4C       STD    $C,U
C971: CE DD 68    LDU    #$DD68
C974: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c977:
C977: EE 10       LDU    -$10,X
C979: 6A 0A       DEC    $A,X
C97B: 27 01       BEQ    $C97E
C97D: 39          RTS
C97E: E6 01       LDB    $1,X
C980: C5 02       BITB   #$02
C982: 26 19       BNE    $C99D
C984: CC 7B 7C    LDD    #$7B7C
C987: ED 4E       STD    $E,U
C989: EC 1A       LDD    -$6,X
C98B: C3 FD D0    ADDD   #$FDD0
C98E: ED 4A       STD    $A,U
C990: EC 1C       LDD    -$4,X
C992: C3 02 20    ADDD   #$0220
C995: ED 4C       STD    $C,U
C997: CE DD 68    LDU    #$DD68		; ROM
C99A: 7E 8D E8    JMP    function_8de8
C99D: CC 7B 80    LDD    #$7B80
C9A0: ED 4E       STD    $E,U
C9A2: EC 1A       LDD    -$6,X
C9A4: C3 01 40    ADDD   #$0140
C9A7: ED 4A       STD    $A,U
C9A9: EC 1C       LDD    -$4,X
C9AB: C3 02 20    ADDD   #$0220
C9AE: ED 4C       STD    $C,U
C9B0: CE DD 68    LDU    #$DD68
C9B3: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c9b6:
C9B6: EE 10       LDU    -$10,X
C9B8: 6A 0A       DEC    $A,X
C9BA: 27 01       BEQ    $C9BD
C9BC: 39          RTS
C9BD: E6 01       LDB    $1,X
C9BF: C5 02       BITB   #$02
C9C1: 26 19       BNE    $C9DC
C9C3: CC 7B 84    LDD    #$7B84
C9C6: ED 4E       STD    $E,U
C9C8: EC 1A       LDD    -$6,X
C9CA: C3 FD E0    ADDD   #$FDE0
C9CD: ED 4A       STD    $A,U
C9CF: EC 1C       LDD    -$4,X
C9D1: C3 02 D0    ADDD   #$02D0
C9D4: ED 4C       STD    $C,U
C9D6: CE DD 68    LDU    #$DD68		; ROM
C9D9: 7E 8D E8    JMP    function_8de8
C9DC: CC 7B 88    LDD    #$7B88
C9DF: ED 4E       STD    $E,U
C9E1: EC 1A       LDD    -$6,X
C9E3: C3 01 30    ADDD   #$0130
C9E6: ED 4A       STD    $A,U
C9E8: EC 1C       LDD    -$4,X
C9EA: C3 02 B0    ADDD   #$02B0
C9ED: ED 4C       STD    $C,U
C9EF: CE DD 68    LDU    #$DD68
C9F2: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_c9f5:
C9F5: EE 10       LDU    -$10,X
C9F7: 6A 0A       DEC    $A,X
C9F9: 27 01       BEQ    $C9FC
C9FB: 39          RTS
C9FC: E6 01       LDB    $1,X
C9FE: C5 02       BITB   #$02
CA00: 26 19       BNE    $CA1B
CA02: CC 7B 8C    LDD    #$7B8C
CA05: ED 4E       STD    $E,U
CA07: EC 1A       LDD    -$6,X
CA09: C3 FE 40    ADDD   #$FE40
CA0C: ED 4A       STD    $A,U
CA0E: EC 1C       LDD    -$4,X
CA10: C3 03 70    ADDD   #$0370
CA13: ED 4C       STD    $C,U
CA15: CE DD 68    LDU    #$DD68		; ROM
CA18: 7E 8D E8    JMP    function_8de8
CA1B: CC 7B 90    LDD    #$7B90
CA1E: ED 4E       STD    $E,U
CA20: EC 1A       LDD    -$6,X
CA22: C3 01 30    ADDD   #$0130
CA25: ED 4A       STD    $A,U
CA27: EC 1C       LDD    -$4,X
CA29: C3 03 70    ADDD   #$0370
CA2C: ED 4C       STD    $C,U
CA2E: CE DD 68    LDU    #$DD68
CA31: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_ca34:
CA34: EE 10       LDU    -$10,X
CA36: 6A 0A       DEC    $A,X
CA38: 27 01       BEQ    $CA3B
CA3A: 39          RTS
CA3B: E6 01       LDB    $1,X
CA3D: C5 02       BITB   #$02
CA3F: 26 19       BNE    $CA5A
CA41: CC 7B 94    LDD    #$7B94
CA44: ED 4E       STD    $E,U
CA46: EC 1A       LDD    -$6,X
CA48: C3 FF 00    ADDD   #$FF00
CA4B: ED 4A       STD    $A,U
CA4D: EC 1C       LDD    -$4,X
CA4F: C3 03 70    ADDD   #$0370
CA52: ED 4C       STD    $C,U
CA54: CE DD 68    LDU    #$DD68		; ROM
CA57: 7E 8D E8    JMP    function_8de8
CA5A: CC 7B 98    LDD    #$7B98
CA5D: ED 4E       STD    $E,U
CA5F: EC 1A       LDD    -$6,X
CA61: C3 00 10    ADDD   #$0010
CA64: ED 4A       STD    $A,U
CA66: EC 1C       LDD    -$4,X
CA68: C3 03 70    ADDD   #$0370
CA6B: ED 4C       STD    $C,U
CA6D: CE DD 68    LDU    #$DD68
CA70: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_ca73:
CA73: 6A 0A       DEC    $A,X
CA75: 27 01       BEQ    $CA78
CA77: 39          RTS
CA78: EE 10       LDU    -$10,X
CA7A: 86 6A       LDA    #$6A
CA7C: A7 C4       STA    ,U
CA7E: CC 00 30    LDD    #$0030
CA81: ED 48       STD    $8,U
CA83: E6 01       LDB    $1,X
CA85: C5 02       BITB   #$02
CA87: 26 10       BNE    $CA99
CA89: CC 7B 9C    LDD    #$7B9C
CA8C: ED 4E       STD    $E,U
CA8E: CC 00 28    LDD    #$0028
CA91: ED 46       STD    $6,U
CA93: CE DD 68    LDU    #$DD68		; ROM
CA96: 7E 8D E8    JMP    function_8de8
CA99: CC 7B A0    LDD    #$7BA0
CA9C: ED 4E       STD    $E,U
CA9E: CC FF D8    LDD    #$FFD8
CAA1: ED 46       STD    $6,U
CAA3: CE DD 68    LDU    #$DD68
CAA6: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_caa9:
CAA9: 6A 0A       DEC    $A,X
CAAB: 27 01       BEQ    $CAAE
CAAD: 39          RTS
CAAE: A6 0D       LDA    $D,X
CAB0: 85 01       BITA   #$01
CAB2: 27 09       BEQ    $CABD
CAB4: A6 02       LDA    $2,X
CAB6: 2A 05       BPL    $CABD
CAB8: C6 88       LDB    #$88
CABA: 7E B4 29    JMP    function_b429
CABD: C6 04       LDB    #$04
CABF: 7E B4 29    JMP    function_b429

; 1 jump-table ref
function_cac2:
CAC2: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
CAC5: EC 1A       LDD    -$6,X
CAC7: A3 5A       SUBD   -$6,U
CAC9: 2A 05       BPL    $CAD0
CACB: 53          COMB
CACC: 43          COMA
CACD: C3 00 01    ADDD   #$0001
CAD0: 10 83 05 00 CMPD   #$0500
CAD4: 24 19       BCC    $CAEF
CAD6: EC 1C       LDD    -$4,X
CAD8: A3 5C       SUBD   -$4,U
CADA: 2A 05       BPL    $CAE1
CADC: 53          COMB
CADD: 43          COMA
CADE: C3 00 01    ADDD   #$0001
CAE1: 10 83 04 00 CMPD   #$0400
CAE5: 24 08       BCC    $CAEF
CAE7: CC 00 00    LDD    #$0000
CAEA: ED 18       STD    -$8,X
CAEC: 7E 8D C8    JMP    function_8dc8
CAEF: A6 84       LDA    ,X
CAF1: 8A 80       ORA    #$80
CAF3: A7 84       STA    ,X
CAF5: 86 80       LDA    #$80
CAF7: A7 01       STA    $1,X
CAF9: 0A 33       DEC    $33
CAFB: 0A 39       DEC    $39
CAFD: 39          RTS

; 2 jump-table ref
function_cafe:
CAFE: 7E 8D C8    JMP    function_8dc8
CB01: CE CB 09    LDU    #jump_table_cb09
CB04: A6 09       LDA    $9,X
CB06: 48          ASLA
CB07: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=16]


; 13 jump-table ref
function_cb29:
CB29: 6A 0A       DEC    $A,X
CB2B: 27 01       BEQ    $CB2E
CB2D: 39          RTS
CB2E: CE DD B8    LDU    #$DDB8		; ROM
CB31: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_cb34:
CB34: 6A 0A       DEC    $A,X
CB36: 27 01       BEQ    $CB39
CB38: 39          RTS
CB39: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
CB3C: CC 00 FF    LDD    #$00FF
CB3F: BD 93 02    JSR    function_9302
CB42: C5 02       BITB   #$02
CB44: 27 06       BEQ    $CB4C
CB46: C4 C0       ANDB   #$C0
CB48: E7 05       STB    $5,X
CB4A: 6C 09       INC    $9,X
CB4C: CE DD B8    LDU    #$DDB8		; ROM
CB4F: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_cb52:
CB52: BD 95 6D    JSR    function_956d
CB55: 26 01       BNE    $CB58
CB57: 39          RTS
CB58: CE DD B8    LDU    #$DDB8		; ROM
CB5B: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_cb5e:
CB5E: 6A 0A       DEC    $A,X
CB60: 27 01       BEQ    $CB63
CB62: 39          RTS
CB63: A6 84       LDA    ,X
CB65: 84 03       ANDA   #$03
CB67: 26 10       BNE    $CB79
CB69: A6 0D       LDA    $D,X
CB6B: 84 01       ANDA   #$01
CB6D: 26 05       BNE    $CB74
CB6F: C6 70       LDB    #$70
CB71: 7E B4 29    JMP    function_b429
CB74: C6 04       LDB    #$04
CB76: 7E B4 29    JMP    function_b429
CB79: 6C 14       INC    -$C,X
CB7B: 39          RTS
CB7C: 6A 0A       DEC    $A,X
CB7E: 27 01       BEQ    $CB81
CB80: 39          RTS
CB81: A6 09       LDA    $9,X
CB83: 81 0D       CMPA   #$0D
CB85: 27 06       BEQ    $CB8D
CB87: CE DD FC    LDU    #$DDFC		; ROM
CB8A: 7E 8D E8    JMP    function_8de8
CB8D: C6 FF       LDB    #$FF
CB8F: E7 84       STB    ,X
CB91: 0A 31       DEC    $31
CB93: 0A 37       DEC    $37
CB95: 0A 33       DEC    $33
CB97: 0A 39       DEC    $39
CB99: 39          RTS

; 2 jump-table ref
function_cb9a:
CB9A: 7E 8D C8    JMP    function_8dc8
CB9D: 6A 0A       DEC    $A,X
CB9F: 27 01       BEQ    $CBA2
CBA1: 39          RTS
CBA2: CE CB AA    LDU    #jump_table_cbaa
CBA5: A6 09       LDA    $9,X
CBA7: 48          ASLA
CBA8: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]


; 1 jump-table ref
function_cbb2:
CBB2: BD 97 D0    JSR    function_97d0
CBB5: 27 01       BEQ    function_cbb8
CBB7: 39          RTS

; 2 jump-table ref  from $CBB5
function_cbb8:
CBB8: CE DE 34    LDU    #$DE34		; ROM
CBBB: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_cbbe:
CBBE: C6 04       LDB    #$04
CBC0: 7E B4 29    JMP    function_b429
CBC3: 6A 0A       DEC    $A,X
CBC5: 27 01       BEQ    $CBC8
CBC7: 39          RTS
CBC8: A6 09       LDA    $9,X
CBCA: 81 03       CMPA   #$03
CBCC: 27 06       BEQ    $CBD4
CBCE: CE DE 34    LDU    #$DE34		; ROM
CBD1: 7E 8D E8    JMP    function_8de8
CBD4: 6C 14       INC    -$C,X
CBD6: 39          RTS
CBD7: 6A 0A       DEC    $A,X
CBD9: 27 01       BEQ    $CBDC
CBDB: 39          RTS
CBDC: A6 09       LDA    $9,X
CBDE: 81 04       CMPA   #$04
CBE0: 27 06       BEQ    $CBE8
CBE2: CE DE 90    LDU    #$DE90
CBE5: 7E 8D E8    JMP    function_8de8
CBE8: 6C 14       INC    -$C,X
CBEA: 39          RTS
CBEB: 6A 0A       DEC    $A,X
CBED: 27 01       BEQ    $CBF0
CBEF: 39          RTS
CBF0: A6 09       LDA    $9,X
CBF2: 81 04       CMPA   #$04
CBF4: 27 06       BEQ    $CBFC
CBF6: CE DE A4    LDU    #$DEA4
CBF9: 7E 8D E8    JMP    function_8de8
CBFC: 6C 14       INC    -$C,X
CBFE: A6 01       LDA    $1,X

; 3 jump-table ref
function_cc00:
CC00: 84 02       ANDA   #$02
CC02: 26 0A       BNE    $CC0E
CC04: EC 1A       LDD    -$6,X
CC06: C3 00 50    ADDD   #$0050
CC09: ED 1A       STD    -$6,X
CC0B: 6C 14       INC    -$C,X
CC0D: 39          RTS
CC0E: EC 1A       LDD    -$6,X
CC10: 83 00 50    SUBD   #$0050
CC13: ED 1A       STD    -$6,X
CC15: 6C 14       INC    -$C,X
CC17: 39          RTS
CC18: 6A 0A       DEC    $A,X
CC1A: 27 01       BEQ    $CC1D
CC1C: 39          RTS
CC1D: A6 09       LDA    $9,X
CC1F: 81 03       CMPA   #$03
CC21: 27 06       BEQ    $CC29
CC23: CE DE B8    LDU    #$DEB8		; ROM
CC26: 7E 8D E8    JMP    function_8de8
CC29: 6C 14       INC    -$C,X
CC2B: 39          RTS
CC2C: 6A 0A       DEC    $A,X
CC2E: 27 01       BEQ    $CC31
CC30: 39          RTS
CC31: 6C 14       INC    -$C,X
CC33: 39          RTS
CC34: 6A 0A       DEC    $A,X
CC36: 27 01       BEQ    $CC39
CC38: 39          RTS
CC39: A6 09       LDA    $9,X
CC3B: 81 08       CMPA   #$08
CC3D: 27 06       BEQ    $CC45
CC3F: CE DE CC    LDU    #$DECC
CC42: 7E 8D E8    JMP    function_8de8
CC45: 6C 14       INC    -$C,X
CC47: 39          RTS
CC48: 6A 0A       DEC    $A,X
CC4A: 27 01       BEQ    $CC4D
CC4C: 39          RTS
CC4D: A6 09       LDA    $9,X
CC4F: 81 02       CMPA   #$02
CC51: 27 06       BEQ    $CC59
CC53: CE DE FC    LDU    #$DEFC
CC56: 7E 8D E8    JMP    function_8de8
CC59: 6C 14       INC    -$C,X
CC5B: 39          RTS
CC5C: 6A 0A       DEC    $A,X
CC5E: 27 01       BEQ    $CC61
CC60: 39          RTS
CC61: A6 09       LDA    $9,X
CC63: 81 02       CMPA   #$02
CC65: 27 06       BEQ    $CC6D
CC67: CE DE F0    LDU    #$DEF0
CC6A: 7E 8D E8    JMP    function_8de8
CC6D: 6C 14       INC    -$C,X
CC6F: 39          RTS
CC70: 6A 0A       DEC    $A,X
CC72: 27 01       BEQ    $CC75
CC74: 39          RTS
CC75: A6 09       LDA    $9,X
CC77: 26 06       BNE    $CC7F
CC79: CE DF 1C    LDU    #$DF1C
CC7C: 7E 8D E8    JMP    function_8de8
CC7F: 6C 14       INC    -$C,X
CC81: 39          RTS
CC82: 6A 0A       DEC    $A,X
CC84: 27 01       BEQ    $CC87
CC86: 39          RTS
CC87: A6 09       LDA    $9,X
CC89: 26 06       BNE    $CC91
CC8B: CE DF 24    LDU    #$DF24
CC8E: 7E 8D E8    JMP    function_8de8
CC91: 6C 14       INC    -$C,X
CC93: 39          RTS

; 2 jump-table ref
function_cc94:
CC94: A6 07       LDA    $7,X
CC96: 84 02       ANDA   #$02
CC98: 26 08       BNE    $CCA2
CC9A: CC 00 10    LDD    #$0010
CC9D: ED 16       STD    -$A,X
CC9F: 7E 8D C8    JMP    function_8dc8
CCA2: CC FF F0    LDD    #$FFF0
CCA5: ED 16       STD    -$A,X
CCA7: 7E 8D C8    JMP    function_8dc8

; 3 jump-table ref
function_ccaa:
CCAA: BD 94 97    JSR    function_9497
CCAD: 2A 01       BPL    $CCB0
CCAF: 39          RTS
CCB0: 6A 0A       DEC    $A,X
CCB2: 27 01       BEQ    $CCB5
CCB4: 39          RTS
CCB5: A6 09       LDA    $9,X
CCB7: 81 07       CMPA   #$07
CCB9: 26 0A       BNE    $CCC5
CCBB: A6 84       LDA    ,X
CCBD: 84 03       ANDA   #$03
CCBF: 26 0A       BNE    $CCCB
CCC1: 86 FF       LDA    #$FF
CCC3: A7 09       STA    $9,X
CCC5: CE DF 2C    LDU    #$DF2C		; ROM
CCC8: 7E 8D E8    JMP    function_8de8
CCCB: 6C 14       INC    -$C,X
CCCD: 39          RTS

; 2 jump-table ref
function_ccce:
CCCE: 6A 0A       DEC    $A,X
CCD0: 27 01       BEQ    $CCD3
CCD2: 39          RTS
CCD3: A6 09       LDA    $9,X
CCD5: 81 05       CMPA   #$05
CCD7: 27 12       BEQ    $CCEB
CCD9: 81 03       CMPA   #$03
CCDB: 26 08       BNE    $CCE5
CCDD: A6 01       LDA    $1,X
CCDF: 88 03       EORA   #$03
CCE1: A7 01       STA    $1,X
CCE3: A7 07       STA    $7,X
CCE5: CE DF 84    LDU    #$DF84		; ROM
CCE8: 7E 8D E8    JMP    function_8de8
CCEB: A6 01       LDA    $1,X
CCED: 84 02       ANDA   #$02
CCEF: 26 05       BNE    $CCF6
CCF1: CC 00 C0    LDD    #$00C0
CCF4: 20 03       BRA    $CCF9
CCF6: CC FF 40    LDD    #$FF40
CCF9: E3 1A       ADDD   -$6,X
CCFB: ED 1A       STD    -$6,X
CCFD: A6 84       LDA    ,X
CCFF: 84 03       ANDA   #$03
CD01: 26 05       BNE    $CD08
CD03: C6 40       LDB    #$40
CD05: 7E B4 29    JMP    function_b429
CD08: 6C 14       INC    -$C,X
CD0A: 39          RTS

; 2 jump-table ref
function_cd0b:
CD0B: A6 07       LDA    $7,X
CD0D: 84 02       ANDA   #$02
CD0F: 26 08       BNE    $CD19
CD11: CC 00 30    LDD    #$0030
CD14: ED 16       STD    -$A,X
CD16: 7E 8D C8    JMP    function_8dc8
CD19: CC FF D0    LDD    #$FFD0
CD1C: ED 16       STD    -$A,X
CD1E: 7E 8D C8    JMP    function_8dc8

; 1 jump-table ref
function_cd21:
CD21: 6D 0C       TST    $C,X
CD23: 27 07       BEQ    $CD2C
CD25: 86 24       LDA    #$24
CD27: A7 04       STA    $4,X
CD29: 6F 0C       CLR    $C,X
CD2B: 39          RTS
CD2C: 86 22       LDA    #$22
CD2E: A7 04       STA    $4,X
CD30: BD 94 97    JSR    function_9497
CD33: 2A 01       BPL    $CD36
CD35: 39          RTS
CD36: A6 01       LDA    $1,X
CD38: 84 02       ANDA   #$02
CD3A: 26 0D       BNE    $CD49
CD3C: EC 1A       LDD    -$6,X
CD3E: 10 83 10 00 CMPD   #$1000
CD42: 2D 0D       BLT    $CD51
CD44: C6 48       LDB    #$48
CD46: 7E B4 29    JMP    function_b429
CD49: EC 1A       LDD    -$6,X
CD4B: 10 83 02 00 CMPD   #$0200
CD4F: 2D F3       BLT    $CD44
CD51: 6A 0A       DEC    $A,X
CD53: 27 01       BEQ    $CD56
CD55: 39          RTS
CD56: A6 09       LDA    $9,X
CD58: 81 05       CMPA   #$05
CD5A: 26 10       BNE    $CD6C
CD5C: A6 84       LDA    ,X
CD5E: 84 03       ANDA   #$03
CD60: 26 10       BNE    $CD72
CD62: A6 0D       LDA    $D,X
CD64: 85 01       BITA   #$01
CD66: 27 DC       BEQ    $CD44
CD68: 86 FF       LDA    #$FF
CD6A: A7 09       STA    $9,X
CD6C: CE DF 9C    LDU    #$DF9C		; ROM
CD6F: 7E 8D E8    JMP    function_8de8
CD72: 6C 14       INC    -$C,X
CD74: 39          RTS

; 2 jump-table ref
function_cd75:
CD75: 96 03       LDA    dp_state_cpu2_03
CD77: 81 06       CMPA   #$06
CD79: 26 0A       BNE    $CD85
CD7B: 96 05       LDA    dp_sub_cpu2_05		; CPU2 sub-state
CD7D: 81 07       CMPA   #$07
CD7F: 26 04       BNE    $CD85
CD81: 86 08       LDA    #$08
CD83: 97 E8       STA    $E8
CD85: 7E 8D C8    JMP    function_8dc8

; 32 jump-table ref; jumped-to 1x  from $B408
function_cd88:
CD88: A6 0C       LDA    $C,X
CD8A: 81 FF       CMPA   #$FF
CD8C: 26 07       BNE    $CD95
CD8E: 6F 0C       CLR    $C,X
CD90: C6 44       LDB    #$44
CD92: 7E B4 29    JMP    function_b429
CD95: CE CD 9D    LDU    #jump_table_cd9d
CD98: A6 09       LDA    $9,X
CD9A: 48          ASLA
CD9B: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]


; 1 jump-table ref
function_cda5:
CDA5: EC 1A       LDD    -$6,X
CDA7: B3 04 0A    SUBD   $040A		; work RAM (shared with CPU1 $4400)
CDAA: 10 83 0C 00 CMPD   #$0C00
CDAE: 2D 01       BLT    $CDB1
CDB0: 39          RTS
CDB1: CE DF 4C    LDU    #$DF4C		; ROM
CDB4: 7E 8D E8    JMP    function_8de8

; 2 jump-table ref
function_cdb7:
CDB7: 6A 0A       DEC    $A,X
CDB9: 27 01       BEQ    $CDBC
CDBB: 39          RTS
CDBC: CE DF 4C    LDU    #$DF4C		; ROM
CDBF: 7E 8D E8    JMP    function_8de8

; 1 jump-table ref
function_cdc2:
CDC2: EC 1A       LDD    -$6,X
CDC4: B3 04 0A    SUBD   $040A		; work RAM (shared with CPU1 $4400)
CDC7: 10 83 06 00 CMPD   #$0600
CDCB: 2D 01       BLT    $CDCE
CDCD: 39          RTS
CDCE: C6 44       LDB    #$44
CDD0: 7E B4 29    JMP    function_b429

; 28 jump-table ref
function_cdd3:
CDD3: 6A 0A       DEC    $A,X
CDD5: 27 01       BEQ    $CDD8
CDD7: 39          RTS
CDD8: A6 09       LDA    $9,X
CDDA: 81 03       CMPA   #$03
CDDC: 27 06       BEQ    $CDE4
CDDE: CE DF 4C    LDU    #$DF4C		; ROM
CDE1: 7E 8D E8    JMP    function_8de8
CDE4: 6C 14       INC    -$C,X
CDE6: 39          RTS

; 4 jump-table ref
function_cde7:
CDE7: 6A 0A       DEC    $A,X
CDE9: 27 01       BEQ    $CDEC
CDEB: 39          RTS
CDEC: A6 09       LDA    $9,X
CDEE: 81 07       CMPA   #$07
CDF0: 27 06       BEQ    $CDF8
CDF2: CE DF B4    LDU    #$DFB4		; ROM
CDF5: 7E 8D E8    JMP    function_8de8
CDF8: 6C 14       INC    -$C,X
CDFA: 39          RTS

; 2 jump-table ref
function_cdfb:
CDFB: 6A 0A       DEC    $A,X
CDFD: 27 01       BEQ    $CE00
CDFF: 39          RTS
CE00: A6 09       LDA    $9,X
CE02: 81 04       CMPA   #$04
CE04: 27 12       BEQ    $CE18
CE06: 81 02       CMPA   #$02
CE08: 26 08       BNE    $CE12
CE0A: A6 01       LDA    $1,X
CE0C: 88 03       EORA   #$03
CE0E: A7 01       STA    $1,X
CE10: A7 07       STA    $7,X
CE12: CE DF D4    LDU    #$DFD4		; ROM
CE15: 7E 8D E8    JMP    function_8de8
CE18: A6 84       LDA    ,X
CE1A: 84 03       ANDA   #$03
CE1C: 26 05       BNE    $CE23
CE1E: C6 40       LDB    #$40
CE20: 7E B4 29    JMP    function_b429
CE23: 6C 14       INC    -$C,X
CE25: 39          RTS

; 2 jump-table ref
function_ce26:
CE26: 6A 0A       DEC    $A,X
CE28: 27 01       BEQ    $CE2B
CE2A: 39          RTS
CE2B: A6 09       LDA    $9,X
CE2D: 81 03       CMPA   #$03
CE2F: 27 06       BEQ    $CE37
CE31: CE DF 74    LDU    #$DF74		; ROM
CE34: 7E 8D E8    JMP    function_8de8
CE37: 6C 14       INC    -$C,X
CE39: 39          RTS

; 2 jump-table ref
function_ce3a:
CE3A: 6A 0A       DEC    $A,X
CE3C: 27 01       BEQ    $CE3F
CE3E: 39          RTS
CE3F: A6 09       LDA    $9,X
CE41: 81 05       CMPA   #$05
CE43: 27 06       BEQ    $CE4B
CE45: CE DF 5C    LDU    #$DF5C		; ROM
CE48: 7E 8D E8    JMP    function_8de8
CE4B: A6 84       LDA    ,X
CE4D: 84 03       ANDA   #$03
CE4F: 26 05       BNE    $CE56
CE51: C6 40       LDB    #$40
CE53: 7E B4 29    JMP    function_b429
CE56: 6C 14       INC    -$C,X
CE58: 39          RTS

; 6 jump-table ref
function_ce59:
CE59: 6D 06       TST    $6,X
CE5B: 27 1A       BEQ    $CE77
CE5D: 10 8E 13 60 LDY    #$1360		; work RAM (shared with CPU1 $4400)
CE61: 96 E4       LDA    $E4
CE63: C6 0E       LDB    #$0E
CE65: E7 A6       STB    A,Y
CE67: 4C          INCA
CE68: 84 1F       ANDA   #$1F
CE6A: 97 E4       STA    $E4
CE6C: A6 0C       LDA    $C,X
CE6E: 8A FF       ORA    #$FF
CE70: A7 0C       STA    $C,X
CE72: E6 01       LDB    $1,X
CE74: E7 07       STB    $7,X
CE76: 39          RTS
CE77: 86 07       LDA    #$07
CE79: 97 E8       STA    $E8
CE7B: 7E 8D C8    JMP    function_8dc8

; 8 jump-table ref; jumped-to 1x  from $B402
function_ce7e:
CE7E: 6A 0A       DEC    $A,X
CE80: 27 01       BEQ    $CE83
CE82: 39          RTS
CE83: A6 09       LDA    $9,X
CE85: 81 06       CMPA   #$06
CE87: 27 06       BEQ    $CE8F
CE89: CE DF E8    LDU    #$DFE8		; ROM
CE8C: 7E 8D E8    JMP    function_8de8
CE8F: 86 FF       LDA    #$FF
CE91: A7 84       STA    ,X
CE93: 0A 31       DEC    $31
CE95: 0A 37       DEC    $37
CE97: 0A 33       DEC    $33
CE99: 0A 39       DEC    $39
CE9B: 0C 1F       INC    $1F
CE9D: 39          RTS

; 4 jump-table ref
function_ce9e:
CE9E: E6 01       LDB    $1,X
CEA0: E7 07       STB    $7,X
CEA2: 39          RTS

; called 2x  from $87B1, $894A
function_cea3:
CEA3: 96 51       LDA    $51
CEA5: 26 03       BNE    $CEAA
CEA7: 97 53       STA    $53
CEA9: 39          RTS
CEAA: 8E 10 00    LDX    #$1000		; work RAM (shared with CPU1 $4400)
CEAD: 97 55       STA    $55
CEAF: 0F 53       CLR    $53
CEB1: A6 84       LDA    ,X
CEB3: 81 FF       CMPA   #$FF
CEB5: 27 19       BEQ    $CED0
CEB7: 84 7F       ANDA   #$7F
CEB9: 81 48       CMPA   #$48
CEBB: 24 13       BCC    $CED0
CEBD: 8D 2B       BSR    function_ceea
CEBF: 2B 0A       BMI    $CECB
CEC1: CE CE DA    LDU    #jump_table_ceda
CEC4: A6 84       LDA    ,X
CEC6: 80 40       SUBA   #$40
CEC8: 48          ASLA
CEC9: AD D6       JSR    [A,U]		; [indirect_jump] [nb_entries=8]
CECB: 0A 55       DEC    $55
CECD: 26 01       BNE    $CED0
CECF: 39          RTS
CED0: 30 88 10    LEAX   $10,X
CED3: 8C 13 00    CMPX   #$1300
CED6: 25 D9       BCS    $CEB1
CED8: 20 FE       BRA    $CED8


; called 1x  from $CEBD
function_ceea:
CEEA: DC 88       LDD    $88
CEEC: E3 0A       ADDD   $A,X
CEEE: ED 0A       STD    $A,X
CEF0: DC 8A       LDD    $8A
CEF2: E3 0C       ADDD   $C,X
CEF4: ED 0C       STD    $C,X
CEF6: 10 83 03 00 CMPD   #$0300
CEFA: 2D 1D       BLT    $CF19
CEFC: 10 83 0E 00 CMPD   #$0E00
CF00: 2C 17       BGE    $CF19
CF02: EC 0A       LDD    $A,X
CF04: 10 83 FE 00 CMPD   #$FE00
CF08: 2D 0F       BLT    $CF19
CF0A: 10 83 14 00 CMPD   #$1400
CF0E: 2C 09       BGE    $CF19
CF10: 0C 53       INC    $53
CF12: A6 84       LDA    ,X
CF14: 84 7F       ANDA   #$7F
CF16: A7 84       STA    ,X
CF18: 39          RTS
CF19: A6 84       LDA    ,X
CF1B: 8A 80       ORA    #$80
CF1D: A7 84       STA    ,X
CF1F: 39          RTS

; 1 jump-table ref
function_cf20:
CF20: 39          RTS


; 7 jump-table ref
function_cf21:
CF21: CE CF 30    LDU    #table_of_jump_tables_cf30
CF24: A6 01       LDA    $1,X
CF26: 84 01       ANDA   #$01
CF28: 48          ASLA
CF29: EE C6       LDU    A,U		; select proper table of jump tables among 2
CF2B: A6 02       LDA    $2,X
CF2D: 48          ASLA
CF2E: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=5]

table_of_jump_tables_cf30:
	.word	jump_table_cf34
	.word	jump_table_cf3e
	
jump_table_cf34:
	.word	function_d083
	.word	function_d044
	.word	function_d02b
	.word	function_d012
	.word	function_cff9
	
jump_table_cf3e:
	.word	function_cf48
	.word	function_cf40	; bogus
	.word	function_cfb5 
	.word	function_cfda
	.word	function_cff2 
	;.word	$cecf


; 1 jump-table ref
function_cf40:
CF40: 39          RTS    ; [breakpoint] fake


; 1 jump-table ref
function_cf48:
CF48: CE CF 8C    LDU    #$CF8C		; ROM
CF4B: A6 84       LDA    ,X
CF4D: 84 03       ANDA   #$03
CF4F: E6 C6       LDB    A,U
CF51: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
CF55: 96 E6       LDA    $E6
CF57: E7 A6       STB    A,Y
CF59: 4C          INCA
CF5A: 84 1F       ANDA   #$1F
CF5C: 97 E6       STA    $E6
CF5E: A6 01       LDA    $1,X
CF60: 84 3E       ANDA   #$3E
CF62: A7 01       STA    $1,X
CF64: 6C 02       INC    $2,X
CF66: CE CF 80    LDU    #$CF80
CF69: A6 84       LDA    ,X
CF6B: 80 40       SUBA   #$40
CF6D: 48          ASLA
CF6E: EC C6       LDD    A,U
CF70: ED 0E       STD    $E,X
CF72: CE CF 86    LDU    #$CF86
CF75: A6 84       LDA    ,X
CF77: 80 40       SUBA   #$40
CF79: 48          ASLA
CF7A: 10 AE C6    LDY    A,U
CF7D: 7E D1 25    JMP    $D125

CF94: A7 01       STA    $1,X
CF96: A6 03       LDA    $3,X
CF98: 4C          INCA
CF99: 84 03       ANDA   #$03
CF9B: A7 03       STA    $3,X
CF9D: 27 01       BEQ    $CFA0
CF9F: 39          RTS
CFA0: 6C 02       INC    $2,X
CFA2: CE CF AF    LDU    #$CFAF
CFA5: A6 84       LDA    ,X
CFA7: 80 40       SUBA   #$40
CFA9: 48          ASLA
CFAA: EC C6       LDD    A,U
CFAC: ED 0E       STD    $E,X
CFAE: 39          RTS


; 1 jump-table ref
function_cfb5:
CFB5: A6 01       LDA    $1,X
CFB7: 84 3E       ANDA   #$3E
CFB9: A7 01       STA    $1,X
CFBB: A6 03       LDA    $3,X
CFBD: 4C          INCA
CFBE: 84 03       ANDA   #$03
CFC0: A7 03       STA    $3,X
CFC2: 27 01       BEQ    $CFC5
CFC4: 39          RTS
CFC5: 6C 02       INC    $2,X
CFC7: CE CF D4    LDU    #$CFD4		; ROM
CFCA: A6 84       LDA    ,X
CFCC: 80 40       SUBA   #$40
CFCE: 48          ASLA
CFCF: EC C6       LDD    A,U
CFD1: ED 0E       STD    $E,X
CFD3: 39          RTS


; 1 jump-table ref
function_cfda:
CFDA: A6 01       LDA    $1,X
CFDC: 84 3E       ANDA   #$3E
CFDE: A7 01       STA    $1,X
CFE0: A6 03       LDA    $3,X
CFE2: 4C          INCA
CFE3: 84 03       ANDA   #$03
CFE5: A7 03       STA    $3,X
CFE7: 27 01       BEQ    $CFEA
CFE9: 39          RTS
CFEA: 6C 02       INC    $2,X
CFEC: CC 00 00    LDD    #$0000
CFEF: ED 0E       STD    $E,X
CFF1: 39          RTS

; 1 jump-table ref
function_cff2:
CFF2: A6 01       LDA    $1,X
CFF4: 84 3E       ANDA   #$3E
CFF6: A7 01       STA    $1,X
CFF8: 39          RTS

; 1 jump-table ref
function_cff9:
CFF9: A6 03       LDA    $3,X
CFFB: 4C          INCA
CFFC: 84 03       ANDA   #$03
CFFE: A7 03       STA    $3,X
D000: 27 01       BEQ    $D003
D002: 39          RTS
D003: 6A 02       DEC    $2,X
D005: CE CF D4    LDU    #$CFD4		; ROM
D008: A6 84       LDA    ,X
D00A: 80 40       SUBA   #$40
D00C: 48          ASLA
D00D: EC C6       LDD    A,U
D00F: ED 0E       STD    $E,X
D011: 39          RTS

; 1 jump-table ref
function_d012:
D012: A6 03       LDA    $3,X
D014: 4C          INCA
D015: 84 03       ANDA   #$03
D017: A7 03       STA    $3,X
D019: 27 01       BEQ    $D01C
D01B: 39          RTS
D01C: 6A 02       DEC    $2,X
D01E: CE CF AF    LDU    #$CFAF		; ROM
D021: A6 84       LDA    ,X
D023: 80 40       SUBA   #$40
D025: 48          ASLA
D026: EC C6       LDD    A,U
D028: ED 0E       STD    $E,X
D02A: 39          RTS

; 1 jump-table ref
function_d02b:
D02B: A6 03       LDA    $3,X
D02D: 4C          INCA
D02E: 84 03       ANDA   #$03
D030: A7 03       STA    $3,X
D032: 27 01       BEQ    $D035
D034: 39          RTS
D035: 6A 02       DEC    $2,X
D037: CE CF 80    LDU    #$CF80		; ROM
D03A: A6 84       LDA    ,X
D03C: 80 40       SUBA   #$40
D03E: 48          ASLA
D03F: EC C6       LDD    A,U
D041: ED 0E       STD    $E,X
D043: 39          RTS


; 1 jump-table ref
function_d044:
D044: A6 03       LDA    $3,X
D046: 4C          INCA
D047: 84 03       ANDA   #$03
D049: A7 03       STA    $3,X
D04B: 27 01       BEQ    $D04E
D04D: 39          RTS
D04E: CE D0 7F    LDU    #$D07F		; ROM
D051: A6 84       LDA    ,X
D053: 84 03       ANDA   #$03
D055: E6 C6       LDB    A,U
D057: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
D05B: 96 E6       LDA    $E6
D05D: E7 A6       STB    A,Y
D05F: 4C          INCA
D060: 84 1F       ANDA   #$1F
D062: 97 E6       STA    $E6
D064: 6A 02       DEC    $2,X
D066: CC 00 00    LDD    #$0000
D069: ED 0E       STD    $E,X
D06B: CE D0 79    LDU    #$D079
D06E: A6 84       LDA    ,X
D070: 80 40       SUBA   #$40
D072: 48          ASLA
D073: 10 AE C6    LDY    A,U
D076: 7E D1 25    JMP    $D125


; 1 jump-table ref
function_d083:
D083: A6 01       LDA    $1,X
D085: 85 3A       BITA   #$3A
D087: 27 01       BEQ    $D08A
D089: 39          RTS
D08A: 6D 06       TST    $6,X
D08C: 27 03       BEQ    $D091
D08E: 6A 06       DEC    $6,X
D090: 39          RTS
D091: 10 8E 04 30 LDY    #$0430		; work RAM (shared with CPU1 $4400)
D095: CE E9 58    LDU    #$E958		; ROM
D098: 96 C2       LDA    $C2
D09A: 48          ASLA
D09B: EE C6       LDU    A,U
D09D: 96 C4       LDA    $C4
D09F: 48          ASLA
D0A0: EE C6       LDU    A,U
D0A2: 96 81       LDA    $81
D0A4: 9B 0F       ADDA   dp_irqcount2_0f		; CPU2 IRQ/frame counter
D0A6: 84 1C       ANDA   #$1C
D0A8: A7 E2       STA    ,-S		; [local]
D0AA: 44          LSRA
D0AB: 44          LSRA
D0AC: AB E0       ADDA   ,S+		; [local]
D0AE: 33 C6       LEAU   A,U
D0B0: A6 A4       LDA    ,Y
D0B2: 81 FF       CMPA   #$FF
D0B4: 27 0A       BEQ    $D0C0
D0B6: 31 A8 20    LEAY   $20,Y
D0B9: 10 8C 09 00 CMPY   #$0900
D0BD: 25 F1       BCS    $D0B0
D0BF: 39          RTS
D0C0: EC C1       LDD    ,U++
D0C2: 8A 80       ORA    #$80
D0C4: A7 A4       STA    ,Y
D0C6: E7 27       STB    $7,Y
D0C8: 86 80       LDA    #$80
D0CA: A7 21       STA    $1,Y
D0CC: EC C1       LDD    ,U++
D0CE: ED 22       STD    $2,Y
D0D0: A6 C0       LDA    ,U+
D0D2: A7 25       STA    $5,Y
D0D4: 6F 2C       CLR    $C,Y
D0D6: 6F 2D       CLR    $D,Y
D0D8: 6F 2E       CLR    $E,Y
D0DA: 6F 29       CLR    $9,Y
D0DC: AF 30       STX    -$10,Y
D0DE: 10 AF 08    STY    $8,X
D0E1: CE E8 E0    LDU    #$E8E0
D0E4: A6 A4       LDA    ,Y
D0E6: 84 7C       ANDA   #$7C
D0E8: A7 E2       STA    ,-S		; [local]
D0EA: AB 22       ADDA   $2,Y
D0EC: 84 03       ANDA   #$03
D0EE: AB E0       ADDA   ,S+		; [local]
D0F0: 48          ASLA
D0F1: EC C6       LDD    A,U
D0F3: A7 24       STA    $4,Y
D0F5: E7 26       STB    $6,Y
D0F7: CE E9 40    LDU    #$E940
D0FA: A6 7F       LDA    -$1,S		; [local]
D0FC: 44          LSRA
D0FD: EC C6       LDD    A,U
D0FF: ED 32       STD    -$E,Y
D101: A6 01       LDA    $1,X
D103: 8A 02       ORA    #$02
D105: A7 01       STA    $1,X
D107: CC 00 00    LDD    #$0000
D10A: ED 36       STD    -$A,Y
D10C: ED 38       STD    -$8,Y
D10E: EC 0A       LDD    $A,X
D110: C3 01 00    ADDD   #$0100
D113: ED 3A       STD    -$6,Y
D115: EC 0C       LDD    $C,X
D117: 83 03 F0    SUBD   #$03F0
D11A: ED 3C       STD    -$4,Y
D11C: 86 7F       LDA    #$7F
D11E: A7 06       STA    $6,X
D120: 0C 31       INC    $31
D122: 0C 37       INC    $37
D124: 39          RTS
D125: A7 E2       STA    ,-S		; [local]
D127: 86 01       LDA    #$01
D129: B7 D8 03    STA    bank2_select_d803
D12C: 8D 2F       BSR    function_d15d
D12E: EC A1       LDD    ,Y++
D130: DD 5A       STD    $5A
D132: DC 56       LDD    $56
D134: 8B 20       ADDA   #$20
D136: 1F 03       TFR    D,U
D138: D6 58       LDB    $58
D13A: 96 5B       LDA    $5B
D13C: A7 E4       STA    ,S		; [local]
D13E: A6 A0       LDA    ,Y+
D140: A7 C5       STA    B,U
D142: 5C          INCB
D143: A6 A0       LDA    ,Y+
D145: A7 C5       STA    B,U
D147: 5C          INCB
D148: C4 7F       ANDB   #$7F
D14A: 6A E4       DEC    ,S		; [local]
D14C: 26 F0       BNE    $D13E
D14E: DC 56       LDD    $56
D150: C3 00 80    ADDD   #$0080
D153: 84 0F       ANDA   #$0F
D155: DD 56       STD    $56
D157: 0A 5A       DEC    $5A
D159: 26 D9       BNE    $D134
D15B: 35 82       PULS   A,PC		; [manual_stack_pull]

; called 1x  from $D12C
function_d15d:
D15D: CE 13 C0    LDU    #$13C0		; work RAM (shared with CPU1 $4400)
D160: E6 43       LDB    $3,U
D162: C4 70       ANDB   #$70
D164: 1D          SEX
D165: E3 0C       ADDD   $C,X
D167: 58          ASLB
D168: 49          ROLA
D169: A7 E2       STA    ,-S		; [local]
D16B: 86 1D       LDA    #$1D
D16D: A0 E0       SUBA   ,S+		; [local]
D16F: 5F          CLRB
D170: 44          LSRA
D171: 56          RORB
D172: E3 46       ADDD   $6,U
D174: 84 0F       ANDA   #$0F
D176: DD 56       STD    $56
D178: E6 41       LDB    $1,U
D17A: C4 70       ANDB   #$70
D17C: 1D          SEX
D17D: E3 0A       ADDD   $A,X
D17F: 58          ASLB
D180: 49          ROLA
D181: 8B 04       ADDA   #$04
D183: 48          ASLA
D184: AB 45       ADDA   $5,U
D186: 84 7E       ANDA   #$7E
D188: 97 58       STA    $58
D18A: 39          RTS
D18B: CE 10 00    LDU    #$1000
D18E: 86 FF       LDA    #$FF
D190: A1 C4       CMPA   ,U
D192: 27 05       BEQ    $D199
D194: 33 C8 10    LEAU   $10,U
D197: 20 F7       BRA    $D190
D199: 8D 03       BSR    function_d19e
D19B: 0C 51       INC    $51
D19D: 39          RTS

; called 1x  from $D199
function_d19e:
D19E: CC 00 00    LDD    #$0000
D1A1: ED C4       STD    ,U
D1A3: ED 42       STD    $2,U
D1A5: ED 44       STD    $4,U
D1A7: ED 46       STD    $6,U
D1A9: ED 48       STD    $8,U
D1AB: ED 4A       STD    $A,U
D1AD: ED 4C       STD    $C,U
D1AF: AF 4E       STX    $E,U
D1B1: 39          RTS

; called 2x  from $87BC, $8958
function_d1b2:
D1B2: 96 40       LDA    $40
D1B4: 26 03       BNE    $D1B9
D1B6: 97 41       STA    $41
D1B8: 39          RTS
D1B9: 8E 09 00    LDX    #$0900		; work RAM (shared with CPU1 $4400)
D1BC: 97 42       STA    $42
D1BE: 0F 41       CLR    $41
D1C0: A6 84       LDA    ,X
D1C2: 2A 0C       BPL    $D1D0
D1C4: 81 FF       CMPA   #$FF
D1C6: 27 25       BEQ    $D1ED
D1C8: 84 7F       ANDA   #$7F
D1CA: A7 84       STA    ,X
D1CC: 0C 41       INC    $41
D1CE: 20 18       BRA    $D1E8
D1D0: DC 88       LDD    $88
D1D2: E3 0A       ADDD   $A,X
D1D4: ED 0A       STD    $A,X
D1D6: DC 8A       LDD    $8A
D1D8: E3 0C       ADDD   $C,X
D1DA: ED 0C       STD    $C,X
D1DC: 0C 41       INC    $41
D1DE: CE D2 14    LDU    #jump_table_d214
D1E1: A6 84       LDA    ,X
D1E3: 80 60       SUBA   #$60
D1E5: 48          ASLA
D1E6: AD D6       JSR    [A,U]		; [indirect_jump] [nb_entries=12]
D1E8: 0A 42       DEC    $42
D1EA: 26 01       BNE    $D1ED
D1EC: 39          RTS
D1ED: 30 88 10    LEAX   $10,X
D1F0: 20 CE       BRA    $D1C0
D1F2: A6 84       LDA    ,X
D1F4: C6 FF       LDB    #$FF
D1F6: E7 84       STB    ,X
D1F8: 81 60       CMPA   #$60
D1FA: 26 0B       BNE    $D207
D1FC: A6 01       LDA    $1,X
D1FE: 84 04       ANDA   #$04
D200: 27 05       BEQ    $D207
D202: CC 00 01    LDD    #$0001
D205: DD CA       STD    $CA
D207: 0A 40       DEC    $40
D209: 0A 42       DEC    $42
D20B: 26 01       BNE    $D20E
D20D: 39          RTS
D20E: 30 88 10    LEAX   $10,X
D211: 20 AD       BRA    $D1C0

; 4 jump-table ref
function_d213:
D213: 39          RTS


; 1 jump-table ref
function_d22c:
D22C: CE D2 36    LDU    #jump_table_d236
D22F: A6 01       LDA    $1,X
D231: 84 0C       ANDA   #$0C
D233: 44          LSRA
D234: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=4]


; 2 jump-table ref
function_d23e:
D23E: A6 01       LDA    $1,X
D240: 84 02       ANDA   #$02
D242: 26 58       BNE    $D29C
D244: BD D4 10    JSR    function_d410
D247: 26 0B       BNE    $D254
D249: BD D6 9F    JSR    function_d69f
D24C: 26 26       BNE    $D274
D24E: CE D4 FF    LDU    #$D4FF		; ROM
D251: 7E D4 A8    JMP    $D4A8
D254: C1 FF       CMPB   #$FF
D256: 26 01       BNE    $D259
D258: 39          RTS
D259: A6 01       LDA    $1,X
D25B: 84 04       ANDA   #$04
D25D: 27 07       BEQ    $D266
D25F: DC CA       LDD    $CA
D261: 26 03       BNE    $D266
D263: 5C          INCB
D264: DD CA       STD    $CA
D266: C6 63       LDB    #$63
D268: E7 84       STB    ,X
D26A: 86 06       LDA    #$06
D26C: A7 03       STA    $3,X
D26E: CC 7B 54    LDD    #$7B54
D271: ED 0E       STD    $E,X
D273: 39          RTS
D274: A6 01       LDA    $1,X
D276: 84 04       ANDA   #$04
D278: 27 07       BEQ    $D281
D27A: DC CA       LDD    $CA
D27C: 26 03       BNE    $D281
D27E: 5C          INCB
D27F: DD CA       STD    $CA
D281: 6D 46       TST    $6,U
D283: 27 02       BEQ    $D287
D285: 6A 46       DEC    $6,U
D287: C6 63       LDB    #$63
D289: E7 84       STB    ,X
D28B: 86 06       LDA    #$06
D28D: A7 03       STA    $3,X
D28F: EC 0A       LDD    $A,X
D291: C3 00 80    ADDD   #$0080
D294: ED 0A       STD    $A,X
D296: CC 7B 54    LDD    #$7B54
D299: ED 0E       STD    $E,X
D29B: 39          RTS
D29C: BD D4 10    JSR    function_d410
D29F: 26 0B       BNE    $D2AC
D2A1: BD D6 9F    JSR    function_d69f
D2A4: 26 26       BNE    $D2CC
D2A6: CE D5 05    LDU    #$D505
D2A9: 7E D4 A8    JMP    $D4A8
D2AC: C1 FF       CMPB   #$FF
D2AE: 26 01       BNE    $D2B1
D2B0: 39          RTS
D2B1: A6 01       LDA    $1,X
D2B3: 84 04       ANDA   #$04
D2B5: 27 07       BEQ    $D2BE
D2B7: DC CA       LDD    $CA
D2B9: 26 03       BNE    $D2BE
D2BB: 5C          INCB
D2BC: DD CA       STD    $CA
D2BE: C6 63       LDB    #$63
D2C0: E7 84       STB    ,X
D2C2: 86 06       LDA    #$06
D2C4: A7 03       STA    $3,X
D2C6: CC 7B 58    LDD    #$7B58
D2C9: ED 0E       STD    $E,X
D2CB: 39          RTS
D2CC: A6 01       LDA    $1,X
D2CE: 84 04       ANDA   #$04
D2D0: 27 07       BEQ    $D2D9
D2D2: DC CA       LDD    $CA
D2D4: 26 03       BNE    $D2D9
D2D6: 5C          INCB
D2D7: DD CA       STD    $CA
D2D9: 6D 46       TST    $6,U
D2DB: 27 02       BEQ    $D2DF
D2DD: 6A 46       DEC    $6,U
D2DF: C6 63       LDB    #$63
D2E1: E7 84       STB    ,X
D2E3: 86 06       LDA    #$06
D2E5: A7 03       STA    $3,X
D2E7: EC 0A       LDD    $A,X
D2E9: 83 00 80    SUBD   #$0080
D2EC: ED 0A       STD    $A,X
D2EE: CC 7B 58    LDD    #$7B58
D2F1: ED 0E       STD    $E,X
D2F3: 39          RTS

; 2 jump-table ref
function_d2f4:
D2F4: A6 01       LDA    $1,X
D2F6: 84 02       ANDA   #$02
D2F8: 26 4A       BNE    $D344
D2FA: BD D4 10    JSR    function_d410
D2FD: 26 0B       BNE    $D30A
D2FF: BD D6 9F    JSR    function_d69f
D302: 26 1F       BNE    $D323
D304: CE D4 FF    LDU    #$D4FF		; ROM
D307: 7E D4 A8    JMP    $D4A8
D30A: C1 FF       CMPB   #$FF
D30C: 26 01       BNE    $D30F
D30E: 39          RTS
D30F: A6 01       LDA    $1,X
D311: 84 04       ANDA   #$04
D313: 27 00       BEQ    $D315
D315: C6 63       LDB    #$63
D317: E7 84       STB    ,X
D319: 86 06       LDA    #$06
D31B: A7 03       STA    $3,X
D31D: CC 7B 54    LDD    #$7B54
D320: ED 0E       STD    $E,X
D322: 39          RTS
D323: A6 01       LDA    $1,X
D325: 84 04       ANDA   #$04
D327: 27 00       BEQ    $D329
D329: 6D 46       TST    $6,U
D32B: 27 02       BEQ    $D32F
D32D: 6A 46       DEC    $6,U
D32F: C6 63       LDB    #$63
D331: E7 84       STB    ,X
D333: 86 06       LDA    #$06
D335: A7 03       STA    $3,X
D337: EC 0A       LDD    $A,X
D339: C3 00 80    ADDD   #$0080
D33C: ED 0A       STD    $A,X
D33E: CC 7B 54    LDD    #$7B54
D341: ED 0E       STD    $E,X
D343: 39          RTS
D344: BD D4 10    JSR    function_d410
D347: 26 0B       BNE    $D354
D349: BD D6 9F    JSR    function_d69f
D34C: 26 1F       BNE    $D36D
D34E: CE D5 05    LDU    #$D505
D351: 7E D4 A8    JMP    $D4A8
D354: C1 FF       CMPB   #$FF
D356: 26 01       BNE    $D359
D358: 39          RTS
D359: A6 01       LDA    $1,X
D35B: 84 04       ANDA   #$04
D35D: 27 00       BEQ    $D35F
D35F: C6 63       LDB    #$63
D361: E7 84       STB    ,X
D363: 86 06       LDA    #$06
D365: A7 03       STA    $3,X
D367: CC 7B 58    LDD    #$7B58
D36A: ED 0E       STD    $E,X
D36C: 39          RTS
D36D: A6 01       LDA    $1,X
D36F: 84 04       ANDA   #$04
D371: 27 00       BEQ    $D373
D373: 6D 46       TST    $6,U
D375: 27 02       BEQ    $D379
D377: 6A 46       DEC    $6,U
D379: C6 63       LDB    #$63
D37B: E7 84       STB    ,X
D37D: 86 06       LDA    #$06
D37F: A7 03       STA    $3,X
D381: EC 0A       LDD    $A,X
D383: 83 00 80    SUBD   #$0080
D386: ED 0A       STD    $A,X
D388: CC 7B 58    LDD    #$7B58
D38B: ED 0E       STD    $E,X
D38D: 39          RTS

; 1 jump-table ref
function_d38e:
D38E: A6 01       LDA    $1,X
D390: 84 02       ANDA   #$02
D392: 26 3E       BNE    $D3D2
D394: BD D4 10    JSR    function_d410
D397: 26 0B       BNE    $D3A4
D399: BD D6 74    JSR    function_d674
D39C: 26 19       BNE    $D3B7
D39E: CE D5 0B    LDU    #$D50B		; ROM
D3A1: 7E D4 A8    JMP    $D4A8
D3A4: C1 FF       CMPB   #$FF
D3A6: 26 01       BNE    $D3A9
D3A8: 39          RTS
D3A9: C6 63       LDB    #$63
D3AB: E7 84       STB    ,X
D3AD: 86 06       LDA    #$06
D3AF: A7 03       STA    $3,X
D3B1: CC 7B 54    LDD    #$7B54
D3B4: ED 0E       STD    $E,X
D3B6: 39          RTS
D3B7: 96 15       LDA    $15
D3B9: 8B 40       ADDA   #$40
D3BB: 97 15       STA    $15
D3BD: C6 63       LDB    #$63
D3BF: E7 84       STB    ,X
D3C1: 86 06       LDA    #$06
D3C3: A7 03       STA    $3,X
D3C5: EC 0A       LDD    $A,X
D3C7: C3 00 80    ADDD   #$0080
D3CA: ED 0A       STD    $A,X
D3CC: CC 7B 54    LDD    #$7B54
D3CF: ED 0E       STD    $E,X
D3D1: 39          RTS
D3D2: BD D4 10    JSR    function_d410
D3D5: 26 0B       BNE    $D3E2
D3D7: BD D6 74    JSR    function_d674
D3DA: 26 19       BNE    $D3F5
D3DC: CE D5 11    LDU    #$D511
D3DF: 7E D4 A8    JMP    $D4A8
D3E2: C1 FF       CMPB   #$FF
D3E4: 26 01       BNE    $D3E7
D3E6: 39          RTS
D3E7: C6 63       LDB    #$63
D3E9: E7 84       STB    ,X
D3EB: 86 06       LDA    #$06
D3ED: A7 03       STA    $3,X
D3EF: CC 7B 58    LDD    #$7B58
D3F2: ED 0E       STD    $E,X
D3F4: 39          RTS
D3F5: 96 15       LDA    $15
D3F7: 8B 40       ADDA   #$40
D3F9: 97 15       STA    $15
D3FB: C6 63       LDB    #$63
D3FD: E7 84       STB    ,X
D3FF: 86 06       LDA    #$06
D401: A7 03       STA    $3,X
D403: EC 0A       LDD    $A,X
D405: 83 00 80    SUBD   #$0080
D408: ED 0A       STD    $A,X
D40A: CC 7B 58    LDD    #$7B58
D40D: ED 0E       STD    $E,X
D40F: 39          RTS

; called 6x  from $D244, $D29C, $D2FA, $D344, $D394, $D3D2
function_d410:
D410: EC 06       LDD    $6,X
D412: 2A 15       BPL    $D429
D414: E3 0A       ADDD   $A,X
D416: 10 83 FF 00 CMPD   #$FF00
D41A: 2D 15       BLT    $D431
D41C: ED 0A       STD    $A,X
D41E: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
D421: CC 01 01    LDD    #$0101
D424: 8D 2F       BSR    function_d455
D426: C4 01       ANDB   #$01
D428: 39          RTS
D429: E3 0A       ADDD   $A,X
D42B: 10 83 12 00 CMPD   #$1200
D42F: 2D EB       BLT    $D41C
D431: A6 01       LDA    $1,X
D433: 84 04       ANDA   #$04
D435: 27 07       BEQ    $D43E
D437: DC CA       LDD    $CA
D439: 26 03       BNE    $D43E
D43B: 5C          INCB
D43C: DD CA       STD    $CA
D43E: C6 FF       LDB    #$FF
D440: E7 84       STB    ,X
D442: 0A 40       DEC    $40
D444: 0A 41       DEC    $41
D446: 39          RTS

; 1 jump-table ref
function_d447:
D447: 6A 03       DEC    $3,X
D449: 27 01       BEQ    $D44C
D44B: 39          RTS
D44C: C6 FF       LDB    #$FF
D44E: E7 84       STB    ,X
D450: 0A 40       DEC    $40
D452: 0A 41       DEC    $41
D454: 39          RTS

; called 2x  from $D424, $D610
function_d455:
D455: 8D 20       BSR    function_d477
D457: CE 40 00    LDU    #$4000		; layer 2 tilemap
D45A: EC CB       LDD    D,U
D45C: C4 03       ANDB   #$03
D45E: C1 03       CMPB   #$03
D460: 27 02       BEQ    $D464
D462: 5F          CLRB
D463: 39          RTS
D464: CE E6 7C    LDU    #$E67C		; ROM
D467: 44          LSRA
D468: 44          LSRA
D469: E6 04       LDB    $4,X
D46B: C4 C0       ANDB   #$C0
D46D: 54          LSRB
D46E: 54          LSRB
D46F: 54          LSRB
D470: 54          LSRB
D471: 54          LSRB
D472: EE C5       LDU    B,U
D474: E6 C6       LDB    A,U
D476: 39          RTS

; called 1x  from $D455
function_d477:
D477: ED E3       STD    ,--S		; [local]
D479: E6 41       LDB    $1,U
D47B: C4 70       ANDB   #$70
D47D: 1D          SEX
D47E: E3 0A       ADDD   $A,X
D480: 58          ASLB
D481: 49          ROLA
D482: AB E0       ADDA   ,S+		; [local]
D484: 8B 04       ADDA   #$04
D486: 48          ASLA
D487: AB 45       ADDA   $5,U
D489: 84 7E       ANDA   #$7E
D48B: A7 E2       STA    ,-S		; [local]
D48D: E6 43       LDB    $3,U
D48F: C4 70       ANDB   #$70
D491: 1D          SEX
D492: E3 0C       ADDD   $C,X
D494: 58          ASLB
D495: 49          ROLA
D496: AB 61       ADDA   $1,S		; [local]
D498: A7 E2       STA    ,-S		; [local]
D49A: 86 1D       LDA    #$1D
D49C: A0 E0       SUBA   ,S+		; [local]
D49E: C6 80       LDB    #$80
D4A0: 3D          MUL
D4A1: E3 46       ADDD   $6,U
D4A3: 84 0F       ANDA   #$0F
D4A5: EB E1       ADDB   ,S++		; [local]
D4A7: 39          RTS
D4A8: A6 03       LDA    $3,X
D4AA: 4C          INCA
D4AB: 84 07       ANDA   #$07
D4AD: A7 03       STA    $3,X
D4AF: 27 01       BEQ    $D4B2
D4B1: 39          RTS
D4B2: A6 02       LDA    $2,X
D4B4: 4C          INCA
D4B5: 81 03       CMPA   #$03
D4B7: 26 01       BNE    $D4BA
D4B9: 4F          CLRA
D4BA: A7 02       STA    $2,X
D4BC: 48          ASLA
D4BD: EC C6       LDD    A,U
D4BF: ED 0E       STD    $E,X
D4C1: 39          RTS

; 1 jump-table ref
function_d4c2:
D4C2: CE D4 F9    LDU    #jump_table_d4f9
D4C5: A6 02       LDA    $2,X
D4C7: 6C 02       INC    $2,X
D4C9: 48          ASLA
D4CA: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=3]

; 1 jump-table ref
function_d4cc:
D4CC: A6 01       LDA    $1,X
D4CE: 84 02       ANDA   #$02
D4D0: 26 06       BNE    $D4D8
D4D2: CC 7B 44    LDD    #$7B44
D4D5: ED 0E       STD    $E,X
D4D7: 39          RTS
D4D8: CC 7B 48    LDD    #$7B48
D4DB: ED 0E       STD    $E,X
D4DD: 39          RTS

; 1 jump-table ref
function_d4de:
D4DE: A6 01       LDA    $1,X
D4E0: 84 02       ANDA   #$02
D4E2: 26 06       BNE    $D4EA
D4E4: CC 7B 4C    LDD    #$7B4C
D4E7: ED 0E       STD    $E,X
D4E9: 39          RTS
D4EA: CC 7B 50    LDD    #$7B50
D4ED: ED 0E       STD    $E,X
D4EF: 39          RTS

; 1 jump-table ref
function_d4f0:
D4F0: 86 FF       LDA    #$FF
D4F2: A7 84       STA    ,X
D4F4: 0A 40       DEC    $40
D4F6: 0A 41       DEC    $41
D4F8: 39          RTS


; called 4x  from $C7D3, $C7F1, $C93D, $C95B
function_d517:
D517: CE 09 00    LDU    #$0900		; work RAM (shared with CPU1 $4400)
D51A: C6 FF       LDB    #$FF
D51C: E1 C4       CMPB   ,U
D51E: 27 05       BEQ    $D525
D520: 33 C8 10    LEAU   $10,U
D523: 20 F7       BRA    $D51C
D525: 8A 80       ORA    #$80
D527: E6 01       LDB    $1,X
D529: C4 03       ANDB   #$03
D52B: ED C4       STD    ,U
D52D: 6F 42       CLR    $2,U
D52F: 6F 43       CLR    $3,U
D531: E6 05       LDB    $5,X
D533: E7 44       STB    $4,U
D535: EF 10       STU    -$10,X
D537: CC 00 00    LDD    #$0000
D53A: ED 46       STD    $6,U
D53C: ED 48       STD    $8,U
D53E: 0C 40       INC    $40
D540: 39          RTS

; 2 jump-table ref
function_d541:
D541: 6D 02       TST    $2,X
D543: 26 01       BNE    $D546
D545: 39          RTS
D546: 8D 69       BSR    function_d5b1
D548: 2E 01       BGT    $D54B
D54A: 39          RTS
D54B: 10 8E 13 A0 LDY    #$13A0		; work RAM (shared with CPU1 $4400)
D54F: 96 E6       LDA    $E6
D551: C6 26       LDB    #$26
D553: E7 A6       STB    A,Y
D555: 4C          INCA
D556: 84 1F       ANDA   #$1F
D558: 97 E6       STA    $E6
D55A: 86 6B       LDA    #$6B
D55C: A7 84       STA    ,X
D55E: CC 7B CC    LDD    #$7BCC
D561: ED 0E       STD    $E,X
D563: EC 0C       LDD    $C,X
D565: C3 00 80    ADDD   #$0080
D568: C4 80       ANDB   #$80
D56A: ED 0C       STD    $C,X
D56C: EC 0A       LDD    $A,X
D56E: 83 00 80    SUBD   #$0080
D571: ED 0A       STD    $A,X
D573: 6F 02       CLR    $2,X
D575: 39          RTS

; 1 jump-table ref
function_d576:
D576: BD D7 68    JSR    function_d768
D579: 26 D0       BNE    $D54B
D57B: 8D 34       BSR    function_d5b1
D57D: 2A 01       BPL    $D580
D57F: 39          RTS
D580: 26 C9       BNE    $D54B
D582: A6 03       LDA    $3,X
D584: 4C          INCA
D585: 84 03       ANDA   #$03
D587: A7 03       STA    $3,X
D589: 27 01       BEQ    $D58C
D58B: 39          RTS
D58C: A6 02       LDA    $2,X
D58E: 4C          INCA
D58F: 81 06       CMPA   #$06
D591: 27 0A       BEQ    $D59D
D593: A7 02       STA    $2,X
D595: EC 0E       LDD    $E,X
D597: C3 00 08    ADDD   #$0008
D59A: ED 0E       STD    $E,X
D59C: 39          RTS
D59D: 6F 02       CLR    $2,X
D59F: A6 01       LDA    $1,X
D5A1: 84 02       ANDA   #$02
D5A3: 26 06       BNE    $D5AB
D5A5: CC 7B 9C    LDD    #$7B9C
D5A8: ED 0E       STD    $E,X
D5AA: 39          RTS
D5AB: CC 7B A0    LDD    #$7BA0
D5AE: ED 0E       STD    $E,X
D5B0: 39          RTS

; called 2x  from $D546, $D57B
function_d5b1:
D5B1: EC 06       LDD    $6,X
D5B3: E3 0A       ADDD   $A,X
D5B5: ED 0A       STD    $A,X
D5B7: EC 08       LDD    $8,X
D5B9: E3 0C       ADDD   $C,X
D5BB: ED 0C       STD    $C,X
D5BD: 6D 08       TST    $8,X
D5BF: 2A 08       BPL    $D5C9
D5C1: 10 83 10 00 CMPD   #$1000
D5C5: 2C 5D       BGE    $D624
D5C7: 20 0E       BRA    $D5D7
D5C9: 10 83 FF 00 CMPD   #$FF00
D5CD: 2D 55       BLT    $D624
D5CF: 2B 1E       BMI    $D5EF
D5D1: 10 83 0F 00 CMPD   #$0F00
D5D5: 2C 18       BGE    $D5EF
D5D7: EC 0A       LDD    $A,X
D5D9: 6D 06       TST    $6,X
D5DB: 2B 1B       BMI    $D5F8
D5DD: 10 83 14 00 CMPD   #$1400
D5E1: 2C 41       BGE    $D624
D5E3: 10 83 12 00 CMPD   #$1200
D5E7: 2C 06       BGE    $D5EF
D5E9: 10 83 00 00 CMPD   #$0000
D5ED: 2C 1B       BGE    $D60A
D5EF: EC 08       LDD    $8,X
D5F1: 83 00 02    SUBD   #$0002
D5F4: ED 08       STD    $8,X
D5F6: 4F          CLRA
D5F7: 39          RTS
D5F8: 10 83 FE 00 CMPD   #$FE00
D5FC: 2D 26       BLT    $D624
D5FE: 10 83 00 00 CMPD   #$0000
D602: 2D EB       BLT    $D5EF
D604: 10 83 12 00 CMPD   #$1200
D608: 2C E5       BGE    $D5EF
D60A: CE 13 E0    LDU    #$13E0		; work RAM (shared with CPU1 $4400)
D60D: CC 01 00    LDD    #$0100
D610: BD D4 55    JSR    function_d455
D613: C5 03       BITB   #$03
D615: 27 D8       BEQ    $D5EF
D617: C4 C0       ANDB   #$C0
D619: E7 04       STB    $4,X
D61B: 84 EE       ANDA   #$EE
D61D: 81 20       CMPA   #$20
D61F: 27 CE       BEQ    $D5EF
D621: C6 03       LDB    #$03
D623: 39          RTS
D624: 0A 40       DEC    $40
D626: 0A 41       DEC    $41
D628: 86 FF       LDA    #$FF
D62A: A7 84       STA    ,X
D62C: 39          RTS

; 1 jump-table ref
function_d62d:
D62D: A6 02       LDA    $2,X
D62F: 81 02       CMPA   #$02
D631: 22 03       BHI    $D636
D633: BD D8 52    JSR    function_d852
D636: A6 03       LDA    $3,X
D638: 4C          INCA
D639: 84 07       ANDA   #$07
D63B: A7 03       STA    $3,X
D63D: 27 01       BEQ    $D640
D63F: 39          RTS
D640: EC 0E       LDD    $E,X
D642: C3 00 04    ADDD   #$0004
D645: ED 0E       STD    $E,X
D647: 6C 02       INC    $2,X
D649: A6 02       LDA    $2,X
D64B: 81 0D       CMPA   #$0D
D64D: 27 D5       BEQ    $D624
D64F: CE D6 5A    LDU    #$D65A		; ROM
D652: 48          ASLA
D653: EC C6       LDD    A,U
D655: E3 0C       ADDD   $C,X
D657: ED 0C       STD    $C,X
D659: 39          RTS


; called 2x  from $D399, $D3D7
function_d674:
D674: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
D677: A6 C4       LDA    ,U
D679: 2B 22       BMI    $D69D
D67B: E6 4B       LDB    $B,U
D67D: 2B 1E       BMI    $D69D
D67F: A6 4D       LDA    $D,U
D681: 26 1A       BNE    $D69D
D683: A6 45       LDA    $5,U
D685: A1 04       CMPA   $4,X
D687: 26 14       BNE    $D69D
D689: 4F          CLRA
D68A: 58          ASLB
D68B: 49          ROLA
D68C: ED E3       STD    ,--S		; [local]
D68E: 58          ASLB
D68F: 49          ROLA
D690: 58          ASLB
D691: 49          ROLA
D692: E3 E1       ADDD   ,S++		; [local]
D694: 10 8E E1 40 LDY    #$E140		; ROM
D698: 31 AB       LEAY   D,Y
D69A: 7E D6 D9    JMP    function_d6d9
D69D: 4F          CLRA
D69E: 39          RTS

; called 4x  from $D249, $D2A1, $D2FF, $D349
function_d69f:
D69F: 96 38       LDA    $38
D6A1: 9B 39       ADDA   $39
D6A3: 26 01       BNE    $D6A6
D6A5: 39          RTS
D6A6: 97 3B       STA    $3B
D6A8: CE 04 30    LDU    #$0430		; work RAM (shared with CPU1 $4400)
D6AB: A6 C4       LDA    ,U
D6AD: 2B 25       BMI    $D6D4
D6AF: A6 45       LDA    $5,U
D6B1: A1 04       CMPA   $4,X
D6B3: 26 1A       BNE    $D6CF
D6B5: E6 4B       LDB    $B,U
D6B7: 2B 16       BMI    $D6CF
D6B9: 4F          CLRA
D6BA: 58          ASLB
D6BB: 49          ROLA
D6BC: ED E3       STD    ,--S		; [local]
D6BE: 58          ASLB
D6BF: 49          ROLA
D6C0: 58          ASLB
D6C1: 49          ROLA
D6C2: E3 E1       ADDD   ,S++		; [local]
D6C4: 10 8E E1 40 LDY    #$E140		; ROM
D6C8: 31 AB       LEAY   D,Y
D6CA: 8D 0D       BSR    function_d6d9
D6CC: 27 01       BEQ    $D6CF
D6CE: 39          RTS
D6CF: 0A 3B       DEC    $3B
D6D1: 26 01       BNE    $D6D4
D6D3: 39          RTS
D6D4: 33 C8 20    LEAU   $20,U
D6D7: 20 D2       BRA    $D6AB

; called 1x; jumped-to 1x  from $D69A, $D6CA
function_d6d9:
D6D9: EC 5C       LDD    -$4,U
D6DB: E3 A4       ADDD   ,Y
D6DD: A3 0C       SUBD   $C,X
D6DF: B3 E6 40    SUBD   $E640		; ROM
D6E2: 2B 08       BMI    $D6EC
D6E4: 10 B3 E6 42 CMPD   $E642
D6E8: 23 0C       BLS    $D6F6
D6EA: 4F          CLRA
D6EB: 39          RTS
D6EC: 53          COMB
D6ED: 43          COMA
D6EE: C3 00 01    ADDD   #$0001
D6F1: 10 A3 22    CMPD   $2,Y
D6F4: 22 F4       BHI    $D6EA
D6F6: 6D 06       TST    $6,X
D6F8: 2B 38       BMI    $D732
D6FA: A6 41       LDA    $1,U
D6FC: 84 02       ANDA   #$02
D6FE: 26 16       BNE    $D716
D700: EC 5A       LDD    -$6,U
D702: E3 24       ADDD   $4,Y
D704: A3 0A       SUBD   $A,X
D706: B3 E6 44    SUBD   $E644
D709: 2B 16       BMI    $D721
D70B: 10 B3 E6 48 CMPD   $E648
D70F: 22 1F       BHI    $D730
D711: 86 61       LDA    #$61
D713: A7 47       STA    $7,U
D715: 39          RTS
D716: EC 5A       LDD    -$6,U
D718: E3 26       ADDD   $6,Y
D71A: A3 0A       SUBD   $A,X
D71C: B3 E6 44    SUBD   $E644
D71F: 2A EA       BPL    $D70B
D721: 53          COMB
D722: 43          COMA
D723: C3 00 01    ADDD   #$0001
D726: 10 A3 28    CMPD   $8,Y
D729: 22 05       BHI    $D730
D72B: 86 61       LDA    #$61
D72D: A7 47       STA    $7,U
D72F: 39          RTS
D730: 4F          CLRA
D731: 39          RTS
D732: A6 41       LDA    $1,U
D734: 84 02       ANDA   #$02
D736: 26 16       BNE    $D74E
D738: EC 5A       LDD    -$6,U
D73A: E3 24       ADDD   $4,Y
D73C: A3 0A       SUBD   $A,X
D73E: B3 E6 46    SUBD   $E646
D741: 2B 16       BMI    $D759
D743: 10 B3 E6 48 CMPD   $E648
D747: 22 E7       BHI    $D730
D749: 86 62       LDA    #$62
D74B: A7 47       STA    $7,U
D74D: 39          RTS
D74E: EC 5A       LDD    -$6,U
D750: E3 26       ADDD   $6,Y
D752: A3 0A       SUBD   $A,X
D754: B3 E6 46    SUBD   $E646
D757: 2A EA       BPL    $D743
D759: 53          COMB
D75A: 43          COMA
D75B: C3 00 01    ADDD   #$0001
D75E: 10 A3 28    CMPD   $8,Y
D761: 22 CD       BHI    $D730
D763: 86 62       LDA    #$62
D765: A7 47       STA    $7,U
D767: 39          RTS

; called 1x  from $D576
function_d768:
D768: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
D76B: A6 C4       LDA    ,U
D76D: 2B 22       BMI    $D791
D76F: E6 4B       LDB    $B,U
D771: 2B 1E       BMI    $D791
D773: A6 4D       LDA    $D,U
D775: 26 1A       BNE    $D791
D777: A6 45       LDA    $5,U
D779: A1 04       CMPA   $4,X
D77B: 26 14       BNE    $D791
D77D: 4F          CLRA
D77E: 58          ASLB
D77F: 49          ROLA
D780: ED E3       STD    ,--S		; [local]
D782: 58          ASLB
D783: 49          ROLA
D784: 58          ASLB
D785: 49          ROLA
D786: E3 E1       ADDD   ,S++		; [local]
D788: 10 8E E1 40 LDY    #$E140		; ROM
D78C: 31 AB       LEAY   D,Y
D78E: 7E D7 93    JMP    $D793
D791: 4F          CLRA
D792: 39          RTS
D793: EC 5C       LDD    -$4,U
D795: E3 A4       ADDD   ,Y
D797: A3 0C       SUBD   $C,X
D799: B3 E6 4A    SUBD   $E64A
D79C: 2B 08       BMI    $D7A6
D79E: 10 B3 E6 4C CMPD   $E64C
D7A2: 23 0C       BLS    $D7B0
D7A4: 4F          CLRA
D7A5: 39          RTS
D7A6: 53          COMB
D7A7: 43          COMA
D7A8: C3 00 01    ADDD   #$0001
D7AB: 10 A3 22    CMPD   $2,Y
D7AE: 22 F4       BHI    $D7A4
D7B0: 6D 06       TST    $6,X
D7B2: 2B 50       BMI    $D804
D7B4: A6 41       LDA    $1,U
D7B6: 84 02       ANDA   #$02
D7B8: 26 22       BNE    $D7DC
D7BA: EC 5A       LDD    -$6,U
D7BC: E3 24       ADDD   $4,Y
D7BE: A3 0A       SUBD   $A,X
D7C0: B3 E6 4E    SUBD   $E64E
D7C3: 2B 22       BMI    $D7E7
D7C5: 10 B3 E6 52 CMPD   $E652
D7C9: 22 37       BHI    $D802
D7CB: 96 15       LDA    $15
D7CD: 8B 20       ADDA   #$20
D7CF: 97 15       STA    $15
D7D1: 9B 14       ADDA   $14
D7D3: 91 C1       CMPA   $C1
D7D5: 24 26       BCC    $D7FD
D7D7: 86 79       LDA    #$79
D7D9: A7 47       STA    $7,U
D7DB: 39          RTS
D7DC: EC 5A       LDD    -$6,U
D7DE: E3 26       ADDD   $6,Y
D7E0: A3 0A       SUBD   $A,X
D7E2: B3 E6 4E    SUBD   $E64E
D7E5: 2A DE       BPL    $D7C5
D7E7: 53          COMB
D7E8: 43          COMA
D7E9: C3 00 01    ADDD   #$0001
D7EC: 10 A3 28    CMPD   $8,Y
D7EF: 22 11       BHI    $D802
D7F1: 96 15       LDA    $15
D7F3: 8B 20       ADDA   #$20
D7F5: 97 15       STA    $15
D7F7: 9B 14       ADDA   $14
D7F9: 91 C1       CMPA   $C1
D7FB: 25 DA       BCS    $D7D7
D7FD: 86 61       LDA    #$61
D7FF: A7 47       STA    $7,U
D801: 39          RTS
D802: 4F          CLRA
D803: 39          RTS
D804: A6 41       LDA    $1,U
D806: 84 02       ANDA   #$02
D808: 26 22       BNE    $D82C
D80A: EC 5A       LDD    -$6,U
D80C: E3 24       ADDD   $4,Y
D80E: A3 0A       SUBD   $A,X
D810: B3 E6 50    SUBD   $E650
D813: 2B 22       BMI    $D837
D815: 10 B3 E6 52 CMPD   $E652
D819: 22 E7       BHI    $D802
D81B: 96 15       LDA    $15
D81D: 8B 20       ADDA   #$20
D81F: 97 15       STA    $15
D821: 9B 14       ADDA   $14
D823: 91 C1       CMPA   $C1
D825: 25 26       BCS    $D84D
D827: 86 62       LDA    #$62
D829: A7 47       STA    $7,U
D82B: 39          RTS
D82C: EC 5A       LDD    -$6,U
D82E: E3 26       ADDD   $6,Y
D830: A3 0A       SUBD   $A,X
D832: B3 E6 50    SUBD   $E650
D835: 2A DE       BPL    $D815
D837: 53          COMB
D838: 43          COMA
D839: C3 00 01    ADDD   #$0001
D83C: 10 A3 28    CMPD   $8,Y
D83F: 22 C1       BHI    $D802
D841: 96 15       LDA    $15
D843: 8B 20       ADDA   #$20
D845: 97 15       STA    $15
D847: 9B 14       ADDA   $14
D849: 91 C1       CMPA   $C1
D84B: 24 DA       BCC    $D827
D84D: 86 7A       LDA    #$7A
D84F: A7 47       STA    $7,U
D851: 39          RTS

; called 1x  from $D633
function_d852:
D852: CE 04 10    LDU    #$0410		; work RAM (shared with CPU1 $4400)
D855: A6 C4       LDA    ,U
D857: 2B 22       BMI    $D87B
D859: E6 4B       LDB    $B,U
D85B: 2B 1E       BMI    $D87B
D85D: A6 4D       LDA    $D,U
D85F: 26 1A       BNE    $D87B
D861: A6 45       LDA    $5,U
D863: A1 04       CMPA   $4,X
D865: 26 14       BNE    $D87B
D867: 4F          CLRA
D868: 58          ASLB
D869: 49          ROLA
D86A: ED E3       STD    ,--S		; [local]
D86C: 58          ASLB
D86D: 49          ROLA
D86E: 58          ASLB
D86F: 49          ROLA
D870: E3 E1       ADDD   ,S++		; [local]
D872: 10 8E E1 40 LDY    #$E140		; ROM
D876: 31 AB       LEAY   D,Y
D878: 7E D8 7D    JMP    $D87D
D87B: 4F          CLRA
D87C: 39          RTS
D87D: EC 5C       LDD    -$4,U
D87F: E3 A4       ADDD   ,Y
D881: A3 0C       SUBD   $C,X
D883: B3 E6 54    SUBD   $E654
D886: 2B 08       BMI    $D890
D888: 10 B3 E6 56 CMPD   $E656
D88C: 23 0C       BLS    $D89A
D88E: 4F          CLRA
D88F: 39          RTS
D890: 53          COMB
D891: 43          COMA
D892: C3 00 01    ADDD   #$0001
D895: 10 A3 22    CMPD   $2,Y
D898: 22 F4       BHI    $D88E
D89A: 6D 06       TST    $6,X
D89C: 2B 50       BMI    $D8EE
D89E: A6 41       LDA    $1,U
D8A0: 84 02       ANDA   #$02
D8A2: 26 22       BNE    $D8C6
D8A4: EC 5A       LDD    -$6,U
D8A6: E3 24       ADDD   $4,Y
D8A8: A3 0A       SUBD   $A,X
D8AA: B3 E6 58    SUBD   $E658
D8AD: 2B 22       BMI    $D8D1
D8AF: 10 B3 E6 5C CMPD   $E65C
D8B3: 22 37       BHI    $D8EC
D8B5: 96 15       LDA    $15
D8B7: 8B 20       ADDA   #$20
D8B9: 97 15       STA    $15
D8BB: 9B 14       ADDA   $14
D8BD: 91 C1       CMPA   $C1
D8BF: 24 26       BCC    $D8E7
D8C1: 86 79       LDA    #$79
D8C3: A7 47       STA    $7,U
D8C5: 39          RTS
D8C6: EC 5A       LDD    -$6,U
D8C8: E3 26       ADDD   $6,Y
D8CA: A3 0A       SUBD   $A,X
D8CC: B3 E6 58    SUBD   $E658
D8CF: 2A DE       BPL    $D8AF
D8D1: 53          COMB
D8D2: 43          COMA
D8D3: C3 00 01    ADDD   #$0001
D8D6: 10 A3 28    CMPD   $8,Y
D8D9: 22 11       BHI    $D8EC
D8DB: 96 15       LDA    $15
D8DD: 8B 20       ADDA   #$20
D8DF: 97 15       STA    $15
D8E1: 9B 14       ADDA   $14
D8E3: 91 C1       CMPA   $C1
D8E5: 25 DA       BCS    $D8C1
D8E7: 86 61       LDA    #$61
D8E9: A7 47       STA    $7,U
D8EB: 39          RTS
D8EC: 4F          CLRA
D8ED: 39          RTS
D8EE: A6 41       LDA    $1,U
D8F0: 84 02       ANDA   #$02
D8F2: 26 22       BNE    $D916
D8F4: EC 5A       LDD    -$6,U
D8F6: E3 24       ADDD   $4,Y
D8F8: A3 0A       SUBD   $A,X
D8FA: B3 E6 5A    SUBD   $E65A
D8FD: 2B 22       BMI    $D921
D8FF: 10 B3 E6 5C CMPD   $E65C
D903: 22 E7       BHI    $D8EC
D905: 96 15       LDA    $15
D907: 8B 20       ADDA   #$20
D909: 97 15       STA    $15
D90B: 9B 14       ADDA   $14
D90D: 91 C1       CMPA   $C1
D90F: 25 26       BCS    $D937
D911: 86 62       LDA    #$62
D913: A7 47       STA    $7,U
D915: 39          RTS
D916: EC 5A       LDD    -$6,U
D918: E3 26       ADDD   $6,Y
D91A: A3 0A       SUBD   $A,X
D91C: B3 E6 5A    SUBD   $E65A
D91F: 2A DE       BPL    $D8FF
D921: 53          COMB
D922: 43          COMA
D923: C3 00 01    ADDD   #$0001
D926: 10 A3 28    CMPD   $8,Y
D929: 22 C1       BHI    $D8EC
D92B: 96 15       LDA    $15
D92D: 8B 20       ADDA   #$20
D92F: 97 15       STA    $15
D931: 9B 14       ADDA   $14
D933: 91 C1       CMPA   $C1
D935: 24 DA       BCC    $D911
D937: 86 7A       LDA    #$7A
D939: A7 47       STA    $7,U
D93B: 39          RTS

jump_table_81ad:
	dc.w	cpu2_reset_all_tables_80a8	; $81ad
	dc.w	function_852a	; $81af
	dc.w	function_854f	; $81b1
	dc.w	function_8768	; $81b3
	dc.w	function_8800	; $81b5
	dc.w	function_88c4	; $81b7
	dc.w	function_88e9	; $81b9
	dc.w	function_9652	; $81bb
	dc.w	function_9b53	; $81bd


jump_table_8333:
	dc.w	function_8343	; $8333
	dc.w	function_8343	; $8335
	dc.w	function_8343	; $8337
	dc.w	function_8343	; $8339
	dc.w	function_8423	; $833b
	dc.w	function_8423	; $833d
	dc.w	function_83d5	; $833f
	dc.w	function_83d5	; $8341
jump_table_8537:
	dc.w	function_853b	; $8537
	dc.w	function_854e	; $8539
jump_table_8561:
	dc.w	function_8567	; $8561
	dc.w	function_858d	; $8563
	dc.w	function_85cb	; $8565
jump_table_86fd:
	dc.w	function_cdd3	; $86fd
	dc.w	function_ccaa	; $86ff
	dc.w	function_cdd3	; $8701
	dc.w	function_cdd3	; $8703
	dc.w	function_cdd3	; $8705
	dc.w	function_cdd3	; $8707
	dc.w	function_cde7	; $8709
	dc.w	function_cde7	; $870b
	dc.w	function_cdd3	; $870d
	dc.w	function_cdd3	; $870f
	dc.w	function_cdd3	; $8711
	dc.w	function_cdd3	; $8713
	dc.w	function_cdd3	; $8715
	dc.w	function_cdd3	; $8717
	dc.w	function_cdd3	; $8719
	dc.w	function_cdd3	; $871b
	dc.w	function_ccaa	; $871d
	dc.w	function_ce3a	; $871f
	dc.w	function_cdfb	; $8721
	dc.w	function_ce26	; $8723
	dc.w	function_cdd3	; $8725
	dc.w	function_cdd3	; $8727
	dc.w	function_cdd3	; $8729
	dc.w	function_cdd3	; $872b
	dc.w	function_ce7e	; $872d
	dc.w	function_ce7e	; $872f
	dc.w	function_ce7e	; $8731
	dc.w	function_ce7e	; $8733
	dc.w	function_8767	; $8735
	dc.w	function_8767	; $8737
	dc.w	function_8767	; $8739
	dc.w	function_8767	; $873b
	dc.w	function_cdd3	; $873d
	dc.w	function_cdd3	; $873f
	dc.w	function_cdd3	; $8741
	dc.w	function_cdd3	; $8743
	dc.w	function_cdd3	; $8745
	dc.w	function_cdd3	; $8747
	dc.w	function_cdd3	; $8749
	dc.w	function_ccce	; $874b
	dc.w	function_cdd3	; $874d
	dc.w	function_cdd3	; $874f
	dc.w	function_cdd3	; $8751
	dc.w	function_cdd3	; $8753
	dc.w	function_8767	; $8755
	dc.w	function_8767	; $8757
	dc.w	function_8767	; $8759
	dc.w	function_8767	; $875b
	dc.w	function_8767	; $875d
	dc.w	function_8767	; $875f
	dc.w	function_8767	; $8761
	dc.w	function_8767	; $8763
	dc.w	function_8767	; $8765
jump_table_8775:
	dc.w	function_8789	; $8775
	dc.w	function_89c4	; $8777
	dc.w	function_89c5	; $8779
	dc.w	function_8a71	; $877b
	dc.w	function_84a7	; $877d
	dc.w	function_8790	; $877f
	dc.w	function_879a	; $8781
	dc.w	function_87e0	; $8783
	dc.w	function_87e5	; $8785
	dc.w	function_87f4	; $8787
jump_table_880d:
	dc.w	function_881b	; $880d
	dc.w	function_882e	; $880f
	dc.w	function_882f	; $8811
	dc.w	function_8830	; $8813
	dc.w	function_8853	; $8815
	dc.w	function_888f	; $8817
	dc.w	function_8898	; $8819
jump_table_88d1:
	dc.w	function_88d5	; $88d1
	dc.w	function_88e8	; $88d3
jump_table_88f6:
	dc.w	function_8910	; $88f6
	dc.w	function_898f	; $88f8
	dc.w	function_89c3	; $88fa
	dc.w	function_89c4	; $88fc
	dc.w	function_89c5	; $88fe
	dc.w	function_8a71	; $8900
	dc.w	function_84a7	; $8902
	dc.w	function_8a94	; $8904
	dc.w	function_8917	; $8906
	dc.w	function_8990	; $8908
	dc.w	function_8a95	; $890a
	dc.w	function_89ca	; $890c
	dc.w	function_8b1f	; $890e
jump_table_899d:
	dc.w	function_89a5	; $899d
	dc.w	function_89a8	; $899f
	dc.w	function_89b4	; $89a1
	dc.w	function_89c2	; $89a3
jump_table_89d7:
	dc.w	function_89eb	; $89d7
	dc.w	function_89ee	; $89d9
	dc.w	function_89fa	; $89db
	dc.w	function_8a08	; $89dd
	dc.w	function_8a09	; $89df
	dc.w	function_8a0a	; $89e1
	dc.w	function_8a2e	; $89e3
	dc.w	function_8a66	; $89e5
	dc.w	function_8a6f	; $89e7
	dc.w	function_8a70	; $89e9
jump_table_8a7e:
	dc.w	function_8a82	; $8a7e
	dc.w	function_8a93	; $8a80
jump_table_8aa2:
	dc.w	function_8ab6	; $8aa2
	dc.w	function_8ab7	; $8aa4
	dc.w	function_8ab8	; $8aa6
	dc.w	function_8ab9	; $8aa8
	dc.w	function_8ada	; $8aaa
	dc.w	function_8b12	; $8aac
	dc.w	function_8b1b	; $8aae
	dc.w	function_8b1c	; $8ab0
	dc.w	function_8b1d	; $8ab2
	dc.w	function_8b1e	; $8ab4
jump_table_8b2c:
	dc.w	function_8b44	; $8b2c
	dc.w	function_8b47	; $8b2e
	dc.w	function_8b53	; $8b30
	dc.w	function_8b61	; $8b32
	dc.w	function_8b62	; $8b34
	dc.w	function_8b63	; $8b36
	dc.w	function_8b64	; $8b38
	dc.w	function_8b88	; $8b3a
	dc.w	function_8ba0	; $8b3c
	dc.w	function_8ba9	; $8b3e
	dc.w	function_8baa	; $8b40
	dc.w	function_8bab	; $8b42
jump_table_9951:
	dc.w	function_9a28	; $9951
	dc.w	function_9a90	; $9953
	dc.w	function_ab4f	; $9955
	dc.w	function_a137	; $9957
	dc.w	function_a14b	; $9959
	dc.w	function_a15f	; $995b
	dc.w	function_a1a3	; $995d
	dc.w	function_a396	; $995f
	dc.w	function_a81b	; $9961
	dc.w	function_a83d	; $9963
	dc.w	function_a914	; $9965
	dc.w	function_aa6b	; $9967
	dc.w	function_aade	; $9969
	dc.w	function_a9b0	; $996b
	dc.w	function_ab5c	; $996d
	dc.w	function_ab5d	; $996f
	dc.w	function_9a90	; $9971
	dc.w	function_a1a3	; $9973
	dc.w	function_ab5e	; $9975
	dc.w	function_9bf6	; $9977
	dc.w	function_9ce3	; $9979
	dc.w	function_ab5f	; $997b
	dc.w	function_9e46	; $997d
	dc.w	function_9f7f	; $997f
	dc.w	function_ab74	; $9981
	dc.w	function_ab74	; $9983
	dc.w	function_ab74	; $9985
	dc.w	function_ab74	; $9987
	dc.w	function_9a28	; $9989
	dc.w	function_9a28	; $998b
	dc.w	function_ac40	; $998d
	dc.w	function_9a28	; $998f
	dc.w	function_9a28	; $9991
	dc.w	function_9a28	; $9993
	dc.w	function_9a28	; $9995
	dc.w	function_9a28	; $9997
	dc.w	function_9a28	; $9999
	dc.w	function_9a28	; $999b
	dc.w	function_9a28	; $999d
	dc.w	function_9b56	; $999f
	dc.w	function_a50d	; $99a1
	dc.w	function_a6b6	; $99a3
	dc.w	function_a02f	; $99a5
	dc.w	function_a0a7	; $99a7
	dc.w	function_9a28	; $99a9
	dc.w	function_9a28	; $99ab
	dc.w	function_9a28	; $99ad
	dc.w	function_9a28	; $99af
	dc.w	function_9a28	; $99b1
	dc.w	function_9a28	; $99b3
	dc.w	function_9a28	; $99b5
	dc.w	function_9a28	; $99b7
	dc.w	function_9a28	; $99b9
	dc.w	function_9a25	; $99bb
	dc.w	function_9a3c	; $99bd
	dc.w	function_9db2	; $99bf
	dc.w	function_9e2f	; $99c1
	dc.w	function_a131	; $99c3
	dc.w	function_a134	; $99c5
	dc.w	player_shoots_a173	; $99c7
	dc.w	function_a366	; $99c9
	dc.w	function_a813	; $99cb
	dc.w	function_a813	; $99cd
	dc.w	function_a8c5	; $99cf
	dc.w	function_aa18	; $99d1
	dc.w	function_aa52	; $99d3
	dc.w	function_a8f2	; $99d5
	dc.w	function_8dc8	; $99d7
	dc.w	function_8dc8	; $99d9
	dc.w	function_9a3c	; $99db
	dc.w	player_shoots_a173	; $99dd
	dc.w	function_8dc8	; $99df
	dc.w	function_9b86	; $99e1
	dc.w	function_9bbe	; $99e3
	dc.w	function_8dc8	; $99e5
	dc.w	function_8dc8	; $99e7
	dc.w	function_8dc8	; $99e9
	dc.w	function_ab60	; $99eb
	dc.w	function_ab60	; $99ed
	dc.w	function_ab60	; $99ef
	dc.w	function_ab60	; $99f1
	dc.w	function_8dc8	; $99f3
	dc.w	function_8dc8	; $99f5
	dc.w	function_ac17	; $99f7
	dc.w	function_8dc8	; $99f9
	dc.w	function_8dc8	; $99fb
	dc.w	function_8dc8	; $99fd
	dc.w	function_8dc8	; $99ff
	dc.w	function_8dc8	; $9a01
	dc.w	function_8dc8	; $9a03
	dc.w	function_8dc8	; $9a05
	dc.w	function_8dc8	; $9a07
	dc.w	function_9a3c	; $9a09
	dc.w	player_shoots_a173	; $9a0b
	dc.w	function_a366	; $9a0d
	dc.w	function_8dc8	; $9a0f
	dc.w	function_8dc8	; $9a11
	dc.w	function_8dc8	; $9a13
	dc.w	function_8dc8	; $9a15
	dc.w	function_8dc8	; $9a17
	dc.w	function_8dc8	; $9a19
	dc.w	function_8dc8	; $9a1b
	dc.w	function_8dc8	; $9a1d
	dc.w	function_8dc8	; $9a1f
	dc.w	function_8dc8	; $9a21
	dc.w	function_8dc8	; $9a23
jump_table_99bb:
	dc.w	function_9a25	; $99bb
	dc.w	function_9a3c	; $99bd
	dc.w	function_9db2	; $99bf
	dc.w	function_9e2f	; $99c1
	dc.w	function_a131	; $99c3
	dc.w	function_a134	; $99c5
	dc.w	player_shoots_a173	; $99c7
	dc.w	function_a366	; $99c9
	dc.w	function_a813	; $99cb
	dc.w	function_a813	; $99cd
	dc.w	function_a8c5	; $99cf
	dc.w	function_aa18	; $99d1
	dc.w	function_aa52	; $99d3
	dc.w	function_a8f2	; $99d5
	dc.w	function_8dc8	; $99d7
	dc.w	function_8dc8	; $99d9
	dc.w	function_9a3c	; $99db
	dc.w	player_shoots_a173	; $99dd
	dc.w	function_8dc8	; $99df
	dc.w	function_9b86	; $99e1
	dc.w	function_9bbe	; $99e3
	dc.w	function_8dc8	; $99e5
	dc.w	function_8dc8	; $99e7
	dc.w	function_8dc8	; $99e9
	dc.w	function_ab60	; $99eb
	dc.w	function_ab60	; $99ed
	dc.w	function_ab60	; $99ef
	dc.w	function_ab60	; $99f1
	dc.w	function_8dc8	; $99f3
	dc.w	function_8dc8	; $99f5
	dc.w	function_ac17	; $99f7
	dc.w	function_8dc8	; $99f9
	dc.w	function_8dc8	; $99fb
	dc.w	function_8dc8	; $99fd
	dc.w	function_8dc8	; $99ff
	dc.w	function_8dc8	; $9a01
	dc.w	function_8dc8	; $9a03
	dc.w	function_8dc8	; $9a05
	dc.w	function_8dc8	; $9a07
	dc.w	function_9a3c	; $9a09
	dc.w	player_shoots_a173	; $9a0b
	dc.w	function_a366	; $9a0d
	dc.w	function_8dc8	; $9a0f
	dc.w	function_8dc8	; $9a11
	dc.w	function_8dc8	; $9a13
	dc.w	function_8dc8	; $9a15
	dc.w	function_8dc8	; $9a17
	dc.w	function_8dc8	; $9a19
	dc.w	function_8dc8	; $9a1b
	dc.w	function_8dc8	; $9a1d
	dc.w	function_8dc8	; $9a1f
	dc.w	function_8dc8	; $9a21
	dc.w	function_8dc8	; $9a23
jump_table_9c23:
	dc.w	function_9c4d	; $9c23
	dc.w	function_9c4d	; $9c25
	dc.w	function_9c3b	; $9c27
	dc.w	function_9c4d	; $9c29
	dc.w	function_9c4d	; $9c2b
	dc.w	function_9c6b	; $9c2d
	dc.w	function_9c65	; $9c2f
	dc.w	function_9c65	; $9c31
	dc.w	function_9c53	; $9c33
	dc.w	function_9c65	; $9c35
	dc.w	function_9c65	; $9c37
	dc.w	function_9c96	; $9c39
jump_table_9c2f:
	dc.w	function_9c65	; $9c2f
	dc.w	function_9c65	; $9c31
	dc.w	function_9c53	; $9c33
	dc.w	function_9c65	; $9c35
	dc.w	function_9c65	; $9c37
	dc.w	function_9c96	; $9c39

jump_table_9d10:
	dc.w	function_9d3a	; $9d10
	dc.w	function_9d28	; $9d12
	dc.w	function_9d3a	; $9d14
	dc.w	function_9d3a	; $9d16
	dc.w	function_9d28	; $9d18
	dc.w	function_9d5e	; $9d1a
	dc.w	function_9d52	; $9d1c
	dc.w	function_9d40	; $9d1e
	dc.w	function_9d52	; $9d20
	dc.w	function_9d52	; $9d22
	dc.w	function_9d40	; $9d24
	dc.w	function_9d77	; $9d26
jump_table_9d1c:
	dc.w	function_9d52	; $9d1c
	dc.w	function_9d40	; $9d1e
	dc.w	function_9d52	; $9d20
	dc.w	function_9d52	; $9d22
	dc.w	function_9d40	; $9d24
	dc.w	function_9d77	; $9d26

jump_table_a013:
	dc.w	function_9e79	; $a013
	dc.w	function_9e8c	; $a015
	dc.w	function_9e8c	; $a017
	dc.w	function_9e8c	; $a019
	dc.w	function_9eaa	; $a01b
	dc.w	function_9ecb	; $a01d
	dc.w	function_9ee2	; $a01f
	dc.w	function_9f4c	; $a021
	dc.w	function_9fa6	; $a023
	dc.w	function_9fbb	; $a025
	dc.w	function_9fbb	; $a027
	dc.w	function_9fbb	; $a029
	dc.w	function_9fbb	; $a02b
	dc.w	function_9fdf	; $a02d

jump_table_a023:
	dc.w	function_9fa6	; $a023
	dc.w	function_9fbb	; $a025
	dc.w	function_9fbb	; $a027
	dc.w	function_9fbb	; $a029
	dc.w	function_9fbb	; $a02b
	dc.w	function_9fdf	; $a02d

jump_table_a119:
	dc.w	function_a061	; $a119
	dc.w	function_a067	; $a11b
	dc.w	function_a067	; $a11d
	dc.w	function_a067	; $a11f
	dc.w	function_a07c	; $a121
	dc.w	function_a095	; $a123
	dc.w	function_a0d3	; $a125
	dc.w	function_a0d9	; $a127
	dc.w	function_a0d9	; $a129
	dc.w	function_a0d9	; $a12b
	dc.w	function_a0f2	; $a12d
	dc.w	function_a107	; $a12f
jump_table_a125:
	dc.w	function_a0d3	; $a125
	dc.w	function_a0d9	; $a127
	dc.w	function_a0d9	; $a129
	dc.w	function_a0d9	; $a12b
	dc.w	function_a0f2	; $a12d
	dc.w	function_a107	; $a12f
jump_table_a1ad:
	dc.w	function_a1b7	; $a1ad
	dc.w	function_a1bf	; $a1af
	dc.w	function_a1cd	; $a1b1
	dc.w	function_a1b7	; $a1b3
	dc.w	function_a1db	; $a1b5
jump_table_a35e:
	dc.w	function_a1ed	; $a35e
	dc.w	function_a1f8	; $a360
	dc.w	function_a21a	; $a362
	dc.w	function_a235	; $a364

jump_table_a505:
	dc.w	function_a3e0	; $a505
	dc.w	function_a3eb	; $a507
	dc.w	function_a40d	; $a509
	dc.w	function_a428	; $a50b
jump_table_a3a0:
	dc.w	function_a3aa	; $a3a0
	dc.w	function_a3b2	; $a3a2
	dc.w	function_a3c0	; $a3a4
	dc.w	function_a3ce	; $a3a6
	dc.w	function_a3aa	; $a3a8
jump_table_a51b:
	dc.w	function_a525	; $a51b
	dc.w	function_a52d	; $a51d
	dc.w	function_a53b	; $a51f
	dc.w	function_a525	; $a521
	dc.w	function_a549	; $a523
jump_table_a6ae:
	dc.w	function_a578	; $a6ae
	dc.w	function_a583	; $a6b0
	dc.w	function_a5a5	; $a6b2
	dc.w	function_a5c0	; $a6b4
jump_table_a80b:
	dc.w	function_a721	; $a80b
	dc.w	function_a72c	; $a80d
	dc.w	function_a74e	; $a80f
	dc.w	function_a769	; $a811
	dc.w	function_cc00	; $a813
jump_table_a6c4:
	dc.w	function_a6ce	; $a6c4
	dc.w	function_a6d6	; $a6c6
	dc.w	function_a6e4	; $a6c8
	dc.w	function_a6f2	; $a6ca
	dc.w	function_a6ce	; $a6cc
jump_table_a82f:
	dc.w	function_a877	; $a82f
	dc.w	function_a88e	; $a831
	dc.w	function_a8a3	; $a833
jump_table_a871:
	dc.w	function_a877	; $a871
	dc.w	function_a88e	; $a873
	dc.w	function_a8a3	; $a875
jump_table_a9fe:
	dc.w	function_a91c	; $a9fe
	dc.w	function_a927	; $aa00
	dc.w	function_a943	; $aa02
	dc.w	function_a958	; $aa04
	dc.w	function_a958	; $aa06
	dc.w	function_a963	; $aa08
	dc.w	function_a958	; $aa0a
	dc.w	function_a958	; $aa0c
	dc.w	function_a991	; $aa0e
	dc.w	function_a99c	; $aa10
	dc.w	function_a9b8	; $aa12
	dc.w	function_a9d3	; $aa14
	dc.w	function_a9ea	; $aa16
	dc.w	function_a601	; $aa18
	dc.w	function_a107	; $aa1a
jump_table_aa12:
	dc.w	function_a9b8	; $aa12
	dc.w	function_a9d3	; $aa14
	dc.w	function_a9ea	; $aa16
	dc.w	function_a601	; $aa18
	dc.w	function_a107	; $aa1a
jump_table_ab3b:
	dc.w	function_aa73	; $ab3b
	dc.w	function_aa7e	; $ab3d
	dc.w	function_aa73	; $ab3f
	dc.w	function_aa73	; $ab41
	dc.w	function_aa9d	; $ab43
	dc.w	function_aab3	; $ab45
	dc.w	function_aaca	; $ab47
	dc.w	function_aaf2	; $ab49
	dc.w	function_ab10	; $ab4b
	dc.w	function_ab27	; $ab4d
jump_table_ab49:
	dc.w	function_aaf2	; $ab49
	dc.w	function_ab10	; $ab4b
	dc.w	function_ab27	; $ab4d
jump_table_ab7c:
	dc.w	function_ab8c	; $ab7c
	dc.w	function_aba3	; $ab7e
	dc.w	function_abb0	; $ab80
	dc.w	function_abb0	; $ab82
	dc.w	function_abb0	; $ab84
	dc.w	function_abb0	; $ab86
	dc.w	function_abbb	; $ab88
	dc.w	function_abc3	; $ab8a
jump_table_ac48:
	dc.w	function_ac4e	; $ac48
	dc.w	function_ac6c	; $ac4a
	dc.w	function_ac88	; $ac4c
jump_table_ad10:
	dc.w	function_ad49	; $ad10
	dc.w	function_ad30	; $ad12
	dc.w	function_ad4f	; $ad14
	dc.w	function_ad49	; $ad16
	dc.w	function_ad6e	; $ad18
	dc.w	function_ad8d	; $ad1a
	dc.w	function_ad92	; $ad1c
	dc.w	function_ad49	; $ad1e
	dc.w	function_ad97	; $ad20
	dc.w	function_adb6	; $ad22
	dc.w	function_adbb	; $ad24
	dc.w	function_ad49	; $ad26
	dc.w	function_ad49	; $ad28
	dc.w	function_ad49	; $ad2a
	dc.w	function_ad49	; $ad2c
	dc.w	function_ad49	; $ad2e
jump_table_add4:
	dc.w	function_adf4	; $add4
	dc.w	function_ae35	; $add6
	dc.w	function_adf5	; $add8
	dc.w	function_adf4	; $adda
	dc.w	function_af55	; $addc
	dc.w	function_afe5	; $adde
	dc.w	function_af95	; $ade0
	dc.w	function_adf4	; $ade2
	dc.w	function_ae75	; $ade4
	dc.w	function_af05	; $ade6
	dc.w	function_aeb5	; $ade8
	dc.w	function_adf4	; $adea
	dc.w	function_adf4	; $adec
	dc.w	function_adf4	; $adee
	dc.w	function_adf4	; $adf0
	dc.w	function_adf4	; $adf2
jump_table_b0dc:
	dc.w	function_b0e6	; $b0dc
	dc.w	function_b0ee	; $b0de
	dc.w	function_b116	; $b0e0
	dc.w	function_b13d	; $b0e2
	dc.w	function_b165	; $b0e4
jump_table_b3d1:
	dc.w	function_cd88	; $b3d1
	dc.w	function_ccaa	; $b3d3
	dc.w	function_cd88	; $b3d5
	dc.w	function_cd88	; $b3d7
	dc.w	function_cd88	; $b3d9
	dc.w	function_cd88	; $b3db
	dc.w	function_cde7	; $b3dd
	dc.w	function_cde7	; $b3df
	dc.w	function_cd88	; $b3e1
	dc.w	function_cd88	; $b3e3
	dc.w	function_cd88	; $b3e5
	dc.w	function_cd88	; $b3e7
	dc.w	function_cd88	; $b3e9
	dc.w	function_cd88	; $b3eb
	dc.w	function_cd88	; $b3ed
	dc.w	function_cd88	; $b3ef
	dc.w	function_cd21	; $b3f1
	dc.w	function_ce3a	; $b3f3
	dc.w	function_cdfb	; $b3f5
	dc.w	function_ce26	; $b3f7
	dc.w	function_cd88	; $b3f9
	dc.w	function_cd88	; $b3fb
	dc.w	function_cd88	; $b3fd
	dc.w	function_cd88	; $b3ff
	dc.w	function_ce7e	; $b401
	dc.w	function_ce7e	; $b403
	dc.w	function_ce7e	; $b405
	dc.w	function_ce7e	; $b407
	dc.w	function_cd88	; $b409
	dc.w	function_cd88	; $b40b
	dc.w	function_cd88	; $b40d
	dc.w	function_cd88	; $b40f
	dc.w	function_cd88	; $b411
	dc.w	function_cd88	; $b413
	dc.w	function_cd88	; $b415
	dc.w	function_cd88	; $b417
	dc.w	function_cd88	; $b419
	dc.w	function_cd88	; $b41b
	dc.w	function_cd88	; $b41d
	dc.w	function_ccce	; $b41f
	dc.w	function_cd88	; $b421
	dc.w	function_cd88	; $b423
	dc.w	function_cd88	; $b425
	dc.w	function_cd88	; $b427

jump_table_b44f:
	dc.w	function_bbc8	; $b44f
	dc.w	function_b523	; $b451
	dc.w	function_bc86	; $b453
	dc.w	function_8dc8	; $b455
	dc.w	function_beb1	; $b457
	dc.w	function_8dc8	; $b459
	dc.w	function_b8f2	; $b45b
	dc.w	function_b95a	; $b45d
	dc.w	function_b6dd	; $b45f
	dc.w	function_b6dd	; $b461
	dc.w	function_b718	; $b463
	dc.w	function_b808	; $b465
	dc.w	function_b810	; $b467
	dc.w	function_b720	; $b469
	dc.w	function_8dc8	; $b46b
	dc.w	function_bd5f	; $b46d
	dc.w	function_b523	; $b46f
	dc.w	function_bb6a	; $b471
	dc.w	function_8dc8	; $b473
	dc.w	function_bf1d	; $b475
	dc.w	function_c019	; $b477
	dc.w	function_8dc8	; $b479
	dc.w	function_c0d2	; $b47b
	dc.w	function_c0d5	; $b47d
	dc.w	function_c31a	; $b47f
	dc.w	function_c31a	; $b481
	dc.w	function_c31a	; $b483
	dc.w	function_8dc8	; $b485
	dc.w	function_bbdd	; $b487
	dc.w	function_b706	; $b489
	dc.w	function_c600	; $b48b
	dc.w	function_c600	; $b48d
	dc.w	function_8dc8	; $b48f
	dc.w	function_c78d	; $b491
	dc.w	function_c78d	; $b493
	dc.w	function_cac2	; $b495
	dc.w	function_cafe	; $b497
	dc.w	function_cb9a	; $b499
	dc.w	function_c5e7	; $b49b
	dc.w	function_b523	; $b49d
	dc.w	function_b8f2	; $b49f
	dc.w	function_b95a	; $b4a1
	dc.w	function_c275	; $b4a3
	dc.w	function_c278	; $b4a5
	dc.w	function_8dc8	; $b4a7
	dc.w	function_8dc8	; $b4a9
	dc.w	function_8dc8	; $b4ab
	dc.w	function_8dc8	; $b4ad
	dc.w	function_8dc8	; $b4af
	dc.w	function_8dc8	; $b4b1
	dc.w	function_8dc8	; $b4b3
	dc.w	function_8dc8	; $b4b5
	dc.w	function_8dc8	; $b4b7
	dc.w	function_cd75	; $b4b9
	dc.w	function_cc94	; $b4bb
	dc.w	function_8dc8	; $b4bd
	dc.w	function_8dc8	; $b4bf
	dc.w	function_8dc8	; $b4c1
	dc.w	function_8dc8	; $b4c3
	dc.w	function_8dc8	; $b4c5
	dc.w	function_8dc8	; $b4c7
	dc.w	function_8dc8	; $b4c9
	dc.w	function_8dc8	; $b4cb
	dc.w	function_8dc8	; $b4cd
	dc.w	function_8dc8	; $b4cf
	dc.w	function_8dc8	; $b4d1
	dc.w	function_8dc8	; $b4d3
	dc.w	function_8dc8	; $b4d5
	dc.w	function_8dc8	; $b4d7
	dc.w	function_cd0b	; $b4d9
	dc.w	function_8dc8	; $b4db
	dc.w	function_8dc8	; $b4dd
	dc.w	function_8dc8	; $b4df
	dc.w	function_8dc8	; $b4e1
	dc.w	function_8dc8	; $b4e3
	dc.w	function_8dc8	; $b4e5
	dc.w	function_8dc8	; $b4e7
	dc.w	function_ce59	; $b4e9
	dc.w	function_ce59	; $b4eb
	dc.w	function_ce59	; $b4ed
	dc.w	function_8dc8	; $b4ef
	dc.w	function_8dc8	; $b4f1
	dc.w	function_8dc8	; $b4f3
	dc.w	function_ce9e	; $b4f5
	dc.w	function_ce9e	; $b4f7
	dc.w	function_8dc8	; $b4f9
	dc.w	function_8dc8	; $b4fb
	dc.w	function_8dc8	; $b4fd
	dc.w	function_8dc8	; $b4ff
	dc.w	function_8dc8	; $b501
	dc.w	function_8dc8	; $b503
	dc.w	function_8dc8	; $b505
	dc.w	function_8dc8	; $b507
	dc.w	function_8dc8	; $b509
	dc.w	function_8dc8	; $b50b
	dc.w	function_8dc8	; $b50d
	dc.w	function_8dc8	; $b50f
	dc.w	function_8dc8	; $b511
	dc.w	function_8dc8	; $b513
	dc.w	function_8dc8	; $b515
	dc.w	function_8dc8	; $b517
	dc.w	function_8dc8	; $b519
	dc.w	function_8dc8	; $b51b
	dc.w	function_8dc8	; $b51d
	dc.w	function_8dc8	; $b51f
	dc.w	function_8dc8	; $b521
jump_table_b4b9:
	dc.w	function_cd75	; $b4b9
	dc.w	function_cc94	; $b4bb
	dc.w	function_8dc8	; $b4bd
	dc.w	function_8dc8	; $b4bf
	dc.w	function_8dc8	; $b4c1
	dc.w	function_8dc8	; $b4c3
	dc.w	function_8dc8	; $b4c5
	dc.w	function_8dc8	; $b4c7
	dc.w	function_8dc8	; $b4c9
	dc.w	function_8dc8	; $b4cb
	dc.w	function_8dc8	; $b4cd
	dc.w	function_8dc8	; $b4cf
	dc.w	function_8dc8	; $b4d1
	dc.w	function_8dc8	; $b4d3
	dc.w	function_8dc8	; $b4d5
	dc.w	function_8dc8	; $b4d7
	dc.w	function_cd0b	; $b4d9
	dc.w	function_8dc8	; $b4db
	dc.w	function_8dc8	; $b4dd
	dc.w	function_8dc8	; $b4df
	dc.w	function_8dc8	; $b4e1
	dc.w	function_8dc8	; $b4e3
	dc.w	function_8dc8	; $b4e5
	dc.w	function_8dc8	; $b4e7
	dc.w	function_ce59	; $b4e9
	dc.w	function_ce59	; $b4eb
	dc.w	function_ce59	; $b4ed
	dc.w	function_8dc8	; $b4ef
	dc.w	function_8dc8	; $b4f1
	dc.w	function_8dc8	; $b4f3
	dc.w	function_ce9e	; $b4f5
	dc.w	function_ce9e	; $b4f7
	dc.w	function_8dc8	; $b4f9
	dc.w	function_8dc8	; $b4fb
	dc.w	function_8dc8	; $b4fd
	dc.w	function_8dc8	; $b4ff
	dc.w	function_8dc8	; $b501
	dc.w	function_8dc8	; $b503
	dc.w	function_8dc8	; $b505
	dc.w	function_8dc8	; $b507
	dc.w	function_8dc8	; $b509
	dc.w	function_8dc8	; $b50b
	dc.w	function_8dc8	; $b50d
	dc.w	function_8dc8	; $b50f
	dc.w	function_8dc8	; $b511
	dc.w	function_8dc8	; $b513
	dc.w	function_8dc8	; $b515
	dc.w	function_8dc8	; $b517
	dc.w	function_8dc8	; $b519
	dc.w	function_8dc8	; $b51b
	dc.w	function_8dc8	; $b51d
	dc.w	function_8dc8	; $b51f
	dc.w	function_8dc8	; $b521
jump_table_b7f4:
	dc.w	function_b72b	; $b7f4
	dc.w	function_b73e	; $b7f6
	dc.w	function_b75a	; $b7f8
	dc.w	function_b777	; $b7fa
	dc.w	function_b782	; $b7fc
	dc.w	function_b777	; $b7fe
	dc.w	function_b777	; $b800
	dc.w	function_b7a1	; $b802
	dc.w	function_b7cf	; $b804
	dc.w	function_b7db	; $b806
	dc.w	function_cc00	; $b808
jump_table_b804:
	dc.w	function_b7cf	; $b804
	dc.w	function_b7db	; $b806
	dc.w	function_cc00	; $b808
jump_table_b8de:
	dc.w	function_b820	; $b8de
	dc.w	function_b82b	; $b8e0
	dc.w	function_b84a	; $b8e2
	dc.w	function_b855	; $b8e4
	dc.w	function_b86f	; $b8e6
	dc.w	function_b887	; $b8e8
	dc.w	function_b893	; $b8ea
	dc.w	function_b89e	; $b8ec
	dc.w	function_b8cc	; $b8ee
	dc.w	function_b89e	; $b8f0
jump_table_b8ee:
	dc.w	function_b8cc	; $b8ee
	dc.w	function_b89e	; $b8f0
jump_table_b91b:
	dc.w	function_b925	; $b91b
	dc.w	function_b92b	; $b91d
	dc.w	function_b934	; $b91f
	dc.w	function_b925	; $b921
	dc.w	function_b940	; $b923
jump_table_b981:
	dc.w	function_b98b	; $b981
	dc.w	function_b991	; $b983
	dc.w	function_b99a	; $b985
	dc.w	function_b98b	; $b987
	dc.w	function_b9a6	; $b989
jump_table_bbc2:
	dc.w	function_bb8d	; $bbc2
	dc.w	function_bba1	; $bbc4
	dc.w	function_bbb3	; $bbc6
jump_table_bc0c:
	dc.w	function_bc1e	; $bc0c
	dc.w	function_bc26	; $bc0e
	dc.w	function_bc2c	; $bc10
	dc.w	function_bc2c	; $bc12
	dc.w	function_bc2c	; $bc14
	dc.w	function_bc2c	; $bc16
	dc.w	function_bc2c	; $bc18
	dc.w	function_bc1e	; $bc1a
	dc.w	function_bc55	; $bc1c
jump_table_bcab:
	dc.w	function_bcbd	; $bcab
	dc.w	function_bcbd	; $bcad
	dc.w	function_bcbd	; $bcaf
	dc.w	function_bcbd	; $bcb1
	dc.w	function_bcc3	; $bcb3
	dc.w	function_bd24	; $bcb5
	dc.w	function_bcbd	; $bcb7
	dc.w	function_bcbd	; $bcb9
	dc.w	function_bd3a	; $bcbb
jump_table_bd84:
	dc.w	function_bd94	; $bd84
	dc.w	function_bd94	; $bd86
	dc.w	function_bd94	; $bd88
	dc.w	function_bd94	; $bd8a
	dc.w	function_bd9a	; $bd8c
	dc.w	function_be0c	; $bd8e
	dc.w	function_bd94	; $bd90
	dc.w	function_be22	; $bd92
jump_table_be54:
	dc.w	function_be66	; $be54
	dc.w	function_be66	; $be56
	dc.w	function_be5e	; $be58
	dc.w	function_be66	; $be5a
	dc.w	function_be71	; $be5c
jump_table_bec5:
	dc.w	function_bec9	; $bec5
	dc.w	function_becf	; $bec7
jump_table_bf53:
	dc.w	function_bf8a	; $bf53
	dc.w	function_bf8a	; $bf55
	dc.w	function_bf6b	; $bf57
	dc.w	function_bf8a	; $bf59
	dc.w	function_bf8a	; $bf5b
	dc.w	function_bfc7	; $bf5d
	dc.w	function_bf8a	; $bf5f
	dc.w	function_bf8a	; $bf61
	dc.w	function_bf90	; $bf63
	dc.w	function_bf8a	; $bf65
	dc.w	function_bf8a	; $bf67
	dc.w	function_bff0	; $bf69
jump_table_c04f:
	dc.w	function_c067	; $c04f
	dc.w	function_c0b0	; $c051
	dc.w	function_c0b0	; $c053
	dc.w	function_c067	; $c055
	dc.w	function_c0b0	; $c057
	dc.w	function_c0c8	; $c059
	dc.w	function_c091	; $c05b
	dc.w	function_c0b0	; $c05d
	dc.w	function_c0b0	; $c05f
	dc.w	function_c091	; $c061
	dc.w	function_c0b0	; $c063
	dc.w	function_c0c8	; $c065
jump_table_c25b:
	dc.w	function_c11f	; $c25b
	dc.w	function_c11f	; $c25d
	dc.w	function_c132	; $c25f
	dc.w	function_c132	; $c261
	dc.w	function_c132	; $c263
	dc.w	function_c152	; $c265
	dc.w	function_c171	; $c267
	dc.w	function_c192	; $c269
	dc.w	function_c1bd	; $c26b
	dc.w	function_c1bd	; $c26d
	dc.w	function_c1d7	; $c26f
	dc.w	function_c227	; $c271
	dc.w	function_c23e	; $c273
jump_table_c269:
	dc.w	function_c192	; $c269
	dc.w	function_c1bd	; $c26b
	dc.w	function_c1bd	; $c26d
	dc.w	function_c1d7	; $c26f
	dc.w	function_c227	; $c271
	dc.w	function_c23e	; $c273
jump_table_c2fa:
	dc.w	function_c293	; $c2fa
	dc.w	function_c293	; $c2fc
	dc.w	function_c28c	; $c2fe
	dc.w	function_c28c	; $c300
	dc.w	function_c28c	; $c302
	dc.w	function_c288	; $c304
	dc.w	function_c293	; $c306
	dc.w	function_c299	; $c308
jump_table_c30a:
	dc.w	function_c2b6	; $c30a
	dc.w	function_c2b6	; $c30c
	dc.w	function_c2ab	; $c30e
	dc.w	function_c2af	; $c310
	dc.w	function_c2af	; $c312
	dc.w	function_c2bc	; $c314
	dc.w	function_c2b6	; $c316
	dc.w	function_c2ea	; $c318

jump_table_c348:
	dc.w	function_c395	; $c348
	dc.w	function_c41f	; $c34a
	dc.w	function_c3da	; $c34c
	dc.w	function_c41f	; $c34e
	dc.w	function_c395	; $c350
	dc.w	function_c3da	; $c352
jump_table_c350:
	dc.w	function_c395	; $c350
	dc.w	function_c3da	; $c352
jump_table_c441:
	dc.w	function_c457	; $c441
	dc.w	function_c47f	; $c443
	dc.w	function_c4ae	; $c445
	dc.w	function_c4ae	; $c447
	dc.w	function_c4ae	; $c449
	dc.w	function_c4b9	; $c44b
	dc.w	function_c4ae	; $c44d
	dc.w	function_c4ae	; $c44f
	dc.w	function_c4ae	; $c451
	dc.w	function_c4ae	; $c453
	dc.w	function_c4d3	; $c455
jump_table_c4ed:
	dc.w	function_c503	; $c4ed
	dc.w	function_c517	; $c4ef
	dc.w	function_c532	; $c4f1
	dc.w	function_c532	; $c4f3
	dc.w	function_c532	; $c4f5
	dc.w	function_c53d	; $c4f7
	dc.w	function_c532	; $c4f9
	dc.w	function_c532	; $c4fb
	dc.w	function_c532	; $c4fd
	dc.w	function_c532	; $c4ff
	dc.w	function_c557	; $c501
jump_table_c571:
	dc.w	function_c58b	; $c571
	dc.w	function_c58b	; $c573
	dc.w	function_c596	; $c575
	dc.w	function_c5a7	; $c577
	dc.w	function_c5a7	; $c579
	dc.w	function_c5b2	; $c57b
	dc.w	function_c5a7	; $c57d
	dc.w	function_c5a7	; $c57f
	dc.w	function_c5a7	; $c581
	dc.w	function_c5a7	; $c583
	dc.w	function_c5a7	; $c585
	dc.w	function_c5a7	; $c587
	dc.w	function_c5d5	; $c589
jump_table_c60c:
	dc.w	function_c610	; $c60c
	dc.w	function_c632	; $c60e
jump_table_c65c:
	dc.w	function_c662	; $c65c
	dc.w	function_c676	; $c65e
	dc.w	function_c688	; $c660
jump_table_c69a:
	dc.w	function_c6a0	; $c69a
	dc.w	function_c6b4	; $c69c
	dc.w	function_c6c6	; $c69e
jump_table_c73e:
	dc.w	function_bbc8	; $c73e
	dc.w	function_b523	; $c740
	dc.w	function_8dc8	; $c742
	dc.w	function_8dc8	; $c744
	dc.w	function_beb1	; $c746
	dc.w	function_8dc8	; $c748
	dc.w	function_b8f2	; $c74a
	dc.w	function_b95a	; $c74c
	dc.w	function_b6dd	; $c74e
	dc.w	function_b6dd	; $c750
	dc.w	function_b718	; $c752
	dc.w	function_b808	; $c754
	dc.w	function_b810	; $c756
	dc.w	function_b720	; $c758
	dc.w	function_8dc8	; $c75a
	dc.w	function_8dc8	; $c75c
	dc.w	function_b523	; $c75e
	dc.w	function_bb6a	; $c760
	dc.w	function_8dc8	; $c762
	dc.w	function_bf1d	; $c764
	dc.w	function_c019	; $c766
	dc.w	function_8dc8	; $c768
	dc.w	function_c6df	; $c76a
	dc.w	function_c0d5	; $c76c
	dc.w	function_c31a	; $c76e
	dc.w	function_c31a	; $c770
	dc.w	function_c31a	; $c772
	dc.w	function_c78c	; $c774
	dc.w	function_bbdd	; $c776
	dc.w	function_b706	; $c778
	dc.w	function_c600	; $c77a
	dc.w	function_c78c	; $c77c
	dc.w	function_c78c	; $c77e
	dc.w	function_c78d	; $c780
	dc.w	function_c78d	; $c782
	dc.w	function_c71a	; $c784
	dc.w	function_cafe	; $c786
	dc.w	function_cb9a	; $c788
	dc.w	function_c5e7	; $c78a
jump_table_c798:
	dc.w	function_c7ac	; $c798
	dc.w	function_c7ac	; $c79a
	dc.w	function_c7ac	; $c79c
	dc.w	function_c7c6	; $c79e
	dc.w	function_c80d	; $c7a0
	dc.w	function_c84c	; $c7a2
	dc.w	function_c88b	; $c7a4
	dc.w	function_c7ac	; $c7a6
	dc.w	function_c7ac	; $c7a8
	dc.w	function_c8c7	; $c7aa
jump_table_c902:
	dc.w	function_c916	; $c902
	dc.w	function_c916	; $c904
	dc.w	function_c930	; $c906
	dc.w	function_c977	; $c908
	dc.w	function_c9b6	; $c90a
	dc.w	function_c9f5	; $c90c
	dc.w	function_ca34	; $c90e
	dc.w	function_ca73	; $c910
	dc.w	function_c916	; $c912
	dc.w	function_caa9	; $c914
jump_table_cb09:
	dc.w	function_cb29	; $cb09
	dc.w	function_cb29	; $cb0b
	dc.w	function_cb29	; $cb0d
	dc.w	function_cb29	; $cb0f
	dc.w	function_cb29	; $cb11
	dc.w	function_cb29	; $cb13
	dc.w	function_cb29	; $cb15
	dc.w	function_cb29	; $cb17
	dc.w	function_cb29	; $cb19
	dc.w	function_cb29	; $cb1b
	dc.w	function_cb29	; $cb1d
	dc.w	function_cb29	; $cb1f
	dc.w	function_cb29	; $cb21
	dc.w	function_cb34	; $cb23
	dc.w	function_cb52	; $cb25
	dc.w	function_cb5e	; $cb27
jump_table_cbaa:
	dc.w	function_cbb8	; $cbaa
	dc.w	function_cbb8	; $cbac
	dc.w	function_cbb2	; $cbae
	dc.w	function_cbbe	; $cbb0
jump_table_cd9d:
	dc.w	function_cda5	; $cd9d
	dc.w	function_cdb7	; $cd9f
	dc.w	function_cdb7	; $cda1
	dc.w	function_cdc2	; $cda3
jump_table_ceda:
	dc.w	function_cf21	; $ceda
	dc.w	function_cf21	; $cedc
	dc.w	function_cf21	; $cede
	dc.w	function_cf20	; $cee0
	dc.w	function_cf21	; $cee2
	dc.w	function_cf21	; $cee4
	dc.w	function_cf21	; $cee6
	dc.w	function_cf21	; $cee8

jump_table_d214:
	dc.w	function_d22c	; $d214
	dc.w	function_d38e	; $d216
	dc.w	function_d4c2	; $d218
	dc.w	function_d447	; $d21a
	dc.w	function_d213	; $d21c
	dc.w	function_d213	; $d21e
	dc.w	function_d213	; $d220
	dc.w	function_d213	; $d222
	dc.w	function_d541	; $d224
	dc.w	function_d541	; $d226
	dc.w	function_d576	; $d228
	dc.w	function_d62d	; $d22a
jump_table_d236:
	dc.w	function_d23e	; $d236
	dc.w	function_d23e	; $d238
	dc.w	function_d2f4	; $d23a
	dc.w	function_d2f4	; $d23c
jump_table_d4f9:
	dc.w	function_d4cc	; $d4f9
	dc.w	function_d4de	; $d4fb
	dc.w	function_d4f0	; $d4fd
jump_table_bf5f:
	dc.w	function_bf8a	; $bf5f
	dc.w	function_bf8a	; $bf61
	dc.w	function_bf90	; $bf63
	dc.w	function_bf8a	; $bf65
	dc.w	function_bf8a	; $bf67
	dc.w	function_bff0	; $bf69


jump_table_c05b:
	dc.w	function_c091	; $c05b
	dc.w	function_c0b0	; $c05d
	dc.w	function_c0b0	; $c05f
	dc.w	function_c091	; $c061
	dc.w	function_c0b0	; $c063
	dc.w	function_c0c8	; $c065




