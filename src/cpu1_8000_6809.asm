;	map(0x0000, 0x1fff).ram().w(FUNC(namcos86_state::videoram1_w)).share("videoram1");
;	map(0x2000, 0x3fff).ram().w(FUNC(namcos86_state::videoram2_w)).share("videoram2");
;
;	map(0x4000, 0x5fff).ram().w(FUNC(namcos86_state::spriteram_w)).share("spriteram");
;
;	map(0x4000, 0x43ff).rw(m_cus30, FUNC(namco_cus30_device::namcos1_cus30_r), FUNC(namco_cus30_device::namcos1_cus30_w)); /* PSG device, shared RAM */
;
;	map(0x6000, 0x7fff).bankr("bank1");
;	map(0x8000, 0xffff).rom();
;
;	/* ROM & Voice expansion board - only some games have it */
;	map(0x6000, 0x7fff).w(FUNC(namcos86_state::cus115_w)); /* ROM bank select and 63701X sample player control */
;
;	map(0x8000, 0x8000).w(FUNC(namcos86_state::watchdog1_w));
;	map(0x8400, 0x8400).w(FUNC(namcos86_state::int_ack1_w)); /* IRQ acknowledge */
;	map(0x8800, 0x8fff).w(FUNC(namcos86_state::tilebank_select_w));
;
;	map(0x9000, 0x9002).w(FUNC(namcos86_state::scroll0_w));   /* scroll + priority */
;	map(0x9003, 0x9003).w(FUNC(namcos86_state::bankswitch1_w));
;	map(0x9004, 0x9006).w(FUNC(namcos86_state::scroll1_w));   /* scroll + priority */
;
;	map(0x9400, 0x9402).w(FUNC(namcos86_state::scroll2_w));   /* scroll + priority */
;//  { 0x9403, 0x9403 } sub CPU rom bank select would be here
;	map(0x9404, 0x9406).w(FUNC(namcos86_state::scroll3_w));   /* scroll + priority */
;
;	map(0xa000, 0xa000).w(FUNC(namcos86_state::backcolor_w));

bankswitch_shadow_19 = $19
; anything $68xx switches banks
bankswitch_6800 = $6800
irq_ack_8400 = $8400
watchdog_8000 = $8000
unknown_6e00 = $6E00
unknown_6200 = $6200
unknown_6600 = $6600
unknown_6C00 = $6C00
cpu_sync_5ff0 = $5ff0

cpu1_boot_0000:    ; [global]
8000: 1A 10       ORCC   #$10
8002: 10 CE 58 00 LDS    #$5800		; set stack to almost top RAM
8006: 86 56       LDA    #$56
8008: 1F 8B       TFR    A,DP		; direct page: $5600
800A: 4F          CLRA
800B: B7 6E 00    STA    unknown_6e00		; bank switch?
800E: B7 62 00    STA    unknown_6200		; bank switch?
8011: B7 66 00    STA    unknown_6600		; bank switch?
8014: B7 6C 00    STA    unknown_6C00		; bank switch?
8017: 7F 5F F1    CLR    $5FF1
801A: 7F 5F F3    CLR    $5FF3
801D: 7F 5F F0    CLR    cpu_sync_5ff0
; copy RAM with ROM start several times
8020: 8E 80 00    LDX    #watchdog_8000
8023: 10 8E 00 00 LDY    #$0000
8027: EC 81       LDD    ,X++
8029: ED A1       STD    ,Y++
802B: B7 80 00    STA    watchdog_8000
802E: 10 8C 20 00 CMPY   #$2000
8032: 26 F3       BNE    $8027
8034: 7C 5F F0    INC    cpu_sync_5ff0
8037: B7 80 00    STA    watchdog_8000
; wait for cpu 2 sync
803A: B6 5F F0    LDA    cpu_sync_5ff0
803D: 81 02       CMPA   #$02
803F: 26 F6       BNE    $8037
8041: 8E 80 00    LDX    #watchdog_8000
8044: 10 8E 00 00 LDY    #$0000
8048: A6 80       LDA    ,X+
804A: A8 A0       EORA   ,Y+
804C: B7 80 00    STA    watchdog_8000
804F: 81 FF       CMPA   #$FF
8051: 26 08       BNE    $805B
8053: 10 8C 20 00 CMPY   #$2000
8057: 26 EF       BNE    $8048
8059: 20 08       BRA    $8063
805B: B6 5F F1    LDA    $5FF1
805E: 8A 04       ORA    #$04
8060: B7 5F F1    STA    $5FF1
8063: 8E 80 00    LDX    #watchdog_8000
8066: 10 8E 20 00 LDY    #$2000
806A: EC 81       LDD    ,X++
806C: ED A1       STD    ,Y++
806E: B7 80 00    STA    watchdog_8000
8071: 10 8C 40 00 CMPY   #$4000
8075: 26 F3       BNE    $806A
8077: 7C 5F F0    INC    cpu_sync_5ff0
807A: B7 80 00    STA    watchdog_8000
807D: B6 5F F0    LDA    cpu_sync_5ff0
8080: 81 04       CMPA   #$04
8082: 26 F6       BNE    $807A
8084: 8E 80 00    LDX    #watchdog_8000
8087: 10 8E 20 00 LDY    #$2000
808B: A6 80       LDA    ,X+
808D: A8 A0       EORA   ,Y+
808F: B7 80 00    STA    watchdog_8000
8092: 81 FF       CMPA   #$FF
8094: 26 08       BNE    $809E
8096: 10 8C 40 00 CMPY   #$4000
809A: 26 EF       BNE    $808B
809C: 20 08       BRA    $80A6
809E: B6 5F F1    LDA    $5FF1
80A1: 8A 08       ORA    #$08
80A3: B7 5F F1    STA    $5FF1
80A6: 8E 80 00    LDX    #watchdog_8000
80A9: 10 8E 44 00 LDY    #$4400
80AD: EC 81       LDD    ,X++
80AF: ED A1       STD    ,Y++
80B1: B7 80 00    STA    watchdog_8000
80B4: 10 8C 5F F0 CMPY   #cpu_sync_5ff0
80B8: 26 F3       BNE    $80AD
80BA: 7C 5F F0    INC    cpu_sync_5ff0
80BD: B7 80 00    STA    watchdog_8000
80C0: B6 5F F0    LDA    cpu_sync_5ff0
80C3: 81 06       CMPA   #$06
80C5: 26 F6       BNE    $80BD
80C7: 8E 80 00    LDX    #watchdog_8000
80CA: 10 8E 44 00 LDY    #$4400
80CE: A6 80       LDA    ,X+
80D0: A8 A0       EORA   ,Y+
80D2: B7 80 00    STA    watchdog_8000
80D5: 81 FF       CMPA   #$FF
80D7: 26 08       BNE    $80E1
80D9: 10 8C 5F F0 CMPY   #cpu_sync_5ff0
80DD: 26 EF       BNE    $80CE
80DF: 20 08       BRA    $80E9
80E1: B6 5F F1    LDA    $5FF1
80E4: 8A 10       ORA    #$10
80E6: B7 5F F1    STA    $5FF1
80E9: 7C 5F F0    INC    cpu_sync_5ff0
80EC: 5F          CLRB
80ED: 8E 80 00    LDX    #watchdog_8000
80F0: B7 80 00    STA    watchdog_8000
80F3: EB 80       ADDB   ,X+
80F5: 8C 00 00    CMPX   #$0000
80F8: 26 F6       BNE    $80F0
80FA: 5D          TSTB
80FB: C1 01       CMPB   #$01
80FD: 27 08       BEQ    $8107
80FF: B6 5F F1    LDA    $5FF1
8102: 8A 01       ORA    #$01
8104: B7 5F F1    STA    $5FF1
8107: B6 41 82    LDA    $4182
810A: B7 80 00    STA    watchdog_8000
810D: 81 A6       CMPA   #$A6
810F: 26 F6       BNE    $8107
8111: B6 41 83    LDA    $4183
8114: 26 F1       BNE    $8107
8116: 86 FF       LDA    #$FF
8118: B7 41 83    STA    $4183
811B: B6 41 84    LDA    $4184
811E: B7 80 00    STA    watchdog_8000
8121: 81 A6       CMPA   #$A6
8123: 26 F6       BNE    $811B
8125: B6 41 85    LDA    $4185
8128: 27 0D       BEQ    $8137
812A: 86 A6       LDA    #$A6
812C: B7 41 81    STA    $4181
812F: B6 5F F1    LDA    $5FF1
8132: 8A 20       ORA    #$20
8134: B7 5F F1    STA    $5FF1
8137: 7F 5F F0    CLR    cpu_sync_5ff0
813A: B7 80 00    STA    watchdog_8000
813D: B6 5F F3    LDA    $5FF3
8140: 27 F5       BEQ    $8137
8142: B6 5F F1    LDA    $5FF1
8145: 27 49       BEQ    normal_start_8190
; service mode or whatever: not good
8147: 86 01       LDA    #$01
8149: B7 5F F6    STA    $5FF6
814C: BD 83 C9    JSR    $83C9
814F: BD 84 13    JSR    $8413
8152: BD 84 6A    JSR    $846A
8155: BD 82 1D    JSR    $821D
8158: CE 35 20    LDU    #$3520
815B: B6 5F F1    LDA    $5FF1
815E: C6 FC       LDB    #$FC
8160: 84 03       ANDA   #$03
8162: 10 8E 81 BE LDY    #$81BE
8166: A6 A6       LDA    A,Y
8168: ED C4       STD    ,U
816A: 10 8E 81 C2 LDY    #$81C2
816E: B6 5F F1    LDA    $5FF1
8171: 44          LSRA
8172: 44          LSRA
8173: 84 07       ANDA   #$07
8175: A6 A6       LDA    A,Y
8177: ED 48       STD    $8,U
8179: B6 5F F1    LDA    $5FF1
817C: 49          ROLA
817D: 49          ROLA
817E: 49          ROLA
817F: 49          ROLA
8180: 84 01       ANDA   #$01
8182: 10 8E 81 CA LDY    #$81CA
8186: A6 A6       LDA    A,Y
8188: ED C8 10    STD    $10,U
; infinite loop
818B: B7 80 00    STA    watchdog_8000
818E: 20 FB       BRA    $818B

normal_start_8190:
; clear memory
8190: 8E 56 00    LDX    #$5600
8193: CC 00 00    LDD    #$0000
8196: ED 81       STD    ,X++
8198: 8C 57 00    CMPX   #$5700
819B: 25 F9       BCS    $8196
819D: 0F D8       CLR    $D8
819F: 0F D9       CLR    $D9
81A1: 0F DB       CLR    $DB
81A3: 0F 02       CLR    $02
81A5: 0F 04       CLR    $04
81A7: 0F 06       CLR    $06
81A9: 7F 41 8C    CLR    $418C
81AC: 86 01       LDA    #$01
81AE: B7 41 8D    STA    $418D
81B1: 7C 5F F3    INC    $5FF3
81B4: 1C EF       ANDCC  #$EF		; enable interrupts
81B6: BD B4 0D    JSR    $B40D
81B9: BD D6 4A    JSR    $D64A
81BC: 20 F8       BRA    $81B6

81CC: 96 00       LDA    $00
81CE: 84 FE       ANDA   #$FE
81D0: BB 42 47    ADDA   $4247
81D3: 97 00       STA    $00
81D5: B6 42 45    LDA    $4245
81D8: 97 10       STA    $10
81DA: B6 42 53    LDA    $4253
81DD: 97 3C       STA    $3C
81DF: 8D 07       BSR    $81E8
81E1: 8D 20       BSR    $8203
81E3: 8D 38       BSR    $821D
81E5: 7E 82 B8    JMP    $82B8
81E8: CE 81 FB    LDU    #$81FB
81EB: B6 42 57    LDA    $4257
81EE: 48          ASLA
81EF: BA 42 59    ORA    $4259
81F2: 48          ASLA
81F3: 9A 01       ORA    $01
81F5: A6 C6       LDA    A,U
81F7: B7 5F F6    STA    $5FF6
81FA: 39          RTS

8203: CE 82 15    LDU    #$8215
8206: B6 42 57    LDA    $4257
8209: 48          ASLA
820A: BA 42 59    ORA    $4259
820D: 48          ASLA
820E: 9A 01       ORA    $01
8210: A6 C6       LDA    A,U
8212: 97 1E       STA    $1E
8214: 39          RTS

821D: 8E 53 C0    LDX    #$53C0
8220: CE 83 3A    LDU    #$833A
8223: B6 5F F6    LDA    $5FF6
8226: 27 48       BEQ    $8270
8228: 10 8E 83 22 LDY    #$8322
822C: EC 84       LDD    ,X
822E: 44          LSRA
822F: 56          RORB
8230: 44          LSRA
8231: 56          RORB
8232: 44          LSRA
8233: 56          RORB
8234: 44          LSRA
8235: 56          RORB
8236: 53          COMB
8237: 43          COMA
8238: C3 00 01    ADDD   #$0001
823B: E3 A1       ADDD   ,Y++
823D: 84 01       ANDA   #$01
823F: AA 04       ORA    $4,X
8241: ED D1       STD    [,U++]
8243: EC 02       LDD    $2,X
8245: 44          LSRA
8246: 56          RORB
8247: 44          LSRA
8248: 56          RORB
8249: 44          LSRA
824A: 56          RORB
824B: 44          LSRA
824C: 56          RORB
824D: EB A0       ADDB   ,Y+
824F: E7 D1       STB    [,U++]
8251: 30 88 10    LEAX   $10,X
8254: 8C 53 F0    CMPX   #$53F0
8257: 23 D3       BLS    $822C
8259: CC 00 9D    LDD    #$009D
825C: FD 5F F4    STD    $5FF4
825F: 86 0F       LDA    #$0F
8261: B7 5F F7    STA    $5FF7
8264: CC 00 00    LDD    #$0000
8267: FD 5F F8    STD    $5FF8
826A: 96 95       LDA    $95
826C: B7 A0 00    STA    $A000
826F: 39          RTS
8270: 10 8E 83 2E LDY    #$832E
8274: EC 84       LDD    ,X
8276: 44          LSRA
8277: 56          RORB
8278: 44          LSRA
8279: 56          RORB
827A: 44          LSRA
827B: 56          RORB
827C: 44          LSRA
827D: 56          RORB
827E: E3 A1       ADDD   ,Y++
8280: 84 01       ANDA   #$01
8282: AA 04       ORA    $4,X
8284: ED D1       STD    [,U++]
8286: EC 02       LDD    $2,X
8288: 44          LSRA
8289: 56          RORB
828A: 44          LSRA
828B: 56          RORB
828C: 44          LSRA
828D: 56          RORB
828E: 44          LSRA
828F: 56          RORB
8290: 53          COMB
8291: 43          COMA
8292: C3 00 01    ADDD   #$0001
8295: EB A0       ADDB   ,Y+
8297: E7 D1       STB    [,U++]
8299: 30 88 10    LEAX   $10,X
829C: 8C 53 F0    CMPX   #$53F0
829F: 23 D3       BLS    $8274
82A1: CC 00 43    LDD    #$0043
82A4: FD 5F F4    STD    $5FF4
82A7: 86 11       LDA    #$11
82A9: B7 5F F7    STA    $5FF7
82AC: CC 00 00    LDD    #$0000
82AF: FD 5F F8    STD    $5FF8
82B2: 96 95       LDA    $95
82B4: B7 A0 00    STA    $A000
82B7: 39          RTS
82B8: 96 02       LDA    $02
82BA: 81 03       CMPA   #$03
82BC: 26 03       BNE    $82C1
82BE: 0F 0A       CLR    $0A
82C0: 39          RTS
82C1: 8E 42 76    LDX    #$4276
82C4: 96 1E       LDA    $1E
82C6: 26 02       BNE    $82CA
82C8: 30 14       LEAX   -$C,X
82CA: A6 07       LDA    $7,X
82CC: 48          ASLA
82CD: AB 05       ADDA   $5,X
82CF: 48          ASLA
82D0: AB 0B       ADDA   $B,X
82D2: 48          ASLA
82D3: AB 09       ADDA   $9,X
82D5: CE 83 4A    LDU    #$834A
82D8: A6 C6       LDA    A,U
82DA: 48          ASLA
82DB: 6D 84       TST    ,X
82DD: 27 05       BEQ    $82E4
82DF: 4C          INCA
82E0: 0C 0D       INC    $0D
82E2: 20 05       BRA    $82E9
82E4: 0D 0D       TST    $0D
82E6: 27 01       BEQ    $82E9
82E8: 4C          INCA
82E9: 48          ASLA
82EA: D6 CE       LDB    $CE
82EC: C1 01       CMPB   #$01
82EE: 27 0A       BEQ    $82FA
82F0: 6D 02       TST    $2,X
82F2: 27 26       BEQ    $831A
82F4: 4C          INCA
82F5: 0C 0B       INC    $0B
82F7: 97 0A       STA    $0A
82F9: 39          RTS
82FA: 6D 02       TST    $2,X
82FC: 26 14       BNE    $8312
82FE: 6D 03       TST    $3,X
8300: 27 18       BEQ    $831A
8302: 0C 0C       INC    $0C
8304: D6 0C       LDB    $0C
8306: C1 05       CMPB   #$05
8308: 26 10       BNE    $831A
830A: 0F 0C       CLR    $0C
830C: 4C          INCA
830D: 0C 0B       INC    $0B
830F: 97 0A       STA    $0A
8311: 39          RTS
8312: 0F 0C       CLR    $0C
8314: 4C          INCA
8315: 0C 0B       INC    $0B
8317: 97 0A       STA    $0A
8319: 39          RTS
831A: 0D 0B       TST    $0B
831C: 27 01       BEQ    $831F
831E: 4C          INCA
831F: 97 0A       STA    $0A
8321: 39          RTS

8355: BD 83 C9    JSR    $83C9
8358: BD 84 13    JSR    $8413
835B: BD 84 59    JSR    $8459
835E: BD 84 8C    JSR    $848C
8361: BD 84 BA    JSR    $84BA
8364: BD 84 CD    JSR    $84CD
8367: BD 84 E0    JSR    $84E0
836A: BD 84 F9    JSR    $84F9
836D: BD 95 E3    JSR    $95E3
8370: 0F 01       CLR    $01
8372: 8E 53 C0    LDX    #$53C0
8375: 86 01       LDA    #$01
8377: 48          ASLA
8378: 84 0E       ANDA   #$0E
837A: A7 04       STA    $4,X
837C: A6 84       LDA    ,X
837E: 84 01       ANDA   #$01
8380: AA 04       ORA    $4,X
8382: B7 90 00    STA    $9000
8385: 8E 53 D0    LDX    #$53D0
8388: 86 03       LDA    #$03
838A: 48          ASLA
838B: 84 0E       ANDA   #$0E
838D: A7 04       STA    $4,X
838F: A6 84       LDA    ,X
8391: 84 01       ANDA   #$01
8393: AA 04       ORA    $4,X
8395: B7 90 04    STA    $9004
8398: 8E 53 E0    LDX    #$53E0
839B: 86 05       LDA    #$05
839D: 48          ASLA
839E: 84 0E       ANDA   #$0E
83A0: A7 04       STA    $4,X
83A2: A6 84       LDA    ,X
83A4: 84 01       ANDA   #$01
83A6: AA 04       ORA    $4,X
83A8: B7 94 00    STA    $9400
83AB: 8E 53 F0    LDX    #$53F0
83AE: 86 07       LDA    #$07
83B0: 48          ASLA
83B1: 84 0E       ANDA   #$0E
83B3: A7 04       STA    $4,X
83B5: A6 84       LDA    ,X
83B7: 84 01       ANDA   #$01
83B9: AA 04       ORA    $4,X
83BB: B7 94 04    STA    $9404
83BE: 86 10       LDA    #$10
83C0: 97 95       STA    $95
83C2: 0C 02       INC    $02
83C4: 0F 04       CLR    $04
83C6: 0F 06       CLR    $06
83C8: 39          RTS
83C9: 8D 37       BSR    $8402
83CB: 8D 24       BSR    $83F1
83CD: 8D 11       BSR    $83E0
83CF: 8E 00 00    LDX    #$0000
83D2: CC FF 03    LDD    #$FF03
83D5: ED 81       STD    ,X++
83D7: 8C 10 00    CMPX   #$1000
83DA: 25 F9       BCS    $83D5
83DC: B7 80 00    STA    watchdog_8000
83DF: 39          RTS
83E0: 8E 10 00    LDX    #$1000
83E3: CC FF 03    LDD    #$FF03
83E6: ED 81       STD    ,X++
83E8: 8C 20 00    CMPX   #$2000
83EB: 25 F9       BCS    $83E6
83ED: B7 80 00    STA    watchdog_8000
83F0: 39          RTS
83F1: 8E 20 00    LDX    #$2000
83F4: CC FF 03    LDD    #$FF03
83F7: ED 81       STD    ,X++
83F9: 8C 30 00    CMPX   #$3000
83FC: 25 F9       BCS    $83F7
83FE: B7 80 00    STA    watchdog_8000
8401: 39          RTS
8402: 8E 30 00    LDX    #$3000
8405: CC FF 03    LDD    #$FF03
8408: ED 81       STD    ,X++
840A: 8C 40 00    CMPX   #$4000
840D: 25 F9       BCS    $8408
840F: B7 80 00    STA    watchdog_8000
8412: 39          RTS
8413: 8E 53 C0    LDX    #$53C0
8416: CC 00 00    LDD    #$0000
8419: ED 81       STD    ,X++
841B: 8C 54 00    CMPX   #$5400
841E: 25 F9       BCS    $8419
8420: B7 80 00    STA    watchdog_8000
8423: CC 00 00    LDD    #$0000
8426: FD 53 C0    STD    $53C0
8429: FD 53 D0    STD    $53D0
842C: FD 53 E0    STD    $53E0
842F: FD 53 F0    STD    $53F0
8432: FD 53 F2    STD    $53F2
8435: CC 00 80    LDD    #$0080
8438: FD 53 C2    STD    $53C2
843B: FD 53 D2    STD    $53D2
843E: FD 53 E2    STD    $53E2
8441: 86 02       LDA    #$02
8443: B7 53 C4    STA    $53C4
8446: 86 06       LDA    #$06
8448: B7 53 D4    STA    $53D4
844B: 86 0A       LDA    #$0A
844D: B7 53 E4    STA    $53E4
8450: 86 0E       LDA    #$0E
8452: B7 53 F4    STA    $53F4
8455: B7 80 00    STA    watchdog_8000
8458: 39          RTS
8459: 8E 54 00    LDX    #$5400
845C: CC 00 00    LDD    #$0000
845F: ED 81       STD    ,X++
8461: 8C 55 00    CMPX   #$5500
8464: 25 F9       BCS    $845F
8466: B7 80 00    STA    watchdog_8000
8469: 39          RTS
846A: 8E 58 00    LDX    #$5800
846D: CC 00 00    LDD    #$0000
8470: 97 24       STA    $24
8472: ED 81       STD    ,X++
8474: 8C 5F F0    CMPX   #cpu_sync_5ff0
8477: 25 F9       BCS    $8472
8479: 8E 58 09    LDX    #$5809
847C: 86 E0       LDA    #$E0
847E: A7 84       STA    ,X
8480: 30 88 10    LEAX   $10,X
8483: 8C 5F F0    CMPX   #cpu_sync_5ff0
8486: 25 F6       BCS    $847E
8488: B7 80 00    STA    watchdog_8000
848B: 39          RTS
848C: 8E 50 00    LDX    #$5000
848F: CC 00 00    LDD    #$0000
8492: 97 50       STA    $50
8494: 97 51       STA    $51
8496: 97 54       STA    $54
8498: 97 55       STA    $55
849A: 97 52       STA    $52
849C: 97 53       STA    $53
849E: ED 81       STD    ,X++
84A0: 8C 53 00    CMPX   #$5300
84A3: 25 F9       BCS    $849E
84A5: B7 80 00    STA    watchdog_8000
84A8: 8E 50 00    LDX    #$5000
84AB: CC 30 FF    LDD    #$30FF
84AE: E7 84       STB    ,X
84B0: 30 88 10    LEAX   $10,X
84B3: 4A          DECA
84B4: 26 F8       BNE    $84AE
84B6: B7 80 00    STA    watchdog_8000
84B9: 39          RTS
84BA: 8E 55 00    LDX    #$5500
84BD: CC 00 00    LDD    #$0000
84C0: DD B3       STD    $B3
84C2: ED 81       STD    ,X++
84C4: 8C 56 00    CMPX   #$5600
84C7: 25 F9       BCS    $84C2
84C9: B7 80 00    STA    watchdog_8000
84CC: 39          RTS
84CD: 8E 53 20    LDX    #$5320
84D0: CC 00 00    LDD    #$0000
84D3: DD 6E       STD    $6E
84D5: ED 81       STD    ,X++
84D7: 8C 53 40    CMPX   #$5340
84DA: 25 F9       BCS    $84D5
84DC: B7 80 00    STA    watchdog_8000
84DF: 39          RTS
84E0: 8E 53 40    LDX    #$5340
84E3: CC 00 00    LDD    #$0000
84E6: 97 E0       STA    $E0
84E8: 97 E1       STA    $E1
84EA: 97 E4       STA    $E4
84EC: 97 E5       STA    $E5
84EE: ED 81       STD    ,X++
84F0: 8C 53 80    CMPX   #$5380
84F3: 25 F9       BCS    $84EE
84F5: B7 80 00    STA    watchdog_8000
84F8: 39          RTS
84F9: 8E 53 80    LDX    #$5380
84FC: 96 E2       LDA    $E2
84FE: 97 E3       STA    $E3
8500: 96 E6       LDA    $E6
8502: 97 E7       STA    $E7
8504: CC 00 00    LDD    #$0000
8507: ED 81       STD    ,X++
8509: 8C 53 C0    CMPX   #$53C0
850C: 25 F9       BCS    $8507
850E: B7 80 00    STA    watchdog_8000
8511: 39          RTS
8512: 86 FF       LDA    #$FF
8514: B7 41 83    STA    $4183
8517: 8D 36       BSR    $854F
8519: 7F 41 83    CLR    $4183
851C: 8D 01       BSR    $851F
851E: 39          RTS
851F: B6 41 85    LDA    $4185
; only RTS!!
8522: 48          ASLA
8523: CE 85 29    LDU    #jump_table_8529
8526: AD D6       JSR    [A,U]		; [indirect_jump] [nb_entries=10]
8528: 39          RTS

853D: 39          RTS
853E: 39          RTS
853F: 39          RTS
8540: 39          RTS
8541: 39          RTS
8542: 39          RTS
8543: 39          RTS
8544: 39          RTS
8545: 39          RTS
8546: 39          RTS
8547: B6 41 82    LDA    $4182
854A: 81 A6       CMPA   #$A6
854C: 26 F9       BNE    $8547
854E: 39          RTS
854F: B6 41 84    LDA    $4184
8552: 81 A6       CMPA   #$A6
8554: 26 F9       BNE    $854F
8556: 39          RTS
8557: 4F          CLRA
8558: B7 6E 00    STA    $6E00
855B: B7 60 00    STA    $6000
855E: B7 64 00    STA    $6400
8561: B7 6C 00    STA    $6C00
8564: 39          RTS
8565: 0C 0E       INC    $0E
8567: 96 00       LDA    $00
8569: 84 01       ANDA   #$01
856B: 26 26       BNE    $8593
856D: BD 81 CC    JSR    $81CC
8570: BD AF 16    JSR    $AF16
8573: BD AF 6C    JSR    $AF6C
8576: BD AF C9    JSR    $AFC9
8579: 96 02       LDA    $02
857B: 91 03       CMPA   $03
857D: 22 08       BHI    $8587
857F: CE 85 A2    LDU    #jump_table_85a2
8582: 96 02       LDA    $02
8584: 48          ASLA
8585: AD D6       JSR    [A,U]		; [indirect_jump] [nb_entries=7]
8587: 96 19       LDA    bankswitch_shadow_19
8589: B7 68 00    STA    bankswitch_6800
858C: B7 80 00    STA    watchdog_8000
858F: B7 84 00    STA    irq_ack_8400
8592: 3B          RTI

8593: BD 81 CC    JSR    $81CC
8596: 96 19       LDA    bankswitch_shadow_19
8598: B7 68 00    STA    bankswitch_6800
859B: B7 80 00    STA    watchdog_8000
859E: B7 84 00    STA    irq_ack_8400
85A1: 3B          RTI

jump_table_85a2:
	.word	$8355 
	.word	$85B0 
	.word	$8F10
	.word	$90FB
	.word	$922E
	.word	$9901
	.word	$9BEF

85B0: 7D 42 3D    TST    $423D
85B3: 27 0D       BEQ    $85C2
85B5: 96 04       LDA    $04
85B7: 91 05       CMPA   $05
85B9: 23 01       BLS    $85BC
85BB: 39          RTS
85BC: CE 85 D4    LDU    #jump_table_85d4
85BF: 48          ASLA
85C0: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]
85C2: 0C 02       INC    $02
85C4: 0F 04       CLR    $04
85C6: 0F 06       CLR    $06
85C8: 0C 03       INC    $03
85CA: 0F 05       CLR    $05
85CC: 0F 07       CLR    $07
85CE: 7F 41 83    CLR    $4183
85D1: 7E 83 C9    JMP    $83C9

85D8: 7F 54 2B    CLR    $542B
85DB: 0C 04       INC    $04
85DD: 0F 06       CLR    $06
85DF: 39          RTS
85E0: 8E 32 08    LDX    #$3208
85E3: CE 32 88    LDU    #$3288
85E6: 32 7E       LEAS   -$2,S		; [alloc_locals]
85E8: 86 0E       LDA    #$0E
85EA: A7 61       STA    $1,S	; [local]
85EC: 86 12       LDA    #$12
85EE: A7 E4       STA    ,S		; [local]
85F0: C6 FC       LDB    #$FC
85F2: 86 3C       LDA    #$3C
85F4: ED 81       STD    ,X++
85F6: 4C          INCA
85F7: ED 81       STD    ,X++
85F9: 4C          INCA
85FA: ED C1       STD    ,U++
85FC: 4C          INCA
85FD: ED C1       STD    ,U++
85FF: 6A E4       DEC    ,S		; [local]
8601: 26 EF       BNE    $85F2
8603: 30 89 00 B8 LEAX   $00B8,X
8607: 33 C9 00 B8 LEAU   $00B8,U
860B: 6A 61       DEC    $1,S   ; [local]
860D: 26 DD       BNE    $85EC
860F: B7 80 00    STA    watchdog_8000
8612: 35 86       PULS   D,PC		; [free_locals]

8614: B6 54 2B    LDA    $542B
8617: 48          ASLA
8618: CE 86 1D    LDU    #jump_table_861d
861B: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=5]
	
8627: B6 5F F1    LDA    $5FF1
862A: 8A 80       ORA    #$80
862C: B7 5F F1    STA    $5FF1
862F: 7C 54 2B    INC    $542B
8632: 39          RTS
8633: 7F 5F F3    CLR    $5FF3
8636: 7F 5F F0    CLR    cpu_sync_5ff0
8639: BD 83 C9    JSR    $83C9
863C: BD 84 6A    JSR    $846A
863F: BD 84 13    JSR    $8413
8642: 7C 54 2B    INC    $542B
8645: 39          RTS

8646: 86 01       LDA    #$01
8648: B4 5F F1    ANDA   $5FF1
864B: 27 19       BEQ    $8666
864D: CE 8D 1B    LDU    #$8D1B
8650: 10 8E 32 92 LDY    #$3292
8654: C6 FC       LDB    #$FC
8656: A6 C0       LDA    ,U+
8658: A7 E2       STA    ,-S		; [local]
865A: A6 C0       LDA    ,U+
865C: ED A1       STD    ,Y++
865E: 6A E4       DEC    ,S		; [local]
8660: 26 F8       BNE    $865A
8662: A6 E0       LDA    ,S+		; [local]
8664: 20 17       BRA    $867D
8666: CE 8D 28    LDU    #$8D28
8669: 10 8E 32 92 LDY    #$3292
866D: C6 FC       LDB    #$FC
866F: A6 C0       LDA    ,U+
8671: A7 E2       STA    ,-S		; [local]
8673: A6 C0       LDA    ,U+
8675: ED A1       STD    ,Y++
8677: 6A E4       DEC    ,S		; [local]
8679: 26 F8       BNE    $8673
867B: A6 E0       LDA    ,S+		; [local]
867D: 86 02       LDA    #$02
867F: B4 5F F1    ANDA   $5FF1
8682: 27 19       BEQ    $869D
8684: CE 8D 35    LDU    #$8D35
8687: 10 8E 32 B0 LDY    #$32B0
868B: C6 FC       LDB    #$FC
868D: A6 C0       LDA    ,U+
868F: A7 E2       STA    ,-S		; [local]
8691: A6 C0       LDA    ,U+
8693: ED A1       STD    ,Y++
8695: 6A E4       DEC    ,S		; [local]
8697: 26 F8       BNE    $8691
8699: A6 E0       LDA    ,S+		; [local]
869B: 20 17       BRA    $86B4
869D: CE 8D 41    LDU    #$8D41
86A0: 10 8E 32 B0 LDY    #$32B0
86A4: C6 FC       LDB    #$FC
86A6: A6 C0       LDA    ,U+
86A8: A7 E2       STA    ,-S		; [local]
86AA: A6 C0       LDA    ,U+
86AC: ED A1       STD    ,Y++
86AE: 6A E4       DEC    ,S		; [local]
86B0: 26 F8       BNE    $86AA
86B2: A6 E0       LDA    ,S+		; [local]
86B4: 86 1C       LDA    #$1C
86B6: B4 5F F1    ANDA   $5FF1
86B9: 27 19       BEQ    $86D4
86BB: CE 8D 4D    LDU    #$8D4D
86BE: 10 8E 33 92 LDY    #$3392
86C2: C6 FC       LDB    #$FC
86C4: A6 C0       LDA    ,U+
86C6: A7 E2       STA    ,-S		; [local]
86C8: A6 C0       LDA    ,U+
86CA: ED A1       STD    ,Y++
86CC: 6A E4       DEC    ,S		; [local]
86CE: 26 F8       BNE    $86C8
86D0: A6 E0       LDA    ,S+		; [local]
86D2: 20 17       BRA    $86EB
86D4: CE 8D 5A    LDU    #$8D5A
86D7: 10 8E 33 92 LDY    #$3392
86DB: C6 FC       LDB    #$FC
86DD: A6 C0       LDA    ,U+
86DF: A7 E2       STA    ,-S		; [local]
86E1: A6 C0       LDA    ,U+
86E3: ED A1       STD    ,Y++
86E5: 6A E4       DEC    ,S		; [local]
86E7: 26 F8       BNE    $86E1
86E9: A6 E0       LDA    ,S+		; [local]
86EB: 86 20       LDA    #$20
86ED: B4 5F F1    ANDA   $5FF1
86F0: 27 19       BEQ    $870B
86F2: CE 8D 67    LDU    #$8D67
86F5: 10 8E 33 B0 LDY    #$33B0
86F9: C6 FC       LDB    #$FC
86FB: A6 C0       LDA    ,U+
86FD: A7 E2       STA    ,-S		; [local]
86FF: A6 C0       LDA    ,U+
8701: ED A1       STD    ,Y++
8703: 6A E4       DEC    ,S		; [local]
8705: 26 F8       BNE    $86FF
8707: A6 E0       LDA    ,S+		; [local]
8709: 20 17       BRA    $8722
870B: CE 8D 73    LDU    #$8D73
870E: 10 8E 33 B0 LDY    #$33B0
8712: C6 FC       LDB    #$FC
8714: A6 C0       LDA    ,U+
8716: A7 E2       STA    ,-S		; [local]
8718: A6 C0       LDA    ,U+
871A: ED A1       STD    ,Y++
871C: 6A E4       DEC    ,S		; [local]
871E: 26 F8       BNE    $8718
8720: A6 E0       LDA    ,S+		; [local]
8722: CE 8D FB    LDU    #$8DFB
8725: 10 8E 34 92 LDY    #$3492
8729: C6 FC       LDB    #$FC
872B: A6 C0       LDA    ,U+
872D: A7 E2       STA    ,-S		; [local]
872F: A6 C0       LDA    ,U+
8731: ED A1       STD    ,Y++
8733: 6A E4       DEC    ,S		; [local]
8735: 26 F8       BNE    $872F
8737: A6 E0       LDA    ,S+		; [local]
8739: CE 8E 1A    LDU    #$8E1A
873C: 10 8E 35 92 LDY    #$3592
8740: C6 FC       LDB    #$FC
8742: A6 C0       LDA    ,U+
8744: A7 E2       STA    ,-S		; [local]
8746: A6 C0       LDA    ,U+
8748: ED A1       STD    ,Y++
874A: 6A E4       DEC    ,S		; [local]
874C: 26 F8       BNE    $8746
874E: A6 E0       LDA    ,S+		; [local]
8750: CE 8E 39    LDU    #$8E39
8753: 10 8E 36 92 LDY    #$3692
8757: C6 FC       LDB    #$FC
8759: A6 C0       LDA    ,U+
875B: A7 E2       STA    ,-S		; [local]
875D: A6 C0       LDA    ,U+
875F: ED A1       STD    ,Y++
8761: 6A E4       DEC    ,S		; [local]
8763: 26 F8       BNE    $875D
8765: A6 E0       LDA    ,S+		; [local]
8767: CE 8E 53    LDU    #$8E53
876A: 10 8E 37 92 LDY    #$3792
876E: C6 FC       LDB    #$FC
8770: A6 C0       LDA    ,U+
8772: A7 E2       STA    ,-S		; [local]
8774: A6 C0       LDA    ,U+
8776: ED A1       STD    ,Y++
8778: 6A E4       DEC    ,S		; [local]
877A: 26 F8       BNE    $8774
877C: A6 E0       LDA    ,S+		; [local]
877E: CE 8E 5D    LDU    #$8E5D
8781: 10 8E 38 92 LDY    #$3892
8785: C6 FC       LDB    #$FC
8787: A6 C0       LDA    ,U+
8789: A7 E2       STA    ,-S		; [local]
878B: A6 C0       LDA    ,U+
878D: ED A1       STD    ,Y++
878F: 6A E4       DEC    ,S		; [local]
8791: 26 F8       BNE    $878B
8793: A6 E0       LDA    ,S+		; [local]
8795: CE 8E 87    LDU    #$8E87
8798: 10 8E 39 92 LDY    #$3992
879C: C6 FC       LDB    #$FC
879E: A6 C0       LDA    ,U+
87A0: A7 E2       STA    ,-S		; [local]
87A2: A6 C0       LDA    ,U+
87A4: ED A1       STD    ,Y++
87A6: 6A E4       DEC    ,S		; [local]
87A8: 26 F8       BNE    $87A2
87AA: A6 E0       LDA    ,S+		; [local]
87AC: CE 8E 9D    LDU    #$8E9D
87AF: 10 8E 3A 92 LDY    #$3A92
87B3: C6 FC       LDB    #$FC
87B5: A6 C0       LDA    ,U+
87B7: A7 E2       STA    ,-S		; [local]
87B9: A6 C0       LDA    ,U+
87BB: ED A1       STD    ,Y++
87BD: 6A E4       DEC    ,S		; [local]
87BF: 26 F8       BNE    $87B9
87C1: A6 E0       LDA    ,S+		; [local]
87C3: CE 8E B4    LDU    #$8EB4
87C6: 10 8E 3B 92 LDY    #$3B92
87CA: C6 FC       LDB    #$FC
87CC: A6 C0       LDA    ,U+
87CE: A7 E2       STA    ,-S		; [local]
87D0: A6 C0       LDA    ,U+
87D2: ED A1       STD    ,Y++
87D4: 6A E4       DEC    ,S		; [local]
87D6: 26 F8       BNE    $87D0
87D8: A6 E0       LDA    ,S+		; [local]
87DA: CE 8E C6    LDU    #$8EC6
87DD: 10 8E 3C 92 LDY    #$3C92
87E1: C6 FC       LDB    #$FC
87E3: A6 C0       LDA    ,U+
87E5: A7 E2       STA    ,-S		; [local]
87E7: A6 C0       LDA    ,U+
87E9: ED A1       STD    ,Y++
87EB: 6A E4       DEC    ,S		; [local]
87ED: 26 F8       BNE    $87E7
87EF: A6 E0       LDA    ,S+		; [local]
87F1: CE 8E D3    LDU    #$8ED3
87F4: 10 8E 3C B6 LDY    #$3CB6
87F8: C6 FC       LDB    #$FC
87FA: A6 C0       LDA    ,U+
87FC: A7 E2       STA    ,-S		; [local]
87FE: A6 C0       LDA    ,U+
8800: ED A1       STD    ,Y++
8802: 6A E4       DEC    ,S		; [local]
8804: 26 F8       BNE    $87FE
8806: A6 E0       LDA    ,S+		; [local]
8808: CE 8E E6    LDU    #$8EE6
880B: 10 8E 3D 92 LDY    #$3D92
880F: C6 FC       LDB    #$FC
8811: A6 C0       LDA    ,U+
8813: A7 E2       STA    ,-S		; [local]
8815: A6 C0       LDA    ,U+
8817: ED A1       STD    ,Y++
8819: 6A E4       DEC    ,S		; [local]
881B: 26 F8       BNE    $8815
881D: A6 E0       LDA    ,S+		; [local]
881F: CE 8E FE    LDU    #$8EFE
8822: 10 8E 3E 92 LDY    #$3E92
8826: C6 FC       LDB    #$FC
8828: A6 C0       LDA    ,U+
882A: A7 E2       STA    ,-S		; [local]
882C: A6 C0       LDA    ,U+
882E: ED A1       STD    ,Y++
8830: 6A E4       DEC    ,S		; [local]
8832: 26 F8       BNE    $882C
8834: A6 E0       LDA    ,S+		; [local]
8836: CE 8F 07    LDU    #$8F07
8839: 10 8E 3F 12 LDY    #$3F12
883D: C6 FC       LDB    #$FC
883F: A6 C0       LDA    ,U+
8841: A7 E2       STA    ,-S		; [local]
8843: A6 C0       LDA    ,U+
8845: ED A1       STD    ,Y++
8847: 6A E4       DEC    ,S		; [local]
8849: 26 F8       BNE    $8843
884B: A6 E0       LDA    ,S+		; [local]
884D: 7C 54 2B    INC    $542B
8850: 39          RTS

8877: CE 8D FB    LDU    #$8DFB
887A: 10 8E 34 92 LDY    #$3492
887E: C6 FC       LDB    #$FC
8880: A6 C0       LDA    ,U+
8882: A7 E2       STA    ,-S		; [local]
8884: A6 C0       LDA    ,U+
8886: ED A1       STD    ,Y++
8888: 6A E4       DEC    ,S		; [local]
888A: 26 F8       BNE    $8884
888C: A6 E0       LDA    ,S+		; [local]
888E: 39          RTS

888F: CE 8D 7F    LDU    #$8D7F
8892: 10 8E 34 92 LDY    #$3492
8896: C6 FC       LDB    #$FC
8898: A6 C0       LDA    ,U+
889A: A7 E2       STA    ,-S		; [local]
889C: A6 C0       LDA    ,U+
889E: ED A1       STD    ,Y++
88A0: 6A E4       DEC    ,S		; [local]
88A2: 26 F8       BNE    $889C
88A4: A6 E0       LDA    ,S+		; [local]
88A6: 39          RTS
88A7: CE 8D BD    LDU    #$8DBD
88AA: 10 8E 34 92 LDY    #$3492
88AE: C6 FC       LDB    #$FC
88B0: A6 C0       LDA    ,U+
88B2: A7 E2       STA    ,-S		; [local]
88B4: A6 C0       LDA    ,U+
88B6: ED A1       STD    ,Y++
88B8: 6A E4       DEC    ,S		; [local]
88BA: 26 F8       BNE    $88B4
88BC: A6 E0       LDA    ,S+		; [local]
88BE: 39          RTS
88BF: CE 8D BD    LDU    #$8DBD
88C2: 10 8E 34 92 LDY    #$3492
88C6: C6 FC       LDB    #$FC
88C8: A6 C0       LDA    ,U+
88CA: A7 E2       STA    ,-S    ; [local]
88CC: A6 C0       LDA    ,U+
88CE: ED A1       STD    ,Y++
88D0: 6A E4       DEC    ,S    ; [local]
88D2: 26 F8       BNE    $88CC
88D4: A6 E0       LDA    ,S+    ; [local]
88D6: 39          RTS
88D7: CE 8E 1A    LDU    #$8E1A
88DA: 10 8E 35 92 LDY    #$3592
88DE: C6 FC       LDB    #$FC
88E0: A6 C0       LDA    ,U+
88E2: A7 E2       STA    ,-S    ; [local]
88E4: A6 C0       LDA    ,U+
88E6: ED A1       STD    ,Y++
88E8: 6A E4       DEC    ,S    ; [local]
88EA: 26 F8       BNE    $88E4
88EC: A6 E0       LDA    ,S+    ; [local]
88EE: 39          RTS
88EF: CE 8D 9E    LDU    #$8D9E
88F2: 10 8E 35 92 LDY    #$3592
88F6: C6 FC       LDB    #$FC
88F8: A6 C0       LDA    ,U+
88FA: A7 E2       STA    ,-S    ; [local]
88FC: A6 C0       LDA    ,U+
88FE: ED A1       STD    ,Y++
8900: 6A E4       DEC    ,S    ; [local]
8902: 26 F8       BNE    $88FC
8904: A6 E0       LDA    ,S+    ; [local]
8906: 39          RTS
8907: CE 8D 9E    LDU    #$8D9E
890A: 10 8E 35 92 LDY    #$3592
890E: C6 FC       LDB    #$FC
8910: A6 C0       LDA    ,U+
8912: A7 E2       STA    ,-S    ; [local]
8914: A6 C0       LDA    ,U+
8916: ED A1       STD    ,Y++
8918: 6A E4       DEC    ,S    ; [local]
891A: 26 F8       BNE    $8914
891C: A6 E0       LDA    ,S+    ; [local]
891E: 39          RTS
891F: CE 8D 9E    LDU    #$8D9E
8922: 10 8E 35 92 LDY    #$3592
8926: C6 FC       LDB    #$FC
8928: A6 C0       LDA    ,U+
892A: A7 E2       STA    ,-S    ; [local]
892C: A6 C0       LDA    ,U+
892E: ED A1       STD    ,Y++
8930: 6A E4       DEC    ,S    ; [local]
8932: 26 F8       BNE    $892C
8934: A6 E0       LDA    ,S+    ; [local]
8936: 39          RTS
8937: B6 42 3F    LDA    $423F
893A: 48          ASLA
893B: BB 42 41    ADDA   $4241
893E: 84 03       ANDA   #$03
8940: CE 88 67    LDU    #jump_table_8867
8943: 48          ASLA
8944: AD D6       JSR    [A,U]        ; [indirect_jump] [nb_entries=8]
8946: B6 42 49    LDA    $4249
8949: 48          ASLA
894A: BB 42 4B    ADDA   $424B
894D: 84 03       ANDA   #$03
894F: CE 88 6F    LDU    #jump_table_886f
8952: 48          ASLA
8953: AD D6       JSR    [A,U]        ; [indirect_jump] [nb_entries=5]
8955: C6 FC       LDB    #$FC
8957: B6 42 3F    LDA    $423F
895A: 48          ASLA
895B: BB 42 41    ADDA   $4241
895E: CE 88 57    LDU    #$8857
8961: 48          ASLA
8962: 33 C6       LEAU   A,U
8964: A6 C0       LDA    ,U+
8966: FD 34 AC    STD    $34AC
8969: A6 C4       LDA    ,U
896B: FD 34 BC    STD    $34BC
896E: B6 42 49    LDA    $4249
8971: 48          ASLA
8972: BB 42 4B    ADDA   $424B
8975: 48          ASLA
8976: CE 88 5F    LDU    #$885F
8979: 33 C6       LEAU   A,U
897B: A6 C0       LDA    ,U+
897D: FD 35 AC    STD    $35AC
8980: A6 C4       LDA    ,U
8982: FD 35 BC    STD    $35BC
8985: B6 42 43    LDA    $4243
8988: 26 19       BNE    $89A3
898A: CE 8E 41    LDU    #$8E41
898D: 10 8E 36 AC LDY    #$36AC
8991: C6 FC       LDB    #$FC
8993: A6 C0       LDA    ,U+
8995: A7 E2       STA    ,-S    ; [local]
8997: A6 C0       LDA    ,U+
8999: ED A1       STD    ,Y++
899B: 6A E4       DEC    ,S    ; [local]
899D: 26 F8       BNE    $8997
899F: A6 E0       LDA    ,S+    ; [local]
89A1: 20 17       BRA    $89BA
89A3: CE 8E 4A    LDU    #$8E4A
89A6: 10 8E 36 AC LDY    #$36AC
89AA: C6 FC       LDB    #$FC
89AC: A6 C0       LDA    ,U+
89AE: A7 E2       STA    ,-S    ; [local]
89B0: A6 C0       LDA    ,U+
89B2: ED A1       STD    ,Y++
89B4: 6A E4       DEC    ,S    ; [local]
89B6: 26 F8       BNE    $89B0
89B8: A6 E0       LDA    ,S+    ; [local]
89BA: B6 42 4D    LDA    $424D
89BD: 84 01       ANDA   #$01
89BF: CE 88 51    LDU    #$8851
89C2: A6 C6       LDA    A,U
89C4: C6 FC       LDB    #$FC
89C6: FD 37 AC    STD    $37AC
89C9: B6 42 4F    LDA    $424F
89CC: 26 19       BNE    $89E7
89CE: CE 8E 63    LDU    #$8E63
89D1: 10 8E 38 AC LDY    #$38AC
89D5: C6 FC       LDB    #$FC
89D7: A6 C0       LDA    ,U+
89D9: A7 E2       STA    ,-S    ; [local]
89DB: A6 C0       LDA    ,U+
89DD: ED A1       STD    ,Y++
89DF: 6A E4       DEC    ,S    ; [local]
89E1: 26 F8       BNE    $89DB
89E3: A6 E0       LDA    ,S+    ; [local]
89E5: 20 17       BRA    $89FE
89E7: CE 8E 75    LDU    #$8E75
89EA: 10 8E 38 AC LDY    #$38AC
89EE: C6 FC       LDB    #$FC
89F0: A6 C0       LDA    ,U+
89F2: A7 E2       STA    ,-S    ; [local]
89F4: A6 C0       LDA    ,U+
89F6: ED A1       STD    ,Y++
89F8: 6A E4       DEC    ,S    ; [local]
89FA: 26 F8       BNE    $89F4
89FC: A6 E0       LDA    ,S+    ; [local]
89FE: B6 42 51    LDA    $4251
8A01: 26 19       BNE    $8A1C
8A03: CE 8E 8D    LDU    #$8E8D
8A06: 10 8E 39 AC LDY    #$39AC
8A0A: C6 FC       LDB    #$FC
8A0C: A6 C0       LDA    ,U+
8A0E: A7 E2       STA    ,-S    ; [local]
8A10: A6 C0       LDA    ,U+
8A12: ED A1       STD    ,Y++
8A14: 6A E4       DEC    ,S    ; [local]
8A16: 26 F8       BNE    $8A10
8A18: A6 E0       LDA    ,S+    ; [local]
8A1A: 20 17       BRA    $8A33
8A1C: CE 8E 95    LDU    #$8E95
8A1F: 10 8E 39 AC LDY    #$39AC
8A23: C6 FC       LDB    #$FC
8A25: A6 C0       LDA    ,U+
8A27: A7 E2       STA    ,-S    ; [local]
8A29: A6 C0       LDA    ,U+
8A2B: ED A1       STD    ,Y++
8A2D: 6A E4       DEC    ,S    ; [local]
8A2F: 26 F8       BNE    $8A29
8A31: A6 E0       LDA    ,S+    ; [local]
8A33: B6 42 53    LDA    $4253
8A36: 26 19       BNE    $8A51
8A38: CE 8E A8    LDU    #$8EA8
8A3B: 10 8E 3A AC LDY    #$3AAC
8A3F: C6 FC       LDB    #$FC
8A41: A6 C0       LDA    ,U+
8A43: A7 E2       STA    ,-S    ; [local]
8A45: A6 C0       LDA    ,U+
8A47: ED A1       STD    ,Y++
8A49: 6A E4       DEC    ,S    ; [local]
8A4B: 26 F8       BNE    $8A45
8A4D: A6 E0       LDA    ,S+    ; [local]
8A4F: 20 17       BRA    $8A68
8A51: CE 8E AE    LDU    #$8EAE
8A54: 10 8E 3A AC LDY    #$3AAC
8A58: C6 FC       LDB    #$FC
8A5A: A6 C0       LDA    ,U+
8A5C: A7 E2       STA    ,-S    ; [local]
8A5E: A6 C0       LDA    ,U+
8A60: ED A1       STD    ,Y++
8A62: 6A E4       DEC    ,S    ; [local]
8A64: 26 F8       BNE    $8A5E
8A66: A6 E0       LDA    ,S+    ; [local]
8A68: B6 42 57    LDA    $4257
8A6B: 48          ASLA
8A6C: BB 42 59    ADDA   $4259
8A6F: 84 03       ANDA   #$03
8A71: CE 88 53    LDU    #$8853
8A74: A6 C6       LDA    A,U
8A76: C6 FC       LDB    #$FC
8A78: FD 3B B6    STD    $3BB6
8A7B: B6 42 5B    LDA    $425B
8A7E: 26 19       BNE    $8A99
8A80: CE 8E E2    LDU    #$8EE2
8A83: 10 8E 3C AC LDY    #$3CAC
8A87: C6 FC       LDB    #$FC
8A89: A6 C0       LDA    ,U+
8A8B: A7 E2       STA    ,-S    ; [local]
8A8D: A6 C0       LDA    ,U+
8A8F: ED A1       STD    ,Y++
8A91: 6A E4       DEC    ,S    ; [local]
8A93: 26 F8       BNE    $8A8D
8A95: A6 E0       LDA    ,S+    ; [local]
8A97: 20 17       BRA    $8AB0
8A99: CE 8E E4    LDU    #$8EE4
8A9C: 10 8E 3C AC LDY    #$3CAC
8AA0: C6 FC       LDB    #$FC
8AA2: A6 C0       LDA    ,U+
8AA4: A7 E2       STA    ,-S    ; [local]
8AA6: A6 C0       LDA    ,U+
8AA8: ED A1       STD    ,Y++
8AAA: 6A E4       DEC    ,S    ; [local]
8AAC: 26 F8       BNE    $8AA6
8AAE: A6 E0       LDA    ,S+    ; [local]
8AB0: B6 42 55    LDA    $4255
8AB3: 26 19       BNE    $8ACE
8AB5: CE 8E DE    LDU    #$8EDE
8AB8: 10 8E 3C C6 LDY    #$3CC6
8ABC: C6 FC       LDB    #$FC
8ABE: A6 C0       LDA    ,U+
8AC0: A7 E2       STA    ,-S    ; [local]
8AC2: A6 C0       LDA    ,U+
8AC4: ED A1       STD    ,Y++
8AC6: 6A E4       DEC    ,S    ; [local]
8AC8: 26 F8       BNE    $8AC2
8ACA: A6 E0       LDA    ,S+    ; [local]
8ACC: 20 17       BRA    $8AE5
8ACE: CE 8E DA    LDU    #$8EDA
8AD1: 10 8E 3C C6 LDY    #$3CC6
8AD5: C6 FC       LDB    #$FC
8AD7: A6 C0       LDA    ,U+
8AD9: A7 E2       STA    ,-S    ; [local]
8ADB: A6 C0       LDA    ,U+
8ADD: ED A1       STD    ,Y++
8ADF: 6A E4       DEC    ,S    ; [local]
8AE1: 26 F8       BNE    $8ADB
8AE3: A6 E0       LDA    ,S+    ; [local]
8AE5: 8E 42 3D    LDX    #$423D
8AE8: CE 3E AC    LDU    #$3EAC
8AEB: BD 8C 96    JSR    $8C96
8AEE: 8E 42 4D    LDX    #$424D
8AF1: CE 3F 2C    LDU    #$3F2C
8AF4: BD 8C 96    JSR    $8C96
8AF7: F6 5F F3    LDB    $5FF3
8AFA: CE 3D AC    LDU    #$3DAC
8AFD: BD 8C AF    JSR    $8CAF
8B00: 7C 54 2C    INC    $542C
8B03: B6 42 7A    LDA    $427A
8B06: BA 42 6E    ORA    $426E
8B09: 27 11       BEQ    $8B1C
8B0B: B6 5F F0    LDA    cpu_sync_5ff0
8B0E: 26 07       BNE    $8B17
8B10: 86 02       LDA    #$02
8B12: B7 5F F0    STA    cpu_sync_5ff0
8B15: 20 1C       BRA    $8B33
8B17: 7A 5F F0    DEC    cpu_sync_5ff0
8B1A: 20 17       BRA    $8B33
8B1C: B6 42 7C    LDA    $427C
8B1F: BA 42 70    ORA    $4270
8B22: 27 0F       BEQ    $8B33
8B24: B6 5F F0    LDA    cpu_sync_5ff0
8B27: 81 02       CMPA   #$02
8B29: 26 05       BNE    $8B30
8B2B: 7F 5F F0    CLR    cpu_sync_5ff0
8B2E: 20 03       BRA    $8B33
8B30: 7C 5F F0    INC    cpu_sync_5ff0
8B33: B6 5F F3    LDA    $5FF3
8B36: 8E 42 85    LDX    #$4285
8B39: F6 42 7E    LDB    $427E
8B3C: FA 42 72    ORB    $4272
8B3F: 26 0F       BNE    $8B50
8B41: F6 42 7F    LDB    $427F
8B44: FA 42 73    ORB    $4273
8B47: 27 10       BEQ    $8B59
8B49: C6 0F       LDB    #$0F
8B4B: F4 54 2C    ANDB   $542C
8B4E: 26 09       BNE    $8B59
8B50: 6F 86       CLR    A,X
8B52: 7F 43 80    CLR    $4380
8B55: 7F 54 2C    CLR    $542C
8B58: 4C          INCA
8B59: F6 42 80    LDB    $4280
8B5C: FA 42 74    ORB    $4274
8B5F: 26 0F       BNE    $8B70
8B61: F6 42 81    LDB    $4281
8B64: FA 42 75    ORB    $4275
8B67: 27 10       BEQ    $8B79
8B69: C6 0F       LDB    #$0F
8B6B: F4 54 2C    ANDB   $542C
8B6E: 26 09       BNE    $8B79
8B70: 6F 86       CLR    A,X
8B72: 7F 43 80    CLR    $4380
8B75: 7F 54 2C    CLR    $542C
8B78: 4A          DECA
8B79: F6 5F F0    LDB    cpu_sync_5ff0
8B7C: C1 02       CMPB   #$02
8B7E: 26 0C       BNE    $8B8C
8B80: 4D          TSTA
8B81: 2A 02       BPL    $8B85
8B83: 86 16       LDA    #$16
8B85: 81 17       CMPA   #$17
8B87: 25 1A       BCS    $8BA3
8B89: 4F          CLRA
8B8A: 20 17       BRA    $8BA3
8B8C: C1 01       CMPB   #$01
8B8E: 26 0C       BNE    $8B9C
8B90: 4D          TSTA
8B91: 2A 02       BPL    $8B95
8B93: 86 0D       LDA    #$0D
8B95: 81 0E       CMPA   #$0E
8B97: 25 0A       BCS    $8BA3
8B99: 4F          CLRA
8B9A: 20 07       BRA    $8BA3
8B9C: F6 5F F0    LDB    cpu_sync_5ff0
8B9F: 26 02       BNE    $8BA3
8BA1: 84 1F       ANDA   #$1F
8BA3: B7 5F F3    STA    $5FF3
8BA6: F6 5F F0    LDB    cpu_sync_5ff0
8BA9: C1 01       CMPB   #$01
8BAB: 24 38       BCC    $8BE5
8BAD: CE 8E EC    LDU    #$8EEC
8BB0: 10 8E 3D 9E LDY    #$3D9E
8BB4: C6 FC       LDB    #$FC
8BB6: A6 C0       LDA    ,U+
8BB8: A7 E2       STA    ,-S    ; [local]
8BBA: A6 C0       LDA    ,U+
8BBC: ED A1       STD    ,Y++
8BBE: 6A E4       DEC    ,S    ; [local]
8BC0: 26 F8       BNE    $8BBA
8BC2: A6 E0       LDA    ,S+    ; [local]
8BC4: B6 42 76    LDA    $4276
8BC7: BA 42 6A    ORA    $426A
8BCA: BA 42 78    ORA    $4278
8BCD: BA 42 6C    ORA    $426C
8BD0: BA 42 62    ORA    $4262
8BD3: BA 42 60    ORA    $4260
8BD6: 10 27 00 9A LBEQ   $8C74
8BDA: B6 5F F3    LDA    $5FF3
8BDD: 8E 42 85    LDX    #$4285
8BE0: 6C 86       INC    A,X
8BE2: 7E 8C 74    JMP    $8C74
8BE5: 26 33       BNE    $8C1A
8BE7: CE 8E F2    LDU    #$8EF2
8BEA: 10 8E 3D 9E LDY    #$3D9E
8BEE: C6 FC       LDB    #$FC
8BF0: A6 C0       LDA    ,U+
8BF2: A7 E2       STA    ,-S    ; [local]
8BF4: A6 C0       LDA    ,U+
8BF6: ED A1       STD    ,Y++
8BF8: 6A E4       DEC    ,S    ; [local]
8BFA: 26 F8       BNE    $8BF4
8BFC: A6 E0       LDA    ,S+    ; [local]
8BFE: B6 42 76    LDA    $4276
8C01: BA 42 6A    ORA    $426A
8C04: BA 42 78    ORA    $4278
8C07: BA 42 6C    ORA    $426C
8C0A: BA 42 62    ORA    $4262
8C0D: BA 42 60    ORA    $4260
8C10: 27 62       BEQ    $8C74
8C12: B6 5F F3    LDA    $5FF3
8C15: B7 43 80    STA    $4380
8C18: 20 5A       BRA    $8C74
8C1A: CE 8E F8    LDU    #$8EF8
8C1D: 10 8E 3D 9E LDY    #$3D9E
8C21: C6 FC       LDB    #$FC
8C23: A6 C0       LDA    ,U+
8C25: A7 E2       STA    ,-S    ; [local]
8C27: A6 C0       LDA    ,U+
8C29: ED A1       STD    ,Y++
8C2B: 6A E4       DEC    ,S    ; [local]
8C2D: 26 F8       BNE    $8C27
8C2F: A6 E0       LDA    ,S+    ; [local]
8C31: B6 42 76    LDA    $4276
8C34: BA 42 6A    ORA    $426A
8C37: BA 42 78    ORA    $4278
8C3A: BA 42 6C    ORA    $426C
8C3D: BA 42 62    ORA    $4262
8C40: BA 42 60    ORA    $4260
8C43: 27 2F       BEQ    $8C74
8C45: B6 5F F3    LDA    $5FF3
8C48: 8E 8C ED    LDX    #$8CED
8C4B: 48          ASLA
8C4C: E6 86       LDB    A,X
8C4E: 26 13       BNE    $8C63
8C50: 4C          INCA
8C51: E6 86       LDB    A,X
8C53: F7 62 00    STB    $6200
8C56: 7C 54 2A    INC    $542A
8C59: B6 54 2A    LDA    $542A
8C5C: 8A C0       ORA    #$C0
8C5E: B7 60 00    STA    $6000
8C61: 20 11       BRA    $8C74
8C63: 4C          INCA
8C64: E6 86       LDB    A,X
8C66: F7 66 00    STB    $6600
8C69: 7C 54 30    INC    $5430
8C6C: B6 54 30    LDA    $5430
8C6F: 8A C0       ORA    #$C0
8C71: B7 64 00    STA    $6400
8C74: B6 42 68    LDA    $4268
8C77: 26 01       BNE    $8C7A
8C79: 39          RTS
8C7A: BD 83 C9    JSR    $83C9
8C7D: BD 84 6A    JSR    $846A
8C80: BD 85 E0    JSR    $85E0
8C83: 7C 54 2B    INC    $542B
8C86: 39          RTS
8C87: B6 42 68    LDA    $4268
8C8A: 26 01       BNE    $8C8D
8C8C: 39          RTS
8C8D: 7F 5F F3    CLR    $5FF3
8C90: 86 01       LDA    #$01
8C92: B7 54 2B    STA    $542B
8C95: 39          RTS
8C96: 86 08       LDA    #$08
8C98: B7 54 2D    STA    $542D
8C9B: A6 81       LDA    ,X++
8C9D: C6 FC       LDB    #$FC
8C9F: 46          RORA
8CA0: 24 04       BCC    $8CA6
8CA2: 86 01       LDA    #$01
8CA4: 20 01       BRA    $8CA7
8CA6: 4F          CLRA
8CA7: ED C1       STD    ,U++
8CA9: 7A 54 2D    DEC    $542D
8CAC: 26 ED       BNE    $8C9B
8CAE: 39          RTS
8CAF: 86 01       LDA    #$01
8CB1: B7 54 2D    STA    $542D
8CB4: 7F 54 2E    CLR    $542E
8CB7: 5D          TSTB
8CB8: 27 19       BEQ    $8CD3
8CBA: 54          LSRB
8CBB: 24 0A       BCC    $8CC7
8CBD: B6 54 2E    LDA    $542E
8CC0: BB 54 2D    ADDA   $542D
8CC3: 19          DAA
8CC4: B7 54 2E    STA    $542E
8CC7: B6 54 2D    LDA    $542D
8CCA: BB 54 2D    ADDA   $542D
8CCD: 19          DAA
8CCE: B7 54 2D    STA    $542D
8CD1: 20 E4       BRA    $8CB7
8CD3: B6 54 2E    LDA    $542E
8CD6: B7 54 2D    STA    $542D
8CD9: 44          LSRA
8CDA: 44          LSRA
8CDB: 44          LSRA
8CDC: 44          LSRA
8CDD: 26 02       BNE    $8CE1
8CDF: 86 FF       LDA    #$FF
8CE1: C6 FC       LDB    #$FC
8CE3: ED C1       STD    ,U++
8CE5: B6 54 2D    LDA    $542D
8CE8: 84 0F       ANDA   #$0F
8CEA: ED C4       STD    ,U
8CEC: 39          RTS

8F10: 7D 42 3D    TST    $423D                                        
8F13: 26 24       BNE    $8F39                                        
8F15: 96 04       LDA    $04
8F17: 91 05       CMPA   $05
8F19: 23 01       BLS    $8F1C
8F1B: 39          RTS
8F1C: CE 8F 49    LDU    #jump_table_8fa9
8F1F: 48          ASLA
8F20: AD D6       JSR    [A,U]		; [indirect_jump] [nb_entries=2]
8F22: 7D 41 A5    TST    $41A5
8F25: 26 01       BNE    $8F28
8F27: 39          RTS
8F28: 0C 18       INC    $18
8F2A: 86 05       LDA    #$05
8F2C: 97 02       STA    $02
8F2E: 0F 04       CLR    $04
8F30: 0F 06       CLR    $06
8F32: 97 03       STA    $03
8F34: 0F 05       CLR    $05
8F36: 0F 07       CLR    $07
8F38: 39          RTS
8F39: B7 C0 00    STA    $C000
8F3C: 0F 02       CLR    $02
8F3E: 0F 04       CLR    $04
8F40: 0F 06       CLR    $06
8F42: 0F 03       CLR    $03
8F44: 0F 05       CLR    $05
8F46: 0F 07       CLR    $07
8F48: 39          RTS

8F4F: 0F D1       CLR    $D1
8F51: 0F 18       CLR    $18
8F53: BD B4 34    JSR    $B434
8F56: BD B4 B8    JSR    $B4B8
8F59: CE AF D6    LDU    #$AFD6
8F5C: 10 8E 32 10 LDY    #$3210
8F60: C6 FC       LDB    #$FC
8F62: A6 C0       LDA    ,U+
8F64: A7 E2       STA    ,-S    ; [local]
8F66: A6 C0       LDA    ,U+
8F68: ED A1       STD    ,Y++
8F6A: 6A E4       DEC    ,S    ; [local]
8F6C: 26 F8       BNE    $8F66
8F6E: A6 E0       LDA    ,S+    ; [local]
8F70: CE AF DA    LDU    #$AFDA
8F73: 10 8E 32 22 LDY    #$3222
8F77: C6 FC       LDB    #$FC
8F79: A6 C0       LDA    ,U+
8F7B: A7 E2       STA    ,-S    ; [local]
8F7D: A6 C0       LDA    ,U+
8F7F: ED A1       STD    ,Y++
8F81: 6A E4       DEC    ,S    ; [local]
8F83: 26 F8       BNE    $8F7D
8F85: A6 E0       LDA    ,S+    ; [local]
8F87: CE AF E5    LDU    #$AFE5
8F8A: 10 8E 32 42 LDY    #$3242
8F8E: C6 FC       LDB    #$FC
8F90: A6 C0       LDA    ,U+
8F92: A7 E2       STA    ,-S    ; [local]
8F94: A6 C0       LDA    ,U+
8F96: ED A1       STD    ,Y++
8F98: 6A E4       DEC    ,S    ; [local]
8F9A: 26 F8       BNE    $8F94
8F9C: A6 E0       LDA    ,S+    ; [local]
8F9E: CE AF EF    LDU    #$AFEF
8FA1: 10 8E 3C 1E LDY    #$3C1E
8FA5: C6 FC       LDB    #$FC
8FA7: A6 C0       LDA    ,U+
8FA9: A7 E2       STA    ,-S    ; [local]
8FAB: A6 C0       LDA    ,U+
8FAD: ED A1       STD    ,Y++
8FAF: 6A E4       DEC    ,S    ; [local]
8FB1: 26 F8       BNE    $8FAB
8FB3: A6 E0       LDA    ,S+    ; [local]
8FB5: CE AF FD    LDU    #$AFFD
8FB8: 10 8E 3D 1A LDY    #$3D1A
8FBC: C6 FC       LDB    #$FC
8FBE: A6 C0       LDA    ,U+
8FC0: A7 E2       STA    ,-S    ; [local]
8FC2: A6 C0       LDA    ,U+
8FC4: ED A1       STD    ,Y++
8FC6: 6A E4       DEC    ,S    ; [local]
8FC8: 26 F8       BNE    $8FC2
8FCA: A6 E0       LDA    ,S+    ; [local]
8FCC: CE B0 11    LDU    #$B011
8FCF: 10 8E 3F 88 LDY    #$3F88
8FD3: C6 FC       LDB    #$FC
8FD5: A6 C0       LDA    ,U+
8FD7: A7 E2       STA    ,-S    ; [local]
8FD9: A6 C0       LDA    ,U+
8FDB: ED A1       STD    ,Y++
8FDD: 6A E4       DEC    ,S    ; [local]
8FDF: 26 F8       BNE    $8FD9
8FE1: A6 E0       LDA    ,S+    ; [local]
8FE3: C6 E4       LDB    #$E4
8FE5: 8D 6B       BSR    $9052
8FE7: 8E 54 54    LDX    #$5454
8FEA: CE 32 8C    LDU    #$328C
8FED: C6 FC       LDB    #$FC
8FEF: BD 94 77    JSR    $9477
8FF2: 8E 54 50    LDX    #$5450
8FF5: CE 32 A4    LDU    #$32A4
8FF8: C6 E4       LDB    #$E4
8FFA: BD 94 77    JSR    $9477
8FFD: 8E 54 58    LDX    #$5458
9000: CE 32 BE    LDU    #$32BE
9003: C6 FC       LDB    #$FC
9005: BD 94 77    JSR    $9477
9008: C6 FC       LDB    #$FC
900A: B6 41 89    LDA    $4189
900D: 26 02       BNE    $9011
900F: 86 FF       LDA    #$FF
9011: FD 3F 96    STD    $3F96
9014: B6 41 8A    LDA    $418A
9017: FD 3F 98    STD    $3F98
901A: 0C 04       INC    $04
901C: 0F 06       CLR    $06
901E: 96 D1       LDA    $D1
9020: 26 03       BNE    $9025
9022: 7E 90 CC    JMP    $90CC
9025: 7E D6 36    JMP    $D636
9028: 0F 06       CLR    $06
902A: CC 00 00    LDD    #$0000
902D: DD 88       STD    $88
902F: DD 8A       STD    $8A
9031: BD D8 36    JSR    $D836
9034: 0C 06       INC    $06
9036: 96 07       LDA    $07
9038: 81 01       CMPA   #$01
903A: 26 FA       BNE    $9036
903C: 39          RTS
903D: BD B4 B8    JSR    $B4B8
9040: BD 84 8C    JSR    $848C
9043: 0C D1       INC    $D1
9045: 0C 02       INC    $02
9047: 0F 04       CLR    $04
9049: 0F 06       CLR    $06
904B: 0C 03       INC    $03
904D: 0F 05       CLR    $05
904F: 0F 07       CLR    $07
9051: 39          RTS
9052: 8E 3E A4    LDX    #$3EA4
9055: CE 3F 24    LDU    #$3F24
9058: 86 40       LDA    #$40
905A: ED 81       STD    ,X++
905C: 4C          INCA
905D: ED 81       STD    ,X++
905F: 4C          INCA
9060: ED C1       STD    ,U++
9062: 4C          INCA
9063: ED C1       STD    ,U++
9065: 4C          INCA
9066: ED 81       STD    ,X++
9068: 4C          INCA
9069: ED 81       STD    ,X++
906B: 4C          INCA
906C: ED C1       STD    ,U++
906E: 4C          INCA
906F: ED C1       STD    ,U++
9071: 4C          INCA
9072: ED 81       STD    ,X++
9074: 4C          INCA
9075: ED 81       STD    ,X++
9077: 4C          INCA
9078: ED C1       STD    ,U++
907A: 4C          INCA
907B: ED C1       STD    ,U++
907D: 4C          INCA
907E: ED 84       STD    ,X
9080: 8B 02       ADDA   #$02
9082: ED C4       STD    ,U
9084: 39          RTS

9085: 8E 3E A4    LDX    #$3EA4
9088: CE 3F 24    LDU    #$3F24
908B: CC FF 00    LDD    #$FF00
908E: ED 81       STD    ,X++
9090: ED C1       STD    ,U++
9092: 8C 3E B2    CMPX   #$3EB2
9095: 25 F7       BCS    $908E
9097: 39          RTS

9098: 86 19       LDA    #$19
909A: B7 68 00    STA    bankswitch_6800
909D: 8E 34 90    LDX    #$3490
90A0: CE 60 00    LDU    #$6000
90A3: EC C1       LDD    ,U++
90A5: ED E3       STD    ,--S   ; [local]
90A7: 6F E2       CLR    ,-S   ; [local]
90A9: E6 C0       LDB    ,U+
90AB: A6 61       LDA    $1,S   ; [local]
90AD: A7 E4       STA    ,S   ; [local]
90AF: A6 C0       LDA    ,U+
90B1: ED 81       STD    ,X++
90B3: 6A E4       DEC    ,S    ; [local]
90B5: 26 F8       BNE    $90AF
90B7: E7 E4       STB    ,S   ; [local]
90B9: C6 80       LDB    #$80
90BB: E0 61       SUBB   $1,S   ; [local]
90BD: E0 61       SUBB   $1,S   ; [local]
90BF: 3A          ABX
90C0: E6 E4       LDB    ,S   ; [local]
90C2: B7 80 00    STA    watchdog_8000
90C5: 6A 62       DEC    $2,S   ; [local]
90C7: 26 E2       BNE    $90AB
90C9: 32 63       LEAS   $3,S	; [free_locals]
90CB: 39          RTS

90CC: 86 19       LDA    #$19
90CE: B7 68 00    STA    bankswitch_6800
90D1: 8E 34 90    LDX    #$3490
90D4: CE 61 1B    LDU    #$611B
90D7: CC 1C 0A    LDD    #$1C0A
90DA: ED E3       STD    ,--S	    ; [local]
90DC: 6F E2       CLR    ,-S		    ; [local]
90DE: A6 61       LDA    $1,S		    ; [local]
90E0: A7 E4       STA    ,S    ; [local]
90E2: EC C1       LDD    ,U++
90E4: ED 81       STD    ,X++
90E6: 6A E4       DEC    ,S    ; [local]
90E8: 26 F8       BNE    $90E2
90EA: C6 80       LDB    #$80
90EC: E0 61       SUBB   $1,S    ; [local]
90EE: E0 61       SUBB   $1,S    ; [local]
90F0: 3A          ABX
90F1: B7 80 00    STA    watchdog_8000
90F4: 6A 62       DEC    $2,S    ; [local]
90F6: 26 E6       BNE    $90DE
90F8: 32 63       LEAS   $3,S	; [free_locals]
90FA: 39          RTS

90FB: 7D 42 3D    TST    $423D
90FE: 26 14       BNE    $9114
9100: 7D 41 A5    TST    $41A5
9103: 27 02       BEQ    $9107
9105: 0C 18       INC    $18
9107: 96 04       LDA    $04
9109: 91 05       CMPA   $05
910B: 23 01       BLS    $910E
910D: 39          RTS
910E: CE 91 24    LDU    #jump_table_9124
9111: 48          ASLA
9112: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=10]
9114: B7 C0 00    STA    $C000
9117: 0F 02       CLR    $02
9119: 0F 04       CLR    $04
911B: 0F 06       CLR    $06
911D: 0F 03       CLR    $03
911F: 0F 05       CLR    $05
9121: 0F 07       CLR    $07
9123: 39          RTS

9138: 86 40       LDA    #$40
913A: 97 C1       STA    $C1
913C: 0F C2       CLR    $C2
913E: 0F C4       CLR    $C4
9140: 86 01       LDA    #$01
9142: 97 C3       STA    $C3
9144: 97 C5       STA    $C5
9146: CC 00 50    LDD    #$0050
9149: DD CA       STD    $CA
914B: CC 00 00    LDD    #$0000
914E: DD CC       STD    $CC
9150: 0F CE       CLR    $CE
9152: 0F CF       CLR    $CF
9154: CC 00 30    LDD    #$0030
9157: DD 11       STD    $11
9159: 0F 13       CLR    $13
915B: 0F 18       CLR    $18
915D: CC 00 00    LDD    #$0000
9160: DD 14       STD    $14
9162: DD 15       STD    $15
9164: 0C 04       INC    $04
9166: 0F 06       CLR    $06
9168: 39          RTS
9169: 8E 44 10    LDX    #$4410
916C: 6F 15       CLR    -$B,X
916E: 0F 0A       CLR    $0A
9170: 0F 0B       CLR    $0B
9172: 0F 0D       CLR    $0D
9174: 6F 14       CLR    -$C,X
9176: 0C 04       INC    $04
9178: 0F 06       CLR    $06
917A: 39          RTS
917B: 0F 06       CLR    $06
917D: CC 00 00    LDD    #$0000
9180: DD 88       STD    $88
9182: DD 8A       STD    $8A
9184: 0C 06       INC    $06
9186: 96 07       LDA    $07
9188: 81 01       CMPA   #$01
918A: 26 FA       BNE    $9186
918C: 0D 18       TST    $18
918E: 26 43       BNE    $91D3
9190: 0D C1       TST    $C1
9192: 27 3C       BEQ    $91D0
9194: 0D 91       TST    $91
9196: 26 38       BNE    $91D0
9198: BD B6 18    JSR    $B618
919B: 0C 06       INC    $06
919D: BD DA 88    JSR    $DA88
91A0: 0C 06       INC    $06
91A2: BD D8 36    JSR    $D836
91A5: 0C 06       INC    $06
91A7: BD D2 71    JSR    $D271
91AA: 0C 06       INC    $06
91AC: 96 07       LDA    $07
91AE: 81 03       CMPA   #$03
91B0: 25 FA       BCS    $91AC
91B2: BD D3 85    JSR    $D385
91B5: BD D2 CD    JSR    $D2CD
91B8: 96 13       LDA    $13
91BA: 4C          INCA
91BB: 84 3F       ANDA   #$3F
91BD: 97 13       STA    $13
91BF: 27 01       BEQ    $91C2
91C1: 39          RTS
91C2: CE 56 11    LDU    #$5611
91C5: CC 99 99    LDD    #$9999
91C8: BD 98 EF    JSR    $98EF
91CB: DC 11       LDD    $11
91CD: 27 01       BEQ    $91D0
91CF: 39          RTS
91D0: 0C 18       INC    $18
91D2: 39          RTS
91D3: 0C 04       INC    $04
91D5: 0F 06       CLR    $06
91D7: 0C 05       INC    $05
91D9: 0F 07       CLR    $07
91DB: 39          RTS
91DC: 0F E8       CLR    $E8
91DE: BD 84 E0    JSR    $84E0
91E1: BD 84 F9    JSR    $84F9
91E4: 0C 04       INC    $04
91E6: 0F 06       CLR    $06
91E8: 39          RTS
91E9: 96 B3       LDA    $B3
91EB: 91 B4       CMPA   $B4
91ED: 27 01       BEQ    $91F0
91EF: 39          RTS
91F0: BD 84 23    JSR    $8423
91F3: BD 84 BA    JSR    $84BA
91F6: 0C 04       INC    $04
91F8: 0F 06       CLR    $06
91FA: 39          RTS
91FB: 96 6E       LDA    $6E
91FD: 91 6F       CMPA   $6F
91FF: 27 01       BEQ    $9202
9201: 39          RTS
9202: BD 83 CB    JSR    $83CB
9205: BD 84 CD    JSR    $84CD
9208: BD 84 8C    JSR    $848C
920B: 7D 41 A5    TST    $41A5
920E: 26 0F       BNE    $921F
9210: 86 04       LDA    #$04
9212: 97 02       STA    $02
9214: 0F 04       CLR    $04
9216: 0F 06       CLR    $06
9218: 97 03       STA    $03
921A: 0F 05       CLR    $05
921C: 0F 07       CLR    $07
921E: 39          RTS
921F: 86 05       LDA    #$05
9221: 97 02       STA    $02
9223: 0F 04       CLR    $04
9225: 0F 06       CLR    $06
9227: 97 03       STA    $03
9229: 0F 05       CLR    $05
922B: 0F 07       CLR    $07
922D: 39          RTS
922E: C6 FC       LDB    #$FC
9230: B6 41 89    LDA    $4189
9233: 26 02       BNE    $9237
9235: 86 FF       LDA    #$FF
9237: FD 3F 96    STD    $3F96
923A: B6 41 8A    LDA    $418A
923D: FD 3F 98    STD    $3F98
9240: 7D 42 3D    TST    $423D
9243: 26 26       BNE    $926B
9245: 96 04       LDA    $04
9247: 91 05       CMPA   $05
9249: 23 01       BLS    $924C
924B: 39          RTS
924C: CE 92 7B    LDU    #jump_table_927b
924F: 48          ASLA
9250: AD D6       JSR    [A,U]        ; [indirect_jump] [nb_entries=7]
9252: 7D 41 A5    TST    $41A5
9255: 26 01       BNE    $9258
9257: 39          RTS
9258: 86 01       LDA    #$01
925A: 97 D1       STA    $D1
925C: 86 05       LDA    #$05
925E: 97 02       STA    $02
9260: 0F 04       CLR    $04
9262: 0F 06       CLR    $06
9264: 97 03       STA    $03
9266: 0F 05       CLR    $05
9268: 0F 07       CLR    $07
926A: 39          RTS
926B: B7 C0 00    STA    $C000
926E: 0F 02       CLR    $02
9270: 0F 04       CLR    $04
9272: 0F 06       CLR    $06
9274: 0F 03       CLR    $03
9276: 0F 05       CLR    $05
9278: 0F 07       CLR    $07
927A: 39          RTS
927B: 92 89       SBCA   $89
927D: 92 90       SBCA   $90
927F: 92 99       SBCA   $99
9281: 92 A3       SBCA   $A3
9283: 92 BE       SBCA   $BE
9285: 92 D3       SBCA   $D3
9287: 92 E6       SBCA   $E6
9289: 0C 04       INC    $04
928B: 0F 06       CLR    $06
928D: 7E B4 34    JMP    $B434
9290: 0F 0E       CLR    $0E
9292: 0C 04       INC    $04
9294: 0C 05       INC    $05
9296: 7E 97 D4    JMP    $97D4
9299: 96 0E       LDA    $0E
929B: 27 01       BEQ    $929E
929D: 39          RTS
929E: 0C 04       INC    $04
92A0: 0C 05       INC    $05
92A2: 39          RTS
92A3: BD B4 B8    JSR    $B4B8
92A6: 86 05       LDA    #$05
92A8: 97 D1       STA    $D1
92AA: 10 8E 53 80 LDY    #$5380
92AE: 96 E2       LDA    $E2
92B0: C6 67       LDB    #$67
92B2: E7 A6       STB    A,Y
92B4: 4C          INCA
92B5: 84 1F       ANDA   #$1F
92B7: 97 E2       STA    $E2
92B9: 0C 04       INC    $04
92BB: 7E D6 36    JMP    $D636
92BE: 0F D2       CLR    $D2
92C0: CC 00 00    LDD    #$0000
92C3: DD 88       STD    $88
92C5: DD 8A       STD    $8A
92C7: BD D8 36    JSR    $D836
92CA: 0C D2       INC    $D2
92CC: 96 D2       LDA    $D2
92CE: 81 02       CMPA   #$02
92D0: 26 FA       BNE    $92CC
92D2: 39          RTS
92D3: BD 84 E0    JSR    $84E0
92D6: BD 84 F9    JSR    $84F9
92D9: BD 84 23    JSR    $8423
92DC: BD 84 8C    JSR    $848C
92DF: 0C 04       INC    $04
92E1: 0C 05       INC    $05
92E3: 7E B4 B8    JMP    $B4B8
92E6: 0F D1       CLR    $D1
92E8: 86 02       LDA    #$02
92EA: 97 02       STA    $02
92EC: 0F 04       CLR    $04
92EE: 0F 06       CLR    $06
92F0: 97 03       STA    $03
92F2: 0F 05       CLR    $05
92F4: 0F 07       CLR    $07
92F6: 39          RTS
92F7: BD 93 7A    JSR    $937A
92FA: BD 94 E4    JSR    $94E4
92FD: BD 95 39    JSR    $9539
9300: 96 01       LDA    $01
9302: 26 2F       BNE    $9333
9304: 96 0E       LDA    $0E
9306: 84 10       ANDA   #$10
9308: 26 19       BNE    $9323
930A: CE AF D6    LDU    #$AFD6
930D: 10 8E 32 10 LDY    #$3210
9311: C6 FC       LDB    #$FC
9313: A6 C0       LDA    ,U+
9315: A7 E2       STA    ,-S    ; [local]
9317: A6 C0       LDA    ,U+
9319: ED A1       STD    ,Y++
931B: 6A E4       DEC    ,S    ; [local]
931D: 26 F8       BNE    $9317
931F: A6 E0       LDA    ,S+    ; [local]
9321: 20 3D       BRA    $9360
9323: 10 8E 32 10 LDY    #$3210
9327: 86 FF       LDA    #$FF
9329: F6 AF D6    LDB    $AFD6
932C: A7 A1       STA    ,Y++
932E: 5A          DECB
932F: 26 FB       BNE    $932C
9331: 20 2D       BRA    $9360
9333: 96 0E       LDA    $0E
9335: 84 10       ANDA   #$10
9337: 26 19       BNE    $9352
9339: CE AF E5    LDU    #$AFE5
933C: 10 8E 32 42 LDY    #$3242
9340: C6 FC       LDB    #$FC
9342: A6 C0       LDA    ,U+
9344: A7 E2       STA    ,-S    ; [local]
9346: A6 C0       LDA    ,U+
9348: ED A1       STD    ,Y++
934A: 6A E4       DEC    ,S    ; [local]
934C: 26 F8       BNE    $9346
934E: A6 E0       LDA    ,S+    ; [local]
9350: 20 0E       BRA    $9360
9352: 10 8E 32 42 LDY    #$3242
9356: 86 FF       LDA    #$FF
9358: F6 AF E5    LDB    $AFE5
935B: A7 A1       STA    ,Y++
935D: 5A          DECB
935E: 26 FB       BNE    $935B
9360: 96 CE       LDA    $CE
9362: 27 0B       BEQ    $936F
9364: 8E 56 CC    LDX    #$56CC
9367: CE 3F 16    LDU    #$3F16
936A: C6 FC       LDB    #$FC
936C: BD 95 83    JSR    $9583
936F: 8E 56 CA    LDX    #$56CA
9372: CE 3F 96    LDU    #$3F96
9375: C6 FC       LDB    #$FC
9377: 7E 95 83    JMP    $9583
937A: CE 54 5C    LDU    #$545C
937D: FC 54 5E    LDD    $545E
9380: BD 98 EF    JSR    $98EF
9383: CE 54 54    LDU    #$5454
9386: 96 01       LDA    $01
9388: 48          ASLA
9389: 48          ASLA
938A: 33 C6       LEAU   A,U
938C: FC 54 5C    LDD    $545C
938F: BD 98 D6    JSR    $98D6
9392: CC 00 00    LDD    #$0000
9395: FD 54 5C    STD    $545C
9398: FD 54 5E    STD    $545E
939B: 8E 54 50    LDX    #$5450
939E: EC C4       LDD    ,U
93A0: 10 A3 84    CMPD   ,X
93A3: 25 10       BCS    $93B5
93A5: 22 06       BHI    $93AD
93A7: A6 42       LDA    $2,U
93A9: A1 02       CMPA   $2,X
93AB: 23 08       BLS    $93B5
93AD: EC C4       LDD    ,U
93AF: ED 84       STD    ,X
93B1: A6 42       LDA    $2,U
93B3: A7 02       STA    $2,X
93B5: 8E 94 6F    LDX    #$946F
93B8: F6 42 4F    LDB    $424F
93BB: 58          ASLB
93BC: 58          ASLB
93BD: 3A          ABX
93BE: 96 D0       LDA    $D0
93C0: 81 02       CMPA   #$02
93C2: 24 20       BCC    $93E4
93C4: 48          ASLA
93C5: EC 86       LDD    A,X
93C7: 10 A3 C4    CMPD   ,U
93CA: 22 18       BHI    $93E4
93CC: 10 8E 53 40 LDY    #$5340
93D0: 96 E0       LDA    $E0
93D2: C6 10       LDB    #$10
93D4: E7 A6       STB    A,Y
93D6: 4C          INCA
93D7: 84 1F       ANDA   #$1F
93D9: 97 E0       STA    $E0
93DB: 96 C0       LDA    $C0
93DD: 8B 01       ADDA   #$01
93DF: 19          DAA
93E0: 97 C0       STA    $C0
93E2: 0C D0       INC    $D0
93E4: 8E 54 54    LDX    #$5454
93E7: CE 32 8C    LDU    #$328C
93EA: C6 FC       LDB    #$FC
93EC: BD 94 77    JSR    $9477
93EF: 8E 54 50    LDX    #$5450
93F2: CE 32 A4    LDU    #$32A4
93F5: C6 E4       LDB    #$E4
93F7: BD 94 77    JSR    $9477
93FA: 8E 54 58    LDX    #$5458
93FD: CE 32 BE    LDU    #$32BE
9400: C6 FC       LDB    #$FC
9402: BD 94 77    JSR    $9477
9405: 0D 01       TST    $01
9407: 26 33       BNE    $943C
9409: 10 8E 33 10 LDY    #$3310
940D: C6 FC       LDB    #$FC
940F: 96 C0       LDA    $C0
9411: 44          LSRA
9412: 44          LSRA
9413: 44          LSRA
9414: 44          LSRA
9415: 26 02       BNE    $9419
9417: 86 FF       LDA    #$FF
9419: ED A4       STD    ,Y
941B: 96 C0       LDA    $C0
941D: 84 0F       ANDA   #$0F
941F: ED 22       STD    $2,Y
9421: 10 8E 33 4A LDY    #$334A
9425: C6 FC       LDB    #$FC
9427: B6 54 A0    LDA    $54A0
942A: 44          LSRA
942B: 44          LSRA
942C: 44          LSRA
942D: 44          LSRA
942E: 26 02       BNE    $9432
9430: 86 FF       LDA    #$FF
9432: ED A4       STD    ,Y
9434: B6 54 A0    LDA    $54A0
9437: 84 0F       ANDA   #$0F
9439: ED 22       STD    $2,Y
943B: 39          RTS
943C: 10 8E 33 10 LDY    #$3310
9440: C6 FC       LDB    #$FC
9442: B6 54 80    LDA    $5480
9445: 44          LSRA
9446: 44          LSRA
9447: 44          LSRA
9448: 44          LSRA
9449: 26 02       BNE    $944D
944B: 86 FF       LDA    #$FF
944D: ED A4       STD    ,Y
944F: B6 54 80    LDA    $5480
9452: 84 0F       ANDA   #$0F
9454: ED 22       STD    $2,Y
9456: 10 8E 33 4A LDY    #$334A
945A: C6 FC       LDB    #$FC
945C: 96 C0       LDA    $C0
945E: 44          LSRA
945F: 44          LSRA
9460: 44          LSRA
9461: 44          LSRA
9462: 26 02       BNE    $9466
9464: 86 FF       LDA    #$FF
9466: ED A4       STD    ,Y
9468: 96 C0       LDA    $C0
946A: 84 0F       ANDA   #$0F
946C: ED 22       STD    $2,Y
946E: 39          RTS

9477: 6F E2       CLR    ,-S		; [alloc_locals]
9479: A6 84       LDA    ,X
947B: 44          LSRA
947C: 44          LSRA
947D: 44          LSRA
947E: 44          LSRA
947F: 26 06       BNE    $9487
9481: 86 FF       LDA    #$FF
9483: ED C1       STD    ,U++
9485: 20 04       BRA    $948B
9487: 6C E4       INC    ,S	; [local]
9489: ED C1       STD    ,U++
948B: A6 80       LDA    ,X+
948D: 84 0F       ANDA   #$0F
948F: 26 0A       BNE    $949B
9491: 6D E4       TST    ,S	; [local]
9493: 26 06       BNE    $949B
9495: 86 FF       LDA    #$FF
9497: ED C1       STD    ,U++
9499: 20 04       BRA    $949F
949B: 6C E4       INC    ,S	; [local]
949D: ED C1       STD    ,U++
949F: A6 84       LDA    ,X
94A1: 44          LSRA
94A2: 44          LSRA
94A3: 44          LSRA
94A4: 44          LSRA
94A5: 26 0A       BNE    $94B1
94A7: 6D E4       TST    ,S	; [local]
94A9: 26 06       BNE    $94B1
94AB: 86 FF       LDA    #$FF
94AD: ED C1       STD    ,U++
94AF: 20 04       BRA    $94B5
94B1: 6C E4       INC    ,S	; [local]
94B3: ED C1       STD    ,U++
94B5: A6 80       LDA    ,X+
94B7: 84 0F       ANDA   #$0F
94B9: 26 0A       BNE    $94C5
94BB: 6D E4       TST    ,S	; [local]
94BD: 26 06       BNE    $94C5
94BF: 86 FF       LDA    #$FF
94C1: ED C1       STD    ,U++
94C3: 20 04       BRA    $94C9
94C5: 6C E4       INC    ,S	; [local]
94C7: ED C1       STD    ,U++
94C9: A6 84       LDA    ,X
94CB: 44          LSRA
94CC: 44          LSRA
94CD: 44          LSRA
94CE: 44          LSRA
94CF: 26 06       BNE    $94D7
94D1: 6D E4       TST    ,S	; [local]
94D3: 26 02       BNE    $94D7
94D5: 86 FF       LDA    #$FF
94D7: ED C1       STD    ,U++
94D9: A6 84       LDA    ,X
94DB: 84 0F       ANDA   #$0F
94DD: ED C1       STD    ,U++
94DF: 4F          CLRA
94E0: ED C4       STD    ,U
94E2: 35 82       PULS   A,PC	; [free_locals]

94E4: 0D C1       TST    $C1
94E6: 27 1F       BEQ    $9507
94E8: 7D 44 0C    TST    $440C
94EB: 2B 08       BMI    $94F5
94ED: 0D 10       TST    $10
94EF: 27 04       BEQ    $94F5
94F1: 0F 14       CLR    $14
94F3: 0F 15       CLR    $15
94F5: 0D 14       TST    $14
94F7: 27 06       BEQ    $94FF
94F9: 0A 14       DEC    $14
94FB: 0A C1       DEC    $C1
94FD: 20 08       BRA    $9507
94FF: 0D 15       TST    $15
9501: 27 04       BEQ    $9507
9503: 0A C1       DEC    $C1
9505: 0A 15       DEC    $15
9507: 8E 3F AC    LDX    #$3FAC
950A: D6 C1       LDB    $C1
950C: C4 78       ANDB   #$78
950E: 54          LSRB
950F: 54          LSRB
9510: 3A          ABX
9511: CE 95 33    LDU    #$9533
9514: 96 C1       LDA    $C1
9516: A1 C1       CMPA   ,U++
9518: 25 FC       BCS    $9516
951A: E6 5F       LDB    -$1,U
951C: 81 40       CMPA   #$40
951E: 24 07       BCC    $9527
9520: 84 07       ANDA   #$07
9522: 80 68       SUBA   #$68
9524: 40          NEGA
9525: ED 84       STD    ,X
9527: 86 61       LDA    #$61
9529: 8C 3F AC    CMPX   #$3FAC
952C: 26 01       BNE    $952F
952E: 39          RTS
952F: ED 83       STD    ,--X
9531: 20 F6       BRA    $9529

9539: DC 11       LDD    $11
953B: 27 24       BEQ    $9561
953D: B6 44 11    LDA    $4411
9540: 84 FC       ANDA   #$FC
9542: 81 9C       CMPA   #$9C
9544: 27 1B       BEQ    $9561
9546: 96 13       LDA    $13
9548: 4C          INCA
9549: 84 3F       ANDA   #$3F
954B: 97 13       STA    $13
954D: 26 12       BNE    $9561
954F: CE 56 11    LDU    #$5611
9552: CC 99 99    LDD    #$9999
9555: BD 98 EF    JSR    $98EF
9558: DC 11       LDD    $11
955A: 26 05       BNE    $9561
955C: C6 60       LDB    #$60
955E: F7 44 17    STB    $4417
9561: CE 95 7A    LDU    #$957A
9564: DC 11       LDD    $11
9566: 10 A3 C1    CMPD   ,U++
9569: 24 04       BCC    $956F
956B: 33 41       LEAU   $1,U
956D: 20 F7       BRA    $9566
956F: E6 C0       LDB    ,U+
9571: 8E 56 11    LDX    #$5611
9574: CE 3F C8    LDU    #$3FC8
9577: 7E 95 83    JMP    $9583

9583: 6F E2       CLR    ,-S		; [local]
9585: A6 80       LDA    ,X+
9587: 84 0F       ANDA   #$0F
9589: 26 06       BNE    $9591
958B: 86 FF       LDA    #$FF
958D: ED C1       STD    ,U++
958F: 20 04       BRA    $9595
9591: 6C E4       INC    ,S		; [local]
9593: ED C1       STD    ,U++
9595: A6 84       LDA    ,X
9597: 44          LSRA
9598: 44          LSRA
9599: 44          LSRA
959A: 44          LSRA
959B: 26 0A       BNE    $95A7
959D: 6D E4       TST    ,S		; [local]
959F: 26 06       BNE    $95A7
95A1: 86 FF       LDA    #$FF
95A3: ED C1       STD    ,U++
95A5: 20 04       BRA    $95AB
95A7: 6C E4       INC    ,S		; [local]
95A9: ED C1       STD    ,U++
95AB: A6 80       LDA    ,X+
95AD: 84 0F       ANDA   #$0F
95AF: ED C1       STD    ,U++
95B1: 35 82       PULS   A,PC	; [manual_stack_pull]

95E3: C6 05       LDB    #$05
95E5: CE 54 00    LDU    #$5400
95E8: 8E 96 0D    LDX    #$960D
95EB: 34 40       PSHS   U
95ED: 10 8E 00 07 LDY    #$0007
95F1: A6 80       LDA    ,X+
95F3: A7 C0       STA    ,U+
95F5: 31 3F       LEAY   -$1,Y
95F7: 26 F8       BNE    $95F1
95F9: 35 40       PULS   U
95FB: 33 47       LEAU   $7,U
95FD: 5A          DECB
95FE: 26 EB       BNE    $95EB
9600: 7F 54 2D    CLR    $542D
9603: CC 00 30    LDD    #$0030
9606: FD 54 50    STD    $5450
9609: B7 54 52    STA    $5452
960C: 39          RTS

9630: CE 96 39    LDU    #jump_table_9639
9633: B6 54 2D    LDA    $542D
9636: 48          ASLA
9637: 6E D6       JMP    [A,U]  ; [indirect_jump] [nb_entries=4]

9641: 39          RTS
9642: CE 54 00    LDU    #$5400
9645: 7F 54 2A    CLR    $542A
9648: 86 01       LDA    #$01
964A: B7 54 31    STA    $5431
964D: 10 8E 54 54 LDY    #$5454
9651: 96 01       LDA    $01
9653: 27 02       BEQ    $9657
9655: 31 24       LEAY   $4,Y
9657: EC A4       LDD    ,Y
9659: 10 A3 C4    CMPD   ,U
965C: 22 16       BHI    $9674
965E: 25 06       BCS    $9666
9660: A6 22       LDA    $2,Y
9662: A1 42       CMPA   $2,U
9664: 24 0E       BCC    $9674
9666: 33 47       LEAU   $7,U
9668: 7C 54 2A    INC    $542A
966B: 11 83 54 23 CMPU   #$5423
966F: 25 E6       BCS    $9657
9671: 7E 97 CC    JMP    $97CC
9674: 34 40       PSHS   U
9676: CE 54 54    LDU    #$5454
9679: 96 01       LDA    $01
967B: 27 02       BEQ    $967F
967D: 33 44       LEAU   $4,U
967F: 10 8E 54 23 LDY    #$5423
9683: EC C1       LDD    ,U++
9685: ED A1       STD    ,Y++
9687: A6 C0       LDA    ,U+
9689: A7 A0       STA    ,Y+
968B: 96 C5       LDA    $C5
968D: A7 A0       STA    ,Y+
968F: CE 95 E0    LDU    #$95E0
9692: C6 03       LDB    #$03
9694: A6 C0       LDA    ,U+
9696: A7 A0       STA    ,Y+
9698: 5A          DECB
9699: 26 F9       BNE    $9694
969B: 35 40       PULS   U
969D: 10 8E 54 23 LDY    #$5423
96A1: C6 07       LDB    #$07
96A3: 34 20       PSHS   Y
96A5: E7 E2       STB    ,-S		; [local]
96A7: A6 A4       LDA    ,Y
96A9: E6 C4       LDB    ,U
96AB: A7 C0       STA    ,U+
96AD: E7 A0       STB    ,Y+
96AF: E6 E0       LDB    ,S+		; [local]
96B1: 5A          DECB
96B2: 26 F1       BNE    $96A5
96B4: 35 20       PULS   Y
96B6: 11 83 54 23 CMPU   #$5423
96BA: 26 E5       BNE    $96A1
96BC: 4F          CLRA
96BD: B7 54 2B    STA    $542B
96C0: B7 54 2C    STA    $542C
96C3: BD B4 B8    JSR    $B4B8
96C6: BD 97 D4    JSR    $97D4
96C9: 86 0B       LDA    #$0B
96CB: 97 E8       STA    $E8
96CD: CE 35 95    LDU    #$3595
96D0: B6 54 2A    LDA    $542A
96D3: 5F          CLRB
96D4: 33 CB       LEAU   D,U
96D6: CC E4 15    LDD    #$E415
96D9: A7 C1       STA    ,U++
96DB: 5A          DECB
96DC: 26 FB       BNE    $96D9
96DE: 7C 54 2D    INC    $542D
96E1: CC 07 00    LDD    #$0700
96E4: FD 54 2E    STD    $542E
96E7: 39          RTS
96E8: FC 54 2E    LDD    $542E
96EB: 83 00 01    SUBD   #$0001
96EE: 10 27 00 89 LBEQ   $977B
96F2: FD 54 2E    STD    $542E
96F5: CE 42 78    LDU    #$4278
96F8: 96 01       LDA    $01
96FA: 27 07       BEQ    $9703
96FC: B6 42 59    LDA    $4259
96FF: 27 02       BEQ    $9703
9701: 33 54       LEAU   -$C,U
9703: A6 C4       LDA    ,U
9705: 27 0C       BEQ    $9713
9707: B6 54 2B    LDA    $542B
970A: 81 02       CMPA   #$02
970C: 27 6D       BEQ    $977B
970E: 7C 54 2B    INC    $542B
9711: 20 49       BRA    $975C
9713: CE 42 80    LDU    #$4280
9716: 96 01       LDA    $01
9718: 27 07       BEQ    $9721
971A: B6 42 59    LDA    $4259
971D: 27 02       BEQ    $9721
971F: 33 54       LEAU   -$C,U
9721: EC C4       LDD    ,U
9723: 27 13       BEQ    $9738
9725: 4D          TSTA
9726: 26 0B       BNE    $9733
9728: B6 54 30    LDA    $5430
972B: 8B 20       ADDA   #$20
972D: B7 54 30    STA    $5430
9730: 25 01       BCS    $9733
9732: 39          RTS
9733: 7A 54 2C    DEC    $542C
9736: 20 24       BRA    $975C
9738: CE 42 7E    LDU    #$427E
973B: 96 01       LDA    $01
973D: 27 07       BEQ    $9746
973F: B6 42 59    LDA    $4259
9742: 27 02       BEQ    $9746
9744: 33 54       LEAU   -$C,U
9746: EC C4       LDD    ,U
9748: 26 01       BNE    $974B
974A: 39          RTS
974B: 4D          TSTA
974C: 26 0B       BNE    $9759
974E: B6 54 30    LDA    $5430
9751: 8B 20       ADDA   #$20
9753: B7 54 30    STA    $5430
9756: 25 01       BCS    $9759
9758: 39          RTS
9759: 7C 54 2C    INC    $542C
975C: CE 35 BC    LDU    #$35BC
975F: B6 54 2A    LDA    $542A
9762: 5F          CLRB
9763: 33 CB       LEAU   D,U
9765: F6 54 2B    LDB    $542B
9768: 58          ASLB
9769: 4F          CLRA
976A: 33 CB       LEAU   D,U
976C: B6 54 2C    LDA    $542C
976F: 84 1F       ANDA   #$1F
9771: 8B 0A       ADDA   #$0A
9773: C6 E4       LDB    #$E4
9775: ED C4       STD    ,U
9777: 7F 54 30    CLR    $5430
977A: 39          RTS
977B: CE 35 BC    LDU    #$35BC
977E: B6 54 2A    LDA    $542A
9781: 5F          CLRB
9782: 33 CB       LEAU   D,U
9784: 10 8E 54 04 LDY    #$5404
9788: 86 07       LDA    #$07
978A: F6 54 2A    LDB    $542A
978D: 3D          MUL
978E: 31 AB       LEAY   D,Y
9790: C6 03       LDB    #$03
9792: A6 C1       LDA    ,U++
9794: A7 A0       STA    ,Y+
9796: 5A          DECB
9797: 26 F9       BNE    $9792
9799: 7C 54 2D    INC    $542D
979C: 86 B4       LDA    #$B4
979E: B7 54 2E    STA    $542E
97A1: 39          RTS
97A2: 7A 54 2E    DEC    $542E
97A5: 27 25       BEQ    $97CC
97A7: 96 0E       LDA    $0E
97A9: 85 03       BITA   #$03
97AB: 27 01       BEQ    $97AE
97AD: 39          RTS
97AE: CE 35 95    LDU    #$3595
97B1: B6 54 2A    LDA    $542A
97B4: 5F          CLRB
97B5: 33 CB       LEAU   D,U
97B7: 86 E4       LDA    #$E4
97B9: 10 8E 00 17 LDY    #$0017
97BD: D6 0E       LDB    $0E
97BF: C4 04       ANDB   #$04
97C1: 27 02       BEQ    $97C5
97C3: 86 FC       LDA    #$FC
97C5: A7 C1       STA    ,U++
97C7: 31 3F       LEAY   -$1,Y
97C9: 26 FA       BNE    $97C5
97CB: 39          RTS
97CC: 4F          CLRA
97CD: B7 54 2D    STA    $542D
97D0: B7 54 31    STA    $5431
97D3: 39          RTS
97D4: CE 95 B3    LDU    #$95B3
97D7: 10 8E 34 26 LDY    #$3426
97DB: C6 FC       LDB    #$FC
97DD: A6 C0       LDA    ,U+
97DF: A7 E2       STA    ,-S    ; [local]
97E1: A6 C0       LDA    ,U+
97E3: ED A1       STD    ,Y++
97E5: 6A E4       DEC    ,S    ; [local]
97E7: 26 F8       BNE    $97E1
97E9: A6 E0       LDA    ,S+    ; [local]
97EB: CE 95 B9    LDU    #$95B9
97EE: 10 8E 34 A0 LDY    #$34A0
97F2: C6 FC       LDB    #$FC
97F4: A6 C0       LDA    ,U+
97F6: A7 E2       STA    ,-S    ; [local]
97F8: A6 C0       LDA    ,U+
97FA: ED A1       STD    ,Y++
97FC: 6A E4       DEC    ,S    ; [local]
97FE: 26 F8       BNE    $97F8
9800: A6 E0       LDA    ,S+    ; [local]
9802: CE 95 CC    LDU    #$95CC
9805: 10 8E 35 94 LDY    #$3594
9809: C6 FC       LDB    #$FC
980B: A6 C0       LDA    ,U+
980D: A7 E2       STA    ,-S    ; [local]
980F: A6 C0       LDA    ,U+
9811: ED A1       STD    ,Y++
9813: 6A E4       DEC    ,S    ; [local]
9815: 26 F8       BNE    $980F
9817: A6 E0       LDA    ,S+    ; [local]
9819: CE 95 D0    LDU    #$95D0
981C: 10 8E 36 94 LDY    #$3694
9820: C6 FC       LDB    #$FC
9822: A6 C0       LDA    ,U+
9824: A7 E2       STA    ,-S    ; [local]
9826: A6 C0       LDA    ,U+
9828: ED A1       STD    ,Y++
982A: 6A E4       DEC    ,S    ; [local]
982C: 26 F8       BNE    $9826
982E: A6 E0       LDA    ,S+    ; [local]
9830: CE 95 D4    LDU    #$95D4
9833: 10 8E 37 94 LDY    #$3794
9837: C6 FC       LDB    #$FC
9839: A6 C0       LDA    ,U+
983B: A7 E2       STA    ,-S    ; [local]
983D: A6 C0       LDA    ,U+
983F: ED A1       STD    ,Y++
9841: 6A E4       DEC    ,S    ; [local]
9843: 26 F8       BNE    $983D
9845: A6 E0       LDA    ,S+    ; [local]
9847: CE 95 D8    LDU    #$95D8
984A: 10 8E 38 94 LDY    #$3894
984E: C6 FC       LDB    #$FC
9850: A6 C0       LDA    ,U+
9852: A7 E2       STA    ,-S    ; [local]
9854: A6 C0       LDA    ,U+
9856: ED A1       STD    ,Y++
9858: 6A E4       DEC    ,S    ; [local]
985A: 26 F8       BNE    $9854
985C: A6 E0       LDA    ,S+    ; [local]
985E: CE 95 DC    LDU    #$95DC
9861: 10 8E 39 94 LDY    #$3994
9865: C6 FC       LDB    #$FC
9867: A6 C0       LDA    ,U+
9869: A7 E2       STA    ,-S    ; [local]
986B: A6 C0       LDA    ,U+
986D: ED A1       STD    ,Y++
986F: 6A E4       DEC    ,S    ; [local]
9871: 26 F8       BNE    $986B
9873: A6 E0       LDA    ,S+    ; [local]
9875: 34 10       PSHS   X
9877: 10 8E 54 00 LDY    #$5400
987B: CE 35 9C    LDU    #$359C
987E: C6 05       LDB    #$05
9880: 34 44       PSHS   U,B
9882: 8E 00 03    LDX    #$0003
9885: BD 98 B0    JSR    $98B0
9888: 6F C4       CLR    ,U
988A: 86 FC       LDA    #$FC
988C: A7 41       STA    $1,U
988E: 33 48       LEAU   $8,U
9890: 8E 00 01    LDX    #$0001
9893: BD 98 B0    JSR    $98B0
9896: 33 48       LEAU   $8,U
9898: C6 03       LDB    #$03
989A: A6 A0       LDA    ,Y+
989C: A7 C0       STA    ,U+
989E: 86 FC       LDA    #$FC
98A0: A7 C0       STA    ,U+
98A2: 5A          DECB
98A3: 26 F5       BNE    $989A
98A5: 35 44       PULS   B,U
98A7: 33 C9 01 00 LEAU   $0100,U
98AB: 5A          DECB
98AC: 26 D2       BNE    $9880
98AE: 35 90       PULS   X,PC
98B0: 5F          CLRB
98B1: A6 A4       LDA    ,Y
98B3: 44          LSRA
98B4: 44          LSRA
98B5: 44          LSRA
98B6: 44          LSRA
98B7: 8D 0B       BSR    $98C4
98B9: A6 A0       LDA    ,Y+
98BB: 84 0F       ANDA   #$0F
98BD: 8D 05       BSR    $98C4
98BF: 30 1F       LEAX   -$1,X
98C1: 26 EE       BNE    $98B1
98C3: 39          RTS
98C4: 4D          TSTA
98C5: 27 03       BEQ    $98CA
98C7: 5C          INCB
98C8: 20 05       BRA    $98CF
98CA: 5D          TSTB
98CB: 26 02       BNE    $98CF
98CD: 86 FF       LDA    #$FF
98CF: A7 C0       STA    ,U+
98D1: 86 FC       LDA    #$FC
98D3: A7 C0       STA    ,U+
98D5: 39          RTS

98D6: 34 06       PSHS   D		; [manual_stack_push]
98D8: A6 42       LDA    $2,U
98DA: AB 61       ADDA   $1,S	; [local]
98DC: 19          DAA
98DD: A7 42       STA    $2,U
98DF: A6 41       LDA    $1,U
98E1: A9 E4       ADCA   ,S	; [local]
98E3: 19          DAA
98E4: A7 41       STA    $1,U
98E6: A6 C4       LDA    ,U
98E8: 89 00       ADCA   #$00
98EA: 19          DAA
98EB: A7 C4       STA    ,U
98ED: 35 86       PULS   D,PC	; [manual_stack_pull] 

98EF: 34 06       PSHS   D		; [manual_stack_push]
98F1: A6 41       LDA    $1,U
98F3: AB 61       ADDA   $1,S	; [local]
98F5: 19          DAA
98F6: A7 41       STA    $1,U
98F8: A6 C4       LDA    ,U
98FA: A9 E4       ADCA   ,S		; [local]
98FC: 19          DAA
98FD: A7 C4       STA    ,U
98FF: 35 86       PULS   D,PC	; [manual_stack_pull] 

9901: 7D 42 3D    TST    $423D
9904: 26 17       BNE    $991D
9906: 96 04       LDA    $04
9908: 91 05       CMPA   $05
990A: 23 01       BLS    $990D
990C: 39          RTS

990D: 0D D8       TST    $D8
990F: 26 06       BNE    $9917
9911: CE 99 2D    LDU    #jump_table_992d
9914: 48          ASLA
9915: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=4]
9917: CE 99 31    LDU    #jump_table_9931
991A: 48          ASLA
991B: 6E D6       JMP    [A,U]   ; [indirect_jump] [nb_entries=2]
991D: B7 C0 00    STA    $C000
9920: 0F 02       CLR    $02
9922: 0F 04       CLR    $04
9924: 0F 06       CLR    $06
9926: 0F 03       CLR    $03
9928: 0F 05       CLR    $05
992A: 0F 07       CLR    $07
992C: 39          RTS

9935: BD 83 CB    JSR    $83CB
9938: BD B4 B8    JSR    $B4B8
993B: C6 FC       LDB    #$FC
993D: B6 41 89    LDA    $4189
9940: 26 02       BNE    $9944
9942: 86 FF       LDA    #$FF
9944: FD 3F 96    STD    $3F96
9947: B6 41 8A    LDA    $418A
994A: FD 3F 98    STD    $3F98
994D: CE B0 82    LDU    #$B082
9950: 10 8E 38 9E LDY    #$389E
9954: C6 FC       LDB    #$FC
9956: A6 C0       LDA    ,U+
9958: A7 E2       STA    ,-S    ; [local]
995A: A6 C0       LDA    ,U+
995C: ED A1       STD    ,Y++
995E: 6A E4       DEC    ,S    ; [local]
9960: 26 F8       BNE    $995A
9962: A6 E0       LDA    ,S+    ; [local]
9964: CE AF EF    LDU    #$AFEF
9967: 10 8E 3C 1E LDY    #$3C1E
996B: C6 FC       LDB    #$FC
996D: A6 C0       LDA    ,U+
996F: A7 E2       STA    ,-S    ; [local]
9971: A6 C0       LDA    ,U+
9973: ED A1       STD    ,Y++
9975: 6A E4       DEC    ,S    ; [local]
9977: 26 F8       BNE    $9971
9979: A6 E0       LDA    ,S+    ; [local]
997B: CE AF FD    LDU    #$AFFD
997E: 10 8E 3D 1A LDY    #$3D1A
9982: C6 FC       LDB    #$FC
9984: A6 C0       LDA    ,U+
9986: A7 E2       STA    ,-S    ; [local]
9988: A6 C0       LDA    ,U+
998A: ED A1       STD    ,Y++
998C: 6A E4       DEC    ,S    ; [local]
998E: 26 F8       BNE    $9988
9990: A6 E0       LDA    ,S+    ; [local]
9992: C6 E4       LDB    #$E4
9994: BD 90 52    JSR    $9052
9997: 7F 41 8D    CLR    $418D
999A: 0C 04       INC    $04
999C: 0F 06       CLR    $06
999E: 39          RTS
999F: 7D 41 8C    TST    $418C
99A2: 26 49       BNE    $99ED
99A4: C6 FC       LDB    #$FC
99A6: B6 41 89    LDA    $4189
99A9: 26 02       BNE    $99AD
99AB: 86 FF       LDA    #$FF
99AD: FD 3F 96    STD    $3F96
99B0: B6 41 8A    LDA    $418A
99B3: FD 3F 98    STD    $3F98
99B6: B6 41 A5    LDA    $41A5
99B9: 81 01       CMPA   #$01
99BB: 22 18       BHI    $99D5
99BD: CE B0 90    LDU    #$B090
99C0: 10 8E 39 96 LDY    #$3996
99C4: C6 FC       LDB    #$FC
99C6: A6 C0       LDA    ,U+
99C8: A7 E2       STA    ,-S    ; [local]
99CA: A6 C0       LDA    ,U+
99CC: ED A1       STD    ,Y++
99CE: 6A E4       DEC    ,S    ; [local]
99D0: 26 F8       BNE    $99CA
99D2: A6 E0       LDA    ,S+    ; [local]
99D4: 39          RTS
99D5: CE B0 A7    LDU    #$B0A7
99D8: 10 8E 39 96 LDY    #$3996
99DC: C6 FC       LDB    #$FC
99DE: A6 C0       LDA    ,U+
99E0: A7 E2       STA    ,-S    ; [local]
99E2: A6 C0       LDA    ,U+
99E4: ED A1       STD    ,Y++
99E6: 6A E4       DEC    ,S    ; [local]
99E8: 26 F8       BNE    $99E2
99EA: A6 E0       LDA    ,S+    ; [local]
99EC: 39          RTS
99ED: 7C 41 8D    INC    $418D
99F0: 0F D9       CLR    $D9
99F2: 7D 42 5B    TST    $425B
99F5: 26 06       BNE    $99FD
99F7: 86 06       LDA    #$06
99F9: 97 DB       STA    $DB
99FB: 20 04       BRA    $9A01
99FD: 86 03       LDA    #$03
99FF: 97 DB       STA    $DB
9A01: 10 8E 38 9E LDY    #$389E
9A05: 86 FF       LDA    #$FF
9A07: F6 B0 82    LDB    $B082
9A0A: A7 A1       STA    ,Y++
9A0C: 5A          DECB
9A0D: 26 FB       BNE    $9A0A
9A0F: 10 8E 3C 1E LDY    #$3C1E
9A13: 86 FF       LDA    #$FF
9A15: F6 AF EF    LDB    $AFEF
9A18: A7 A1       STA    ,Y++
9A1A: 5A          DECB
9A1B: 26 FB       BNE    $9A18
9A1D: 10 8E 3D 1A LDY    #$3D1A
9A21: 86 FF       LDA    #$FF
9A23: F6 AF FD    LDB    $AFFD
9A26: A7 A1       STA    ,Y++
9A28: 5A          DECB
9A29: 26 FB       BNE    $9A26
9A2B: 10 8E 39 96 LDY    #$3996
9A2F: 86 FF       LDA    #$FF
9A31: F6 B0 90    LDB    $B090
9A34: A7 A1       STA    ,Y++
9A36: 5A          DECB
9A37: 26 FB       BNE    $9A34
9A39: BD 90 85    JSR    $9085
9A3C: 0C 02       INC    $02
9A3E: 0F 04       CLR    $04
9A40: 0F 06       CLR    $06
9A42: 0C 03       INC    $03
9A44: 0F 05       CLR    $05
9A46: 0F 07       CLR    $07
9A48: 39          RTS
9A49: BD 83 CB    JSR    $83CB
9A4C: BD B4 B8    JSR    $B4B8
9A4F: C6 FC       LDB    #$FC
9A51: B6 41 89    LDA    $4189
9A54: 26 02       BNE    $9A58
9A56: 86 FF       LDA    #$FF
9A58: FD 3F 96    STD    $3F96
9A5B: B6 41 8A    LDA    $418A
9A5E: FD 3F 98    STD    $3F98
9A61: CE B0 57    LDU    #$B057
9A64: 10 8E 37 24 LDY    #$3724
9A68: C6 FC       LDB    #$FC
9A6A: A6 C0       LDA    ,U+
9A6C: A7 E2       STA    ,-S    ; [local]
9A6E: A6 C0       LDA    ,U+
9A70: ED A1       STD    ,Y++
9A72: 6A E4       DEC    ,S    ; [local]
9A74: 26 F8       BNE    $9A6E
9A76: A6 E0       LDA    ,S+    ; [local]
9A78: CE B0 60    LDU    #$B060
9A7B: 10 8E 38 9A LDY    #$389A
9A7F: C6 FC       LDB    #$FC
9A81: A6 C0       LDA    ,U+
9A83: A7 E2       STA    ,-S    ; [local]
9A85: A6 C0       LDA    ,U+
9A87: ED A1       STD    ,Y++
9A89: 6A E4       DEC    ,S    ; [local]
9A8B: 26 F8       BNE    $9A85
9A8D: A6 E0       LDA    ,S+    ; [local]
9A8F: CE B0 7D    LDU    #$B07D
9A92: 10 8E 39 A8 LDY    #$39A8
9A96: C6 FC       LDB    #$FC
9A98: A6 C0       LDA    ,U+
9A9A: A7 E2       STA    ,-S    ; [local]
9A9C: A6 C0       LDA    ,U+
9A9E: ED A1       STD    ,Y++
9AA0: 6A E4       DEC    ,S    ; [local]
9AA2: 26 F8       BNE    $9A9C
9AA4: A6 E0       LDA    ,S+    ; [local]
9AA6: CE AF EF    LDU    #$AFEF
9AA9: 10 8E 3C 1E LDY    #$3C1E
9AAD: C6 FC       LDB    #$FC
9AAF: A6 C0       LDA    ,U+
9AB1: A7 E2       STA    ,-S    ; [local]
9AB3: A6 C0       LDA    ,U+
9AB5: ED A1       STD    ,Y++
9AB7: 6A E4       DEC    ,S    ; [local]
9AB9: 26 F8       BNE    $9AB3
9ABB: A6 E0       LDA    ,S+    ; [local]
9ABD: CE AF FD    LDU    #$AFFD
9AC0: 10 8E 3D 1A LDY    #$3D1A
9AC4: C6 FC       LDB    #$FC
9AC6: A6 C0       LDA    ,U+
9AC8: A7 E2       STA    ,-S    ; [local]
9ACA: A6 C0       LDA    ,U+
9ACC: ED A1       STD    ,Y++
9ACE: 6A E4       DEC    ,S    ; [local]
9AD0: 26 F8       BNE    $9ACA
9AD2: A6 E0       LDA    ,S+    ; [local]
9AD4: 10 8E 37 30 LDY    #$3730
9AD8: C6 E4       LDB    #$E4
9ADA: 96 DA       LDA    $DA
9ADC: 44          LSRA
9ADD: 44          LSRA
9ADE: 44          LSRA
9ADF: 44          LSRA
9AE0: 26 02       BNE    $9AE4
9AE2: 86 FF       LDA    #$FF
9AE4: ED A4       STD    ,Y
9AE6: 96 DA       LDA    $DA
9AE8: 84 0F       ANDA   #$0F
9AEA: ED 22       STD    $2,Y
9AEC: C6 E4       LDB    #$E4
9AEE: BD 90 52    JSR    $9052
9AF1: 7F 41 8D    CLR    $418D
9AF4: 0C 04       INC    $04
9AF6: 0F 06       CLR    $06
9AF8: 39          RTS

9B02: C6 FC       LDB    #$FC
9B04: B6 41 89    LDA    $4189
9B07: 26 02       BNE    $9B0B
9B09: 86 FF       LDA    #$FF
9B0B: FD 3F 96    STD    $3F96
9B0E: B6 41 8A    LDA    $418A
9B11: FD 3F 98    STD    $3F98
9B14: 7D 41 8C    TST    $418C
9B17: 26 67       BNE    $9B80
9B19: BD AC 53    JSR    $AC53
9B1C: 26 2B       BNE    $9B49
9B1E: 10 8E 39 A8 LDY    #$39A8
9B22: 86 FF       LDA    #$FF
9B24: F6 B0 7D    LDB    $B07D
9B27: A7 A1       STA    ,Y++
9B29: 5A          DECB
9B2A: 26 FB       BNE    $9B27
9B2C: 10 8E 3A 96 LDY    #$3A96
9B30: 86 FF       LDA    #$FF
9B32: F6 B0 90    LDB    $B090
9B35: A7 A1       STA    ,Y++
9B37: 5A          DECB
9B38: 26 FB       BNE    $9B35
9B3A: 0F DB       CLR    $DB
9B3C: 0F D8       CLR    $D8
9B3E: 0F D9       CLR    $D9
9B40: 0F 04       CLR    $04
9B42: 0F 05       CLR    $05
9B44: 0F 06       CLR    $06
9B46: 0F 07       CLR    $07
9B48: 39          RTS
9B49: B6 41 A5    LDA    $41A5
9B4C: 81 01       CMPA   #$01
9B4E: 22 18       BHI    $9B68
9B50: CE B0 90    LDU    #$B090
9B53: 10 8E 3A 96 LDY    #$3A96
9B57: C6 FC       LDB    #$FC
9B59: A6 C0       LDA    ,U+
9B5B: A7 E2       STA    ,-S    ; [local]
9B5D: A6 C0       LDA    ,U+
9B5F: ED A1       STD    ,Y++
9B61: 6A E4       DEC    ,S    ; [local]
9B63: 26 F8       BNE    $9B5D
9B65: A6 E0       LDA    ,S+    ; [local]
9B67: 39          RTS
9B68: CE B0 A7    LDU    #$B0A7
9B6B: 10 8E 3A 96 LDY    #$3A96
9B6F: C6 FC       LDB    #$FC
9B71: A6 C0       LDA    ,U+
9B73: A7 E2       STA    ,-S    ; [local]
9B75: A6 C0       LDA    ,U+
9B77: ED A1       STD    ,Y++
9B79: 6A E4       DEC    ,S    ; [local]
9B7B: 26 F8       BNE    $9B75
9B7D: A6 E0       LDA    ,S+    ; [local]
9B7F: 39          RTS
9B80: 7C 41 8D    INC    $418D
9B83: 0A DB       DEC    $DB
9B85: 96 D8       LDA    $D8
9B87: 97 D9       STA    $D9
9B89: 0F 13       CLR    $13
9B8B: 10 8E 37 24 LDY    #$3724
9B8F: 86 FF       LDA    #$FF
9B91: F6 B0 57    LDB    $B057
9B94: A7 A1       STA    ,Y++
9B96: 5A          DECB
9B97: 26 FB       BNE    $9B94
9B99: 10 8E 38 9A LDY    #$389A
9B9D: 86 FF       LDA    #$FF
9B9F: F6 B0 60    LDB    $B060
9BA2: A7 A1       STA    ,Y++
9BA4: 5A          DECB
9BA5: 26 FB       BNE    $9BA2
9BA7: 10 8E 39 A8 LDY    #$39A8
9BAB: 86 FF       LDA    #$FF
9BAD: F6 B0 7D    LDB    $B07D
9BB0: A7 A1       STA    ,Y++
9BB2: 5A          DECB
9BB3: 26 FB       BNE    $9BB0
9BB5: 10 8E 3C 1E LDY    #$3C1E
9BB9: 86 FF       LDA    #$FF
9BBB: F6 AF EF    LDB    $AFEF
9BBE: A7 A1       STA    ,Y++
9BC0: 5A          DECB
9BC1: 26 FB       BNE    $9BBE
9BC3: 10 8E 3D 1A LDY    #$3D1A
9BC7: 86 FF       LDA    #$FF
9BC9: F6 AF FD    LDB    $AFFD
9BCC: A7 A1       STA    ,Y++
9BCE: 5A          DECB
9BCF: 26 FB       BNE    $9BCC
9BD1: 10 8E 3A 96 LDY    #$3A96
9BD5: 86 FF       LDA    #$FF
9BD7: F6 B0 90    LDB    $B090
9BDA: A7 A1       STA    ,Y++
9BDC: 5A          DECB
9BDD: 26 FB       BNE    $9BDA
9BDF: BD 90 85    JSR    $9085
9BE2: 0C 02       INC    $02
9BE4: 0F 04       CLR    $04
9BE6: 0F 06       CLR    $06
9BE8: 0C 03       INC    $03
9BEA: 0F 05       CLR    $05
9BEC: 0F 07       CLR    $07
9BEE: 39          RTS
9BEF: 7D 42 3D    TST    $423D
9BF2: 26 0D       BNE    $9C01
9BF4: 96 04       LDA    $04
9BF6: 91 05       CMPA   $05
9BF8: 23 01       BLS    $9BFB
9BFA: 39          RTS
9BFB: CE 9C 11    LDU    #jump_table_9c11
9BFE: 48          ASLA
9BFF: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=13]
9C01: B7 C0 00    STA    $C000
9C04: 0F 02       CLR    $02
9C06: 0F 04       CLR    $04
9C08: 0F 06       CLR    $06
9C0A: 0F 03       CLR    $03
9C0C: 0F 05       CLR    $05
9C0E: 0F 07       CLR    $07
9C10: 39          RTS

9C2B: CE 9C B2    LDU    #$9CB2
9C2E: B6 42 51    LDA    $4251
9C31: 48          ASLA
9C32: EC C6       LDD    A,U
9C34: DD 11       STD    $11
9C36: CC 00 00    LDD    #$0000
9C39: DD 14       STD    $14
9C3B: DD 15       STD    $15
9C3D: FD 54 5C    STD    $545C
9C40: FD 54 5E    STD    $545E
9C43: 96 D9       LDA    $D9
9C45: 26 1F       BNE    $9C66
9C47: 7D 41 8E    TST    $418E
9C4A: 27 05       BEQ    $9C51
9C4C: CE 54 A0    LDU    #$54A0
9C4F: 8D 65       BSR    $9CB6
9C51: CE 54 80    LDU    #$5480
9C54: 8D 60       BSR    $9CB6
9C56: CE 54 54    LDU    #$5454
9C59: CC 00 0A    LDD    #$000A
9C5C: A7 C0       STA    ,U+
9C5E: 5A          DECB
9C5F: 26 FB       BNE    $9C5C
9C61: 0C 04       INC    $04
9C63: 0F 06       CLR    $06
9C65: 39          RTS
9C66: 81 01       CMPA   #$01
9C68: 26 1F       BNE    $9C89
9C6A: 7D 41 8E    TST    $418E
9C6D: 27 05       BEQ    $9C74
9C6F: CE 54 A0    LDU    #$54A0
9C72: 8D 42       BSR    $9CB6
9C74: CE 54 80    LDU    #$5480
9C77: 8D 72       BSR    $9CEB
9C79: CE 54 58    LDU    #$5458
9C7C: CC 00 05    LDD    #$0005
9C7F: A7 C0       STA    ,U+
9C81: 5A          DECB
9C82: 26 FB       BNE    $9C7F
9C84: 0C 04       INC    $04
9C86: 0F 06       CLR    $06
9C88: 39          RTS
9C89: 7D 41 8E    TST    $418E
9C8C: 26 15       BNE    $9CA3
9C8E: CE 54 80    LDU    #$5480
9C91: 8D 58       BSR    $9CEB
9C93: CE 54 58    LDU    #$5458
9C96: CC 00 05    LDD    #$0005
9C99: A7 C0       STA    ,U+
9C9B: 5A          DECB
9C9C: 26 FB       BNE    $9C99
9C9E: 0C 04       INC    $04
9CA0: 0F 06       CLR    $06
9CA2: 39          RTS
9CA3: CE 54 A0    LDU    #$54A0
9CA6: 8D 43       BSR    $9CEB
9CA8: CE 54 80    LDU    #$5480
9CAB: 8D 3E       BSR    $9CEB
9CAD: 0C 04       INC    $04
9CAF: 0F 06       CLR    $06
9CB1: 39          RTS
9CB2: 01 20       NEG    $20
9CB4: 01 50       NEG    $50
9CB6: 10 8E 9D 0B LDY    #$9D0B
9CBA: B6 42 4D    LDA    $424D
9CBD: A6 A6       LDA    A,Y
9CBF: A7 C4       STA    ,U
9CC1: 86 40       LDA    #$40
9CC3: A7 41       STA    $1,U
9CC5: 6F 42       CLR    $2,U
9CC7: 6F 44       CLR    $4,U
9CC9: 86 01       LDA    #$01
9CCB: A7 43       STA    $3,U
9CCD: A7 45       STA    $5,U
9CCF: DC C6       LDD    $C6
9CD1: ED 46       STD    $6,U
9CD3: CC 00 50    LDD    #$0050
9CD6: ED 48       STD    $8,U
9CD8: CC 00 00    LDD    #$0000
9CDB: ED 4A       STD    $A,U
9CDD: 6F 4C       CLR    $C,U
9CDF: 6F 4D       CLR    $D,U
9CE1: 6F 4E       CLR    $E,U
9CE3: 6F 4F       CLR    $F,U
9CE5: 86 01       LDA    #$01
9CE7: A7 C8 10    STA    $10,U
9CEA: 39          RTS
9CEB: 10 8E 9D 0B LDY    #$9D0B
9CEF: B6 42 4D    LDA    $424D
9CF2: A6 A6       LDA    A,Y
9CF4: A7 C4       STA    ,U
9CF6: 86 40       LDA    #$40
9CF8: A7 41       STA    $1,U
9CFA: CC 00 50    LDD    #$0050
9CFD: ED 48       STD    $8,U
9CFF: CC 00 00    LDD    #$0000
9D02: ED 4A       STD    $A,U
9D04: 6F 4C       CLR    $C,U
9D06: 6F 4D       CLR    $D,U
9D08: 6F 4E       CLR    $E,U
9D0A: 39          RTS
9D0B: 03 05       COM    $05
9D0D: 86 FF       LDA    #$FF
9D0F: 97 06       STA    $06
9D11: B7 80 00    STA    watchdog_8000
9D14: 0D 07       TST    $07
9D16: 2A F9       BPL    $9D11
9D18: 0F 07       CLR    $07
9D1A: 0D 06       TST    $06
9D1C: 26 FC       BNE    $9D1A
9D1E: CC 00 00    LDD    #$0000
9D21: DD 88       STD    $88
9D23: DD 8A       STD    $8A
9D25: 0C 06       INC    $06
9D27: B7 80 00    STA    watchdog_8000
9D2A: 96 07       LDA    $07
9D2C: 81 01       CMPA   #$01
9D2E: 25 F7       BCS    $9D27
9D30: B6 44 10    LDA    $4410
9D33: 81 FF       CMPA   #$FF
9D35: 27 33       BEQ    $9D6A
9D37: 0D 91       TST    $91
9D39: 26 6A       BNE    $9DA5
9D3B: 0D 1F       TST    $1F
9D3D: 10 2B 00 A7 LBMI   $9DE8
9D41: BD B6 18    JSR    $B618
9D44: 0C 06       INC    $06
9D46: BD DA 88    JSR    $DA88
9D49: 0C 06       INC    $06
9D4B: BD D8 36    JSR    $D836
9D4E: 0C 06       INC    $06
9D50: BD D2 71    JSR    $D271
9D53: BD A6 C2    JSR    $A6C2
9D56: 0C 06       INC    $06
9D58: B7 80 00    STA    watchdog_8000
9D5B: 96 07       LDA    $07
9D5D: 81 04       CMPA   #$04
9D5F: 25 F7       BCS    $9D58
9D61: BD 92 F7    JSR    $92F7
9D64: BD D3 85    JSR    $D385
9D67: 7E D2 CD    JMP    $D2CD
9D6A: 0F E8       CLR    $E8
9D6C: CE AF D6    LDU    #$AFD6
9D6F: 10 8E 32 10 LDY    #$3210
9D73: C6 FC       LDB    #$FC
9D75: A6 C0       LDA    ,U+
9D77: A7 E2       STA    ,-S    ; [local]
9D79: A6 C0       LDA    ,U+
9D7B: ED A1       STD    ,Y++
9D7D: 6A E4       DEC    ,S    ; [local]
9D7F: 26 F8       BNE    $9D79
9D81: A6 E0       LDA    ,S+    ; [local]
9D83: CE AF E5    LDU    #$AFE5
9D86: 10 8E 32 42 LDY    #$3242
9D8A: C6 FC       LDB    #$FC
9D8C: A6 C0       LDA    ,U+
9D8E: A7 E2       STA    ,-S    ; [local]
9D90: A6 C0       LDA    ,U+
9D92: ED A1       STD    ,Y++
9D94: 6A E4       DEC    ,S    ; [local]
9D96: 26 F8       BNE    $9D90
9D98: A6 E0       LDA    ,S+    ; [local]
9D9A: 0F 0E       CLR    $0E
9D9C: 0C 04       INC    $04
9D9E: 0F 06       CLR    $06
9DA0: 0C 05       INC    $05
9DA2: 0F 07       CLR    $07
9DA4: 39          RTS
9DA5: FC 44 0A    LDD    $440A
9DA8: 10 83 12 80 CMPD   #$1280
9DAC: 2C 01       BGE    $9DAF
9DAE: 39          RTS
9DAF: CE AF D6    LDU    #$AFD6
9DB2: 10 8E 32 10 LDY    #$3210
9DB6: C6 FC       LDB    #$FC
9DB8: A6 C0       LDA    ,U+
9DBA: A7 E2       STA    ,-S    ; [local]
9DBC: A6 C0       LDA    ,U+
9DBE: ED A1       STD    ,Y++
9DC0: 6A E4       DEC    ,S    ; [local]
9DC2: 26 F8       BNE    $9DBC
9DC4: A6 E0       LDA    ,S+    ; [local]
9DC6: CE AF E5    LDU    #$AFE5
9DC9: 10 8E 32 42 LDY    #$3242
9DCD: C6 FC       LDB    #$FC
9DCF: A6 C0       LDA    ,U+
9DD1: A7 E2       STA    ,-S    ; [local]
9DD3: A6 C0       LDA    ,U+
9DD5: ED A1       STD    ,Y++
9DD7: 6A E4       DEC    ,S    ; [local]
9DD9: 26 F8       BNE    $9DD3
9DDB: A6 E0       LDA    ,S+    ; [local]
9DDD: 86 0B       LDA    #$0B
9DDF: 97 04       STA    $04
9DE1: 0F 06       CLR    $06
9DE3: 97 05       STA    $05
9DE5: 0F 07       CLR    $07
9DE7: 39          RTS
9DE8: 7D 43 80    TST    $4380
9DEB: 27 01       BEQ    $9DEE
9DED: 39          RTS
9DEE: CE AF D6    LDU    #$AFD6
9DF1: 10 8E 32 10 LDY    #$3210
9DF5: C6 FC       LDB    #$FC
9DF7: A6 C0       LDA    ,U+
9DF9: A7 E2       STA    ,-S    ; [local]
9DFB: A6 C0       LDA    ,U+
9DFD: ED A1       STD    ,Y++
9DFF: 6A E4       DEC    ,S    ; [local]
9E01: 26 F8       BNE    $9DFB
9E03: A6 E0       LDA    ,S+    ; [local]
9E05: CE AF E5    LDU    #$AFE5
9E08: 10 8E 32 42 LDY    #$3242
9E0C: C6 FC       LDB    #$FC
9E0E: A6 C0       LDA    ,U+
9E10: A7 E2       STA    ,-S    ; [local]
9E12: A6 C0       LDA    ,U+
9E14: ED A1       STD    ,Y++
9E16: 6A E4       DEC    ,S    ; [local]
9E18: 26 F8       BNE    $9E12
9E1A: A6 E0       LDA    ,S+    ; [local]
9E1C: 86 0C       LDA    #$0C
9E1E: 97 04       STA    $04
9E20: 0F 06       CLR    $06
9E22: 97 05       STA    $05
9E24: 0F 07       CLR    $07
9E26: 39          RTS
9E27: 7D 42 55    TST    $4255
9E2A: 27 1A       BEQ    $9E46
9E2C: 0D D9       TST    $D9
9E2E: 26 16       BNE    $9E46
9E30: CE 9E 4F    LDU    #$9E4F
9E33: 96 01       LDA    $01
9E35: 48          ASLA
9E36: EE C6       LDU    A,U
9E38: A6 4E       LDA    $E,U
9E3A: AA 42       ORA    $2,U
9E3C: 26 08       BNE    $9E46
9E3E: CE 9E 53    LDU    #jump_table_9e53
9E41: 96 06       LDA    $06
9E43: 48          ASLA
9E44: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=4]
9E46: 0C 04       INC    $04
9E48: 0F 06       CLR    $06
9E4A: 0C 05       INC    $05
9E4C: 0F 07       CLR    $07
9E4E: 39          RTS

9E5B: C6 FC       LDB    #$FC
9E5D: B6 41 89    LDA    $4189
9E60: 26 02       BNE    $9E64
9E62: 86 FF       LDA    #$FF
9E64: FD 3F 96    STD    $3F96
9E67: B6 41 8A    LDA    $418A
9E6A: FD 3F 98    STD    $3F98
9E6D: 86 10       LDA    #$10
9E6F: 97 DA       STA    $DA
9E71: 0F 13       CLR    $13
9E73: CE B0 57    LDU    #$B057
9E76: 10 8E 36 A4 LDY    #$36A4
9E7A: C6 FC       LDB    #$FC
9E7C: A6 C0       LDA    ,U+
9E7E: A7 E2       STA    ,-S    ; [local]
9E80: A6 C0       LDA    ,U+
9E82: ED A1       STD    ,Y++
9E84: 6A E4       DEC    ,S    ; [local]
9E86: 26 F8       BNE    $9E80
9E88: A6 E0       LDA    ,S+    ; [local]
9E8A: CE B1 65    LDU    #$B165
9E8D: 10 8E 38 14 LDY    #$3814
9E91: C6 FC       LDB    #$FC
9E93: A6 C0       LDA    ,U+
9E95: A7 E2       STA    ,-S    ; [local]
9E97: A6 C0       LDA    ,U+
9E99: ED A1       STD    ,Y++
9E9B: 6A E4       DEC    ,S    ; [local]
9E9D: 26 F8       BNE    $9E97
9E9F: A6 E0       LDA    ,S+    ; [local]
9EA1: CE B1 7D    LDU    #$B17D
9EA4: 10 8E 39 2A LDY    #$392A
9EA8: C6 FC       LDB    #$FC
9EAA: A6 C0       LDA    ,U+
9EAC: A7 E2       STA    ,-S    ; [local]
9EAE: A6 C0       LDA    ,U+
9EB0: ED A1       STD    ,Y++
9EB2: 6A E4       DEC    ,S    ; [local]
9EB4: 26 F8       BNE    $9EAE
9EB6: A6 E0       LDA    ,S+    ; [local]
9EB8: CE B1 80    LDU    #$B180
9EBB: 10 8E 3A 14 LDY    #$3A14
9EBF: C6 FC       LDB    #$FC
9EC1: A6 C0       LDA    ,U+
9EC3: A7 E2       STA    ,-S    ; [local]
9EC5: A6 C0       LDA    ,U+
9EC7: ED A1       STD    ,Y++
9EC9: 6A E4       DEC    ,S    ; [local]
9ECB: 26 F8       BNE    $9EC5
9ECD: A6 E0       LDA    ,S+    ; [local]
9ECF: CE B1 9A    LDU    #$B19A
9ED2: 10 8E 3B 10 LDY    #$3B10
9ED6: C6 FC       LDB    #$FC
9ED8: A6 C0       LDA    ,U+
9EDA: A7 E2       STA    ,-S    ; [local]
9EDC: A6 C0       LDA    ,U+
9EDE: ED A1       STD    ,Y++
9EE0: 6A E4       DEC    ,S    ; [local]
9EE2: 26 F8       BNE    $9EDC
9EE4: A6 E0       LDA    ,S+    ; [local]
9EE6: CE B0 3F    LDU    #$B03F
9EE9: 10 8E 3D A2 LDY    #$3DA2
9EED: C6 EC       LDB    #$EC
9EEF: A6 C0       LDA    ,U+
9EF1: A7 E2       STA    ,-S    ; [local]
9EF3: A6 C0       LDA    ,U+
9EF5: ED A1       STD    ,Y++
9EF7: 6A E4       DEC    ,S    ; [local]
9EF9: 26 F8       BNE    $9EF3
9EFB: A6 E0       LDA    ,S+    ; [local]
9EFD: 10 8E 36 B0 LDY    #$36B0
9F01: C6 E4       LDB    #$E4
9F03: 96 DA       LDA    $DA
9F05: 44          LSRA
9F06: 44          LSRA
9F07: 44          LSRA
9F08: 44          LSRA
9F09: 26 02       BNE    $9F0D
9F0B: 86 FF       LDA    #$FF
9F0D: ED A4       STD    ,Y
9F0F: 96 DA       LDA    $DA
9F11: 84 0F       ANDA   #$0F
9F13: ED 22       STD    $2,Y
9F15: 10 8E 3D AE LDY    #$3DAE
9F19: C6 EC       LDB    #$EC
9F1B: 96 C5       LDA    $C5
9F1D: 44          LSRA
9F1E: 44          LSRA
9F1F: 44          LSRA
9F20: 44          LSRA
9F21: 26 02       BNE    $9F25
9F23: 86 FF       LDA    #$FF
9F25: ED A4       STD    ,Y
9F27: 96 C5       LDA    $C5
9F29: 84 0F       ANDA   #$0F
9F2B: ED 22       STD    $2,Y
9F2D: 0C 06       INC    $06
9F2F: 0D 01       TST    $01
9F31: 26 18       BNE    $9F4B
9F33: CE B0 BE    LDU    #$B0BE
9F36: 10 8E 3C A2 LDY    #$3CA2
9F3A: C6 EC       LDB    #$EC
9F3C: A6 C0       LDA    ,U+
9F3E: A7 E2       STA    ,-S    ; [local]
9F40: A6 C0       LDA    ,U+
9F42: ED A1       STD    ,Y++
9F44: 6A E4       DEC    ,S    ; [local]
9F46: 26 F8       BNE    $9F40
9F48: A6 E0       LDA    ,S+    ; [local]
9F4A: 39          RTS
9F4B: CE B0 C9    LDU    #$B0C9
9F4E: 10 8E 3C A2 LDY    #$3CA2
9F52: C6 EC       LDB    #$EC
9F54: A6 C0       LDA    ,U+
9F56: A7 E2       STA    ,-S    ; [local]
9F58: A6 C0       LDA    ,U+
9F5A: ED A1       STD    ,Y++
9F5C: 6A E4       DEC    ,S    ; [local]
9F5E: 26 F8       BNE    $9F58
9F60: A6 E0       LDA    ,S+    ; [local]
9F62: 39          RTS
9F63: C6 FC       LDB    #$FC
9F65: B6 41 89    LDA    $4189
9F68: 26 02       BNE    $9F6C
9F6A: 86 FF       LDA    #$FF
9F6C: FD 3F 96    STD    $3F96
9F6F: B6 41 8A    LDA    $418A
9F72: FD 3F 98    STD    $3F98
9F75: BD A0 F9    JSR    $A0F9
9F78: 27 56       BEQ    $9FD0
9F7A: B6 42 62    LDA    $4262
9F7D: BA 42 60    ORA    $4260
9F80: 26 01       BNE    $9F83
9F82: 39          RTS
9F83: 0C 06       INC    $06
9F85: 0D 01       TST    $01
9F87: 26 18       BNE    $9FA1
9F89: CE B0 BE    LDU    #$B0BE
9F8C: 10 8E 3C A2 LDY    #$3CA2
9F90: C6 FC       LDB    #$FC
9F92: A6 C0       LDA    ,U+
9F94: A7 E2       STA    ,-S    ; [local]
9F96: A6 C0       LDA    ,U+
9F98: ED A1       STD    ,Y++
9F9A: 6A E4       DEC    ,S    ; [local]
9F9C: 26 F8       BNE    $9F96
9F9E: A6 E0       LDA    ,S+    ; [local]
9FA0: 39          RTS
9FA1: CE B0 C9    LDU    #$B0C9
9FA4: 10 8E 3C A2 LDY    #$3CA2
9FA8: C6 FC       LDB    #$FC
9FAA: A6 C0       LDA    ,U+
9FAC: A7 E2       STA    ,-S    ; [local]
9FAE: A6 C0       LDA    ,U+
9FB0: ED A1       STD    ,Y++
9FB2: 6A E4       DEC    ,S    ; [local]
9FB4: 26 F8       BNE    $9FAE
9FB6: A6 E0       LDA    ,S+    ; [local]
9FB8: 39          RTS
9FB9: C6 FC       LDB    #$FC
9FBB: B6 41 89    LDA    $4189
9FBE: 26 02       BNE    $9FC2
9FC0: 86 FF       LDA    #$FF
9FC2: FD 3F 96    STD    $3F96
9FC5: B6 41 8A    LDA    $418A
9FC8: FD 3F 98    STD    $3F98
9FCB: BD A0 F9    JSR    $A0F9
9FCE: 26 36       BNE    $A006
9FD0: 86 03       LDA    #$03
9FD2: 97 06       STA    $06
9FD4: 0F 0E       CLR    $0E
9FD6: CE B0 3F    LDU    #$B03F
9FD9: 10 8E 3D A2 LDY    #$3DA2
9FDD: C6 FC       LDB    #$FC
9FDF: A6 C0       LDA    ,U+
9FE1: A7 E2       STA    ,-S    ; [local]
9FE3: A6 C0       LDA    ,U+
9FE5: ED A1       STD    ,Y++
9FE7: 6A E4       DEC    ,S    ; [local]
9FE9: 26 F8       BNE    $9FE3
9FEB: A6 E0       LDA    ,S+    ; [local]
9FED: 10 8E 3D AE LDY    #$3DAE
9FF1: C6 FC       LDB    #$FC
9FF3: 96 C5       LDA    $C5
9FF5: 44          LSRA
9FF6: 44          LSRA
9FF7: 44          LSRA
9FF8: 44          LSRA
9FF9: 26 02       BNE    $9FFD
9FFB: 86 FF       LDA    #$FF
9FFD: ED A4       STD    ,Y
9FFF: 96 C5       LDA    $C5
A001: 84 0F       ANDA   #$0F
A003: ED 22       STD    $2,Y
A005: 39          RTS
A006: B6 42 63    LDA    $4263
A009: BA 42 61    ORA    $4261
A00C: 27 C2       BEQ    $9FD0
A00E: CE 42 76    LDU    #$4276
A011: 96 1E       LDA    $1E
A013: 26 02       BNE    $A017
A015: 33 54       LEAU   -$C,U
A017: 6D 48       TST    $8,U
A019: 26 2E       BNE    $A049
A01B: 6D 4A       TST    $A,U
A01D: 26 01       BNE    $A020
A01F: 39          RTS
A020: 96 C4       LDA    $C4
A022: 26 01       BNE    $A025
A024: 39          RTS
A025: 0A C4       DEC    $C4
A027: 0A D1       DEC    $D1
A029: 96 C5       LDA    $C5
A02B: 8B 99       ADDA   #$99
A02D: 19          DAA
A02E: 97 C5       STA    $C5
A030: 10 8E 3D AE LDY    #$3DAE
A034: C6 EC       LDB    #$EC
A036: 96 C5       LDA    $C5
A038: 44          LSRA
A039: 44          LSRA
A03A: 44          LSRA
A03B: 44          LSRA
A03C: 26 02       BNE    $A040
A03E: 86 FF       LDA    #$FF
A040: ED A4       STD    ,Y
A042: 96 C5       LDA    $C5
A044: 84 0F       ANDA   #$0F
A046: ED 22       STD    $2,Y
A048: 39          RTS
A049: 96 C4       LDA    $C4
A04B: 4C          INCA
A04C: 81 05       CMPA   #$05
A04E: 25 01       BCS    $A051
A050: 39          RTS
A051: 97 C4       STA    $C4
A053: 0C D1       INC    $D1
A055: 96 C5       LDA    $C5
A057: 8B 01       ADDA   #$01
A059: 19          DAA
A05A: 97 C5       STA    $C5
A05C: 10 8E 3D AE LDY    #$3DAE
A060: C6 EC       LDB    #$EC
A062: 96 C5       LDA    $C5
A064: 44          LSRA
A065: 44          LSRA
A066: 44          LSRA
A067: 44          LSRA
A068: 26 02       BNE    $A06C
A06A: 86 FF       LDA    #$FF
A06C: ED A4       STD    ,Y
A06E: 96 C5       LDA    $C5
A070: 84 0F       ANDA   #$0F
A072: ED 22       STD    $2,Y
A074: 39          RTS
A075: C6 FC       LDB    #$FC
A077: B6 41 89    LDA    $4189
A07A: 26 02       BNE    $A07E
A07C: 86 FF       LDA    #$FF
A07E: FD 3F 96    STD    $3F96
A081: B6 41 8A    LDA    $418A
A084: FD 3F 98    STD    $3F98
A087: 10 8E 36 A4 LDY    #$36A4
A08B: 86 FF       LDA    #$FF
A08D: F6 B0 57    LDB    $B057
A090: A7 A1       STA    ,Y++
A092: 5A          DECB
A093: 26 FB       BNE    $A090
A095: 96 0E       LDA    $0E
A097: 84 3F       ANDA   #$3F
A099: 27 01       BEQ    $A09C
A09B: 39          RTS
A09C: 10 8E 38 14 LDY    #$3814
A0A0: 86 FF       LDA    #$FF
A0A2: F6 B1 65    LDB    $B165
A0A5: A7 A1       STA    ,Y++
A0A7: 5A          DECB
A0A8: 26 FB       BNE    $A0A5
A0AA: 10 8E 39 2A LDY    #$392A
A0AE: 86 FF       LDA    #$FF
A0B0: F6 B1 7D    LDB    $B17D
A0B3: A7 A1       STA    ,Y++
A0B5: 5A          DECB
A0B6: 26 FB       BNE    $A0B3
A0B8: 10 8E 3A 14 LDY    #$3A14
A0BC: 86 FF       LDA    #$FF
A0BE: F6 B1 80    LDB    $B180
A0C1: A7 A1       STA    ,Y++
A0C3: 5A          DECB
A0C4: 26 FB       BNE    $A0C1
A0C6: 10 8E 3B 10 LDY    #$3B10
A0CA: 86 FF       LDA    #$FF
A0CC: F6 B1 9A    LDB    $B19A
A0CF: A7 A1       STA    ,Y++
A0D1: 5A          DECB
A0D2: 26 FB       BNE    $A0CF
A0D4: 10 8E 3D A2 LDY    #$3DA2
A0D8: 86 FF       LDA    #$FF
A0DA: F6 B0 3F    LDB    $B03F
A0DD: A7 A1       STA    ,Y++
A0DF: 5A          DECB
A0E0: 26 FB       BNE    $A0DD
A0E2: 10 8E 3C A2 LDY    #$3CA2
A0E6: 86 FF       LDA    #$FF
A0E8: F6 B0 BE    LDB    $B0BE
A0EB: A7 A1       STA    ,Y++
A0ED: 5A          DECB
A0EE: 26 FB       BNE    $A0EB
A0F0: 0C 04       INC    $04
A0F2: 0F 06       CLR    $06
A0F4: 0C 05       INC    $05
A0F6: 0F 07       CLR    $07
A0F8: 39          RTS
A0F9: 96 13       LDA    $13
A0FB: 4C          INCA
A0FC: 84 3F       ANDA   #$3F
A0FE: 97 13       STA    $13
A100: 26 07       BNE    $A109
A102: 96 DA       LDA    $DA
A104: 8B 99       ADDA   #$99
A106: 19          DAA
A107: 97 DA       STA    $DA
A109: 10 8E 36 B0 LDY    #$36B0
A10D: C6 E4       LDB    #$E4
A10F: 96 DA       LDA    $DA
A111: 44          LSRA
A112: 44          LSRA
A113: 44          LSRA
A114: 44          LSRA
A115: 26 02       BNE    $A119
A117: 86 FF       LDA    #$FF
A119: ED A4       STD    ,Y
A11B: 96 DA       LDA    $DA
A11D: 84 0F       ANDA   #$0F
A11F: ED 22       STD    $2,Y
A121: 96 DA       LDA    $DA
A123: 39          RTS
A124: 96 01       LDA    $01
A126: 26 06       BNE    $A12E
A128: 8E 54 80    LDX    #$5480
A12B: 7E A1 31    JMP    $A131
A12E: 8E 54 A0    LDX    #$54A0
A131: CE 56 C0    LDU    #$56C0
A134: EC 81       LDD    ,X++
A136: 8B 99       ADDA   #$99
A138: 19          DAA
A139: ED C1       STD    ,U++
A13B: EC 81       LDD    ,X++
A13D: ED C1       STD    ,U++
A13F: EC 81       LDD    ,X++
A141: ED C1       STD    ,U++
A143: EC 81       LDD    ,X++
A145: ED C1       STD    ,U++
A147: ED C1       STD    ,U++
A149: EC 81       LDD    ,X++
A14B: ED C1       STD    ,U++
A14D: EC 81       LDD    ,X++
A14F: ED C1       STD    ,U++
A151: EC 81       LDD    ,X++
A153: ED C1       STD    ,U++
A155: EC 81       LDD    ,X++
A157: E7 C0       STB    ,U+
A159: A6 80       LDA    ,X+
A15B: A7 C4       STA    ,U
A15D: 0F 0B       CLR    $0B
A15F: 0F 0D       CLR    $0D
A161: 96 0A       LDA    $0A
A163: 84 FC       ANDA   #$FC
A165: 97 0A       STA    $0A
A167: 0C 04       INC    $04
A169: 0F 06       CLR    $06
A16B: 0C 05       INC    $05
A16D: 0F 07       CLR    $07
A16F: 39          RTS
A170: 96 06       LDA    $06
A172: 91 07       CMPA   $07
A174: 23 01       BLS    $A177
A176: 39          RTS
A177: CE A1 7D    LDU    #jump_table_a17d
A17A: 48          ASLA
A17B: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=4]

A185: 0C 06       INC    $06
A187: 0F E8       CLR    $E8
A189: BD 84 E0    JSR    $84E0
A18C: 7E 84 F9    JMP    $84F9
A18F: 96 B3       LDA    $B3
A191: 91 B4       CMPA   $B4
A193: 27 01       BEQ    $A196
A195: 39          RTS
A196: 0C 06       INC    $06
A198: BD 84 23    JSR    $8423
A19B: 7E 84 BA    JMP    $84BA
A19E: 96 6E       LDA    $6E
A1A0: 91 6F       CMPA   $6F
A1A2: 27 01       BEQ    $A1A5
A1A4: 39          RTS
A1A5: 0C 06       INC    $06
A1A7: BD 83 CB    JSR    $83CB
A1AA: BD 84 CD    JSR    $84CD
A1AD: 7E 84 8C    JMP    $848C
A1B0: 86 40       LDA    #$40
A1B2: 97 C1       STA    $C1
A1B4: CC 00 50    LDD    #$0050
A1B7: DD CA       STD    $CA
A1B9: 7D 41 8E    TST    $418E
A1BC: 26 12       BNE    $A1D0
A1BE: CE 54 80    LDU    #$5480
A1C1: 8D 62       BSR    $A225
A1C3: 0D C0       TST    $C0
A1C5: 26 37       BNE    $A1FE
A1C7: 0C 04       INC    $04
A1C9: 0C 05       INC    $05
A1CB: 0F 06       CLR    $06
A1CD: 0F 07       CLR    $07
A1CF: 39          RTS
A1D0: 0D 01       TST    $01
A1D2: 26 16       BNE    $A1EA
A1D4: CE 54 80    LDU    #$5480
A1D7: 8D 4C       BSR    $A225
A1D9: 0D C0       TST    $C0
A1DB: 27 EA       BEQ    $A1C7
A1DD: 7D 54 A0    TST    $54A0
A1E0: 27 1C       BEQ    $A1FE
A1E2: 96 01       LDA    $01
A1E4: 88 01       EORA   #$01
A1E6: 97 01       STA    $01
A1E8: 20 14       BRA    $A1FE
A1EA: CE 54 A0    LDU    #$54A0
A1ED: 8D 36       BSR    $A225
A1EF: 0D C0       TST    $C0
A1F1: 27 D4       BEQ    $A1C7
A1F3: 7D 54 80    TST    $5480
A1F6: 27 06       BEQ    $A1FE
A1F8: 96 01       LDA    $01
A1FA: 88 01       EORA   #$01
A1FC: 97 01       STA    $01
A1FE: CE A2 21    LDU    #$A221
A201: B6 42 51    LDA    $4251
A204: 48          ASLA
A205: EC C6       LDD    A,U
A207: DD 11       STD    $11
A209: CC 00 00    LDD    #$0000
A20C: FD 54 5C    STD    $545C
A20F: FD 54 5E    STD    $545E
A212: 97 14       STA    $14
A214: 97 15       STA    $15
A216: 86 01       LDA    #$01
A218: 97 04       STA    $04
A21A: 97 05       STA    $05
A21C: 0F 06       CLR    $06
A21E: 0F 07       CLR    $07
A220: 39          RTS
A221: 01 20       NEG    $20
A223: 01 50       NEG    $50
A225: 8E 56 C0    LDX    #$56C0
A228: EC 81       LDD    ,X++
A22A: ED C1       STD    ,U++
A22C: EC 81       LDD    ,X++
A22E: ED C1       STD    ,U++
A230: EC 81       LDD    ,X++
A232: ED C1       STD    ,U++
A234: EC 81       LDD    ,X++
A236: ED C1       STD    ,U++
A238: EC 02       LDD    $2,X
A23A: ED C1       STD    ,U++
A23C: EC 04       LDD    $4,X
A23E: ED C1       STD    ,U++
A240: EC 06       LDD    $6,X
A242: ED C1       STD    ,U++
A244: 6C C0       INC    ,U+
A246: EC 08       LDD    $8,X
A248: ED C4       STD    ,U
A24A: 39          RTS
A24B: 86 18       LDA    #$18
A24D: B7 68 00    STA    bankswitch_6800
A250: CE 60 00    LDU    #$6000
A253: A6 C0       LDA    ,U+
A255: 97 70       STA    $70
A257: 91 C2       CMPA   $C2
A259: 22 02       BHI    $A25D
A25B: 0A C2       DEC    $C2
A25D: 96 C2       LDA    $C2
A25F: 48          ASLA
A260: EC C6       LDD    A,U
A262: DD 72       STD    $72
A264: BD 83 CB    JSR    $83CB
A267: 10 8E 38 9E LDY    #$389E
A26B: 86 FF       LDA    #$FF
A26D: F6 B0 82    LDB    $B082
A270: A7 A1       STA    ,Y++
A272: 5A          DECB
A273: 26 FB       BNE    $A270
A275: 10 8E 3C 1E LDY    #$3C1E
A279: 86 FF       LDA    #$FF
A27B: F6 AF EF    LDB    $AFEF
A27E: A7 A1       STA    ,Y++
A280: 5A          DECB
A281: 26 FB       BNE    $A27E
A283: 10 8E 3D 1A LDY    #$3D1A
A287: 86 FF       LDA    #$FF
A289: F6 AF FD    LDB    $AFFD
A28C: A7 A1       STA    ,Y++
A28E: 5A          DECB
A28F: 26 FB       BNE    $A28C
A291: 10 8E 39 96 LDY    #$3996
A295: 86 FF       LDA    #$FF
A297: F6 B0 90    LDB    $B090
A29A: A7 A1       STA    ,Y++
A29C: 5A          DECB
A29D: 26 FB       BNE    $A29A
A29F: BD 90 85    JSR    $9085
A2A2: 0C 04       INC    $04
A2A4: 0F 06       CLR    $06
A2A6: 0C 05       INC    $05
A2A8: 0F 07       CLR    $07
A2AA: 39          RTS
A2AB: 86 18       LDA    #$18
A2AD: B7 68 00    STA    bankswitch_6800
A2B0: DE 72       LDU    $72
A2B2: A6 C0       LDA    ,U+
A2B4: 97 71       STA    $71
A2B6: 91 C4       CMPA   $C4
A2B8: 22 02       BHI    $A2BC
A2BA: 0A C4       DEC    $C4
A2BC: 96 C4       LDA    $C4
A2BE: 96 C4       LDA    $C4
A2C0: 48          ASLA
A2C1: EE C6       LDU    A,U
A2C3: EC C1       LDD    ,U++
A2C5: DD 78       STD    $78
A2C7: A6 C0       LDA    ,U+
A2C9: 26 05       BNE    $A2D0
A2CB: B7 88 00    STA    $8800
A2CE: 20 03       BRA    $A2D3
A2D0: B7 8C 00    STA    $8C00
A2D3: EC C1       LDD    ,U++
A2D5: DD 7A       STD    $7A
A2D7: EC C1       LDD    ,U++
A2D9: DD 7C       STD    $7C
A2DB: EC C1       LDD    ,U++
A2DD: DD 7E       STD    $7E
A2DF: 8E 53 C0    LDX    #$53C0
A2E2: CC 10 10    LDD    #$1010
A2E5: ED 08       STD    $8,X
A2E7: CC 20 20    LDD    #$2020
A2EA: ED 0A       STD    $A,X
A2EC: 8E 53 D0    LDX    #$53D0
A2EF: EC C1       LDD    ,U++
A2F1: ED 08       STD    $8,X
A2F3: 48          ASLA
A2F4: 58          ASLB
A2F5: ED 0A       STD    $A,X
A2F7: 8E 53 E0    LDX    #$53E0
A2FA: EC C1       LDD    ,U++
A2FC: ED 08       STD    $8,X
A2FE: 48          ASLA
A2FF: 58          ASLB
A300: ED 0A       STD    $A,X
A302: DF 74       STU    $74
A304: 0C 04       INC    $04
A306: 0F 06       CLR    $06
A308: 39          RTS
A309: 96 06       LDA    $06
A30B: 91 07       CMPA   $07
A30D: 23 01       BLS    $A310
A30F: 39          RTS
A310: CE A3 16    LDU    #jump_table_a316
A313: 48          ASLA
A314: 6E D6       JMP    [A,U]   ; [indirect_jump] [nb_entries=10]

A32A: 0C 06       INC    $06
A32C: 0F E8       CLR    $E8
A32E: BD 84 E0    JSR    $84E0
A331: 7E 84 F9    JMP    $84F9
A334: 96 B3       LDA    $B3
A336: 91 B4       CMPA   $B4
A338: 27 01       BEQ    $A33B
A33A: 39          RTS
A33B: 0C 06       INC    $06
A33D: BD 84 23    JSR    $8423
A340: 7E 84 BA    JMP    $84BA
A343: 96 6E       LDA    $6E
A345: 91 6F       CMPA   $6F
A347: 27 01       BEQ    $A34A
A349: 39          RTS
A34A: 0C 06       INC    $06
A34C: BD 83 CB    JSR    $83CB
A34F: BD B4 B8    JSR    $B4B8
A352: BD 84 CD    JSR    $84CD
A355: 7E 84 8C    JMP    $848C
A358: 0C C4       INC    $C4
A35A: 96 C4       LDA    $C4
A35C: 91 71       CMPA   $71
A35E: 24 5A       BCC    $A3BA
A360: CE B1 2C    LDU    #$B12C
A363: 10 8E 35 1C LDY    #$351C
A367: C6 FC       LDB    #$FC
A369: A6 C0       LDA    ,U+
A36B: A7 E2       STA    ,-S    ; [local]
A36D: A6 C0       LDA    ,U+
A36F: ED A1       STD    ,Y++
A371: 6A E4       DEC    ,S    ; [local]
A373: 26 F8       BNE    $A36D
A375: A6 E0       LDA    ,S+    ; [local]
A377: CE B1 4C    LDU    #$B14C
A37A: 10 8E 36 9C LDY    #$369C
A37E: C6 FC       LDB    #$FC
A380: A6 C0       LDA    ,U+
A382: A7 E2       STA    ,-S    ; [local]
A384: A6 C0       LDA    ,U+
A386: ED A1       STD    ,Y++
A388: 6A E4       DEC    ,S    ; [local]
A38A: 26 F8       BNE    $A384
A38C: A6 E0       LDA    ,S+    ; [local]
A38E: 10 8E 36 A8 LDY    #$36A8
A392: C6 FC       LDB    #$FC
A394: 96 C5       LDA    $C5
A396: 44          LSRA
A397: 44          LSRA
A398: 44          LSRA
A399: 44          LSRA
A39A: 26 02       BNE    $A39E
A39C: 86 FF       LDA    #$FF
A39E: ED A4       STD    ,Y
A3A0: 96 C5       LDA    $C5
A3A2: 84 0F       ANDA   #$0F
A3A4: ED 22       STD    $2,Y
A3A6: 96 C5       LDA    $C5
A3A8: 8B 01       ADDA   #$01
A3AA: 19          DAA
A3AB: 97 C5       STA    $C5
A3AD: 0F 91       CLR    $91
A3AF: 0F CF       CLR    $CF
A3B1: 0F 0E       CLR    $0E
A3B3: 0C 06       INC    $06
A3B5: 0C 07       INC    $07
A3B7: 7E B4 34    JMP    $B434
A3BA: 0C C2       INC    $C2
A3BC: 96 C2       LDA    $C2
A3BE: 91 70       CMPA   $70
A3C0: 24 5A       BCC    $A41C
A3C2: CE B1 2C    LDU    #$B12C
A3C5: 10 8E 35 1C LDY    #$351C
A3C9: C6 FC       LDB    #$FC
A3CB: A6 C0       LDA    ,U+
A3CD: A7 E2       STA    ,-S    ; [local]
A3CF: A6 C0       LDA    ,U+
A3D1: ED A1       STD    ,Y++
A3D3: 6A E4       DEC    ,S    ; [local]
A3D5: 26 F8       BNE    $A3CF
A3D7: A6 E0       LDA    ,S+    ; [local]
A3D9: CE B1 3C    LDU    #$B13C
A3DC: 10 8E 36 9C LDY    #$369C
A3E0: C6 FC       LDB    #$FC
A3E2: A6 C0       LDA    ,U+
A3E4: A7 E2       STA    ,-S    ; [local]
A3E6: A6 C0       LDA    ,U+
A3E8: ED A1       STD    ,Y++
A3EA: 6A E4       DEC    ,S    ; [local]
A3EC: 26 F8       BNE    $A3E6
A3EE: A6 E0       LDA    ,S+    ; [local]
A3F0: 10 8E 36 A8 LDY    #$36A8
A3F4: C6 FC       LDB    #$FC
A3F6: 96 C3       LDA    $C3
A3F8: 44          LSRA
A3F9: 44          LSRA
A3FA: 44          LSRA
A3FB: 44          LSRA
A3FC: 26 02       BNE    $A400
A3FE: 86 FF       LDA    #$FF
A400: ED A4       STD    ,Y
A402: 96 C3       LDA    $C3
A404: 84 0F       ANDA   #$0F
A406: ED 22       STD    $2,Y
A408: 96 C3       LDA    $C3
A40A: 8B 01       ADDA   #$01
A40C: 19          DAA
A40D: 97 C3       STA    $C3
A40F: 0F C4       CLR    $C4
A411: 96 C5       LDA    $C5
A413: 8B 01       ADDA   #$01
A415: 19          DAA
A416: 97 C5       STA    $C5
A418: 0F 91       CLR    $91
A41A: 0F CF       CLR    $CF
A41C: 0F 0E       CLR    $0E
A41E: 0C 06       INC    $06
A420: 0C 07       INC    $07
A422: 7E B4 34    JMP    $B434
A425: DC 11       LDD    $11
A427: 27 31       BEQ    $A45A
A429: 10 8E 53 40 LDY    #$5340
A42D: 96 E0       LDA    $E0
A42F: C6 0A       LDB    #$0A
A431: E7 A6       STB    A,Y
A433: 4C          INCA
A434: 84 1F       ANDA   #$1F
A436: 97 E0       STA    $E0
A438: CC 00 12    LDD    #$0012
A43B: FD 54 5C    STD    $545C
A43E: CC 00 00    LDD    #$0000
A441: FD 54 5E    STD    $545E
A444: BD 93 7A    JSR    $937A
A447: CE 56 11    LDU    #$5611
A44A: CC 99 99    LDD    #$9999
A44D: BD 98 EF    JSR    $98EF
A450: BD 95 61    JSR    $9561
A453: DC 11       LDD    $11
A455: 27 01       BEQ    $A458
A457: 39          RTS
A458: 0F 0E       CLR    $0E
A45A: 96 0E       LDA    $0E
A45C: 84 3F       ANDA   #$3F
A45E: 27 01       BEQ    $A461
A460: 39          RTS
A461: 0C 06       INC    $06
A463: 0C 07       INC    $07
A465: 39          RTS
A466: 96 D1       LDA    $D1
A468: 81 05       CMPA   #$05
A46A: 26 26       BNE    $A492
A46C: 10 8E 53 80 LDY    #$5380
A470: 96 E2       LDA    $E2
A472: C6 4C       LDB    #$4C
A474: E7 A6       STB    A,Y
A476: 4C          INCA
A477: 84 1F       ANDA   #$1F
A479: 97 E2       STA    $E2
A47B: 10 8E 53 80 LDY    #$5380
A47F: 96 E2       LDA    $E2
A481: C6 67       LDB    #$67
A483: E7 A6       STB    A,Y
A485: 4C          INCA
A486: 84 1F       ANDA   #$1F
A488: 97 E2       STA    $E2
A48A: 0C 06       INC    $06
A48C: BD B4 B8    JSR    $B4B8
A48F: 7E D6 36    JMP    $D636
A492: 10 8E 53 40 LDY    #$5340
A496: 96 E0       LDA    $E0
A498: C6 0C       LDB    #$0C
A49A: E7 A6       STB    A,Y
A49C: 4C          INCA
A49D: 84 1F       ANDA   #$1F
A49F: 97 E0       STA    $E0
A4A1: 86 05       LDA    #$05
A4A3: 97 E8       STA    $E8
A4A5: 10 8E 53 80 LDY    #$5380
A4A9: 96 E2       LDA    $E2
A4AB: C6 4C       LDB    #$4C
A4AD: E7 A6       STB    A,Y
A4AF: 4C          INCA
A4B0: 84 1F       ANDA   #$1F
A4B2: 97 E2       STA    $E2
A4B4: 0C 06       INC    $06
A4B6: BD B4 B8    JSR    $B4B8
A4B9: 7E D6 36    JMP    $D636
A4BC: 0F D2       CLR    $D2
A4BE: CC 00 00    LDD    #$0000
A4C1: DD 88       STD    $88
A4C3: DD 8A       STD    $8A
A4C5: BD D8 36    JSR    $D836
A4C8: 0C D2       INC    $D2
A4CA: 96 D2       LDA    $D2
A4CC: 81 02       CMPA   #$02
A4CE: 26 FA       BNE    $A4CA
A4D0: 39          RTS
A4D1: 10 8E 53 40 LDY    #$5340
A4D5: 96 E0       LDA    $E0
A4D7: C6 8C       LDB    #$8C
A4D9: E7 A6       STB    A,Y
A4DB: 4C          INCA
A4DC: 84 1F       ANDA   #$1F
A4DE: 97 E0       STA    $E0
A4E0: 0F E8       CLR    $E8
A4E2: 10 8E 53 80 LDY    #$5380
A4E6: 96 E2       LDA    $E2
A4E8: C6 2B       LDB    #$2B
A4EA: E7 A6       STB    A,Y
A4EC: 4C          INCA
A4ED: 84 1F       ANDA   #$1F
A4EF: 97 E2       STA    $E2
A4F1: 0C D1       INC    $D1
A4F3: 0C 06       INC    $06
A4F5: 0C 07       INC    $07
A4F7: BD B4 B8    JSR    $B4B8
A4FA: 7E 84 8C    JMP    $848C
A4FD: CC 00 00    LDD    #$0000
A500: FD 54 5C    STD    $545C
A503: FD 54 5E    STD    $545E
A506: 97 14       STA    $14
A508: 97 15       STA    $15
A50A: CE A5 37    LDU    #$A537
A50D: B6 42 51    LDA    $4251
A510: 48          ASLA
A511: EC C6       LDD    A,U
A513: DD 11       STD    $11
A515: 86 40       LDA    #$40
A517: 97 C1       STA    $C1
A519: CC 00 50    LDD    #$0050
A51C: 10 93 CA    CMPD   $CA
A51F: 23 02       BLS    $A523
A521: DD CA       STD    $CA
A523: 0C 06       INC    $06
A525: 0C 07       INC    $07
A527: 0D 01       TST    $01
A529: 26 06       BNE    $A531
A52B: CE 54 80    LDU    #$5480
A52E: 7E A2 25    JMP    $A225
A531: CE 54 A0    LDU    #$54A0
A534: 7E A2 25    JMP    $A225
A537: 01 20       NEG    $20
A539: 01 50       NEG    $50
A53B: 0D C4       TST    $C4
A53D: 27 0D       BEQ    $A54C
A53F: 86 04       LDA    #$04
A541: 97 04       STA    $04
A543: 0F 06       CLR    $06
A545: 97 05       STA    $05
A547: 0F 07       CLR    $07
A549: 7E B4 B8    JMP    $B4B8
A54C: 86 03       LDA    #$03
A54E: 97 04       STA    $04
A550: 0F 06       CLR    $06
A552: 97 05       STA    $05
A554: 0F 07       CLR    $07
A556: 7E B4 B8    JMP    $B4B8
A559: 96 06       LDA    $06
A55B: 91 07       CMPA   $07
A55D: 23 01       BLS    $A560
A55F: 39          RTS
A560: CE A5 66    LDU    #jump_table_a566
A563: 48          ASLA
A564: 6E D6       JMP    [A,U]		; [indirect_jump] [nb_entries=2]

A56A: BD 83 CB    JSR    $83CB
A56D: BD 84 8C    JSR    $848C
A570: BD 84 CD    JSR    $84CD
A573: BD 84 E0    JSR    $84E0
A576: BD 84 F9    JSR    $84F9
A579: 0C 06       INC    $06
A57B: 39          RTS
A57C: 8D 12       BSR    $A590
A57E: DC C6       LDD    $C6
A580: C3 01 01    ADDD   #$0101
A583: DD C6       STD    $C6
A585: DD C8       STD    $C8
A587: 0C 04       INC    $04
A589: 0F 06       CLR    $06
A58B: 0C 05       INC    $05
A58D: 0F 07       CLR    $07
A58F: 39          RTS
A590: 0D CF       TST    $CF
A592: 26 08       BNE    $A59C
A594: DC 7A       LDD    $7A
A596: DD C6       STD    $C6
A598: DD C8       STD    $C8
A59A: 20 06       BRA    $A5A2
A59C: DC 7C       LDD    $7C
A59E: DD C6       STD    $C6
A5A0: DD C8       STD    $C8
A5A2: 96 C6       LDA    $C6
A5A4: 5F          CLRB
A5A5: DD 80       STD    $80
A5A7: 96 C7       LDA    $C7
A5A9: C6 08       LDB    #$08
A5AB: DD 82       STD    $82
A5AD: 8E 55 00    LDX    #$5500
A5B0: 10 8E 53 C0 LDY    #$53C0
A5B4: 4F          CLRA
A5B5: A7 84       STA    ,X
A5B7: 8D 0E       BSR    $A5C7
A5B9: 10 8E 53 D0 LDY    #$53D0
A5BD: 6C 84       INC    ,X
A5BF: 8D 06       BSR    $A5C7
A5C1: 10 8E 53 E0 LDY    #$53E0
A5C5: 6C 84       INC    ,X
A5C7: DC 82       LDD    $82
A5C9: 97 AC       STA    $AC
A5CB: A6 29       LDA    $9,Y
A5CD: 3D          MUL
A5CE: ED 22       STD    $2,Y
A5D0: 58          ASLB
A5D1: 49          ROLA
A5D2: 80 02       SUBA   #$02
A5D4: 2A 04       BPL    $A5DA
A5D6: 0A AC       DEC    $AC
A5D8: AB 2B       ADDA   $B,Y
A5DA: A7 E2       STA    ,-S    ; [local]
A5DC: A6 2B       LDA    $B,Y
A5DE: 4A          DECA
A5DF: A0 E0       SUBA   ,S+    ; [local]
A5E1: 97 AE       STA    $AE
A5E3: EC 22       LDD    $2,Y
A5E5: 84 0F       ANDA   #$0F
A5E7: 83 01 00    SUBD   #$0100
A5EA: 53          COMB
A5EB: 43          COMA
A5EC: C3 00 01    ADDD   #$0001
A5EF: 84 0F       ANDA   #$0F
A5F1: ED 26       STD    $6,Y
A5F3: ED 06       STD    $6,X
A5F5: 86 20       LDA    #$20
A5F7: 97 B1       STA    $B1
A5F9: EC 06       LDD    $6,X
A5FB: 83 00 80    SUBD   #$0080
A5FE: 84 0F       ANDA   #$0F
A600: ED 06       STD    $6,X
A602: CE B2 E4    LDU    #$B2E4
A605: A6 84       LDA    ,X
A607: 48          ASLA
A608: EC C6       LDD    A,U
A60A: E3 06       ADDD   $6,X
A60C: DD A9       STD    $A9
A60E: DC 80       LDD    $80
A610: 97 AB       STA    $AB
A612: A6 28       LDA    $8,Y
A614: 3D          MUL
A615: ED A4       STD    ,Y
A617: 58          ASLB
A618: 49          ROLA
A619: 80 04       SUBA   #$04
A61B: 2A 04       BPL    $A621
A61D: 0A AB       DEC    $AB
A61F: AB 2A       ADDA   $A,Y
A621: 97 AD       STA    $AD
A623: A6 21       LDA    $1,Y
A625: 84 F8       ANDA   #$F8
A627: 44          LSRA
A628: 44          LSRA
A629: A7 25       STA    $5,Y
A62B: A7 05       STA    $5,X
A62D: 8D 10       BSR    $A63F
A62F: 0A AE       DEC    $AE
A631: 2A 07       BPL    $A63A
A633: 0C AC       INC    $AC
A635: A6 2B       LDA    $B,Y
A637: 4A          DECA
A638: 97 AE       STA    $AE
A63A: 0A B1       DEC    $B1
A63C: 26 BB       BNE    $A5F9
A63E: 39          RTS
A63F: 86 2C       LDA    #$2C
A641: 97 B2       STA    $B2
A643: BD B4 D7    JSR    $B4D7
A646: 26 53       BNE    $A69B
A648: BD B4 EC    JSR    $B4EC
A64B: 26 4E       BNE    $A69B
A64D: BD B5 1D    JSR    $B51D
A650: BD B5 31    JSR    $B531
A653: BD B5 6D    JSR    $B56D
A656: DE A6       LDU    $A6
A658: 96 A8       LDA    $A8
A65A: EC C6       LDD    A,U
A65C: ED E3       STD    ,--S    ; [local]
A65E: DE A9       LDU    $A9
A660: A6 05       LDA    $5,X
A662: 33 C6       LEAU   A,U
A664: EC E1       LDD    ,S++    ; [local]
A666: ED C4       STD    ,U
A668: 0A B2       DEC    $B2
A66A: 27 2B       BEQ    $A697
A66C: A6 05       LDA    $5,X
A66E: 8B 02       ADDA   #$02
A670: 84 7F       ANDA   #$7F
A672: A7 05       STA    $5,X
A674: 0C AD       INC    $AD
A676: 96 AD       LDA    $AD
A678: 85 03       BITA   #$03
A67A: 27 08       BEQ    $A684
A67C: 96 A8       LDA    $A8
A67E: 8B 02       ADDA   #$02
A680: 97 A8       STA    $A8
A682: 20 D2       BRA    $A656
A684: A1 2A       CMPA   $A,Y
A686: 24 09       BCC    $A691
A688: DC A4       LDD    $A4
A68A: C3 00 02    ADDD   #$0002
A68D: DD A4       STD    $A4
A68F: 20 BF       BRA    $A650
A691: 0C AB       INC    $AB
A693: 0F AD       CLR    $AD
A695: 20 AC       BRA    $A643
A697: B7 80 00    STA    watchdog_8000
A69A: 39          RTS
A69B: DE A9       LDU    $A9
A69D: A6 05       LDA    $5,X
A69F: 33 C6       LEAU   A,U
A6A1: CC FF 03    LDD    #$FF03
A6A4: ED C4       STD    ,U
A6A6: 0A B2       DEC    $B2
A6A8: 27 17       BEQ    $A6C1
A6AA: A6 05       LDA    $5,X
A6AC: 8B 02       ADDA   #$02
A6AE: 84 7F       ANDA   #$7F
A6B0: A7 05       STA    $5,X
A6B2: 0C AD       INC    $AD
A6B4: 96 AD       LDA    $AD
A6B6: A1 2A       CMPA   $A,Y
A6B8: 25 E1       BCS    $A69B
A6BA: 0C AB       INC    $AB
A6BC: 0F AD       CLR    $AD
A6BE: 7E A6 43    JMP    $A643

A6C0: 43          COMA
A6C1: 39          RTS
A6C2: 0D CF       TST    $CF
A6C4: 27 01       BEQ    $A6C7
A6C6: 39          RTS
A6C7: 0D 60       TST    $60
A6C9: 26 01       BNE    $A6CC
A6CB: 39          RTS
A6CC: DC C6       LDD    $C6
A6CE: 83 01 01    SUBD   #$0101
A6D1: 10 93 7C    CMPD   $7C
A6D4: 27 01       BEQ    $A6D7
A6D6: 39          RTS
A6D7: 0C CF       INC    $CF
A6D9: 39          RTS
A6DA: CE A6 E2    LDU    #jump_table_a6e2
A6DD: 96 06       LDA    $06
A6DF: 48          ASLA
A6E0: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=2]

A6E6: CE A8 66    LDU    #$A866
A6E9: 96 C2       LDA    $C2
A6EB: 48          ASLA
A6EC: 48          ASLA
A6ED: 9B C2       ADDA   $C2
A6EF: 9B C4       ADDA   $C4
A6F1: A6 C6       LDA    A,U
A6F3: 97 E8       STA    $E8
A6F5: CE AF D6    LDU    #$AFD6
A6F8: 10 8E 32 10 LDY    #$3210
A6FC: C6 FC       LDB    #$FC
A6FE: A6 C0       LDA    ,U+
A700: A7 E2       STA    ,-S    ; [local]
A702: A6 C0       LDA    ,U+
A704: ED A1       STD    ,Y++
A706: 6A E4       DEC    ,S    ; [local]
A708: 26 F8       BNE    $A702
A70A: A6 E0       LDA    ,S+    ; [local]
A70C: CE AF DA    LDU    #$AFDA
A70F: 10 8E 32 22 LDY    #$3222
A713: C6 FC       LDB    #$FC
A715: A6 C0       LDA    ,U+
A717: A7 E2       STA    ,-S    ; [local]
A719: A6 C0       LDA    ,U+
A71B: ED A1       STD    ,Y++
A71D: 6A E4       DEC    ,S    ; [local]
A71F: 26 F8       BNE    $A719
A721: A6 E0       LDA    ,S+    ; [local]
A723: CE AF E5    LDU    #$AFE5
A726: 10 8E 32 42 LDY    #$3242
A72A: C6 FC       LDB    #$FC
A72C: A6 C0       LDA    ,U+
A72E: A7 E2       STA    ,-S    ; [local]
A730: A6 C0       LDA    ,U+
A732: ED A1       STD    ,Y++
A734: 6A E4       DEC    ,S    ; [local]
A736: 26 F8       BNE    $A730
A738: A6 E0       LDA    ,S+    ; [local]
A73A: CE AF E9    LDU    #$AFE9
A73D: 10 8E 33 0A LDY    #$330A
A741: C6 FC       LDB    #$FC
A743: A6 C0       LDA    ,U+
A745: A7 E2       STA    ,-S    ; [local]
A747: A6 C0       LDA    ,U+
A749: ED A1       STD    ,Y++
A74B: 6A E4       DEC    ,S    ; [local]
A74D: 26 F8       BNE    $A747
A74F: A6 E0       LDA    ,S+    ; [local]
A751: CE AF E9    LDU    #$AFE9
A754: 10 8E 33 44 LDY    #$3344
A758: C6 FC       LDB    #$FC
A75A: A6 C0       LDA    ,U+
A75C: A7 E2       STA    ,-S    ; [local]
A75E: A6 C0       LDA    ,U+
A760: ED A1       STD    ,Y++
A762: 6A E4       DEC    ,S    ; [local]
A764: 26 F8       BNE    $A75E
A766: A6 E0       LDA    ,S+    ; [local]
A768: CE B0 D4    LDU    #$B0D4
A76B: 10 8E 38 22 LDY    #$3822
A76F: C6 FC       LDB    #$FC
A771: A6 C0       LDA    ,U+
A773: A7 E2       STA    ,-S    ; [local]
A775: A6 C0       LDA    ,U+
A777: ED A1       STD    ,Y++
A779: 6A E4       DEC    ,S    ; [local]
A77B: 26 F8       BNE    $A775
A77D: A6 E0       LDA    ,S+    ; [local]
A77F: CE B0 36    LDU    #$B036
A782: 10 8E 3A 22 LDY    #$3A22
A786: C6 FC       LDB    #$FC
A788: A6 C0       LDA    ,U+
A78A: A7 E2       STA    ,-S    ; [local]
A78C: A6 C0       LDA    ,U+
A78E: ED A1       STD    ,Y++
A790: 6A E4       DEC    ,S    ; [local]
A792: 26 F8       BNE    $A78C
A794: A6 E0       LDA    ,S+    ; [local]
A796: CE B0 3F    LDU    #$B03F
A799: 10 8E 3B 22 LDY    #$3B22
A79D: C6 FC       LDB    #$FC
A79F: A6 C0       LDA    ,U+
A7A1: A7 E2       STA    ,-S    ; [local]
A7A3: A6 C0       LDA    ,U+
A7A5: ED A1       STD    ,Y++
A7A7: 6A E4       DEC    ,S    ; [local]
A7A9: 26 F8       BNE    $A7A3
A7AB: A6 E0       LDA    ,S+    ; [local]
A7AD: CE B1 08    LDU    #$B108
A7B0: 10 8E 3F 88 LDY    #$3F88
A7B4: C6 FC       LDB    #$FC
A7B6: A6 C0       LDA    ,U+
A7B8: A7 E2       STA    ,-S    ; [local]
A7BA: A6 C0       LDA    ,U+
A7BC: ED A1       STD    ,Y++
A7BE: 6A E4       DEC    ,S    ; [local]
A7C0: 26 F8       BNE    $A7BA
A7C2: A6 E0       LDA    ,S+    ; [local]
A7C4: CE B1 5C    LDU    #$B15C
A7C7: 10 8E 3F BE LDY    #$3FBE
A7CB: C6 FC       LDB    #$FC
A7CD: A6 C0       LDA    ,U+
A7CF: A7 E2       STA    ,-S    ; [local]
A7D1: A6 C0       LDA    ,U+
A7D3: ED A1       STD    ,Y++
A7D5: 6A E4       DEC    ,S    ; [local]
A7D7: 26 F8       BNE    $A7D1
A7D9: A6 E0       LDA    ,S+    ; [local]
A7DB: CE B1 1E    LDU    #$B11E
A7DE: 10 8E 3F A2 LDY    #$3FA2
A7E2: C6 FC       LDB    #$FC
A7E4: A6 C0       LDA    ,U+
A7E6: A7 E2       STA    ,-S    ; [local]
A7E8: A6 C0       LDA    ,U+
A7EA: ED A1       STD    ,Y++
A7EC: 6A E4       DEC    ,S    ; [local]
A7EE: 26 F8       BNE    $A7E8
A7F0: A6 E0       LDA    ,S+    ; [local]
A7F2: 10 8E 3A 2E LDY    #$3A2E
A7F6: C6 FC       LDB    #$FC
A7F8: 96 C3       LDA    $C3
A7FA: 44          LSRA
A7FB: 44          LSRA
A7FC: 44          LSRA
A7FD: 44          LSRA
A7FE: 26 02       BNE    $A802
A800: 86 FF       LDA    #$FF
A802: ED A4       STD    ,Y
A804: 96 C3       LDA    $C3
A806: 84 0F       ANDA   #$0F
A808: ED 22       STD    $2,Y
A80A: 10 8E 3B 2E LDY    #$3B2E
A80E: C6 FC       LDB    #$FC
A810: 96 C5       LDA    $C5
A812: 44          LSRA
A813: 44          LSRA
A814: 44          LSRA
A815: 44          LSRA
A816: 26 02       BNE    $A81A
A818: 86 FF       LDA    #$FF
A81A: ED A4       STD    ,Y
A81C: 96 C5       LDA    $C5
A81E: 84 0F       ANDA   #$0F
A820: ED 22       STD    $2,Y
A822: BD 93 E4    JSR    $93E4
A825: BD 93 60    JSR    $9360
A828: BD 95 07    JSR    $9507
A82B: BD 95 61    JSR    $9561
A82E: 0C 06       INC    $06
A830: 0F 0E       CLR    $0E
A832: 0D 01       TST    $01
A834: 26 18       BNE    $A84E
A836: CE B0 BE    LDU    #$B0BE
A839: 10 8E 37 22 LDY    #$3722
A83D: C6 FC       LDB    #$FC
A83F: A6 C0       LDA    ,U+
A841: A7 E2       STA    ,-S    ; [local]
A843: A6 C0       LDA    ,U+
A845: ED A1       STD    ,Y++
A847: 6A E4       DEC    ,S    ; [local]
A849: 26 F8       BNE    $A843
A84B: A6 E0       LDA    ,S+    ; [local]
A84D: 39          RTS
A84E: CE B0 C9    LDU    #$B0C9
A851: 10 8E 37 22 LDY    #$3722
A855: C6 FC       LDB    #$FC
A857: A6 C0       LDA    ,U+
A859: A7 E2       STA    ,-S    ; [local]
A85B: A6 C0       LDA    ,U+
A85D: ED A1       STD    ,Y++
A85F: 6A E4       DEC    ,S    ; [local]
A861: 26 F8       BNE    $A85B
A863: A6 E0       LDA    ,S+    ; [local]
A865: 39          RTS
A866: 06 06       ROR    $06
A868: 0A 0A       DEC    $0A
A86A: 06 06       ROR    $06
A86C: 06 0A       ROR    $0A
A86E: 0A 06       DEC    $06
A870: 96 0E       LDA    $0E
A872: 84 7F       ANDA   #$7F
A874: 27 01       BEQ    $A877
A876: 39          RTS
A877: 10 8E 37 22 LDY    #$3722
A87B: 86 FF       LDA    #$FF
A87D: F6 B0 BE    LDB    $B0BE
A880: A7 A1       STA    ,Y++
A882: 5A          DECB
A883: 26 FB       BNE    $A880
A885: 10 8E 38 22 LDY    #$3822
A889: 86 FF       LDA    #$FF
A88B: F6 B0 D4    LDB    $B0D4
A88E: A7 A1       STA    ,Y++
A890: 5A          DECB
A891: 26 FB       BNE    $A88E
A893: 10 8E 3A 22 LDY    #$3A22
A897: 86 FF       LDA    #$FF
A899: F6 B0 36    LDB    $B036
A89C: A7 A1       STA    ,Y++
A89E: 5A          DECB
A89F: 26 FB       BNE    $A89C
A8A1: 10 8E 3B 22 LDY    #$3B22
A8A5: 86 FF       LDA    #$FF
A8A7: F6 B0 3F    LDB    $B03F
A8AA: A7 A1       STA    ,Y++
A8AC: 5A          DECB
A8AD: 26 FB       BNE    $A8AA
A8AF: 0F 0B       CLR    $0B
A8B1: 0F 0D       CLR    $0D
A8B3: 96 0A       LDA    $0A
A8B5: 84 FC       ANDA   #$FC
A8B7: 97 0A       STA    $0A
A8B9: BD 93 E4    JSR    $93E4
A8BC: 0C 04       INC    $04
A8BE: 0F 06       CLR    $06
A8C0: 0C 05       INC    $05
A8C2: 0F 07       CLR    $07
A8C4: 39          RTS
A8C5: 96 06       LDA    $06
A8C7: 91 07       CMPA   $07
A8C9: 23 01       BLS    $A8CC
A8CB: 39          RTS
A8CC: CE A8 D2    LDU    #jump_table_a8d2
A8CF: 48          ASLA
A8D0: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=10]

A8E6: 86 0C       LDA    #$0C
A8E8: 97 E8       STA    $E8
A8EA: 0D 01       TST    $01
A8EC: 26 35       BNE    $A923
A8EE: CE B0 BE    LDU    #$B0BE
A8F1: 10 8E 37 22 LDY    #$3722
A8F5: C6 FC       LDB    #$FC
A8F7: A6 C0       LDA    ,U+
A8F9: A7 E2       STA    ,-S    ; [local]
A8FB: A6 C0       LDA    ,U+
A8FD: ED A1       STD    ,Y++
A8FF: 6A E4       DEC    ,S    ; [local]
A901: 26 F8       BNE    $A8FB
A903: A6 E0       LDA    ,S+    ; [local]
A905: CE B0 EA    LDU    #$B0EA
A908: 10 8E 38 22 LDY    #$3822
A90C: C6 E4       LDB    #$E4
A90E: A6 C0       LDA    ,U+
A910: A7 E2       STA    ,-S    ; [local]
A912: A6 C0       LDA    ,U+
A914: ED A1       STD    ,Y++
A916: 6A E4       DEC    ,S    ; [local]
A918: 26 F8       BNE    $A912
A91A: A6 E0       LDA    ,S+    ; [local]
A91C: 0F 0E       CLR    $0E
A91E: 0C 06       INC    $06
A920: 0C 07       INC    $07
A922: 39          RTS
A923: CE B0 C9    LDU    #$B0C9
A926: 10 8E 37 22 LDY    #$3722
A92A: C6 FC       LDB    #$FC
A92C: A6 C0       LDA    ,U+
A92E: A7 E2       STA    ,-S    ; [local]
A930: A6 C0       LDA    ,U+
A932: ED A1       STD    ,Y++
A934: 6A E4       DEC    ,S    ; [local]
A936: 26 F8       BNE    $A930
A938: A6 E0       LDA    ,S+    ; [local]
A93A: CE B0 EA    LDU    #$B0EA
A93D: 10 8E 38 22 LDY    #$3822
A941: C6 E4       LDB    #$E4
A943: A6 C0       LDA    ,U+
A945: A7 E2       STA    ,-S    ; [local]
A947: A6 C0       LDA    ,U+
A949: ED A1       STD    ,Y++
A94B: 6A E4       DEC    ,S    ; [local]
A94D: 26 F8       BNE    $A947
A94F: A6 E0       LDA    ,S+    ; [local]
A951: 0F 0E       CLR    $0E
A953: 0C 06       INC    $06
A955: 0C 07       INC    $07
A957: 39          RTS
A958: 7D 43 80    TST    $4380
A95B: 27 01       BEQ    $A95E
A95D: 39          RTS
A95E: 10 8E 37 22 LDY    #$3722
A962: 86 FF       LDA    #$FF
A964: F6 B0 C9    LDB    $B0C9
A967: A7 A1       STA    ,Y++
A969: 5A          DECB
A96A: 26 FB       BNE    $A967
A96C: 10 8E 38 22 LDY    #$3822
A970: 86 FF       LDA    #$FF
A972: F6 B0 EA    LDB    $B0EA
A975: A7 A1       STA    ,Y++
A977: 5A          DECB
A978: 26 FB       BNE    $A975
A97A: 10 8E 33 0A LDY    #$330A
A97E: 86 FF       LDA    #$FF
A980: F6 AF E9    LDB    $AFE9
A983: A7 A1       STA    ,Y++
A985: 5A          DECB
A986: 26 FB       BNE    $A983
A988: 10 8E 33 44 LDY    #$3344
A98C: 86 FF       LDA    #$FF
A98E: F6 AF E9    LDB    $AFE9
A991: A7 A1       STA    ,Y++
A993: 5A          DECB
A994: 26 FB       BNE    $A991
A996: 10 8E 3F 08 LDY    #$3F08
A99A: 86 FF       LDA    #$FF
A99C: F6 B1 13    LDB    $B113
A99F: A7 A1       STA    ,Y++
A9A1: 5A          DECB
A9A2: 26 FB       BNE    $A99F
A9A4: 10 8E 3F 88 LDY    #$3F88
A9A8: 86 FF       LDA    #$FF
A9AA: F6 B1 08    LDB    $B108
A9AD: A7 A1       STA    ,Y++
A9AF: 5A          DECB
A9B0: 26 FB       BNE    $A9AD
A9B2: 10 8E 3F A2 LDY    #$3FA2
A9B6: 86 FF       LDA    #$FF
A9B8: F6 B1 1E    LDB    $B11E
A9BB: A7 A1       STA    ,Y++
A9BD: 5A          DECB
A9BE: 26 FB       BNE    $A9BB
A9C0: 10 8E 3F BE LDY    #$3FBE
A9C4: 86 FF       LDA    #$FF
A9C6: F6 B1 5C    LDB    $B15C
A9C9: A7 A1       STA    ,Y++
A9CB: 5A          DECB
A9CC: 26 FB       BNE    $A9C9
A9CE: CE B0 11    LDU    #$B011
A9D1: 10 8E 3F 88 LDY    #$3F88
A9D5: C6 FC       LDB    #$FC
A9D7: A6 C0       LDA    ,U+
A9D9: A7 E2       STA    ,-S    ; [local]
A9DB: A6 C0       LDA    ,U+
A9DD: ED A1       STD    ,Y++
A9DF: 6A E4       DEC    ,S    ; [local]
A9E1: 26 F8       BNE    $A9DB
A9E3: A6 E0       LDA    ,S+    ; [local]
A9E5: C6 FC       LDB    #$FC
A9E7: B6 41 89    LDA    $4189
A9EA: 26 02       BNE    $A9EE
A9EC: 86 FF       LDA    #$FF
A9EE: FD 3F 96    STD    $3F96
A9F1: B6 41 8A    LDA    $418A
A9F4: FD 3F 98    STD    $3F98
A9F7: 0C 06       INC    $06
A9F9: 0C 07       INC    $07
A9FB: 7E B4 34    JMP    $B434
A9FE: C6 FC       LDB    #$FC
AA00: B6 41 89    LDA    $4189
AA03: 26 02       BNE    $AA07
AA05: 86 FF       LDA    #$FF
AA07: FD 3F 96    STD    $3F96
AA0A: B6 41 8A    LDA    $418A
AA0D: FD 3F 98    STD    $3F98
AA10: BD 96 30    JSR    $9630
AA13: 7D 54 31    TST    $5431
AA16: 27 01       BEQ    $AA19
AA18: 39          RTS
AA19: 0C 06       INC    $06
AA1B: 0C 07       INC    $07
AA1D: 39          RTS
AA1E: C6 FC       LDB    #$FC
AA20: B6 41 89    LDA    $4189
AA23: 26 02       BNE    $AA27
AA25: 86 FF       LDA    #$FF
AA27: FD 3F 96    STD    $3F96
AA2A: B6 41 8A    LDA    $418A
AA2D: FD 3F 98    STD    $3F98
AA30: BD B4 B8    JSR    $B4B8
AA33: 86 05       LDA    #$05
AA35: 97 D1       STA    $D1
AA37: 10 8E 53 80 LDY    #$5380
AA3B: 96 E2       LDA    $E2
AA3D: C6 67       LDB    #$67
AA3F: E7 A6       STB    A,Y
AA41: 4C          INCA
AA42: 84 1F       ANDA   #$1F
AA44: 97 E2       STA    $E2
AA46: 0C 06       INC    $06
AA48: 7E D6 36    JMP    $D636
AA4B: C6 FC       LDB    #$FC
AA4D: B6 41 89    LDA    $4189
AA50: 26 02       BNE    $AA54
AA52: 86 FF       LDA    #$FF
AA54: FD 3F 96    STD    $3F96
AA57: B6 41 8A    LDA    $418A
AA5A: FD 3F 98    STD    $3F98
AA5D: 0F D2       CLR    $D2
AA5F: CC 00 00    LDD    #$0000
AA62: DD 88       STD    $88
AA64: DD 8A       STD    $8A
AA66: BD D8 36    JSR    $D836
AA69: 0C D2       INC    $D2
AA6B: 96 D2       LDA    $D2
AA6D: 81 02       CMPA   #$02
AA6F: 26 FA       BNE    $AA6B
AA71: 39          RTS
AA72: C6 FC       LDB    #$FC
AA74: B6 41 89    LDA    $4189
AA77: 26 02       BNE    $AA7B
AA79: 86 FF       LDA    #$FF
AA7B: FD 3F 96    STD    $3F96
AA7E: B6 41 8A    LDA    $418A
AA81: FD 3F 98    STD    $3F98
AA84: 0F E8       CLR    $E8
AA86: BD 84 23    JSR    $8423
AA89: 0C 06       INC    $06
AA8B: 0C 07       INC    $07
AA8D: 7E B4 B8    JMP    $B4B8
AA90: C6 FC       LDB    #$FC
AA92: B6 41 89    LDA    $4189
AA95: 26 02       BNE    $AA99
AA97: 86 FF       LDA    #$FF
AA99: FD 3F 96    STD    $3F96
AA9C: B6 41 8A    LDA    $418A
AA9F: FD 3F 98    STD    $3F98
AAA2: BD 84 8C    JSR    $848C
AAA5: BD 83 CB    JSR    $83CB
AAA8: 7D 41 8E    TST    $418E
AAAB: 27 37       BEQ    $AAE4
AAAD: 0D 01       TST    $01
AAAF: 26 2E       BNE    $AADF
AAB1: 7D 54 A0    TST    $54A0
AAB4: 27 2E       BEQ    $AAE4
AAB6: 96 01       LDA    $01
AAB8: 88 01       EORA   #$01
AABA: 97 01       STA    $01
AABC: CE AB 02    LDU    #$AB02
AABF: B6 42 51    LDA    $4251
AAC2: 48          ASLA
AAC3: EC C6       LDD    A,U
AAC5: DD 11       STD    $11
AAC7: CC 00 00    LDD    #$0000
AACA: FD 54 5C    STD    $545C
AACD: FD 54 5E    STD    $545E
AAD0: 97 14       STA    $14
AAD2: 97 15       STA    $15
AAD4: 86 01       LDA    #$01
AAD6: 97 04       STA    $04
AAD8: 97 05       STA    $05
AADA: 0F 06       CLR    $06
AADC: 0F 07       CLR    $07
AADE: 39          RTS
AADF: 7D 54 80    TST    $5480
AAE2: 26 D2       BNE    $AAB6
AAE4: 0F 01       CLR    $01
AAE6: 0D DB       TST    $DB
AAE8: 27 0F       BEQ    $AAF9
AAEA: 0D D8       TST    $D8
AAEC: 2B 0B       BMI    $AAF9
AAEE: B6 41 8E    LDA    $418E
AAF1: 4C          INCA
AAF2: 97 D8       STA    $D8
AAF4: 0C 06       INC    $06
AAF6: 0C 07       INC    $07
AAF8: 39          RTS
AAF9: 0F D8       CLR    $D8
AAFB: 0F D9       CLR    $D9
AAFD: 0C 06       INC    $06
AAFF: 0C 07       INC    $07
AB01: 39          RTS
AB02: 01 20       NEG    $20
AB04: 01 50       NEG    $50
AB06: C6 FC       LDB    #$FC
AB08: B6 41 89    LDA    $4189
AB0B: 26 02       BNE    $AB0F
AB0D: 86 FF       LDA    #$FF
AB0F: FD 3F 96    STD    $3F96
AB12: B6 41 8A    LDA    $418A
AB15: FD 3F 98    STD    $3F98
AB18: 7F 41 8C    CLR    $418C
AB1B: 86 10       LDA    #$10
AB1D: 97 DA       STA    $DA
AB1F: 0F 13       CLR    $13
AB21: 7D 41 A5    TST    $41A5
AB24: 26 0B       BNE    $AB31
AB26: 0D D8       TST    $D8
AB28: 10 27 01 16 LBEQ   $AC42
AB2C: 0C 06       INC    $06
AB2E: 0C 07       INC    $07
AB30: 39          RTS
AB31: 86 01       LDA    #$01
AB33: 97 D1       STA    $D1
AB35: 86 05       LDA    #$05
AB37: 97 02       STA    $02
AB39: 0F 04       CLR    $04
AB3B: 0F 06       CLR    $06
AB3D: 97 03       STA    $03
AB3F: 0F 05       CLR    $05
AB41: 0F 07       CLR    $07
AB43: 39          RTS
AB44: C6 FC       LDB    #$FC
AB46: B6 41 89    LDA    $4189
AB49: 26 02       BNE    $AB4D
AB4B: 86 FF       LDA    #$FF
AB4D: FD 3F 96    STD    $3F96
AB50: B6 41 8A    LDA    $418A
AB53: FD 3F 98    STD    $3F98
AB56: CE B0 57    LDU    #$B057
AB59: 10 8E 37 24 LDY    #$3724
AB5D: C6 FC       LDB    #$FC
AB5F: A6 C0       LDA    ,U+
AB61: A7 E2       STA    ,-S    ; [local]
AB63: A6 C0       LDA    ,U+
AB65: ED A1       STD    ,Y++
AB67: 6A E4       DEC    ,S    ; [local]
AB69: 26 F8       BNE    $AB63
AB6B: A6 E0       LDA    ,S+    ; [local]
AB6D: CE B0 60    LDU    #$B060
AB70: 10 8E 38 9A LDY    #$389A
AB74: C6 FC       LDB    #$FC
AB76: A6 C0       LDA    ,U+
AB78: A7 E2       STA    ,-S    ; [local]
AB7A: A6 C0       LDA    ,U+
AB7C: ED A1       STD    ,Y++
AB7E: 6A E4       DEC    ,S    ; [local]
AB80: 26 F8       BNE    $AB7A
AB82: A6 E0       LDA    ,S+    ; [local]
AB84: CE B0 71    LDU    #$B071
AB87: 10 8E 39 A0 LDY    #$39A0
AB8B: C6 FC       LDB    #$FC
AB8D: A6 C0       LDA    ,U+
AB8F: A7 E2       STA    ,-S    ; [local]
AB91: A6 C0       LDA    ,U+
AB93: ED A1       STD    ,Y++
AB95: 6A E4       DEC    ,S    ; [local]
AB97: 26 F8       BNE    $AB91
AB99: A6 E0       LDA    ,S+    ; [local]
AB9B: CE AF EF    LDU    #$AFEF
AB9E: 10 8E 3C 1E LDY    #$3C1E
ABA2: C6 FC       LDB    #$FC
ABA4: A6 C0       LDA    ,U+
ABA6: A7 E2       STA    ,-S    ; [local]
ABA8: A6 C0       LDA    ,U+
ABAA: ED A1       STD    ,Y++
ABAC: 6A E4       DEC    ,S    ; [local]
ABAE: 26 F8       BNE    $ABA8
ABB0: A6 E0       LDA    ,S+    ; [local]
ABB2: CE AF FD    LDU    #$AFFD
ABB5: 10 8E 3D 1A LDY    #$3D1A
ABB9: C6 FC       LDB    #$FC
ABBB: A6 C0       LDA    ,U+
ABBD: A7 E2       STA    ,-S    ; [local]
ABBF: A6 C0       LDA    ,U+
ABC1: ED A1       STD    ,Y++
ABC3: 6A E4       DEC    ,S    ; [local]
ABC5: 26 F8       BNE    $ABBF
ABC7: A6 E0       LDA    ,S+    ; [local]
ABC9: 10 8E 37 30 LDY    #$3730
ABCD: C6 E4       LDB    #$E4
ABCF: 96 DA       LDA    $DA
ABD1: 44          LSRA
ABD2: 44          LSRA
ABD3: 44          LSRA
ABD4: 44          LSRA
ABD5: 26 02       BNE    $ABD9
ABD7: 86 FF       LDA    #$FF
ABD9: ED A4       STD    ,Y
ABDB: 96 DA       LDA    $DA
ABDD: 84 0F       ANDA   #$0F
ABDF: ED 22       STD    $2,Y
ABE1: C6 E4       LDB    #$E4
ABE3: BD 90 52    JSR    $9052
ABE6: 0C 06       INC    $06
ABE8: 0C 07       INC    $07
ABEA: 39          RTS

ABF4: C6 FC       LDB    #$FC
ABF6: B6 41 89    LDA    $4189
ABF9: 26 02       BNE    $ABFD
ABFB: 86 FF       LDA    #$FF
ABFD: FD 3F 96    STD    $3F96
AC00: B6 41 8A    LDA    $418A
AC03: FD 3F 98    STD    $3F98
AC06: 7D 41 A5    TST    $41A5
AC09: 10 26 FF 24 LBNE   $AB31
AC0D: 8D 44       BSR    $AC53
AC0F: 27 01       BEQ    $AC12
AC11: 39          RTS
AC12: 0F DB       CLR    $DB
AC14: 0F D8       CLR    $D8
AC16: 0F D9       CLR    $D9
AC18: 10 8E 37 24 LDY    #$3724
AC1C: 86 FF       LDA    #$FF
AC1E: F6 B0 57    LDB    $B057
AC21: A7 A1       STA    ,Y++
AC23: 5A          DECB
AC24: 26 FB       BNE    $AC21
AC26: 10 8E 38 9A LDY    #$389A
AC2A: 86 FF       LDA    #$FF
AC2C: F6 B0 60    LDB    $B060
AC2F: A7 A1       STA    ,Y++
AC31: 5A          DECB
AC32: 26 FB       BNE    $AC2F
AC34: 10 8E 39 A0 LDY    #$39A0
AC38: 86 FF       LDA    #$FF
AC3A: F6 B0 71    LDB    $B071
AC3D: A7 A1       STA    ,Y++
AC3F: 5A          DECB
AC40: 26 FB       BNE    $AC3D
AC42: 0F D1       CLR    $D1
AC44: 86 02       LDA    #$02
AC46: 97 02       STA    $02
AC48: 0F 04       CLR    $04
AC4A: 0F 06       CLR    $06
AC4C: 97 03       STA    $03
AC4E: 0F 05       CLR    $05
AC50: 0F 07       CLR    $07
AC52: 39          RTS
AC53: 96 13       LDA    $13
AC55: 4C          INCA
AC56: 84 3F       ANDA   #$3F
AC58: 97 13       STA    $13
AC5A: 26 07       BNE    $AC63
AC5C: 96 DA       LDA    $DA
AC5E: 8B 99       ADDA   #$99
AC60: 19          DAA
AC61: 97 DA       STA    $DA
AC63: 10 8E 37 30 LDY    #$3730
AC67: C6 E4       LDB    #$E4
AC69: 96 DA       LDA    $DA
AC6B: 44          LSRA
AC6C: 44          LSRA
AC6D: 44          LSRA
AC6E: 44          LSRA
AC6F: 26 02       BNE    $AC73
AC71: 86 FF       LDA    #$FF
AC73: ED A4       STD    ,Y
AC75: 96 DA       LDA    $DA
AC77: 84 0F       ANDA   #$0F
AC79: ED 22       STD    $2,Y
AC7B: 96 DA       LDA    $DA
AC7D: 39          RTS
AC7E: 96 06       LDA    $06
AC80: 91 07       CMPA   $07
AC82: 23 01       BLS    $AC85
AC84: 39          RTS
AC85: CE AC 8B    LDU    #jump_table_ac8b
AC88: 48          ASLA
AC89: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=12]

ACA3: 0C 06       INC    $06
ACA5: 0F E8       CLR    $E8
ACA7: BD 84 E0    JSR    $84E0
ACAA: 7E 84 F9    JMP    $84F9
ACAD: 96 B3       LDA    $B3
ACAF: 91 B4       CMPA   $B4
ACB1: 27 01       BEQ    $ACB4
ACB3: 39          RTS
ACB4: 0C 06       INC    $06
ACB6: BD 84 23    JSR    $8423
ACB9: 7E 84 BA    JMP    $84BA

ACBC: 96 6E       LDA    $6E
ACBE: 91 6F       CMPA   $6F
ACC0: 27 01       BEQ    $ACC3
ACC2: 39          RTS
ACC3: 0C 06       INC    $06
ACC5: BD 83 CB    JSR    $83CB
ACC8: BD B4 B8    JSR    $B4B8
ACCB: BD 84 CD    JSR    $84CD
ACCE: 7E 84 8C    JMP    $848C
ACD1: 86 09       LDA    #$09
ACD3: 97 E8       STA    $E8
ACD5: CE B1 2C    LDU    #$B12C
ACD8: 10 8E 35 1C LDY    #$351C
ACDC: C6 FC       LDB    #$FC
ACDE: A6 C0       LDA    ,U+
ACE0: A7 E2       STA    ,-S    ; [local]
ACE2: A6 C0       LDA    ,U+
ACE4: ED A1       STD    ,Y++
ACE6: 6A E4       DEC    ,S    ; [local]
ACE8: 26 F8       BNE    $ACE2
ACEA: A6 E0       LDA    ,S+    ; [local]
ACEC: 0F 0E       CLR    $0E
ACEE: 0C 06       INC    $06
ACF0: 0C 07       INC    $07
ACF2: 0D 01       TST    $01
ACF4: 26 31       BNE    $AD27
ACF6: CE B0 BE    LDU    #$B0BE
ACF9: 10 8E 37 22 LDY    #$3722
ACFD: C6 FC       LDB    #$FC
ACFF: A6 C0       LDA    ,U+
AD01: A7 E2       STA    ,-S    ; [local]
AD03: A6 C0       LDA    ,U+
AD05: ED A1       STD    ,Y++
AD07: 6A E4       DEC    ,S    ; [local]
AD09: 26 F8       BNE    $AD03
AD0B: A6 E0       LDA    ,S+    ; [local]
AD0D: CE B0 F5    LDU    #$B0F5
AD10: 10 8E 38 1A LDY    #$381A
AD14: C6 FC       LDB    #$FC
AD16: A6 C0       LDA    ,U+
AD18: A7 E2       STA    ,-S    ; [local]
AD1A: A6 C0       LDA    ,U+
AD1C: ED A1       STD    ,Y++
AD1E: 6A E4       DEC    ,S    ; [local]
AD20: 26 F8       BNE    $AD1A
AD22: A6 E0       LDA    ,S+    ; [local]
AD24: 7E B4 34    JMP    $B434
AD27: CE B0 C9    LDU    #$B0C9
AD2A: 10 8E 37 22 LDY    #$3722
AD2E: C6 FC       LDB    #$FC
AD30: A6 C0       LDA    ,U+
AD32: A7 E2       STA    ,-S    ; [local]
AD34: A6 C0       LDA    ,U+
AD36: ED A1       STD    ,Y++
AD38: 6A E4       DEC    ,S    ; [local]
AD3A: 26 F8       BNE    $AD34
AD3C: A6 E0       LDA    ,S+    ; [local]
AD3E: CE B0 F5    LDU    #$B0F5
AD41: 10 8E 38 1A LDY    #$381A
AD45: C6 FC       LDB    #$FC
AD47: A6 C0       LDA    ,U+
AD49: A7 E2       STA    ,-S    ; [local]
AD4B: A6 C0       LDA    ,U+
AD4D: ED A1       STD    ,Y++
AD4F: 6A E4       DEC    ,S    ; [local]
AD51: 26 F8       BNE    $AD4B
AD53: A6 E0       LDA    ,S+    ; [local]
AD55: 7E B4 34    JMP    $B434
AD58: DC 11       LDD    $11
AD5A: 27 2F       BEQ    $AD8B
AD5C: 10 8E 53 40 LDY    #$5340
AD60: 96 E0       LDA    $E0
AD62: C6 0A       LDB    #$0A
AD64: E7 A6       STB    A,Y
AD66: 4C          INCA
AD67: 84 1F       ANDA   #$1F
AD69: 97 E0       STA    $E0
AD6B: CC 00 12    LDD    #$0012
AD6E: FD 54 5C    STD    $545C
AD71: CC 00 00    LDD    #$0000
AD74: FD 54 5E    STD    $545E
AD77: BD 93 7A    JSR    $937A
AD7A: CE 56 11    LDU    #$5611
AD7D: CC 99 99    LDD    #$9999
AD80: BD 98 EF    JSR    $98EF
AD83: BD 95 61    JSR    $9561
AD86: DC 11       LDD    $11
AD88: 27 01       BEQ    $AD8B
AD8A: 39          RTS
AD8B: 96 0E       LDA    $0E
AD8D: 81 C0       CMPA   #$C0
AD8F: 24 01       BCC    $AD92
AD91: 39          RTS
AD92: 0F 0E       CLR    $0E
AD94: 0C 06       INC    $06
AD96: 0C 07       INC    $07
AD98: 39          RTS
AD99: 96 0E       LDA    $0E
AD9B: 84 7F       ANDA   #$7F
AD9D: 27 01       BEQ    $ADA0
AD9F: 39          RTS
ADA0: 0F CE       CLR    $CE
ADA2: CC 00 00    LDD    #$0000
ADA5: DD CA       STD    $CA
ADA7: DD CC       STD    $CC
ADA9: 97 C0       STA    $C0
ADAB: BD 92 F7    JSR    $92F7
ADAE: 0D 01       TST    $01
ADB0: 26 0D       BNE    $ADBF
ADB2: 0C 06       INC    $06
ADB4: 0C 07       INC    $07
ADB6: CE 54 80    LDU    #$5480
ADB9: BD A2 25    JSR    $A225
ADBC: 7E B4 B8    JMP    $B4B8
ADBF: 0C 06       INC    $06
ADC1: 0C 07       INC    $07
ADC3: CE 54 A0    LDU    #$54A0
ADC6: BD A2 25    JSR    $A225
ADC9: 7E B4 B8    JMP    $B4B8
ADCC: BD B4 B8    JSR    $B4B8
ADCF: CE B0 11    LDU    #$B011
ADD2: 10 8E 3F 88 LDY    #$3F88
ADD6: C6 FC       LDB    #$FC
ADD8: A6 C0       LDA    ,U+
ADDA: A7 E2       STA    ,-S    ; [local]
ADDC: A6 C0       LDA    ,U+
ADDE: ED A1       STD    ,Y++
ADE0: 6A E4       DEC    ,S    ; [local]
ADE2: 26 F8       BNE    $ADDC
ADE4: A6 E0       LDA    ,S+    ; [local]
ADE6: C6 FC       LDB    #$FC
ADE8: B6 41 89    LDA    $4189
ADEB: 26 02       BNE    $ADEF
ADED: 86 FF       LDA    #$FF
ADEF: FD 3F 96    STD    $3F96
ADF2: B6 41 8A    LDA    $418A
ADF5: FD 3F 98    STD    $3F98
ADF8: 10 8E 3F A2 LDY    #$3FA2
ADFC: 86 FF       LDA    #$FF
ADFE: F6 B1 1E    LDB    $B11E
AE01: A7 A1       STA    ,Y++
AE03: 5A          DECB
AE04: 26 FB       BNE    $AE01
AE06: 10 8E 3F BE LDY    #$3FBE
AE0A: 86 FF       LDA    #$FF
AE0C: F6 B1 5C    LDB    $B15C
AE0F: A7 A1       STA    ,Y++
AE11: 5A          DECB
AE12: 26 FB       BNE    $AE0F
AE14: 0C 06       INC    $06
AE16: 7E D6 36    JMP    $D636
AE19: 0F D2       CLR    $D2
AE1B: CC 00 00    LDD    #$0000
AE1E: DD 88       STD    $88
AE20: DD 8A       STD    $8A
AE22: BD D8 36    JSR    $D836
AE25: 0C D2       INC    $D2
AE27: 96 D2       LDA    $D2
AE29: 81 02       CMPA   #$02
AE2B: 26 FA       BNE    $AE27
AE2D: C6 FC       LDB    #$FC
AE2F: B6 41 89    LDA    $4189
AE32: 26 02       BNE    $AE36
AE34: 86 FF       LDA    #$FF
AE36: FD 3F 96    STD    $3F96
AE39: B6 41 8A    LDA    $418A
AE3C: FD 3F 98    STD    $3F98
AE3F: 7D 43 80    TST    $4380
AE42: 27 01       BEQ    $AE45
AE44: 39          RTS
AE45: 0C 06       INC    $06
AE47: 0C 07       INC    $07
AE49: 39          RTS
AE4A: C6 FC       LDB    #$FC
AE4C: B6 41 89    LDA    $4189
AE4F: 26 02       BNE    $AE53
AE51: 86 FF       LDA    #$FF
AE53: FD 3F 96    STD    $3F96
AE56: B6 41 8A    LDA    $418A
AE59: FD 3F 98    STD    $3F98
AE5C: 0C 06       INC    $06
AE5E: 0C 07       INC    $07
AE60: BD B4 B8    JSR    $B4B8
AE63: 7E 84 8C    JMP    $848C
AE66: C6 FC       LDB    #$FC
AE68: B6 41 89    LDA    $4189
AE6B: 26 02       BNE    $AE6F
AE6D: 86 FF       LDA    #$FF
AE6F: FD 3F 96    STD    $3F96
AE72: B6 41 8A    LDA    $418A
AE75: FD 3F 98    STD    $3F98
AE78: BD 96 30    JSR    $9630
AE7B: B6 54 31    LDA    $5431
AE7E: 27 01       BEQ    $AE81
AE80: 39          RTS
AE81: 0F E8       CLR    $E8
AE83: 0C 06       INC    $06
AE85: 0C 07       INC    $07
AE87: 39          RTS
AE88: 0F 1F       CLR    $1F
AE8A: BD B4 B8    JSR    $B4B8
AE8D: BD 84 23    JSR    $8423
AE90: 86 FF       LDA    #$FF
AE92: 97 D8       STA    $D8
AE94: 7D 41 8E    TST    $418E
AE97: 27 3D       BEQ    $AED6
AE99: 0D 01       TST    $01
AE9B: 26 31       BNE    $AECE
AE9D: 7F 54 80    CLR    $5480
AEA0: 7D 54 A0    TST    $54A0
AEA3: 27 31       BEQ    $AED6
AEA5: 96 01       LDA    $01
AEA7: 88 01       EORA   #$01
AEA9: 97 01       STA    $01
AEAB: CE AE E3    LDU    #$AEE3
AEAE: B6 42 51    LDA    $4251
AEB1: 48          ASLA
AEB2: EC C6       LDD    A,U
AEB4: DD 11       STD    $11
AEB6: CC 00 00    LDD    #$0000
AEB9: FD 54 5C    STD    $545C
AEBC: FD 54 5E    STD    $545E
AEBF: 97 14       STA    $14
AEC1: 97 15       STA    $15
AEC3: 86 01       LDA    #$01
AEC5: 97 04       STA    $04
AEC7: 97 05       STA    $05
AEC9: 0F 06       CLR    $06
AECB: 0F 07       CLR    $07
AECD: 39          RTS
AECE: 7F 54 A0    CLR    $54A0
AED1: 7D 54 80    TST    $5480
AED4: 26 CF       BNE    $AEA5
AED6: 0F 01       CLR    $01
AED8: 0F DB       CLR    $DB
AEDA: 0F D8       CLR    $D8
AEDC: 0F D9       CLR    $D9
AEDE: 0C 06       INC    $06
AEE0: 0C 07       INC    $07
AEE2: 39          RTS
AEE3: 01 20       NEG    $20
AEE5: 01 50       NEG    $50
AEE7: 7F 41 8C    CLR    $418C
AEEA: BD 83 CB    JSR    $83CB
AEED: 7D 41 A5    TST    $41A5
AEF0: 27 13       BEQ    $AF05
AEF2: 86 01       LDA    #$01
AEF4: 97 D1       STA    $D1
AEF6: 86 05       LDA    #$05
AEF8: 97 02       STA    $02
AEFA: 0F 04       CLR    $04
AEFC: 0F 06       CLR    $06
AEFE: 97 03       STA    $03
AF00: 0F 05       CLR    $05
AF02: 0F 07       CLR    $07
AF04: 39          RTS
AF05: 0F D1       CLR    $D1
AF07: 86 02       LDA    #$02
AF09: 97 02       STA    $02
AF0B: 0F 04       CLR    $04
AF0D: 0F 06       CLR    $06
AF0F: 97 03       STA    $03
AF11: 0F 05       CLR    $05
AF13: 0F 07       CLR    $07
AF15: 39          RTS
AF16: 7D 42 43    TST    $4243
AF19: 27 0A       BEQ    $AF25
AF1B: 96 02       LDA    $02
AF1D: 81 03       CMPA   #$03
AF1F: 27 28       BEQ    $AF49
AF21: 81 04       CMPA   #$04
AF23: 27 24       BEQ    $AF49
AF25: CE 42 85    LDU    #$4285
AF28: 8E 53 40    LDX    #$5340
AF2B: 96 E1       LDA    $E1
AF2D: 91 E0       CMPA   $E0
AF2F: 27 19       BEQ    $AF4A
AF31: E6 86       LDB    A,X
AF33: 2B 09       BMI    $AF3E
AF35: E7 C5       STB    B,U
AF37: 4C          INCA
AF38: 84 1F       ANDA   #$1F
AF3A: 97 E1       STA    $E1
AF3C: 20 EF       BRA    $AF2D
AF3E: C4 7F       ANDB   #$7F
AF40: 6F C5       CLR    B,U
AF42: 4C          INCA
AF43: 84 1F       ANDA   #$1F
AF45: 97 E1       STA    $E1
AF47: 20 E4       BRA    $AF2D
AF49: 39          RTS
AF4A: 8E 53 60    LDX    #$5360
AF4D: 96 E5       LDA    $E5
AF4F: 91 E4       CMPA   $E4
AF51: 26 01       BNE    $AF54
AF53: 39          RTS
AF54: E6 86       LDB    A,X
AF56: 2B 09       BMI    $AF61
AF58: E7 C5       STB    B,U
AF5A: 4C          INCA
AF5B: 84 1F       ANDA   #$1F
AF5D: 97 E5       STA    $E5
AF5F: 20 EE       BRA    $AF4F
AF61: C4 7F       ANDB   #$7F
AF63: 6F C5       CLR    B,U
AF65: 4C          INCA
AF66: 84 1F       ANDA   #$1F
AF68: 97 E5       STA    $E5
AF6A: 20 E3       BRA    $AF4F
AF6C: 7D 42 43    TST    $4243
AF6F: 27 0A       BEQ    $AF7B
AF71: 96 02       LDA    $02
AF73: 81 03       CMPA   #$03
AF75: 27 2A       BEQ    $AFA1
AF77: 81 04       CMPA   #$04
AF79: 27 26       BEQ    $AFA1
AF7B: 8E 53 80    LDX    #$5380
AF7E: 96 E3       LDA    $E3
AF80: 91 E2       CMPA   $E2
AF82: 27 1E       BEQ    $AFA2
AF84: E6 86       LDB    A,X
AF86: 4C          INCA
AF87: 84 1F       ANDA   #$1F
AF89: 97 E3       STA    $E3
AF8B: C5 20       BITB   #$20
AF8D: 27 0A       BEQ    $AF99
AF8F: C4 DF       ANDB   #$DF
AF91: F7 66 00    STB    $6600
AF94: B7 64 00    STA    $6400
AF97: 20 E7       BRA    $AF80
AF99: F7 62 00    STB    $6200
AF9C: B7 60 00    STA    $6000
AF9F: 20 DF       BRA    $AF80
AFA1: 39          RTS
AFA2: 8E 53 A0    LDX    #$53A0
AFA5: 96 E7       LDA    $E7
AFA7: 91 E6       CMPA   $E6
AFA9: 26 01       BNE    $AFAC
AFAB: 39          RTS
AFAC: E6 86       LDB    A,X
AFAE: 4C          INCA
AFAF: 84 1F       ANDA   #$1F
AFB1: 97 E7       STA    $E7
AFB3: C5 20       BITB   #$20
AFB5: 27 0A       BEQ    $AFC1
AFB7: C4 DF       ANDB   #$DF
AFB9: F7 66 00    STB    $6600
AFBC: B7 64 00    STA    $6400
AFBF: 20 E6       BRA    $AFA7
AFC1: F7 62 00    STB    $6200
AFC4: B7 60 00    STA    $6000
AFC7: 20 DE       BRA    $AFA7
AFC9: 96 E8       LDA    $E8
AFCB: 91 E9       CMPA   $E9
AFCD: 26 01       BNE    $AFD0
AFCF: 39          RTS
AFD0: B7 43 80    STA    $4380
AFD3: 97 E9       STA    $E9
AFD5: 39          RTS

B1B9: 10 8E B2 DC LDY    #$B2DC
B1BD: CE B2 E4    LDU    #$B2E4
B1C0: A6 84       LDA    ,X
B1C2: 84 03       ANDA   #$03
B1C4: 48          ASLA
B1C5: 10 AE A6    LDY    A,Y
B1C8: EC C6       LDD    A,U
B1CA: EB 05       ADDB   $5,X
B1CC: DD A9       STD    $A9
B1CE: EC 01       LDD    $1,X
B1D0: 97 AB       STA    $AB
B1D2: A6 28       LDA    $8,Y
B1D4: 3D          MUL
B1D5: 58          ASLB
B1D6: 49          ROLA
B1D7: 8B 20       ADDA   #$20
B1D9: A1 2A       CMPA   $A,Y
B1DB: 25 04       BCS    $B1E1
B1DD: 0C AB       INC    $AB
B1DF: A0 2A       SUBA   $A,Y
B1E1: 8B 07       ADDA   #$07
B1E3: A1 2A       CMPA   $A,Y
B1E5: 25 04       BCS    $B1EB
B1E7: 0C AB       INC    $AB
B1E9: A0 2A       SUBA   $A,Y
B1EB: 97 AD       STA    $AD
B1ED: 8D 48       BSR    $B237
B1EF: A6 84       LDA    ,X
B1F1: 85 03       BITA   #$03
B1F3: 27 04       BEQ    $B1F9
B1F5: 6A 84       DEC    ,X
B1F7: 20 C0       BRA    $B1B9
B1F9: 6F 84       CLR    ,X
B1FB: 0C B4       INC    $B4
B1FD: 39          RTS
B1FE: 10 8E B2 DC LDY    #$B2DC
B202: CE B2 E4    LDU    #$B2E4
B205: A6 84       LDA    ,X
B207: 84 03       ANDA   #$03
B209: 48          ASLA
B20A: 10 AE A6    LDY    A,Y
B20D: EC C6       LDD    A,U
B20F: EB 05       ADDB   $5,X
B211: DD A9       STD    $A9
B213: EC 01       LDD    $1,X
B215: 97 AB       STA    $AB
B217: A6 28       LDA    $8,Y
B219: 3D          MUL
B21A: 58          ASLB
B21B: 49          ROLA
B21C: 80 04       SUBA   #$04
B21E: 2A 04       BPL    $B224
B220: 0A AB       DEC    $AB
B222: AB 2A       ADDA   $A,Y
B224: 97 AD       STA    $AD
B226: 8D 0F       BSR    $B237
B228: A6 84       LDA    ,X
B22A: 85 03       BITA   #$03
B22C: 27 04       BEQ    $B232
B22E: 6A 84       DEC    ,X
B230: 20 CC       BRA    $B1FE
B232: 6F 84       CLR    ,X
B234: 0C B4       INC    $B4
B236: 39          RTS

B237: EC 06       LDD    $6,X
B239: ED E3       STD    ,--S    ; [local]
B23B: EC 03       LDD    $3,X
B23D: 97 AC       STA    $AC
B23F: A6 29       LDA    $9,Y
B241: 3D          MUL
B242: 58          ASLB
B243: 49          ROLA
B244: 80 02       SUBA   #$02
B246: 2A 04       BPL    $B24C
B248: 0A AC       DEC    $AC
B24A: AB 2B       ADDA   $B,Y
B24C: A7 E2       STA    ,-S    ; [local]
B24E: A6 2B       LDA    $B,Y
B250: 4A          DECA
B251: A0 E0       SUBA   ,S+    ; [local]
B253: 97 AE       STA    $AE
B255: 86 20       LDA    #$20
B257: 97 B1       STA    $B1
B259: BD B4 D7    JSR    $B4D7
B25C: 26 55       BNE    $B2B3
B25E: BD B4 EC    JSR    $B4EC
B261: 26 50       BNE    $B2B3
B263: BD B5 1D    JSR    $B51D
B266: BD B5 31    JSR    $B531
B269: BD B5 6D    JSR    $B56D
B26C: DE A6       LDU    $A6
B26E: 96 A8       LDA    $A8
B270: EC C6       LDD    A,U
B272: ED E3       STD    ,--S    ; [local]
B274: DE A9       LDU    $A9
B276: EC 06       LDD    $6,X
B278: 83 00 80    SUBD   #$0080
B27B: 84 0F       ANDA   #$0F
B27D: ED 06       STD    $6,X
B27F: 33 CB       LEAU   D,U
B281: EC E1       LDD    ,S++    ; [local]
B283: ED C4       STD    ,U
B285: 0A B1       DEC    $B1
B287: 27 25       BEQ    $B2AE
B289: 96 AE       LDA    $AE
B28B: 0A AE       DEC    $AE
B28D: 2B 16       BMI    $B2A5
B28F: 85 03       BITA   #$03
B291: 27 08       BEQ    $B29B
B293: 96 A8       LDA    $A8
B295: 80 08       SUBA   #$08
B297: 97 A8       STA    $A8
B299: 20 D1       BRA    $B26C
B29B: E6 28       LDB    $8,Y
B29D: 50          NEGB
B29E: 1D          SEX
B29F: D3 A4       ADDD   $A4
B2A1: DD A4       STD    $A4
B2A3: 20 C1       BRA    $B266
B2A5: 0C AC       INC    $AC
B2A7: A6 2B       LDA    $B,Y
B2A9: 4A          DECA
B2AA: 97 AE       STA    $AE
B2AC: 20 AB       BRA    $B259
B2AE: EC E1       LDD    ,S++    ; [local]
B2B0: ED 06       STD    $6,X
B2B2: 39          RTS
B2B3: DE A9       LDU    $A9
B2B5: EC 06       LDD    $6,X
B2B7: 83 00 80    SUBD   #$0080
B2BA: 84 0F       ANDA   #$0F
B2BC: ED 06       STD    $6,X
B2BE: 33 CB       LEAU   D,U
B2C0: CC FF 03    LDD    #$FF03
B2C3: ED C4       STD    ,U
B2C5: 0A B1       DEC    $B1
B2C7: 27 0E       BEQ    $B2D7
B2C9: 0A AE       DEC    $AE
B2CB: 2A E6       BPL    $B2B3
B2CD: 0C AC       INC    $AC
B2CF: A6 2B       LDA    $B,Y
B2D1: 4A          DECA
B2D2: 97 AE       STA    $AE
B2D4: 7E B2 59    JMP    $B259
B2D7: EC E1       LDD    ,S++    ; [local]
B2D9: ED 06       STD    $6,X
B2DB: 39          RTS

B2EC: 10 8E B2 DC LDY    #$B2DC
B2F0: CE B2 E4    LDU    #$B2E4
B2F3: A6 84       LDA    ,X
B2F5: 84 03       ANDA   #$03
B2F7: 48          ASLA
B2F8: 10 AE A6    LDY    A,Y
B2FB: EC C6       LDD    A,U
B2FD: E3 06       ADDD   $6,X
B2FF: DD A9       STD    $A9
B301: EC 03       LDD    $3,X
B303: 97 AC       STA    $AC
B305: A6 29       LDA    $9,Y
B307: 3D          MUL
B308: 58          ASLB
B309: 49          ROLA
B30A: 8B 1D       ADDA   #$1D
B30C: A1 2B       CMPA   $B,Y
B30E: 25 04       BCS    $B314
B310: 0C AC       INC    $AC
B312: A0 2B       SUBA   $B,Y
B314: A7 E2       STA    ,-S    ; [local]
B316: A6 2B       LDA    $B,Y
B318: 4A          DECA
B319: A0 E0       SUBA   ,S+    ; [local]
B31B: 97 AE       STA    $AE
B31D: 8D 4F       BSR    $B36E
B31F: A6 84       LDA    ,X
B321: 85 03       BITA   #$03
B323: 27 04       BEQ    $B329
B325: 6A 84       DEC    ,X
B327: 20 C3       BRA    $B2EC
B329: 6F 84       CLR    ,X
B32B: 0C B4       INC    $B4
B32D: 39          RTS
B32E: 10 8E B2 DC LDY    #$B2DC
B332: CE B2 E4    LDU    #$B2E4
B335: A6 84       LDA    ,X
B337: 84 03       ANDA   #$03
B339: 48          ASLA
B33A: 10 AE A6    LDY    A,Y
B33D: EC C6       LDD    A,U
B33F: E3 06       ADDD   $6,X
B341: DD A9       STD    $A9
B343: EC 03       LDD    $3,X
B345: 97 AC       STA    $AC
B347: A6 29       LDA    $9,Y
B349: 3D          MUL
B34A: 58          ASLB
B34B: 49          ROLA
B34C: 80 02       SUBA   #$02
B34E: 2A 04       BPL    $B354
B350: 0A AC       DEC    $AC
B352: AB 2B       ADDA   $B,Y
B354: A7 E2       STA    ,-S    ; [local]
B356: A6 2B       LDA    $B,Y
B358: 4A          DECA
B359: A0 E0       SUBA   ,S+    ; [local]
B35B: 97 AE       STA    $AE
B35D: 8D 0F       BSR    $B36E
B35F: A6 84       LDA    ,X
B361: 85 03       BITA   #$03
B363: 27 04       BEQ    $B369
B365: 6A 84       DEC    ,X
B367: 20 C5       BRA    $B32E
B369: 6F 84       CLR    ,X
B36B: 0C B4       INC    $B4
B36D: 39          RTS
B36E: A6 05       LDA    $5,X
B370: A7 E2       STA    ,-S    ; [local]
B372: EC 01       LDD    $1,X
B374: 97 AB       STA    $AB
B376: A6 28       LDA    $8,Y
B378: 3D          MUL
B379: 58          ASLB
B37A: 49          ROLA
B37B: 80 04       SUBA   #$04
B37D: 2A 04       BPL    $B383
B37F: 0A AB       DEC    $AB
B381: AB 2A       ADDA   $A,Y
B383: 97 AD       STA    $AD
B385: 86 2C       LDA    #$2C
B387: 97 B2       STA    $B2
B389: BD B4 D7    JSR    $B4D7
B38C: 26 54       BNE    $B3E2
B38E: BD B4 EC    JSR    $B4EC
B391: 26 4F       BNE    $B3E2
B393: BD B5 1D    JSR    $B51D
B396: BD B5 31    JSR    $B531
B399: BD B5 6D    JSR    $B56D
B39C: DE A6       LDU    $A6
B39E: 96 A8       LDA    $A8
B3A0: EC C6       LDD    A,U
B3A2: ED E3       STD    ,--S    ; [local]
B3A4: DE A9       LDU    $A9
B3A6: A6 05       LDA    $5,X
B3A8: 33 C6       LEAU   A,U
B3AA: EC E1       LDD    ,S++    ; [local]
B3AC: ED C4       STD    ,U
B3AE: 0A B2       DEC    $B2
B3B0: 27 2B       BEQ    $B3DD
B3B2: A6 05       LDA    $5,X
B3B4: 8B 02       ADDA   #$02
B3B6: 84 7F       ANDA   #$7F
B3B8: A7 05       STA    $5,X
B3BA: 0C AD       INC    $AD
B3BC: 96 AD       LDA    $AD
B3BE: 85 03       BITA   #$03
B3C0: 27 08       BEQ    $B3CA
B3C2: 96 A8       LDA    $A8
B3C4: 8B 02       ADDA   #$02
B3C6: 97 A8       STA    $A8
B3C8: 20 D2       BRA    $B39C
B3CA: A1 2A       CMPA   $A,Y
B3CC: 24 09       BCC    $B3D7
B3CE: DC A4       LDD    $A4
B3D0: C3 00 02    ADDD   #$0002
B3D3: DD A4       STD    $A4
B3D5: 20 BF       BRA    $B396
B3D7: 0C AB       INC    $AB
B3D9: 0F AD       CLR    $AD
B3DB: 20 AC       BRA    $B389
B3DD: A6 E0       LDA    ,S+    ; [local]
B3DF: A7 05       STA    $5,X
B3E1: 39          RTS
B3E2: DE A9       LDU    $A9
B3E4: A6 05       LDA    $5,X
B3E6: 33 C6       LEAU   A,U
B3E8: CC FF 03    LDD    #$FF03
B3EB: ED C4       STD    ,U
B3ED: 0A B2       DEC    $B2
B3EF: 27 17       BEQ    $B408
B3F1: A6 05       LDA    $5,X
B3F3: 8B 02       ADDA   #$02
B3F5: 84 7F       ANDA   #$7F
B3F7: A7 05       STA    $5,X
B3F9: 0C AD       INC    $AD
B3FB: 96 AD       LDA    $AD
B3FD: A1 2A       CMPA   $A,Y
B3FF: 25 E1       BCS    $B3E2
B401: 0C AB       INC    $AB
B403: 0F AD       CLR    $AD
B405: 7E B3 89    JMP    $B389
B408: A6 E0       LDA    ,S+    ; [local]
B40A: A7 05       STA    $5,X
B40C: 39          RTS
B40D: D6 B4       LDB    $B4
B40F: D1 B3       CMPB   $B3
B411: 26 01       BNE    $B414
B413: 39          RTS
B414: 8E 55 00    LDX    #$5500
B417: 58          ASLB
B418: 58          ASLB
B419: 58          ASLB
B41A: 3A          ABX
B41B: CE B4 27    LDU    #jump_table_b427
B41E: A6 84       LDA    ,X
B420: 2B 0F       BMI    $B431
B422: 84 1C       ANDA   #$1C
B424: 44          LSRA
B425: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=5]

B431: 0C B4       INC    $B4
B433: 39          RTS

B434: 86 18       LDA    #$18
B436: B7 68 00    STA    bankswitch_6800
B439: CE 63 B3    LDU    #$63B3
B43C: EC C1       LDD    ,U++
B43E: DD 78       STD    $78
B440: A6 C0       LDA    ,U+
B442: 26 05       BNE    $B449
B444: B7 88 00    STA    $8800
B447: 20 03       BRA    $B44C
B449: B7 8C 00    STA    $8C00
B44C: EC C1       LDD    ,U++
B44E: DD 7A       STD    $7A
B450: EC C1       LDD    ,U++
B452: DD 7C       STD    $7C
B454: EC C1       LDD    ,U++
B456: DD 7E       STD    $7E
B458: 8E 53 C0    LDX    #$53C0
B45B: CC 10 10    LDD    #$1010
B45E: ED 08       STD    $8,X
B460: CC 20 20    LDD    #$2020
B463: ED 0A       STD    $A,X
B465: 8E 53 D0    LDX    #$53D0
B468: EC C1       LDD    ,U++
B46A: ED 08       STD    $8,X
B46C: 48          ASLA
B46D: 58          ASLB
B46E: ED 0A       STD    $A,X
B470: 8E 53 E0    LDX    #$53E0
B473: EC C1       LDD    ,U++
B475: ED 08       STD    $8,X
B477: 48          ASLA
B478: 58          ASLB
B479: ED 0A       STD    $A,X
B47B: DF 74       STU    $74
B47D: DC 7A       LDD    $7A
B47F: DD C6       STD    $C6
B481: DD C8       STD    $C8
B483: 0D CF       TST    $CF
B485: 26 08       BNE    $B48F
B487: DC 7A       LDD    $7A
B489: DD C6       STD    $C6
B48B: DD C8       STD    $C8
B48D: 20 06       BRA    $B495
B48F: DC 7C       LDD    $7C
B491: DD C6       STD    $C6
B493: DD C8       STD    $C8
B495: 96 C6       LDA    $C6
B497: 5F          CLRB
B498: DD 80       STD    $80
B49A: 96 C7       LDA    $C7
B49C: C6 08       LDB    #$08
B49E: DD 82       STD    $82
B4A0: 8E 55 00    LDX    #$5500
B4A3: 10 8E 53 E0 LDY    #$53E0
B4A7: 86 02       LDA    #$02
B4A9: A7 84       STA    ,X
B4AB: BD A5 C7    JSR    $A5C7
B4AE: 10 8E 53 C0 LDY    #$53C0
B4B2: 4F          CLRA
B4B3: A7 84       STA    ,X
B4B5: 7E A5 C7    JMP    $A5C7
B4B8: 8E 34 10    LDX    #$3410
B4BB: 32 7E       LEAS   -$2,S	; [alloc_locals]
B4BD: 86 0C       LDA    #$0C
B4BF: A7 61       STA    $1,S	; [local]
B4C1: 86 1C       LDA    #$1C
B4C3: A7 E4       STA    ,S		; [local]
B4C5: CC FF 00    LDD    #$FF00
B4C8: ED 81       STD    ,X++
B4CA: 6A E4       DEC    ,S    ; [local]
B4CC: 26 FA       BNE    $B4C8
B4CE: 30 88 48    LEAX   $48,X
B4D1: 6A 61       DEC    $1,S		; [local]
B4D3: 26 EC       BNE    $B4C1
B4D5: 35 86       PULS   D,PC		; [manual_stack_pull]

B4D7: 96 AB       LDA    $AB
B4D9: 2B 0E       BMI    $B4E9
B4DB: 91 78       CMPA   $78
B4DD: 24 0A       BCC    $B4E9
B4DF: 96 AC       LDA    $AC
B4E1: 2B 06       BMI    $B4E9
B4E3: 91 79       CMPA   $79
B4E5: 24 02       BCC    $B4E9
B4E7: 4F          CLRA
B4E8: 39          RTS
B4E9: 86 01       LDA    #$01
B4EB: 39          RTS
B4EC: DE 74       LDU    $74
B4EE: 86 18       LDA    #$18
B4F0: 97 19       STA    bankswitch_shadow_19
B4F2: B7 68 00    STA    bankswitch_6800
B4F5: 96 AB       LDA    $AB
B4F7: 48          ASLA
B4F8: A7 E2       STA    ,-S    ; [local]
B4FA: DC 78       LDD    $78
B4FC: 5A          DECB
B4FD: D0 AC       SUBB   $AC
B4FF: 48          ASLA
B500: 3D          MUL
B501: EB E0       ADDB   ,S+    ; [local]
B503: EE CB       LDU    D,U
B505: A6 C0       LDA    ,U+
B507: 27 E0       BEQ    $B4E9
B509: A7 E2       STA    ,-S    ; [local]
B50B: A6 84       LDA    ,X
B50D: 84 03       ANDA   #$03
B50F: A1 E0       CMPA   ,S+	; [local]
B511: 24 07       BCC    $B51A
B513: 48          ASLA
B514: EC C6       LDD    A,U
B516: DD A2       STD    $A2
B518: 4F          CLRA
B519: 39          RTS
B51A: 86 02       LDA    #$02
B51C: 39          RTS
B51D: 96 AE       LDA    $AE
B51F: 44          LSRA
B520: 44          LSRA
B521: E6 28       LDB    $8,Y
B523: 3D          MUL
B524: DD A4       STD    $A4
B526: D6 AD       LDB    $AD
B528: C4 3C       ANDB   #$3C
B52A: 54          LSRB
B52B: 4F          CLRA
B52C: D3 A4       ADDD   $A4
B52E: DD A4       STD    $A4
B530: 39          RTS
B531: CE 60 00    LDU    #$6000
B534: DC A2       LDD    $A2
B536: D3 A4       ADDD   $A4
B538: ED E3       STD    ,--S		; [local]
B53A: 1F 89       TFR    A,B
B53C: A6 84       LDA    ,X
B53E: 84 03       ANDA   #$03
B540: 58          ASLB
B541: 49          ROLA
B542: 58          ASLB
B543: 49          ROLA
B544: 58          ASLB
B545: 49          ROLA
B546: 97 19       STA    bankswitch_shadow_19
B548: B7 68 00    STA    bankswitch_6800
B54B: EC E1       LDD    ,S++		; [local]
B54D: 84 1F       ANDA   #$1F
B54F: EC CB       LDD    D,U
B551: ED E3       STD    ,--S	; [local]
B553: 1F 89       TFR    A,B
B555: A6 84       LDA    ,X
B557: 84 03       ANDA   #$03
B559: 58          ASLB
B55A: 49          ROLA
B55B: 58          ASLB
B55C: 49          ROLA
B55D: 58          ASLB
B55E: 49          ROLA
B55F: 97 19       STA    bankswitch_shadow_19
B561: B7 68 00    STA    bankswitch_6800
B564: EC E1       LDD    ,S++		; [local]
B566: 84 1F       ANDA   #$1F
B568: 8A 60       ORA    #$60
B56A: DD A6       STD    $A6
B56C: 39          RTS
B56D: D6 AD       LDB    $AD
B56F: C4 03       ANDB   #$03
B571: 58          ASLB
B572: E7 E2       STB    ,-S	; [local]
B574: D6 AE       LDB    $AE
B576: C4 03       ANDB   #$03
B578: 58          ASLB
B579: 58          ASLB
B57A: 58          ASLB
B57B: EB E0       ADDB   ,S+	; [local]
B57D: D7 A8       STB    $A8
B57F: 39          RTS

B580: A6 84       LDA    ,X
B582: 81 FF       CMPA   #$FF
B584: 27 09       BEQ    $B58F
B586: 30 88 20    LEAX   $20,X
B589: 8C 49 00    CMPX   #$4900
B58C: 26 F2       BNE    $B580
B58E: 39          RTS
B58F: EC A1       LDD    ,Y++
B591: 8A 80       ORA    #$80
B593: A7 84       STA    ,X
B595: E7 07       STB    $7,X
B597: EC A1       LDD    ,Y++
B599: ED 02       STD    $2,X
B59B: A6 A0       LDA    ,Y+
B59D: A7 05       STA    $5,X
B59F: 86 80       LDA    #$80
B5A1: A7 01       STA    $1,X
B5A3: 6F 0C       CLR    $C,X
B5A5: 6F 09       CLR    $9,X
B5A7: 6F 0D       CLR    $D,X
B5A9: 6F 0E       CLR    $E,X
B5AB: 0C 30       INC    $30
B5AD: 39          RTS
B5AE: 6F 09       CLR    $9,X
B5B0: CE B6 10    LDU    #$B610
B5B3: A6 84       LDA    ,X
B5B5: 80 20       SUBA   #$20
B5B7: 84 7C       ANDA   #$7C
B5B9: 44          LSRA
B5BA: EE C6       LDU    A,U
B5BC: E6 07       LDB    $7,X
B5BE: E7 01       STB    $1,X
B5C0: C4 FC       ANDB   #$FC
B5C2: 54          LSRB
B5C3: EE C5       LDU    B,U
B5C5: EC C1       LDD    ,U++
B5C7: A7 0A       STA    $A,X
B5C9: E7 0B       STB    $B,X
B5CB: EC C4       LDD    ,U
B5CD: ED 1E       STD    -$2,X
B5CF: 39          RTS
B5D0: A6 84       LDA    ,X
B5D2: 81 FF       CMPA   #$FF
B5D4: 27 05       BEQ    $B5DB
B5D6: 30 88 20    LEAX   $20,X
B5D9: 20 F5       BRA    $B5D0
B5DB: EC C1       LDD    ,U++
B5DD: 8A 80       ORA    #$80
B5DF: A7 84       STA    ,X
B5E1: E7 07       STB    $7,X
B5E3: 86 80       LDA    #$80
B5E5: A7 01       STA    $1,X
B5E7: EC C1       LDD    ,U++
B5E9: ED 02       STD    $2,X
B5EB: A6 C0       LDA    ,U+
B5ED: A7 05       STA    $5,X
B5EF: 6F 0D       CLR    $D,X
B5F1: 6F 0E       CLR    $E,X
B5F3: 6F 09       CLR    $9,X
B5F5: 10 AF 10    STY    -$10,X
B5F8: AF 28       STX    $8,Y
B5FA: 0C 30       INC    $30
B5FC: 39          RTS
B5FD: 6C 09       INC    $9,X
B5FF: E6 09       LDB    $9,X
B601: 58          ASLB
B602: 58          ASLB
B603: 33 C5       LEAU   B,U
B605: EC C1       LDD    ,U++
B607: A7 0A       STA    $A,X
B609: E7 0B       STB    $B,X
B60B: EC C4       LDD    ,U
B60D: ED 1E       STD    -$2,X
B60F: 39          RTS

B618: 96 36       LDA    $36
B61A: 26 05       BNE    $B621
B61C: 97 32       STA    $32
B61E: 97 38       STA    $38
B620: 39          RTS

B621: 8E 44 30    LDX    #$4430
B624: 97 3A       STA    $3A
B626: 0F 32       CLR    $32
B628: 0F 38       CLR    $38
B62A: A6 84       LDA    ,X
B62C: 81 FF       CMPA   #$FF
B62E: 27 2F       BEQ    $B65F
B630: 84 7F       ANDA   #$7F
B632: 81 20       CMPA   #$20
B634: 25 29       BCS    $B65F
B636: 81 30       CMPA   #$30
B638: 24 32       BCC    $B66C
B63A: 8D 32       BSR    $B66E
B63C: A6 84       LDA    ,X
B63E: 2B 1A       BMI    $B65A
B640: BD BC DA    JSR    $BCDA
B643: CE B6 64    LDU    #table_of_jump_tables_b664
B646: A6 84       LDA    ,X
B648: 80 20       SUBA   #$20
B64A: 84 7C       ANDA   #$7C
B64C: 44          LSRA
B64D: EE C6       LDU    A,U
B64F: E6 01       LDB    $1,X
B651: C1 C0       CMPB   #$C0
B653: 24 05       BCC    $B65A		; [breakpoint]
B655: C4 FC       ANDB   #$FC
B657: 54          LSRB
B658: AD D5       JSR    [B,U]        ; [indirect_jump] [nb_entries=2]
B65A: 0A 3A       DEC    $3A
B65C: 26 01       BNE    $B65F
B65E: 39          RTS
B65F: 30 88 20    LEAX   $20,X
B662: 20 C6       BRA    $B62A

table_of_jump_tables_b664:
	dc.w	jump_table_b6e6	; $b664
	dc.w	jump_table_b750	; $b666
	dc.w	jump_table_b7ba	; $b668


B66C: 20 FE       BRA    $B66C
B66E: DC 8A       LDD    $8A
B670: E3 1C       ADDD   -$4,X
B672: ED 1C       STD    -$4,X
B674: DC 88       LDD    $88
B676: E3 1A       ADDD   -$6,X
B678: ED 1A       STD    -$6,X
B67A: A6 01       LDA    $1,X
B67C: 84 FC       ANDA   #$FC
B67E: 81 80       CMPA   #$80
B680: 27 37       BEQ    $B6B9
B682: EC 1C       LDD    -$4,X
B684: 10 83 FC 00 CMPD   #$FC00
B688: 2D 28       BLT    $B6B2
B68A: 10 83 10 00 CMPD   #$1000
B68E: 2C 22       BGE    $B6B2
B690: EC 1A       LDD    -$6,X
B692: 10 83 15 00 CMPD   #$1500
B696: 2E 1A       BGT    $B6B2
B698: 10 83 FD 00 CMPD   #$FD00
B69C: 2D 14       BLT    $B6B2
B69E: 0C 32       INC    $32
B6A0: 0C 38       INC    $38
B6A2: A6 84       LDA    ,X
B6A4: 84 7F       ANDA   #$7F
B6A6: A7 84       STA    ,X
B6A8: E6 07       LDB    $7,X
B6AA: E1 01       CMPB   $1,X
B6AC: 26 01       BNE    $B6AF
B6AE: 39          RTS
B6AF: 7E B8 8E    JMP    $B88E
B6B2: A6 84       LDA    ,X
B6B4: 8A 80       ORA    #$80
B6B6: A7 84       STA    ,X
B6B8: 39          RTS
B6B9: EC 1C       LDD    -$4,X
B6BB: 10 83 FC 00 CMPD   #$FC00
B6BF: 2C 01       BGE    $B6C2
B6C1: 39          RTS
B6C2: 10 83 10 00 CMPD   #$1000
B6C6: 2D 01       BLT    $B6C9
B6C8: 39          RTS
B6C9: A6 07       LDA    $7,X
B6CB: 85 02       BITA   #$02
B6CD: 26 09       BNE    $B6D8
B6CF: EC 1A       LDD    -$6,X
B6D1: 10 83 FD 00 CMPD   #$FD00
B6D5: 2D 0A       BLT    $B6E1
B6D7: 39          RTS
B6D8: EC 1A       LDD    -$6,X
B6DA: 10 83 15 00 CMPD   #$1500
B6DE: 2C 01       BGE    $B6E1
B6E0: 39          RTS
B6E1: E6 07       LDB    $7,X
B6E3: 7E B8 8E    JMP    $B88E

B88E: E7 07       STB    $7,X
B890: C5 03       BITB   #$03
B892: 26 08       BNE    $B89C
B894: E6 01       LDB    $1,X
B896: C4 03       ANDB   #$03
B898: EB 07       ADDB   $7,X
B89A: E7 07       STB    $7,X
B89C: C1 C0       CMPB   #$C0
B89E: 25 01       BCS    $B8A1
B8A0: 39          RTS

B8A1: C4 FC       ANDB   #$FC
B8A3: 54          LSRB
B8A4: CE B8 B7    LDU    #table_of_jump_tables_b8b7
B8A7: A6 84       LDA    ,X
B8A9: 84 7F       ANDA   #$7F
B8AB: 80 20       SUBA   #$20
B8AD: 2A 01       BPL    $B8B0
B8AF: 39          RTS
B8B0: 84 7C       ANDA   #$7C
B8B2: 44          LSRA
B8B3: EE C6       LDU    A,U   ; [breakpoint] select proper table 0-3 (unreferenced jump_table_b7a6 ??)
B8B5: 6E D5       JMP    [B,U]		; [indirect_jump] [nb_entries=127]

table_of_jump_tables_b8b7:
	.word	jump_table_b8d3 ; $b8b7
	.word	jump_table_b93d ; $b8b9
	.word	jump_table_b9a7 ; $b8bb
	.word	jump_table_ba11 ; $b8bd


jump_table_b8d3:
	.word	$b5ae
	.word	$be6a
	.word	$be6a
	.word	$be6a
	.word	$be6a
	.word	$be6a
	.word	$c1ac
	.word	$c1ac
	.word	$c1ac
	.word	$c1ac
	.word	$bf82
	.word	$c0a5
	.word	$c142
	.word	$b5ae
	.word	$b5ae
	.word	$be6a
	.word	$be6a
	.word	$c1ac
	.word	$b5ae
	.word	$be6a
	.word	$be6a
	.word	$b5ae
	.word	$be6a
	.word	$be6a
	.word	$c271
	.word	$c271
	.word	$c271
	.word	$c271
	.word	$be6a
	.word	$ba7b
	.word	$be6a
	.word	$be6a
	.word	$b5ae
	.word	$be6a
	.word	$be6a
	.word	$be6a
	.word	$be6a
	.word	$c1ac
	.word	$be6a
	.word	$be6a
	.word	$c1ac
	.word	$c1ac
	.word	$be6a
	.word	$be6a
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$c7da
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$cac5
	.word	$c88f
	.word	$c88f
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$ca37
	.word	$c968
	.word	$c968
	.word	$ca37
	.word	$c968
	.word	$c968
	.word	$c850
	.word	$c850
	.word	$c850
	.word	$c850
	.word	$c968
	.word	$c968
	.word	$c88f
	.word	$c88f
	.word	$b5ae
	.word	$cac5
	.word	$cac5
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$cac5
	.word	$c968
	.word	$c968
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$c3d6
	.word	$c2c6
	.word	$c4cc
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c39b
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c563
	.word	$c563
	.word	$c563
	.word	$c760
	.word	$c2c6
	.word	$c2c6
	.word	$c563
	.word	$c563
	.word	$b5ae
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c563
	.word	$c2c6
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cd58
	.word	$cd58
	.word	$ce12
	.word	$cf4a
	.word	$cd58
	.word	$b5ae
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$cd58
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$b5ae
	.word	$ba7b
	.word	$d0db
	.word	$d0db
	.word	$b5ae
	.word	$cd58
	.word	$cd58
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d12b
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
jump_table_b93d:
	.word	$c7da
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$cac5
	.word	$c88f
	.word	$c88f
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$ca37
	.word	$c968
	.word	$c968
	.word	$ca37
	.word	$c968
	.word	$c968
	.word	$c850
	.word	$c850
	.word	$c850
	.word	$c850
	.word	$c968
	.word	$c968
	.word	$c88f
	.word	$c88f
	.word	$b5ae
	.word	$cac5
	.word	$cac5
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$c968
	.word	$c968
	.word	$cac5
	.word	$cac5
	.word	$c968
	.word	$c968
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$c3d6
	.word	$c2c6
	.word	$c4cc
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c39b
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c563
	.word	$c563
	.word	$c563
	.word	$c760
	.word	$c2c6
	.word	$c2c6
	.word	$c563
	.word	$c563
	.word	$b5ae
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c563
	.word	$c2c6
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cd58
	.word	$cd58
	.word	$ce12
	.word	$cf4a
	.word	$cd58
	.word	$b5ae
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$cd58
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$b5ae
	.word	$ba7b
	.word	$d0db
	.word	$d0db
	.word	$b5ae
	.word	$cd58
	.word	$cd58
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d12b
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae

jump_table_b9a7:
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$c3d6
	.word	$c2c6
	.word	$c4cc
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c39b
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c2c6
	.word	$c563
	.word	$c563
	.word	$c563
	.word	$c760
	.word	$c2c6
	.word	$c2c6
	.word	$c563
	.word	$c563
	.word	$b5ae
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$c3a3
	.word	$c563
	.word	$c2c6
	.word	$c3a3
	.word	$c3a3
	.word	$c2c6
	.word	$c2c6
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cd58
	.word	$cd58
	.word	$ce12
	.word	$cf4a
	.word	$cd58
	.word	$b5ae
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$cd58
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$b5ae
	.word	$ba7b
	.word	$d0db
	.word	$d0db
	.word	$b5ae
	.word	$cd58
	.word	$cd58
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d12b
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae

jump_table_ba11:
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cd58
	.word	$cd58
	.word	$ce12
	.word	$cf4a
	.word	$cd58
	.word	$b5ae
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$cd58
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$b5ae
	.word	$cbfb
	.word	$cbfb
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$d1e7
	.word	$b5ae
	.word	$ba7b
	.word	$d0db
	.word	$d0db
	.word	$b5ae
	.word	$cd58
	.word	$cd58
	.word	$cbfb
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d0db
	.word	$d0db
	.word	$cbfb
	.word	$d12b
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae
	.word	$b5ae



jump_table_b7a6:		; [not referenced yet]
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3f6
	.word	$c2e6
	.word	$c501
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a2
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c738
	.word	$c5b2
	.word	$c768
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c5b2
	.word	$b8bf
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c5b2
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cd73
	.word	$cd73
	.word	$ce39
	.word	$cf6d
	.word	$cd73
	.word	$ceec
	.word	$d030
	.word	$cc2c
	.word	$cc2c
	.word	$cd73
	.word	$d08d
	.word	$cc2c
	.word	$cc2c
	.word	$d0c5
	.word	$cc2c
	.word	$cc2c
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d030
	.word	$d030
	.word	$d105
	.word	$d105
	.word	$b8bf
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cc2c
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$d133
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c


B8BF: CE B8 B7    LDU    #table_of_jump_tables_b8b7
B8C2: A6 84       LDA    ,X                                           
B8C4: 80 20       SUBA   #$20
B8C6: 84 7C       ANDA   #$7C
B8C8: 44          LSRA
B8C9: EE C6       LDU    A,U  ; [breakpoint] select proper table
B8CB: E6 07       LDB    $7,X
B8CD: C4 FC       ANDB   #$FC
B8CF: 54          LSRB
B8D0: 6E D5       JMP    [B,U]        ; [indirect_jump] [nb_entries=127]
B8D2: 39          RTS

BA7B: EC 1C       LDD    -$4,X
BA7D: 10 83 07 00 CMPD   #$0700
BA81: 2C 05       BGE    $BA88
BA83: C6 28       LDB    #$28
BA85: 7E B8 8E    JMP    $B88E
BA88: C6 2C       LDB    #$2C
BA8A: 7E B8 8E    JMP    $B88E
BA8D: EC 16       LDD    -$A,X
BA8F: 10 2B 00 99 LBMI   $BB2C
BA93: E3 1A       ADDD   -$6,X
BA95: 10 83 14 00 CMPD   #$1400
BA99: 2C 3A       BGE    $BAD5
BA9B: 32 7D       LEAS   -$3,S		 ; [alloc_locals]
BA9D: ED E4       STD    ,S			; [local]
BA9F: EC 1A       LDD    -$6,X
BAA1: CE 53 E0    LDU    #$53E0
BAA4: C4 70       ANDB   #$70
BAA6: EB 41       ADDB   $1,U
BAA8: C4 70       ANDB   #$70
BAAA: 26 16       BNE    $BAC2
BAAC: 10 8E BC CA LDY    #$BCCA
BAB0: A6 84       LDA    ,X
BAB2: 80 20       SUBA   #$20
BAB4: 84 7C       ANDA   #$7C
BAB6: 44          LSRA
BAB7: EC A6       LDD    A,Y
BAB9: BD BB 6E    JSR    $BB6E
BABC: A7 62       STA    $2,S	; [local]
BABE: C4 01       ANDB   #$01
BAC0: 26 20       BNE    $BAE2
BAC2: EC 1A       LDD    -$6,X
BAC4: C3 00 10    ADDD   #$0010
BAC7: ED 1A       STD    -$6,X
BAC9: 10 A3 E4    CMPD   ,S		; [local]
BACC: 2F D3       BLE    $BAA1
BACE: EC E1       LDD    ,S++	; [local]
BAD0: ED 1A       STD    -$6,X
BAD2: 5F          CLRB
BAD3: 35 82       PULS   A,PC	; [manual_stack_pull]
BAD5: 0A 30       DEC    $30
BAD7: 0A 36       DEC    $36
BAD9: 0A 32       DEC    $32
BADB: 0A 38       DEC    $38
BADD: C6 FF       LDB    #$FF
BADF: E7 84       STB    ,X
BAE1: 39          RTS

BAE2: 32 62       LEAS   $2,S	; [free_locals]
BAE4: E6 1B       LDB    -$5,X
BAE6: C4 F0       ANDB   #$F0
BAE8: E7 1B       STB    -$5,X
BAEA: E6 0C       LDB    $C,X
BAEC: CA 01       ORB    #$01
BAEE: E7 0C       STB    $C,X
BAF0: A6 84       LDA    ,X
BAF2: 84 FC       ANDA   #$FC
BAF4: 81 2C       CMPA   #$2C
BAF6: 27 04       BEQ    $BAFC
BAF8: 81 20       CMPA   #$20
BAFA: 26 0C       BNE    $BB08
BAFC: A6 01       LDA    $1,X
BAFE: 84 FC       ANDA   #$FC
BB00: 81 04       CMPA   #$04
BB02: 27 08       BEQ    $BB0C
BB04: 81 40       CMPA   #$40
BB06: 27 04       BEQ    $BB0C
BB08: C6 48       LDB    #$48
BB0A: 35 82       PULS   A,PC
BB0C: CE BB C1    LDU    #$BBC1
BB0F: C6 08       LDB    #$08
BB11: A6 E0       LDA    ,S+    ; [local]
BB13: A1 C1       CMPA   ,U++
BB15: 27 08       BEQ    $BB1F
BB17: 5A          DECB
BB18: 26 F9       BNE    $BB13
BB1A: C6 24       LDB    #$24
BB1C: 7E B8 8E    JMP    $B88E
BB1F: E6 5F       LDB    -$1,U
BB21: BD B8 8E    JSR    $B88E
BB24: 27 01       BEQ    $BB27
BB26: 39          RTS
BB27: C6 48       LDB    #$48
BB29: 7E B8 8E    JMP    $B88E
BB2C: E3 1A       ADDD   -$6,X
BB2E: 10 83 FE 00 CMPD   #$FE00
BB32: 2D A1       BLT    $BAD5
BB34: 32 7D       LEAS   -$3,S	; [alloc_locals]
BB36: ED E4       STD    ,S		;   [local]
BB38: EC 1A       LDD    -$6,X
BB3A: CE 53 E0    LDU    #$53E0
BB3D: C4 70       ANDB   #$70
BB3F: EB 41       ADDB   $1,U
BB41: C4 70       ANDB   #$70
BB43: 26 16       BNE    $BB5B
BB45: 10 8E BC D2 LDY    #$BCD2
BB49: A6 84       LDA    ,X
BB4B: 80 20       SUBA   #$20
BB4D: 84 7C       ANDA   #$7C
BB4F: 44          LSRA
BB50: EC A6       LDD    A,Y
BB52: BD BB 6E    JSR    $BB6E
BB55: A7 62       STA    $2,S	;   [local]
BB57: C4 01       ANDB   #$01
BB59: 26 87       BNE    $BAE2
BB5B: EC 1A       LDD    -$6,X
BB5D: C3 FF F0    ADDD   #$FFF0
BB60: ED 1A       STD    -$6,X
BB62: 10 A3 E4    CMPD   ,S		;   [local]
BB65: 2C D3       BGE    $BB3A
BB67: EC E1       LDD    ,S++	;   [local]
BB69: ED 1A       STD    -$6,X
BB6B: 5F          CLRB
BB6C: 35 82       PULS   A,PC	; [manual_stack_pull]

BB6E: 8D 20       BSR    $BB90
BB70: CE 20 00    LDU    #$2000
BB73: EC CB       LDD    D,U
BB75: C4 03       ANDB   #$03
BB77: C1 03       CMPB   #$03
BB79: 27 02       BEQ    $BB7D
BB7B: 5F          CLRB
BB7C: 39          RTS
BB7D: CE E7 4A    LDU    #$E74A
BB80: 44          LSRA
BB81: 44          LSRA
BB82: E6 05       LDB    $5,X
BB84: C4 C0       ANDB   #$C0
BB86: 54          LSRB
BB87: 54          LSRB
BB88: 54          LSRB
BB89: 54          LSRB
BB8A: 54          LSRB
BB8B: EE C5       LDU    B,U
BB8D: E6 C6       LDB    A,U
BB8F: 39          RTS

BB90: ED E3       STD    ,--S    ; [local]
BB92: E6 41       LDB    $1,U
BB94: C4 70       ANDB   #$70
BB96: 1D          SEX
BB97: E3 1A       ADDD   -$6,X
BB99: 58          ASLB
BB9A: 49          ROLA
BB9B: AB E0       ADDA   ,S+    ; [local]
BB9D: 8B 04       ADDA   #$04
BB9F: 48          ASLA
BBA0: AB 45       ADDA   $5,U
BBA2: 84 7E       ANDA   #$7E
BBA4: A7 E2       STA    ,-S    ; [local]
BBA6: E6 43       LDB    $3,U
BBA8: C4 70       ANDB   #$70
BBAA: 1D          SEX
BBAB: E3 1C       ADDD   -$4,X
BBAD: 58          ASLB
BBAE: 49          ROLA
BBAF: AB 61       ADDA   $1,S    ; [local]
BBB1: A7 E2       STA    ,-S    ; [local]
BBB3: 86 1D       LDA    #$1D
BBB5: A0 E0       SUBA   ,S+    ; [local]
BBB7: C6 80       LDB    #$80
BBB9: 3D          MUL
BBBA: E3 46       ADDD   $6,U
BBBC: 84 0F       ANDA   #$0F
BBBE: EB E1       ADDB   ,S++    ; [local]
BBC0: 39          RTS

BBD1: EC 18       LDD    -$8,X
BBD3: 2F 61       BLE    $BC36
BBD5: E3 1C       ADDD   -$4,X
BBD7: 10 83 0F 80 CMPD   #$0F80
BBDB: 2C 4C       BGE    $BC29
BBDD: 32 7D       LEAS   -$3,S		; [alloc_locals]
BBDF: ED E4       STD    ,S		; [local]
BBE1: A6 0C       LDA    $C,X
BBE3: 84 10       ANDA   #$10
BBE5: 26 35       BNE    $BC1C
BBE7: A6 01       LDA    $1,X
BBE9: 84 FC       ANDA   #$FC
BBEB: 81 28       CMPA   #$28
BBED: 26 2D       BNE    $BC1C
BBEF: EC 1C       LDD    -$4,X
BBF1: CE 53 E0    LDU    #$53E0
BBF4: C4 70       ANDB   #$70
BBF6: EB 43       ADDB   $3,U
BBF8: C4 70       ANDB   #$70
BBFA: 26 14       BNE    $BC10
BBFC: CC 00 03    LDD    #$0003
BBFF: BD BB 6E    JSR    $BB6E
BC02: A7 62       STA    $2,S	;   [local]
BC04: C4 08       ANDB   #$08
BC06: 27 08       BEQ    $BC10
BC08: A6 0C       LDA    $C,X
BC0A: 8A 10       ORA    #$10
BC0C: A7 0C       STA    $C,X
BC0E: 20 0C       BRA    $BC1C
BC10: EC 1C       LDD    -$4,X
BC12: C3 00 10    ADDD   #$0010
BC15: ED 1C       STD    -$4,X
BC17: 10 A3 E4    CMPD   ,S		; [local]
BC1A: 2F D5       BLE    $BBF1
BC1C: EC E1       LDD    ,S++	;   [local]
BC1E: ED 1C       STD    -$4,X
BC20: EC 18       LDD    -$8,X
BC22: E3 12       ADDD   -$E,X
BC24: ED 18       STD    -$8,X
BC26: 5F          CLRB
BC27: 35 82       PULS   A,PC		; [manual_stack_pull]

BC29: 0A 30       DEC    $30
BC2B: 0A 36       DEC    $36
BC2D: 0A 32       DEC    $32
BC2F: 0A 38       DEC    $38
BC31: C6 FF       LDB    #$FF
BC33: E7 84       STB    ,X
BC35: 39          RTS
BC36: E3 1C       ADDD   -$4,X
BC38: 10 83 FC 80 CMPD   #$FC80
BC3C: 2D EB       BLT    $BC29
BC3E: 32 7D       LEAS   -$3,S		; [alloc_locals]
BC40: ED E4       STD    ,S		; [local]
BC42: EC 1C       LDD    -$4,X
BC44: CE 53 E0    LDU    #$53E0
BC47: C4 70       ANDB   #$70
BC49: EB 43       ADDB   $3,U
BC4B: C4 70       ANDB   #$70
BC4D: 26 24       BNE    $BC73
BC4F: CC 00 FF    LDD    #$00FF
BC52: BD BB 6E    JSR    $BB6E
BC55: A7 62       STA    $2,S	; [local]
BC57: C5 06       BITB   #$06
BC59: 27 18       BEQ    $BC73
BC5B: A6 01       LDA    $1,X
BC5D: 84 FC       ANDA   #$FC
BC5F: 81 2C       CMPA   #$2C
BC61: 26 04       BNE    $BC67
BC63: C5 04       BITB   #$04
BC65: 27 0C       BEQ    $BC73
BC67: C4 C0       ANDB   #$C0
BC69: E7 05       STB    $5,X
BC6B: A6 62       LDA    $2,S	; [free_locals]
BC6D: 85 EE       BITA   #$EE
BC6F: 81 20       CMPA   #$20
BC71: 26 19       BNE    $BC8C
BC73: EC 1C       LDD    -$4,X
BC75: C3 FF F0    ADDD   #$FFF0
BC78: ED 1C       STD    -$4,X
BC7A: 10 A3 E4    CMPD   ,S		;   [local]
BC7D: 2C C5       BGE    $BC44
BC7F: EC E1       LDD    ,S++		;   [local]
BC81: ED 1C       STD    -$4,X
BC83: EC 18       LDD    -$8,X
BC85: E3 12       ADDD   -$E,X
BC87: ED 18       STD    -$8,X
BC89: 5F          CLRB
BC8A: 35 82       PULS   A,PC		; [manual_stack_pull]

BC8C: 32 62       LEAS   $2,S	; [free_locals]
BC8E: A6 1D       LDA    -$3,X
BC90: 84 F0       ANDA   #$F0
BC92: A7 1D       STA    -$3,X
BC94: A6 0C       LDA    $C,X
BC96: 8A 02       ORA    #$02
BC98: A7 0C       STA    $C,X
BC9A: 35 82       PULS   A,PC		; [manual_stack_pull]

BC9C: EC 1A       LDD    -$6,X
BC9E: 10 83 FF 00 CMPD   #$FF00
BCA2: 2D 21       BLT    $BCC5
BCA4: 10 83 13 00 CMPD   #$1300
BCA8: 2E 1B       BGT    $BCC5
BCAA: CE 53 E0    LDU    #$53E0
BCAD: CC 00 FF    LDD    #$00FF
BCB0: BD BB 6E    JSR    $BB6E
BCB3: C5 20       BITB   #$20
BCB5: 26 0A       BNE    $BCC1
BCB7: C5 02       BITB   #$02
BCB9: 27 0C       BEQ    $BCC7
BCBB: 84 EE       ANDA   #$EE
BCBD: 81 20       CMPA   #$20
BCBF: 27 06       BEQ    $BCC7
BCC1: C4 C0       ANDB   #$C0
BCC3: E7 05       STB    $5,X
BCC5: 5F          CLRB
BCC6: 39          RTS
BCC7: C6 30       LDB    #$30
BCC9: 39          RTS

BCDA: E6 0D       LDB    $D,X
BCDC: 58          ASLB
BCDD: EA 0D       ORB    $D,X
BCDF: C4 02       ANDB   #$02
BCE1: E7 0D       STB    $D,X
BCE3: 10 8E E2 0E LDY    #$E20E
BCE7: F6 44 1B    LDB    $441B
BCEA: C4 7F       ANDB   #$7F
BCEC: 4F          CLRA
BCED: 58          ASLB
BCEE: 49          ROLA
BCEF: ED E3       STD    ,--S	; [local]
BCF1: 58          ASLB
BCF2: 49          ROLA
BCF3: 58          ASLB
BCF4: 49          ROLA
BCF5: E3 E1       ADDD   ,S++	; [local]
BCF7: 31 AB       LEAY   D,Y
BCF9: CE E2 0E    LDU    #$E20E
BCFC: E6 0B       LDB    $B,X
BCFE: C4 7F       ANDB   #$7F
BD00: 4F          CLRA
BD01: 58          ASLB
BD02: 49          ROLA
BD03: ED E3       STD    ,--S	; [local]
BD05: 58          ASLB
BD06: 49          ROLA
BD07: 58          ASLB
BD08: 49          ROLA
BD09: E3 E1       ADDD   ,S++	; [local]
BD0B: 33 CB       LEAU   D,U
BD0D: 8D 47       BSR    $BD56
BD0F: C5 40       BITB   #$40
BD11: 26 01       BNE    $BD14
BD13: 39          RTS
BD14: A6 4D       LDA    $D,U
BD16: 27 01       BEQ    $BD19
BD18: 39          RTS
BD19: 6D 4B       TST    $B,U
BD1B: 2B 31       BMI    $BD4E
BD1D: 6D 0B       TST    $B,X
BD1F: 2B 2D       BMI    $BD4E
BD21: 96 14       LDA    $14
BD23: 8B 20       ADDA   #$20
BD25: 97 14       STA    $14
BD27: 9B 15       ADDA   $15
BD29: A7 E2       STA    ,-S    ; [local]
BD2B: 96 C1       LDA    $C1
BD2D: A0 E0       SUBA   ,S+	; [local]
BD2F: 23 18       BLS    $BD49
BD31: 10 8E 53 40 LDY    #$5340
BD35: 96 E0       LDA    $E0
BD37: C6 02       LDB    #$02
BD39: E7 A6       STB    A,Y
BD3B: 4C          INCA
BD3C: 84 1F       ANDA   #$1F
BD3E: 97 E0       STA    $E0
BD40: A6 0D       LDA    $D,X
BD42: A7 4D       STA    $D,U
BD44: C6 78       LDB    #$78
BD46: E7 47       STB    $7,U
BD48: 39          RTS
BD49: C6 60       LDB    #$60
BD4B: E7 47       STB    $7,U
BD4D: 39          RTS
BD4E: A6 0D       LDA    $D,X
BD50: 84 FE       ANDA   #$FE
BD52: A7 0D       STA    $D,X
BD54: 5F          CLRB
BD55: 39          RTS
BD56: FC 44 0C    LDD    $440C
BD59: E3 A4       ADDD   ,Y
BD5B: A3 1C       SUBD   -$4,X
BD5D: A3 C4       SUBD   ,U
BD5F: 2B 23       BMI    $BD84
BD61: 10 83 05 00 CMPD   #$0500
BD65: 2E 15       BGT    $BD7C
BD67: 10 A3 42    CMPD   $2,U
BD6A: 2E 08       BGT    $BD74
BD6C: E6 0D       LDB    $D,X
BD6E: CA 61       ORB    #$61
BD70: E7 0D       STB    $D,X
BD72: 20 20       BRA    $BD94
BD74: E6 0D       LDB    $D,X
BD76: CA 21       ORB    #$21
BD78: E7 0D       STB    $D,X
BD7A: 20 18       BRA    $BD94
BD7C: E6 0D       LDB    $D,X
BD7E: CA 08       ORB    #$08
BD80: E7 0D       STB    $D,X
BD82: 20 10       BRA    $BD94

BD84: 53          COMB
BD85: 43          COMA
BD86: C3 00 01    ADDD   #$0001
BD89: 10 A3 22    CMPD   $2,Y
BD8C: 2E 06       BGT    $BD94
BD8E: E6 0D       LDB    $D,X
BD90: CA 61       ORB    #$61
BD92: E7 0D       STB    $D,X
BD94: B6 44 11    LDA    $4411
BD97: 84 02       ANDA   #$02
BD99: 26 20       BNE    $BDBB
BD9B: A6 01       LDA    $1,X
BD9D: 84 02       ANDA   #$02
BD9F: 26 0D       BNE    $BDAE
BDA1: FC 44 0A    LDD    $440A
BDA4: E3 24       ADDD   $4,Y
BDA6: A3 1A       SUBD   -$6,X
BDA8: A3 44       SUBD   $4,U
BDAA: 2B 75       BMI    $BE21
BDAC: 20 2B       BRA    $BDD9
BDAE: FC 44 0A    LDD    $440A
BDB1: E3 24       ADDD   $4,Y
BDB3: A3 1A       SUBD   -$6,X
BDB5: A3 46       SUBD   $6,U
BDB7: 2B 68       BMI    $BE21
BDB9: 20 1E       BRA    $BDD9
BDBB: A6 01       LDA    $1,X
BDBD: 84 02       ANDA   #$02
BDBF: 26 0D       BNE    $BDCE
BDC1: FC 44 0A    LDD    $440A
BDC4: E3 26       ADDD   $6,Y
BDC6: A3 1A       SUBD   -$6,X
BDC8: A3 44       SUBD   $4,U
BDCA: 2B 55       BMI    $BE21
BDCC: 20 0B       BRA    $BDD9
BDCE: FC 44 0A    LDD    $440A
BDD1: E3 26       ADDD   $6,Y
BDD3: A3 1A       SUBD   -$6,X
BDD5: A3 46       SUBD   $6,U
BDD7: 2B 48       BMI    $BE21
BDD9: 10 A3 48    CMPD   $8,U
BDDC: 2E 19       BGT    $BDF7
BDDE: CE 44 10    LDU    #$4410
BDE1: A6 05       LDA    $5,X
BDE3: A1 45       CMPA   $5,U
BDE5: 26 07       BNE    $BDEE
BDE7: E6 0D       LDB    $D,X
BDE9: CA 14       ORB    #$14
BDEB: E7 0D       STB    $D,X
BDED: 39          RTS
BDEE: E6 0D       LDB    $D,X
BDF0: CA 94       ORB    #$94
BDF2: C4 BE       ANDB   #$BE
BDF4: E7 0D       STB    $D,X
BDF6: 39          RTS
BDF7: CE 44 10    LDU    #$4410
BDFA: A6 01       LDA    $1,X
BDFC: 84 01       ANDA   #$01
BDFE: 27 18       BEQ    $BE18
BE00: A6 05       LDA    $5,X
BE02: A1 45       CMPA   $5,U
BE04: 26 09       BNE    $BE0F
BE06: E6 0D       LDB    $D,X
BE08: CA 04       ORB    #$04
BE0A: C4 2F       ANDB   #$2F
BE0C: E7 0D       STB    $D,X
BE0E: 39          RTS
BE0F: E6 0D       LDB    $D,X
BE11: CA 84       ORB    #$84
BE13: C4 AE       ANDB   #$AE
BE15: E7 0D       STB    $D,X
BE17: 39          RTS
BE18: E6 0D       LDB    $D,X
BE1A: CA 04       ORB    #$04
BE1C: C4 2E       ANDB   #$2E
BE1E: E7 0D       STB    $D,X
BE20: 39          RTS
BE21: 53          COMB
BE22: 43          COMA
BE23: C3 00 01    ADDD   #$0001
BE26: 10 A3 28    CMPD   $8,Y
BE29: 2E 19       BGT    $BE44
BE2B: CE 44 10    LDU    #$4410
BE2E: A6 05       LDA    $5,X
BE30: A1 45       CMPA   $5,U
BE32: 26 07       BNE    $BE3B
BE34: E6 0D       LDB    $D,X
BE36: CA 10       ORB    #$10
BE38: E7 0D       STB    $D,X
BE3A: 39          RTS
BE3B: E6 0D       LDB    $D,X
BE3D: CA 80       ORB    #$80
BE3F: C4 BA       ANDB   #$BA
BE41: E7 0D       STB    $D,X
BE43: 39          RTS
BE44: CE 44 10    LDU    #$4410
BE47: A6 01       LDA    $1,X
BE49: 84 02       ANDA   #$02
BE4B: 27 16       BEQ    $BE63
BE4D: A6 05       LDA    $5,X
BE4F: A1 45       CMPA   $5,U
BE51: 26 07       BNE    $BE5A
BE53: E6 0D       LDB    $D,X
BE55: C4 2B       ANDB   #$2B
BE57: E7 0D       STB    $D,X
BE59: 39          RTS
BE5A: E6 0D       LDB    $D,X
BE5C: CA 80       ORB    #$80
BE5E: C4 AA       ANDB   #$AA
BE60: E7 0D       STB    $D,X
BE62: 39          RTS
BE63: E6 0D       LDB    $D,X
BE65: C4 2A       ANDB   #$2A
BE67: E7 0D       STB    $D,X
BE69: 39          RTS
BE6A: CC 00 00    LDD    #$0000
BE6D: ED 18       STD    -$8,X
BE6F: CE BE 8B    LDU    #$BE8B
BE72: A6 03       LDA    $3,X
BE74: 84 30       ANDA   #$30
BE76: 44          LSRA
BE77: 44          LSRA
BE78: A7 E2       STA    ,-S    ; [local]
BE7A: A6 07       LDA    $7,X
BE7C: 84 02       ANDA   #$02
BE7E: AB E0       ADDA   ,S+    ; [local]
BE80: EC C6       LDD    A,U
BE82: A7 08       STA    $8,X
BE84: 5D          TSTB
BE85: 1D          SEX
BE86: ED 16       STD    -$A,X
BE88: 7E B5 AE    JMP    $B5AE

BE9B: BD BA 8D    JSR    $BA8D
BE9E: 27 01       BEQ    $BEA1
BEA0: 39          RTS
BEA1: BD BC 9C    JSR    $BC9C
BEA4: 10 26 F9 E6 LBNE   $B88E
BEA8: BD BE C9    JSR    $BEC9
BEAB: 27 01       BEQ    $BEAE
BEAD: 39          RTS
BEAE: 6A 0A       DEC    $A,X
BEB0: 27 01       BEQ    $BEB3
BEB2: 39          RTS
BEB3: A6 09       LDA    $9,X
BEB5: 81 05       CMPA   #$05
BEB7: 26 0A       BNE    $BEC3
BEB9: 86 FF       LDA    #$FF
BEBB: A7 09       STA    $9,X
BEBD: A6 0C       LDA    $C,X
BEBF: 84 DF       ANDA   #$DF
BEC1: A7 0C       STA    $C,X
BEC3: CE DE 8A    LDU    #$DE8A
BEC6: 7E B5 FD    JMP    $B5FD
BEC9: A6 0C       LDA    $C,X
BECB: 85 20       BITA   #$20
BECD: 26 49       BNE    $BF18
BECF: E6 0D       LDB    $D,X
BED1: C5 01       BITB   #$01
BED3: 26 4D       BNE    $BF22
BED5: C5 20       BITB   #$20
BED7: 27 1B       BEQ    $BEF4
BED9: 6A 08       DEC    $8,X
BEDB: 26 3B       BNE    $BF18
BEDD: C5 04       BITB   #$04
BEDF: 26 0B       BNE    $BEEC
BEE1: A6 01       LDA    $1,X
BEE3: 85 02       BITA   #$02
BEE5: 26 23       BNE    $BF0A
BEE7: C6 38       LDB    #$38
BEE9: 7E B8 8E    JMP    $B88E
BEEC: A6 01       LDA    $1,X
BEEE: 85 02       BITA   #$02
BEF0: 26 F5       BNE    $BEE7
BEF2: 20 16       BRA    $BF0A
BEF4: A6 03       LDA    $3,X
BEF6: 85 40       BITA   #$40
BEF8: 26 04       BNE    $BEFE
BEFA: 6A 08       DEC    $8,X
BEFC: 26 1A       BNE    $BF18
BEFE: C5 08       BITB   #$08
BF00: 26 18       BNE    $BF1A
BF02: C6 2C       LDB    #$2C
BF04: BD B8 8E    JSR    $B88E
BF07: 27 01       BEQ    $BF0A
BF09: 39          RTS
BF0A: CE BE 8B    LDU    #$BE8B
BF0D: A6 03       LDA    $3,X
BF0F: 84 30       ANDA   #$30
BF11: 44          LSRA
BF12: 44          LSRA
BF13: 44          LSRA
BF14: A6 C6       LDA    A,U
BF16: A7 08       STA    $8,X
BF18: 5F          CLRB
BF19: 39          RTS
BF1A: C6 28       LDB    #$28
BF1C: BD B8 8E    JSR    $B88E
BF1F: 27 E9       BEQ    $BF0A
BF21: 39          RTS
BF22: EC 1A       LDD    -$6,X
BF24: B3 44 0A    SUBD   $440A
BF27: 2A 05       BPL    $BF2E
BF29: 53          COMB
BF2A: 43          COMA
BF2B: C3 00 01    ADDD   #$0001
BF2E: 81 04       CMPA   #$04
BF30: 26 E6       BNE    $BF18
BF32: C6 44       LDB    #$44
BF34: 7E B8 8E    JMP    $B88E
BF37: 6A 0A       DEC    $A,X
BF39: 27 01       BEQ    $BF3C
BF3B: 39          RTS
BF3C: CE BF 44    LDU    #jump_table_bf44
BF3F: A6 09       LDA    $9,X
BF41: 48          ASLA
BF42: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

BF4A: A6 01       LDA    $1,X
BF4C: 88 03       EORA   #$03
BF4E: A7 01       STA    $1,X
BF50: A7 07       STA    $7,X
BF52: CE DF 06    LDU    #$DF06
BF55: 7E B5 FD    JMP    $B5FD
BF58: A6 0C       LDA    $C,X
BF5A: 84 FE       ANDA   #$FE
BF5C: A7 0C       STA    $C,X
BF5E: C6 04       LDB    #$04
BF60: 7E B8 8E    JMP    $B88E
BF63: 6A 0A       DEC    $A,X
BF65: 27 01       BEQ    $BF68
BF67: 39          RTS
BF68: C6 04       LDB    #$04
BF6A: 7E B8 8E    JMP    $B88E
BF6D: 6A 0A       DEC    $A,X
BF6F: 27 01       BEQ    $BF72
BF71: 39          RTS
BF72: A6 0D       LDA    $D,X
BF74: 84 04       ANDA   #$04
BF76: 26 05       BNE    $BF7D
BF78: C6 06       LDB    #$06
BF7A: 7E B8 8E    JMP    $B88E
BF7D: C6 05       LDB    #$05
BF7F: 7E B8 8E    JMP    $B88E
BF82: CE 53 E0    LDU    #$53E0
BF85: CC 00 FF    LDD    #$00FF
BF88: BD BB 6E    JSR    $BB6E
BF8B: 81 23       CMPA   #$23
BF8D: 27 12       BEQ    $BFA1
BF8F: 81 2F       CMPA   #$2F
BF91: 27 0E       BEQ    $BFA1
BF93: CC 00 A0    LDD    #$00A0
BF96: ED 18       STD    -$8,X
BF98: A6 0C       LDA    $C,X
BF9A: 84 ED       ANDA   #$ED
BF9C: A7 0C       STA    $C,X
BF9E: 7E B5 AE    JMP    $B5AE
BFA1: A6 0C       LDA    $C,X
BFA3: 8A 20       ORA    #$20
BFA5: A7 0C       STA    $C,X
BFA7: 4F          CLRA
BFA8: 39          RTS
BFA9: CE BF B1    LDU    #jump_table_bfb1
BFAC: A6 09       LDA    $9,X
BFAE: 48          ASLA
BFAF: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=5]

BFBB: BD BB D1    JSR    $BBD1
BFBE: A6 0C       LDA    $C,X
BFC0: 84 10       ANDA   #$10
BFC2: 26 0B       BNE    $BFCF
BFC4: 6A 0A       DEC    $A,X
BFC6: 27 01       BEQ    $BFC9
BFC8: 39          RTS
BFC9: CE DE A2    LDU    #$DEA2
BFCC: 7E B5 FD    JMP    $B5FD
BFCF: 6C 09       INC    $9,X
BFD1: CE DE A2    LDU    #$DEA2
BFD4: 7E B5 FD    JMP    $B5FD
BFD7: BD BB D1    JSR    $BBD1
BFDA: A6 0C       LDA    $C,X
BFDC: 84 10       ANDA   #$10
BFDE: 26 05       BNE    $BFE5
BFE0: 6A 0A       DEC    $A,X
BFE2: 27 01       BEQ    $BFE5
BFE4: 39          RTS
BFE5: CE DE A2    LDU    #$DEA2
BFE8: 7E B5 FD    JMP    $B5FD
BFEB: BD BB D1    JSR    $BBD1
BFEE: A6 18       LDA    -$8,X
BFF0: 27 01       BEQ    $BFF3
BFF2: 39          RTS
BFF3: E6 19       LDB    -$7,X
BFF5: C4 F0       ANDB   #$F0
BFF7: 27 01       BEQ    $BFFA
BFF9: 39          RTS
BFFA: ED 18       STD    -$8,X
BFFC: A6 0C       LDA    $C,X
BFFE: 84 10       ANDA   #$10
C000: 26 05       BNE    $C007
C002: C6 34       LDB    #$34
C004: 7E B8 8E    JMP    $B88E
C007: A6 05       LDA    $5,X
C009: 81 40       CMPA   #$40
C00B: 26 0A       BNE    $C017
C00D: 86 80       LDA    #$80
C00F: A7 05       STA    $5,X
C011: CE DE A2    LDU    #$DEA2
C014: 7E B5 FD    JMP    $B5FD
C017: 86 40       LDA    #$40
C019: A7 05       STA    $5,X
C01B: CE DE A2    LDU    #$DEA2
C01E: 7E B5 FD    JMP    $B5FD
C021: BD BB D1    JSR    $BBD1
C024: 26 01       BNE    $C027
C026: 39          RTS
C027: CE DE A2    LDU    #$DEA2
C02A: 7E B5 FD    JMP    $B5FD
C02D: 6A 0A       DEC    $A,X
C02F: 27 01       BEQ    $C032
C031: 39          RTS
C032: A6 0C       LDA    $C,X
C034: 85 01       BITA   #$01
C036: 26 0F       BNE    $C047
C038: E6 0D       LDB    $D,X
C03A: C5 01       BITB   #$01
C03C: 26 09       BNE    $C047
C03E: 84 FE       ANDA   #$FE
C040: A7 0C       STA    $C,X
C042: C6 38       LDB    #$38
C044: 7E B8 8E    JMP    $B88E
C047: 84 FE       ANDA   #$FE
C049: A7 0C       STA    $C,X
C04B: C6 04       LDB    #$04
C04D: 7E B8 8E    JMP    $B88E
C050: CE C0 58    LDU    #jump_table_c058
C053: A6 09       LDA    $9,X
C055: 48          ASLA
C056: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]
C058: C0 5E       SUBB   #$5E
C05A: C0 76       SUBB   #$76
C05C: C0 82       SUBB   #$82
C05E: BD BB D1    JSR    $BBD1
C061: 26 0B       BNE    $C06E
C063: 6A 0A       DEC    $A,X
C065: 27 01       BEQ    $C068
C067: 39          RTS
C068: CE DE CA    LDU    #$DECA
C06B: 7E B5 FD    JMP    $B5FD
C06E: 6C 09       INC    $9,X
C070: CE DE CA    LDU    #$DECA
C073: 7E B5 FD    JMP    $B5FD
C076: BD BB D1    JSR    $BBD1
C079: 26 01       BNE    $C07C
C07B: 39          RTS
C07C: CE DE CA    LDU    #$DECA
C07F: 7E B5 FD    JMP    $B5FD
C082: 6A 0A       DEC    $A,X
C084: 27 01       BEQ    $C087
C086: 39          RTS
C087: A6 0C       LDA    $C,X
C089: 85 01       BITA   #$01
C08B: 26 06       BNE    $C093
C08D: E6 0D       LDB    $D,X
C08F: C5 01       BITB   #$01
C091: 26 09       BNE    $C09C
C093: 8A 20       ORA    #$20
C095: A7 0C       STA    $C,X
C097: C6 48       LDB    #$48
C099: 7E B8 8E    JMP    $B88E
C09C: 8A 20       ORA    #$20
C09E: A7 0C       STA    $C,X
C0A0: C6 04       LDB    #$04
C0A2: 7E B8 8E    JMP    $B88E
C0A5: CE 53 E0    LDU    #$53E0
C0A8: CC 00 03    LDD    #$0003
C0AB: BD BB 6E    JSR    $BB6E
C0AE: C4 10       ANDB   #$10
C0B0: 27 0E       BEQ    $C0C0
C0B2: CC 00 40    LDD    #$0040
C0B5: ED 18       STD    -$8,X
C0B7: A6 0C       LDA    $C,X
C0B9: 84 FD       ANDA   #$FD
C0BB: A7 0C       STA    $C,X
C0BD: 7E B5 AE    JMP    $B5AE
C0C0: A6 0C       LDA    $C,X
C0C2: 8A 20       ORA    #$20
C0C4: A7 0C       STA    $C,X
C0C6: 4F          CLRA
C0C7: 39          RTS
C0C8: CE C0 D0    LDU    #jump_table_c0d0
C0CB: A6 09       LDA    $9,X
C0CD: 48          ASLA
C0CE: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=5]

C0DA: BD BB D1    JSR    $BBD1
C0DD: 6A 0A       DEC    $A,X
C0DF: 27 01       BEQ    $C0E2
C0E1: 39          RTS
C0E2: CE DE B6    LDU    #$DEB6
C0E5: 7E B5 FD    JMP    $B5FD
C0E8: BD BB D1    JSR    $BBD1
C0EB: A6 18       LDA    -$8,X
C0ED: 27 01       BEQ    $C0F0
C0EF: 39          RTS
C0F0: E6 19       LDB    -$7,X
C0F2: C4 F0       ANDB   #$F0
C0F4: 27 01       BEQ    $C0F7
C0F6: 39          RTS
C0F7: ED 18       STD    -$8,X
C0F9: A6 05       LDA    $5,X
C0FB: 81 40       CMPA   #$40
C0FD: 26 0A       BNE    $C109
C0FF: 86 80       LDA    #$80
C101: A7 05       STA    $5,X
C103: CE DE B6    LDU    #$DEB6
C106: 7E B5 FD    JMP    $B5FD
C109: 86 40       LDA    #$40
C10B: A7 05       STA    $5,X
C10D: CE DE B6    LDU    #$DEB6
C110: 7E B5 FD    JMP    $B5FD
C113: BD BB D1    JSR    $BBD1
C116: 26 01       BNE    $C119
C118: 39          RTS
C119: CE DE B6    LDU    #$DEB6
C11C: 7E B5 FD    JMP    $B5FD
C11F: 6A 0A       DEC    $A,X
C121: 27 01       BEQ    $C124
C123: 39          RTS
C124: A6 0C       LDA    $C,X
C126: 85 01       BITA   #$01
C128: 26 0F       BNE    $C139
C12A: E6 0D       LDB    $D,X
C12C: C5 01       BITB   #$01
C12E: 26 09       BNE    $C139
C130: 84 FE       ANDA   #$FE
C132: A7 0C       STA    $C,X
C134: C6 38       LDB    #$38
C136: 7E B8 8E    JMP    $B88E
C139: 84 FE       ANDA   #$FE
C13B: A7 0C       STA    $C,X
C13D: C6 04       LDB    #$04
C13F: 7E B8 8E    JMP    $B88E
C142: CC 00 28    LDD    #$0028
C145: ED 18       STD    -$8,X
C147: A6 07       LDA    $7,X
C149: 84 02       ANDA   #$02
C14B: 26 06       BNE    $C153
C14D: CC 00 20    LDD    #$0020
C150: 7E B5 AE    JMP    $B5AE
C153: CC FF E0    LDD    #$FFE0
C156: 7E B5 AE    JMP    $B5AE
C159: CE C1 61    LDU    #jump_table_c161
C15C: A6 09       LDA    $9,X
C15E: 48          ASLA
C15F: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

C167: BD BA 8D    JSR    $BA8D
C16A: 2A 01       BPL    $C16D
C16C: 39          RTS
C16D: BD BB D1    JSR    $BBD1
C170: 26 0B       BNE    $C17D
C172: 6A 0A       DEC    $A,X
C174: 27 01       BEQ    $C177
C176: 39          RTS
C177: CE DE CA    LDU    #$DECA
C17A: 7E B5 FD    JMP    $B5FD
C17D: 6C 09       INC    $9,X
C17F: CE DE CA    LDU    #$DECA
C182: 7E B5 FD    JMP    $B5FD
C185: BD BA 8D    JSR    $BA8D
C188: 2A 01       BPL    $C18B
C18A: 39          RTS
C18B: BD BB D1    JSR    $BBD1
C18E: 26 01       BNE    $C191
C190: 39          RTS
C191: CE DE CA    LDU    #$DECA
C194: 7E B5 FD    JMP    $B5FD
C197: 6A 0A       DEC    $A,X
C199: 27 01       BEQ    $C19C
C19B: 39          RTS
C19C: E6 0D       LDB    $D,X
C19E: C5 01       BITB   #$01
C1A0: 26 05       BNE    $C1A7
C1A2: C6 38       LDB    #$38
C1A4: 7E B8 8E    JMP    $B88E
C1A7: C6 04       LDB    #$04
C1A9: 7E B8 8E    JMP    $B88E
C1AC: CC 00 60    LDD    #$0060
C1AF: ED 18       STD    -$8,X
C1B1: 10 8E 53 80 LDY    #$5380
C1B5: 96 E2       LDA    $E2
C1B7: C6 63       LDB    #$63
C1B9: E7 A6       STB    A,Y
C1BB: 4C          INCA
C1BC: 84 1F       ANDA   #$1F
C1BE: 97 E2       STA    $E2
C1C0: A6 07       LDA    $7,X
C1C2: 84 02       ANDA   #$02
C1C4: 26 08       BNE    $C1CE
C1C6: CC 00 30    LDD    #$0030
C1C9: ED 16       STD    -$A,X
C1CB: 7E B5 AE    JMP    $B5AE
C1CE: CC FF D0    LDD    #$FFD0
C1D1: ED 16       STD    -$A,X
C1D3: 7E B5 AE    JMP    $B5AE
C1D6: CE C1 DE    LDU    #jump_table_c1de
C1D9: A6 09       LDA    $9,X
C1DB: 48          ASLA
C1DC: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

C1E4: BD BA 8D    JSR    $BA8D
C1E7: 2A 01       BPL    $C1EA
C1E9: 39          RTS
C1EA: BD BB D1    JSR    $BBD1
C1ED: A6 18       LDA    -$8,X
C1EF: 27 01       BEQ    $C1F2
C1F1: 39          RTS
C1F2: E6 19       LDB    -$7,X
C1F4: C4 F0       ANDB   #$F0
C1F6: 27 01       BEQ    $C1F9
C1F8: 39          RTS
C1F9: ED 18       STD    -$8,X
C1FB: CE DE D6    LDU    #$DED6
C1FE: 7E B5 FD    JMP    $B5FD
C201: BD BA 8D    JSR    $BA8D
C204: 2A 01       BPL    $C207
C206: 39          RTS
C207: BD BB D1    JSR    $BBD1
C20A: 26 01       BNE    $C20D
C20C: 39          RTS
C20D: CE DE D6    LDU    #$DED6
C210: 7E B5 FD    JMP    $B5FD
C213: 6A 0A       DEC    $A,X
C215: 27 01       BEQ    $C218
C217: 39          RTS
C218: A6 0D       LDA    $D,X
C21A: 85 31       BITA   #$31
C21C: 26 05       BNE    $C223
C21E: C6 38       LDB    #$38
C220: 7E B8 8E    JMP    $B88E
C223: C6 04       LDB    #$04
C225: 7E B8 8E    JMP    $B88E
C228: 6A 0A       DEC    $A,X
C22A: 27 01       BEQ    $C22D
C22C: 39          RTS
C22D: CE C2 35    LDU    #jump_table_c235
C230: A6 09       LDA    $9,X
C232: 48          ASLA
C233: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

C23B: A6 01       LDA    $1,X
C23D: 88 03       EORA   #$03
C23F: A7 01       STA    $1,X
C241: A7 07       STA    $7,X
C243: CE DF 12    LDU    #$DF12
C246: 7E B5 FD    JMP    $B5FD
C249: A6 0D       LDA    $D,X
C24B: 85 20       BITA   #$20
C24D: 27 17       BEQ    $C266
C24F: 85 01       BITA   #$01
C251: 26 0A       BNE    $C25D
C253: E6 01       LDB    $1,X
C255: C5 02       BITB   #$02
C257: 26 09       BNE    $C262
C259: 85 04       BITA   #$04
C25B: 27 09       BEQ    $C266
C25D: C6 54       LDB    #$54
C25F: 7E B8 8E    JMP    $B88E
C262: 85 04       BITA   #$04
C264: 27 F7       BEQ    $C25D
C266: CE DF 12    LDU    #$DF12
C269: 7E B5 FD    JMP    $B5FD
C26C: C6 04       LDB    #$04
C26E: 7E B8 8E    JMP    $B88E
C271: 10 8E 53 80 LDY    #$5380
C275: 96 E2       LDA    $E2
C277: C6 63       LDB    #$63
C279: E7 A6       STB    A,Y
C27B: 4C          INCA
C27C: 84 1F       ANDA   #$1F
C27E: 97 E2       STA    $E2
C280: CE 54 5C    LDU    #$545C
C283: CC 00 30    LDD    #$0030
C286: BD 98 EF    JSR    $98EF
C289: A6 07       LDA    $7,X
C28B: 88 03       EORA   #$03
C28D: A7 07       STA    $7,X
C28F: 7E B5 AE    JMP    $B5AE
C292: 6A 0A       DEC    $A,X
C294: 27 01       BEQ    $C297
C296: 39          RTS
C297: CE C2 9F    LDU    #jump_table_c29f
C29A: A6 09       LDA    $9,X
C29C: 48          ASLA
C29D: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=8]

C2AF: 86 1E       LDA    #$1E
C2B1: A7 04       STA    $4,X
C2B3: CE DE E6    LDU    #$DEE6
C2B6: 7E B5 FD    JMP    $B5FD
C2B9: 86 FF       LDA    #$FF
C2BB: A7 84       STA    ,X
C2BD: 0A 30       DEC    $30
C2BF: 0A 36       DEC    $36
C2C1: 0A 32       DEC    $32
C2C3: 0A 38       DEC    $38
C2C5: 39          RTS
C2C6: CC FF FE    LDD    #$FFFE
C2C9: ED 12       STD    -$E,X
C2CB: CC 00 48    LDD    #$0048
C2CE: ED 18       STD    -$8,X
C2D0: A6 07       LDA    $7,X
C2D2: 84 02       ANDA   #$02
C2D4: 26 08       BNE    $C2DE
C2D6: CC 00 20    LDD    #$0020
C2D9: ED 16       STD    -$A,X
C2DB: 7E B5 AE    JMP    $B5AE
C2DE: CC FF E0    LDD    #$FFE0
C2E1: ED 16       STD    -$A,X
C2E3: 7E B5 AE    JMP    $B5AE

C2E6: BD BA 8D    JSR    $BA8D
C2E9: 2A 01       BPL    $C2EC
C2EB: 39          RTS
C2EC: 26 14       BNE    $C302
C2EE: EC 1A       LDD    -$6,X
C2F0: 6D 16       TST    -$A,X
C2F2: 2B 08       BMI    $C2FC
C2F4: 10 83 11 00 CMPD   #$1100
C2F8: 2C 08       BGE    $C302
C2FA: 20 17       BRA    $C313
C2FC: 10 83 01 00 CMPD   #$0100
C300: 2C 11       BGE    $C313
C302: A6 01       LDA    $1,X
C304: 88 03       EORA   #$03
C306: A7 01       STA    $1,X
C308: A7 07       STA    $7,X
C30A: EC 16       LDD    -$A,X
C30C: 53          COMB
C30D: 43          COMA
C30E: C3 00 01    ADDD   #$0001
C311: ED 16       STD    -$A,X
C313: BD BB D1    JSR    $BBD1
C316: 26 68       BNE    $C380
C318: CE C3 8F    LDU    #jump_table_c38f
C31B: A6 09       LDA    $9,X
C31D: 48          ASLA
C31E: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=6]
C320: EC 18       LDD    -$8,X
C322: C4 F8       ANDB   #$F8
C324: 10 83 00 30 CMPD   #$0030
C328: 2F 01       BLE    $C32B
C32A: 39          RTS
C32B: CE E0 FE    LDU    #$E0FE
C32E: 7E B5 FD    JMP    $B5FD
C331: EC 18       LDD    -$8,X
C333: C4 F8       ANDB   #$F8
C335: 10 83 00 18 CMPD   #$0018
C339: 2F 01       BLE    $C33C
C33B: 39          RTS
C33C: CE E0 FE    LDU    #$E0FE
C33F: 7E B5 FD    JMP    $B5FD
C342: EC 18       LDD    -$8,X
C344: C4 F8       ANDB   #$F8
C346: 10 83 00 00 CMPD   #$0000
C34A: 2F 01       BLE    $C34D
C34C: 39          RTS
C34D: CE E0 FE    LDU    #$E0FE
C350: 7E B5 FD    JMP    $B5FD
C353: EC 18       LDD    -$8,X
C355: C4 F8       ANDB   #$F8
C357: 10 83 FF E8 CMPD   #$FFE8
C35B: 2F 01       BLE    $C35E
C35D: 39          RTS
C35E: CE E0 FE    LDU    #$E0FE
C361: 7E B5 FD    JMP    $B5FD
C364: EC 18       LDD    -$8,X
C366: C4 F8       ANDB   #$F8
C368: 10 83 FF D0 CMPD   #$FFD0
C36C: 2F 01       BLE    $C36F
C36E: 39          RTS
C36F: CE E0 FE    LDU    #$E0FE
C372: 7E B5 FD    JMP    $B5FD
C375: EC 18       LDD    -$8,X
C377: C4 F8       ANDB   #$F8
C379: 10 83 00 00 CMPD   #$0000
C37D: 27 01       BEQ    $C380
C37F: 39          RTS
C380: CC 00 48    LDD    #$0048
C383: ED 18       STD    -$8,X
C385: 86 FF       LDA    #$FF
C387: A7 09       STA    $9,X
C389: CE E0 FE    LDU    #$E0FE
C38C: 7E B5 FD    JMP    $B5FD

C39B: E6 01       LDB    $1,X
C39D: C8 03       EORB   #$03
C39F: 7E B8 8E    JMP    $B88E
C3A2: 39          RTS
C3A3: 7E B5 AE    JMP    $B5AE
C3A6: CE C3 AE    LDU    #jump_table_c3ae
C3A9: A6 09       LDA    $9,X
C3AB: 48          ASLA
C3AC: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=4]

C3B6: 6A 0A       DEC    $A,X
C3B8: 27 01       BEQ    $C3BB
C3BA: 39          RTS

C3BB: CE E1 32    LDU    #$E132
C3BE: 7E B5 FD    JMP    $B5FD
C3C1: 6A 0A       DEC    $A,X
C3C3: 27 01       BEQ    $C3C6
C3C5: 39          RTS
C3C6: CE E1 32    LDU    #$E132
C3C9: 7E B5 FD    JMP    $B5FD
C3CC: 6A 0A       DEC    $A,X
C3CE: 27 01       BEQ    $C3D1
C3D0: 39          RTS
C3D1: C6 30       LDB    #$30
C3D3: 7E B8 8E    JMP    $B88E
C3D6: CC 00 04    LDD    #$0004
C3D9: ED 12       STD    -$E,X
C3DB: CC 00 04    LDD    #$0004
C3DE: ED 18       STD    -$8,X
C3E0: A6 07       LDA    $7,X
C3E2: 84 02       ANDA   #$02
C3E4: 26 08       BNE    $C3EE
C3E6: CC 00 10    LDD    #$0010
C3E9: ED 16       STD    -$A,X
C3EB: 7E B5 AE    JMP    $B5AE
C3EE: CC FF F0    LDD    #$FFF0
C3F1: ED 16       STD    -$A,X
C3F3: 7E B5 AE    JMP    $B5AE
C3F6: CE C3 FE    LDU    #jump_table_c3fe
C3F9: A6 09       LDA    $9,X
C3FB: 48          ASLA
C3FC: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

C401: 43          COMA
C402: C4 82       ANDB   #$82
C404: BD BA 8D    JSR    $BA8D
C407: 2A 01       BPL    $C40A
C409: 39          RTS
C40A: 26 0E       BNE    $C41A
C40C: A6 01       LDA    $1,X
C40E: 84 02       ANDA   #$02
C410: 26 1B       BNE    $C42D
C412: EC 1A       LDD    -$6,X
C414: 10 83 11 00 CMPD   #$1100
C418: 2D 1B       BLT    $C435
C41A: A6 01       LDA    $1,X
C41C: 88 03       EORA   #$03
C41E: A7 01       STA    $1,X
C420: A7 07       STA    $7,X
C422: EC 16       LDD    -$A,X
C424: 53          COMB
C425: 43          COMA
C426: C3 00 01    ADDD   #$0001
C429: ED 16       STD    -$A,X
C42B: 20 08       BRA    $C435
C42D: EC 1A       LDD    -$6,X
C42F: 10 83 01 00 CMPD   #$0100
C433: 2D E5       BLT    $C41A
C435: BD BB D1    JSR    $BBD1
C438: 6A 0A       DEC    $A,X
C43A: 27 01       BEQ    $C43D
C43C: 39          RTS
C43D: CE E1 1A    LDU    #$E11A
C440: 7E B5 FD    JMP    $B5FD
C443: BD BA 8D    JSR    $BA8D
C446: 2A 01       BPL    $C449
C448: 39          RTS
C449: 26 0E       BNE    $C459
C44B: A6 01       LDA    $1,X
C44D: 84 02       ANDA   #$02
C44F: 26 1B       BNE    $C46C
C451: EC 1A       LDD    -$6,X
C453: 10 83 11 00 CMPD   #$1100
C457: 2D 1B       BLT    $C474
C459: A6 01       LDA    $1,X
C45B: 88 03       EORA   #$03
C45D: A7 01       STA    $1,X
C45F: A7 07       STA    $7,X
C461: EC 16       LDD    -$A,X
C463: 53          COMB
C464: 43          COMA
C465: C3 00 01    ADDD   #$0001
C468: ED 16       STD    -$A,X
C46A: 20 08       BRA    $C474
C46C: EC 1A       LDD    -$6,X
C46E: 10 83 01 00 CMPD   #$0100
C472: 2D E5       BLT    $C459
C474: BD BB D1    JSR    $BBD1
C477: 6A 0A       DEC    $A,X
C479: 27 01       BEQ    $C47C
C47B: 39          RTS
C47C: CE E1 1A    LDU    #$E11A
C47F: 7E B5 FD    JMP    $B5FD
C482: BD BA 8D    JSR    $BA8D
C485: 2A 01       BPL    $C488
C487: 39          RTS
C488: 26 0E       BNE    $C498
C48A: A6 01       LDA    $1,X
C48C: 84 02       ANDA   #$02
C48E: 26 1B       BNE    $C4AB
C490: EC 1A       LDD    -$6,X
C492: 10 83 11 00 CMPD   #$1100
C496: 2D 1B       BLT    $C4B3
C498: A6 01       LDA    $1,X
C49A: 88 03       EORA   #$03
C49C: A7 01       STA    $1,X
C49E: A7 07       STA    $7,X
C4A0: EC 16       LDD    -$A,X
C4A2: 53          COMB
C4A3: 43          COMA
C4A4: C3 00 01    ADDD   #$0001
C4A7: ED 16       STD    -$A,X
C4A9: 20 08       BRA    $C4B3
C4AB: EC 1A       LDD    -$6,X
C4AD: 10 83 01 00 CMPD   #$0100
C4B1: 2D E5       BLT    $C498
C4B3: BD BB D1    JSR    $BBD1
C4B6: EC 1C       LDD    -$4,X
C4B8: 10 83 10 00 CMPD   #$1000
C4BC: 2C 01       BGE    $C4BF
C4BE: 39          RTS
C4BF: C6 FF       LDB    #$FF
C4C1: E7 84       STB    ,X
C4C3: 0A 30       DEC    $30
C4C5: 0A 36       DEC    $36
C4C7: 0A 32       DEC    $32
C4C9: 0A 38       DEC    $38
C4CB: 39          RTS
C4CC: CE C4 F7    LDU    #$C4F7
C4CF: A6 03       LDA    $3,X
C4D1: 27 02       BEQ    $C4D5
C4D3: 33 45       LEAU   $5,U
C4D5: EC C1       LDD    ,U++
C4D7: ED 18       STD    -$8,X
C4D9: EC C1       LDD    ,U++
C4DB: ED 12       STD    -$E,X
C4DD: A6 C0       LDA    ,U+
C4DF: A7 08       STA    $8,X
C4E1: A6 07       LDA    $7,X
C4E3: 84 02       ANDA   #$02
C4E5: 26 08       BNE    $C4EF
C4E7: CC 00 18    LDD    #$0018
C4EA: ED 16       STD    -$A,X
C4EC: 7E B5 AE    JMP    $B5AE
C4EF: CC FF E8    LDD    #$FFE8
C4F2: ED 16       STD    -$A,X
C4F4: 7E B5 AE    JMP    $B5AE

C501: BD BA 8D    JSR    $BA8D
C504: 2A 01       BPL    $C507
C506: 39          RTS
C507: 26 12       BNE    $C51B
C509: 6D 16       TST    -$A,X
C50B: 2A 06       BPL    $C513
C50D: 6D 1A       TST    -$6,X
C50F: 2B 0A       BMI    $C51B
C511: 20 19       BRA    $C52C
C513: EC 1A       LDD    -$6,X
C515: 10 83 12 00 CMPD   #$1200
C519: 2D 11       BLT    $C52C
C51B: A6 01       LDA    $1,X
C51D: 88 03       EORA   #$03
C51F: A7 01       STA    $1,X
C521: A7 07       STA    $7,X
C523: EC 16       LDD    -$A,X
C525: 53          COMB
C526: 43          COMA
C527: C3 00 01    ADDD   #$0001
C52A: ED 16       STD    -$A,X
C52C: BD BB D1    JSR    $BBD1
C52F: 26 2D       BNE    $C55E
C531: EC 18       LDD    -$8,X
C533: 2A 05       BPL    $C53A
C535: 53          COMB
C536: 43          COMA
C537: C3 00 01    ADDD   #$0001
C53A: 10 83 00 30 CMPD   #$0030
C53E: 26 09       BNE    $C549
C540: EC 12       LDD    -$E,X
C542: 53          COMB
C543: 43          COMA
C544: C3 00 01    ADDD   #$0001
C547: ED 12       STD    -$E,X
C549: 6A 0A       DEC    $A,X
C54B: 27 01       BEQ    $C54E
C54D: 39          RTS
C54E: A6 09       LDA    $9,X
C550: 81 02       CMPA   #$02
C552: 26 04       BNE    $C558
C554: 86 FF       LDA    #$FF
C556: A7 09       STA    $9,X
C558: CE E1 26    LDU    #$E126
C55B: 7E B5 FD    JMP    $B5FD
C55E: C6 28       LDB    #$28
C560: 7E B8 8E    JMP    $B88E
C563: A6 01       LDA    $1,X
C565: 84 FC       ANDA   #$FC
C567: 81 28       CMPA   #$28
C569: 27 33       BEQ    $C59E
C56B: 81 6C       CMPA   #$6C
C56D: 27 2F       BEQ    $C59E
C56F: 10 8E 53 40 LDY    #$5340
C573: 96 E0       LDA    $E0
C575: C6 06       LDB    #$06
C577: E7 A6       STB    A,Y
C579: 4C          INCA
C57A: 84 1F       ANDA   #$1F
C57C: 97 E0       STA    $E0
C57E: CC 00 08    LDD    #$0008
C581: ED 12       STD    -$E,X
C583: CC 00 20    LDD    #$0020
C586: ED 18       STD    -$8,X
C588: A6 07       LDA    $7,X
C58A: 84 02       ANDA   #$02
C58C: 26 08       BNE    $C596
C58E: CC 00 10    LDD    #$0010
C591: ED 16       STD    -$A,X
C593: 7E B5 AE    JMP    $B5AE
C596: CC FF F0    LDD    #$FFF0
C599: ED 16       STD    -$A,X
C59B: 7E B5 AE    JMP    $B5AE
C59E: CE 54 5C    LDU    #$545C
C5A1: CC 00 80    LDD    #$0080
C5A4: BD 98 EF    JSR    $98EF
C5A7: E6 07       LDB    $7,X
C5A9: C4 03       ANDB   #$03
C5AB: CA 64       ORB    #$64
C5AD: E7 07       STB    $7,X
C5AF: 7E B5 AE    JMP    $B5AE
C5B2: CE C5 BA    LDU    #jump_table_c5ba
C5B5: A6 09       LDA    $9,X
C5B7: 48          ASLA
C5B8: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=5]
C5BA: C5 C4       BITB   #$C4
C5BC: C5 C4       BITB   #$C4
C5BE: C5 C4       BITB   #$C4
C5C0: C5 C4       BITB   #$C4
C5C2: C6 0E       LDB    #$0E
C5C4: BD BA 8D    JSR    $BA8D
C5C7: 2A 01       BPL    $C5CA
C5C9: 39          RTS
C5CA: 27 11       BEQ    $C5DD
C5CC: A6 01       LDA    $1,X
C5CE: 88 03       EORA   #$03
C5D0: A7 01       STA    $1,X
C5D2: A7 07       STA    $7,X
C5D4: EC 16       LDD    -$A,X
C5D6: 53          COMB
C5D7: 43          COMA
C5D8: C3 00 01    ADDD   #$0001
C5DB: ED 16       STD    -$A,X
C5DD: BD BB D1    JSR    $BBD1
C5E0: EC 18       LDD    -$8,X
C5E2: 27 20       BEQ    $C604
C5E4: EC 1C       LDD    -$4,X
C5E6: 10 83 06 00 CMPD   #$0600
C5EA: 2D 05       BLT    $C5F1
C5EC: CC FF F8    LDD    #$FFF8
C5EF: ED 12       STD    -$E,X
C5F1: 6A 0A       DEC    $A,X
C5F3: 27 01       BEQ    $C5F6
C5F5: 39          RTS
C5F6: A6 09       LDA    $9,X
C5F8: 81 03       CMPA   #$03
C5FA: 26 02       BNE    $C5FE
C5FC: 6F 09       CLR    $9,X
C5FE: CE E1 46    LDU    #$E146
C601: 7E B5 FD    JMP    $B5FD
C604: 86 03       LDA    #$03
C606: A7 09       STA    $9,X
C608: CE E1 46    LDU    #$E146
C60B: 7E B5 FD    JMP    $B5FD
C60E: 6A 0A       DEC    $A,X
C610: 27 01       BEQ    $C613
C612: 39          RTS
C613: A6 01       LDA    $1,X
C615: 84 02       ANDA   #$02
C617: 10 26 00 83 LBNE   $C69E
C61B: 34 10       PSHS   X
C61D: 96 30       LDA    $30
C61F: 9B 31       ADDA   $31
C621: 81 28       CMPA   #$28
C623: 24 16       BCC    $C63B
C625: 10 8E C6 E6 LDY    #$C6E6
C629: 8D 38       BSR    $C663
C62B: 27 0E       BEQ    $C63B
C62D: 10 8E C6 F1 LDY    #$C6F1
C631: 8D 30       BSR    $C663
C633: 27 06       BEQ    $C63B
C635: 10 8E C6 FC LDY    #$C6FC
C639: 8D 28       BSR    $C663
C63B: 35 10       PULS   X
C63D: 10 8E C7 07 LDY    #$C707
C641: EC 1A       LDD    -$6,X
C643: E3 A1       ADDD   ,Y++
C645: ED 1A       STD    -$6,X
C647: EC 1C       LDD    -$4,X
C649: E3 A1       ADDD   ,Y++
C64B: ED 1C       STD    -$4,X
C64D: EC A1       LDD    ,Y++
C64F: ED 16       STD    -$A,X
C651: CC FF E0    LDD    #$FFE0
C654: ED 18       STD    -$8,X
C656: EC A4       LDD    ,Y
C658: ED 02       STD    $2,X
C65A: C6 6D       LDB    #$6D
C65C: E7 07       STB    $7,X
C65E: E7 01       STB    $1,X
C660: 7E B5 AE    JMP    $B5AE

C663: EE 62       LDU    $2,S		; [pushed_parameter] retrieve pushed object number from stack (X)
C665: BD B5 80    JSR    $B580		; [breakpoint]
C668: 26 01       BNE    $C66B
C66A: 39          RTS
C66B: 86 20       LDA    #$20
C66D: A7 04       STA    $4,X
C66F: A6 45       LDA    $5,U
C671: A7 05       STA    $5,X
C673: EC 5A       LDD    -$6,U
C675: E3 A1       ADDD   ,Y++
C677: ED 1A       STD    -$6,X
C679: EC 5C       LDD    -$4,U
C67B: E3 A1       ADDD   ,Y++
C67D: ED 1C       STD    -$4,X
C67F: EC A4       LDD    ,Y
C681: ED 16       STD    -$A,X
C683: CC FF E0    LDD    #$FFE0
C686: ED 18       STD    -$8,X
C688: CC FF FE    LDD    #$FFFE
C68B: ED 12       STD    -$E,X
C68D: 0C 36       INC    $36
C68F: 0C 3A       INC    $3A
C691: A6 84       LDA    ,X
C693: 84 7F       ANDA   #$7F
C695: A7 84       STA    ,X
C697: E6 07       LDB    $7,X
C699: E7 01       STB    $1,X
C69B: 7E B5 AE    JMP    $B5AE
C69E: 34 10       PSHS   X
C6A0: 96 30       LDA    $30
C6A2: 9B 31       ADDA   $31
C6A4: 81 28       CMPA   #$28
C6A6: 24 16       BCC    $C6BE
C6A8: 10 8E C7 0F LDY    #$C70F
C6AC: 8D B5       BSR    $C663
C6AE: 27 0E       BEQ    $C6BE
C6B0: 10 8E C7 1A LDY    #$C71A
C6B4: 8D AD       BSR    $C663
C6B6: 27 06       BEQ    $C6BE
C6B8: 10 8E C7 25 LDY    #$C725
C6BC: 8D A5       BSR    $C663
C6BE: 35 10       PULS   X
C6C0: 10 8E C7 30 LDY    #$C730
C6C4: EC 1A       LDD    -$6,X
C6C6: E3 A1       ADDD   ,Y++
C6C8: ED 1A       STD    -$6,X
C6CA: EC 1C       LDD    -$4,X
C6CC: E3 A1       ADDD   ,Y++
C6CE: ED 1C       STD    -$4,X
C6D0: EC A1       LDD    ,Y++
C6D2: ED 16       STD    -$A,X
C6D4: CC FF E0    LDD    #$FFE0
C6D7: ED 18       STD    -$8,X
C6D9: EC A4       LDD    ,Y
C6DB: ED 02       STD    $2,X
C6DD: C6 6E       LDB    #$6E
C6DF: E7 07       STB    $7,X
C6E1: E7 01       STB    $1,X
C6E3: 7E B5 AE    JMP    $B5AE

C738: 6A 0A       DEC    $A,X
C73A: 27 01       BEQ    $C73D
C73C: 39          RTS

C73D: CE C7 45    LDU    #jump_table_c745
C740: A6 09       LDA    $9,X
C742: 48          ASLA
C743: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=4]

C74D: CE E1 5A    LDU    #$E15A
C750: 7E B5 FD    JMP    $B5FD
C753: 86 FF       LDA    #$FF
C755: A7 84       STA    ,X
C757: 0A 30       DEC    $30
C759: 0A 36       DEC    $36
C75B: 0A 32       DEC    $32
C75D: 0A 38       DEC    $38
C75F: 39          RTS
C760: CC FF FE    LDD    #$FFFE
C763: ED 12       STD    -$E,X
C765: 7E B5 AE    JMP    $B5AE
C768: CE C7 70    LDU    #jump_table_c770
C76B: A6 09       LDA    $9,X
C76D: 48          ASLA
C76E: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=12]

C788: BD BA 8D    JSR    $BA8D
C78B: 2A 01       BPL    $C78E
C78D: 39          RTS
C78E: 27 11       BEQ    $C7A1
C790: A6 01       LDA    $1,X
C792: 88 03       EORA   #$03
C794: A7 01       STA    $1,X
C796: A7 07       STA    $7,X
C798: EC 16       LDD    -$A,X
C79A: 53          COMB
C79B: 43          COMA
C79C: C3 00 01    ADDD   #$0001
C79F: ED 16       STD    -$A,X
C7A1: BD BB D1    JSR    $BBD1
C7A4: 26 15       BNE    $C7BB
C7A6: 6A 0A       DEC    $A,X
C7A8: 27 01       BEQ    $C7AB
C7AA: 39          RTS
C7AB: A6 09       LDA    $9,X
C7AD: 81 06       CMPA   #$06
C7AF: 26 04       BNE    $C7B5
C7B1: 86 03       LDA    #$03
C7B3: ED 09       STD    $9,X
C7B5: CE E1 6A    LDU    #$E16A
C7B8: 7E B5 FD    JMP    $B5FD
C7BB: 86 06       LDA    #$06
C7BD: A7 09       STA    $9,X
C7BF: CE E1 6A    LDU    #$E16A
C7C2: 7E B5 FD    JMP    $B5FD
C7C5: 6A 0A       DEC    $A,X
C7C7: 27 01       BEQ    $C7CA
C7C9: 39          RTS
C7CA: CE E1 6A    LDU    #$E16A
C7CD: 7E B5 FD    JMP    $B5FD
C7D0: 6A 0A       DEC    $A,X
C7D2: 27 01       BEQ    $C7D5
C7D4: 39          RTS
C7D5: C6 28       LDB    #$28
C7D7: 7E B8 8E    JMP    $B88E
C7DA: 86 03       LDA    #$03
C7DC: A7 08       STA    $8,X
C7DE: 7E B5 AE    JMP    $B5AE
C7E1: 6A 0A       DEC    $A,X
C7E3: 27 01       BEQ    $C7E6
C7E5: 39          RTS
C7E6: CE C7 EE    LDU    #jump_table_c7ee
C7E9: A6 09       LDA    $9,X
C7EB: 48          ASLA
C7EC: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=4]
C7F6: A6 01       LDA    $1,X
C7F8: 88 03       EORA   #$03
C7FA: A7 01       STA    $1,X
C7FC: A7 07       STA    $7,X
C7FE: CE E1 9A    LDU    #$E19A
C801: 7E B5 FD    JMP    $B5FD
C804: 6D 08       TST    $8,X
C806: 26 19       BNE    $C821
C808: A6 0D       LDA    $D,X
C80A: 85 10       BITA   #$10
C80C: 26 0A       BNE    $C818
C80E: E6 01       LDB    $1,X
C810: C4 02       ANDB   #$02
C812: 26 09       BNE    $C81D
C814: 85 04       BITA   #$04
C816: 27 09       BEQ    $C821
C818: C6 20       LDB    #$20
C81A: 7E B8 8E    JMP    $B88E
C81D: 85 04       BITA   #$04
C81F: 27 F7       BEQ    $C818
C821: CE E1 9A    LDU    #$E19A
C824: 7E B5 FD    JMP    $B5FD
C827: 6D 08       TST    $8,X
C829: 26 19       BNE    $C844
C82B: A6 0D       LDA    $D,X
C82D: 85 10       BITA   #$10
C82F: 26 0A       BNE    $C83B
C831: E6 01       LDB    $1,X
C833: C4 02       ANDB   #$02
C835: 26 09       BNE    $C840
C837: 85 04       BITA   #$04
C839: 27 09       BEQ    $C844
C83B: C6 20       LDB    #$20
C83D: 7E B8 8E    JMP    $B88E
C840: 85 04       BITA   #$04
C842: 27 F7       BEQ    $C83B
C844: 6A 08       DEC    $8,X
C846: 86 FF       LDA    #$FF
C848: A7 09       STA    $9,X
C84A: CE E1 9A    LDU    #$E19A
C84D: 7E B5 FD    JMP    $B5FD
C850: 10 8E 53 80 LDY    #$5380
C854: 96 E2       LDA    $E2
C856: C6 62       LDB    #$62
C858: E7 A6       STB    A,Y
C85A: 4C          INCA
C85B: 84 1F       ANDA   #$1F
C85D: 97 E2       STA    $E2
C85F: CE 54 5C    LDU    #$545C
C862: CC 00 80    LDD    #$0080
C865: BD 98 EF    JSR    $98EF
C868: A6 07       LDA    $7,X
C86A: 88 03       EORA   #$03
C86C: A7 07       STA    $7,X
C86E: 7E B5 AE    JMP    $B5AE
C871: 6A 0A       DEC    $A,X
C873: 27 01       BEQ    $C876
C875: 39          RTS
C876: A6 09       LDA    $9,X
C878: 81 03       CMPA   #$03
C87A: 27 06       BEQ    $C882
C87C: CE E1 EA    LDU    #$E1EA
C87F: 7E B5 FD    JMP    $B5FD
C882: 86 FF       LDA    #$FF
C884: A7 84       STA    ,X
C886: 0A 32       DEC    $32
C888: 0A 38       DEC    $38
C88A: 0A 30       DEC    $30
C88C: 0A 36       DEC    $36
C88E: 39          RTS
C88F: 86 05       LDA    #$05
C891: A7 08       STA    $8,X
C893: CC 00 04    LDD    #$0004
C896: ED 18       STD    -$8,X
C898: CC 00 04    LDD    #$0004
C89B: ED 12       STD    -$E,X
C89D: 7E B5 AE    JMP    $B5AE
C8A0: CE C8 A8    LDU    #jump_table_c8a8
C8A3: A6 09       LDA    $9,X
C8A5: 48          ASLA
C8A6: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=6]
C8B4: 6A 0A       DEC    $A,X
C8B6: 27 01       BEQ    $C8B9
C8B8: 39          RTS
C8B9: CE E1 AA    LDU    #$E1AA
C8BC: 7E B5 FD    JMP    $B5FD
C8BF: 6A 0A       DEC    $A,X
C8C1: 27 01       BEQ    $C8C4
C8C3: 39          RTS
C8C4: 6A 08       DEC    $8,X
C8C6: 27 04       BEQ    $C8CC
C8C8: 86 FF       LDA    #$FF
C8CA: A7 09       STA    $9,X
C8CC: CE E1 AA    LDU    #$E1AA
C8CF: 7E B5 FD    JMP    $B5FD
C8D2: BD BB D1    JSR    $BBD1
C8D5: EC 1C       LDD    -$4,X
C8D7: 10 83 09 00 CMPD   #$0900
C8DB: 2C 01       BGE    $C8DE
C8DD: 39          RTS
C8DE: CC 00 40    LDD    #$0040
C8E1: ED 18       STD    -$8,X
C8E3: CC FF F8    LDD    #$FFF8
C8E6: ED 12       STD    -$E,X
C8E8: CE E1 AA    LDU    #$E1AA
C8EB: 7E B5 FD    JMP    $B5FD
C8EE: BD BB D1    JSR    $BBD1
C8F1: 6A 0A       DEC    $A,X
C8F3: 27 01       BEQ    $C8F6
C8F5: 39          RTS
C8F6: CC FF FC    LDD    #$FFFC
C8F9: ED 12       STD    -$E,X
C8FB: A6 01       LDA    $1,X
C8FD: 84 02       ANDA   #$02
C8FF: 26 0B       BNE    $C90C
C901: CC 00 10    LDD    #$0010
C904: ED 16       STD    -$A,X
C906: CE E1 AA    LDU    #$E1AA
C909: 7E B5 FD    JMP    $B5FD
C90C: CC FF F0    LDD    #$FFF0
C90F: ED 16       STD    -$A,X
C911: CE E1 AA    LDU    #$E1AA
C914: 7E B5 FD    JMP    $B5FD
C917: BD BA 8D    JSR    $BA8D
C91A: 2A 01       BPL    $C91D
C91C: 39          RTS
C91D: BD BB D1    JSR    $BBD1
C920: 6A 0A       DEC    $A,X
C922: 27 01       BEQ    $C925
C924: 39          RTS
C925: CC 00 00    LDD    #$0000
C928: ED 12       STD    -$E,X
C92A: A6 01       LDA    $1,X
C92C: 84 02       ANDA   #$02
C92E: 26 0B       BNE    $C93B
C930: CC 00 20    LDD    #$0020
C933: ED 16       STD    -$A,X
C935: CE E1 AA    LDU    #$E1AA
C938: 7E B5 FD    JMP    $B5FD
C93B: CC FF E0    LDD    #$FFE0
C93E: ED 16       STD    -$A,X
C940: CE E1 AA    LDU    #$E1AA
C943: 7E B5 FD    JMP    $B5FD
C946: BD BA 8D    JSR    $BA8D
C949: 2A 01       BPL    $C94C
C94B: 39          RTS
C94C: BD BB D1    JSR    $BBD1
C94F: 6A 0A       DEC    $A,X
C951: 27 01       BEQ    $C954
C953: 39          RTS
C954: 10 8E 53 80 LDY    #$5380
C958: 96 E2       LDA    $E2
C95A: C6 62       LDB    #$62
C95C: E7 A6       STB    A,Y
C95E: 4C          INCA
C95F: 84 1F       ANDA   #$1F
C961: 97 E2       STA    $E2
C963: C6 04       LDB    #$04
C965: 7E B8 8E    JMP    $B88E
C968: 10 8E 53 40 LDY    #$5340
C96C: 96 E0       LDA    $E0
C96E: C6 08       LDB    #$08
C970: E7 A6       STB    A,Y
C972: 4C          INCA
C973: 84 1F       ANDA   #$1F
C975: 97 E0       STA    $E0
C977: CE C9 9F    LDU    #$C99F
C97A: A6 03       LDA    $3,X
C97C: 84 30       ANDA   #$30
C97E: 44          LSRA
C97F: 44          LSRA
C980: A7 E2       STA    ,-S    ; [local]
C982: A6 07       LDA    $7,X
C984: 84 02       ANDA   #$02
C986: AB E0       ADDA   ,S+		; [local]
C988: 44          LSRA
C989: C6 05       LDB    #$05
C98B: 3D          MUL
C98C: 33 C5       LEAU   B,U
C98E: EC C1       LDD    ,U++
C990: ED 16       STD    -$A,X
C992: ED 18       STD    -$8,X
C994: EC C1       LDD    ,U++
C996: ED 12       STD    -$E,X
C998: A6 C0       LDA    ,U+
C99A: A7 08       STA    $8,X
C99C: 7E B5 AE    JMP    $B5AE

C9C7: BD BA 8D    JSR    $BA8D
C9CA: 2A 01       BPL    $C9CD
C9CC: 39          RTS

C9CD: 26 63       BNE    $CA32
C9CF: EC 18       LDD    -$8,X
C9D1: 26 1F       BNE    $C9F2
C9D3: 6D 08       TST    $8,X
C9D5: 27 04       BEQ    $C9DB
C9D7: 6A 08       DEC    $8,X
C9D9: 20 17       BRA    $C9F2
C9DB: A6 0D       LDA    $D,X
C9DD: 85 10       BITA   #$10
C9DF: 26 11       BNE    $C9F2
C9E1: 6D 16       TST    -$A,X
C9E3: 2B 09       BMI    $C9EE
C9E5: 85 04       BITA   #$04
C9E7: 27 09       BEQ    $C9F2
C9E9: C6 44       LDB    #$44
C9EB: 7E B8 8E    JMP    $B88E
C9EE: 85 04       BITA   #$04
C9F0: 27 F7       BEQ    $C9E9
C9F2: 6D 16       TST    -$A,X
C9F4: 2A 0A       BPL    $CA00
C9F6: EC 1A       LDD    -$6,X
C9F8: 10 83 02 00 CMPD   #$0200
C9FC: 2D 34       BLT    $CA32
C9FE: 20 08       BRA    $CA08
CA00: EC 1A       LDD    -$6,X
CA02: 10 83 10 00 CMPD   #$1000
CA06: 2E 2A       BGT    $CA32
CA08: 8D 47       BSR    $CA51
CA0A: 6A 0A       DEC    $A,X
CA0C: 27 01       BEQ    $CA0F
CA0E: 39          RTS
CA0F: A6 09       LDA    $9,X
CA11: 81 02       CMPA   #$02
CA13: 27 08       BEQ    $CA1D
CA15: 81 05       CMPA   #$05
CA17: 26 13       BNE    $CA2C
CA19: 86 FF       LDA    #$FF
CA1B: A7 09       STA    $9,X
CA1D: 10 8E 53 40 LDY    #$5340
CA21: 96 E0       LDA    $E0
CA23: C6 08       LDB    #$08
CA25: E7 A6       STB    A,Y
CA27: 4C          INCA
CA28: 84 1F       ANDA   #$1F
CA2A: 97 E0       STA    $E0
CA2C: CE E1 C2    LDU    #$E1C2
CA2F: 7E B5 FD    JMP    $B5FD
CA32: C6 48       LDB    #$48
CA34: 7E B8 8E    JMP    $B88E
CA37: 7E B5 AE    JMP    $B5AE
CA3A: 6A 0A       DEC    $A,X
CA3C: 27 01       BEQ    $CA3F
CA3E: 39          RTS
CA3F: CE CA 47    LDU    #jump_table_ca47
CA42: A6 09       LDA    $9,X
CA44: 48          ASLA
CA45: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=6]

CA51: BD BB D1    JSR    $BBD1
CA54: EC 18       LDD    -$8,X
CA56: 2A 05       BPL    $CA5D
CA58: 53          COMB
CA59: 43          COMA
CA5A: C3 00 01    ADDD   #$0001
CA5D: ED E3       STD    ,--S		; [local]
CA5F: CE CA 7B    LDU    #$CA7B
CA62: A6 03       LDA    $3,X
CA64: 84 30       ANDA   #$30
CA66: 44          LSRA
CA67: 44          LSRA
CA68: 44          LSRA
CA69: EC C6       LDD    A,U
CA6B: 10 A3 E1    CMPD   ,S++		; [local]
CA6E: 27 01       BEQ    $CA71
CA70: 39          RTS
CA71: EC 12       LDD    -$E,X
CA73: 53          COMB
CA74: 43          COMA
CA75: C3 00 01    ADDD   #$0001
CA78: ED 12       STD    -$E,X
CA7A: 39          RTS

CA83: 8D CC       BSR    $CA51
CA85: CE E1 FA    LDU    #$E1FA
CA88: 7E B5 FD    JMP    $B5FD
CA8B: 8D C4       BSR    $CA51
CA8D: A6 01       LDA    $1,X
CA8F: 88 03       EORA   #$03
CA91: A7 01       STA    $1,X
CA93: A7 07       STA    $7,X
CA95: EC 16       LDD    -$A,X
CA97: 53          COMB
CA98: 43          COMA
CA99: C3 00 01    ADDD   #$0001
CA9C: ED 16       STD    -$A,X
CA9E: CE E1 FA    LDU    #$E1FA
CAA1: 7E B5 FD    JMP    $B5FD
CAA4: BD BA 8D    JSR    $BA8D
CAA7: 2A 01       BPL    $CAAA
CAA9: 39          RTS
CAAA: 8D A5       BSR    $CA51
CAAC: CE E1 FA    LDU    #$E1FA
CAAF: 7E B5 FD    JMP    $B5FD
CAB2: BD BA 8D    JSR    $BA8D
CAB5: 2A 01       BPL    $CAB8
CAB7: 39          RTS
CAB8: 8D 97       BSR    $CA51
CABA: E6 01       LDB    $1,X
CABC: C4 03       ANDB   #$03
CABE: CA 04       ORB    #$04
CAC0: E7 07       STB    $7,X
CAC2: 7E B5 AE    JMP    $B5AE
CAC5: A6 03       LDA    $3,X
CAC7: 84 30       ANDA   #$30
CAC9: 44          LSRA
CACA: 44          LSRA
CACB: 44          LSRA
CACC: 44          LSRA
CACD: 8B 03       ADDA   #$03
CACF: A7 18       STA    -$8,X
CAD1: 10 8E 53 80 LDY    #$5380
CAD5: 96 E2       LDA    $E2
CAD7: C6 62       LDB    #$62
CAD9: E7 A6       STB    A,Y
CADB: 4C          INCA
CADC: 84 1F       ANDA   #$1F
CADE: 97 E2       STA    $E2
CAE0: C6 01       LDB    #$01
CAE2: E7 08       STB    $8,X
CAE4: 7E B5 AE    JMP    $B5AE
CAE7: CE CA F3    LDU    #jump_table_caf3
CAEA: A6 0D       LDA    $D,X
CAEC: 84 30       ANDA   #$30
CAEE: 44          LSRA
CAEF: 44          LSRA
CAF0: 44          LSRA
CAF1: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=4]

CAFB: 8D 5D       BSR    $CB5A
CAFD: 6A 0A       DEC    $A,X
CAFF: 27 01       BEQ    $CB02
CB01: 39          RTS
CB02: A6 08       LDA    $8,X
CB04: A1 18       CMPA   -$8,X
CB06: 24 03       BCC    $CB0B
CB08: 4C          INCA
CB09: A7 08       STA    $8,X
CB0B: A6 09       LDA    $9,X
CB0D: 81 03       CMPA   #$03
CB0F: 26 13       BNE    $CB24
CB11: 10 8E 53 80 LDY    #$5380
CB15: 96 E2       LDA    $E2
CB17: C6 62       LDB    #$62
CB19: E7 A6       STB    A,Y
CB1B: 4C          INCA
CB1C: 84 1F       ANDA   #$1F
CB1E: 97 E2       STA    $E2
CB20: 86 FF       LDA    #$FF
CB22: A7 09       STA    $9,X
CB24: CE E1 DA    LDU    #$E1DA
CB27: 7E B5 FD    JMP    $B5FD
CB2A: 8D 2E       BSR    $CB5A
CB2C: A6 08       LDA    $8,X
CB2E: 81 01       CMPA   #$01
CB30: 23 03       BLS    $CB35
CB32: 4A          DECA
CB33: A7 08       STA    $8,X
CB35: 6A 0A       DEC    $A,X
CB37: 27 01       BEQ    $CB3A
CB39: 39          RTS
CB3A: A6 09       LDA    $9,X
CB3C: 81 03       CMPA   #$03
CB3E: 26 13       BNE    $CB53
CB40: 10 8E 53 80 LDY    #$5380
CB44: 96 E2       LDA    $E2
CB46: C6 62       LDB    #$62
CB48: E7 A6       STB    A,Y
CB4A: 4C          INCA
CB4B: 84 1F       ANDA   #$1F
CB4D: 97 E2       STA    $E2
CB4F: 86 FF       LDA    #$FF
CB51: A7 09       STA    $9,X
CB53: CE E1 DA    LDU    #$E1DA
CB56: 7E B5 FD    JMP    $B5FD
CB59: 39          RTS
CB5A: CE 44 10    LDU    #$4410
CB5D: 32 7B       LEAS   -$5,S	; [alloc_locals]
CB5F: A6 08       LDA    $8,X
CB61: A7 E4       STA    ,S		; [local]
CB63: EC 1C       LDD    -$4,X
CB65: A3 5C       SUBD   -$4,U
CB67: C4 F0       ANDB   #$F0
CB69: ED 63       STD    $3,S		; [local]
CB6B: EC 1A       LDD    -$6,X
CB6D: A3 5A       SUBD   -$6,U
CB6F: C4 F0       ANDB   #$F0
CB71: ED 61       STD    $1,S		; [local]
CB73: 2A 05       BPL    $CB7A
CB75: 53          COMB
CB76: 43          COMA
CB77: C3 00 01    ADDD   #$0001
CB7A: ED E3       STD    ,--S		; [local]
CB7C: EC 65       LDD    $5,S		; [local]
CB7E: 2A 05       BPL    $CB85
CB80: 53          COMB
CB81: 43          COMA
CB82: C3 00 01    ADDD   #$0001
CB85: 10 A3 E1    CMPD   ,S++		; [local]
CB88: 27 2E       BEQ    $CBB8
CB8A: 22 16       BHI    $CBA2
CB8C: 6D 61       TST    $1,S		; [local]
CB8E: 2A 09       BPL    $CB99
CB90: EC 1A       LDD    -$6,X
CB92: C3 00 10    ADDD   #$0010
CB95: ED 1A       STD    -$6,X
CB97: 20 47       BRA    $CBE0
CB99: EC 1A       LDD    -$6,X
CB9B: 83 00 10    SUBD   #$0010
CB9E: ED 1A       STD    -$6,X
CBA0: 20 3E       BRA    $CBE0
CBA2: 6D 63       TST    $3,S		; [local]
CBA4: 2A 09       BPL    $CBAF
CBA6: EC 1C       LDD    -$4,X
CBA8: C3 00 10    ADDD   #$0010
CBAB: ED 1C       STD    -$4,X
CBAD: 20 31       BRA    $CBE0
CBAF: EC 1C       LDD    -$4,X
CBB1: 83 00 10    SUBD   #$0010
CBB4: ED 1C       STD    -$4,X
CBB6: 20 28       BRA    $CBE0
CBB8: 6D 61       TST    $1,S		; [local]
CBBA: 2A 09       BPL    $CBC5
CBBC: EC 1A       LDD    -$6,X
CBBE: C3 00 10    ADDD   #$0010
CBC1: ED 1A       STD    -$6,X
CBC3: 20 07       BRA    $CBCC
CBC5: EC 1A       LDD    -$6,X
CBC7: 83 00 10    SUBD   #$0010
CBCA: ED 1A       STD    -$6,X
CBCC: 6D 63       TST    $3,S		; [local]
CBCE: 2A 09       BPL    $CBD9
CBD0: EC 1C       LDD    -$4,X
CBD2: C3 00 10    ADDD   #$0010
CBD5: ED 1C       STD    -$4,X
CBD7: 20 07       BRA    $CBE0
CBD9: EC 1C       LDD    -$4,X
CBDB: 83 00 10    SUBD   #$0010
CBDE: ED 1C       STD    -$4,X
CBE0: 6A E4       DEC    ,S    ; [local]
CBE2: 10 26 FF 7D LBNE   $CB63
CBE6: 32 65       LEAS   $5,S	; [free_locals]
CBE8: 39          RTS

CBE9: BD BC 9C    JSR    $BC9C
CBEC: 27 08       BEQ    $CBF6
CBEE: EC 1C       LDD    -$4,X
CBF0: 83 00 20    SUBD   #$0020
CBF3: ED 1C       STD    -$4,X
CBF5: 39          RTS
CBF6: C6 20       LDB    #$20
CBF8: 7E B8 8E    JMP    $B88E

CBFB: CC 00 00    LDD    #$0000
CBFE: ED 18       STD    -$8,X
CC00: CE CC 1C    LDU    #$CC1C
CC03: A6 03       LDA    $3,X
CC05: 84 30       ANDA   #$30
CC07: 44          LSRA
CC08: 44          LSRA
CC09: A7 E2       STA    ,-S    ; [local]
CC0B: A6 07       LDA    $7,X
CC0D: 84 02       ANDA   #$02
CC0F: AB E0       ADDA   ,S+		; [local]
CC11: EC C6       LDD    A,U
CC13: A7 08       STA    $8,X
CC15: 5D          TSTB
CC16: 1D          SEX
CC17: ED 16       STD    -$A,X
CC19: 7E B5 AE    JMP    $B5AE

CC2C: BD BA 8D    JSR    $BA8D
CC2F: 27 01       BEQ    $CC32
CC31: 39          RTS

CC32: BD BC 9C    JSR    $BC9C
CC35: 10 26 EC 55 LBNE   $B88E
CC39: BD CC DC    JSR    $CCDC
CC3C: 10 26 EC 4E LBNE   $B88E
CC40: BD CC 61    JSR    $CC61
CC43: 27 01       BEQ    $CC46
CC45: 39          RTS
CC46: 6A 0A       DEC    $A,X
CC48: 27 01       BEQ    $CC4B
CC4A: 39          RTS
CC4B: A6 09       LDA    $9,X
CC4D: 81 05       CMPA   #$05
CC4F: 26 0A       BNE    $CC5B
CC51: 86 FF       LDA    #$FF
CC53: A7 09       STA    $9,X
CC55: A6 0C       LDA    $C,X
CC57: 84 DF       ANDA   #$DF
CC59: A7 0C       STA    $C,X
CC5B: CE DF 22    LDU    #$DF22
CC5E: 7E B5 FD    JMP    $B5FD
CC61: A6 0C       LDA    $C,X
CC63: 85 20       BITA   #$20
CC65: 26 49       BNE    $CCB0
CC67: E6 0D       LDB    $D,X
CC69: C5 01       BITB   #$01
CC6B: 26 4D       BNE    $CCBA
CC6D: C5 20       BITB   #$20
CC6F: 27 1B       BEQ    $CC8C
CC71: 6A 08       DEC    $8,X
CC73: 26 3B       BNE    $CCB0
CC75: C5 04       BITB   #$04
CC77: 26 0B       BNE    $CC84
CC79: A6 01       LDA    $1,X
CC7B: 85 02       BITA   #$02
CC7D: 26 23       BNE    $CCA2
CC7F: C6 38       LDB    #$38
CC81: 7E B8 8E    JMP    $B88E
CC84: A6 01       LDA    $1,X
CC86: 85 02       BITA   #$02
CC88: 26 F5       BNE    $CC7F
CC8A: 20 16       BRA    $CCA2
CC8C: A6 03       LDA    $3,X
CC8E: 85 40       BITA   #$40
CC90: 26 04       BNE    $CC96
CC92: 6A 08       DEC    $8,X
CC94: 26 1A       BNE    $CCB0
CC96: C5 08       BITB   #$08
CC98: 26 18       BNE    $CCB2
CC9A: C6 2C       LDB    #$2C
CC9C: BD B8 8E    JSR    $B88E
CC9F: 27 01       BEQ    $CCA2
CCA1: 39          RTS
CCA2: CE CC 1C    LDU    #$CC1C
CCA5: A6 03       LDA    $3,X
CCA7: 84 30       ANDA   #$30
CCA9: 44          LSRA
CCAA: 44          LSRA
CCAB: 44          LSRA
CCAC: A6 C6       LDA    A,U
CCAE: A7 08       STA    $8,X
CCB0: 5F          CLRB
CCB1: 39          RTS
CCB2: C6 28       LDB    #$28
CCB4: BD B8 8E    JSR    $B88E
CCB7: 27 E9       BEQ    $CCA2
CCB9: 39          RTS
CCBA: 6D 0D       TST    $D,X
CCBC: 2B 10       BMI    $CCCE
CCBE: EC 1A       LDD    -$6,X
CCC0: B3 44 0A    SUBD   $440A
CCC3: 2A 05       BPL    $CCCA
CCC5: 53          COMB
CCC6: 43          COMA
CCC7: C3 00 01    ADDD   #$0001
CCCA: 81 05       CMPA   #$05
CCCC: 27 09       BEQ    $CCD7
CCCE: 6A 08       DEC    $8,X
CCD0: 26 DE       BNE    $CCB0
CCD2: C6 18       LDB    #$18
CCD4: 7E B8 8E    JMP    $B88E
CCD7: C6 44       LDB    #$44
CCD9: 7E B8 8E    JMP    $B88E
CCDC: A6 02       LDA    $2,X
CCDE: 84 20       ANDA   #$20
CCE0: 26 01       BNE    $CCE3
CCE2: 39          RTS
CCE3: A6 1B       LDA    -$5,X
CCE5: 84 F0       ANDA   #$F0
CCE7: 27 02       BEQ    $CCEB
CCE9: 5F          CLRB
CCEA: 39          RTS
CCEB: 96 53       LDA    $53
CCED: 26 01       BNE    $CCF0
CCEF: 39          RTS
CCF0: 97 54       STA    $54
CCF2: CE 50 00    LDU    #$5000
CCF5: A6 C4       LDA    ,U
CCF7: 2B 56       BMI    $CD4F
CCF9: 81 43       CMPA   #$43
CCFB: 27 08       BEQ    $CD05
CCFD: 84 FC       ANDA   #$FC
CCFF: 81 40       CMPA   #$40
CD01: 27 47       BEQ    $CD4A
CD03: 20 4A       BRA    $CD4F
CD05: EC 4A       LDD    $A,U
CD07: C3 00 E0    ADDD   #$00E0
CD0A: A3 1A       SUBD   -$6,X
CD0C: 2A 05       BPL    $CD13
CD0E: 53          COMB
CD0F: 43          COMA
CD10: C3 00 01    ADDD   #$0001
CD13: 10 83 00 80 CMPD   #$0080
CD17: 24 31       BCC    $CD4A
CD19: A6 44       LDA    $4,U
CD1B: A1 05       CMPA   $5,X
CD1D: 27 16       BEQ    $CD35
CD1F: 10 8E CD 56 LDY    #$CD56
CD23: EC 4C       LDD    $C,U
CD25: A3 1C       SUBD   -$4,X
CD27: A3 A4       SUBD   ,Y
CD29: 26 1F       BNE    $CD4A
CD2B: 96 0E       LDA    $0E
CD2D: 84 01       ANDA   #$01
CD2F: 26 01       BNE    $CD32
CD31: 39          RTS
CD32: C6 AC       LDB    #$AC
CD34: 39          RTS
CD35: 10 8E CD 54 LDY    #$CD54
CD39: A6 41       LDA    $1,U
CD3B: 84 04       ANDA   #$04
CD3D: 44          LSRA
CD3E: 31 A6       LEAY   A,Y
CD40: EC 4C       LDD    $C,U
CD42: A3 1C       SUBD   -$4,X
CD44: A3 A4       SUBD   ,Y
CD46: 26 02       BNE    $CD4A
CD48: 5F          CLRB
CD49: 39          RTS
CD4A: 0A 54       DEC    $54
CD4C: 26 01       BNE    $CD4F
CD4E: 39          RTS
CD4F: 33 C8 10    LEAU   $10,U
CD52: 20 A1       BRA    $CCF5
CD54: 04 70       LSR    $70
CD56: 03 F0       COM    $F0
CD58: CC 00 60    LDD    #$0060
CD5B: ED 18       STD    -$8,X
CD5D: A6 07       LDA    $7,X
CD5F: 84 02       ANDA   #$02
CD61: 26 08       BNE    $CD6B
CD63: CC 00 30    LDD    #$0030
CD66: ED 16       STD    -$A,X
CD68: 7E B5 AE    JMP    $B5AE
CD6B: CC FF D0    LDD    #$FFD0
CD6E: ED 16       STD    -$A,X
CD70: 7E B5 AE    JMP    $B5AE
CD73: CE CD E7    LDU    #jump_table_cde7
CD76: A6 09       LDA    $9,X
CD78: 48          ASLA
CD79: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=9]
CD7B: 6A 0A       DEC    $A,X
CD7D: 27 01       BEQ    $CD80
CD7F: 39          RTS
CD80: CE E0 62    LDU    #$E062
CD83: 7E B5 FD    JMP    $B5FD
CD86: BD BA 8D    JSR    $BA8D
CD89: 2A 01       BPL    $CD8C
CD8B: 39          RTS
CD8C: BD BB D1    JSR    $BBD1
CD8F: EC 18       LDD    -$8,X
CD91: 10 83 00 20 CMPD   #$0020
CD95: 2F 01       BLE    $CD98
CD97: 39          RTS
CD98: CE E0 62    LDU    #$E062
CD9B: 7E B5 FD    JMP    $B5FD
CD9E: BD BA 8D    JSR    $BA8D
CDA1: 2A 01       BPL    $CDA4
CDA3: 39          RTS
CDA4: BD BB D1    JSR    $BBD1
CDA7: 26 0F       BNE    $CDB8
CDA9: EC 18       LDD    -$8,X
CDAB: 10 83 FF E0 CMPD   #$FFE0
CDAF: 2F 01       BLE    $CDB2
CDB1: 39          RTS
CDB2: CE E0 62    LDU    #$E062
CDB5: 7E B5 FD    JMP    $B5FD
CDB8: 6C 09       INC    $9,X
CDBA: CE E0 62    LDU    #$E062
CDBD: 7E B5 FD    JMP    $B5FD
CDC0: BD BA 8D    JSR    $BA8D
CDC3: 2A 01       BPL    $CDC6
CDC5: 39          RTS
CDC6: BD BB D1    JSR    $BBD1
CDC9: 26 01       BNE    $CDCC
CDCB: 39          RTS
CDCC: CE E0 62    LDU    #$E062
CDCF: 7E B5 FD    JMP    $B5FD
CDD2: 6A 0A       DEC    $A,X
CDD4: 27 01       BEQ    $CDD7
CDD6: 39          RTS
CDD7: A6 0D       LDA    $D,X
CDD9: 85 31       BITA   #$31
CDDB: 26 05       BNE    $CDE2
CDDD: C6 38       LDB    #$38
CDDF: 7E B8 8E    JMP    $B88E
CDE2: C6 04       LDB    #$04
CDE4: 7E B8 8E    JMP    $B88E

CDFA: ED 18       STD    -$8,X
CDFC: A6 01       LDA    $1,X
CDFE: 84 02       ANDA   #$02
CE00: 26 08       BNE    $CE0A
CE02: CC 00 30    LDD    #$0030
CE05: ED 16       STD    -$A,X
CE07: 7E B5 AE    JMP    $B5AE
CE0A: CC FF D0    LDD    #$FFD0
CE0D: ED 16       STD    -$A,X
CE0F: 7E B5 AE    JMP    $B5AE
CE12: CE 53 E0    LDU    #$53E0
CE15: CC 00 FF    LDD    #$00FF
CE18: BD BB 6E    JSR    $BB6E
CE1B: 81 23       CMPA   #$23
CE1D: 27 12       BEQ    $CE31
CE1F: 81 2F       CMPA   #$2F
CE21: 27 0E       BEQ    $CE31
CE23: CC 00 90    LDD    #$0090
CE26: ED 18       STD    -$8,X
CE28: A6 0C       LDA    $C,X
CE2A: 84 ED       ANDA   #$ED
CE2C: A7 0C       STA    $C,X
CE2E: 7E B5 AE    JMP    $B5AE
CE31: A6 0C       LDA    $C,X
CE33: 8A 20       ORA    #$20
CE35: A7 0C       STA    $C,X
CE37: 4F          CLRA
CE38: 39          RTS

CE39: CE CE 41    LDU    #jump_table_ce41
CE3C: A6 09       LDA    $9,X
CE3E: 48          ASLA
CE3F: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=24]

CE71: 6A 0A       DEC    $A,X
CE73: 27 01       BEQ    $CE76
CE75: 39          RTS

CE76: CE DF BA    LDU    #$DFBA
CE79: 7E B5 FD    JMP    $B5FD
CE7C: BD BB D1    JSR    $BBD1
CE7F: A6 18       LDA    -$8,X
CE81: 27 01       BEQ    $CE84
CE83: 39          RTS
CE84: E6 19       LDB    -$7,X
CE86: C4 F0       ANDB   #$F0
CE88: 27 01       BEQ    $CE8B
CE8A: 39          RTS
CE8B: ED 18       STD    -$8,X
CE8D: A6 0C       LDA    $C,X
CE8F: 84 10       ANDA   #$10
CE91: 26 05       BNE    $CE98
CE93: C6 34       LDB    #$34
CE95: 7E B8 8E    JMP    $B88E
CE98: CE DF BA    LDU    #$DFBA
CE9B: 7E B5 FD    JMP    $B5FD
CE9E: 6A 0A       DEC    $A,X
CEA0: 27 01       BEQ    $CEA3
CEA2: 39          RTS
CEA3: A6 05       LDA    $5,X
CEA5: 81 40       CMPA   #$40
CEA7: 26 0A       BNE    $CEB3
CEA9: 86 80       LDA    #$80
CEAB: A7 05       STA    $5,X
CEAD: CE DF BA    LDU    #$DFBA
CEB0: 7E B5 FD    JMP    $B5FD
CEB3: 86 40       LDA    #$40
CEB5: A7 05       STA    $5,X
CEB7: CE DF BA    LDU    #$DFBA
CEBA: 7E B5 FD    JMP    $B5FD
CEBD: BD BB D1    JSR    $BBD1
CEC0: 26 01       BNE    $CEC3
CEC2: 39          RTS
CEC3: CE DF BA    LDU    #$DFBA
CEC6: 7E B5 FD    JMP    $B5FD
CEC9: 6A 0A       DEC    $A,X
CECB: 27 01       BEQ    $CECE
CECD: 39          RTS
CECE: A6 0C       LDA    $C,X
CED0: 85 01       BITA   #$01
CED2: 26 06       BNE    $CEDA
CED4: E6 0D       LDB    $D,X
CED6: C5 01       BITB   #$01
CED8: 27 09       BEQ    $CEE3
CEDA: 84 FE       ANDA   #$FE
CEDC: A7 0C       STA    $C,X
CEDE: C6 04       LDB    #$04
CEE0: 7E B8 8E    JMP    $B88E
CEE3: 84 FE       ANDA   #$FE
CEE5: A7 0C       STA    $C,X
CEE7: C6 38       LDB    #$38
CEE9: 7E B8 8E    JMP    $B88E
CEEC: CE CF 2E    LDU    #jump_table_cf2e
CEEF: A6 09       LDA    $9,X
CEF1: 48          ASLA
CEF2: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=14]
CEF4: 6A 0A       DEC    $A,X
CEF6: 27 01       BEQ    $CEF9
CEF8: 39          RTS
CEF9: CE DF E2    LDU    #$DFE2
CEFC: 7E B5 FD    JMP    $B5FD
CEFF: BD BB D1    JSR    $BBD1
CF02: 26 01       BNE    $CF05
CF04: 39          RTS
CF05: CE DF E2    LDU    #$DFE2
CF08: 7E B5 FD    JMP    $B5FD

CF0B: 6A 0A       DEC    $A,X
CF0D: 27 01       BEQ    $CF10
CF0F: 39          RTS
CF10: A6 0C       LDA    $C,X
CF12: 85 01       BITA   #$01
CF14: 26 0F       BNE    $CF25
CF16: E6 0D       LDB    $D,X
CF18: C5 01       BITB   #$01
CF1A: 27 09       BEQ    $CF25
CF1C: 8A 20       ORA    #$20
CF1E: A7 0C       STA    $C,X
CF20: C6 04       LDB    #$04
CF22: 7E B8 8E    JMP    $B88E
CF25: 8A 20       ORA    #$20
CF27: A7 0C       STA    $C,X
CF29: C6 48       LDB    #$48
CF2B: 7E B8 8E    JMP    $B88E

CF4A: CE 53 E0    LDU    #$53E0
CF4D: CC 00 03    LDD    #$0003
CF50: BD BB 6E    JSR    $BB6E
CF53: C4 10       ANDB   #$10
CF55: 27 0E       BEQ    $CF65
CF57: CC 00 40    LDD    #$0040
CF5A: ED 18       STD    -$8,X
CF5C: A6 0C       LDA    $C,X
CF5E: 84 FD       ANDA   #$FD
CF60: A7 0C       STA    $C,X
CF62: 7E B5 AE    JMP    $B5AE
CF65: A6 0C       LDA    $C,X
CF67: 8A 20       ORA    #$20
CF69: A7 0C       STA    $C,X
CF6B: 4F          CLRA
CF6C: 39          RTS
CF6D: CE CF 75    LDU    #jump_table_cf75
CF70: A6 09       LDA    $9,X
CF72: 48          ASLA
CF73: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=18]

CF99: 6A 0A       DEC    $A,X
CF9B: 27 01       BEQ    $CF9E
CF9D: 39          RTS

CF9E: CE E0 1A    LDU    #$E01A
CFA1: 7E B5 FD    JMP    $B5FD
CFA4: BD BB D1    JSR    $BBD1
CFA7: EC 18       LDD    -$8,X
CFA9: C4 F0       ANDB   #$F0
CFAB: 10 83 00 00 CMPD   #$0000
CFAF: 27 01       BEQ    $CFB2
CFB1: 39          RTS
CFB2: ED 18       STD    -$8,X
CFB4: EC 1C       LDD    -$4,X
CFB6: C3 00 C0    ADDD   #$00C0
CFB9: ED 1C       STD    -$4,X
CFBB: CE E0 1A    LDU    #$E01A
CFBE: 7E B5 FD    JMP    $B5FD
CFC1: 6A 0A       DEC    $A,X
CFC3: 27 01       BEQ    $CFC6
CFC5: 39          RTS
CFC6: EC 1C       LDD    -$4,X
CFC8: 83 01 C0    SUBD   #$01C0
CFCB: ED 1C       STD    -$4,X
CFCD: A6 05       LDA    $5,X
CFCF: 81 40       CMPA   #$40
CFD1: 27 0A       BEQ    $CFDD
CFD3: 86 40       LDA    #$40
CFD5: A7 05       STA    $5,X
CFD7: CE E0 1A    LDU    #$E01A
CFDA: 7E B5 FD    JMP    $B5FD
CFDD: 86 80       LDA    #$80
CFDF: A7 05       STA    $5,X
CFE1: CE E0 1A    LDU    #$E01A
CFE4: 7E B5 FD    JMP    $B5FD
CFE7: BD BB D1    JSR    $BBD1
CFEA: 26 0B       BNE    $CFF7
CFEC: 6A 0A       DEC    $A,X
CFEE: 27 01       BEQ    $CFF1
CFF0: 39          RTS
CFF1: CE E0 1A    LDU    #$E01A
CFF4: 7E B5 FD    JMP    $B5FD
CFF7: 6C 89 B5 FD INC    -$4A03,X
CFFB: CE E0 1A    LDU    #$E01A
CFFE: 7E B5 FD    JMP    $B5FD
D001: BD BB D1    JSR    $BBD1
D004: 26 01       BNE    $D007
D006: 39          RTS
D007: CE E0 1A    LDU    #$E01A
D00A: 7E B5 FD    JMP    $B5FD
D00D: 6A 0A       DEC    $A,X
D00F: 27 01       BEQ    $D012
D011: 39          RTS
D012: A6 0C       LDA    $C,X
D014: 85 01       BITA   #$01
D016: 26 06       BNE    $D01E
D018: E6 0D       LDB    $D,X
D01A: C5 01       BITB   #$01
D01C: 27 09       BEQ    $D027
D01E: 84 FE       ANDA   #$FE
D020: A7 0C       STA    $C,X
D022: C6 04       LDB    #$04
D024: 7E B8 8E    JMP    $B88E
D027: 84 FE       ANDA   #$FE
D029: A7 0C       STA    $C,X
D02B: C6 38       LDB    #$38
D02D: 7E B8 8E    JMP    $B88E
D030: 6A 0A       DEC    $A,X
D032: 27 01       BEQ    $D035
D034: 39          RTS
D035: CE D0 3D    LDU    #jump_table_d03d
D038: A6 09       LDA    $9,X
D03A: 48          ASLA
D03B: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=7]

D04B: CE DF 4A    LDU    #$DF4A
D04E: 7E B5 FD    JMP    $B5FD
D051: A6 01       LDA    $1,X
D053: 88 03       EORA   #$03
D055: A7 01       STA    $1,X
D057: A7 07       STA    $7,X
D059: CE DF 4A    LDU    #$DF4A
D05C: 7E B5 FD    JMP    $B5FD
D05F: A6 0D       LDA    $D,X
D061: 85 20       BITA   #$20
D063: 27 1D       BEQ    $D082
D065: E6 0C       LDB    $C,X
D067: C4 FB       ANDB   #$FB
D069: E7 0C       STB    $C,X
D06B: 85 01       BITA   #$01
D06D: 26 0A       BNE    $D079
D06F: E6 01       LDB    $1,X
D071: C5 02       BITB   #$02
D073: 26 09       BNE    $D07E
D075: 85 04       BITA   #$04
D077: 27 09       BEQ    $D082
D079: C6 54       LDB    #$54
D07B: 7E B8 8E    JMP    $B88E
D07E: 85 04       BITA   #$04
D080: 27 F7       BEQ    $D079
D082: CE DF 4A    LDU    #$DF4A
D085: 7E B5 FD    JMP    $B5FD
D088: C6 04       LDB    #$04
D08A: 7E B8 8E    JMP    $B88E
D08D: 6A 0A       DEC    $A,X
D08F: 27 01       BEQ    $D092
D091: 39          RTS
D092: CE D0 9A    LDU    #jump_table_d09a
D095: A6 09       LDA    $9,X
D097: 48          ASLA
D098: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=9]

D0AC: A6 01       LDA    $1,X
D0AE: 88 03       EORA   #$03
D0B0: A7 01       STA    $1,X
D0B2: A7 07       STA    $7,X
D0B4: CE DF 7A    LDU    #$DF7A
D0B7: 7E B5 FD    JMP    $B5FD
D0BA: A6 0C       LDA    $C,X
D0BC: 84 FE       ANDA   #$FE
D0BE: A7 0C       STA    $C,X
D0C0: C6 04       LDB    #$04
D0C2: 7E B8 8E    JMP    $B88E
D0C5: 6A 0A       DEC    $A,X
D0C7: 27 01       BEQ    $D0CA
D0C9: 39          RTS
D0CA: A6 09       LDA    $9,X
D0CC: 81 04       CMPA   #$04
D0CE: 27 06       BEQ    $D0D6
D0D0: CE DF 66    LDU    #$DF66
D0D3: 7E B5 FD    JMP    $B5FD
D0D6: C6 18       LDB    #$18
D0D8: 7E B8 8E    JMP    $B88E
D0DB: 96 0E       LDA    $0E
D0DD: 84 04       ANDA   #$04
D0DF: 26 12       BNE    $D0F3
D0E1: 10 8E 53 80 LDY    #$5380
D0E5: 96 E2       LDA    $E2
D0E7: C6 69       LDB    #$69
D0E9: E7 A6       STB    A,Y
D0EB: 4C          INCA
D0EC: 84 1F       ANDA   #$1F
D0EE: 97 E2       STA    $E2
D0F0: 7E B5 AE    JMP    $B5AE
D0F3: 10 8E 53 80 LDY    #$5380
D0F7: 96 E2       LDA    $E2
D0F9: C6 61       LDB    #$61
D0FB: E7 A6       STB    A,Y
D0FD: 4C          INCA
D0FE: 84 1F       ANDA   #$1F
D100: 97 E2       STA    $E2
D102: 7E B5 AE    JMP    $B5AE
D105: 6A 0A       DEC    $A,X
D107: 27 01       BEQ    $D10A
D109: 39          RTS
D10A: CE D1 12    LDU    #jump_table_d112
D10D: A6 09       LDA    $9,X
D10F: 48          ASLA
D110: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=7]

D120: CE DF 9E    LDU    #$DF9E
D123: 7E B5 FD    JMP    $B5FD
D126: C6 04       LDB    #$04
D128: 7E B8 8E    JMP    $B88E
D12B: CC 00 30    LDD    #$0030
D12E: ED 18       STD    -$8,X
D130: 7E B5 AE    JMP    $B5AE
D133: CE D1 3B    LDU    #jump_table_d13b
D136: A6 09       LDA    $9,X
D138: 48          ASLA
D139: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=17]

D15D: 6A 0A       DEC    $A,X
D15F: 27 01       BEQ    $D162
D161: 39          RTS
D162: CE E0 82    LDU    #$E082
D165: 7E B5 FD    JMP    $B5FD
D168: BD BB D1    JSR    $BBD1
D16B: A6 18       LDA    -$8,X
D16D: 27 01       BEQ    $D170
D16F: 39          RTS
D170: E6 19       LDB    -$7,X
D172: C4 F0       ANDB   #$F0
D174: 27 01       BEQ    $D177
D176: 39          RTS
D177: CE E0 82    LDU    #$E082
D17A: 7E B5 FD    JMP    $B5FD
D17D: 6A 0A       DEC    $A,X
D17F: 27 01       BEQ    $D182
D181: 39          RTS
D182: 86 80       LDA    #$80
D184: A7 05       STA    $5,X
D186: CE E0 82    LDU    #$E082
D189: 7E B5 FD    JMP    $B5FD
D18C: BD BB D1    JSR    $BBD1
D18F: 26 01       BNE    $D192
D191: 39          RTS
D192: CE E0 82    LDU    #$E082
D195: 7E B5 FD    JMP    $B5FD
D198: 6A 0A       DEC    $A,X
D19A: 27 01       BEQ    $D19D
D19C: 39          RTS
D19D: A6 0D       LDA    $D,X
D19F: 85 01       BITA   #$01
D1A1: 27 05       BEQ    $D1A8
D1A3: C6 04       LDB    #$04
D1A5: 7E B8 8E    JMP    $B88E
D1A8: E6 03       LDB    $3,X
D1AA: C4 40       ANDB   #$40
D1AC: 26 22       BNE    $D1D0
D1AE: E6 01       LDB    $1,X
D1B0: 84 02       ANDA   #$02
D1B2: 26 09       BNE    $D1BD
D1B4: 85 04       BITA   #$04
D1B6: 26 0E       BNE    $D1C6
D1B8: C6 49       LDB    #$49
D1BA: 7E B8 8E    JMP    $B88E
D1BD: 85 04       BITA   #$04
D1BF: 26 0A       BNE    $D1CB
D1C1: C6 06       LDB    #$06
D1C3: 7E B8 8E    JMP    $B88E
D1C6: C6 05       LDB    #$05
D1C8: 7E B8 8E    JMP    $B88E
D1CB: C6 4A       LDB    #$4A
D1CD: 7E B8 8E    JMP    $B88E
D1D0: 85 20       BITA   #$20
D1D2: 26 0E       BNE    $D1E2
D1D4: 85 08       BITA   #$08
D1D6: 26 05       BNE    $D1DD
D1D8: C6 2C       LDB    #$2C
D1DA: 7E B8 8E    JMP    $B88E
D1DD: C6 28       LDB    #$28
D1DF: 7E B8 8E    JMP    $B88E
D1E2: C6 38       LDB    #$38
D1E4: 7E B8 8E    JMP    $B88E
D1E7: 10 8E 53 80 LDY    #$5380
D1EB: 96 E2       LDA    $E2
D1ED: C6 69       LDB    #$69
D1EF: E7 A6       STB    A,Y
D1F1: 4C          INCA
D1F2: 84 1F       ANDA   #$1F
D1F4: 97 E2       STA    $E2
D1F6: CE 54 5C    LDU    #$545C
D1F9: CC 00 50    LDD    #$0050
D1FC: BD 98 EF    JSR    $98EF
D1FF: A6 07       LDA    $7,X
D201: 88 03       EORA   #$03
D203: A7 07       STA    $7,X
D205: 7E B5 AE    JMP    $B5AE
D208: CE D2 10    LDU    #jump_table_d210
D20B: A6 09       LDA    $9,X
D20D: 48          ASLA
D20E: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=7]

D21E: BD BB D1    JSR    $BBD1
D221: 6A 0A       DEC    $A,X
D223: 27 01       BEQ    $D226
D225: 39          RTS
D226: CE E0 C6    LDU    #$E0C6
D229: 7E B5 FD    JMP    $B5FD
D22C: BD BB D1    JSR    $BBD1
D22F: 26 01       BNE    $D232
D231: 39          RTS
D232: 6A 0A       DEC    $A,X
D234: 27 01       BEQ    $D237
D236: 39          RTS
D237: CE E0 C6    LDU    #$E0C6
D23A: 7E B5 FD    JMP    $B5FD
D23D: 6A 0A       DEC    $A,X
D23F: 27 01       BEQ    $D242
D241: 39          RTS
D242: CE E0 C6    LDU    #$E0C6
D245: 7E B5 FD    JMP    $B5FD
D248: 6A 0A       DEC    $A,X
D24A: 27 01       BEQ    $D24D
D24C: 39          RTS
D24D: 86 FF       LDA    #$FF
D24F: A7 84       STA    ,X
D251: 0A 30       DEC    $30
D253: 0A 36       DEC    $36
D255: 0A 32       DEC    $32
D257: 0A 38       DEC    $38
D259: 39          RTS
D25A: 0D 0D       TST    $0D
D25C: 26 01       BNE    $D25F
D25E: 39          RTS
D25F: 0F 0D       CLR    $0D
D261: A6 09       LDA    $9,X
D263: 81 03       CMPA   #$03
D265: 26 04       BNE    $D26B
D267: 86 FF       LDA    #$FF
D269: A7 09       STA    $9,X
D26B: CE E0 E2    LDU    #$E0E2
D26E: 7E B5 FD    JMP    $B5FD
D271: 0D 60       TST    $60
D273: 27 01       BEQ    $D276
D275: 39          RTS
D276: DC 88       LDD    $88
D278: 27 24       BEQ    $D29E
D27A: 2A 0F       BPL    $D28B
D27C: DC 80       LDD    $80
D27E: C3 00 90    ADDD   #$0090
D281: 91 C6       CMPA   $C6
D283: 26 19       BNE    $D29E
D285: 86 01       LDA    #$01
D287: 97 60       STA    $60
D289: 20 13       BRA    $D29E
D28B: 96 C6       LDA    $C6
D28D: 80 02       SUBA   #$02
D28F: A7 E2       STA    ,-S    ; [local]
D291: DC 80       LDD    $80
D293: C3 00 90    ADDD   #$0090
D296: A1 E0       CMPA   ,S+    ; [local]
D298: 26 04       BNE    $D29E
D29A: 86 02       LDA    #$02
D29C: 97 60       STA    $60
D29E: DC 8A       LDD    $8A
D2A0: 26 01       BNE    $D2A3
D2A2: 39          RTS
D2A3: 2A 11       BPL    $D2B6
D2A5: DC 82       LDD    $82
D2A7: C3 00 80    ADDD   #$0080
D2AA: 91 C7       CMPA   $C7
D2AC: 27 01       BEQ    $D2AF
D2AE: 39          RTS
D2AF: 96 60       LDA    $60
D2B1: 8A 04       ORA    #$04
D2B3: 97 60       STA    $60
D2B5: 39          RTS
D2B6: 96 C7       LDA    $C7
D2B8: 80 02       SUBA   #$02
D2BA: A7 E2       STA    ,-S    ; [local]
D2BC: DC 82       LDD    $82
D2BE: C3 00 80    ADDD   #$0080
D2C1: A1 E0       CMPA   ,S+    ; [local]
D2C3: 27 01       BEQ    $D2C6
D2C5: 39          RTS
D2C6: 96 60       LDA    $60
D2C8: 8A 08       ORA    #$08
D2CA: 97 60       STA    $60
D2CC: 39          RTS
D2CD: CE D2 D5    LDU    #jump_table_d2d5
D2D0: 96 60       LDA    $60
D2D2: 48          ASLA
D2D3: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=16]

D2F5: 8E 53 20    LDX    #$5320
D2F8: D6 6E       LDB    $6E
D2FA: 58          ASLB
D2FB: 58          ASLB
D2FC: 3A          ABX
D2FD: 86 02       LDA    #$02
D2FF: A7 84       STA    ,X
D301: DC C6       LDD    $C6
D303: ED 02       STD    $2,X
D305: 0C C6       INC    $C6
D307: 96 6E       LDA    $6E
D309: 4C          INCA
D30A: 84 07       ANDA   #$07
D30C: 97 6E       STA    $6E
D30E: 0F 60       CLR    $60
D310: B7 80 00    STA    watchdog_8000
D313: 39          RTS
D314: 8E 53 20    LDX    #$5320
D317: D6 6E       LDB    $6E
D319: 58          ASLB
D31A: 58          ASLB
D31B: 3A          ABX
D31C: 86 04       LDA    #$04
D31E: A7 84       STA    ,X
D320: DC C6       LDD    $C6
D322: ED 02       STD    $2,X
D324: 0A C6       DEC    $C6
D326: 96 6E       LDA    $6E
D328: 4C          INCA
D329: 84 07       ANDA   #$07
D32B: 97 6E       STA    $6E
D32D: 0F 60       CLR    $60
D32F: B7 80 00    STA    watchdog_8000
D332: 39          RTS
D333: 8E 53 20    LDX    #$5320
D336: D6 6E       LDB    $6E
D338: 58          ASLB
D339: 58          ASLB
D33A: 3A          ABX
D33B: 86 06       LDA    #$06
D33D: A7 84       STA    ,X
D33F: DC C6       LDD    $C6
D341: ED 02       STD    $2,X
D343: 0C C7       INC    $C7
D345: 96 6E       LDA    $6E
D347: 4C          INCA
D348: 84 07       ANDA   #$07
D34A: 97 6E       STA    $6E
D34C: 0F 60       CLR    $60
D34E: B7 80 00    STA    watchdog_8000
D351: 39          RTS
D352: 8D DF       BSR    $D333
D354: 7E D2 F5    JMP    $D2F5
D357: 8D DA       BSR    $D333
D359: 7E D3 14    JMP    $D314
D35C: 8E 53 20    LDX    #$5320
D35F: D6 6E       LDB    $6E
D361: 58          ASLB
D362: 58          ASLB
D363: 3A          ABX
D364: 86 08       LDA    #$08
D366: A7 84       STA    ,X
D368: DC C6       LDD    $C6
D36A: ED 02       STD    $2,X
D36C: 0A C7       DEC    $C7
D36E: 96 6E       LDA    $6E
D370: 4C          INCA
D371: 84 07       ANDA   #$07
D373: 97 6E       STA    $6E
D375: 0F 60       CLR    $60
D377: B7 80 00    STA    watchdog_8000
D37A: 39          RTS
D37B: 8D DF       BSR    $D35C
D37D: 7E D2 F5    JMP    $D2F5
D380: 8D DA       BSR    $D35C
D382: 7E D3 14    JMP    $D314
D385: 96 50       LDA    $50
D387: 9B 51       ADDA   $51
D389: 26 01       BNE    $D38C
D38B: 39          RTS
D38C: 97 54       STA    $54
D38E: CE D3 96    LDU    #jump_table_d396
D391: 96 60       LDA    $60
D393: 48          ASLA
D394: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=16]

D3B6: 39          RTS
D3B7: 8E 50 00    LDX    #$5000
D3BA: A6 84       LDA    ,X
D3BC: 2A 28       BPL    $D3E6
D3BE: 81 FF       CMPA   #$FF
D3C0: 27 28       BEQ    $D3EA
D3C2: 84 7C       ANDA   #$7C
D3C4: 81 40       CMPA   #$40
D3C6: 27 10       BEQ    $D3D8
D3C8: EC 0A       LDD    $A,X
D3CA: 10 83 19 00 CMPD   #$1900
D3CE: 2D 16       BLT    $D3E6
D3D0: 86 FF       LDA    #$FF
D3D2: A7 84       STA    ,X
D3D4: 0A 50       DEC    $50
D3D6: 20 0E       BRA    $D3E6
D3D8: EC 0A       LDD    $A,X
D3DA: 10 83 19 00 CMPD   #$1900
D3DE: 2D 06       BLT    $D3E6
D3E0: 86 FF       LDA    #$FF
D3E2: A7 84       STA    ,X
D3E4: 0A 51       DEC    $51
D3E6: 0A 54       DEC    $54
D3E8: 27 05       BEQ    $D3EF
D3EA: 30 88 10    LEAX   $10,X
D3ED: 20 CB       BRA    $D3BA
D3EF: B7 80 00    STA    watchdog_8000
D3F2: 39          RTS
D3F3: 8E 50 00    LDX    #$5000
D3F6: A6 84       LDA    ,X
D3F8: 2A 28       BPL    $D422
D3FA: 81 FF       CMPA   #$FF
D3FC: 27 28       BEQ    $D426
D3FE: 84 7C       ANDA   #$7C
D400: 81 40       CMPA   #$40
D402: 27 10       BEQ    $D414
D404: EC 0A       LDD    $A,X
D406: 10 83 F9 00 CMPD   #$F900
D40A: 2C 16       BGE    $D422
D40C: 86 FF       LDA    #$FF
D40E: A7 84       STA    ,X
D410: 0A 50       DEC    $50
D412: 20 0E       BRA    $D422
D414: EC 0A       LDD    $A,X
D416: 10 83 F9 00 CMPD   #$F900
D41A: 2C 06       BGE    $D422
D41C: 86 FF       LDA    #$FF
D41E: A7 84       STA    ,X
D420: 0A 51       DEC    $51
D422: 0A 54       DEC    $54
D424: 27 05       BEQ    $D42B
D426: 30 88 10    LEAX   $10,X
D429: 20 CB       BRA    $D3F6
D42B: B7 80 00    STA    watchdog_8000
D42E: 39          RTS
D42F: 8E 50 00    LDX    #$5000
D432: A6 84       LDA    ,X
D434: 2A 28       BPL    $D45E
D436: 81 FF       CMPA   #$FF
D438: 27 28       BEQ    $D462
D43A: 84 7C       ANDA   #$7C
D43C: 81 40       CMPA   #$40
D43E: 27 10       BEQ    $D450
D440: EC 0C       LDD    $C,X
D442: 10 83 18 00 CMPD   #$1800
D446: 2D 16       BLT    $D45E
D448: 86 FF       LDA    #$FF
D44A: A7 84       STA    ,X
D44C: 0A 50       DEC    $50
D44E: 20 0E       BRA    $D45E
D450: EC 0C       LDD    $C,X
D452: 10 83 18 00 CMPD   #$1800
D456: 2D 06       BLT    $D45E
D458: 86 FF       LDA    #$FF
D45A: A7 84       STA    ,X
D45C: 0A 51       DEC    $51
D45E: 0A 54       DEC    $54
D460: 27 05       BEQ    $D467
D462: 30 88 10    LEAX   $10,X
D465: 20 CB       BRA    $D432
D467: B7 80 00    STA    watchdog_8000
D46A: 39          RTS
D46B: 8E 50 00    LDX    #$5000
D46E: A6 84       LDA    ,X
D470: 2A 38       BPL    $D4AA
D472: 81 FF       CMPA   #$FF
D474: 27 38       BEQ    $D4AE
D476: 84 7C       ANDA   #$7C
D478: 81 40       CMPA   #$40
D47A: 27 18       BEQ    $D494
D47C: EC 0C       LDD    $C,X
D47E: 10 83 18 00 CMPD   #$1800
D482: 2C 08       BGE    $D48C
D484: EC 0A       LDD    $A,X
D486: 10 83 19 00 CMPD   #$1900
D48A: 2D 1E       BLT    $D4AA
D48C: 86 FF       LDA    #$FF
D48E: A7 84       STA    ,X
D490: 0A 50       DEC    $50
D492: 20 16       BRA    $D4AA
D494: EC 0C       LDD    $C,X
D496: 10 83 18 00 CMPD   #$1800
D49A: 2C 08       BGE    $D4A4
D49C: EC 0A       LDD    $A,X
D49E: 10 83 19 00 CMPD   #$1900
D4A2: 2D 06       BLT    $D4AA
D4A4: 86 FF       LDA    #$FF
D4A6: A7 84       STA    ,X
D4A8: 0A 51       DEC    $51
D4AA: 0A 54       DEC    $54
D4AC: 27 05       BEQ    $D4B3
D4AE: 30 88 10    LEAX   $10,X
D4B1: 20 BB       BRA    $D46E
D4B3: B7 80 00    STA    watchdog_8000
D4B6: 39          RTS
D4B7: 8E 50 00    LDX    #$5000
D4BA: A6 84       LDA    ,X
D4BC: 2A 38       BPL    $D4F6
D4BE: 81 FF       CMPA   #$FF
D4C0: 27 38       BEQ    $D4FA
D4C2: 84 7C       ANDA   #$7C
D4C4: 81 40       CMPA   #$40
D4C6: 27 18       BEQ    $D4E0
D4C8: EC 0C       LDD    $C,X
D4CA: 10 83 18 00 CMPD   #$1800
D4CE: 2C 08       BGE    $D4D8
D4D0: EC 0A       LDD    $A,X
D4D2: 10 83 F9 00 CMPD   #$F900
D4D6: 2C 1E       BGE    $D4F6
D4D8: 86 FF       LDA    #$FF
D4DA: A7 84       STA    ,X
D4DC: 0A 50       DEC    $50
D4DE: 20 16       BRA    $D4F6
D4E0: EC 0C       LDD    $C,X
D4E2: 10 83 18 00 CMPD   #$1800
D4E6: 2C 08       BGE    $D4F0
D4E8: EC 0A       LDD    $A,X
D4EA: 10 83 F9 00 CMPD   #$F900
D4EE: 2C 06       BGE    $D4F6
D4F0: 86 FF       LDA    #$FF
D4F2: A7 84       STA    ,X
D4F4: 0A 51       DEC    $51
D4F6: 0A 54       DEC    $54
D4F8: 27 05       BEQ    $D4FF
D4FA: 30 88 10    LEAX   $10,X
D4FD: 20 BB       BRA    $D4BA
D4FF: B7 80 00    STA    watchdog_8000
D502: 39          RTS
D503: 8E 50 00    LDX    #$5000
D506: A6 84       LDA    ,X
D508: 2A 28       BPL    $D532
D50A: 81 FF       CMPA   #$FF
D50C: 27 28       BEQ    $D536
D50E: 84 7C       ANDA   #$7C
D510: 81 40       CMPA   #$40
D512: 27 10       BEQ    $D524
D514: EC 0C       LDD    $C,X
D516: 10 83 F8 00 CMPD   #$F800
D51A: 2C 16       BGE    $D532
D51C: 86 FF       LDA    #$FF
D51E: A7 84       STA    ,X
D520: 0A 50       DEC    $50
D522: 20 0E       BRA    $D532
D524: EC 0C       LDD    $C,X
D526: 10 83 F8 00 CMPD   #$F800
D52A: 2C 06       BGE    $D532
D52C: 86 FF       LDA    #$FF
D52E: A7 84       STA    ,X
D530: 0A 51       DEC    $51
D532: 0A 54       DEC    $54
D534: 27 05       BEQ    $D53B
D536: 30 88 10    LEAX   $10,X
D539: 20 CB       BRA    $D506
D53B: B7 80 00    STA    watchdog_8000
D53E: 39          RTS
D53F: 8E 50 00    LDX    #$5000
D542: A6 84       LDA    ,X
D544: 2A 38       BPL    $D57E
D546: 81 FF       CMPA   #$FF
D548: 27 38       BEQ    $D582
D54A: 84 7C       ANDA   #$7C
D54C: 81 40       CMPA   #$40
D54E: 27 18       BEQ    $D568
D550: EC 0C       LDD    $C,X
D552: 10 83 F8 00 CMPD   #$F800
D556: 2D 08       BLT    $D560
D558: EC 0A       LDD    $A,X
D55A: 10 83 19 00 CMPD   #$1900
D55E: 2D 1E       BLT    $D57E
D560: 86 FF       LDA    #$FF
D562: A7 84       STA    ,X
D564: 0A 50       DEC    $50
D566: 20 16       BRA    $D57E
D568: EC 0C       LDD    $C,X
D56A: 10 83 F8 00 CMPD   #$F800
D56E: 2D 08       BLT    $D578
D570: EC 0A       LDD    $A,X
D572: 10 83 19 00 CMPD   #$1900
D576: 2D 06       BLT    $D57E
D578: 86 FF       LDA    #$FF
D57A: A7 84       STA    ,X
D57C: 0A 51       DEC    $51
D57E: 0A 54       DEC    $54
D580: 27 05       BEQ    $D587
D582: 30 88 10    LEAX   $10,X
D585: 20 BB       BRA    $D542
D587: B7 80 00    STA    watchdog_8000
D58A: 39          RTS
D58B: 8E 50 00    LDX    #$5000
D58E: A6 84       LDA    ,X
D590: 2A 38       BPL    $D5CA
D592: 81 FF       CMPA   #$FF
D594: 27 38       BEQ    $D5CE
D596: 84 7C       ANDA   #$7C
D598: 81 40       CMPA   #$40
D59A: 27 18       BEQ    $D5B4
D59C: EC 0C       LDD    $C,X
D59E: 10 83 F8 00 CMPD   #$F800
D5A2: 2D 08       BLT    $D5AC
D5A4: EC 0A       LDD    $A,X
D5A6: 10 83 F9 00 CMPD   #$F900
D5AA: 2C 1E       BGE    $D5CA
D5AC: 86 FF       LDA    #$FF
D5AE: A7 84       STA    ,X
D5B0: 0A 50       DEC    $50
D5B2: 20 16       BRA    $D5CA
D5B4: EC 0C       LDD    $C,X
D5B6: 10 83 F8 00 CMPD   #$F800
D5BA: 2D 08       BLT    $D5C4
D5BC: EC 0A       LDD    $A,X
D5BE: 10 83 F9 00 CMPD   #$F900
D5C2: 2C 06       BGE    $D5CA
D5C4: 86 FF       LDA    #$FF
D5C6: A7 84       STA    ,X
D5C8: 0A 51       DEC    $51
D5CA: 0A 54       DEC    $54
D5CC: 27 05       BEQ    $D5D3
D5CE: 30 88 10    LEAX   $10,X
D5D1: 20 BB       BRA    $D58E
D5D3: B7 80 00    STA    watchdog_8000
D5D6: 39          RTS
D5D7: 96 C7       LDA    $C7
D5D9: 80 02       SUBA   #$02
D5DB: 97 6D       STA    $6D
D5DD: 86 03       LDA    #$03
D5DF: 97 6B       STA    $6B
D5E1: D6 6D       LDB    $6D
D5E3: 2B 06       BMI    $D5EB
D5E5: D1 79       CMPB   $79
D5E7: 2C 08       BGE    $D5F1
D5E9: 8D 0B       BSR    $D5F6
D5EB: 0C 6D       INC    $6D
D5ED: 0A 6B       DEC    $6B
D5EF: 26 F0       BNE    $D5E1
D5F1: 0C 04       INC    $04
D5F3: 0F 06       CLR    $06
D5F5: 39          RTS
D5F6: 96 C6       LDA    $C6
D5F8: 80 02       SUBA   #$02
D5FA: 97 6C       STA    $6C
D5FC: 86 03       LDA    #$03
D5FE: 97 6A       STA    $6A
D600: 96 50       LDA    $50
D602: 9B 51       ADDA   $51
D604: 81 1F       CMPA   #$1F
D606: 24 2D       BCC    $D635
D608: D6 6C       LDB    $6C
D60A: 2B 23       BMI    $D62F
D60C: D1 78       CMPB   $78
D60E: 24 25       BCC    $D635
D610: 1D          SEX
D611: ED E3       STD    ,--S    ; [local]
D613: CE E9 FA    LDU    #$E9FA
D616: 96 C2       LDA    $C2
D618: 48          ASLA
D619: EE C6       LDU    A,U
D61B: 96 C4       LDA    $C4
D61D: 48          ASLA
D61E: EE C6       LDU    A,U
D620: 96 6D       LDA    $6D
D622: D6 78       LDB    $78
D624: 3D          MUL
D625: E3 E1       ADDD   ,S++    ; [local]
D627: 58          ASLB
D628: 49          ROLA
D629: 10 AE CB    LDY    D,U
D62C: BD D7 58    JSR    $D758
D62F: 0C 6C       INC    $6C
D631: 0A 6A       DEC    $6A
D633: 26 CB       BNE    $D600
D635: 39          RTS
D636: 96 D1       LDA    $D1
D638: 26 01       BNE    $D63B
D63A: 39          RTS
D63B: 0F 6C       CLR    $6C
D63D: 0F 6D       CLR    $6D
D63F: 10 8E F3 81 LDY    #$F381
D643: 48          ASLA
D644: 10 AE A6    LDY    A,Y
D647: 7E D7 58    JMP    $D758
D64A: D6 6F       LDB    $6F
D64C: D1 6E       CMPB   $6E
D64E: 26 01       BNE    $D651
D650: 39          RTS
D651: 8E 53 20    LDX    #$5320
D654: 58          ASLB
D655: 58          ASLB
D656: 3A          ABX
D657: CE D6 60    LDU    #jump_table_d660
D65A: A6 84       LDA    ,X
D65C: AD D6       JSR    [A,U]        ; [indirect_jump] [nb_entries=5]
D65E: 20 EA       BRA    $D64A

D66A: 96 6F       LDA    $6F
D66C: 4C          INCA
D66D: 84 07       ANDA   #$07
D66F: 97 6F       STA    $6F
D671: 39          RTS
D672: EC 02       LDD    $2,X
D674: 4C          INCA
D675: 91 78       CMPA   $78
D677: 2C 14       BGE    $D68D
D679: C0 02       SUBB   #$02
D67B: DD 6C       STD    $6C
D67D: CE E9 FA    LDU    #$E9FA
D680: 96 C2       LDA    $C2
D682: 48          ASLA
D683: EE C6       LDU    A,U
D685: 96 C4       LDA    $C4
D687: 48          ASLA
D688: EE C6       LDU    A,U
D68A: BD D7 04    JSR    $D704
D68D: 6F 84       CLR    ,X
D68F: 96 6F       LDA    $6F
D691: 4C          INCA
D692: 84 07       ANDA   #$07
D694: 97 6F       STA    $6F
D696: 39          RTS
D697: EC 02       LDD    $2,X
D699: 80 03       SUBA   #$03
D69B: 2B 14       BMI    $D6B1
D69D: C0 03       SUBB   #$03
D69F: DD 6C       STD    $6C
D6A1: CE E9 FA    LDU    #$E9FA
D6A4: 96 C2       LDA    $C2
D6A6: 48          ASLA
D6A7: EE C6       LDU    A,U
D6A9: 96 C4       LDA    $C4
D6AB: 48          ASLA
D6AC: EE C6       LDU    A,U
D6AE: BD D7 04    JSR    $D704
D6B1: 6F 84       CLR    ,X
D6B3: 96 6F       LDA    $6F
D6B5: 4C          INCA
D6B6: 84 07       ANDA   #$07
D6B8: 97 6F       STA    $6F
D6BA: 39          RTS
D6BB: EC 02       LDD    $2,X
D6BD: 80 02       SUBA   #$02
D6BF: 5C          INCB
D6C0: D1 79       CMPB   $79
D6C2: 2C 12       BGE    $D6D6
D6C4: DD 6C       STD    $6C
D6C6: CE E9 FA    LDU    #$E9FA
D6C9: 96 C2       LDA    $C2
D6CB: 48          ASLA
D6CC: EE C6       LDU    A,U
D6CE: 96 C4       LDA    $C4
D6D0: 48          ASLA
D6D1: EE C6       LDU    A,U
D6D3: BD D7 2E    JSR    $D72E
D6D6: 6F 84       CLR    ,X
D6D8: 96 6F       LDA    $6F
D6DA: 4C          INCA
D6DB: 84 07       ANDA   #$07
D6DD: 97 6F       STA    $6F
D6DF: 39          RTS
D6E0: EC 02       LDD    $2,X
D6E2: 80 02       SUBA   #$02
D6E4: C0 03       SUBB   #$03
D6E6: 2B 12       BMI    $D6FA
D6E8: DD 6C       STD    $6C
D6EA: CE E9 FA    LDU    #$E9FA
D6ED: 96 C2       LDA    $C2
D6EF: 48          ASLA
D6F0: EE C6       LDU    A,U
D6F2: 96 C4       LDA    $C4
D6F4: 48          ASLA
D6F5: EE C6       LDU    A,U
D6F7: BD D7 2E    JSR    $D72E
D6FA: 6F 84       CLR    ,X
D6FC: 96 6F       LDA    $6F
D6FE: 4C          INCA
D6FF: 84 07       ANDA   #$07
D701: 97 6F       STA    $6F
D703: 39          RTS
D704: 96 50       LDA    $50
D706: 9B 51       ADDA   $51
D708: 81 1F       CMPA   #$1F
D70A: 24 21       BCC    $D72D
D70C: 96 6D       LDA    $6D
D70E: 2B 15       BMI    $D725
D710: 91 79       CMPA   $79
D712: 24 19       BCC    $D72D
D714: D6 78       LDB    $78
D716: 3D          MUL
D717: ED E3       STD    ,--S	; [local]
D719: D6 6C       LDB    $6C
D71B: 1D          SEX
D71C: E3 E1       ADDD   ,S++	; [local]
D71E: 58          ASLB
D71F: 49          ROLA
D720: 10 AE CB    LDY    D,U
D723: 8D 33       BSR    $D758
D725: 0C 6D       INC    $6D
D727: 96 6D       LDA    $6D
D729: A1 03       CMPA   $3,X
D72B: 2F D7       BLE    $D704
D72D: 39          RTS
D72E: 96 50       LDA    $50
D730: 9B 51       ADDA   $51
D732: 81 1F       CMPA   #$1F
D734: 24 21       BCC    $D757
D736: D6 6C       LDB    $6C
D738: 2B 15       BMI    $D74F
D73A: D1 78       CMPB   $78
D73C: 24 19       BCC    $D757
D73E: 1D          SEX
D73F: ED E3       STD    ,--S	; [local]
D741: 96 6D       LDA    $6D
D743: D6 78       LDB    $78
D745: 3D          MUL
D746: E3 E1       ADDD   ,S++	; [local]
D748: 58          ASLB
D749: 49          ROLA
D74A: 10 AE CB    LDY    D,U
D74D: 8D 09       BSR    $D758
D74F: 0C 6C       INC    $6C
D751: D6 6C       LDB    $6C
D753: E1 02       CMPB   $2,X
D755: 2F D7       BLE    $D72E
D757: 39          RTS
D758: 34 50       PSHS   U,X
D75A: 8E 50 00    LDX    #$5000
D75D: A6 A0       LDA    ,Y+
D75F: 27 10       BEQ    $D771
D761: 97 69       STA    $69
D763: 8D 11       BSR    $D776
D765: 96 50       LDA    $50
D767: 9B 51       ADDA   $51
D769: 81 1F       CMPA   #$1F
D76B: 24 04       BCC    $D771
D76D: 0A 69       DEC    $69
D76F: 26 F2       BNE    $D763
D771: B7 80 00    STA    watchdog_8000
D774: 35 D0       PULS   X,U,PC
D776: A6 84       LDA    ,X
D778: 81 FF       CMPA   #$FF
D77A: 27 0A       BEQ    $D786
D77C: 30 88 10    LEAX   $10,X
D77F: 8C 53 00    CMPX   #$5300
D782: 25 F2       BCS    $D776
D784: 20 FE       BRA    $D784
D786: EC A1       LDD    ,Y++
D788: 8A 80       ORA    #$80
D78A: A7 84       STA    ,X
D78C: E7 01       STB    $1,X
D78E: 6F 02       CLR    $2,X
D790: 6F 03       CLR    $3,X
D792: E6 A0       LDB    ,Y+
D794: E7 04       STB    $4,X
D796: 84 7F       ANDA   #$7F
D798: 81 48       CMPA   #$48
D79A: 25 04       BCS    $D7A0
D79C: 0C 50       INC    $50
D79E: 20 02       BRA    $D7A2
D7A0: 0C 51       INC    $51
D7A2: CE D8 16    LDU    #$D816
D7A5: 80 40       SUBA   #$40
D7A7: E6 C6       LDB    A,U
D7A9: E7 05       STB    $5,X
D7AB: CE D7 D6    LDU    #$D7D6
D7AE: 48          ASLA
D7AF: EC C6       LDD    A,U
D7B1: ED 0E       STD    $E,X
D7B3: 6F 06       CLR    $6,X
D7B5: 96 6C       LDA    $6C
D7B7: E6 A0       LDB    ,Y+
D7B9: 93 80       SUBD   $80
D7BB: 58          ASLB
D7BC: 49          ROLA
D7BD: 58          ASLB
D7BE: 49          ROLA
D7BF: 58          ASLB
D7C0: 49          ROLA
D7C1: 58          ASLB
D7C2: 49          ROLA
D7C3: ED 0A       STD    $A,X
D7C5: 96 6D       LDA    $6D
D7C7: E6 A0       LDB    ,Y+
D7C9: 93 82       SUBD   $82
D7CB: 58          ASLB
D7CC: 49          ROLA
D7CD: 58          ASLB
D7CE: 49          ROLA
D7CF: 58          ASLB
D7D0: 49          ROLA
D7D1: 58          ASLB
D7D2: 49          ROLA
D7D3: ED 0C       STD    $C,X
D7D5: 39          RTS

D836: 96 50       LDA    $50
D838: 26 03       BNE    $D83D
D83A: 97 52       STA    $52
D83C: 39          RTS
D83D: 8E 50 00    LDX    #$5000
D840: 97 54       STA    $54
D842: 0F 52       CLR    $52
D844: A6 84       LDA    ,X
D846: 81 FF       CMPA   #$FF
D848: 27 1F       BEQ    $D869
D84A: 84 7F       ANDA   #$7F
D84C: 81 48       CMPA   #$48
D84E: 25 19       BCS    $D869
D850: 8D 4C       BSR    $D89E
D852: 2B 10       BMI    $D864
D854: 6D 06       TST    $6,X
D856: 27 02       BEQ    $D85A
D858: 6A 06       DEC    $6,X
D85A: CE D8 6E    LDU    #jump_table_d86e
D85D: A6 84       LDA    ,X
D85F: 80 48       SUBA   #$48
D861: 48          ASLA
D862: AD D6       JSR    [A,U]        ; [indirect_jump] [nb_entries=24]
D864: 0A 54       DEC    $54
D866: 26 01       BNE    $D869
D868: 39          RTS
D869: 30 88 10    LEAX   $10,X
D86C: 20 D6       BRA    $D844

D89E: DC 88       LDD    $88
D8A0: E3 0A       ADDD   $A,X
D8A2: ED 0A       STD    $A,X
D8A4: DC 8A       LDD    $8A
D8A6: E3 0C       ADDD   $C,X
D8A8: ED 0C       STD    $C,X
D8AA: 10 83 FF 00 CMPD   #$FF00
D8AE: 2D 1D       BLT    $D8CD
D8B0: 10 83 0F 00 CMPD   #$0F00
D8B4: 2C 17       BGE    $D8CD
D8B6: EC 0A       LDD    $A,X
D8B8: 10 83 FE 00 CMPD   #$FE00
D8BC: 2D 0F       BLT    $D8CD
D8BE: 10 83 14 00 CMPD   #$1400
D8C2: 2C 09       BGE    $D8CD
D8C4: 0C 52       INC    $52
D8C6: A6 84       LDA    ,X
D8C8: 84 7F       ANDA   #$7F
D8CA: A7 84       STA    ,X
D8CC: 39          RTS
D8CD: A6 84       LDA    ,X
D8CF: 8A 80       ORA    #$80
D8D1: A7 84       STA    ,X
D8D3: 39          RTS
D8D4: 39          RTS
D8D5: 39          RTS
D8D6: 6C 03       INC    $3,X
D8D8: A6 03       LDA    $3,X
D8DA: 84 07       ANDA   #$07
D8DC: 27 01       BEQ    $D8DF
D8DE: 39          RTS
D8DF: CE D8 EF    LDU    #$D8EF
D8E2: A6 02       LDA    $2,X
D8E4: 4C          INCA
D8E5: 84 03       ANDA   #$03
D8E7: A7 02       STA    $2,X
D8E9: 48          ASLA
D8EA: EC C6       LDD    A,U
D8EC: ED 0E       STD    $E,X
D8EE: 39          RTS

D8F7: CE D8 FF 	  LDU    #jump_table_d8ff
D8FA: A6 02       LDA    $2,X
D8FC: 48          ASLA
D8FD: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=13]

jump_table_d8ff:
	.word	$d919 
	.word	$d930 
	.word	$d930 
	.word	$d930 
	.word	$d930 
	.word	$d947 
	.word	$d930 
	.word	$d98b
	.word	$d930 
	.word	$d930 
	.word	$d930
	.word	$d930 
	.word	$d9a6


D919: A6 03       LDA    $3,X
D91B: 4C          INCA
D91C: 84 07       ANDA   #$07
D91E: A7 03       STA    $3,X
D920: 27 01       BEQ    $D923
D922: 39          RTS
D923: CE D9 F9    LDU    #$D9F9
D926: 6C 02       INC    $2,X
D928: A6 02       LDA    $2,X
D92A: 48          ASLA
D92B: EC C6       LDD    A,U
D92D: ED 0E       STD    $E,X
D92F: 39          RTS

D930: A6 03       LDA    $3,X
D932: 4C          INCA
D933: 84 07       ANDA   #$07
D935: A7 03       STA    $3,X
D937: 27 01       BEQ    $D93A
D939: 39          RTS
D93A: CE D9 F9    LDU    #$D9F9
D93D: 6C 02       INC    $2,X
D93F: A6 02       LDA    $2,X
D941: 48          ASLA
D942: EC C6       LDD    A,U
D944: ED 0E       STD    $E,X
D946: 39          RTS
D947: A6 03       LDA    $3,X
D949: 4C          INCA
D94A: 84 07       ANDA   #$07
D94C: A7 03       STA    $3,X
D94E: 27 01       BEQ    $D951
D950: 39          RTS
D951: 6C 02       INC    $2,X
D953: CE D9 F9    LDU    #$D9F9
D956: A6 02       LDA    $2,X
D958: 48          ASLA
D959: EC C6       LDD    A,U
D95B: ED 0E       STD    $E,X
D95D: 96 45       LDA    $45
D95F: 81 10       CMPA   #$10
D961: 23 01       BLS    $D964
D963: 39          RTS
D964: 10 8E 53 40 LDY    #$5340
D968: 96 E0       LDA    $E0
D96A: C6 07       LDB    #$07
D96C: E7 A6       STB    A,Y
D96E: 4C          INCA
D96F: 84 1F       ANDA   #$1F
D971: 97 E0       STA    $E0
D973: A6 84       LDA    ,X
D975: 81 4C       CMPA   #$4C
D977: 26 09       BNE    $D982
D979: 10 8E 7C 08 LDY    #$7C08
D97D: C6 72       LDB    #$72
D97F: 7E D9 BD    JMP    $D9BD
D982: 10 8E 7C 0C LDY    #$7C0C
D986: C6 73       LDB    #$73
D988: 7E D9 BD    JMP    $D9BD
D98B: 6D 03       TST    $3,X
D98D: 26 09       BNE    $D998
D98F: EE 08       LDU    $8,X
D991: A6 C4       LDA    ,U
D993: 81 FF       CMPA   #$FF
D995: 27 01       BEQ    $D998
D997: 39          RTS
D998: 6F 03       CLR    $3,X
D99A: 6C 02       INC    $2,X
D99C: CE D9 F9    LDU    #$D9F9
D99F: A6 02       LDA    $2,X
D9A1: 48          ASLA
D9A2: EC C6       LDD    A,U
D9A4: ED 0E       STD    $E,X
D9A6: 6D 03       TST    $3,X
D9A8: 26 09       BNE    $D9B3
D9AA: EE 08       LDU    $8,X
D9AC: A6 C4       LDA    ,U
D9AE: 81 FF       CMPA   #$FF
D9B0: 27 01       BEQ    $D9B3
D9B2: 39          RTS
D9B3: 6F 03       CLR    $3,X
D9B5: 6F 02       CLR    $2,X
D9B7: CC 78 40    LDD    #$7840
D9BA: ED 0E       STD    $E,X
D9BC: 39          RTS
D9BD: CE 4C 00    LDU    #$4C00
D9C0: 86 FF       LDA    #$FF
D9C2: A1 C4       CMPA   ,U
D9C4: 27 05       BEQ    $D9CB
D9C6: 33 C8 10    LEAU   $10,U
D9C9: 20 F7       BRA    $D9C2
D9CB: E7 C4       STB    ,U
D9CD: A6 01       LDA    $1,X
D9CF: A7 41       STA    $1,U
D9D1: 6F 42       CLR    $2,U
D9D3: 6F 43       CLR    $3,U
D9D5: A6 04       LDA    $4,X
D9D7: 80 40       SUBA   #$40
D9D9: A7 44       STA    $4,U
D9DB: 10 AF 4E    STY    $E,U
D9DE: 6F 45       CLR    $5,U
D9E0: 6F 46       CLR    $6,U
D9E2: 6F 47       CLR    $7,U
D9E4: AF 48       STX    $8,U
D9E6: EF 08       STU    $8,X
D9E8: EC 0A       LDD    $A,X
D9EA: C3 00 80    ADDD   #$0080
D9ED: ED 4A       STD    $A,U
D9EF: EC 0C       LDD    $C,X
D9F1: 83 01 80    SUBD   #$0180
D9F4: ED 4C       STD    $C,U
D9F6: 0C 45       INC    $45
D9F8: 39          RTS

DA13: 39          RTS
DA14: 39          RTS
DA15: 39          RTS
DA16: 6C 03       INC    $3,X
DA18: A6 03       LDA    $3,X
DA1A: 84 07       ANDA   #$07
DA1C: 27 01       BEQ    $DA1F
DA1E: 39          RTS
DA1F: 34 10       PSHS   X
DA21: 10 8E F3 C9 LDY    #$F3C9
DA25: 0C 54       INC    $54
DA27: BD D7 76    JSR    $D776
DA2A: 35 90       PULS   X,PC
DA2C: 39          RTS
DA2D: 6C 03       INC    $3,X
DA2F: A6 03       LDA    $3,X
DA31: 84 01       ANDA   #$01
DA33: 27 01       BEQ    $DA36
DA35: 39          RTS
DA36: 86 FF       LDA    #$FF
DA38: A7 84       STA    ,X
DA3A: 0A 50       DEC    $50
DA3C: 0A 52       DEC    $52
DA3E: 39          RTS
DA3F: 39          RTS
DA40: 96 02       LDA    $02
DA42: 81 06       CMPA   #$06
DA44: 26 0F       BNE    $DA55
DA46: 96 04       LDA    $04
DA48: 81 0B       CMPA   #$0B
DA4A: 26 09       BNE    $DA55
DA4C: DC 11       LDD    $11
DA4E: 10 83 00 06 CMPD   #$0006
DA52: 22 0A       BHI    $DA5E
DA54: 39          RTS
DA55: DC 11       LDD    $11
DA57: 10 83 00 01 CMPD   #$0001
DA5B: 22 01       BHI    $DA5E
DA5D: 39          RTS
DA5E: 6C 03       INC    $3,X
DA60: A6 03       LDA    $3,X
DA62: 84 07       ANDA   #$07
DA64: 27 01       BEQ    $DA67
DA66: 39          RTS
DA67: 86 5F       LDA    #$5F
DA69: A7 84       STA    ,X
DA6B: CC 7A CF    LDD    #$7ACF
DA6E: ED 0E       STD    $E,X
DA70: 6F 03       CLR    $3,X
DA72: 39          RTS

DA73: 6C 03       INC    $3,X
DA75: A6 03       LDA    $3,X
DA77: 84 07       ANDA   #$07
DA79: 27 01       BEQ    $DA7C
DA7B: 39          RTS
DA7C: 86 5E       LDA    #$5E
DA7E: A7 84       STA    ,X
DA80: CC 7A 92    LDD    #$7A92
DA83: ED 0E       STD    $E,X
DA85: 6F 03       CLR    $3,X
DA87: 39          RTS
DA88: 96 45       LDA    $45
DA8A: 26 03       BNE    $DA8F
DA8C: 97 46       STA    $46
DA8E: 39          RTS
DA8F: 8E 4C 00    LDX    #$4C00
DA92: 97 47       STA    $47
DA94: 0F 46       CLR    $46
DA96: A6 84       LDA    ,X
DA98: 2A 0C       BPL    $DAA6
DA9A: 81 FF       CMPA   #$FF
DA9C: 27 39       BEQ    $DAD7
DA9E: 84 7F       ANDA   #$7F
DAA0: A7 84       STA    ,X
DAA2: 0C 46       INC    $46
DAA4: 20 2C       BRA    $DAD2
DAA6: DC 88       LDD    $88
DAA8: E3 0A       ADDD   $A,X
DAAA: ED 0A       STD    $A,X
DAAC: 10 83 FE 00 CMPD   #$FE00
DAB0: 2D 2A       BLT    $DADC
DAB2: 10 83 14 00 CMPD   #$1400
DAB6: 2C 24       BGE    $DADC
DAB8: DC 8A       LDD    $8A
DABA: E3 0C       ADDD   $C,X
DABC: ED 0C       STD    $C,X
DABE: 2B 1C       BMI    $DADC
DAC0: 10 83 0F 00 CMPD   #$0F00
DAC4: 2C 16       BGE    $DADC
DAC6: 0C 46       INC    $46
DAC8: CE DA ED    LDU    #jump_table_daed
DACB: A6 84       LDA    ,X
DACD: 80 70       SUBA   #$70
DACF: 48          ASLA
DAD0: AD D6       JSR    [A,U]        ; [indirect_jump] [nb_entries=8]
DAD2: 0A 47       DEC    $47
DAD4: 26 01       BNE    $DAD7
DAD6: 39          RTS
DAD7: 30 88 10    LEAX   $10,X
DADA: 20 BA       BRA    $DA96
DADC: C6 FF       LDB    #$FF
DADE: E7 84       STB    ,X
DAE0: 0A 45       DEC    $45
DAE2: 0A 47       DEC    $47
DAE4: 26 01       BNE    $DAE7
DAE6: 39          RTS
DAE7: 30 88 10    LEAX   $10,X
DAEA: 20 AA       BRA    $DA96
DAEC: 39          RTS
DAED: DB EE       ADDB   $EE
DAEF: DB FD       ADDB   $FD
DAF1: DA FD       ORB    $FD
DAF3: DB 0E       ADDB   $0E
DAF5: DC F9       LDD    $F9
DAF7: DC F9       LDD    $F9
DAF9: DC B0       LDD    $B0
DAFB: DC B9       LDD    $B9
DAFD: BD DD 8E    JSR    $DD8E
DB00: CE DB 08    LDU    #jump_table_db08
DB03: A6 02       LDA    $2,X
DB05: 48          ASLA
DB06: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

DB0E: BD DD 8E    JSR    $DD8E
DB11: CE DB 19    LDU    #jump_table_db19
DB14: A6 02       LDA    $2,X
DB16: 48          ASLA
DB17: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

DB1F: A6 03       LDA    $3,X
DB21: 4C          INCA
DB22: 84 07       ANDA   #$07
DB24: A7 03       STA    $3,X
DB26: 27 01       BEQ    $DB29
DB28: 39          RTS
DB29: 6C 02       INC    $2,X
DB2B: EC 0C       LDD    $C,X
DB2D: 83 01 00    SUBD   #$0100
DB30: ED 0C       STD    $C,X
DB32: 10 8E 7C 00 LDY    #$7C00
DB36: C6 70       LDB    #$70
DB38: BD DD 29    JSR    $DD29
DB3B: 10 8E 7C 14 LDY    #$7C14
DB3F: C6 76       LDB    #$76
DB41: 7E DD 29    JMP    $DD29
DB44: A6 03       LDA    $3,X
DB46: 4C          INCA
DB47: 84 07       ANDA   #$07
DB49: A7 03       STA    $3,X
DB4B: 27 01       BEQ    $DB4E
DB4D: 39          RTS
DB4E: 6C 02       INC    $2,X
DB50: EC 0C       LDD    $C,X
DB52: 83 01 00    SUBD   #$0100
DB55: ED 0C       STD    $C,X
DB57: 10 8E 7C 04 LDY    #$7C04
DB5B: C6 71       LDB    #$71
DB5D: BD DD 29    JSR    $DD29
DB60: 10 8E 7C 14 LDY    #$7C14
DB64: C6 76       LDB    #$76
DB66: 7E DD 29    JMP    $DD29
DB69: A6 03       LDA    $3,X
DB6B: 4C          INCA
DB6C: 84 03       ANDA   #$03
DB6E: A7 03       STA    $3,X
DB70: 27 01       BEQ    $DB73
DB72: 39          RTS
DB73: 6C 06       INC    $6,X
DB75: A6 06       LDA    $6,X
DB77: AB 07       ADDA   $7,X
DB79: A1 01       CMPA   $1,X
DB7B: 27 03       BEQ    $DB80
DB7D: 7E DD 1E    JMP    $DD1E
DB80: 6C 02       INC    $2,X
DB82: 6A 07       DEC    $7,X
DB84: A6 06       LDA    $6,X
DB86: A1 01       CMPA   $1,X
DB88: 27 03       BEQ    $DB8D
DB8A: 7E DD 1E    JMP    $DD1E
DB8D: EE 08       LDU    $8,X
DB8F: 6C 43       INC    $3,U
DB91: C6 74       LDB    #$74
DB93: E7 84       STB    ,X
DB95: CC 7C 10    LDD    #$7C10
DB98: ED 0E       STD    $E,X
DB9A: 7E DD 1E    JMP    $DD1E
DB9D: A6 03       LDA    $3,X
DB9F: 4C          INCA
DBA0: 84 03       ANDA   #$03
DBA2: A7 03       STA    $3,X
DBA4: 27 01       BEQ    $DBA7
DBA6: 39          RTS
DBA7: 6C 06       INC    $6,X
DBA9: A6 06       LDA    $6,X
DBAB: AB 07       ADDA   $7,X
DBAD: A1 01       CMPA   $1,X
DBAF: 27 03       BEQ    $DBB4
DBB1: 7E DD 1E    JMP    $DD1E
DBB4: 6C 02       INC    $2,X
DBB6: 6A 07       DEC    $7,X
DBB8: A6 06       LDA    $6,X
DBBA: A1 01       CMPA   $1,X
DBBC: 27 CF       BEQ    $DB8D
DBBE: 7E DD 1E    JMP    $DD1E
DBC1: A6 07       LDA    $7,X
DBC3: 26 1A       BNE    $DBDF
DBC5: EC 0C       LDD    $C,X
DBC7: 83 00 40    SUBD   #$0040
DBCA: ED 0C       STD    $C,X
DBCC: A6 03       LDA    $3,X
DBCE: 4C          INCA
DBCF: 84 03       ANDA   #$03
DBD1: A7 03       STA    $3,X
DBD3: 27 01       BEQ    $DBD6
DBD5: 39          RTS
DBD6: 86 FF       LDA    #$FF
DBD8: A7 84       STA    ,X
DBDA: 0A 45       DEC    $45
DBDC: 0A 46       DEC    $46
DBDE: 39          RTS
DBDF: A6 03       LDA    $3,X
DBE1: 4C          INCA
DBE2: 84 03       ANDA   #$03
DBE4: A7 03       STA    $3,X
DBE6: 27 01       BEQ    $DBE9
DBE8: 39          RTS
DBE9: 6A 07       DEC    $7,X
DBEB: 7E DD 1E    JMP    $DD1E
DBEE: BD DD 8E    JSR    $DD8E
DBF1: CE DB F9    LDU    #jump_table_dbf9
DBF4: A6 02       LDA    $2,X
DBF6: 48          ASLA
DBF7: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=2]

DBFD: BD DD 8E    JSR    $DD8E
DC00: CE DC 08    LDU    #jump_table_dc08
DC03: A6 02       LDA    $2,X
DC05: 48          ASLA
DC06: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=2]

DC0C: EC 0C       LDD    $C,X
DC0E: 83 00 40    SUBD   #$0040
DC11: ED 0C       STD    $C,X
DC13: A6 03       LDA    $3,X
DC15: 4C          INCA
DC16: 84 03       ANDA   #$03
DC18: A7 03       STA    $3,X
DC1A: 27 01       BEQ    $DC1D
DC1C: 39          RTS
DC1D: 6C 02       INC    $2,X
DC1F: A6 07       LDA    $7,X
DC21: A1 01       CMPA   $1,X
DC23: 27 1B       BEQ    $DC40
DC25: C6 72       LDB    #$72
DC27: E7 84       STB    ,X
DC29: CC 7C 08    LDD    #$7C08
DC2C: ED 0E       STD    $E,X
DC2E: 10 8E 7C 00 LDY    #$7C00
DC32: C6 70       LDB    #$70
DC34: BD DD 29    JSR    $DD29
DC37: 10 8E 7C 14 LDY    #$7C14
DC3B: C6 76       LDB    #$76
DC3D: 7E DD 29    JMP    $DD29
DC40: 10 8E 7C 20 LDY    #$7C20
DC44: C6 77       LDB    #$77
DC46: BD DD 29    JSR    $DD29
DC49: 6A 47       DEC    $7,U
DC4B: EC 4A       LDD    $A,U
DC4D: 83 00 80    SUBD   #$0080
DC50: ED 4A       STD    $A,U
DC52: 39          RTS
DC53: EC 0C       LDD    $C,X
DC55: 83 00 40    SUBD   #$0040
DC58: ED 0C       STD    $C,X
DC5A: A6 03       LDA    $3,X
DC5C: 4C          INCA
DC5D: 84 03       ANDA   #$03
DC5F: A7 03       STA    $3,X
DC61: 27 01       BEQ    $DC64
DC63: 39          RTS
DC64: 6C 02       INC    $2,X
DC66: A6 07       LDA    $7,X
DC68: A1 01       CMPA   $1,X
DC6A: 27 1B       BEQ    $DC87
DC6C: C6 73       LDB    #$73
DC6E: E7 84       STB    ,X
DC70: CC 7C 0C    LDD    #$7C0C
DC73: ED 0E       STD    $E,X
DC75: 10 8E 7C 04 LDY    #$7C04
DC79: C6 71       LDB    #$71
DC7B: BD DD 29    JSR    $DD29
DC7E: 10 8E 7C 14 LDY    #$7C14
DC82: C6 76       LDB    #$76
DC84: 7E DD 29    JMP    $DD29
DC87: 10 8E 7C 20 LDY    #$7C20
DC8B: C6 77       LDB    #$77
DC8D: BD DD 29    JSR    $DD29
DC90: 6A 47       DEC    $7,U
DC92: EC 4A       LDD    $A,U
DC94: 83 00 80    SUBD   #$0080
DC97: ED 4A       STD    $A,U
DC99: EC 4C       LDD    $C,U
DC9B: 83 00 80    SUBD   #$0080
DC9E: ED 4C       STD    $C,U
DCA0: 39          RTS
DCA1: A6 03       LDA    $3,X
DCA3: 4C          INCA
DCA4: 84 03       ANDA   #$03
DCA6: A7 03       STA    $3,X
DCA8: 27 01       BEQ    $DCAB
DCAA: 39          RTS
DCAB: 6A 07       DEC    $7,X
DCAD: 27 01       BEQ    $DCB0
DCAF: 39          RTS
DCB0: 86 FF       LDA    #$FF
DCB2: A7 84       STA    ,X
DCB4: 0A 45       DEC    $45
DCB6: 0A 46       DEC    $46
DCB8: 39          RTS
DCB9: BD DE 0A    JSR    $DE0A
DCBC: A6 03       LDA    $3,X
DCBE: 4C          INCA
DCBF: 84 03       ANDA   #$03
DCC1: A7 03       STA    $3,X
DCC3: 27 01       BEQ    $DCC6
DCC5: 39          RTS
DCC6: 6A 07       DEC    $7,X
DCC8: 26 09       BNE    $DCD3
DCCA: 86 FF       LDA    #$FF
DCCC: A7 84       STA    ,X
DCCE: 0A 45       DEC    $45
DCD0: 0A 46       DEC    $46
DCD2: 39          RTS
DCD3: CE DC DB    LDU    #jump_table_dcdb
DCD6: A6 02       LDA    $2,X
DCD8: 48          ASLA
DCD9: 6E D6       JMP    [A,U]        ; [indirect_jump] [nb_entries=3]

DCE1: 6C 02       INC    $2,X
DCE3: CC 7C 24    LDD    #$7C24
DCE6: ED 0E       STD    $E,X
DCE8: 39          RTS
DCE9: 6C 02       INC    $2,X
DCEB: CC 7C 28    LDD    #$7C28
DCEE: ED 0E       STD    $E,X
DCF0: 39          RTS
DCF1: 6F 02       CLR    $2,X
DCF3: CC 7C 20    LDD    #$7C20
DCF6: ED 0E       STD    $E,X
DCF8: 39          RTS
DCF9: EC 0C       LDD    $C,X
DCFB: 83 00 40    SUBD   #$0040
DCFE: ED 0C       STD    $C,X
DD00: A6 03       LDA    $3,X
DD02: 4C          INCA
DD03: 84 03       ANDA   #$03
DD05: A7 03       STA    $3,X
DD07: 27 01       BEQ    $DD0A
DD09: 39          RTS
DD0A: 6A 06       DEC    $6,X
DD0C: 27 03       BEQ    $DD11
DD0E: 7E DD 1E    JMP    $DD1E
DD11: EE 08       LDU    $8,X
DD13: 6C 43       INC    $3,U
DD15: 86 FF       LDA    #$FF
DD17: A7 84       STA    ,X
DD19: 0A 45       DEC    $45
DD1B: 0A 46       DEC    $46
DD1D: 39          RTS
DD1E: CE DD 70    LDU    #$DD70
DD21: A6 06       LDA    $6,X
DD23: 48          ASLA
DD24: 10 AE C6    LDY    A,U
DD27: C6 76       LDB    #$76
DD29: 33 88 10    LEAU   $10,X
DD2C: 11 83 50 00 CMPU   #$5000
DD30: 25 01       BCS    $DD33
DD32: 39          RTS
DD33: 86 FF       LDA    #$FF
DD35: A1 C4       CMPA   ,U
DD37: 27 0A       BEQ    $DD43
DD39: 33 C8 10    LEAU   $10,U
DD3C: 11 83 50 00 CMPU   #$5000
DD40: 25 F3       BCS    $DD35
DD42: 39          RTS
DD43: CA 80       ORB    #$80
DD45: E7 C4       STB    ,U
DD47: A6 01       LDA    $1,X
DD49: A7 41       STA    $1,U
DD4B: 6F 42       CLR    $2,U
DD4D: 6F 43       CLR    $3,U
DD4F: A6 04       LDA    $4,X
DD51: A7 44       STA    $4,U
DD53: 10 AF 4E    STY    $E,U
DD56: 6F 45       CLR    $5,U
DD58: 6F 46       CLR    $6,U
DD5A: A6 07       LDA    $7,X
DD5C: 4C          INCA
DD5D: A7 47       STA    $7,U
DD5F: EC 08       LDD    $8,X
DD61: ED 48       STD    $8,U
DD63: 0C 45       INC    $45
DD65: 0C 47       INC    $47
DD67: EC 0A       LDD    $A,X
DD69: ED 4A       STD    $A,U
DD6B: EC 0C       LDD    $C,X
DD6D: ED 4C       STD    $C,U
DD6F: 39          RTS

DD8E: CE 44 10    LDU    #$4410
DD91: A6 C4       LDA    ,U
DD93: 2A 01       BPL    $DD96
DD95: 39          RTS
DD96: E6 4B       LDB    $B,U
DD98: 2A 01       BPL    $DD9B
DD9A: 39          RTS
DD9B: A6 45       LDA    $5,U
DD9D: A1 04       CMPA   $4,X
DD9F: 27 01       BEQ    $DDA2
DDA1: 39          RTS
DDA2: 4F          CLRA
DDA3: 58          ASLB
DDA4: 49          ROLA
DDA5: ED E3       STD    ,--S	; [local]
DDA7: 58          ASLB
DDA8: 49          ROLA
DDA9: 58          ASLB
DDAA: 49          ROLA
DDAB: E3 E1       ADDD   ,S++	; [local]
DDAD: 10 8E E2 0E LDY    #$E20E
DDB1: 31 AB       LEAY   D,Y
DDB3: 7E DD B6    JMP    $DDB6
DDB6: EC 5C       LDD    -$4,U
DDB8: E3 A4       ADDD   ,Y
DDBA: A3 0C       SUBD   $C,X
DDBC: B3 E7 36    SUBD   $E736
DDBF: 2B 07       BMI    $DDC8
DDC1: 10 B3 E7 38 CMPD   $E738
DDC5: 23 0C       BLS    $DDD3
DDC7: 39          RTS
DDC8: 53          COMB
DDC9: 43          COMA
DDCA: C3 00 01    ADDD   #$0001
DDCD: 10 A3 22    CMPD   $2,Y
DDD0: 23 01       BLS    $DDD3
DDD2: 39          RTS
DDD3: A6 41       LDA    $1,U
DDD5: 84 02       ANDA   #$02
DDD7: 26 12       BNE    $DDEB
DDD9: EC 5A       LDD    -$6,U
DDDB: E3 24       ADDD   $4,Y
DDDD: A3 0A       SUBD   $A,X
DDDF: B3 E7 3A    SUBD   $E73A
DDE2: 2B 12       BMI    $DDF6
DDE4: 10 B3 E7 3E CMPD   $E73E
DDE8: 23 17       BLS    $DE01
DDEA: 39          RTS
DDEB: EC 5A       LDD    -$6,U
DDED: E3 26       ADDD   $6,Y
DDEF: A3 0A       SUBD   $A,X
DDF1: B3 E7 3A    SUBD   $E73A
DDF4: 2A EE       BPL    $DDE4
DDF6: 53          COMB
DDF7: 43          COMA
DDF8: C3 00 01    ADDD   #$0001
DDFB: 10 A3 28    CMPD   $8,Y
DDFE: 23 01       BLS    $DE01
DE00: 39          RTS
DE01: C6 60       LDB    #$60
DE03: E7 47       STB    $7,U
DE05: 86 40       LDA    #$40
DE07: 97 14       STA    $14
DE09: 39          RTS
DE0A: CE 44 10    LDU    #$4410
DE0D: A6 C4       LDA    ,U
DE0F: 2A 01       BPL    $DE12
DE11: 39          RTS
DE12: E6 4B       LDB    $B,U
DE14: 2A 01       BPL    $DE17
DE16: 39          RTS
DE17: A6 45       LDA    $5,U
DE19: A1 04       CMPA   $4,X
DE1B: 27 01       BEQ    $DE1E
DE1D: 39          RTS
DE1E: 4F          CLRA
DE1F: 58          ASLB
DE20: 49          ROLA
DE21: ED E3       STD    ,--S	; [local]
DE23: 58          ASLB
DE24: 49          ROLA
DE25: 58          ASLB
DE26: 49          ROLA
DE27: E3 E1       ADDD   ,S++	; [local]
DE29: 10 8E E2 0E LDY    #$E20E
DE2D: 31 AB       LEAY   D,Y
DE2F: 7E DE 32    JMP    $DE32
DE32: EC 5C       LDD    -$4,U
DE34: E3 A4       ADDD   ,Y
DE36: A3 0C       SUBD   $C,X
DE38: B3 E7 40    SUBD   $E740
DE3B: 2B 07       BMI    $DE44
DE3D: 10 B3 E7 42 CMPD   $E742
DE41: 23 0C       BLS    $DE4F
DE43: 39          RTS
DE44: 53          COMB
DE45: 43          COMA
DE46: C3 00 01    ADDD   #$0001
DE49: 10 A3 22    CMPD   $2,Y
DE4C: 23 01       BLS    $DE4F
DE4E: 39          RTS
DE4F: A6 41       LDA    $1,U
DE51: 84 02       ANDA   #$02
DE53: 26 12       BNE    $DE67
DE55: EC 5A       LDD    -$6,U
DE57: E3 24       ADDD   $4,Y
DE59: A3 0A       SUBD   $A,X
DE5B: B3 E7 44    SUBD   $E744
DE5E: 2B 12       BMI    $DE72
DE60: 10 B3 E7 48 CMPD   $E748
DE64: 23 17       BLS    $DE7D
DE66: 39          RTS
DE67: EC 5A       LDD    -$6,U
DE69: E3 26       ADDD   $6,Y
DE6B: A3 0A       SUBD   $A,X
DE6D: B3 E7 44    SUBD   $E744
DE70: 2A EE       BPL    $DE60
DE72: 53          COMB
DE73: 43          COMA
DE74: C3 00 01    ADDD   #$0001
DE77: 10 A3 28    CMPD   $8,Y
DE7A: 23 01       BLS    $DE7D
DE7C: 39          RTS
DE7D: C6 60       LDB    #$60
DE7F: E7 47       STB    $7,U
DE81: 86 40       LDA    #$40
DE83: 97 14       STA    $14
DE85: 39          RTS

jump_table_8529:
	dc.w	$853d	; $8529
	dc.w	$853e	; $852b
	dc.w	$853f	; $852d
	dc.w	$8540	; $852f
	dc.w	$8541	; $8531
	dc.w	$8542	; $8533
	dc.w	$8543	; $8535
	dc.w	$8544	; $8537
	dc.w	$8545	; $8539
	dc.w	$8546	; $853b
jump_table_85d4:
	dc.w	$85d8	; $85d4
	dc.w	$8614	; $85d6
jump_table_8867:
	dc.w	$8877	; $8867
	dc.w	$888f	; $8869
	dc.w	$88a7	; $886b
	dc.w	$88bf	; $886d
	dc.w	$88d7	; $886f
	dc.w	$88ef	; $8871
	dc.w	$8907	; $8873
	dc.w	$891f	; $8875
jump_table_886f:
	dc.w	$88d7	; $886f
	dc.w	$88ef	; $8871
	dc.w	$8907	; $8873
	dc.w	$891f	; $8875
	dc.w	$ce8d	; $8877


jump_table_8fa9:
	dc.w	$a7e2	; $8fa9
	dc.w	$a6c0	; $8fab
jump_table_9124:
	dc.w	$9138	; $9124
	dc.w	$a24b	; $9126
	dc.w	$a2ab	; $9128
	dc.w	$a559	; $912a
	dc.w	$d5d7	; $912c
	dc.w	$9169	; $912e
	dc.w	$917b	; $9130
	dc.w	$91dc	; $9132
	dc.w	$91e9	; $9134
	dc.w	$91fb	; $9136
jump_table_927b:
	dc.w	$9289	; $927b
	dc.w	$9290	; $927d
	dc.w	$9299	; $927f
	dc.w	$92a3	; $9281
	dc.w	$92be	; $9283
	dc.w	$92d3	; $9285
	dc.w	$92e6	; $9287
jump_table_9639:
	dc.w	$9642	; $9639
	dc.w	$96e8	; $963b
	dc.w	$97a2	; $963d
	dc.w	$9641	; $963f
jump_table_992d:
	dc.w	$9935	; $992d
	dc.w	$999f	; $992f
	dc.w	$9a49	; $9931
	dc.w	$9b02	; $9933
jump_table_9931:
	dc.w	$9a49	; $9931
	dc.w	$9b02	; $9933

jump_table_9c11:
	dc.w	$9c2b	; $9c11
	dc.w	$a124	; $9c13
	dc.w	$9e27	; $9c15
	dc.w	$a24b	; $9c17
	dc.w	$a2ab	; $9c19
	dc.w	$a559	; $9c1b
	dc.w	$d5d7	; $9c1d
	dc.w	$a6da	; $9c1f
	dc.w	$9d0d	; $9c21
	dc.w	$a170	; $9c23
	dc.w	$a8c5	; $9c25
	dc.w	$a309	; $9c27
	dc.w	$ac7e	; $9c29
jump_table_9e53:
	dc.w	$9e5b	; $9e53
	dc.w	$9f63	; $9e55
	dc.w	$9fb9	; $9e57
	dc.w	$a075	; $9e59
jump_table_a17d:
	dc.w	$a185	; $a17d
	dc.w	$a18f	; $a17f
	dc.w	$a19e	; $a181
	dc.w	$a1b0	; $a183
jump_table_a316:
	dc.w	$a32a	; $a316
	dc.w	$a334	; $a318
	dc.w	$a343	; $a31a
	dc.w	$a358	; $a31c
	dc.w	$a425	; $a31e
	dc.w	$a466	; $a320
	dc.w	$a4bc	; $a322
	dc.w	$a4d1	; $a324
	dc.w	$a4fd	; $a326
	dc.w	$a53b	; $a328
jump_table_a566:
	dc.w	$a56a	; $a566
	dc.w	$a57c	; $a568
jump_table_a6e2:
	dc.w	$a6e6	; $a6e2
	dc.w	$a870	; $a6e4
jump_table_a8d2:
	dc.w	$a8e6	; $a8d2
	dc.w	$a958	; $a8d4
	dc.w	$a9fe	; $a8d6
	dc.w	$aa1e	; $a8d8
	dc.w	$aa4b	; $a8da
	dc.w	$aa72	; $a8dc
	dc.w	$aa90	; $a8de
	dc.w	$ab06	; $a8e0
	dc.w	$ab44	; $a8e2
	dc.w	$abf4	; $a8e4
jump_table_ac8b:
	dc.w	$aca3	; $ac8b
	dc.w	$acad	; $ac8d
	dc.w	$acbc	; $ac8f
	dc.w	$acd1	; $ac91
	dc.w	$ad58	; $ac93
	dc.w	$ad99	; $ac95
	dc.w	$adcc	; $ac97
	dc.w	$ae19	; $ac99
	dc.w	$ae4a	; $ac9b
	dc.w	$ae66	; $ac9d
	dc.w	$ae88	; $ac9f
	dc.w	$aee7	; $aca1
jump_table_b427:
	dc.w	$b431	; $b427
	dc.w	$b1b9	; $b429
	dc.w	$b1fe	; $b42b
	dc.w	$b2ec	; $b42d
	dc.w	$b32e	; $b42f

	
jump_table_bf44:
	dc.w	$bf4a	; $bf44
	dc.w	$bf52	; $bf46
	dc.w	$bf58	; $bf48
jump_table_bfb1:
	dc.w	$bfbb	; $bfb1
	dc.w	$bfd7	; $bfb3
	dc.w	$bfeb	; $bfb5
	dc.w	$c021	; $bfb7
	dc.w	$c02d	; $bfb9
jump_table_c058:
	dc.w	$c05e	; $c058
	dc.w	$c076	; $c05a
	dc.w	$c082	; $c05c
jump_table_c0d0:
	dc.w	$c0da	; $c0d0
	dc.w	$c0e8	; $c0d2
	dc.w	$c0da	; $c0d4
	dc.w	$c113	; $c0d6
	dc.w	$c11f	; $c0d8
jump_table_c161:
	dc.w	$c167	; $c161
	dc.w	$c185	; $c163
	dc.w	$c197	; $c165
jump_table_c1de:
	dc.w	$c1e4	; $c1de
	dc.w	$c201	; $c1e0
	dc.w	$c213	; $c1e2
jump_table_c235:
	dc.w	$c23b	; $c235
	dc.w	$c249	; $c237
	dc.w	$c26c	; $c239
jump_table_c29f:
	dc.w	$c2af	; $c29f
	dc.w	$c2b3	; $c2a1
	dc.w	$c2b3	; $c2a3
	dc.w	$c2b3	; $c2a5
	dc.w	$c2b3	; $c2a7
	dc.w	$c2b3	; $c2a9
	dc.w	$c2b3	; $c2ab
	dc.w	$c2b9	; $c2ad
jump_table_c38f:
	dc.w	$c320	; $c38f
	dc.w	$c331	; $c391
	dc.w	$c342	; $c393
	dc.w	$c353	; $c395
	dc.w	$c364	; $c397
	dc.w	$c375	; $c399
jump_table_c3ae:
	dc.w	$c3b6	; $c3ae
	dc.w	$c3b6	; $c3b0
	dc.w	$c3c1	; $c3b2
	dc.w	$c3cc	; $c3b4
jump_table_c3fe:
	dc.w	$c404	; $c3fe
	dc.w	$c443	; $c400
	dc.w	$c482	; $c402
jump_table_c5ba:
	dc.w	$c5c4	; $c5ba
	dc.w	$c5c4	; $c5bc
	dc.w	$c5c4	; $c5be
	dc.w	$c5c4	; $c5c0
	dc.w	$c60e	; $c5c2
jump_table_c745:
	dc.w	$c74d	; $c745
	dc.w	$c74d	; $c747
	dc.w	$c74d	; $c749
	dc.w	$c753	; $c74b
jump_table_c770:
	dc.w	$c788	; $c770
	dc.w	$c788	; $c772
	dc.w	$c788	; $c774
	dc.w	$c788	; $c776
	dc.w	$c788	; $c778
	dc.w	$c788	; $c77a
	dc.w	$c788	; $c77c
	dc.w	$c7c5	; $c77e
	dc.w	$c7c5	; $c780
	dc.w	$c7c5	; $c782
	dc.w	$c7c5	; $c784
	dc.w	$c7d0	; $c786
jump_table_c7ee:
	dc.w	$c7f6	; $c7ee
	dc.w	$c804	; $c7f0
	dc.w	$c7f6	; $c7f2
	dc.w	$c827	; $c7f4
jump_table_c8a8:
	dc.w	$c8b4	; $c8a8
	dc.w	$c8bf	; $c8aa
	dc.w	$c8d2	; $c8ac
	dc.w	$c8ee	; $c8ae
	dc.w	$c917	; $c8b0
	dc.w	$c946	; $c8b2
jump_table_ca47:
	dc.w	$ca83	; $ca47
	dc.w	$ca83	; $ca49
	dc.w	$ca8b	; $ca4b
	dc.w	$caa4	; $ca4d
	dc.w	$cab2	; $ca4f
	dc.w	$bdbb	; $ca51

jump_table_caf3:
	dc.w	$cafb	; $caf3
	dc.w	$cafb	; $caf5
	dc.w	$cafb	; $caf7
	dc.w	$cbe9	; $caf9
jump_table_cde7:
	dc.w	$cd7b	; $cde7
	dc.w	$cd7b	; $cde9
	dc.w	$cd86	; $cdeb
	dc.w	$cd9e	; $cded
	dc.w	$cdc0	; $cdef
	dc.w	$cd7b	; $cdf1
	dc.w	$cd7b	; $cdf3
	dc.w	$cdd2	; $cdf5
	dc.w	$cc00	; $cdf7
jump_table_ce41:
	dc.w	$ce71	; $ce41
	dc.w	$ce71	; $ce43
	dc.w	$ce71	; $ce45
	dc.w	$ce71	; $ce47
	dc.w	$ce71	; $ce49
	dc.w	$ce71	; $ce4b
	dc.w	$ce71	; $ce4d
	dc.w	$ce71	; $ce4f
	dc.w	$ce71	; $ce51
	dc.w	$ce7c	; $ce53
	dc.w	$ce9e	; $ce55
	dc.w	$ce71	; $ce57
	dc.w	$ce71	; $ce59
	dc.w	$cebd	; $ce5b
	dc.w	$ce71	; $ce5d
	dc.w	$ce71	; $ce5f
	dc.w	$ce71	; $ce61
	dc.w	$ce71	; $ce63
	dc.w	$ce71	; $ce65
	dc.w	$ce71	; $ce67
	dc.w	$ce71	; $ce69
	dc.w	$ce71	; $ce6b
	dc.w	$ce71	; $ce6d
	dc.w	$cec9	; $ce6f
jump_table_cf2e:
	dc.w	$cef4	; $cf2e
	dc.w	$cef4	; $cf30
	dc.w	$ceff	; $cf32
	dc.w	$cef4	; $cf34
	dc.w	$cef4	; $cf36
	dc.w	$cef4	; $cf38
	dc.w	$cef4	; $cf3a
	dc.w	$cef4	; $cf3c
	dc.w	$cef4	; $cf3e
	dc.w	$cef4	; $cf40
	dc.w	$cef4	; $cf42
	dc.w	$cef4	; $cf44
	dc.w	$cef4	; $cf46
	dc.w	$cf0b	; $cf48


jump_table_cf75:
	dc.w	$cf99	; $cf75
	dc.w	$cf99	; $cf77
	dc.w	$cf99	; $cf79
	dc.w	$cf99	; $cf7b
	dc.w	$cfa4	; $cf7d
	dc.w	$cfc1	; $cf7f
	dc.w	$cfe7	; $cf81
	dc.w	$d001	; $cf83
	dc.w	$cf99	; $cf85
	dc.w	$cf99	; $cf87
	dc.w	$cf99	; $cf89
	dc.w	$cf99	; $cf8b
	dc.w	$cf99	; $cf8d
	dc.w	$cf99	; $cf8f
	dc.w	$cf99	; $cf91
	dc.w	$cf99	; $cf93
	dc.w	$cf99	; $cf95
	dc.w	$d00d	; $cf97
jump_table_d03d:
	dc.w	$d04b	; $d03d
	dc.w	$d051	; $d03f
	dc.w	$d05f	; $d041
	dc.w	$d04b	; $d043
	dc.w	$d051	; $d045
	dc.w	$d04b	; $d047
	dc.w	$d088	; $d049
jump_table_d09a:
	dc.w	$d0b4	; $d09a
	dc.w	$d0ac	; $d09c
	dc.w	$d0b4	; $d09e
	dc.w	$d0b4	; $d0a0
	dc.w	$d0b4	; $d0a2
	dc.w	$d0b4	; $d0a4
	dc.w	$d0b4	; $d0a6
	dc.w	$d0b4	; $d0a8
	dc.w	$d0ba	; $d0aa
jump_table_d112:
	dc.w	$d120	; $d112
	dc.w	$d120	; $d114
	dc.w	$d120	; $d116
	dc.w	$d120	; $d118
	dc.w	$d120	; $d11a
	dc.w	$d120	; $d11c
	dc.w	$d126	; $d11e
jump_table_d13b:
	dc.w	$d15d	; $d13b
	dc.w	$d15d	; $d13d
	dc.w	$d15d	; $d13f
	dc.w	$d15d	; $d141
	dc.w	$d168	; $d143
	dc.w	$d17d	; $d145
	dc.w	$d18c	; $d147
	dc.w	$d15d	; $d149
	dc.w	$d15d	; $d14b
	dc.w	$d15d	; $d14d
	dc.w	$d15d	; $d14f
	dc.w	$d15d	; $d151
	dc.w	$d15d	; $d153
	dc.w	$d15d	; $d155
	dc.w	$d15d	; $d157
	dc.w	$d15d	; $d159
	dc.w	$d198	; $d15b
jump_table_d210:
	dc.w	$d21e	; $d210
	dc.w	$d22c	; $d212
	dc.w	$d23d	; $d214
	dc.w	$d23d	; $d216
	dc.w	$d23d	; $d218
	dc.w	$d23d	; $d21a
	dc.w	$d248	; $d21c
jump_table_d2d5:
	dc.w	$d30e	; $d2d5
	dc.w	$d2f5	; $d2d7
	dc.w	$d314	; $d2d9
	dc.w	$d30e	; $d2db
	dc.w	$d333	; $d2dd
	dc.w	$d352	; $d2df
	dc.w	$d357	; $d2e1
	dc.w	$d30e	; $d2e3
	dc.w	$d35c	; $d2e5
	dc.w	$d37b	; $d2e7
	dc.w	$d380	; $d2e9
	dc.w	$d30e	; $d2eb
	dc.w	$d30e	; $d2ed
	dc.w	$d30e	; $d2ef
	dc.w	$d30e	; $d2f1
	dc.w	$d30e	; $d2f3
jump_table_d396:
	dc.w	$d3b6	; $d396
	dc.w	$d3f3	; $d398
	dc.w	$d3b7	; $d39a
	dc.w	$d3b6	; $d39c
	dc.w	$d503	; $d39e
	dc.w	$d58b	; $d3a0
	dc.w	$d53f	; $d3a2
	dc.w	$d3b6	; $d3a4
	dc.w	$d42f	; $d3a6
	dc.w	$d4b7	; $d3a8
	dc.w	$d46b	; $d3aa
	dc.w	$d3b6	; $d3ac
	dc.w	$d3b6	; $d3ae
	dc.w	$d3b6	; $d3b0
	dc.w	$d3b6	; $d3b2
	dc.w	$d3b6	; $d3b4
jump_table_d660:
	dc.w	$d66a	; $d660
	dc.w	$d672	; $d662
	dc.w	$d697	; $d664
	dc.w	$d6bb	; $d666
	dc.w	$d6e0	; $d668
jump_table_d86e:
	dc.w	$d8d6	; $d86e
	dc.w	$d8d4	; $d870
	dc.w	$d8d4	; $d872
	dc.w	$d8d4	; $d874
	dc.w	$d8f7	; $d876
	dc.w	$d8f7	; $d878
	dc.w	$d8f7	; $d87a
	dc.w	$d8f7	; $d87c
	dc.w	$d8d5	; $d87e
	dc.w	$da13	; $d880
	dc.w	$da13	; $d882
	dc.w	$da14	; $d884
	dc.w	$da14	; $d886
	dc.w	$da14	; $d888
	dc.w	$da15	; $d88a
	dc.w	$da15	; $d88c
	dc.w	$da16	; $d88e
	dc.w	$da2c	; $d890
	dc.w	$da2d	; $d892
	dc.w	$da3f	; $d894
	dc.w	$da3f	; $d896
	dc.w	$da3f	; $d898
	dc.w	$da40	; $d89a
	dc.w	$da73	; $d89c


jump_table_daed:
	dc.w	$dbee	; $daed
	dc.w	$dbfd	; $daef
	dc.w	$dafd	; $daf1
	dc.w	$db0e	; $daf3
	dc.w	$dcf9	; $daf5
	dc.w	$dcf9	; $daf7
	dc.w	$dcb0	; $daf9
	dc.w	$dcb9	; $dafb
jump_table_db08:
	dc.w	$db1f	; $db08
	dc.w	$db69	; $db0a
	dc.w	$dbc1	; $db0c

jump_table_db19:
	dc.w	$db44	; $db19
	dc.w	$db9d	; $db1b
	dc.w	$dbc1	; $db1d
jump_table_dbf9:
	dc.w	$dc0c	; $dbf9
	dc.w	$dca1	; $dbfb

jump_table_dc08:
	dc.w	$dc53	; $dc08
	dc.w	$dca1	; $dc0a

jump_table_dcdb:
	dc.w	$dce1	; $dcdb
	dc.w	$dce9	; $dcdd
	dc.w	$dcf1	; $dcdf
jump_table_861d:
	.word	$8627
	.word	$8633
	.word	$8646
	.word	$8937
	.word	$8c87


jump_table_b6e6:
	.word	$bf6d
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$c1d6
	.word	$c1d6
	.word	$c1d6
	.word	$c1d6
	.word	$bfa9
	.word	$c0c8
	.word	$c159
	.word	$c050
	.word	$c228
	.word	$be9b
	.word	$be9b
	.word	$c1d6
	.word	$bf37
	.word	$be9b
	.word	$be9b
	.word	$bf63
	.word	$be9b
	.word	$be9b
	.word	$c292
	.word	$c292
	.word	$c292
	.word	$c292
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$b8bf
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$c1d6
	.word	$be9b
	.word	$be9b
	.word	$c1d6
	.word	$c1d6
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$be9b
	.word	$c7e1
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$cae7
	.word	$cae7
	.word	$c8a0
	.word	$c8a0
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$cae7
	.word	$ca3a
	.word	$c9c7
	.word	$c9c7
	.word	$ca3a
	.word	$c9c7
	.word	$c9c7
	.word	$c871
	.word	$c871
	.word	$c871
	.word	$c871
	.word	$c9c7
	.word	$c9c7
	.word	$c8a0
	.word	$c8a0
	.word	$b8bf
	.word	$cae7
	.word	$cae7
	.word	$c9c7
	.word	$c9c7
	.word	$cae7
	.word	$c7e1
	.word	$c9c7
	.word	$cae7
	.word	$cae7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3f6
	.word	$c2e6
	.word	$c501
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a2
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c738
	.word	$c5b2
	.word	$c768
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c5b2
	.word	$b8bf
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c5b2
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cd73
	.word	$cd73
	.word	$ce39
	.word	$cf6d
	.word	$cd73
	.word	$ceec
	.word	$d030
	.word	$cc2c
	.word	$cc2c
	.word	$cd73
	.word	$d08d
	.word	$cc2c
	.word	$cc2c
	.word	$d0c5
	.word	$cc2c
	.word	$cc2c
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d030
	.word	$d030
	.word	$d105
	.word	$d105
	.word	$b8bf
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cc2c
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$d133
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
jump_table_b750:
	.word	$c7e1
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$cae7
	.word	$cae7
	.word	$c8a0
	.word	$c8a0
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$cae7
	.word	$ca3a
	.word	$c9c7
	.word	$c9c7
	.word	$ca3a
	.word	$c9c7
	.word	$c9c7
	.word	$c871
	.word	$c871
	.word	$c871
	.word	$c871
	.word	$c9c7
	.word	$c9c7
	.word	$c8a0
	.word	$c8a0
	.word	$b8bf
	.word	$cae7
	.word	$cae7
	.word	$c9c7
	.word	$c9c7
	.word	$cae7
	.word	$c7e1
	.word	$c9c7
	.word	$cae7
	.word	$cae7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c9c7
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3f6
	.word	$c2e6
	.word	$c501
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a2
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c738
	.word	$c5b2
	.word	$c768
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c5b2
	.word	$b8bf
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c5b2
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cd73
	.word	$cd73
	.word	$ce39
	.word	$cf6d
	.word	$cd73
	.word	$ceec
	.word	$d030
	.word	$cc2c
	.word	$cc2c
	.word	$cd73
	.word	$d08d
	.word	$cc2c
	.word	$cc2c
	.word	$d0c5
	.word	$cc2c
	.word	$cc2c
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d030
	.word	$d030
	.word	$d105
	.word	$d105
	.word	$b8bf
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cc2c
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$d133
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c


jump_table_b7ba:
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3f6
	.word	$c2e6
	.word	$c501
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a2
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c738
	.word	$c5b2
	.word	$c768
	.word	$c2e6
	.word	$c2e6
	.word	$c5b2
	.word	$c5b2
	.word	$b8bf
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c3a6
	.word	$c5b2
	.word	$c2e6
	.word	$c3a6
	.word	$c3a6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$c2e6
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cd73
	.word	$cd73
	.word	$ce39
	.word	$cf6d
	.word	$cd73
	.word	$ceec
	.word	$d030
	.word	$cc2c
	.word	$cc2c
	.word	$cd73
	.word	$d08d
	.word	$cc2c
	.word	$cc2c
	.word	$d0c5
	.word	$cc2c
	.word	$cc2c
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d208
	.word	$d030
	.word	$d030
	.word	$d105
	.word	$d105
	.word	$b8bf
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$cc2c
	.word	$d105
	.word	$d105
	.word	$cc2c
	.word	$cd73
	.word	$cd73
	.word	$cc2c
	.word	$d133
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c
	.word	$cc2c


