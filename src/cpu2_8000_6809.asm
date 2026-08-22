8000: 1A 10       ORCC   #$10
8002: 10 CE 04 00 LDS    #$0400
8006: 86 16       LDA    #$16
8008: 1F 8B       TFR    A,DP
800A: 4F          CLRA
800B: B7 80 00    STA    $8000
800E: 4A          DECA
800F: 26 FA       BNE    $800B
8011: B7 80 00    STA    $8000
8014: B6 1F F0    LDA    $1FF0
8017: 26 F8       BNE    $8011
8019: 8E 20 00    LDX    #$2000
801C: A6 84       LDA    ,X
801E: 43          COMA
801F: A7 80       STA    ,X+
8021: B7 80 00    STA    $8000
8024: 8C 40 00    CMPX   #$4000
8027: 25 F3       BCS    $801C
8029: 7C 1F F0    INC    $1FF0
802C: B7 80 00    STA    $8000
802F: B6 1F F0    LDA    $1FF0
8032: 81 03       CMPA   #$03
8034: 26 F6       BNE    $802C
8036: 8E 40 00    LDX    #$4000
8039: A6 84       LDA    ,X
803B: 43          COMA
803C: A7 80       STA    ,X+
803E: B7 80 00    STA    $8000
8041: 8C 60 00    CMPX   #$6000
8044: 26 F3       BNE    $8039
8046: 7C 1F F0    INC    $1FF0
8049: B7 80 00    STA    $8000
804C: B6 1F F0    LDA    $1FF0
804F: 81 05       CMPA   #$05
8051: 26 F6       BNE    $8049
8053: 8E 04 00    LDX    #$0400
8056: A6 84       LDA    ,X
8058: 43          COMA
8059: A7 80       STA    ,X+
805B: B7 80 00    STA    $8000
805E: 8C 1F F0    CMPX   #$1FF0
8061: 26 F3       BNE    $8056
8063: 7C 1F F0    INC    $1FF0
8066: B7 80 00    STA    $8000
8069: B6 1F F0    LDA    $1FF0
806C: 81 07       CMPA   #$07
806E: 26 F6       BNE    $8066
8070: 8E 80 00    LDX    #$8000
8073: 5F          CLRB
8074: EB 80       ADDB   ,X+
8076: B7 80 00    STA    $8000
8079: 8C 00 00    CMPX   #$0000
807C: 26 F6       BNE    $8074
807E: C1 01       CMPB   #$01
8080: 27 08       BEQ    $808A
8082: B6 1F F1    LDA    $1FF1
8085: 8A 02       ORA    #$02
8087: B7 1F F1    STA    $1FF1
808A: 86 01       LDA    #$01
808C: B7 1F F3    STA    $1FF3
808F: B7 80 00    STA    $8000
8092: B6 1F F3    LDA    $1FF3
8095: 81 02       CMPA   #$02
8097: 26 F6       BNE    $808F
8099: 0F 00       CLR    $00
809B: 0F 03       CLR    $03
809D: 0F 05       CLR    $05
809F: 0F 07       CLR    $07
80A1: 1C EF       ANDCC  #$EF
80A3: BD B0 BF    JSR    $B0BF
80A6: 20 FB       BRA    $80A3
80A8: BD 80 BE    JSR    $80BE
80AB: BD 80 E9    JSR    $80E9
80AE: BD 80 FE    JSR    $80FE
80B1: BD 81 35    JSR    $8135
80B4: BD 81 60    JSR    $8160
80B7: 0C 03       INC    $03
80B9: 0F 05       CLR    $05
80BB: 0F 07       CLR    $07
80BD: 39          RTS
80BE: 8E 18 00    LDX    #$1800
80C1: CC 00 00    LDD    #$0000
80C4: 97 24       STA    $24
80C6: ED 81       STD    ,X++
80C8: 8C 1F F0    CMPX   #$1FF0
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
80E5: B7 80 00    STA    $8000
80E8: 39          RTS
80E9: 8E 00 00    LDX    #$0000
80EC: CC 00 00    LDD    #$0000
80EF: 97 20       STA    $20
80F1: 97 21       STA    $21
80F3: ED 81       STD    ,X++
80F5: 8C 03 00    CMPX   #$0300
80F8: 25 F9       BCS    $80F3
80FA: B7 80 00    STA    $8000
80FD: 39          RTS
80FE: 8E 04 00    LDX    #$0400
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
8131: B7 80 00    STA    $8000
8134: 39          RTS
8135: 8E 09 00    LDX    #$0900
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
815C: B7 80 00    STA    $8000
815F: 39          RTS
8160: 8E 13 00    LDX    #$1300
8163: CC 00 00    LDD    #$0000
8166: DD 67       STD    $67
8168: ED 81       STD    ,X++
816A: 8C 13 20    CMPX   #$1320
816D: 25 F9       BCS    $8168
816F: B7 80 00    STA    $8000
8172: 39          RTS
8173: 0C 0F       INC    $0F
8175: 96 00       LDA    $00
8177: 84 01       ANDA   #$01
8179: 26 1A       BNE    $8195
817B: 96 03       LDA    $03
817D: 91 02       CMPA   $02
817F: 22 08       BHI    $8189
8181: 8E 81 AD    LDX    #$81AD
8184: 96 03       LDA    $03
8186: 48          ASLA
8187: AD 96       JSR    [A,X]
8189: 96 1A       LDA    $1A
818B: B7 D8 03    STA    $D803
818E: B7 80 00    STA    $8000
8191: B7 88 00    STA    $8800
8194: 3B          RTI
8195: BD 81 BB    JSR    $81BB
8198: BD 83 0D    JSR    $830D
819B: BD 84 8B    JSR    $848B
819E: B7 1F F2    STA    $1FF2
81A1: 96 1A       LDA    $1A
81A3: B7 D8 03    STA    $D803
81A6: B7 80 00    STA    $8000
81A9: B7 88 00    STA    $8800
81AC: 3B          RTI
81AD: 80 A8       SUBA   #$A8
81AF: 85 2A       BITA   #$2A
81B1: 85 4F       BITA   #$4F
81B3: 87 68       XSTA   #$68
81B5: 88 00       EORA   #$00
81B7: 88 C4       EORA   #$C4
81B9: 88 E9       EORA   #$E9
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
81CE: 8E 18 00    LDX    #$1800
81D1: CC 00 00    LDD    #$0000
81D4: E7 86       STB    A,X
81D6: 8B 10       ADDA   #$10
81D8: 2A FA       BPL    $81D4
81DA: 96 52       LDA    $52
81DC: 9B 53       ADDA   $53
81DE: 27 1B       BEQ    $81FB
81E0: CE 10 00    LDU    #$1000
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
826F: 8E 00 00    LDX    #$0000
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
8309: B7 80 00    STA    $8000
830C: 39          RTS
830D: 8E 00 00    LDX    #$0000
8310: 10 8E 18 00 LDY    #$1800
8314: 96 20       LDA    $20
8316: 26 01       BNE    $8319
8318: 39          RTS
8319: 97 21       STA    $21
831B: 0F 24       CLR    $24
831D: CE 83 33    LDU    #$8333
8320: A6 94       LDA    [,X]
8322: 84 70       ANDA   #$70
8324: 44          LSRA
8325: 44          LSRA
8326: 44          LSRA
8327: AD D6       JSR    [A,U]
8329: 30 02       LEAX   $2,X
832B: 0A 21       DEC    $21
832D: 26 EE       BNE    $831D
832F: B7 80 00    STA    $8000
8332: 39          RTS
8333: 83 43 83    SUBD   #$4383
8336: 43          COMA
8337: 83 43 83    SUBD   #$4383
833A: 43          COMA
833B: 84 23       ANDA   #$23
833D: 84 23       ANDA   #$23
833F: 83 D5 83    SUBD   #$D583
8342: D5 34       BITB   $34
8344: 10 EE 84    LDS    ,X
8347: 8E 84 9B    LDX    #$849B
834A: A6 C4       LDA    ,U
834C: 44          LSRA
834D: 44          LSRA
834E: A6 86       LDA    A,X
8350: B7 D8 03    STA    $D803
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
83D5: EE 84       LDU    ,X
83D7: 34 10       PSHS   X
83D9: 86 01       LDA    #$01
83DB: B7 D8 03    STA    $D803
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
8423: EE 84       LDU    ,X
8425: 34 10       PSHS   X
8427: 86 01       LDA    #$01
8429: B7 D8 03    STA    $D803
842C: AE 4E       LDX    $E,U
842E: 27 59       BEQ    $8489
8430: A6 80       LDA    ,X+
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
844C: EC 84       LDD    ,X
844E: ED 24       STD    $4,Y
8450: E6 03       LDB    $3,X
8452: 1D          SEX
8453: D3 26       ADDD   $26
8455: 10 83 01 1F CMPD   #$011F
8459: 2E 28       BGT    $8483
845B: 10 83 FF E1 CMPD   #$FFE1
845F: 2D 22       BLT    $8483
8461: 84 01       ANDA   #$01
8463: AA 45       ORA    $5,U
8465: ED 26       STD    $6,Y
8467: E6 04       LDB    $4,X
8469: 1D          SEX
846A: D3 28       ADDD   $28
846C: 10 83 00 DF CMPD   #$00DF
8470: 2E 11       BGT    $8483
8472: 10 83 FF E1 CMPD   #$FFE1
8476: 2D 0B       BLT    $8483
8478: A6 02       LDA    $2,X
847A: AA 44       ORA    $4,U
847C: ED 28       STD    $8,Y
847E: 0C 24       INC    $24
8480: 31 A8 10    LEAY   $10,Y
8483: 30 05       LEAX   $5,X
8485: 0A 25       DEC    $25
8487: 26 C3       BNE    $844C
8489: 35 90       PULS   X,PC
848B: 31 29       LEAY   $9,Y
848D: 86 E0       LDA    #$E0
848F: A7 A4       STA    ,Y
8491: 31 A8 10    LEAY   $10,Y
8494: 10 8C 1F F0 CMPY   #$1FF0
8498: 25 F5       BCS    $848F
849A: 39          RTS
849B: 00 00       NEG    $00
849D: 01 00       NEG    $00
849F: 01 00       NEG    $00
84A1: 00 00       NEG    $00
84A3: 00 01       NEG    $01
84A5: 01 00       NEG    $00
84A7: 8E 04 10    LDX    #$0410
84AA: 96 03       LDA    $03
84AC: 81 03       CMPA   #$03
84AE: 26 06       BNE    $84B6
84B0: 10 8E 85 0F LDY    #$850F
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
84C9: BD 8D 9E    JSR    $8D9E
84CC: 6F 04       CLR    $4,X
84CE: EC A1       LDD    ,Y++
84D0: ED 1A       STD    -$6,X
84D2: EC A4       LDD    ,Y
84D4: ED 1C       STD    -$4,X
84D6: CC FF F8    LDD    #$FFF8
84D9: ED 12       STD    -$E,X
84DB: BD B0 35    JSR    $B035
84DE: 0C 05       INC    $05
84E0: 0F 07       CLR    $07
84E2: 39          RTS
84E3: 84 E7       ANDA   #$E7
84E5: 84 FB       ANDA   #$FB
84E7: 85 18       BITA   #$18
84E9: 85 21       BITA   #$21
84EB: 85 18       BITA   #$18
84ED: 85 21       BITA   #$21
84EF: 85 18       BITA   #$18
84F1: 85 18       BITA   #$18
84F3: 85 18       BITA   #$18
84F5: 85 18       BITA   #$18
84F7: 85 18       BITA   #$18
84F9: 85 18       BITA   #$18
84FB: 85 18       BITA   #$18
84FD: 85 21       BITA   #$21
84FF: 85 18       BITA   #$18
8501: 85 18       BITA   #$18
8503: 85 18       BITA   #$18
8505: 85 18       BITA   #$18
8507: 85 18       BITA   #$18
8509: 85 18       BITA   #$18
850B: 85 18       BITA   #$18
850D: 85 18       BITA   #$18
850F: 03 01       COM    $01
8511: 00 00       NEG    $00
8513: 80 05       SUBA   #$05
8515: 80 01       SUBA   #$01
8517: 00 00       NEG    $00
8519: 01 00       NEG    $00
851B: 00 80       NEG    $80
851D: 06 00       ROR    $00
851F: 01 00       NEG    $00
8521: 00 01       NEG    $01
8523: 00 00       NEG    $00
8525: 40          NEGA
8526: 06 00       ROR    $00
8528: 07 80       ASR    $80
852A: 96 05       LDA    $05
852C: 91 04       CMPA   $04
852E: 23 01       BLS    $8531
8530: 39          RTS
8531: CE 85 37    LDU    #$8537
8534: 48          ASLA
8535: 6E D6       JMP    [A,U]
8537: 85 3B       BITA   #$3B
8539: 85 4E       BITA   #$4E
853B: 0C 05       INC    $05
853D: 0F 07       CLR    $07
853F: BD 80 BE    JSR    $80BE
8542: BD 80 E9    JSR    $80E9
8545: BD 80 FE    JSR    $80FE
8548: BD 81 35    JSR    $8135
854B: 7E 81 60    JMP    $8160
854E: 39          RTS
854F: 96 05       LDA    $05
8551: 91 04       CMPA   $04
8553: 23 01       BLS    $8556
8555: 39          RTS
8556: 0D 18       TST    $18
8558: 27 01       BEQ    $855B
855A: 39          RTS
855B: CE 85 61    LDU    #$8561
855E: 48          ASLA
855F: 6E D6       JMP    [A,U]
8561: 85 67       BITA   #$67
8563: 85 8D       BITA   #$8D
8565: 85 CB       BITA   #$CB
8567: 0C 05       INC    $05
8569: 0F 07       CLR    $07
856B: CC 00 00    LDD    #$0000
856E: DD 80       STD    $80
8570: C6 08       LDB    #$08
8572: DD 82       STD    $82
8574: CC 00 08    LDD    #$0008
8577: DD 11       STD    $11
8579: 0F 13       CLR    $13
857B: BD 80 BE    JSR    $80BE
857E: BD 80 E9    JSR    $80E9
8581: BD 80 FE    JSR    $80FE
8584: BD 81 35    JSR    $8135
8587: BD 81 60    JSR    $8160
858A: 7E B0 9A    JMP    $B09A
858D: 96 06       LDA    $06
858F: 26 FC       BNE    $858D
8591: 0F 07       CLR    $07
8593: 96 06       LDA    $06
8595: 81 01       CMPA   #$01
8597: 26 FA       BNE    $8593
8599: BD 85 DA    JSR    $85DA
859C: BD 81 BB    JSR    $81BB
859F: BD 83 0D    JSR    $830D
85A2: BD 84 8B    JSR    $848B
85A5: B7 1F F2    STA    $1FF2
85A8: 96 13       LDA    $13
85AA: 4C          INCA
85AB: 84 3F       ANDA   #$3F
85AD: 97 13       STA    $13
85AF: 27 03       BEQ    $85B4
85B1: 0C 07       INC    $07
85B3: 39          RTS
85B4: CE 16 11    LDU    #$1611
85B7: CC 99 99    LDD    #$9999
85BA: BD 88 B2    JSR    $88B2
85BD: DC 11       LDD    $11
85BF: 27 03       BEQ    $85C4
85C1: 0C 07       INC    $07
85C3: 39          RTS
85C4: 0C 04       INC    $04
85C6: 0C 05       INC    $05
85C8: 0C 07       INC    $07
85CA: 39          RTS
85CB: BD 80 BE    JSR    $80BE
85CE: BD 80 E9    JSR    $80E9
85D1: BD 80 FE    JSR    $80FE
85D4: BD 81 35    JSR    $8135
85D7: 7E 81 60    JMP    $8160
85DA: 96 37       LDA    $37
85DC: 26 05       BNE    $85E3
85DE: 97 33       STA    $33
85E0: 97 39       STA    $39
85E2: 39          RTS
85E3: 8E 04 30    LDX    #$0430
85E6: 97 3B       STA    $3B
85E8: 0F 33       CLR    $33
85EA: 0F 39       CLR    $39
85EC: A6 84       LDA    ,X
85EE: 81 FF       CMPA   #$FF
85F0: 27 5C       BEQ    $864E
85F2: 84 7F       ANDA   #$7F
85F4: 81 20       CMPA   #$20
85F6: 24 56       BCC    $864E
85F8: 8D 60       BSR    $865A
85FA: A6 84       LDA    ,X
85FC: 2B 4B       BMI    $8649
85FE: CE 86 93    LDU    #$8693
8601: 81 13       CMPA   #$13
8603: 26 03       BNE    $8608
8605: CE 86 FD    LDU    #$86FD
8608: E6 01       LDB    $1,X
860A: C4 FC       ANDB   #$FC
860C: 54          LSRB
860D: AD D5       JSR    [B,U]
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
8644: BD B4 29    JSR    $B429
8647: 6F 14       CLR    -$C,X
8649: 0A 3B       DEC    $3B
864B: 26 01       BNE    $864E
864D: 39          RTS
864E: 30 88 20    LEAX   $20,X
8651: 20 99       BRA    $85EC
8653: 01 02       NEG    $02
8655: 04 08       LSR    $08
8657: 10 20 40 EC XLBRA  $C747
865B: 1C 10       ANDCC  #$10
865D: 83 FC 00    SUBD   #$FC00
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
8687: 7E B4 29    JMP    $B429
868A: 86 FF       LDA    #$FF
868C: A7 84       STA    ,X
868E: 0A 31       DEC    $31
8690: 0A 37       DEC    $37
8692: 39          RTS
8693: BB D5 B5    ADDA   $D5B5
8696: A3 87       SUBD   E,X
8698: 67 87       ASR    E,X
869A: 67 87       ASR    E,X
869C: 67 87       ASR    E,X
869E: 67 87       ASR    E,X
86A0: 67 87       ASR    E,X
86A2: 67 87       ASR    E,X
86A4: 67 87       ASR    E,X
86A6: 67 87       ASR    E,X
86A8: 67 87       ASR    E,X
86AA: 67 87       ASR    E,X
86AC: 67 87       ASR    E,X
86AE: 67 87       ASR    E,X
86B0: 67 87       ASR    E,X
86B2: 67 B5       ASR    [B,Y]
86B4: A3 87       SUBD   E,X
86B6: 67 BE       ASR    [W,Y]
86B8: 7C 87 67    INC    $8767
86BB: 87 67       XSTA   #$67
86BD: 87 67       XSTA   #$67
86BF: 87 67       XSTA   #$67
86C1: 87 67       XSTA   #$67
86C3: 87 67       XSTA   #$67
86C5: 87 67       XSTA   #$67
86C7: 87 67       XSTA   #$67
86C9: 87 67       XSTA   #$67
86CB: 87 67       XSTA   #$67
86CD: 87 67       XSTA   #$67
86CF: 87 67       XSTA   #$67
86D1: 87 67       XSTA   #$67
86D3: 87 67       XSTA   #$67
86D5: 87 67       XSTA   #$67
86D7: 87 67       XSTA   #$67
86D9: CB 01       ADDB   #$01
86DB: CB 7C       ADDB   #$7C
86DD: CB C3       ADDB   #$C3
86DF: 87 67       XSTA   #$67
86E1: 87 67       XSTA   #$67
86E3: 87 67       XSTA   #$67
86E5: 87 67       XSTA   #$67
86E7: 87 67       XSTA   #$67
86E9: 87 67       XSTA   #$67
86EB: CB D7       ADDB   #$D7
86ED: CB EB       ADDB   #$EB
86EF: CC 18 CC    LDD    #$18CC
86F2: 2C CC       BGE    $86C0
86F4: 34 CC       PSHS   PC,U,DP,B
86F6: 48          ASLA
86F7: CC 5C CC    LDD    #$5CCC
86FA: 70 CC 82    NEG    $CC82
86FD: CD          XHCF
86FE: D3 CC       ADDD   $CC
8700: AA CD D3 CD ORA    $5AD1,PCR
8704: D3 CD       ADDD   $CD
8706: D3 CD       ADDD   $CD
8708: D3 CD       ADDD   $CD
870A: E7 CD E7 CD STB    $6EDB,PCR
870E: D3 CD       ADDD   $CD
8710: D3 CD       ADDD   $CD
8712: D3 CD       ADDD   $CD
8714: D3 CD       ADDD   $CD
8716: D3 CD       ADDD   $CD
8718: D3 CD       ADDD   $CD
871A: D3 CD       ADDD   $CD
871C: D3 CC       ADDD   $CC
871E: AA CE       ORA    W,U
8720: 3A          ABX
8721: CD          XHCF
8722: FB CE 26    ADDB   $CE26
8725: CD          XHCF
8726: D3 CD       ADDD   $CD
8728: D3 CD       ADDD   $CD
872A: D3 CD       ADDD   $CD
872C: D3 CE       ADDD   $CE
872E: 7E CE 7E    JMP    $CE7E
8731: CE 7E CE    LDU    #$7ECE
8734: 7E 87 67    JMP    $8767
8737: 87 67       XSTA   #$67
8739: 87 67       XSTA   #$67
873B: 87 67       XSTA   #$67
873D: CD          XHCF
873E: D3 CD       ADDD   $CD
8740: D3 CD       ADDD   $CD
8742: D3 CD       ADDD   $CD
8744: D3 CD       ADDD   $CD
8746: D3 CD       ADDD   $CD
8748: D3 CD       ADDD   $CD
874A: D3 CC       ADDD   $CC
874C: CE CD D3    LDU    #$CDD3
874F: CD          XHCF
8750: D3 CD       ADDD   $CD
8752: D3 CD       ADDD   $CD
8754: D3 87       ADDD   $87
8756: 67 87       ASR    E,X
8758: 67 87       ASR    E,X
875A: 67 87       ASR    E,X
875C: 67 87       ASR    E,X
875E: 67 87       ASR    E,X
8760: 67 87       ASR    E,X
8762: 67 87       ASR    E,X
8764: 67 87       ASR    E,X
8766: 67 39       ASR    -$7,Y
8768: 96 05       LDA    $05
876A: 91 04       CMPA   $04
876C: 23 01       BLS    $876F
876E: 39          RTS
876F: CE 87 75    LDU    #$8775
8772: 48          ASLA
8773: 6E D6       JMP    [A,U]
8775: 87 89       XSTA   #$89
8777: 89 C4       ADCA   #$C4
8779: 89 C5       ADCA   #$C5
877B: 8A 71       ORA    #$71
877D: 84 A7       ANDA   #$A7
877F: 87 90       XSTA   #$90
8781: 87 9A       XSTA   #$9A
8783: 87 E0       XSTA   #$E0
8785: 87 E5       XSTA   #$E5
8787: 87 F4       XSTA   #$F4
8789: 0F 91       CLR    $91
878B: 0C 05       INC    $05
878D: 0F 07       CLR    $07
878F: 39          RTS
8790: 86 03       LDA    #$03
8792: B7 04 10    STA    $0410
8795: 0C 05       INC    $05
8797: 0F 07       CLR    $07
8799: 39          RTS
879A: 0F 07       CLR    $07
879C: 96 06       LDA    $06
879E: 81 01       CMPA   #$01
87A0: 26 FA       BNE    $879C
87A2: BD 98 9D    JSR    $989D
87A5: 0C 07       INC    $07
87A7: 0D 18       TST    $18
87A9: 27 01       BEQ    $87AC
87AB: 39          RTS
87AC: BD B2 78    JSR    $B278
87AF: 0C 07       INC    $07
87B1: BD CE A3    JSR    $CEA3
87B4: 0C 07       INC    $07
87B6: 96 06       LDA    $06
87B8: 81 02       CMPA   #$02
87BA: 25 FA       BCS    $87B6
87BC: BD D1 B2    JSR    $D1B2
87BF: 0C 07       INC    $07
87C1: BD AC AC    JSR    $ACAC
87C4: 0C 07       INC    $07
87C6: 96 06       LDA    $06
87C8: 81 03       CMPA   #$03
87CA: 25 FA       BCS    $87C6
87CC: BD 81 BB    JSR    $81BB
87CF: BD 83 0D    JSR    $830D
87D2: BD 84 8B    JSR    $848B
87D5: B7 1F F2    STA    $1FF2
87D8: 0C 07       INC    $07
87DA: BD AD C0    JSR    $ADC0
87DD: 7E AD 08    JMP    $AD08
87E0: 0C 05       INC    $05
87E2: 0F 07       CLR    $07
87E4: 39          RTS
87E5: 96 67       LDA    $67
87E7: 91 68       CMPA   $68
87E9: 27 01       BEQ    $87EC
87EB: 39          RTS
87EC: BD 81 60    JSR    $8160
87EF: 0C 05       INC    $05
87F1: 0F 07       CLR    $07
87F3: 39          RTS
87F4: BD 80 BE    JSR    $80BE
87F7: BD 80 E9    JSR    $80E9
87FA: BD 80 FE    JSR    $80FE
87FD: 7E 81 35    JMP    $8135
8800: 96 05       LDA    $05
8802: 91 04       CMPA   $04
8804: 23 01       BLS    $8807
8806: 39          RTS
8807: CE 88 0D    LDU    #$880D
880A: 48          ASLA
880B: 6E D6       JMP    [A,U]
880D: 88 1B       EORA   #$1B
880F: 88 2E       EORA   #$2E
8811: 88 2F       EORA   #$2F
8813: 88 30       EORA   #$30
8815: 88 53       EORA   #$53
8817: 88 8F       EORA   #$8F
8819: 88 98       EORA   #$98
881B: 0C 05       INC    $05
881D: 0F 07       CLR    $07
881F: BD 80 BE    JSR    $80BE
8822: BD 80 E9    JSR    $80E9
8825: BD 80 FE    JSR    $80FE
8828: BD 81 35    JSR    $8135
882B: 7E 81 60    JMP    $8160
882E: 39          RTS
882F: 39          RTS
8830: CC 00 00    LDD    #$0000
8833: DD 80       STD    $80
8835: C6 08       LDB    #$08
8837: DD 82       STD    $82
8839: CC 00 03    LDD    #$0003
883C: DD 11       STD    $11
883E: 0F 13       CLR    $13
8840: BD 80 BE    JSR    $80BE
8843: BD 80 E9    JSR    $80E9
8846: BD 80 FE    JSR    $80FE
8849: BD 81 35    JSR    $8135
884C: 0C 05       INC    $05
884E: 0F 07       CLR    $07
8850: 7E B0 9A    JMP    $B09A
8853: 96 D2       LDA    $D2
8855: 81 01       CMPA   #$01
8857: 26 FA       BNE    $8853
8859: BD 85 DA    JSR    $85DA
885C: BD 81 BB    JSR    $81BB
885F: BD 83 0D    JSR    $830D
8862: BD 84 8B    JSR    $848B
8865: B7 1F F2    STA    $1FF2
8868: 96 13       LDA    $13
886A: 4C          INCA
886B: 84 3F       ANDA   #$3F
886D: 97 13       STA    $13
886F: 27 03       BEQ    $8874
8871: 0C D2       INC    $D2
8873: 39          RTS
8874: CE 16 11    LDU    #$1611
8877: CC 99 99    LDD    #$9999
887A: BD 88 B2    JSR    $88B2
887D: DC 11       LDD    $11
887F: 27 03       BEQ    $8884
8881: 0C D2       INC    $D2
8883: 39          RTS
8884: 0C 04       INC    $04
8886: 0F 06       CLR    $06
8888: 0C 05       INC    $05
888A: 0F 07       CLR    $07
888C: 0C D2       INC    $D2
888E: 39          RTS
888F: BD 80 E9    JSR    $80E9
8892: BD 80 BE    JSR    $80BE
8895: 7E 80 FE    JMP    $80FE
8898: 39          RTS
8899: 34 06       PSHS   D
889B: A6 42       LDA    $2,U
889D: AB 61       ADDA   $1,S
889F: 19          DAA
88A0: A7 42       STA    $2,U
88A2: A6 41       LDA    $1,U
88A4: A9 E4       ADCA   ,S
88A6: 19          DAA
88A7: A7 41       STA    $1,U
88A9: A6 C4       LDA    ,U
88AB: 89 00       ADCA   #$00
88AD: 19          DAA
88AE: A7 C4       STA    ,U
88B0: 35 86       PULS   D,PC
88B2: 34 06       PSHS   D
88B4: A6 41       LDA    $1,U
88B6: AB 61       ADDA   $1,S
88B8: 19          DAA
88B9: A7 41       STA    $1,U
88BB: A6 C4       LDA    ,U
88BD: A9 E4       ADCA   ,S
88BF: 19          DAA
88C0: A7 C4       STA    ,U
88C2: 35 86       PULS   D,PC
88C4: 96 05       LDA    $05
88C6: 91 04       CMPA   $04
88C8: 23 01       BLS    $88CB
88CA: 39          RTS
88CB: CE 88 D1    LDU    #$88D1
88CE: 48          ASLA
88CF: 6E D6       JMP    [A,U]
88D1: 88 D5       EORA   #$D5
88D3: 88 E8       EORA   #$E8
88D5: 0C 05       INC    $05
88D7: 0F 07       CLR    $07
88D9: BD 80 BE    JSR    $80BE
88DC: BD 80 E9    JSR    $80E9
88DF: BD 80 FE    JSR    $80FE
88E2: BD 81 35    JSR    $8135
88E5: 7E 81 60    JMP    $8160
88E8: 39          RTS
88E9: 96 05       LDA    $05
88EB: 91 04       CMPA   $04
88ED: 23 01       BLS    $88F0
88EF: 39          RTS
88F0: CE 88 F6    LDU    #$88F6
88F3: 48          ASLA
88F4: 6E D6       JMP    [A,U]
88F6: 89 10       ADCA   #$10
88F8: 89 8F       ADCA   #$8F
88FA: 89 C3       ADCA   #$C3
88FC: 89 C4       ADCA   #$C4
88FE: 89 C5       ADCA   #$C5
8900: 8A 71       ORA    #$71
8902: 84 A7       ANDA   #$A7
8904: 8A 94       ORA    #$94
8906: 89 17       ADCA   #$17
8908: 89 90       ADCA   #$90
890A: 8A 95       ORA    #$95
890C: 89 CA       ADCA   #$CA
890E: 8B 1F       ADDA   #$1F
8910: 0F 91       CLR    $91
8912: 0C 05       INC    $05
8914: 0F 07       CLR    $07
8916: 39          RTS
8917: 86 FF       LDA    #$FF
8919: 97 07       STA    $07
891B: B7 80 00    STA    $8000
891E: 96 06       LDA    $06
8920: 2A F9       BPL    $891B
8922: 0F 06       CLR    $06
8924: 0D 07       TST    $07
8926: 26 FC       BNE    $8924
8928: B7 80 00    STA    $8000
892B: 96 06       LDA    $06
892D: 81 01       CMPA   #$01
892F: 25 F7       BCS    $8928
8931: BD 98 9D    JSR    $989D
8934: 0C 07       INC    $07
8936: B6 04 10    LDA    $0410
8939: 81 FF       CMPA   #$FF
893B: 27 45       BEQ    $8982
893D: 0D 1F       TST    $1F
893F: 2B 41       BMI    $8982
8941: 0D 91       TST    $91
8943: 26 3D       BNE    $8982
8945: BD B2 78    JSR    $B278
8948: 0C 07       INC    $07
894A: BD CE A3    JSR    $CEA3
894D: 0C 07       INC    $07
894F: B7 80 00    STA    $8000
8952: 96 06       LDA    $06
8954: 81 02       CMPA   #$02
8956: 25 F7       BCS    $894F
8958: BD D1 B2    JSR    $D1B2
895B: 0C 07       INC    $07
895D: BD AC AC    JSR    $ACAC
8960: 0C 07       INC    $07
8962: B7 80 00    STA    $8000
8965: 96 06       LDA    $06
8967: 81 04       CMPA   #$04
8969: 25 F7       BCS    $8962
896B: BD 81 BB    JSR    $81BB
896E: BD 83 0D    JSR    $830D
8971: BD 84 8B    JSR    $848B
8974: B7 1F F2    STA    $1FF2
8977: 0C 07       INC    $07
8979: BD AD C0    JSR    $ADC0
897C: BD AD 08    JSR    $AD08
897F: 0C 07       INC    $07
8981: 39          RTS
8982: BD 81 BB    JSR    $81BB
8985: BD 83 0D    JSR    $830D
8988: BD 84 8B    JSR    $848B
898B: B7 1F F2    STA    $1FF2
898E: 39          RTS
898F: 39          RTS
8990: CE 89 9D    LDU    #$899D
8993: 96 07       LDA    $07
8995: 91 06       CMPA   $06
8997: 23 01       BLS    $899A
8999: 39          RTS
899A: 48          ASLA
899B: 6E D6       JMP    [A,U]
899D: 89 A5       ADCA   #$A5
899F: 89 A8       ADCA   #$A8
89A1: 89 B4       ADCA   #$B4
89A3: 89 C2       ADCA   #$C2
89A5: 0C 07       INC    $07
89A7: 39          RTS
89A8: 96 67       LDA    $67
89AA: 91 68       CMPA   $68
89AC: 27 01       BEQ    $89AF
89AE: 39          RTS
89AF: 0C 07       INC    $07
89B1: 7E 81 60    JMP    $8160
89B4: 0C 07       INC    $07
89B6: BD 80 E9    JSR    $80E9
89B9: BD 80 BE    JSR    $80BE
89BC: BD 80 FE    JSR    $80FE
89BF: 7E 81 35    JMP    $8135
89C2: 39          RTS
89C3: 39          RTS
89C4: 39          RTS
89C5: 0C 05       INC    $05
89C7: 0F 07       CLR    $07
89C9: 39          RTS
89CA: 96 07       LDA    $07
89CC: 91 06       CMPA   $06
89CE: 23 01       BLS    $89D1
89D0: 39          RTS
89D1: CE 89 D7    LDU    #$89D7
89D4: 48          ASLA
89D5: 6E D6       JMP    [A,U]
89D7: 89 EB       ADCA   #$EB
89D9: 89 EE       ADCA   #$EE
89DB: 89 FA       ADCA   #$FA
89DD: 8A 08       ORA    #$08
89DF: 8A 09       ORA    #$09
89E1: 8A 0A       ORA    #$0A
89E3: 8A 2E       ORA    #$2E
89E5: 8A 66       ORA    #$66
89E7: 8A 6F       ORA    #$6F
89E9: 8A 70       ORA    #$70
89EB: 0C 07       INC    $07
89ED: 39          RTS
89EE: 96 67       LDA    $67
89F0: 91 68       CMPA   $68
89F2: 27 01       BEQ    $89F5
89F4: 39          RTS
89F5: 0C 07       INC    $07
89F7: 7E 81 60    JMP    $8160
89FA: 0C 07       INC    $07
89FC: BD 80 E9    JSR    $80E9
89FF: BD 80 BE    JSR    $80BE
8A02: BD 80 FE    JSR    $80FE
8A05: 7E 81 35    JMP    $8135
8A08: 39          RTS
8A09: 39          RTS
8A0A: 0C 07       INC    $07
8A0C: CC 00 00    LDD    #$0000
8A0F: DD 80       STD    $80
8A11: C6 08       LDB    #$08
8A13: DD 82       STD    $82
8A15: CC 00 08    LDD    #$0008
8A18: DD 11       STD    $11
8A1A: 0F 13       CLR    $13
8A1C: BD 80 BE    JSR    $80BE
8A1F: BD 80 E9    JSR    $80E9
8A22: BD 80 FE    JSR    $80FE
8A25: BD 81 35    JSR    $8135
8A28: BD 81 60    JSR    $8160
8A2B: 7E B0 9A    JMP    $B09A
8A2E: 96 D2       LDA    $D2
8A30: 81 01       CMPA   #$01
8A32: 26 FA       BNE    $8A2E
8A34: BD 85 DA    JSR    $85DA
8A37: BD 81 BB    JSR    $81BB
8A3A: BD 83 0D    JSR    $830D
8A3D: BD 84 8B    JSR    $848B
8A40: B7 1F F2    STA    $1FF2
8A43: 96 13       LDA    $13
8A45: 4C          INCA
8A46: 84 3F       ANDA   #$3F
8A48: 97 13       STA    $13
8A4A: 27 03       BEQ    $8A4F
8A4C: 0C D2       INC    $D2
8A4E: 39          RTS
8A4F: CE 16 11    LDU    #$1611
8A52: CC 99 99    LDD    #$9999
8A55: BD 88 B2    JSR    $88B2
8A58: DC 11       LDD    $11
8A5A: 27 03       BEQ    $8A5F
8A5C: 0C D2       INC    $D2
8A5E: 39          RTS
8A5F: 0C 06       INC    $06
8A61: 0C 07       INC    $07
8A63: 0C D2       INC    $D2
8A65: 39          RTS
8A66: BD 80 BE    JSR    $80BE
8A69: BD 80 E9    JSR    $80E9
8A6C: 7E 80 FE    JMP    $80FE
8A6F: 39          RTS
8A70: 39          RTS
8A71: 96 07       LDA    $07
8A73: 91 06       CMPA   $06
8A75: 23 01       BLS    $8A78
8A77: 39          RTS
8A78: CE 8A 7E    LDU    #$8A7E
8A7B: 48          ASLA
8A7C: 6E D6       JMP    [A,U]
8A7E: 8A 82       ORA    #$82
8A80: 8A 93       ORA    #$93
8A82: 0C 07       INC    $07
8A84: BD 80 BE    JSR    $80BE
8A87: BD 80 E9    JSR    $80E9
8A8A: BD 80 FE    JSR    $80FE
8A8D: BD 81 35    JSR    $8135
8A90: 7E 81 60    JMP    $8160
8A93: 39          RTS
8A94: 39          RTS
8A95: 96 07       LDA    $07
8A97: 91 06       CMPA   $06
8A99: 23 01       BLS    $8A9C
8A9B: 39          RTS
8A9C: CE 8A A2    LDU    #$8AA2
8A9F: 48          ASLA
8AA0: 6E D6       JMP    [A,U]
8AA2: 8A B6       ORA    #$B6
8AA4: 8A B7       ORA    #$B7
8AA6: 8A B8       ORA    #$B8
8AA8: 8A B9       ORA    #$B9
8AAA: 8A DA       ORA    #$DA
8AAC: 8B 12       ADDA   #$12
8AAE: 8B 1B       ADDA   #$1B
8AB0: 8B 1C       ADDA   #$1C
8AB2: 8B 1D       ADDA   #$1D
8AB4: 8B 1E       ADDA   #$1E
8AB6: 39          RTS
8AB7: 39          RTS
8AB8: 39          RTS
8AB9: 0C 07       INC    $07
8ABB: CC 00 00    LDD    #$0000
8ABE: DD 80       STD    $80
8AC0: C6 08       LDB    #$08
8AC2: DD 82       STD    $82
8AC4: CC 00 03    LDD    #$0003
8AC7: DD 11       STD    $11
8AC9: 0F 13       CLR    $13
8ACB: BD 80 BE    JSR    $80BE
8ACE: BD 80 E9    JSR    $80E9
8AD1: BD 80 FE    JSR    $80FE
8AD4: BD 81 35    JSR    $8135
8AD7: 7E B0 9A    JMP    $B09A
8ADA: 96 D2       LDA    $D2
8ADC: 81 01       CMPA   #$01
8ADE: 26 FA       BNE    $8ADA
8AE0: BD 85 DA    JSR    $85DA
8AE3: BD 81 BB    JSR    $81BB
8AE6: BD 83 0D    JSR    $830D
8AE9: BD 84 8B    JSR    $848B
8AEC: B7 1F F2    STA    $1FF2
8AEF: 96 13       LDA    $13
8AF1: 4C          INCA
8AF2: 84 3F       ANDA   #$3F
8AF4: 97 13       STA    $13
8AF6: 27 03       BEQ    $8AFB
8AF8: 0C D2       INC    $D2
8AFA: 39          RTS
8AFB: CE 16 11    LDU    #$1611
8AFE: CC 99 99    LDD    #$9999
8B01: BD 88 B2    JSR    $88B2
8B04: DC 11       LDD    $11
8B06: 27 03       BEQ    $8B0B
8B08: 0C D2       INC    $D2
8B0A: 39          RTS
8B0B: 0C 06       INC    $06
8B0D: 0C 07       INC    $07
8B0F: 0C D2       INC    $D2
8B11: 39          RTS
8B12: BD 80 BE    JSR    $80BE
8B15: BD 80 E9    JSR    $80E9
8B18: 7E 80 FE    JMP    $80FE
8B1B: 39          RTS
8B1C: 39          RTS
8B1D: 39          RTS
8B1E: 39          RTS
8B1F: 96 07       LDA    $07
8B21: 91 06       CMPA   $06
8B23: 23 01       BLS    $8B26
8B25: 39          RTS
8B26: CE 8B 2C    LDU    #$8B2C
8B29: 48          ASLA
8B2A: 6E D6       JMP    [A,U]
8B2C: 8B 44       ADDA   #$44
8B2E: 8B 47       ADDA   #$47
8B30: 8B 53       ADDA   #$53
8B32: 8B 61       ADDA   #$61
8B34: 8B 62       ADDA   #$62
8B36: 8B 63       ADDA   #$63
8B38: 8B 64       ADDA   #$64
8B3A: 8B 88       ADDA   #$88
8B3C: 8B A0       ADDA   #$A0
8B3E: 8B A9       ADDA   #$A9
8B40: 8B AA       ADDA   #$AA
8B42: 8B AB       ADDA   #$AB
8B44: 0C 07       INC    $07
8B46: 39          RTS
8B47: 96 67       LDA    $67
8B49: 91 68       CMPA   $68
8B4B: 27 01       BEQ    $8B4E
8B4D: 39          RTS
8B4E: 0C 07       INC    $07
8B50: 7E 81 60    JMP    $8160
8B53: 0C 07       INC    $07
8B55: BD 80 E9    JSR    $80E9
8B58: BD 80 BE    JSR    $80BE
8B5B: BD 80 FE    JSR    $80FE
8B5E: 7E 81 35    JMP    $8135
8B61: 39          RTS
8B62: 39          RTS
8B63: 39          RTS
8B64: 0C 07       INC    $07
8B66: CC 00 00    LDD    #$0000
8B69: DD 80       STD    $80
8B6B: C6 08       LDB    #$08
8B6D: DD 82       STD    $82
8B6F: CC 00 08    LDD    #$0008
8B72: DD 11       STD    $11
8B74: 0F 13       CLR    $13
8B76: BD 80 BE    JSR    $80BE
8B79: BD 80 E9    JSR    $80E9
8B7C: BD 80 FE    JSR    $80FE
8B7F: BD 81 35    JSR    $8135
8B82: BD 81 60    JSR    $8160
8B85: 7E B0 9A    JMP    $B09A
8B88: 96 D2       LDA    $D2
8B8A: 81 01       CMPA   #$01
8B8C: 26 FA       BNE    $8B88
8B8E: BD 85 DA    JSR    $85DA
8B91: BD 81 BB    JSR    $81BB
8B94: BD 83 0D    JSR    $830D
8B97: BD 84 8B    JSR    $848B
8B9A: B7 1F F2    STA    $1FF2
8B9D: 0C D2       INC    $D2
8B9F: 39          RTS
8BA0: BD 80 BE    JSR    $80BE
8BA3: BD 80 E9    JSR    $80E9
8BA6: 7E 80 FE    JMP    $80FE
8BA9: 39          RTS
8BAA: 39          RTS
8BAB: 39          RTS
8BAC: 03 01       COM    $01
8BAE: 1E 19       EXG    X,B
8BB0: 0A 11       DEC    $11
8BB2: 12          NOP
8BB3: 10          FCB    $10
8BB4: 11 FF 1C 0C STS    $1C0C
8BB8: 18          X18
8BB9: 1B          NOP
8BBA: 0E 03       JMP    $03
8BBC: 02 1E       XNC    $1E
8BBE: 19          DAA
8BBF: 05 16       LSR    $16
8BC1: 0A 17       DEC    $17
8BC3: FF FF 0D    STU    $FF0D
8BC6: 30 31       LEAX   -$F,Y
8BC8: FF 01 09    STU    $0109
8BCB: 08 06       ASL    $06
8BCD: FF 17 0A    STU    $170A
8BD0: 16 0C 18    LBRA   $97EB
8BD3: 13          SYNC
8BD4: 0A 15       DEC    $15
8BD6: 15          XHCF
8BD7: FF 1B 12    STU    $1B12
8BDA: 10          FCB    $10
8BDB: 11 1D       SEX
8BDD: 1C FF       ANDCC  #$FF
8BDF: 1B          NOP
8BE0: 0E 1C       JMP    $1C
8BE2: 0E 1B       JMP    $1B
8BE4: 1F 0E       TFR    D,inv
8BE6: 0D 0A       TST    $0A
8BE8: 0C 1B       INC    $1B
8BEA: 0E 0D       JMP    $0D
8BEC: 12          NOP
8BED: 1D          SEX
8BEE: FF FF FF    STU    $FFFF
8BF1: FF 07 0A    STU    $070A
8BF4: 1D          SEX
8BF5: 1D          SEX
8BF6: 1B          NOP
8BF7: 0A 0C       DEC    $0C
8BF9: 1D          SEX
8BFA: 06 1B       ROR    $1B
8BFC: 0A 1D       DEC    $1D
8BFE: 12          NOP
8BFF: 17 10 04    LBSR   $9C06
8C02: 1B          NOP
8C03: 0A 17       DEC    $17
8C05: 14          XHCF
8C06: 05 1C       LSR    $1C
8C08: 0C 18       INC    $18
8C0A: 1B          NOP
8C0B: 0E 08       JMP    $08
8C0D: 1C 1D       ANDCC  #$1D
8C0F: 18          X18
8C10: 1B          NOP
8C11: 22 FF       BHI    $8C12
8C13: FF FF 08    STU    $FF08
8C16: 0A 1B       DEC    $1B
8C18: 0E 0A       JMP    $0A
8C1A: FF FF FF    STU    $FFFF
8C1D: FF 04 17    STU    $0417
8C20: 0A 16       DEC    $16
8C22: 0E 01       JMP    $01
8C24: 01 01       NEG    $01
8C26: 02 01       XNC    $01
8C28: 03 01       COM    $01
8C2A: 04 01       LSR    $01
8C2C: 05 08       LSR    $08
8C2E: 1D          SEX
8C2F: 12          NOP
8C30: 16 0E 1B    LBRA   $9A4E
8C33: FF FF FF    STU    $FFFF
8C36: 10 1D       SEX
8C38: 18          X18
8C39: FF 0C 18    STU    $0C18
8C3C: 17 1D 12    LBSR   $A951
8C3F: 17 1E 0E    LBSR   $AA50
8C42: FF 10 0A    STU    $100A
8C45: 16 0E 0B    LBRA   $9A53
8C48: 12          NOP
8C49: 17 1C 0E    LBSR   $A85A
8C4C: 1B          NOP
8C4D: 1D          SEX
8C4E: FF 0C 18    STU    $0C18
8C51: 12          NOP
8C52: 17 04 19    LBSR   $906E
8C55: 1E 1C       EXG    X,inv
8C57: 11 0D 1D    TST    $1D
8C5A: 18          X18
8C5B: FF 1C 1D    STU    $1C1D
8C5E: 0A 1B       DEC    $1B
8C60: 1D          SEX
8C61: FF 19 1E    STU    $191E
8C64: 1C 11       ANDCC  #$11
8C66: 16 18 17    LBRA   $A480
8C69: 15          XHCF
8C6A: 22 FF       BHI    $8C6B
8C6C: 01 FF       NEG    $FF
8C6E: 19          DAA
8C6F: 15          XHCF
8C70: 0A 22       DEC    $22
8C72: 0E 1B       JMP    $1B
8C74: 2B 1C       BMI    $8C92
8C76: FF 0B 1E    STU    $0B1E
8C79: 1D          SEX
8C7A: 1D          SEX
8C7B: 18          X18
8C7C: 17 16 01    LBSR   $A280
8C7F: FF 18 1B    STU    $181B
8C82: FF 02 FF    STU    $02FF
8C85: 19          DAA
8C86: 15          XHCF
8C87: 0A 22       DEC    $22
8C89: 0E 1B       JMP    $1B
8C8B: 1C 2B       ANDCC  #$2B
8C8D: FF 0B 1E    STU    $0B1E
8C90: 1D          SEX
8C91: 1D          SEX
8C92: 18          X18
8C93: 17 0A 19    LBSR   $96AF
8C96: 15          XHCF
8C97: 0A 22       DEC    $22
8C99: 0E 1B       JMP    $1B
8C9B: FF 18 17    STU    $1817
8C9E: 0E 0A       JMP    $0A
8CA0: 19          DAA
8CA1: 15          XHCF
8CA2: 0A 22       DEC    $22
8CA4: 0E 1B       JMP    $1B
8CA6: FF 1D 20    STU    $1D20
8CA9: 18          X18
8CAA: 0A 1B       DEC    $1B
8CAC: 0E 0A       JMP    $0A
8CAE: 0D 22       TST    $22
8CB0: FF 25 FF    STU    $25FF
8CB3: FF FF 0A    STU    $FF0A
8CB6: FF FF 10    STU    $FF10
8CB9: 18          X18
8CBA: FF FF 25    STU    $FF25
8CBD: FF FF FF    STU    $FFFF
8CC0: 0A 10       DEC    $10
8CC2: 0A 16       DEC    $16
8CC4: 0E FF       JMP    $FF
8CC6: FF 18 1F    STU    $181F
8CC9: 0E 1B       JMP    $1B
8CCB: 12          NOP
8CCC: 16 12 1C    LBRA   $9EEB
8CCF: 1C 12       ANDCC  #$12
8CD1: 18          X18
8CD2: 17 FF 0C    LBSR   $8BE1
8CD5: 18          X18
8CD6: 16 19 15    LBRA   $A5EE
8CD9: 0E 1D       JMP    $1D
8CDB: 0E FF       JMP    $FF
8CDD: 25 0A       BCS    $8CE9
8CDF: 0B 1E       XDEC   $1E
8CE1: 15          XHCF
8CE2: 15          XHCF
8CE3: 0E 1D       JMP    $1D
8CE5: FF FF FF    STU    $FFFF
8CE8: FF 0A 16    STU    $0A16
8CEB: 10 FF 0B 15 STS    $0B15
8CEF: 1D          SEX
8CF0: FF FF FF    STU    $FFFF
8CF3: FF 0D 15    STU    $0D15
8CF6: 12          NOP
8CF7: 0F 0E       CLR    $0E
8CF9: FF FF FF    STU    $FFFF
8CFC: FF FF FF    STU    $FFFF
8CFF: FF FF FF    STU    $FFFF
8D02: 0F 0C       CLR    $0C
8D04: 18          X18
8D05: 17 10 1B    LBSR   $9D23
8D08: 0A 1D       DEC    $1D
8D0A: 1E 15       EXG    X,PC
8D0C: 0A 1D       DEC    $1D
8D0E: 12          NOP
8D0F: 18          X18
8D10: 17 1C 0F    LBSR   $A922
8D13: 1C 1D       ANDCC  #$1D
8D15: 18          X18
8D16: 1B          NOP
8D17: 22 FF       BHI    $8D18
8D19: FF FF FF    STU    $FFFF
8D1C: 0C 15       INC    $15
8D1E: 0E 0A       JMP    $0A
8D20: 1B          NOP
8D21: FF 0F 0A    STU    $0F0A
8D24: 1B          NOP
8D25: 0E 0A       JMP    $0A
8D27: FF FF FF    STU    $FFFF
8D2A: FF FF 0C    STU    $FF0C
8D2D: 15          XHCF
8D2E: 0E 0A       JMP    $0A
8D30: 1B          NOP
8D31: FF 08 1D    STU    $081D
8D34: 12          NOP
8D35: 16 0E FF    LBRA   $9C37
8D38: FF FF FF    STU    $FFFF
8D3B: 17 0A 0D    LBSR   $974B
8D3E: 1F 0A       TFR    D,CC
8D40: 17 0C 0E    LBSR   $9951
8D43: FF 1D 18    STU    $1D18
8D46: FF 11 12    STU    $1112
8D49: 10          FCB    $10
8D4A: 11 0E 1B    JMP    $1B
8D4D: FF 0A 1B    STU    $0A1B
8D50: 0E 0A       JMP    $0A
8D52: 1C 02       ANDCC  #$02
8D54: 0B 22       XDEC   $22
8D56: 19          DAA
8D57: 11 18       X18
8D59: 15          XHCF
8D5A: 0D 12       TST    $12
8D5C: 17 10 FF    LBSR   $9E5E
8D5F: 0D 18       TST    $18
8D61: 20 17       BRA    $8D7A
8D63: FF 1C 1D    STU    $1C1D
8D66: 0A 1B       DEC    $1B
8D68: 1D          SEX
8D69: FF 0B 1E    STU    $0B1E
8D6C: 1D          SEX
8D6D: 1D          SEX
8D6E: 18          X18
8D6F: 17 1E 2A    LBSR   $AB9C
8D72: FF 16 18    STU    $1618
8D75: 1F 12       TFR    X,Y
8D77: 17 10 FF    LBSR   $9E79
8D7A: 0C 18       INC    $18
8D7C: 17 1D 1B    LBSR   $AA9A
8D7F: 18          X18
8D80: 15          XHCF
8D81: FF 1D 18    STU    $1D18
8D84: FF 1D 11    STU    $1D11
8D87: 0E FF       JMP    $FF
8D89: 1B          NOP
8D8A: 12          NOP
8D8B: 10          FCB    $10
8D8C: 11 1D       SEX
8D8E: 26 8E       BNE    $8D1E
8D90: 04 10       LSR    $10
8D92: CC 28 FF    LDD    #$28FF
8D95: E7 84       STB    ,X
8D97: 30 88 20    LEAX   $20,X
8D9A: 4A          DECA
8D9B: 26 F8       BNE    $8D95
8D9D: 39          RTS
8D9E: A6 84       LDA    ,X
8DA0: 81 FF       CMPA   #$FF
8DA2: 27 05       BEQ    $8DA9
8DA4: 30 88 20    LEAX   $20,X
8DA7: 20 F5       BRA    $8D9E
8DA9: EC A1       LDD    ,Y++
8DAB: 8A 80       ORA    #$80
8DAD: A7 84       STA    ,X
8DAF: E7 07       STB    $7,X
8DB1: EC A1       LDD    ,Y++
8DB3: ED 02       STD    $2,X
8DB5: A6 A0       LDA    ,Y+
8DB7: A7 05       STA    $5,X
8DB9: 86 80       LDA    #$80
8DBB: A7 01       STA    $1,X
8DBD: 6F 0C       CLR    $C,X
8DBF: 6F 09       CLR    $9,X
8DC1: 6F 0D       CLR    $D,X
8DC3: 6F 0E       CLR    $E,X
8DC5: 0C 31       INC    $31
8DC7: 39          RTS
8DC8: 6F 09       CLR    $9,X
8DCA: CE 8D FB    LDU    #$8DFB
8DCD: A6 84       LDA    ,X
8DCF: 84 7C       ANDA   #$7C
8DD1: 44          LSRA
8DD2: EE C6       LDU    A,U
8DD4: E6 07       LDB    $7,X
8DD6: E7 01       STB    $1,X
8DD8: C4 FC       ANDB   #$FC
8DDA: 54          LSRB
8DDB: EE C5       LDU    B,U
8DDD: EC C1       LDD    ,U++
8DDF: A7 0A       STA    $A,X
8DE1: E7 0B       STB    $B,X
8DE3: EC C4       LDD    ,U
8DE5: ED 1E       STD    -$2,X
8DE7: 39          RTS
8DE8: 6C 09       INC    $9,X
8DEA: E6 09       LDB    $9,X
8DEC: 58          ASLB
8DED: 58          ASLB
8DEE: 33 C5       LEAU   B,U
8DF0: EC C1       LDD    ,U++
8DF2: A7 0A       STA    $A,X
8DF4: E7 0B       STB    $B,X
8DF6: EC C4       LDD    ,U
8DF8: ED 1E       STD    -$2,X
8DFA: 39          RTS
8DFB: E7 84       STB    ,X
8DFD: E7 EE       STB    W,S
8DFF: E7 EE       STB    W,S
8E01: E7 EE       STB    W,S
8E03: E8 58       EORB   -$8,U
8E05: DC 84       LDD    $84
8E07: C4 F0       ANDB   #$F0
8E09: ED E3       STD    ,--S
8E0B: DC 84       LDD    $84
8E0D: E3 16       ADDD   -$A,X
8E0F: DD 84       STD    $84
8E11: C4 F0       ANDB   #$F0
8E13: A3 E1       SUBD   ,S++
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
8E31: 8D 3B       BSR    $8E6E
8E33: 27 0D       BEQ    $8E42
8E35: BD 8E BF    JSR    $8EBF
8E38: 26 21       BNE    $8E5B
8E3A: BD 8E EF    JSR    $8EEF
8E3D: 0A 90       DEC    $90
8E3F: 26 E8       BNE    $8E29
8E41: 39          RTS
8E42: EC 1A       LDD    -$6,X
8E44: 10 83 11 00 CMPD   #$1100
8E48: 2C 11       BGE    $8E5B
8E4A: BD 8E D1    JSR    $8ED1
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
8E6E: 96 81       LDA    $81
8E70: 84 07       ANDA   #$07
8E72: 26 4A       BNE    $8EBE
8E74: CE 13 E0    LDU    #$13E0
8E77: E6 45       LDB    $5,U
8E79: CB 50       ADDB   #$50
8E7B: C4 7E       ANDB   #$7E
8E7D: E7 E2       STB    ,-S
8E7F: EC 46       LDD    $6,U
8E81: C3 0E 80    ADDD   #$0E80
8E84: 84 0F       ANDA   #$0F
8E86: EB E0       ADDB   ,S+
8E88: CE 40 00    LDU    #$4000
8E8B: ED E3       STD    ,--S
8E8D: EC CB       LDD    D,U
8E8F: C4 07       ANDB   #$07
8E91: 10 83 FF 03 CMPD   #$FF03
8E95: 26 02       BNE    $8E99
8E97: 35 86       PULS   D,PC
8E99: 96 83       LDA    $83
8E9B: 84 07       ANDA   #$07
8E9D: 26 10       BNE    $8EAF
8E9F: EC E1       LDD    ,S++
8EA1: 83 0D 80    SUBD   #$0D80
8EA4: 84 0F       ANDA   #$0F
8EA6: EC CB       LDD    D,U
8EA8: C4 07       ANDB   #$07
8EAA: 10 83 FF 03 CMPD   #$FF03
8EAE: 39          RTS
8EAF: EC E1       LDD    ,S++
8EB1: 83 0E 00    SUBD   #$0E00
8EB4: 84 0F       ANDA   #$0F
8EB6: EC CB       LDD    D,U
8EB8: C4 03       ANDB   #$03
8EBA: 10 83 FF 03 CMPD   #$FF03
8EBE: 39          RTS
8EBF: CE 13 E0    LDU    #$13E0
8EC2: A6 41       LDA    $1,U
8EC4: 84 70       ANDA   #$70
8EC6: 26 25       BNE    $8EED
8EC8: CC 01 00    LDD    #$0100
8ECB: BD 93 02    JSR    $9302
8ECE: C4 01       ANDB   #$01
8ED0: 39          RTS
8ED1: CE 13 E0    LDU    #$13E0
8ED4: A6 1B       LDA    -$5,X
8ED6: 84 70       ANDA   #$70
8ED8: A7 E2       STA    ,-S
8EDA: A6 41       LDA    $1,U
8EDC: 84 70       ANDA   #$70
8EDE: AB E0       ADDA   ,S+
8EE0: 84 70       ANDA   #$70
8EE2: 26 09       BNE    $8EED
8EE4: CC 01 00    LDD    #$0100
8EE7: BD 93 02    JSR    $9302
8EEA: C4 01       ANDB   #$01
8EEC: 39          RTS
8EED: 5F          CLRB
8EEE: 39          RTS
8EEF: 34 10       PSHS   X
8EF1: CE 13 E0    LDU    #$13E0
8EF4: DC 80       LDD    $80
8EF6: C3 00 01    ADDD   #$0001
8EF9: DD 80       STD    $80
8EFB: DC 88       LDD    $88
8EFD: 83 00 10    SUBD   #$0010
8F00: DD 88       STD    $88
8F02: A6 41       LDA    $1,U
8F04: 84 80       ANDA   #$80
8F06: A7 E2       STA    ,-S
8F08: E6 48       LDB    $8,U
8F0A: 1D          SEX
8F0B: E3 C4       ADDD   ,U
8F0D: ED C4       STD    ,U
8F0F: ED 50       STD    -$10,U
8F11: ED C8 E0    STD    -$20,U
8F14: C4 80       ANDB   #$80
8F16: E0 E0       SUBB   ,S+
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
8F59: 8D 3B       BSR    $8F96
8F5B: 27 0D       BEQ    $8F6A
8F5D: BD 8F E9    JSR    $8FE9
8F60: 26 21       BNE    $8F83
8F62: BD 90 19    JSR    $9019
8F65: 0A 90       DEC    $90
8F67: 26 E8       BNE    $8F51
8F69: 39          RTS
8F6A: EC 1A       LDD    -$6,X
8F6C: 10 83 00 10 CMPD   #$0010
8F70: 2D 11       BLT    $8F83
8F72: BD 8F FB    JSR    $8FFB
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
8F96: 96 81       LDA    $81
8F98: 84 07       ANDA   #$07
8F9A: 26 4C       BNE    $8FE8
8F9C: CE 13 E0    LDU    #$13E0
8F9F: E6 45       LDB    $5,U
8FA1: CB 06       ADDB   #$06
8FA3: C4 7F       ANDB   #$7F
8FA5: E7 E2       STB    ,-S
8FA7: EC 46       LDD    $6,U
8FA9: C3 0E 80    ADDD   #$0E80
8FAC: 84 0F       ANDA   #$0F
8FAE: C4 80       ANDB   #$80
8FB0: EB E0       ADDB   ,S+
8FB2: CE 40 00    LDU    #$4000
8FB5: ED E3       STD    ,--S
8FB7: EC CB       LDD    D,U
8FB9: C4 03       ANDB   #$03
8FBB: 10 83 FF 03 CMPD   #$FF03
8FBF: 26 02       BNE    $8FC3
8FC1: 35 86       PULS   D,PC
8FC3: 96 83       LDA    $83
8FC5: 84 07       ANDA   #$07
8FC7: 26 10       BNE    $8FD9
8FC9: EC E1       LDD    ,S++
8FCB: 83 0D 80    SUBD   #$0D80
8FCE: 84 0F       ANDA   #$0F
8FD0: EC CB       LDD    D,U
8FD2: C4 03       ANDB   #$03
8FD4: 10 83 FF 03 CMPD   #$FF03
8FD8: 39          RTS
8FD9: EC E1       LDD    ,S++
8FDB: 83 0E 00    SUBD   #$0E00
8FDE: 84 0F       ANDA   #$0F
8FE0: EC CB       LDD    D,U
8FE2: C4 03       ANDB   #$03
8FE4: 10 83 FF 03 CMPD   #$FF03
8FE8: 39          RTS
8FE9: CE 13 E0    LDU    #$13E0
8FEC: A6 41       LDA    $1,U
8FEE: 84 70       ANDA   #$70
8FF0: 26 25       BNE    $9017
8FF2: CC FE 00    LDD    #$FE00
8FF5: BD 93 02    JSR    $9302
8FF8: C4 01       ANDB   #$01
8FFA: 39          RTS
8FFB: CE 13 E0    LDU    #$13E0
8FFE: A6 1B       LDA    -$5,X
9000: 84 70       ANDA   #$70
9002: A7 E2       STA    ,-S
9004: A6 41       LDA    $1,U
9006: 84 70       ANDA   #$70
9008: AB E0       ADDA   ,S+
900A: 84 70       ANDA   #$70
900C: 26 09       BNE    $9017
900E: CC FE 00    LDD    #$FE00
9011: BD 93 02    JSR    $9302
9014: C4 01       ANDB   #$01
9016: 39          RTS
9017: 5F          CLRB
9018: 39          RTS
9019: 34 10       PSHS   X
901B: CE 13 E0    LDU    #$13E0
901E: DC 80       LDD    $80
9020: 83 00 01    SUBD   #$0001
9023: DD 80       STD    $80
9025: DC 88       LDD    $88
9027: C3 00 10    ADDD   #$0010
902A: DD 88       STD    $88
902C: A6 41       LDA    $1,U
902E: 84 80       ANDA   #$80
9030: A7 E2       STA    ,-S
9032: E6 48       LDB    $8,U
9034: 50          NEGB
9035: 1D          SEX
9036: E3 C4       ADDD   ,U
9038: ED C4       STD    ,U
903A: ED 50       STD    -$10,U
903C: ED C8 E0    STD    -$20,U
903F: C4 80       ANDB   #$80
9041: E0 E0       SUBB   ,S+
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
9076: DC 86       LDD    $86
9078: C4 F0       ANDB   #$F0
907A: ED E3       STD    ,--S
907C: DC 86       LDD    $86
907E: E3 18       ADDD   -$8,X
9080: DD 86       STD    $86
9082: C4 F0       ANDB   #$F0
9084: A3 E1       SUBD   ,S++
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
90A1: 8D 4B       BSR    $90EE
90A3: 27 14       BEQ    $90B9
90A5: BD 91 3D    JSR    $913D
90A8: 26 29       BNE    $90D3
90AA: BD 91 77    JSR    $9177
90AD: 0A 90       DEC    $90
90AF: 26 E8       BNE    $9099
90B1: EC 18       LDD    -$8,X
90B3: E3 12       ADDD   -$E,X
90B5: ED 18       STD    -$8,X
90B7: 4F          CLRA
90B8: 39          RTS
90B9: BD 91 57    JSR    $9157
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
90EE: 96 83       LDA    $83
90F0: 84 07       ANDA   #$07
90F2: 27 01       BEQ    $90F5
90F4: 39          RTS
90F5: CE 13 E0    LDU    #$13E0
90F8: 10 8E 40 00 LDY    #$4000
90FC: EC 46       LDD    $6,U
90FE: C3 00 80    ADDD   #$0080
9101: 84 0F       ANDA   #$0F
9103: C4 80       ANDB   #$80
9105: 31 AB       LEAY   D,Y
9107: E6 45       LDB    $5,U
9109: CB 08       ADDB   #$08
910B: C4 7F       ANDB   #$7F
910D: E7 E2       STB    ,-S
910F: EC A5       LDD    B,Y
9111: C4 03       ANDB   #$03
9113: 10 83 FF 03 CMPD   #$FF03
9117: 26 02       BNE    $911B
9119: 35 82       PULS   A,PC
911B: E6 E0       LDB    ,S+
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
913D: A6 01       LDA    $1,X
913F: 84 FC       ANDA   #$FC
9141: 81 28       CMPA   #$28
9143: 26 30       BNE    $9175
9145: CE 13 E0    LDU    #$13E0
9148: A6 43       LDA    $3,U
914A: 84 70       ANDA   #$70
914C: 26 27       BNE    $9175
914E: CC 00 03    LDD    #$0003
9151: BD 93 02    JSR    $9302
9154: C4 08       ANDB   #$08
9156: 39          RTS
9157: A6 01       LDA    $1,X
9159: 84 FC       ANDA   #$FC
915B: 81 28       CMPA   #$28
915D: 26 16       BNE    $9175
915F: CE 13 E0    LDU    #$13E0
9162: A6 43       LDA    $3,U
9164: 84 70       ANDA   #$70
9166: AB 1C       ADDA   -$4,X
9168: 84 70       ANDA   #$70
916A: 26 09       BNE    $9175
916C: CC 00 03    LDD    #$0003
916F: BD 93 02    JSR    $9302
9172: C4 08       ANDB   #$08
9174: 39          RTS
9175: 5F          CLRB
9176: 39          RTS
9177: 34 10       PSHS   X
9179: CE 13 E0    LDU    #$13E0
917C: DC 82       LDD    $82
917E: C3 00 01    ADDD   #$0001
9181: DD 82       STD    $82
9183: DC 8A       LDD    $8A
9185: 83 00 10    SUBD   #$0010
9188: DD 8A       STD    $8A
918A: A6 43       LDA    $3,U
918C: 84 80       ANDA   #$80
918E: A7 E2       STA    ,-S
9190: E6 49       LDB    $9,U
9192: 1D          SEX
9193: E3 42       ADDD   $2,U
9195: ED 42       STD    $2,U
9197: ED 52       STD    -$E,U
9199: ED C8 E2    STD    -$1E,U
919C: C4 80       ANDB   #$80
919E: E0 E0       SUBB   ,S+
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
91DC: 8D 78       BSR    $9256
91DE: 27 1A       BEQ    $91FA
91E0: BD 92 A5    JSR    $92A5
91E3: 26 15       BNE    $91FA
91E5: BD 93 55    JSR    $9355
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
9208: BD 92 D6    JSR    $92D6
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
9256: 96 83       LDA    $83
9258: 84 07       ANDA   #$07
925A: 27 01       BEQ    $925D
925C: 39          RTS
925D: CE 13 E0    LDU    #$13E0
9260: 10 8E 40 00 LDY    #$4000
9264: EC 46       LDD    $6,U
9266: C3 0F 00    ADDD   #$0F00
9269: 84 0F       ANDA   #$0F
926B: C4 80       ANDB   #$80
926D: 31 AB       LEAY   D,Y
926F: E6 45       LDB    $5,U
9271: CB 08       ADDB   #$08
9273: C4 7F       ANDB   #$7F
9275: E7 E2       STB    ,-S
9277: EC A5       LDD    B,Y
9279: C4 03       ANDB   #$03
927B: 10 83 FF 03 CMPD   #$FF03
927F: 26 02       BNE    $9283
9281: 35 82       PULS   A,PC
9283: E6 E0       LDB    ,S+
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
92A5: CE 13 E0    LDU    #$13E0
92A8: A6 43       LDA    $3,U
92AA: 84 70       ANDA   #$70
92AC: 26 52       BNE    $9300
92AE: CC 00 FF    LDD    #$00FF
92B1: 8D 4F       BSR    $9302
92B3: C5 06       BITB   #$06
92B5: 27 49       BEQ    $9300
92B7: A7 E2       STA    ,-S
92B9: 84 EE       ANDA   #$EE
92BB: 81 20       CMPA   #$20
92BD: 27 10       BEQ    $92CF
92BF: A6 01       LDA    $1,X
92C1: 84 FC       ANDA   #$FC
92C3: 81 2C       CMPA   #$2C
92C5: 27 04       BEQ    $92CB
92C7: C5 02       BITB   #$02
92C9: 35 82       PULS   A,PC
92CB: C5 04       BITB   #$04
92CD: 35 82       PULS   A,PC
92CF: C4 C0       ANDB   #$C0
92D1: E7 05       STB    $5,X
92D3: 5F          CLRB
92D4: 35 82       PULS   A,PC
92D6: CE 13 E0    LDU    #$13E0
92D9: A6 1D       LDA    -$3,X
92DB: 84 70       ANDA   #$70
92DD: AB 43       ADDA   $3,U
92DF: 84 70       ANDA   #$70
92E1: 26 1D       BNE    $9300
92E3: CC 00 FF    LDD    #$00FF
92E6: 8D 1A       BSR    $9302
92E8: C5 06       BITB   #$06
92EA: 27 14       BEQ    $9300
92EC: A7 E2       STA    ,-S
92EE: 84 EE       ANDA   #$EE
92F0: 81 20       CMPA   #$20
92F2: 27 DB       BEQ    $92CF
92F4: A6 01       LDA    $1,X
92F6: 84 FC       ANDA   #$FC
92F8: 81 2C       CMPA   #$2C
92FA: 27 CF       BEQ    $92CB
92FC: C5 02       BITB   #$02
92FE: 35 82       PULS   A,PC
9300: 5F          CLRB
9301: 39          RTS
9302: 8D 20       BSR    $9324
9304: CE 40 00    LDU    #$4000
9307: EC CB       LDD    D,U
9309: C4 03       ANDB   #$03
930B: C1 03       CMPB   #$03
930D: 27 02       BEQ    $9311
930F: 5F          CLRB
9310: 39          RTS
9311: CE E6 7C    LDU    #$E67C
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
9324: ED E3       STD    ,--S
9326: E6 41       LDB    $1,U
9328: C4 70       ANDB   #$70
932A: 1D          SEX
932B: E3 1A       ADDD   -$6,X
932D: 58          ASLB
932E: 49          ROLA
932F: AB E0       ADDA   ,S+
9331: 8B 04       ADDA   #$04
9333: 48          ASLA
9334: AB 45       ADDA   $5,U
9336: 84 7E       ANDA   #$7E
9338: A7 E2       STA    ,-S
933A: E6 43       LDB    $3,U
933C: C4 70       ANDB   #$70
933E: 1D          SEX
933F: E3 1C       ADDD   -$4,X
9341: 58          ASLB
9342: 49          ROLA
9343: AB 61       ADDA   $1,S
9345: A7 E2       STA    ,-S
9347: 86 1D       LDA    #$1D
9349: A0 E0       SUBA   ,S+
934B: C6 80       LDB    #$80
934D: 3D          MUL
934E: E3 46       ADDD   $6,U
9350: 84 0F       ANDA   #$0F
9352: EB E1       ADDB   ,S++
9354: 39          RTS
9355: 34 10       PSHS   X
9357: CE 13 E0    LDU    #$13E0
935A: DC 82       LDD    $82
935C: 83 00 01    SUBD   #$0001
935F: DD 82       STD    $82
9361: DC 8A       LDD    $8A
9363: C3 00 10    ADDD   #$0010
9366: DD 8A       STD    $8A
9368: A6 43       LDA    $3,U
936A: 84 80       ANDA   #$80
936C: A7 E2       STA    ,-S
936E: E6 49       LDB    $9,U
9370: 50          NEGB
9371: 1D          SEX
9372: E3 42       ADDD   $2,U
9374: ED 42       STD    $2,U
9376: ED 52       STD    -$E,U
9378: ED C8 E2    STD    -$1E,U
937B: C4 80       ANDB   #$80
937D: E0 E0       SUBB   ,S+
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
93E6: BD 8E 6E    JSR    $8E6E
93E9: 27 E5       BEQ    $93D0
93EB: 7E 8E EF    JMP    $8EEF
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
941D: BD 8F 96    JSR    $8F96
9420: 27 E5       BEQ    $9407
9422: 7E 90 19    JMP    $9019
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
9458: BD 90 EE    JSR    $90EE
945B: 27 E5       BEQ    $9442
945D: 7E 91 77    JMP    $9177
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
948F: BD 92 56    JSR    $9256
9492: 27 E5       BEQ    $9479
9494: 7E 93 55    JMP    $9355
9497: EC 16       LDD    -$A,X
9499: 2B 74       BMI    $950F
949B: E3 1A       ADDD   -$6,X
949D: 10 83 14 00 CMPD   #$1400
94A1: 2C 36       BGE    $94D9
94A3: 32 7D       LEAS   -$3,S
94A5: ED E4       STD    ,S
94A7: EC 1A       LDD    -$6,X
94A9: A6 84       LDA    ,X
94AB: 81 10       CMPA   #$10
94AD: 24 17       BCC    $94C6
94AF: CE 13 E0    LDU    #$13E0
94B2: C4 70       ANDB   #$70
94B4: EB 41       ADDB   $1,U
94B6: C4 70       ANDB   #$70
94B8: 26 0C       BNE    $94C6
94BA: CC 01 00    LDD    #$0100
94BD: BD 93 02    JSR    $9302
94C0: A7 62       STA    $2,S
94C2: C4 01       ANDB   #$01
94C4: 26 20       BNE    $94E6
94C6: EC 1A       LDD    -$6,X
94C8: C3 00 10    ADDD   #$0010
94CB: ED 1A       STD    -$6,X
94CD: 10 A3 E4    CMPD   ,S
94D0: 2F D7       BLE    $94A9
94D2: EC E1       LDD    ,S++
94D4: ED 1A       STD    -$6,X
94D6: 5F          CLRB
94D7: 35 82       PULS   A,PC
94D9: 0A 31       DEC    $31
94DB: 0A 37       DEC    $37
94DD: 0A 33       DEC    $33
94DF: 0A 39       DEC    $39
94E1: C6 FF       LDB    #$FF
94E3: E7 84       STB    ,X
94E5: 39          RTS
94E6: 32 62       LEAS   $2,S
94E8: E6 1B       LDB    -$5,X
94EA: C4 F0       ANDB   #$F0
94EC: E7 1B       STB    -$5,X
94EE: E6 0C       LDB    $C,X
94F0: CA 01       ORB    #$01
94F2: E7 0C       STB    $C,X
94F4: CE 95 4D    LDU    #$954D
94F7: 6D 03       TST    $3,X
94F9: 2A 03       BPL    $94FE
94FB: 33 C8 10    LEAU   $10,U
94FE: C6 08       LDB    #$08
9500: A6 E0       LDA    ,S+
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
9517: 32 7D       LEAS   -$3,S
9519: ED E4       STD    ,S
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
9531: BD 93 02    JSR    $9302
9534: A7 62       STA    $2,S
9536: C4 01       ANDB   #$01
9538: 26 AC       BNE    $94E6
953A: EC 1A       LDD    -$6,X
953C: C3 FF F0    ADDD   #$FFF0
953F: ED 1A       STD    -$6,X
9541: 10 A3 E4    CMPD   ,S
9544: 2C D7       BGE    $951D
9546: EC E1       LDD    ,S++
9548: ED 1A       STD    -$6,X
954A: 5F          CLRB
954B: 35 82       PULS   A,PC
954D: 19          DAA
954E: 48          ASLA
954F: 22 48       BHI    $9599
9551: 24 24       BCC    $9577
9553: 25 08       BCS    $955D
9555: 26 24       BNE    $957B
9557: 27 28       BEQ    $9581
9559: 2C 24       BGE    $957F
955B: 2D 3C       BLT    $9599
955D: 19          DAA
955E: 48          ASLA
955F: 22 48       BHI    $95A9
9561: 24 0C       BCC    $956F
9563: 25 08       BCS    $956D
9565: 26 0C       BNE    $9573
9567: 27 28       BEQ    $9591
9569: 2C 0C       BGE    $9577
956B: 2D 3C       BLT    $95A9
956D: EC 18       LDD    -$8,X
956F: 2F 63       BLE    $95D4
9571: E3 1C       ADDD   -$4,X
9573: 10 83 0F 80 CMPD   #$0F80
9577: 2C 3E       BGE    $95B7
9579: 32 7D       LEAS   -$3,S
957B: ED E4       STD    ,S
957D: A6 01       LDA    $1,X
957F: 84 FC       ANDA   #$FC
9581: 81 28       CMPA   #$28
9583: 26 25       BNE    $95AA
9585: EC 1C       LDD    -$4,X
9587: CE 13 E0    LDU    #$13E0
958A: C4 70       ANDB   #$70
958C: EB 43       ADDB   $3,U
958E: C4 70       ANDB   #$70
9590: 26 0C       BNE    $959E
9592: CC 00 03    LDD    #$0003
9595: BD 93 02    JSR    $9302
9598: A7 62       STA    $2,S
959A: C4 08       ANDB   #$08
959C: 26 26       BNE    $95C4
959E: EC 1C       LDD    -$4,X
95A0: C3 00 10    ADDD   #$0010
95A3: ED 1C       STD    -$4,X
95A5: 10 A3 E4    CMPD   ,S
95A8: 2F DD       BLE    $9587
95AA: EC E1       LDD    ,S++
95AC: ED 1C       STD    -$4,X
95AE: EC 18       LDD    -$8,X
95B0: E3 12       ADDD   -$E,X
95B2: ED 18       STD    -$8,X
95B4: 5F          CLRB
95B5: 35 82       PULS   A,PC
95B7: 0A 31       DEC    $31
95B9: 0A 37       DEC    $37
95BB: 0A 33       DEC    $33
95BD: 0A 39       DEC    $39
95BF: C6 FF       LDB    #$FF
95C1: E7 84       STB    ,X
95C3: 39          RTS
95C4: 32 62       LEAS   $2,S
95C6: A6 1D       LDA    -$3,X
95C8: 84 F0       ANDA   #$F0
95CA: A7 1D       STA    -$3,X
95CC: A6 0C       LDA    $C,X
95CE: 8A 02       ORA    #$02
95D0: A7 0C       STA    $C,X
95D2: 35 82       PULS   A,PC
95D4: E3 1C       ADDD   -$4,X
95D6: 10 83 FC 80 CMPD   #$FC80
95DA: 2D DB       BLT    $95B7
95DC: 32 7D       LEAS   -$3,S
95DE: ED E4       STD    ,S
95E0: EC 1C       LDD    -$4,X
95E2: CE 13 E0    LDU    #$13E0
95E5: C4 70       ANDB   #$70
95E7: EB 43       ADDB   $3,U
95E9: C4 70       ANDB   #$70
95EB: 26 24       BNE    $9611
95ED: CC 00 FF    LDD    #$00FF
95F0: BD 93 02    JSR    $9302
95F3: A7 62       STA    $2,S
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
9609: A6 62       LDA    $2,S
960B: 84 EE       ANDA   #$EE
960D: 81 20       CMPA   #$20
960F: 26 B3       BNE    $95C4
9611: EC 1C       LDD    -$4,X
9613: C3 FF F0    ADDD   #$FFF0
9616: ED 1C       STD    -$4,X
9618: 10 A3 E4    CMPD   ,S
961B: 2C C5       BGE    $95E2
961D: EC E1       LDD    ,S++
961F: ED 1C       STD    -$4,X
9621: EC 18       LDD    -$8,X
9623: E3 12       ADDD   -$E,X
9625: ED 18       STD    -$8,X
9627: 5F          CLRB
9628: 35 82       PULS   A,PC
962A: E6 0D       LDB    $D,X
962C: 58          ASLB
962D: EA 0D       ORB    $D,X
962F: C4 02       ANDB   #$02
9631: E7 0D       STB    $D,X
9633: 10 8E E1 40 LDY    #$E140
9637: F6 04 1B    LDB    $041B
963A: C4 7F       ANDB   #$7F
963C: 4F          CLRA
963D: 58          ASLB
963E: 49          ROLA
963F: ED E3       STD    ,--S
9641: 58          ASLB
9642: 49          ROLA
9643: 58          ASLB
9644: 49          ROLA
9645: E3 E1       ADDD   ,S++
9647: 31 AB       LEAY   D,Y
9649: CE E1 40    LDU    #$E140
964C: E6 0B       LDB    $B,X
964E: C4 7F       ANDB   #$7F
9650: 4F          CLRA
9651: 58          ASLB
9652: 49          ROLA
9653: ED E3       STD    ,--S
9655: 58          ASLB
9656: 49          ROLA
9657: 58          ASLB
9658: 49          ROLA
9659: E3 E1       ADDD   ,S++
965B: 33 CB       LEAU   D,U
965D: 8D 5D       BSR    $96BC
965F: C5 40       BITB   #$40
9661: 26 01       BNE    $9664
9663: 39          RTS
9664: CE 04 10    LDU    #$0410
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
967B: A7 E2       STA    ,-S
967D: 96 C1       LDA    $C1
967F: A0 E0       SUBA   ,S+
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
96B1: 7E B4 29    JMP    $B429
96B4: E6 0D       LDB    $D,X
96B6: C4 FE       ANDB   #$FE
96B8: E7 0D       STB    $D,X
96BA: 5F          CLRB
96BB: 39          RTS
96BC: FC 04 0C    LDD    $040C
96BF: E3 A4       ADDD   ,Y
96C1: A3 1C       SUBD   -$4,X
96C3: A3 C4       SUBD   ,U
96C5: 2B 23       BMI    $96EA
96C7: 10 83 05 00 CMPD   #$0500
96CB: 2E 15       BGT    $96E2
96CD: 10 A3 42    CMPD   $2,U
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
96EF: 10 A3 22    CMPD   $2,Y
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
9717: E3 24       ADDD   $4,Y
9719: A3 1A       SUBD   -$6,X
971B: A3 46       SUBD   $6,U
971D: 2B 68       BMI    $9787
971F: 20 1E       BRA    $973F
9721: A6 01       LDA    $1,X
9723: 84 02       ANDA   #$02
9725: 26 0D       BNE    $9734
9727: FC 04 0A    LDD    $040A
972A: E3 26       ADDD   $6,Y
972C: A3 1A       SUBD   -$6,X
972E: A3 44       SUBD   $4,U
9730: 2B 55       BMI    $9787
9732: 20 0B       BRA    $973F
9734: FC 04 0A    LDD    $040A
9737: E3 26       ADDD   $6,Y
9739: A3 1A       SUBD   -$6,X
973B: A3 46       SUBD   $6,U
973D: 2B 48       BMI    $9787
973F: 10 A3 48    CMPD   $8,U
9742: 2E 19       BGT    $975D
9744: CE 04 10    LDU    #$0410
9747: A6 05       LDA    $5,X
9749: A1 45       CMPA   $5,U
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
978C: 10 A3 28    CMPD   $8,Y
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
97D0: CE 04 10    LDU    #$0410
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
97E4: ED E3       STD    ,--S
97E6: 58          ASLB
97E7: 49          ROLA
97E8: 58          ASLB
97E9: 49          ROLA
97EA: E3 E1       ADDD   ,S++
97EC: 10 8E E1 40 LDY    #$E140
97F0: 31 AB       LEAY   D,Y
97F2: 8D 20       BSR    $9814
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
9811: 7E B4 29    JMP    $B429
9814: EC 5C       LDD    -$4,U
9816: E3 A4       ADDD   ,Y
9818: A3 1C       SUBD   -$4,X
981A: B3 E6 5E    SUBD   $E65E
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
989D: 8E 04 10    LDX    #$0410
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
98B9: BD 99 3B    JSR    $993B
98BC: 0C 33       INC    $33
98BE: CE 99 51    LDU    #$9951
98C1: E6 01       LDB    $1,X
98C3: C4 FC       ANDB   #$FC
98C5: 54          LSRB
98C6: AD D5       JSR    [B,U]
98C8: 8D 03       BSR    $98CD
98CA: 7E 98 F0    JMP    $98F0
98CD: A6 84       LDA    ,X
98CF: 85 03       BITA   #$03
98D1: 26 01       BNE    $98D4
98D3: 39          RTS
98D4: 6D 14       TST    -$C,X
98D6: 26 01       BNE    $98D9
98D8: 39          RTS
98D9: CE EB 00    LDU    #$EB00
98DC: A6 15       LDA    -$B,X
98DE: 4C          INCA
98DF: 84 7F       ANDA   #$7F
98E1: A7 15       STA    -$B,X
98E3: E6 C6       LDB    A,U
98E5: 2A 04       BPL    $98EB
98E7: 6F 15       CLR    -$B,X
98E9: E6 C4       LDB    ,U
98EB: 8D 4E       BSR    $993B
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
9926: BD 9A 62    JSR    $9A62
9929: 27 01       BEQ    $992C
992B: 39          RTS
992C: 0C 91       INC    $91
992E: 86 40       LDA    #$40
9930: A7 05       STA    $5,X
9932: C6 9C       LDB    #$9C
9934: 7E 99 3B    JMP    $993B
9937: 96 0A       LDA    $0A
9939: E6 C6       LDB    A,U
993B: E7 07       STB    $7,X
993D: C5 03       BITB   #$03
993F: 26 08       BNE    $9949
9941: E6 01       LDB    $1,X
9943: C4 03       ANDB   #$03
9945: EB 07       ADDB   $7,X
9947: E7 07       STB    $7,X
9949: C4 FC       ANDB   #$FC
994B: 54          LSRB
994C: CE 99 BB    LDU    #$99BB
994F: 6E D5       JMP    [B,U]
9951: 9A 28       ORA    $28
9953: 9A 90       ORA    $90
9955: AB 4F       ADDA   $F,U
9957: A1 37       CMPA   -$9,Y
9959: A1 4B       CMPA   $B,U
995B: A1 5F       CMPA   -$1,U
995D: A1 A3       CMPA   ,--Y
995F: A3 96       SUBD   [A,X]
9961: A8 1B       EORA   -$5,X
9963: A8 3D       EORA   -$3,Y
9965: A9 14       ADCA   -$C,X
9967: AA 6B       ORA    $B,S
9969: AA DE       ORA    [W,U]
996B: A9 B0 AB 5C ADCA   [-$54A4,W]
996F: AB 5D       ADDA   -$3,U
9971: 9A 90       ORA    $90
9973: A1 A3       CMPA   ,--Y
9975: AB 5E       ADDA   -$2,U
9977: 9B F6       ADDA   $F6
9979: 9C E3       CMPX   $E3
997B: AB 5F       ADDA   -$1,U
997D: 9E 46       LDX    $46
997F: 9F 7F       STX    $7F
9981: AB 74       ADDA   -$C,S
9983: AB 74       ADDA   -$C,S
9985: AB 74       ADDA   -$C,S
9987: AB 74       ADDA   -$C,S
9989: 9A 28       ORA    $28
998B: 9A 28       ORA    $28
998D: AC 40       CMPX   $0,U
998F: 9A 28       ORA    $28
9991: 9A 28       ORA    $28
9993: 9A 28       ORA    $28
9995: 9A 28       ORA    $28
9997: 9A 28       ORA    $28
9999: 9A 28       ORA    $28
999B: 9A 28       ORA    $28
999D: 9A 28       ORA    $28
999F: 9B 56       ADDA   $56
99A1: A5 0D       BITA   $D,X
99A3: A6 B6       LDA    [A,Y]
99A5: A0 2F       SUBA   $F,Y
99A7: A0 A7       SUBA   E,Y
99A9: 9A 28       ORA    $28
99AB: 9A 28       ORA    $28
99AD: 9A 28       ORA    $28
99AF: 9A 28       ORA    $28
99B1: 9A 28       ORA    $28
99B3: 9A 28       ORA    $28
99B5: 9A 28       ORA    $28
99B7: 9A 28       ORA    $28
99B9: 9A 28       ORA    $28
99BB: 9A 25       ORA    $25
99BD: 9A 3C       ORA    $3C
99BF: 9D B2       JSR    $B2
99C1: 9E 2F       LDX    $2F
99C3: A1 31       CMPA   -$F,Y
99C5: A1 34       CMPA   -$C,Y
99C7: A1 73       CMPA   -$D,S
99C9: A3 66       SUBD   $6,S
99CB: A8 13       EORA   -$D,X
99CD: A8 13       EORA   -$D,X
99CF: A8 C5       EORA   B,U
99D1: AA 18       ORA    -$8,X
99D3: AA 52       ORA    -$E,U
99D5: A8 F2       EORA   Illegal Postbyte
99D7: 8D C8       BSR    $99A1
99D9: 8D C8       BSR    $99A3
99DB: 9A 3C       ORA    $3C
99DD: A1 73       CMPA   -$D,S
99DF: 8D C8       BSR    $99A9
99E1: 9B 86       ADDA   $86
99E3: 9B BE       ADDA   $BE
99E5: 8D C8       BSR    $99AF
99E7: 8D C8       BSR    $99B1
99E9: 8D C8       BSR    $99B3
99EB: AB 60       ADDA   $0,S
99ED: AB 60       ADDA   $0,S
99EF: AB 60       ADDA   $0,S
99F1: AB 60       ADDA   $0,S
99F3: 8D C8       BSR    $99BD
99F5: 8D C8       BSR    $99BF
99F7: AC 17       CMPX   -$9,X
99F9: 8D C8       BSR    $99C3
99FB: 8D C8       BSR    $99C5
99FD: 8D C8       BSR    $99C7
99FF: 8D C8       BSR    $99C9
9A01: 8D C8       BSR    $99CB
9A03: 8D C8       BSR    $99CD
9A05: 8D C8       BSR    $99CF
9A07: 8D C8       BSR    $99D1
9A09: 9A 3C       ORA    $3C
9A0B: A1 73       CMPA   -$D,S
9A0D: A3 66       SUBD   $6,S
9A0F: 8D C8       BSR    $99D9
9A11: 8D C8       BSR    $99DB
9A13: 8D C8       BSR    $99DD
9A15: 8D C8       BSR    $99DF
9A17: 8D C8       BSR    $99E1
9A19: 8D C8       BSR    $99E3
9A1B: 8D C8       BSR    $99E5
9A1D: 8D C8       BSR    $99E7
9A1F: 8D C8       BSR    $99E9
9A21: 8D C8       BSR    $99EB
9A23: 8D C8       BSR    $99ED
9A25: 7E 8D C8    JMP    $8DC8
9A28: 6A 0A       DEC    $A,X
9A2A: 27 01       BEQ    $9A2D
9A2C: 39          RTS
9A2D: A6 84       LDA    ,X
9A2F: 84 03       ANDA   #$03
9A31: 26 06       BNE    $9A39
9A33: CE E0 14    LDU    #$E014
9A36: 7E 99 37    JMP    $9937
9A39: 6C 14       INC    -$C,X
9A3B: 39          RTS
9A3C: A6 84       LDA    ,X
9A3E: 84 03       ANDA   #$03
9A40: 26 07       BNE    $9A49
9A42: A6 07       LDA    $7,X
9A44: A1 01       CMPA   $1,X
9A46: 26 01       BNE    $9A49
9A48: 39          RTS
9A49: BD 9A D5    JSR    $9AD5
9A4C: A6 07       LDA    $7,X
9A4E: 84 02       ANDA   #$02
9A50: 26 08       BNE    $9A5A
9A52: CC 00 20    LDD    #$0020
9A55: ED 16       STD    -$A,X
9A57: 7E 8D C8    JMP    $8DC8
9A5A: CC FF E0    LDD    #$FFE0
9A5D: ED 16       STD    -$A,X
9A5F: 7E 8D C8    JMP    $8DC8
9A62: EC 1A       LDD    -$6,X
9A64: 10 83 FF 00 CMPD   #$FF00
9A68: 2D 21       BLT    $9A8B
9A6A: 10 83 13 00 CMPD   #$1300
9A6E: 2E 1B       BGT    $9A8B
9A70: CE 13 E0    LDU    #$13E0
9A73: CC 00 FF    LDD    #$00FF
9A76: BD 93 02    JSR    $9302
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
9A90: BD 8E 05    JSR    $8E05
9A93: 8D 65       BSR    $9AFA
9A95: 10 26 FE A2 LBNE   $993B
9A99: 8D C7       BSR    $9A62
9A9B: 10 26 FE 9C LBNE   $993B
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
9AB3: 8D 20       BSR    $9AD5
9AB5: CE D9 50    LDU    #$D950
9AB8: BD 8D E8    JSR    $8DE8
9ABB: CE E0 14    LDU    #$E014
9ABE: 7E 99 37    JMP    $9937
9AC1: 6A 0A       DEC    $A,X
9AC3: 27 01       BEQ    $9AC6
9AC5: 39          RTS
9AC6: A6 09       LDA    $9,X
9AC8: 81 05       CMPA   #$05
9ACA: 27 06       BEQ    $9AD2
9ACC: CE D9 50    LDU    #$D950
9ACF: 7E 8D E8    JMP    $8DE8
9AD2: 6C 14       INC    -$C,X
9AD4: 39          RTS
9AD5: CE 9A F0    LDU    #$9AF0
9AD8: 96 C2       LDA    $C2
9ADA: 48          ASLA
9ADB: 48          ASLA
9ADC: 9B C2       ADDA   $C2
9ADE: 9B C4       ADDA   $C4
9AE0: E6 C6       LDB    A,U
9AE2: 10 8E 13 A0 LDY    #$13A0
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
9AFA: A6 01       LDA    $1,X
9AFC: 84 02       ANDA   #$02
9AFE: 26 2C       BNE    $9B2C
9B00: CE 13 E0    LDU    #$13E0
9B03: CC FF FF    LDD    #$FFFF
9B06: BD 93 02    JSR    $9302
9B09: C4 20       ANDB   #$20
9B0B: 27 07       BEQ    $9B14
9B0D: 84 01       ANDA   #$01
9B0F: 26 03       BNE    $9B14
9B11: C6 51       LDB    #$51
9B13: 39          RTS
9B14: CE 13 E0    LDU    #$13E0
9B17: CC 01 00    LDD    #$0100
9B1A: BD 93 02    JSR    $9302
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
9B32: BD 93 02    JSR    $9302
9B35: C4 20       ANDB   #$20
9B37: 27 07       BEQ    $9B40
9B39: 84 01       ANDA   #$01
9B3B: 26 03       BNE    $9B40
9B3D: C6 4E       LDB    #$4E
9B3F: 39          RTS
9B40: CE 13 E0    LDU    #$13E0
9B43: CC 01 FF    LDD    #$01FF
9B46: BD 93 02    JSR    $9302
9B49: C4 20       ANDB   #$20
9B4B: 26 01       BNE    $9B4E
9B4D: 39          RTS
9B4E: 84 01       ANDA   #$01
9B50: 26 01       BNE    $9B53
9B52: 39          RTS
9B53: C6 52       LDB    #$52
9B55: 39          RTS
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
9B7D: BD 9A D5    JSR    $9AD5
9B80: CE D9 50    LDU    #$D950
9B83: 7E 8D E8    JMP    $8DE8
9B86: A6 07       LDA    $7,X
9B88: A1 01       CMPA   $1,X
9B8A: 27 2C       BEQ    $9BB8
9B8C: 10 8E 13 A0 LDY    #$13A0
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
9BA8: 7E 8D C8    JMP    $8DC8
9BAB: CC FF F0    LDD    #$FFF0
9BAE: ED 16       STD    -$A,X
9BB0: CC 00 10    LDD    #$0010
9BB3: ED 18       STD    -$8,X
9BB5: 7E 8D C8    JMP    $8DC8
9BB8: CE DA 1C    LDU    #$DA1C
9BBB: 7E 8D E8    JMP    $8DE8
9BBE: A6 07       LDA    $7,X
9BC0: A1 01       CMPA   $1,X
9BC2: 27 2C       BEQ    $9BF0
9BC4: 10 8E 13 A0 LDY    #$13A0
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
9BE3: 7E 8D C8    JMP    $8DC8
9BE6: CC FF F0    LDD    #$FFF0
9BE9: ED 18       STD    -$8,X
9BEB: ED 18       STD    -$8,X
9BED: 7E 8D C8    JMP    $8DC8
9BF0: CE DA 34    LDU    #$DA34
9BF3: 7E 8D E8    JMP    $8DE8
9BF6: BD 93 B3    JSR    $93B3
9BF9: EC 1A       LDD    -$6,X
9BFB: 93 8C       SUBD   $8C
9BFD: ED 1A       STD    -$6,X
9BFF: BD 94 25    JSR    $9425
9C02: EC 1C       LDD    -$4,X
9C04: 93 8E       SUBD   $8E
9C06: ED 1C       STD    -$4,X
9C08: 6A 0A       DEC    $A,X
9C0A: 27 01       BEQ    $9C0D
9C0C: 39          RTS
9C0D: A6 01       LDA    $1,X
9C0F: 84 02       ANDA   #$02
9C11: 26 08       BNE    $9C1B
9C13: CE 9C 23    LDU    #$9C23
9C16: A6 09       LDA    $9,X
9C18: 48          ASLA
9C19: 6E D6       JMP    [A,U]
9C1B: CE 9C 2F    LDU    #$9C2F
9C1E: A6 09       LDA    $9,X
9C20: 48          ASLA
9C21: 6E D6       JMP    [A,U]
9C23: 9C 4D       CMPX   $4D
9C25: 9C 4D       CMPX   $4D
9C27: 9C 3B       CMPX   $3B
9C29: 9C 4D       CMPX   $4D
9C2B: 9C 4D       CMPX   $4D
9C2D: 9C 6B       CMPX   $6B
9C2F: 9C 65       CMPX   $65
9C31: 9C 65       CMPX   $65
9C33: 9C 53       CMPX   $53
9C35: 9C 65       CMPX   $65
9C37: 9C 65       CMPX   $65
9C39: 9C 96       CMPX   $96
9C3B: EC 1A       LDD    -$6,X
9C3D: C3 00 C0    ADDD   #$00C0
9C40: ED 1A       STD    -$6,X
9C42: EC 1C       LDD    -$4,X
9C44: C3 00 80    ADDD   #$0080
9C47: ED 1C       STD    -$4,X
9C49: 8D 76       BSR    $9CC1
9C4B: 27 6E       BEQ    $9CBB
9C4D: CE E0 F0    LDU    #$E0F0
9C50: 7E 99 37    JMP    $9937
9C53: EC 1A       LDD    -$6,X
9C55: 83 00 C0    SUBD   #$00C0
9C58: ED 1A       STD    -$6,X
9C5A: EC 1C       LDD    -$4,X
9C5C: C3 00 80    ADDD   #$0080
9C5F: ED 1C       STD    -$4,X
9C61: 8D 6F       BSR    $9CD2
9C63: 27 56       BEQ    $9CBB
9C65: CE E1 04    LDU    #$E104
9C68: 7E 99 37    JMP    $9937
9C6B: EC 1A       LDD    -$6,X
9C6D: C3 00 C0    ADDD   #$00C0
9C70: ED 1A       STD    -$6,X
9C72: EC 1C       LDD    -$4,X
9C74: C3 00 80    ADDD   #$0080
9C77: ED 1C       STD    -$4,X
9C79: 10 8E 13 A0 LDY    #$13A0
9C7D: 96 E6       LDA    $E6
9C7F: C6 48       LDB    #$48
9C81: E7 A6       STB    A,Y
9C83: 4C          INCA
9C84: 84 1F       ANDA   #$1F
9C86: 97 E6       STA    $E6
9C88: 86 FF       LDA    #$FF
9C8A: A7 09       STA    $9,X
9C8C: 8D 33       BSR    $9CC1
9C8E: 27 2B       BEQ    $9CBB
9C90: CE E0 F0    LDU    #$E0F0
9C93: 7E 99 37    JMP    $9937
9C96: EC 1A       LDD    -$6,X
9C98: 83 00 C0    SUBD   #$00C0
9C9B: ED 1A       STD    -$6,X
9C9D: EC 1C       LDD    -$4,X
9C9F: C3 00 80    ADDD   #$0080
9CA2: ED 1C       STD    -$4,X
9CA4: 10 8E 13 A0 LDY    #$13A0
9CA8: 96 E6       LDA    $E6
9CAA: C6 48       LDB    #$48
9CAC: E7 A6       STB    A,Y
9CAE: 4C          INCA
9CAF: 84 1F       ANDA   #$1F
9CB1: 97 E6       STA    $E6
9CB3: 86 FF       LDA    #$FF
9CB5: A7 09       STA    $9,X
9CB7: 8D 19       BSR    $9CD2
9CB9: 26 AA       BNE    $9C65
9CBB: CE E0 14    LDU    #$E014
9CBE: 7E 99 37    JMP    $9937
9CC1: CE 13 E0    LDU    #$13E0
9CC4: CC 01 00    LDD    #$0100
9CC7: BD 93 02    JSR    $9302
9CCA: C4 20       ANDB   #$20
9CCC: 26 01       BNE    $9CCF
9CCE: 39          RTS
9CCF: C6 4D       LDB    #$4D
9CD1: 39          RTS
9CD2: CE 13 E0    LDU    #$13E0
9CD5: CC FF 00    LDD    #$FF00
9CD8: BD 93 02    JSR    $9302
9CDB: C4 20       ANDB   #$20
9CDD: 26 01       BNE    $9CE0
9CDF: 39          RTS
9CE0: C6 4E       LDB    #$4E
9CE2: 39          RTS
9CE3: BD 93 B3    JSR    $93B3
9CE6: EC 1A       LDD    -$6,X
9CE8: 93 8C       SUBD   $8C
9CEA: ED 1A       STD    -$6,X
9CEC: BD 94 25    JSR    $9425
9CEF: EC 1C       LDD    -$4,X
9CF1: 93 8E       SUBD   $8E
9CF3: ED 1C       STD    -$4,X
9CF5: 6A 0A       DEC    $A,X
9CF7: 27 01       BEQ    $9CFA
9CF9: 39          RTS
9CFA: A6 01       LDA    $1,X
9CFC: 84 02       ANDA   #$02
9CFE: 26 08       BNE    $9D08
9D00: CE 9D 10    LDU    #$9D10
9D03: A6 09       LDA    $9,X
9D05: 48          ASLA
9D06: 6E D6       JMP    [A,U]
9D08: CE 9D 1C    LDU    #$9D1C
9D0B: A6 09       LDA    $9,X
9D0D: 48          ASLA
9D0E: 6E D6       JMP    [A,U]
9D10: 9D 3A       JSR    $3A
9D12: 9D 28       JSR    $28
9D14: 9D 3A       JSR    $3A
9D16: 9D 3A       JSR    $3A
9D18: 9D 28       JSR    $28
9D1A: 9D 5E       JSR    $5E
9D1C: 9D 52       JSR    $52
9D1E: 9D 40       JSR    $40
9D20: 9D 52       JSR    $52
9D22: 9D 52       JSR    $52
9D24: 9D 40       JSR    $40
9D26: 9D 77       JSR    $77
9D28: EC 1A       LDD    -$6,X
9D2A: C3 00 C0    ADDD   #$00C0
9D2D: ED 1A       STD    -$6,X
9D2F: EC 1C       LDD    -$4,X
9D31: 83 00 80    SUBD   #$0080
9D34: ED 1C       STD    -$4,X
9D36: 8D 58       BSR    $9D90
9D38: 27 1E       BEQ    $9D58
9D3A: CE E1 18    LDU    #$E118
9D3D: 7E 99 37    JMP    $9937
9D40: EC 1A       LDD    -$6,X
9D42: 83 00 C0    SUBD   #$00C0
9D45: ED 1A       STD    -$6,X
9D47: EC 1C       LDD    -$4,X
9D49: 83 00 80    SUBD   #$0080
9D4C: ED 1C       STD    -$4,X
9D4E: 8D 51       BSR    $9DA1
9D50: 27 06       BEQ    $9D58
9D52: CE E1 2C    LDU    #$E12C
9D55: 7E 99 37    JMP    $9937
9D58: CE E0 14    LDU    #$E014
9D5B: 7E 99 37    JMP    $9937
9D5E: 10 8E 13 A0 LDY    #$13A0
9D62: 96 E6       LDA    $E6
9D64: C6 48       LDB    #$48
9D66: E7 A6       STB    A,Y
9D68: 4C          INCA
9D69: 84 1F       ANDA   #$1F
9D6B: 97 E6       STA    $E6
9D6D: 86 FF       LDA    #$FF
9D6F: A7 09       STA    $9,X
9D71: CE E1 18    LDU    #$E118
9D74: 7E 99 37    JMP    $9937
9D77: 10 8E 13 A0 LDY    #$13A0
9D7B: 96 E6       LDA    $E6
9D7D: C6 48       LDB    #$48
9D7F: E7 A6       STB    A,Y
9D81: 4C          INCA
9D82: 84 1F       ANDA   #$1F
9D84: 97 E6       STA    $E6
9D86: 86 FF       LDA    #$FF
9D88: A7 09       STA    $9,X
9D8A: CE E1 2C    LDU    #$E12C
9D8D: 7E 99 37    JMP    $9937
9D90: CE 13 E0    LDU    #$13E0
9D93: CC FF FF    LDD    #$FFFF
9D96: BD 93 02    JSR    $9302
9D99: C4 20       ANDB   #$20
9D9B: 26 01       BNE    $9D9E
9D9D: 39          RTS
9D9E: C6 51       LDB    #$51
9DA0: 39          RTS
9DA1: CE 13 E0    LDU    #$13E0
9DA4: CC 01 FF    LDD    #$01FF
9DA7: BD 93 02    JSR    $9302
9DAA: C4 20       ANDB   #$20
9DAC: 26 01       BNE    $9DAF
9DAE: 39          RTS
9DAF: C6 52       LDB    #$52
9DB1: 39          RTS
9DB2: 8D 15       BSR    $9DC9
9DB4: 27 10       BEQ    $9DC6
9DB6: A6 C4       LDA    ,U
9DB8: 81 43       CMPA   #$43
9DBA: 27 05       BEQ    $9DC1
9DBC: C6 58       LDB    #$58
9DBE: 7E 99 3B    JMP    $993B
9DC1: C6 A8       LDB    #$A8
9DC3: 7E 99 3B    JMP    $993B
9DC6: 7E 8D C8    JMP    $8DC8
9DC9: 96 53       LDA    $53
9DCB: 26 01       BNE    $9DCE
9DCD: 39          RTS
9DCE: 97 55       STA    $55
9DD0: CE 10 00    LDU    #$1000
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
9DFF: 10 8E 9E 2D LDY    #$9E2D
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
9E2F: 8D 98       BSR    $9DC9
9E31: 27 10       BEQ    $9E43
9E33: A6 C4       LDA    ,U
9E35: 81 43       CMPA   #$43
9E37: 27 05       BEQ    $9E3E
9E39: C6 5C       LDB    #$5C
9E3B: 7E 99 3B    JMP    $993B
9E3E: C6 AC       LDB    #$AC
9E40: 7E 99 3B    JMP    $993B
9E43: 7E 8D C8    JMP    $8DC8
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
9E5C: CE 9E 73    LDU    #$9E73
9E5F: A6 09       LDA    $9,X
9E61: A6 C6       LDA    A,U
9E63: A7 09       STA    $9,X
9E65: CE DA 64    LDU    #$DA64
9E68: 7E 8D EA    JMP    $8DEA
9E6B: CE A0 13    LDU    #$A013
9E6E: A6 09       LDA    $9,X
9E70: 48          ASLA
9E71: 6E D6       JMP    [A,U]
9E73: 05 05       LSR    $05
9E75: 04 03       LSR    $03
9E77: 02 00       XNC    $00
9E79: EE 10       LDU    -$10,X
9E7B: A6 41       LDA    $1,U
9E7D: 8A 01       ORA    #$01
9E7F: A7 41       STA    $1,U
9E81: 6A 0A       DEC    $A,X
9E83: 27 01       BEQ    $9E86
9E85: 39          RTS
9E86: CE DA 4C    LDU    #$DA4C
9E89: 7E 8D E8    JMP    $8DE8
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
9EA4: CE DA 4C    LDU    #$DA4C
9EA7: 7E 8D E8    JMP    $8DE8
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
9ECB: 6D 0A       TST    $A,X
9ECD: 27 03       BEQ    $9ED2
9ECF: 6A 0A       DEC    $A,X
9ED1: 39          RTS
9ED2: EE 10       LDU    -$10,X
9ED4: A6 41       LDA    $1,U
9ED6: 84 18       ANDA   #$18
9ED8: 26 05       BNE    $9EDF
9EDA: C6 5C       LDB    #$5C
9EDC: 7E 99 3B    JMP    $993B
9EDF: 6C 09       INC    $9,X
9EE1: 39          RTS
9EE2: EE 10       LDU    -$10,X
9EE4: A6 41       LDA    $1,U
9EE6: 85 20       BITA   #$20
9EE8: 26 1F       BNE    $9F09
9EEA: 10 8E 9F 40 LDY    #$9F40
9EEE: 84 18       ANDA   #$18
9EF0: 44          LSRA
9EF1: 44          LSRA
9EF2: 44          LSRA
9EF3: A6 A6       LDA    A,Y
9EF5: A7 0A       STA    $A,X
9EF7: 10 8E 13 60 LDY    #$1360
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
9F11: EC A6       LDD    A,Y
9F13: 97 CE       STA    $CE
9F15: E7 0A       STB    $A,X
9F17: CE 8C E9    LDU    #$8CE9
9F1A: 10 8E 5F 08 LDY    #$5F08
9F1E: C6 FC       LDB    #$FC
9F20: A6 C0       LDA    ,U+
9F22: A7 E2       STA    ,-S
9F24: A6 C0       LDA    ,U+
9F26: ED A1       STD    ,Y++
9F28: 6A E4       DEC    ,S
9F2A: 26 F8       BNE    $9F24
9F2C: A6 E0       LDA    ,S+
9F2E: 10 8E 13 60 LDY    #$1360
9F32: 96 E4       LDA    $E4
9F34: C6 04       LDB    #$04
9F36: E7 A6       STB    A,Y
9F38: 4C          INCA
9F39: 84 1F       ANDA   #$1F
9F3B: 97 E4       STA    $E4
9F3D: 6C 09       INC    $9,X
9F3F: 39          RTS
9F40: 00 14       NEG    $14
9F42: 1E 32       EXG    U,Y
9F44: 00 00       NEG    $00
9F46: 01 28       NEG    $28
9F48: 01 50       NEG    $50
9F4A: 01 64       NEG    $64
9F4C: EE 10       LDU    -$10,X
9F4E: A6 41       LDA    $1,U
9F50: 85 20       BITA   #$20
9F52: 26 0E       BNE    $9F62
9F54: CE 16 CA    LDU    #$16CA
9F57: CC 00 01    LDD    #$0001
9F5A: BD 88 B2    JSR    $88B2
9F5D: 6A 0A       DEC    $A,X
9F5F: 27 0F       BEQ    $9F70
9F61: 39          RTS
9F62: CE 16 CC    LDU    #$16CC
9F65: CC 00 01    LDD    #$0001
9F68: BD 88 B2    JSR    $88B2
9F6B: 6A 0A       DEC    $A,X
9F6D: 27 01       BEQ    $9F70
9F6F: 39          RTS
9F70: EE 10       LDU    -$10,X
9F72: A6 41       LDA    $1,U
9F74: 84 07       ANDA   #$07
9F76: 8A 20       ORA    #$20
9F78: A7 41       STA    $1,U
9F7A: C6 5C       LDB    #$5C
9F7C: 7E 99 3B    JMP    $993B
9F7F: 96 0A       LDA    $0A
9F81: 84 1C       ANDA   #$1C
9F83: 81 0C       CMPA   #$0C
9F85: 26 17       BNE    $9F9E
9F87: A6 01       LDA    $1,X
9F89: 80 04       SUBA   #$04
9F8B: A7 01       STA    $1,X
9F8D: A7 07       STA    $7,X
9F8F: CE 9E 73    LDU    #$9E73
9F92: A6 09       LDA    $9,X
9F94: A6 C6       LDA    A,U
9F96: A7 09       STA    $9,X
9F98: CE DA 4C    LDU    #$DA4C
9F9B: 7E 8D EA    JMP    $8DEA
9F9E: CE A0 23    LDU    #$A023
9FA1: A6 09       LDA    $9,X
9FA3: 48          ASLA
9FA4: 6E D6       JMP    [A,U]
9FA6: EE 10       LDU    -$10,X
9FA8: A6 41       LDA    $1,U
9FAA: 8A 01       ORA    #$01
9FAC: A7 41       STA    $1,U
9FAE: A6 42       LDA    $2,U
9FB0: 81 04       CMPA   #$04
9FB2: 27 01       BEQ    $9FB5
9FB4: 39          RTS
9FB5: CE DA 64    LDU    #$DA64
9FB8: 7E 8D E8    JMP    $8DE8
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
9FD9: CE DA 64    LDU    #$DA64
9FDC: 7E 8D E8    JMP    $8DE8
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
A00A: CE E0 14    LDU    #$E014
A00D: 7E 99 37    JMP    $9937
A010: 6C 14       INC    -$C,X
A012: 39          RTS
A013: 9E 79       LDX    $79
A015: 9E 8C       LDX    $8C
A017: 9E 8C       LDX    $8C
A019: 9E 8C       LDX    $8C
A01B: 9E AA       LDX    $AA
A01D: 9E CB       LDX    $CB
A01F: 9E E2       LDX    $E2
A021: 9F 4C       STX    $4C
A023: 9F A6       STX    $A6
A025: 9F BB       STX    $BB
A027: 9F BB       STX    $BB
A029: 9F BB       STX    $BB
A02B: 9F BB       STX    $BB
A02D: 9F DF       STX    $DF
A02F: 96 0A       LDA    $0A
A031: 84 1C       ANDA   #$1C
A033: 81 10       CMPA   #$10
A035: 26 17       BNE    $A04E
A037: A6 01       LDA    $1,X
A039: 8B 04       ADDA   #$04
A03B: A7 01       STA    $1,X
A03D: A7 07       STA    $7,X
A03F: CE A0 5B    LDU    #$A05B
A042: A6 09       LDA    $9,X
A044: A6 C6       LDA    A,U
A046: A7 09       STA    $9,X
A048: CE DA 7C    LDU    #$DA7C
A04B: 7E 8D EA    JMP    $8DEA
A04E: 6A 0A       DEC    $A,X
A050: 27 01       BEQ    $A053
A052: 39          RTS
A053: CE A1 19    LDU    #$A119
A056: A6 09       LDA    $9,X
A058: 48          ASLA
A059: 6E D6       JMP    [A,U]
A05B: 05 05       LSR    $05
A05D: 04 03       LSR    $03
A05F: 02 00       XNC    $00
A061: CE DA 4C    LDU    #$DA4C
A064: 7E 8D E8    JMP    $8DE8
A067: EE 10       LDU    -$10,X
A069: A6 41       LDA    $1,U
A06B: 84 04       ANDA   #$04
A06D: 26 07       BNE    $A076
A06F: EC 1C       LDD    -$4,X
A071: C3 00 20    ADDD   #$0020
A074: ED 1C       STD    -$4,X
A076: CE DA 4C    LDU    #$DA4C
A079: 7E 8D E8    JMP    $8DE8
A07C: EE 10       LDU    -$10,X
A07E: A6 41       LDA    $1,U
A080: 84 04       ANDA   #$04
A082: 26 07       BNE    $A08B
A084: EC 1C       LDD    -$4,X
A086: C3 00 20    ADDD   #$0020
A089: ED 1C       STD    -$4,X
A08B: 86 40       LDA    #$40
A08D: A7 05       STA    $5,X
A08F: CE DA 4C    LDU    #$DA4C
A092: 7E 8D E8    JMP    $8DE8
A095: 6F 0D       CLR    $D,X
A097: 0F 0B       CLR    $0B
A099: 0F 0D       CLR    $0D
A09B: 96 0A       LDA    $0A
A09D: 84 FC       ANDA   #$FC
A09F: 97 0A       STA    $0A
A0A1: CE E0 14    LDU    #$E014
A0A4: 7E 99 37    JMP    $9937
A0A7: 96 0A       LDA    $0A
A0A9: 84 1C       ANDA   #$1C
A0AB: 81 0C       CMPA   #$0C
A0AD: 26 17       BNE    $A0C6
A0AF: A6 01       LDA    $1,X
A0B1: 80 04       SUBA   #$04
A0B3: A7 01       STA    $1,X
A0B5: A7 07       STA    $7,X
A0B7: CE A0 5B    LDU    #$A05B
A0BA: A6 09       LDA    $9,X
A0BC: A6 C6       LDA    A,U
A0BE: A7 09       STA    $9,X
A0C0: CE DA 4C    LDU    #$DA4C
A0C3: 7E 8D EA    JMP    $8DEA
A0C6: 6A 0A       DEC    $A,X
A0C8: 27 01       BEQ    $A0CB
A0CA: 39          RTS
A0CB: CE A1 25    LDU    #$A125
A0CE: A6 09       LDA    $9,X
A0D0: 48          ASLA
A0D1: 6E D6       JMP    [A,U]
A0D3: CE DA 7C    LDU    #$DA7C
A0D6: 7E 8D E8    JMP    $8DE8
A0D9: EE 10       LDU    -$10,X
A0DB: A6 44       LDA    $4,U
A0DD: A7 05       STA    $5,X
A0DF: A6 41       LDA    $1,U
A0E1: 84 04       ANDA   #$04
A0E3: 26 07       BNE    $A0EC
A0E5: EC 1C       LDD    -$4,X
A0E7: 83 00 20    SUBD   #$0020
A0EA: ED 1C       STD    -$4,X
A0EC: CE DA 7C    LDU    #$DA7C
A0EF: 7E 8D E8    JMP    $8DE8
A0F2: EE 10       LDU    -$10,X
A0F4: A6 41       LDA    $1,U
A0F6: 84 04       ANDA   #$04
A0F8: 26 07       BNE    $A101
A0FA: EC 1C       LDD    -$4,X
A0FC: 83 00 20    SUBD   #$0020
A0FF: ED 1C       STD    -$4,X
A101: CE DA 7C    LDU    #$DA7C
A104: 7E 8D E8    JMP    $8DE8
A107: 6F 0D       CLR    $D,X
A109: 0F 0B       CLR    $0B
A10B: 0F 0D       CLR    $0D
A10D: 96 0A       LDA    $0A
A10F: 84 FC       ANDA   #$FC
A111: 97 0A       STA    $0A
A113: CE E0 14    LDU    #$E014
A116: 7E 99 37    JMP    $9937
A119: A0 61       SUBA   $1,S
A11B: A0 67       SUBA   $7,S
A11D: A0 67       SUBA   $7,S
A11F: A0 67       SUBA   $7,S
A121: A0 7C       SUBA   -$4,S
A123: A0 95       SUBA   [B,X]
A125: A0 D3       SUBA   [,--U]
A127: A0 D9 A0 D9 SUBA   [-$5F27,U]
A12B: A0 D9 A0 F2 SUBA   [-$5F0E,U]
A12F: A1 07       CMPA   $7,X
A131: 7E 8D C8    JMP    $8DC8
A134: 7E 8D C8    JMP    $8DC8
A137: 6A 0A       DEC    $A,X
A139: 27 01       BEQ    $A13C
A13B: 39          RTS
A13C: A6 84       LDA    ,X
A13E: 84 03       ANDA   #$03
A140: 26 06       BNE    $A148
A142: CE E0 28    LDU    #$E028
A145: 7E 99 37    JMP    $9937
A148: 6C 14       INC    -$C,X
A14A: 39          RTS
A14B: 6A 0A       DEC    $A,X
A14D: 27 01       BEQ    $A150
A14F: 39          RTS
A150: A6 84       LDA    ,X
A152: 84 03       ANDA   #$03
A154: 26 06       BNE    $A15C
A156: CE E0 3C    LDU    #$E03C
A159: 7E 99 37    JMP    $9937
A15C: 6C 14       INC    -$C,X
A15E: 39          RTS
A15F: 6A 0A       DEC    $A,X
A161: 27 01       BEQ    $A164
A163: 39          RTS
A164: A6 84       LDA    ,X
A166: 84 03       ANDA   #$03
A168: 26 06       BNE    $A170
A16A: CE E0 50    LDU    #$E050
A16D: 7E 99 37    JMP    $9937
A170: 6C 14       INC    -$C,X
A172: 39          RTS
A173: 96 CE       LDA    $CE
A175: 81 01       CMPA   #$01
A177: 27 10       BEQ    $A189
A179: A6 84       LDA    ,X
A17B: 84 03       ANDA   #$03
A17D: 27 04       BEQ    $A183
A17F: 86 01       LDA    #$01
A181: 97 0B       STA    $0B
A183: BD A2 59    JSR    $A259
A186: 7E 8D C8    JMP    $8DC8
A189: A6 84       LDA    ,X
A18B: 84 03       ANDA   #$03
A18D: 27 04       BEQ    $A193
A18F: 86 08       LDA    #$08
A191: 97 0B       STA    $0B
A193: BD A5 F8    JSR    $A5F8
A196: E6 01       LDB    $1,X
A198: C4 03       ANDB   #$03
A19A: CB A0       ADDB   #$A0
A19C: E7 01       STB    $1,X
A19E: E7 07       STB    $7,X
A1A0: 7E 8D C8    JMP    $8DC8
A1A3: CE A1 AD    LDU    #$A1AD
A1A6: 96 0A       LDA    $0A
A1A8: 84 1C       ANDA   #$1C
A1AA: 44          LSRA
A1AB: 6E D6       JMP    [A,U]
A1AD: A1 B7       CMPA   [E,Y]
A1AF: A1 BF A1 CD CMPA   [$A1CD]
A1B3: A1 B7       CMPA   [E,Y]
A1B5: A1 DB       CMPA   [D,U]
A1B7: CE A3 5E    LDU    #$A35E
A1BA: A6 09       LDA    $9,X
A1BC: 48          ASLA
A1BD: 6E D6       JMP    [A,U]
A1BF: 86 19       LDA    #$19
A1C1: A7 01       STA    $1,X
A1C3: A7 07       STA    $7,X
A1C5: CE A3 5E    LDU    #$A35E
A1C8: A6 09       LDA    $9,X
A1CA: 48          ASLA
A1CB: 6E D6       JMP    [A,U]
A1CD: 86 1A       LDA    #$1A
A1CF: A7 01       STA    $1,X
A1D1: A7 07       STA    $7,X
A1D3: CE A3 5E    LDU    #$A35E
A1D6: A6 09       LDA    $9,X
A1D8: 48          ASLA
A1D9: 6E D6       JMP    [A,U]
A1DB: A6 01       LDA    $1,X
A1DD: 84 03       ANDA   #$03
A1DF: 8B 1C       ADDA   #$1C
A1E1: A7 01       STA    $1,X
A1E3: A7 07       STA    $7,X
A1E5: CE A5 05    LDU    #$A505
A1E8: A6 09       LDA    $9,X
A1EA: 48          ASLA
A1EB: 6E D6       JMP    [A,U]
A1ED: 6A 0A       DEC    $A,X
A1EF: 27 01       BEQ    $A1F2
A1F1: 39          RTS
A1F2: CE D9 FC    LDU    #$D9FC
A1F5: 7E 8D E8    JMP    $8DE8
A1F8: 96 0B       LDA    $0B
A1FA: 81 01       CMPA   #$01
A1FC: 27 0F       BEQ    $A20D
A1FE: 0A 0B       DEC    $0B
A200: BD A2 59    JSR    $A259
A203: 86 FF       LDA    #$FF
A205: A7 09       STA    $9,X
A207: CE D9 FC    LDU    #$D9FC
A20A: 7E 8D E8    JMP    $8DE8
A20D: 6A 0A       DEC    $A,X
A20F: 27 01       BEQ    $A212
A211: 39          RTS
A212: 0A 0B       DEC    $0B
A214: CE D9 FC    LDU    #$D9FC
A217: 7E 8D E8    JMP    $8DE8
A21A: 0D 0B       TST    $0B
A21C: 27 0C       BEQ    $A22A
A21E: 8D 39       BSR    $A259
A220: 86 FF       LDA    #$FF
A222: A7 09       STA    $9,X
A224: CE D9 FC    LDU    #$D9FC
A227: 7E 8D E8    JMP    $8DE8
A22A: 6A 0A       DEC    $A,X
A22C: 27 01       BEQ    $A22F
A22E: 39          RTS
A22F: CE D9 FC    LDU    #$D9FC
A232: 7E 8D E8    JMP    $8DE8
A235: 0D 0B       TST    $0B
A237: 27 0C       BEQ    $A245
A239: 8D 1E       BSR    $A259
A23B: 86 FF       LDA    #$FF
A23D: A7 09       STA    $9,X
A23F: CE D9 FC    LDU    #$D9FC
A242: 7E 8D E8    JMP    $8DE8
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
A259: DC CA       LDD    $CA
A25B: 27 17       BEQ    $A274
A25D: CE 09 00    LDU    #$0900
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
A2A1: 10 8E A3 1E LDY    #$A31E
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
A315: CE 16 CA    LDU    #$16CA
A318: CC 99 99    LDD    #$9999
A31B: 7E 88 B2    JMP    $88B2
A31E: 01 7B       NEG    $7B
A320: 0C 00       INC    $00
A322: 40          NEGA
A323: 00 80       NEG    $80
A325: 02 40       XNC    $40
A327: 01 7B       NEG    $7B
A329: 3C 01       CWAI   #$01
A32B: 80 02       SUBA   #$02
A32D: 40          NEGA
A32E: 02 7B       XNC    $7B
A330: 10 FF C0 FE STS    $C0FE
A334: 80 02       SUBA   #$02
A336: 40          NEGA
A337: 02 7B       XNC    $7B
A339: 40          NEGA
A33A: FD 80 02    STD    $8002
A33D: 40          NEGA
A33E: 05 7B       LSR    $7B
A340: 0C 00       INC    $00
A342: 20 00       BRA    $A344
A344: 80 02       SUBA   #$02
A346: 40          NEGA
A347: 01 7B       NEG    $7B
A349: 3C 01       CWAI   #$01
A34B: 80 02       SUBA   #$02
A34D: 40          NEGA
A34E: 06 7B       ROR    $7B
A350: 10 FF E0 FE STS    $E0FE
A354: 80 02       SUBA   #$02
A356: 40          NEGA
A357: 02 7B       XNC    $7B
A359: 40          NEGA
A35A: FD 80 02    STD    $8002
A35D: 40          NEGA
A35E: A1 ED A1 F8 CMPA   $455A,PCR
A362: A2 1A       SBCA   -$6,X
A364: A2 35       SBCA   -$B,Y
A366: 96 CE       LDA    $CE
A368: 81 01       CMPA   #$01
A36A: 27 10       BEQ    $A37C
A36C: A6 84       LDA    ,X
A36E: 84 03       ANDA   #$03
A370: 27 04       BEQ    $A376
A372: 86 01       LDA    #$01
A374: 97 0B       STA    $0B
A376: BD A4 4C    JSR    $A44C
A379: 7E 8D C8    JMP    $8DC8
A37C: A6 84       LDA    ,X
A37E: 84 03       ANDA   #$03
A380: 27 04       BEQ    $A386
A382: 86 08       LDA    #$08
A384: 97 0B       STA    $0B
A386: BD A7 A1    JSR    $A7A1
A389: E6 01       LDB    $1,X
A38B: C4 03       ANDB   #$03
A38D: CB A4       ADDB   #$A4
A38F: E7 01       STB    $1,X
A391: E7 07       STB    $7,X
A393: 7E 8D C8    JMP    $8DC8
A396: CE A3 A0    LDU    #$A3A0
A399: 96 0A       LDA    $0A
A39B: 84 1C       ANDA   #$1C
A39D: 44          LSRA
A39E: 6E D6       JMP    [A,U]
A3A0: A3 AA       SUBD   F,Y
A3A2: A3 B2       SUBD   Illegal Postbyte
A3A4: A3 C0       SUBD   ,U+
A3A6: A3 CE       SUBD   W,U
A3A8: A3 AA       SUBD   F,Y
A3AA: CE A5 05    LDU    #$A505
A3AD: A6 09       LDA    $9,X
A3AF: 48          ASLA
A3B0: 6E D6       JMP    [A,U]
A3B2: 86 1D       LDA    #$1D
A3B4: A7 01       STA    $1,X
A3B6: A7 07       STA    $7,X
A3B8: CE A5 05    LDU    #$A505
A3BB: A6 09       LDA    $9,X
A3BD: 48          ASLA
A3BE: 6E D6       JMP    [A,U]
A3C0: 86 1E       LDA    #$1E
A3C2: A7 01       STA    $1,X
A3C4: A7 07       STA    $7,X
A3C6: CE A5 05    LDU    #$A505
A3C9: A6 09       LDA    $9,X
A3CB: 48          ASLA
A3CC: 6E D6       JMP    [A,U]
A3CE: A6 01       LDA    $1,X
A3D0: 84 03       ANDA   #$03
A3D2: 8B 18       ADDA   #$18
A3D4: A7 01       STA    $1,X
A3D6: A7 07       STA    $7,X
A3D8: CE A3 5E    LDU    #$A35E
A3DB: A6 09       LDA    $9,X
A3DD: 48          ASLA
A3DE: 6E D6       JMP    [A,U]
A3E0: 6A 0A       DEC    $A,X
A3E2: 27 01       BEQ    $A3E5
A3E4: 39          RTS
A3E5: CE DA 0C    LDU    #$DA0C
A3E8: 7E 8D E8    JMP    $8DE8
A3EB: 96 0B       LDA    $0B
A3ED: 81 01       CMPA   #$01
A3EF: 27 0F       BEQ    $A400
A3F1: 0A 0B       DEC    $0B
A3F3: BD A4 4C    JSR    $A44C
A3F6: 86 FF       LDA    #$FF
A3F8: A7 09       STA    $9,X
A3FA: CE DA 0C    LDU    #$DA0C
A3FD: 7E 8D E8    JMP    $8DE8
A400: 6A 0A       DEC    $A,X
A402: 27 01       BEQ    $A405
A404: 39          RTS
A405: 0A 0B       DEC    $0B
A407: CE DA 0C    LDU    #$DA0C
A40A: 7E 8D E8    JMP    $8DE8
A40D: 0D 0B       TST    $0B
A40F: 27 0C       BEQ    $A41D
A411: 8D 39       BSR    $A44C
A413: 86 FF       LDA    #$FF
A415: A7 09       STA    $9,X
A417: CE DA 0C    LDU    #$DA0C
A41A: 7E 8D E8    JMP    $8DE8
A41D: 6A 0A       DEC    $A,X
A41F: 27 01       BEQ    $A422
A421: 39          RTS
A422: CE DA 0C    LDU    #$DA0C
A425: 7E 8D E8    JMP    $8DE8
A428: 0D 0B       TST    $0B
A42A: 27 0C       BEQ    $A438
A42C: 8D 1E       BSR    $A44C
A42E: 86 FF       LDA    #$FF
A430: A7 09       STA    $9,X
A432: CE DA 0C    LDU    #$DA0C
A435: 7E 8D E8    JMP    $8DE8
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
A44C: DC CA       LDD    $CA
A44E: 27 17       BEQ    $A467
A450: CE 09 00    LDU    #$0900
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
A494: 10 8E A4 C5 LDY    #$A4C5
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
A4C5: 01 7B       NEG    $7B
A4C7: 0C 00       INC    $00
A4C9: 40          NEGA
A4CA: FF 80 00    STU    $8000
A4CD: F0 01 7B    SUBB   $017B
A4D0: 3C 00       CWAI   #$00
A4D2: 80 00       SUBA   #$00
A4D4: F0 02 7B    SUBB   $027B
A4D7: 10 FF C0 FF STS    $C0FF
A4DB: 80 00       SUBA   #$00
A4DD: F0 02 7B    SUBB   $027B
A4E0: 40          NEGA
A4E1: FE 80 00    LDU    $8000
A4E4: F0 05 7B    SUBB   $057B
A4E7: 0C 00       INC    $00
A4E9: 20 FF       BRA    $A4EA
A4EB: 80 00       SUBA   #$00
A4ED: F0 01 7B    SUBB   $017B
A4F0: 3C 00       CWAI   #$00
A4F2: 80 00       SUBA   #$00
A4F4: F0 06 7B    SUBB   $067B
A4F7: 10 FF E0 FF STS    $E0FF
A4FB: 80 00       SUBA   #$00
A4FD: F0 02 7B    SUBB   $027B
A500: 40          NEGA
A501: FE 80 00    LDU    $8000
A504: F0 A3 E0    SUBB   $A3E0
A507: A3 EB       SUBD   D,S
A509: A4 0D       ANDA   $D,X
A50B: A4 28       ANDA   $8,Y
A50D: DC CC       LDD    $CC
A50F: 27 4A       BEQ    $A55B
A511: CE A5 1B    LDU    #$A51B
A514: 96 0A       LDA    $0A
A516: 84 1C       ANDA   #$1C
A518: 44          LSRA
A519: 6E D6       JMP    [A,U]
A51B: A5 25       BITA   $5,Y
A51D: A5 2D       BITA   $D,Y
A51F: A5 3B       BITA   -$5,Y
A521: A5 25       BITA   $5,Y
A523: A5 49       BITA   $9,U
A525: CE A6 AE    LDU    #$A6AE
A528: A6 09       LDA    $9,X
A52A: 48          ASLA
A52B: 6E D6       JMP    [A,U]
A52D: 86 A1       LDA    #$A1
A52F: A7 01       STA    $1,X
A531: A7 07       STA    $7,X
A533: CE A6 AE    LDU    #$A6AE
A536: A6 09       LDA    $9,X
A538: 48          ASLA
A539: 6E D6       JMP    [A,U]
A53B: 86 A2       LDA    #$A2
A53D: A7 01       STA    $1,X
A53F: A7 07       STA    $7,X
A541: CE A6 AE    LDU    #$A6AE
A544: A6 09       LDA    $9,X
A546: 48          ASLA
A547: 6E D6       JMP    [A,U]
A549: A6 01       LDA    $1,X
A54B: 84 03       ANDA   #$03
A54D: 8B A4       ADDA   #$A4
A54F: A7 01       STA    $1,X
A551: A7 07       STA    $7,X
A553: CE A8 0B    LDU    #$A80B
A556: A6 09       LDA    $9,X
A558: 48          ASLA
A559: 6E D6       JMP    [A,U]
A55B: 10 8E 5F 08 LDY    #$5F08
A55F: 86 FF       LDA    #$FF
A561: F6 8C E9    LDB    $8CE9
A564: A7 A1       STA    ,Y++
A566: 5A          DECB
A567: 26 FB       BNE    $A564
A569: 0F CE       CLR    $CE
A56B: A6 01       LDA    $1,X
A56D: 84 03       ANDA   #$03
A56F: 8B 18       ADDA   #$18
A571: A7 01       STA    $1,X
A573: A7 07       STA    $7,X
A575: 7E A1 A3    JMP    $A1A3
A578: 6A 0A       DEC    $A,X
A57A: 27 01       BEQ    $A57D
A57C: 39          RTS
A57D: CE DA E0    LDU    #$DAE0
A580: 7E 8D E8    JMP    $8DE8
A583: 96 0B       LDA    $0B
A585: 81 01       CMPA   #$01
A587: 27 0F       BEQ    $A598
A589: 0A 0B       DEC    $0B
A58B: BD A5 F8    JSR    $A5F8
A58E: 86 FF       LDA    #$FF
A590: A7 09       STA    $9,X
A592: CE DA E0    LDU    #$DAE0
A595: 7E 8D E8    JMP    $8DE8
A598: 6A 0A       DEC    $A,X
A59A: 27 01       BEQ    $A59D
A59C: 39          RTS
A59D: 0A 0B       DEC    $0B
A59F: CE DA E0    LDU    #$DAE0
A5A2: 7E 8D E8    JMP    $8DE8
A5A5: 0D 0B       TST    $0B
A5A7: 27 0C       BEQ    $A5B5
A5A9: 8D 4D       BSR    $A5F8
A5AB: 86 FF       LDA    #$FF
A5AD: A7 09       STA    $9,X
A5AF: CE DA E0    LDU    #$DAE0
A5B2: 7E 8D E8    JMP    $8DE8
A5B5: 6A 0A       DEC    $A,X
A5B7: 27 01       BEQ    $A5BA
A5B9: 39          RTS
A5BA: CE DA E0    LDU    #$DAE0
A5BD: 7E 8D E8    JMP    $8DE8
A5C0: 0D 0B       TST    $0B
A5C2: 27 0C       BEQ    $A5D0
A5C4: 8D 32       BSR    $A5F8
A5C6: 86 FF       LDA    #$FF
A5C8: A7 09       STA    $9,X
A5CA: CE DA E0    LDU    #$DAE0
A5CD: 7E 8D E8    JMP    $8DE8
A5D0: 6A 0A       DEC    $A,X
A5D2: 27 01       BEQ    $A5D5
A5D4: 39          RTS
A5D5: DC CC       LDD    $CC
A5D7: 26 10       BNE    $A5E9
A5D9: 0F CE       CLR    $CE
A5DB: 10 8E 5F 08 LDY    #$5F08
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
A5F8: CE 09 00    LDU    #$0900
A5FB: C6 FF       LDB    #$FF
A5FD: E1 C4       CMPB   ,U
A5FF: 26 05       BNE    $A606
A601: E1 C8 10    CMPB   $10,U
A604: 27 19       BEQ    $A61F
A606: 33 C8 10    LEAU   $10,U
A609: 11 83 0C 00 CMPU   #$0C00
A60D: 25 EE       BCS    $A5FD
A60F: 10 8E 13 A0 LDY    #$13A0
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
A634: 10 8E A6 8E LDY    #$A68E
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
A685: CE 16 CC    LDU    #$16CC
A688: CC 99 99    LDD    #$9999
A68B: 7E 88 B2    JMP    $88B2
A68E: 09 7B       ROL    $7B
A690: 0C 00       INC    $00
A692: 40          NEGA
A693: 00 80       NEG    $80
A695: 02 40       XNC    $40
A697: 01 7B       NEG    $7B
A699: 3C 01       CWAI   #$01
A69B: 80 02       SUBA   #$02
A69D: 40          NEGA
A69E: 0A 7B       DEC    $7B
A6A0: 10 FF C0 FE STS    $C0FE
A6A4: 80 02       SUBA   #$02
A6A6: 40          NEGA
A6A7: 02 7B       XNC    $7B
A6A9: 40          NEGA
A6AA: FD 80 02    STD    $8002
A6AD: 40          NEGA
A6AE: A5 78       BITA   -$8,S
A6B0: A5 83       BITA   ,--X
A6B2: A5 A5       BITA   B,Y
A6B4: A5 C0       BITA   ,U+
A6B6: DC CC       LDD    $CC
A6B8: 27 4A       BEQ    $A704
A6BA: CE A6 C4    LDU    #$A6C4
A6BD: 96 0A       LDA    $0A
A6BF: 84 1C       ANDA   #$1C
A6C1: 44          LSRA
A6C2: 6E D6       JMP    [A,U]
A6C4: A6 CE       LDA    W,U
A6C6: A6 D6       LDA    [A,U]
A6C8: A6 E4       LDA    ,S
A6CA: A6 F2       LDA    Illegal Postbyte
A6CC: A6 CE       LDA    W,U
A6CE: CE A8 0B    LDU    #$A80B
A6D1: A6 09       LDA    $9,X
A6D3: 48          ASLA
A6D4: 6E D6       JMP    [A,U]
A6D6: 86 A5       LDA    #$A5
A6D8: A7 01       STA    $1,X
A6DA: A7 07       STA    $7,X
A6DC: CE A8 0B    LDU    #$A80B
A6DF: A6 09       LDA    $9,X
A6E1: 48          ASLA
A6E2: 6E D6       JMP    [A,U]
A6E4: 86 A6       LDA    #$A6
A6E6: A7 01       STA    $1,X
A6E8: A7 07       STA    $7,X
A6EA: CE A8 0B    LDU    #$A80B
A6ED: A6 09       LDA    $9,X
A6EF: 48          ASLA
A6F0: 6E D6       JMP    [A,U]
A6F2: A6 01       LDA    $1,X
A6F4: 84 03       ANDA   #$03
A6F6: 8B A0       ADDA   #$A0
A6F8: A7 01       STA    $1,X
A6FA: A7 07       STA    $7,X
A6FC: CE A6 AE    LDU    #$A6AE
A6FF: A6 09       LDA    $9,X
A701: 48          ASLA
A702: 6E D6       JMP    [A,U]
A704: 10 8E 5F 08 LDY    #$5F08
A708: 86 FF       LDA    #$FF
A70A: F6 8C E9    LDB    $8CE9
A70D: A7 A1       STA    ,Y++
A70F: 5A          DECB
A710: 26 FB       BNE    $A70D
A712: 0F CE       CLR    $CE
A714: A6 01       LDA    $1,X
A716: 84 03       ANDA   #$03
A718: 8B 1C       ADDA   #$1C
A71A: A7 01       STA    $1,X
A71C: A7 07       STA    $7,X
A71E: 7E A3 96    JMP    $A396
A721: 6A 0A       DEC    $A,X
A723: 27 01       BEQ    $A726
A725: 39          RTS
A726: CE DA F0    LDU    #$DAF0
A729: 7E 8D E8    JMP    $8DE8
A72C: 96 0B       LDA    $0B
A72E: 81 01       CMPA   #$01
A730: 27 0F       BEQ    $A741
A732: 0A 0B       DEC    $0B
A734: BD A7 A1    JSR    $A7A1
A737: 86 FF       LDA    #$FF
A739: A7 09       STA    $9,X
A73B: CE DA F0    LDU    #$DAF0
A73E: 7E 8D E8    JMP    $8DE8
A741: 6A 0A       DEC    $A,X
A743: 27 01       BEQ    $A746
A745: 39          RTS
A746: 0A 0B       DEC    $0B
A748: CE DA F0    LDU    #$DAF0
A74B: 7E 8D E8    JMP    $8DE8
A74E: 0D 0B       TST    $0B
A750: 27 0C       BEQ    $A75E
A752: 8D 4D       BSR    $A7A1
A754: 86 FF       LDA    #$FF
A756: A7 09       STA    $9,X
A758: CE DA F0    LDU    #$DAF0
A75B: 7E 8D E8    JMP    $8DE8
A75E: 6A 0A       DEC    $A,X
A760: 27 01       BEQ    $A763
A762: 39          RTS
A763: CE DA F0    LDU    #$DAF0
A766: 7E 8D E8    JMP    $8DE8
A769: 0D 0B       TST    $0B
A76B: 27 0C       BEQ    $A779
A76D: 8D 32       BSR    $A7A1
A76F: 86 FF       LDA    #$FF
A771: A7 09       STA    $9,X
A773: CE DA F0    LDU    #$DAF0
A776: 7E 8D E8    JMP    $8DE8
A779: 6A 0A       DEC    $A,X
A77B: 27 01       BEQ    $A77E
A77D: 39          RTS
A77E: DC CC       LDD    $CC
A780: 26 10       BNE    $A792
A782: 0F CE       CLR    $CE
A784: 10 8E 5F 08 LDY    #$5F08
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
A7A1: CE 09 00    LDU    #$0900
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
A7DD: 10 8E A7 EB LDY    #$A7EB
A7E1: 7E A6 42    JMP    $A642
A7E4: 10 8E A7 FB LDY    #$A7FB
A7E8: 7E A6 42    JMP    $A642
A7EB: 09 7B       ROL    $7B
A7ED: 0C 00       INC    $00
A7EF: 40          NEGA
A7F0: FF 80 00    STU    $8000
A7F3: F0 01 7B    SUBB   $017B
A7F6: 3C 00       CWAI   #$00
A7F8: 80 00       SUBA   #$00
A7FA: F0 0A 7B    SUBB   $0A7B
A7FD: 10 FF C0 FF STS    $C0FF
A801: 80 00       SUBA   #$00
A803: F0 02 7B    SUBB   $027B
A806: 40          NEGA
A807: FE 80 00    LDU    $8000
A80A: F0 A7 21    SUBB   $A721
A80D: A7 2C       STA    $C,Y
A80F: A7 4E       STA    $E,U
A811: A7 69       STA    $9,S
A813: CC 00 70    LDD    #$0070
A816: ED 18       STD    -$8,X
A818: 7E 8D C8    JMP    $8DC8
A81B: CE A8 35    LDU    #$A835
A81E: 96 0A       LDA    $0A
A820: 84 0C       ANDA   #$0C
A822: 44          LSRA
A823: EC C6       LDD    A,U
A825: ED 16       STD    -$A,X
A827: CE A8 2F    LDU    #$A82F
A82A: A6 09       LDA    $9,X
A82C: 48          ASLA
A82D: 6E D6       JMP    [A,U]
A82F: A8 77       EORA   -$9,S
A831: A8 8E       EORA   W,X
A833: A8 A3       EORA   ,--Y
A835: 00 00       NEG    $00
A837: 00 08       NEG    $08
A839: FF F8 00    STU    $F800
A83C: 00 A6       NEG    $A6
A83E: 01 84       NEG    $84
A840: 02 26       XNC    $26
A842: 17 CE A8    LBSR   $76ED
A845: 35 96       PULS   D,X,PC
A847: 0A 84       DEC    $84
A849: 0C 44       INC    $44
A84B: EC C6       LDD    A,U
A84D: C3 00 20    ADDD   #$0020
A850: ED 16       STD    -$A,X
A852: CE A8 71    LDU    #$A871
A855: A6 09       LDA    $9,X
A857: 48          ASLA
A858: 6E D6       JMP    [A,U]
A85A: CE A8 35    LDU    #$A835
A85D: 96 0A       LDA    $0A
A85F: 84 0C       ANDA   #$0C
A861: 44          LSRA
A862: EC C6       LDD    A,U
A864: C3 FF E0    ADDD   #$FFE0
A867: ED 16       STD    -$A,X
A869: CE A8 71    LDU    #$A871
A86C: A6 09       LDA    $9,X
A86E: 48          ASLA
A86F: 6E D6       JMP    [A,U]
A871: A8 77       EORA   -$9,S
A873: A8 8E       EORA   W,X
A875: A8 A3       EORA   ,--Y
A877: BD 8E 05    JSR    $8E05
A87A: BD 90 76    JSR    $9076
A87D: 26 07       BNE    $A886
A87F: A6 19       LDA    -$7,X
A881: 81 40       CMPA   #$40
A883: 2D 03       BLT    $A888
A885: 39          RTS
A886: 6C 09       INC    $9,X
A888: CE D9 80    LDU    #$D980
A88B: 7E 8D E8    JMP    $8DE8
A88E: BD 8E 05    JSR    $8E05
A891: BD 90 76    JSR    $9076
A894: 26 07       BNE    $A89D
A896: A6 19       LDA    -$7,X
A898: 81 C0       CMPA   #$C0
A89A: 2F 01       BLE    $A89D
A89C: 39          RTS
A89D: CE D9 80    LDU    #$D980
A8A0: 7E 8D E8    JMP    $8DE8
A8A3: BD 8E 05    JSR    $8E05
A8A6: BD 90 76    JSR    $9076
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
A8BC: CE E0 14    LDU    #$E014
A8BF: 7E 99 37    JMP    $9937
A8C2: 6C 14       INC    -$C,X
A8C4: 39          RTS
A8C5: A6 01       LDA    $1,X
A8C7: A1 07       CMPA   $7,X
A8C9: 27 1B       BEQ    $A8E6
A8CB: 84 FC       ANDA   #$FC
A8CD: 81 28       CMPA   #$28
A8CF: 27 08       BEQ    $A8D9
A8D1: CC 00 A0    LDD    #$00A0
A8D4: ED 18       STD    -$8,X
A8D6: 7E 8D C8    JMP    $8DC8
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
A8EC: CE D9 A0    LDU    #$D9A0
A8EF: 7E 8D E8    JMP    $8DE8
A8F2: A6 01       LDA    $1,X
A8F4: A1 07       CMPA   $7,X
A8F6: 27 16       BEQ    $A90E
A8F8: 84 FC       ANDA   #$FC
A8FA: 81 34       CMPA   #$34
A8FC: 27 03       BEQ    $A901
A8FE: 7E 8D C8    JMP    $8DC8
A901: A6 07       LDA    $7,X
A903: A7 01       STA    $1,X
A905: EC 16       LDD    -$A,X
A907: 53          COMB
A908: 43          COMA
A909: C3 00 01    ADDD   #$0001
A90C: ED 16       STD    -$A,X
A90E: CE D9 F0    LDU    #$D9F0
A911: 7E 8D E8    JMP    $8DE8
A914: CE A9 FE    LDU    #$A9FE
A917: A6 09       LDA    $9,X
A919: 48          ASLA
A91A: 6E D6       JMP    [A,U]
A91C: 6A 0A       DEC    $A,X
A91E: 27 01       BEQ    $A921
A920: 39          RTS
A921: CE D9 A0    LDU    #$D9A0
A924: 7E 8D E8    JMP    $8DE8
A927: BD 90 76    JSR    $9076
A92A: 26 0F       BNE    $A93B
A92C: EC 18       LDD    -$8,X
A92E: 27 1D       BEQ    $A94D
A930: 6A 0A       DEC    $A,X
A932: 27 01       BEQ    $A935
A934: 39          RTS
A935: CE D9 A0    LDU    #$D9A0
A938: 7E 8D E8    JMP    $8DE8
A93B: 6C 09       INC    $9,X
A93D: CE D9 A0    LDU    #$D9A0
A940: 7E 8D E8    JMP    $8DE8
A943: BD 90 76    JSR    $9076
A946: 26 0A       BNE    $A952
A948: EC 18       LDD    -$8,X
A94A: 27 01       BEQ    $A94D
A94C: 39          RTS
A94D: C6 34       LDB    #$34
A94F: 7E 99 3B    JMP    $993B
A952: CE D9 A0    LDU    #$D9A0
A955: 7E 8D E8    JMP    $8DE8
A958: 6A 0A       DEC    $A,X
A95A: 27 01       BEQ    $A95D
A95C: 39          RTS
A95D: CE D9 A0    LDU    #$D9A0
A960: 7E 8D E8    JMP    $8DE8
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
A981: CE D9 A0    LDU    #$D9A0
A984: 7E 8D E8    JMP    $8DE8
A987: 86 40       LDA    #$40
A989: A7 05       STA    $5,X
A98B: CE D9 A0    LDU    #$D9A0
A98E: 7E 8D E8    JMP    $8DE8
A991: 6A 0A       DEC    $A,X
A993: 27 01       BEQ    $A996
A995: 39          RTS
A996: CE E0 8C    LDU    #$E08C
A999: 7E 99 37    JMP    $9937
A99C: 6A 0A       DEC    $A,X
A99E: 27 01       BEQ    $A9A1
A9A0: 39          RTS
A9A1: A6 84       LDA    ,X
A9A3: 84 03       ANDA   #$03
A9A5: 26 06       BNE    $A9AD
A9A7: CE E0 14    LDU    #$E014
A9AA: 7E 99 37    JMP    $9937
A9AD: 6C 14       INC    -$C,X
A9AF: 39          RTS
A9B0: CE AA 12    LDU    #$AA12
A9B3: A6 09       LDA    $9,X
A9B5: 48          ASLA
A9B6: 6E D6       JMP    [A,U]
A9B8: BD 90 76    JSR    $9076
A9BB: 26 01       BNE    $A9BE
A9BD: 39          RTS
A9BE: 0F 0D       CLR    $0D
A9C0: 0F 0B       CLR    $0B
A9C2: 96 0A       LDA    $0A
A9C4: 84 FC       ANDA   #$FC
A9C6: 97 0A       STA    $0A
A9C8: CC 00 00    LDD    #$0000
A9CB: ED 18       STD    -$8,X
A9CD: CE D9 F0    LDU    #$D9F0
A9D0: 7E 8D E8    JMP    $8DE8
A9D3: 6A 0A       DEC    $A,X
A9D5: 27 01       BEQ    $A9D8
A9D7: 39          RTS
A9D8: A6 84       LDA    ,X
A9DA: 84 03       ANDA   #$03
A9DC: 26 06       BNE    $A9E4
A9DE: CE E0 A0    LDU    #$E0A0
A9E1: 7E 99 37    JMP    $9937
A9E4: CE D9 F0    LDU    #$D9F0
A9E7: 7E 8D E8    JMP    $8DE8
A9EA: 6A 0A       DEC    $A,X
A9EC: 27 01       BEQ    $A9EF
A9EE: 39          RTS
A9EF: A6 84       LDA    ,X
A9F1: 84 03       ANDA   #$03
A9F3: 26 06       BNE    $A9FB
A9F5: CE E0 14    LDU    #$E014
A9F8: 7E 99 37    JMP    $9937
A9FB: 6C 14       INC    -$C,X
A9FD: 39          RTS
A9FE: A9 1C       ADCA   -$4,X
AA00: A9 27       ADCA   $7,Y
AA02: A9 43       ADCA   $3,U
AA04: A9 58       ADCA   -$8,U
AA06: A9 58       ADCA   -$8,U
AA08: A9 63       ADCA   $3,S
AA0A: A9 58       ADCA   -$8,U
AA0C: A9 58       ADCA   -$8,U
AA0E: A9 91       ADCA   [,X++]
AA10: A9 9C A9    ADCA   [$A9BC,PCR]
AA13: B8 A9 D3    EORA   $A9D3
AA16: A9 EA       ADCA   F,S
AA18: A6 01       LDA    $1,X
AA1A: A1 07       CMPA   $7,X
AA1C: 27 23       BEQ    $AA41
AA1E: 84 FC       ANDA   #$FC
AA20: 81 2C       CMPA   #$2C
AA22: 27 10       BEQ    $AA34
AA24: CE 13 E0    LDU    #$13E0
AA27: CC 00 03    LDD    #$0003
AA2A: BD 93 02    JSR    $9302
AA2D: C4 10       ANDB   #$10
AA2F: 27 1C       BEQ    $AA4D
AA31: 7E 8D C8    JMP    $8DC8
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
AA47: CE D9 C8    LDU    #$D9C8
AA4A: 7E 8D E8    JMP    $8DE8
AA4D: C6 20       LDB    #$20
AA4F: 7E 99 3B    JMP    $993B
AA52: A6 01       LDA    $1,X
AA54: A1 07       CMPA   $7,X
AA56: 27 0D       BEQ    $AA65
AA58: 84 FC       ANDA   #$FC
AA5A: 81 30       CMPA   #$30
AA5C: 27 03       BEQ    $AA61
AA5E: 7E 8D C8    JMP    $8DC8
AA61: A6 07       LDA    $7,X
AA63: A7 01       STA    $1,X
AA65: CE D9 E4    LDU    #$D9E4
AA68: 7E 8D E8    JMP    $8DE8
AA6B: CE AB 3B    LDU    #$AB3B
AA6E: A6 09       LDA    $9,X
AA70: 48          ASLA
AA71: 6E D6       JMP    [A,U]
AA73: 6A 0A       DEC    $A,X
AA75: 27 01       BEQ    $AA78
AA77: 39          RTS
AA78: CE D9 C8    LDU    #$D9C8
AA7B: 7E 8D E8    JMP    $8DE8
AA7E: 6A 0A       DEC    $A,X
AA80: 27 01       BEQ    $AA83
AA82: 39          RTS
AA83: A6 05       LDA    $5,X
AA85: 81 40       CMPA   #$40
AA87: 26 0A       BNE    $AA93
AA89: 86 80       LDA    #$80
AA8B: A7 05       STA    $5,X
AA8D: CE D9 C8    LDU    #$D9C8
AA90: 7E 8D E8    JMP    $8DE8
AA93: 86 40       LDA    #$40
AA95: A7 05       STA    $5,X
AA97: CE D9 C8    LDU    #$D9C8
AA9A: 7E 8D E8    JMP    $8DE8
AA9D: BD 90 76    JSR    $9076
AAA0: 26 01       BNE    $AAA3
AAA2: 39          RTS
AAA3: 0F 0B       CLR    $0B
AAA5: 0F 0D       CLR    $0D
AAA7: 96 0A       LDA    $0A
AAA9: 84 FC       ANDA   #$FC
AAAB: 97 0A       STA    $0A
AAAD: CE D9 C8    LDU    #$D9C8
AAB0: 7E 8D E8    JMP    $8DE8
AAB3: 6A 0A       DEC    $A,X
AAB5: 27 01       BEQ    $AAB8
AAB7: 39          RTS
AAB8: A6 84       LDA    ,X
AABA: 84 03       ANDA   #$03
AABC: 26 06       BNE    $AAC4
AABE: CE E0 B4    LDU    #$E0B4
AAC1: 7E 99 37    JMP    $9937
AAC4: CE D9 C8    LDU    #$D9C8
AAC7: 7E 8D E8    JMP    $8DE8
AACA: 6A 0A       DEC    $A,X
AACC: 27 01       BEQ    $AACF
AACE: 39          RTS
AACF: A6 84       LDA    ,X
AAD1: 84 03       ANDA   #$03
AAD3: 26 06       BNE    $AADB
AAD5: CE E0 14    LDU    #$E014
AAD8: 7E 99 37    JMP    $9937
AADB: 6C 14       INC    -$C,X
AADD: 39          RTS
AADE: CE A8 35    LDU    #$A835
AAE1: 96 0A       LDA    $0A
AAE3: 84 0C       ANDA   #$0C
AAE5: 44          LSRA
AAE6: EC C6       LDD    A,U
AAE8: ED 16       STD    -$A,X
AAEA: CE AB 49    LDU    #$AB49
AAED: A6 09       LDA    $9,X
AAEF: 48          ASLA
AAF0: 6E D6       JMP    [A,U]
AAF2: BD 8E 05    JSR    $8E05
AAF5: BD 90 76    JSR    $9076
AAF8: 26 01       BNE    $AAFB
AAFA: 39          RTS
AAFB: 0F 0D       CLR    $0D
AAFD: 0F 0B       CLR    $0B
AAFF: 96 0A       LDA    $0A
AB01: 84 FC       ANDA   #$FC
AB03: 97 0A       STA    $0A
AB05: CC 00 00    LDD    #$0000
AB08: ED 18       STD    -$8,X
AB0A: CE D9 E4    LDU    #$D9E4
AB0D: 7E 8D E8    JMP    $8DE8
AB10: 6A 0A       DEC    $A,X
AB12: 27 01       BEQ    $AB15
AB14: 39          RTS
AB15: A6 84       LDA    ,X
AB17: 84 03       ANDA   #$03
AB19: 26 06       BNE    $AB21
AB1B: CE E0 C8    LDU    #$E0C8
AB1E: 7E 99 37    JMP    $9937
AB21: CE D9 E4    LDU    #$D9E4
AB24: 7E 8D E8    JMP    $8DE8
AB27: 6A 0A       DEC    $A,X
AB29: 27 01       BEQ    $AB2C
AB2B: 39          RTS
AB2C: A6 84       LDA    ,X
AB2E: 84 03       ANDA   #$03
AB30: 26 06       BNE    $AB38
AB32: CE E0 14    LDU    #$E014
AB35: 7E 99 37    JMP    $9937
AB38: 6C 14       INC    -$C,X
AB3A: 39          RTS
AB3B: AA 73       ORA    -$D,S
AB3D: AA 7E       ORA    -$2,S
AB3F: AA 73       ORA    -$D,S
AB41: AA 73       ORA    -$D,S
AB43: AA 9D AA B3 ORA    [$55FA,PCR]
AB47: AA CA       ORA    F,U
AB49: AA F2       ORA    Illegal Postbyte
AB4B: AB 10       ADDA   -$10,X
AB4D: AB 27       ADDA   $7,Y
AB4F: 6A 0A       DEC    $A,X
AB51: 27 01       BEQ    $AB54
AB53: 39          RTS
AB54: 6C 14       INC    -$C,X
AB56: CE E0 14    LDU    #$E014
AB59: 7E 99 37    JMP    $9937
AB5C: 39          RTS
AB5D: 39          RTS
AB5E: 39          RTS
AB5F: 39          RTS
AB60: 10 8E 13 60 LDY    #$1360
AB64: 96 E4       LDA    $E4
AB66: C6 0B       LDB    #$0B
AB68: E7 A6       STB    A,Y
AB6A: 4C          INCA
AB6B: 84 1F       ANDA   #$1F
AB6D: 97 E4       STA    $E4
AB6F: 6C 0D       INC    $D,X
AB71: 7E 8D C8    JMP    $8DC8
AB74: CE AB 7C    LDU    #$AB7C
AB77: A6 09       LDA    $9,X
AB79: 48          ASLA
AB7A: 6E D6       JMP    [A,U]
AB7C: AB 8C AB    ADDA   $AB2A,PCR
AB7F: A3 AB       SUBD   D,Y
AB81: B0 AB B0    SUBA   $ABB0
AB84: AB B0 AB B0 ADDA   [-$5450,W]
AB88: AB BB       ADDA   [D,Y]
AB8A: AB C3       ADDA   ,--U
AB8C: 6A 0A       DEC    $A,X
AB8E: 27 01       BEQ    $AB91
AB90: 39          RTS
AB91: A6 01       LDA    $1,X
AB93: 8A 6C       ORA    #$6C
AB95: A7 01       STA    $1,X
AB97: A7 07       STA    $7,X
AB99: 86 02       LDA    #$02
AB9B: A7 04       STA    $4,X
AB9D: CE DA A4    LDU    #$DAA4
ABA0: 7E 8D E8    JMP    $8DE8
ABA3: 6A 0A       DEC    $A,X
ABA5: 27 01       BEQ    $ABA8
ABA7: 39          RTS
ABA8: 6F 04       CLR    $4,X
ABAA: CE DA A4    LDU    #$DAA4
ABAD: 7E 8D E8    JMP    $8DE8
ABB0: 6A 0A       DEC    $A,X
ABB2: 27 01       BEQ    $ABB5
ABB4: 39          RTS
ABB5: CE DA A4    LDU    #$DAA4
ABB8: 7E 8D E8    JMP    $8DE8
ABBB: 6A 0A       DEC    $A,X
ABBD: 27 01       BEQ    $ABC0
ABBF: 39          RTS
ABC0: 6C 09       INC    $9,X
ABC2: 39          RTS
ABC3: 96 03       LDA    $03
ABC5: 81 03       CMPA   #$03
ABC7: 27 3B       BEQ    $AC04
ABC9: 6D 1C       TST    -$4,X
ABCB: 2B 04       BMI    $ABD1
ABCD: 0D 10       TST    $10
ABCF: 26 1E       BNE    $ABEF
ABD1: 10 8E 5F 08 LDY    #$5F08
ABD5: 86 FF       LDA    #$FF
ABD7: F6 8C E9    LDB    $8CE9
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
AC14: 7E 8D E8    JMP    $8DE8
AC17: CC 00 40    LDD    #$0040
AC1A: ED 18       STD    -$8,X
AC1C: A6 0D       LDA    $D,X
AC1E: 84 04       ANDA   #$04
AC20: 27 0F       BEQ    $AC31
AC22: CC 00 20    LDD    #$0020
AC25: ED 16       STD    -$A,X
AC27: 7E 8D C8    JMP    $8DC8
AC2A: A6 0B       LDA    $B,X
AC2C: 8A 80       ORA    #$80
AC2E: A7 0B       STA    $B,X
AC30: 39          RTS
AC31: CC FF E0    LDD    #$FFE0
AC34: ED 16       STD    -$A,X
AC36: 7E 8D C8    JMP    $8DC8
AC39: A6 0B       LDA    $B,X
AC3B: 8A 80       ORA    #$80
AC3D: A7 0B       STA    $B,X
AC3F: 39          RTS
AC40: CE AC 48    LDU    #$AC48
AC43: A6 09       LDA    $9,X
AC45: 48          ASLA
AC46: 6E D6       JMP    [A,U]
AC48: AC 4E       CMPX   $E,U
AC4A: AC 6C       CMPX   $C,S
AC4C: AC 88 BD    CMPX   -$43,X
AC4F: 8E 05 BD    LDX    #$05BD
AC52: 90 76       SUBA   $76
AC54: 26 07       BNE    $AC5D
AC56: A6 19       LDA    -$7,X
AC58: 81 40       CMPA   #$40
AC5A: 2D 03       BLT    $AC5F
AC5C: 39          RTS
AC5D: 6C 09       INC    $9,X
AC5F: CE D9 80    LDU    #$D980
AC62: 7E 8D E8    JMP    $8DE8
AC65: A6 0B       LDA    $B,X
AC67: 8A 80       ORA    #$80
AC69: A7 0B       STA    $B,X
AC6B: 39          RTS
AC6C: BD 8E 05    JSR    $8E05
AC6F: BD 90 76    JSR    $9076
AC72: 26 07       BNE    $AC7B
AC74: A6 19       LDA    -$7,X
AC76: 81 C0       CMPA   #$C0
AC78: 2F 01       BLE    $AC7B
AC7A: 39          RTS
AC7B: CE D9 80    LDU    #$D980
AC7E: 7E 8D E8    JMP    $8DE8
AC81: A6 0B       LDA    $B,X
AC83: 8A 80       ORA    #$80
AC85: A7 0B       STA    $B,X
AC87: 39          RTS
AC88: BD 8E 05    JSR    $8E05
AC8B: BD 90 76    JSR    $9076
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
ACA3: CE E0 14    LDU    #$E014
ACA6: 7E 99 37    JMP    $9937
ACA9: 6C 14       INC    -$C,X
ACAB: 39          RTS
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
ACCA: A7 E2       STA    ,-S
ACCC: DC 80       LDD    $80
ACCE: C3 00 90    ADDD   #$0090
ACD1: A1 E0       CMPA   ,S+
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
ACF5: A7 E2       STA    ,-S
ACF7: DC 82       LDD    $82
ACF9: C3 00 80    ADDD   #$0080
ACFC: A1 E0       CMPA   ,S+
ACFE: 27 01       BEQ    $AD01
AD00: 39          RTS
AD01: 96 61       LDA    $61
AD03: 8A 08       ORA    #$08
AD05: 97 61       STA    $61
AD07: 39          RTS
AD08: CE AD 10    LDU    #$AD10
AD0B: 96 61       LDA    $61
AD0D: 48          ASLA
AD0E: 6E D6       JMP    [A,U]
AD10: AD 49       JSR    $9,U
AD12: AD 30       JSR    -$10,Y
AD14: AD 4F       JSR    $F,U
AD16: AD 49       JSR    $9,U
AD18: AD 6E       JSR    $E,S
AD1A: AD 8D AD 92 JSR    $5AB0,PCR
AD1E: AD 49       JSR    $9,U
AD20: AD 97       JSR    [E,X]
AD22: AD B6       JSR    [A,Y]
AD24: AD BB       JSR    [D,Y]
AD26: AD 49       JSR    $9,U
AD28: AD 49       JSR    $9,U
AD2A: AD 49       JSR    $9,U
AD2C: AD 49       JSR    $9,U
AD2E: AD 49       JSR    $9,U
AD30: 8E 13 00    LDX    #$1300
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
AD49: 0F 61       CLR    $61
AD4B: B7 80 00    STA    $8000
AD4E: 39          RTS
AD4F: 8E 13 00    LDX    #$1300
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
AD6A: B7 80 00    STA    $8000
AD6D: 39          RTS
AD6E: 8E 13 00    LDX    #$1300
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
AD89: B7 80 00    STA    $8000
AD8C: 39          RTS
AD8D: 8D DF       BSR    $AD6E
AD8F: 7E AD 30    JMP    $AD30
AD92: 8D DA       BSR    $AD6E
AD94: 7E AD 4F    JMP    $AD4F
AD97: 8E 13 00    LDX    #$1300
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
ADB2: B7 80 00    STA    $8000
ADB5: 39          RTS
ADB6: 8D DF       BSR    $AD97
ADB8: 7E AD 30    JMP    $AD30
ADBB: 8D DA       BSR    $AD97
ADBD: 7E AD 4F    JMP    $AD4F
ADC0: 96 36       LDA    $36
ADC2: 9B 37       ADDA   $37
ADC4: 26 01       BNE    $ADC7
ADC6: 39          RTS
ADC7: 8E 04 30    LDX    #$0430
ADCA: 97 3B       STA    $3B
ADCC: CE AD D4    LDU    #$ADD4
ADCF: 96 61       LDA    $61
ADD1: 48          ASLA
ADD2: 6E D6       JMP    [A,U]
ADD4: AD F4       JSR    [,S]
ADD6: AE 35       LDX    -$B,Y
ADD8: AD F5       JSR    [B,S]
ADDA: AD F4       JSR    [,S]
ADDC: AF 55       STX    -$B,U
ADDE: AF E5       STX    B,S
ADE0: AF 95       STX    [B,X]
ADE2: AD F4       JSR    [,S]
ADE4: AE 75       LDX    -$B,S
ADE6: AF 05       STX    $5,X
ADE8: AE B5       LDX    [B,Y]
ADEA: AD F4       JSR    [,S]
ADEC: AD F4       JSR    [,S]
ADEE: AD F4       JSR    [,S]
ADF0: AD F4       JSR    [,S]
ADF2: AD F4       JSR    [,S]
ADF4: 39          RTS
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
AE0B: BD C3 5A    JSR    $C35A
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
AE2F: 20 C4       BRA    $ADF5
AE31: B7 80 00    STA    $8000
AE34: 39          RTS
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
AE4B: BD C3 5A    JSR    $C35A
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
AE6F: 20 C4       BRA    $AE35
AE71: B7 80 00    STA    $8000
AE74: 39          RTS
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
AE8B: BD C3 5A    JSR    $C35A
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
AEAF: 20 C4       BRA    $AE75
AEB1: B7 80 00    STA    $8000
AEB4: 39          RTS
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
AED3: BD C3 5A    JSR    $C35A
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
AEFF: 20 B4       BRA    $AEB5
AF01: B7 80 00    STA    $8000
AF04: 39          RTS
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
AF23: BD C3 5A    JSR    $C35A
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
AF4F: 20 B4       BRA    $AF05
AF51: B7 80 00    STA    $8000
AF54: 39          RTS
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
AF6B: BD C3 5A    JSR    $C35A
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
AF8F: 20 C4       BRA    $AF55
AF91: B7 80 00    STA    $8000
AF94: 39          RTS
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
AFB3: BD C3 5A    JSR    $C35A
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
AFDF: 20 B4       BRA    $AF95
AFE1: B7 80 00    STA    $8000
AFE4: 39          RTS
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
B003: BD C3 5A    JSR    $C35A
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
B02F: 20 B4       BRA    $AFE5
B031: B7 80 00    STA    $8000
B034: 39          RTS
B035: 86 02       LDA    #$02
B037: 9B 3C       ADDA   $3C
B039: B7 D8 03    STA    $D803
B03C: D6 C7       LDB    $C7
B03E: C0 02       SUBB   #$02
B040: D7 63       STB    $63
B042: 86 03       LDA    #$03
B044: 97 66       STA    $66
B046: D6 63       LDB    $63
B048: 2B 06       BMI    $B050
B04A: D1 79       CMPB   $79
B04C: 2C 08       BGE    $B056
B04E: 8D 07       BSR    $B057
B050: 0C 63       INC    $63
B052: 0A 66       DEC    $66
B054: 26 F0       BNE    $B046
B056: 39          RTS
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
B072: ED E3       STD    ,--S
B074: CE E8 B0    LDU    #$E8B0
B077: 96 3C       LDA    $3C
B079: 48          ASLA
B07A: 9B C2       ADDA   $C2
B07C: 48          ASLA
B07D: EE C6       LDU    A,U
B07F: 96 C4       LDA    $C4
B081: 48          ASLA
B082: EE C6       LDU    A,U
B084: 96 63       LDA    $63
B086: D6 78       LDB    $78
B088: 3D          MUL
B089: E3 E1       ADDD   ,S++
B08B: 58          ASLB
B08C: 49          ROLA
B08D: 10 AE CB    LDY    D,U
B090: BD B1 E0    JSR    $B1E0
B093: 0C 62       INC    $62
B095: 0A 65       DEC    $65
B097: 26 C8       BNE    $B061
B099: 39          RTS
B09A: 0F 62       CLR    $62
B09C: 0F 63       CLR    $63
B09E: 86 02       LDA    #$02
B0A0: B7 D8 03    STA    $D803
B0A3: 97 65       STA    $65
B0A5: 10 8E 78 3C LDY    #$783C
B0A9: 96 D1       LDA    $D1
B0AB: 48          ASLA
B0AC: 10 AE A6    LDY    A,Y
B0AF: 96 62       LDA    $62
B0B1: 48          ASLA
B0B2: 10 AE A6    LDY    A,Y
B0B5: BD B1 E0    JSR    $B1E0
B0B8: 0C 62       INC    $62
B0BA: 0A 65       DEC    $65
B0BC: 26 E7       BNE    $B0A5
B0BE: 39          RTS
B0BF: D6 68       LDB    $68
B0C1: D1 67       CMPB   $67
B0C3: 26 01       BNE    $B0C6
B0C5: 39          RTS
B0C6: 86 02       LDA    #$02
B0C8: 9B 3C       ADDA   $3C
B0CA: 97 1A       STA    $1A
B0CC: B7 D8 03    STA    $D803
B0CF: 8E 13 00    LDX    #$1300
B0D2: 58          ASLB
B0D3: 58          ASLB
B0D4: 3A          ABX
B0D5: CE B0 DC    LDU    #$B0DC
B0D8: A6 84       LDA    ,X
B0DA: 6E D6       JMP    [A,U]
B0DC: B0 E6 B0    SUBA   $E6B0
B0DF: EE B1       LDU    [,Y++]
B0E1: 16 B1 3D    LBRA   $6221
B0E4: B1 65 96    CMPA   $6596
B0E7: 68 4C       ASL    $C,U
B0E9: 84 07       ANDA   #$07
B0EB: 97 68       STA    $68
B0ED: 39          RTS
B0EE: EC 02       LDD    $2,X
B0F0: 4C          INCA
B0F1: 91 78       CMPA   $78
B0F3: 2C 17       BGE    $B10C
B0F5: C0 02       SUBB   #$02
B0F7: DD 62       STD    $62
B0F9: CE E8 B0    LDU    #$E8B0
B0FC: 96 3C       LDA    $3C
B0FE: 48          ASLA
B0FF: 9B C2       ADDA   $C2
B101: 48          ASLA
B102: EE C6       LDU    A,U
B104: 96 C4       LDA    $C4
B106: 48          ASLA
B107: EE C6       LDU    A,U
B109: BD B1 8C    JSR    $B18C
B10C: 6F 84       CLR    ,X
B10E: 96 68       LDA    $68
B110: 4C          INCA
B111: 84 07       ANDA   #$07
B113: 97 68       STA    $68
B115: 39          RTS
B116: EC 02       LDD    $2,X
B118: 80 03       SUBA   #$03
B11A: 2B 17       BMI    $B133
B11C: C0 02       SUBB   #$02
B11E: DD 62       STD    $62
B120: CE E8 B0    LDU    #$E8B0
B123: 96 3C       LDA    $3C
B125: 48          ASLA
B126: 9B C2       ADDA   $C2
B128: 48          ASLA
B129: EE C6       LDU    A,U
B12B: 96 C4       LDA    $C4
B12D: 48          ASLA
B12E: EE C6       LDU    A,U
B130: BD B1 8C    JSR    $B18C
B133: 6F 84       CLR    ,X
B135: 96 68       LDA    $68
B137: 4C          INCA
B138: 84 07       ANDA   #$07
B13A: 97 68       STA    $68
B13C: 39          RTS
B13D: EC 02       LDD    $2,X
B13F: 80 02       SUBA   #$02
B141: 5C          INCB
B142: D1 79       CMPB   $79
B144: 2C 15       BGE    $B15B
B146: DD 62       STD    $62
B148: CE E8 B0    LDU    #$E8B0
B14B: 96 3C       LDA    $3C
B14D: 48          ASLA
B14E: 9B C2       ADDA   $C2
B150: 48          ASLA
B151: EE C6       LDU    A,U
B153: 96 C4       LDA    $C4
B155: 48          ASLA
B156: EE C6       LDU    A,U
B158: BD B1 B6    JSR    $B1B6
B15B: 6F 84       CLR    ,X
B15D: 96 68       LDA    $68
B15F: 4C          INCA
B160: 84 07       ANDA   #$07
B162: 97 68       STA    $68
B164: 39          RTS
B165: EC 02       LDD    $2,X
B167: 80 02       SUBA   #$02
B169: C0 03       SUBB   #$03
B16B: 2B 15       BMI    $B182
B16D: DD 62       STD    $62
B16F: CE E8 B0    LDU    #$E8B0
B172: 96 3C       LDA    $3C
B174: 48          ASLA
B175: 9B C2       ADDA   $C2
B177: 48          ASLA
B178: EE C6       LDU    A,U
B17A: 96 C4       LDA    $C4
B17C: 48          ASLA
B17D: EE C6       LDU    A,U
B17F: BD B1 B6    JSR    $B1B6
B182: 6F 84       CLR    ,X
B184: 96 68       LDA    $68
B186: 4C          INCA
B187: 84 07       ANDA   #$07
B189: 97 68       STA    $68
B18B: 39          RTS
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
B19F: ED E3       STD    ,--S
B1A1: D6 62       LDB    $62
B1A3: 1D          SEX
B1A4: E3 E1       ADDD   ,S++
B1A6: 58          ASLB
B1A7: 49          ROLA
B1A8: 10 AE CB    LDY    D,U
B1AB: 8D 33       BSR    $B1E0
B1AD: 0C 63       INC    $63
B1AF: 96 63       LDA    $63
B1B1: A1 03       CMPA   $3,X
B1B3: 2F D7       BLE    $B18C
B1B5: 39          RTS
B1B6: 96 30       LDA    $30
B1B8: 9B 31       ADDA   $31
B1BA: 81 28       CMPA   #$28
B1BC: 24 21       BCC    $B1DF
B1BE: D6 62       LDB    $62
B1C0: 2B 15       BMI    $B1D7
B1C2: D1 78       CMPB   $78
B1C4: 24 19       BCC    $B1DF
B1C6: 1D          SEX
B1C7: ED E3       STD    ,--S
B1C9: 96 63       LDA    $63
B1CB: D6 78       LDB    $78
B1CD: 3D          MUL
B1CE: E3 E1       ADDD   ,S++
B1D0: 58          ASLB
B1D1: 49          ROLA
B1D2: 10 AE CB    LDY    D,U
B1D5: 8D 09       BSR    $B1E0
B1D7: 0C 62       INC    $62
B1D9: D6 62       LDB    $62
B1DB: E1 02       CMPB   $2,X
B1DD: 2F D7       BLE    $B1B6
B1DF: 39          RTS
B1E0: A6 A0       LDA    ,Y+
B1E2: 26 01       BNE    $B1E5
B1E4: 39          RTS
B1E5: 34 50       PSHS   U,X
B1E7: 8E 04 30    LDX    #$0430
B1EA: 97 64       STA    $64
B1EC: A6 84       LDA    ,X
B1EE: 81 FF       CMPA   #$FF
B1F0: 26 06       BNE    $B1F8
B1F2: 8D 11       BSR    $B205
B1F4: 0A 64       DEC    $64
B1F6: 27 08       BEQ    $B200
B1F8: 30 88 20    LEAX   $20,X
B1FB: 8C 09 00    CMPX   #$0900
B1FE: 25 EC       BCS    $B1EC
B200: B7 80 00    STA    $8000
B203: 35 D0       PULS   X,U,PC
B205: EC A1       LDD    ,Y++
B207: 8A 80       ORA    #$80
B209: A7 84       STA    ,X
B20B: E7 07       STB    $7,X
B20D: EC A1       LDD    ,Y++
B20F: ED 02       STD    $2,X
B211: A6 A0       LDA    ,Y+
B213: A7 05       STA    $5,X
B215: 86 80       LDA    #$80
B217: A7 01       STA    $1,X
B219: 6F 0C       CLR    $C,X
B21B: 6F 0D       CLR    $D,X
B21D: 6F 0E       CLR    $E,X
B21F: CE E8 E0    LDU    #$E8E0
B222: A6 84       LDA    ,X
B224: 84 7C       ANDA   #$7C
B226: A7 E2       STA    ,-S
B228: A6 02       LDA    $2,X
B22A: 84 03       ANDA   #$03
B22C: AB E0       ADDA   ,S+
B22E: 48          ASLA
B22F: EC C6       LDD    A,U
B231: A7 04       STA    $4,X
B233: E7 06       STB    $6,X
B235: CE E9 40    LDU    #$E940
B238: A6 7F       LDA    -$1,S
B23A: 44          LSRA
B23B: EC C6       LDD    A,U
B23D: ED 12       STD    -$E,X
B23F: 96 62       LDA    $62
B241: E6 A0       LDB    ,Y+
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
B251: E6 A0       LDB    ,Y+
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
B278: 96 37       LDA    $37
B27A: 26 03       BNE    $B27F
B27C: 97 39       STA    $39
B27E: 39          RTS
B27F: 8E 04 30    LDX    #$0430
B282: 97 3B       STA    $3B
B284: 0F 39       CLR    $39
B286: A6 84       LDA    ,X
B288: 81 FF       CMPA   #$FF
B28A: 27 2D       BEQ    $B2B9
B28C: 84 7F       ANDA   #$7F
B28E: 81 20       CMPA   #$20
B290: 24 27       BCC    $B2B9
B292: 8D 2A       BSR    $B2BE
B294: A6 84       LDA    ,X
B296: 2B 1C       BMI    $B2B4
B298: BD 96 2A    JSR    $962A
B29B: CE B3 79    LDU    #$B379
B29E: A6 84       LDA    ,X
B2A0: 84 FC       ANDA   #$FC
B2A2: 81 10       CMPA   #$10
B2A4: 26 03       BNE    $B2A9
B2A6: CE B3 D1    LDU    #$B3D1
B2A9: E6 01       LDB    $1,X
B2AB: C1 C0       CMPB   #$C0
B2AD: 24 05       BCC    $B2B4
B2AF: C4 FC       ANDB   #$FC
B2B1: 54          LSRB
B2B2: AD D5       JSR    [B,U]
B2B4: 0A 3B       DEC    $3B
B2B6: 26 01       BNE    $B2B9
B2B8: 39          RTS
B2B9: 30 88 20    LEAX   $20,X
B2BC: 20 C8       BRA    $B286
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
B2FF: 7E B4 29    JMP    $B429
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
B33F: 7E B4 29    JMP    $B429
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
B36F: 7E B4 29    JMP    $B429
B372: A6 84       LDA    ,X
B374: 8A 80       ORA    #$80
B376: A7 84       STA    ,X
B378: 39          RTS
B379: BB CB B5    ADDA   $CBB5
B37C: 54          LSRB
B37D: BC 9E BE    CMPX   $9EBE
B380: 9C BE       CMPX   $BE
B382: B8 BE E8    EORA   $BEE8
B385: B9 0E B9    ADCA   $0EB9
B388: 74 B6 F1    LSR    $B6F1
B38B: B6 EB B7    LDA    $EBB7
B38E: 23 B8       BLS    $B348
B390: 18          X18
B391: B8 C4 B7    EORA   $C4B7
B394: C7 BB       XSTB   #$BB
B396: FF BD 77    STU    $BD77
B399: B5 54 BB    BITA   $54BB
B39C: 85 BE       BITA   #$BE
B39E: 47          ASRA
B39F: BF 3A C0    STX    $3AC0
B3A2: 36 BE       PSHU   PC,Y,X,DP,D
B3A4: 6C C1       INC    ,U++
B3A6: 17 C1 8A    LBSR   $7533
B3A9: C4 39       ANDB   #$39
B3AB: C4 E5       ANDB   #$E5
B3AD: C5 69       BITB   #$69
B3AF: BB CB BB    ADDA   $CBBB
B3B2: CB BB       ADDB   #$BB
B3B4: CB C6       ADDB   #$C6
B3B6: 54          LSRB
B3B7: C6 92       LDB    #$92
B3B9: C6 D5       LDB    #$D5
B3BB: C7 90       XSTB   #$90
B3BD: C8 FA       EORB   #$FA
B3BF: CB 01       ADDB   #$01
B3C1: CB 7C       ADDB   #$7C
B3C3: CB 9D       ADDB   #$9D
B3C5: C5 EA       BITB   #$EA
B3C7: B5 54 B5    BITA   $54B5
B3CA: 54          LSRB
B3CB: B5 54 C2    BITA   $54C2
B3CE: 7B C2 9E    XDEC   $C29E
B3D1: CD          XHCF
B3D2: 88 CC       EORA   #$CC
B3D4: AA CD 88 CD ORA    $3CA5,PCR
B3D8: 88 CD       EORA   #$CD
B3DA: 88 CD       EORA   #$CD
B3DC: 88 CD       EORA   #$CD
B3DE: E7 CD E7 CD STB    $9BAF,PCR
B3E2: 88 CD       EORA   #$CD
B3E4: 88 CD       EORA   #$CD
B3E6: 88 CD       EORA   #$CD
B3E8: 88 CD       EORA   #$CD
B3EA: 88 CD       EORA   #$CD
B3EC: 88 CD       EORA   #$CD
B3EE: 88 CD       EORA   #$CD
B3F0: 88 CD       EORA   #$CD
B3F2: 21 CE       BRN    $B3C2
B3F4: 3A          ABX
B3F5: CD          XHCF
B3F6: FB CE 26    ADDB   $CE26
B3F9: CD          XHCF
B3FA: 88 CD       EORA   #$CD
B3FC: 88 CD       EORA   #$CD
B3FE: 88 CD       EORA   #$CD
B400: 88 CE       EORA   #$CE
B402: 7E CE 7E    JMP    $CE7E
B405: CE 7E CE    LDU    #$7ECE
B408: 7E CD 88    JMP    $CD88
B40B: CD          XHCF
B40C: 88 CD       EORA   #$CD
B40E: 88 CD       EORA   #$CD
B410: 88 CD       EORA   #$CD
B412: 88 CD       EORA   #$CD
B414: 88 CD       EORA   #$CD
B416: 88 CD       EORA   #$CD
B418: 88 CD       EORA   #$CD
B41A: 88 CD       EORA   #$CD
B41C: 88 CD       EORA   #$CD
B41E: 88 CC       EORA   #$CC
B420: CE CD 88    LDU    #$CD88
B423: CD          XHCF
B424: 88 CD       EORA   #$CD
B426: 88 CD       EORA   #$CD
B428: 88 E7       EORA   #$E7
B42A: 07 C5       ASR    $C5
B42C: 03 26       COM    $26
B42E: 08 E6       ASL    $E6
B430: 01 C4       NEG    $C4
B432: 03 EB       COM    $EB
B434: 07 E7       ASR    $E7
B436: 07 A6       ASR    $A6
B438: 84 84       ANDA   #$84
B43A: 7F 81 10    CLR    $8110
B43D: 24 08       BCC    $B447
B43F: CE B4 4F    LDU    #$B44F
B442: C4 FC       ANDB   #$FC
B444: 54          LSRB
B445: 6E D5       JMP    [B,U]
B447: CE B4 B9    LDU    #$B4B9
B44A: C4 FC       ANDB   #$FC
B44C: 54          LSRB
B44D: 6E D5       JMP    [B,U]
B44F: BB C8 B5    ADDA   $C8B5
B452: 23 BC       BLS    $B410
B454: 86 8D       LDA    #$8D
B456: C8 BE       EORB   #$BE
B458: B1 8D C8    CMPA   $8DC8
B45B: B8 F2 B9    EORA   $F2B9
B45E: 5A          DECB
B45F: B6 DD B6    LDA    $DDB6
B462: DD B7       STD    $B7
B464: 18          X18
B465: B8 08 B8    EORA   $08B8
B468: 10 B7 20 8D STA    $208D
B46C: C8 BD       EORB   #$BD
B46E: 5F          CLRB
B46F: B5 23 BB    BITA   $23BB
B472: 6A 8D C8 BF DEC    $7D35,PCR
B476: 1D          SEX
B477: C0 19       SUBB   #$19
B479: 8D C8       BSR    $B443
B47B: C0 D2       SUBB   #$D2
B47D: C0 D5       SUBB   #$D5
B47F: C3 1A C3    ADDD   #$1AC3
B482: 1A C3       ORCC   #$C3
B484: 1A 8D       ORCC   #$8D
B486: C8 BB       EORB   #$BB
B488: DD B7       STD    $B7
B48A: 06 C6       ROR    $C6
B48C: 00 C6       NEG    $C6
B48E: 00 8D       NEG    $8D
B490: C8 C7       EORB   #$C7
B492: 8D C7       BSR    $B45B
B494: 8D CA       BSR    $B460
B496: C2 CA       SBCB   #$CA
B498: FE CB 9A    LDU    $CB9A
B49B: C5 E7       BITB   #$E7
B49D: B5 23 B8    BITA   $23B8
B4A0: F2 B9 5A    SBCB   $B95A
B4A3: C2 75       SBCB   #$75
B4A5: C2 78       SBCB   #$78
B4A7: 8D C8       BSR    $B471
B4A9: 8D C8       BSR    $B473
B4AB: 8D C8       BSR    $B475
B4AD: 8D C8       BSR    $B477
B4AF: 8D C8       BSR    $B479
B4B1: 8D C8       BSR    $B47B
B4B3: 8D C8       BSR    $B47D
B4B5: 8D C8       BSR    $B47F
B4B7: 8D C8       BSR    $B481
B4B9: CD          XHCF
B4BA: 75 CC 94    LSR    $CC94
B4BD: 8D C8       BSR    $B487
B4BF: 8D C8       BSR    $B489
B4C1: 8D C8       BSR    $B48B
B4C3: 8D C8       BSR    $B48D
B4C5: 8D C8       BSR    $B48F
B4C7: 8D C8       BSR    $B491
B4C9: 8D C8       BSR    $B493
B4CB: 8D C8       BSR    $B495
B4CD: 8D C8       BSR    $B497
B4CF: 8D C8       BSR    $B499
B4D1: 8D C8       BSR    $B49B
B4D3: 8D C8       BSR    $B49D
B4D5: 8D C8       BSR    $B49F
B4D7: 8D C8       BSR    $B4A1
B4D9: CD          XHCF
B4DA: 0B 8D       XDEC   $8D
B4DC: C8 8D       EORB   #$8D
B4DE: C8 8D       EORB   #$8D
B4E0: C8 8D       EORB   #$8D
B4E2: C8 8D       EORB   #$8D
B4E4: C8 8D       EORB   #$8D
B4E6: C8 8D       EORB   #$8D
B4E8: C8 CE       EORB   #$CE
B4EA: 59          ROLB
B4EB: CE 59 CE    LDU    #$59CE
B4EE: 59          ROLB
B4EF: 8D C8       BSR    $B4B9
B4F1: 8D C8       BSR    $B4BB
B4F3: 8D C8       BSR    $B4BD
B4F5: CE 9E CE    LDU    #$9ECE
B4F8: 9E 8D       LDX    $8D
B4FA: C8 8D       EORB   #$8D
B4FC: C8 8D       EORB   #$8D
B4FE: C8 8D       EORB   #$8D
B500: C8 8D       EORB   #$8D
B502: C8 8D       EORB   #$8D
B504: C8 8D       EORB   #$8D
B506: C8 8D       EORB   #$8D
B508: C8 8D       EORB   #$8D
B50A: C8 8D       EORB   #$8D
B50C: C8 8D       EORB   #$8D
B50E: C8 8D       EORB   #$8D
B510: C8 8D       EORB   #$8D
B512: C8 8D       EORB   #$8D
B514: C8 8D       EORB   #$8D
B516: C8 8D       EORB   #$8D
B518: C8 8D       EORB   #$8D
B51A: C8 8D       EORB   #$8D
B51C: C8 8D       EORB   #$8D
B51E: C8 8D       EORB   #$8D
B520: C8 8D       EORB   #$8D
B522: C8 CC       EORB   #$CC
B524: 00 00       NEG    $00
B526: ED 18       STD    -$8,X
B528: CE B5 44    LDU    #$B544
B52B: A6 03       LDA    $3,X
B52D: 84 30       ANDA   #$30
B52F: 44          LSRA
B530: 44          LSRA
B531: A7 E2       STA    ,-S
B533: A6 07       LDA    $7,X
B535: 84 02       ANDA   #$02
B537: AB E0       ADDA   ,S+
B539: EC C6       LDD    A,U
B53B: A7 08       STA    $8,X
B53D: 5D          TSTB
B53E: 1D          SEX
B53F: ED 16       STD    -$A,X
B541: 7E 8D C8    JMP    $8DC8
B544: 14          XHCF
B545: 14          XHCF
B546: 1E EC       EXG    inv,inv
B548: 14          XHCF
B549: 18          X18
B54A: 1E E8       EXG    inv,A
B54C: 14          XHCF
B54D: 1C 1E       ANDCC  #$1E
B54F: E4 14       ANDB   -$C,X
B551: 20 1E       BRA    $B571
B553: E0 BD 94 97 SUBB   [$49EE,PCR]
B557: 2A 01       BPL    $B55A
B559: 39          RTS
B55A: 10 26 FE CB LBNE   $B429
B55E: BD 9A FA    JSR    $9AFA
B561: 10 26 FE C4 LBNE   $B429
B565: BD 9A 62    JSR    $9A62
B568: 10 26 FE BD LBNE   $B429
B56C: BD B6 57    JSR    $B657
B56F: 10 26 FE B6 LBNE   $B429
B573: BD B5 C1    JSR    $B5C1
B576: 10 26 FE AF LBNE   $B429
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
B59A: 7E 8D E8    JMP    $8DE8
B59D: CE DB 34    LDU    #$DB34
B5A0: 7E 8D E8    JMP    $8DE8
B5A3: BD 94 97    JSR    $9497
B5A6: 2A 01       BPL    $B5A9
B5A8: 39          RTS
B5A9: 10 26 FE 7C LBNE   $B429
B5AD: 6A 0A       DEC    $A,X
B5AF: 27 01       BEQ    $B5B2
B5B1: 39          RTS
B5B2: A6 09       LDA    $9,X
B5B4: 81 05       CMPA   #$05
B5B6: 27 06       BEQ    $B5BE
B5B8: CE DB 1C    LDU    #$DB1C
B5BB: 7E 8D E8    JMP    $8DE8
B5BE: 6C 14       INC    -$C,X
B5C0: 39          RTS
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
B5FC: CE B5 44    LDU    #$B544
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
B60E: B3 04 0A    SUBD   $040A
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
B62B: A7 E2       STA    ,-S
B62D: 96 0E       LDA    $0E
B62F: 84 02       ANDA   #$02
B631: AB E0       ADDA   ,S+
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
B64F: 00 00       NEG    $00
B651: 18          X18
B652: 18          X18
B653: 0C 0C       INC    $0C
B655: 18          X18
B656: 0C A6       INC    $A6
B658: 02 84       XNC    $84
B65A: 20 26       BRA    $B682
B65C: 01 39       NEG    $39
B65E: 96 0F       LDA    $0F
B660: 84 0F       ANDA   #$0F
B662: 27 02       BEQ    $B666
B664: 5F          CLRB
B665: 39          RTS
B666: 96 53       LDA    $53
B668: 26 01       BNE    $B66B
B66A: 39          RTS
B66B: 97 55       STA    $55
B66D: CE 10 00    LDU    #$1000
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
B69A: 10 8E B6 DB LDY    #$B6DB
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
B6DD: CC 00 70    LDD    #$0070
B6E0: ED 18       STD    -$8,X
B6E2: A6 0C       LDA    $C,X
B6E4: 84 7E       ANDA   #$7E
B6E6: A7 0C       STA    $C,X
B6E8: 7E 8D C8    JMP    $8DC8
B6EB: BD 94 97    JSR    $9497
B6EE: 2A 01       BPL    $B6F1
B6F0: 39          RTS
B6F1: BD 95 6D    JSR    $956D
B6F4: 26 0B       BNE    $B701
B6F6: 6A 0A       DEC    $A,X
B6F8: 27 01       BEQ    $B6FB
B6FA: 39          RTS
B6FB: CE DB 4C    LDU    #$DB4C
B6FE: 7E 8D E8    JMP    $8DE8
B701: C6 04       LDB    #$04
B703: 7E B4 29    JMP    $B429
B706: EC 1C       LDD    -$4,X
B708: 10 83 07 00 CMPD   #$0700
B70C: 2C 05       BGE    $B713
B70E: C6 28       LDB    #$28
B710: 7E B4 29    JMP    $B429
B713: C6 2C       LDB    #$2C
B715: 7E B4 29    JMP    $B429
B718: CC 00 A0    LDD    #$00A0
B71B: ED 18       STD    -$8,X
B71D: 7E 8D C8    JMP    $8DC8
B720: 7E 8D C8    JMP    $8DC8
B723: CE B7 F4    LDU    #$B7F4
B726: A6 09       LDA    $9,X
B728: 48          ASLA
B729: 6E D6       JMP    [A,U]
B72B: 6A 0A       DEC    $A,X
B72D: 27 01       BEQ    $B730
B72F: 39          RTS
B730: A6 01       LDA    $1,X
B732: 88 03       EORA   #$03
B734: A7 01       STA    $1,X
B736: A7 07       STA    $7,X
B738: CE DB 64    LDU    #$DB64
B73B: 7E 8D E8    JMP    $8DE8
B73E: BD 95 6D    JSR    $956D
B741: 26 0F       BNE    $B752
B743: EC 18       LDD    -$8,X
B745: 27 1D       BEQ    $B764
B747: 6A 0A       DEC    $A,X
B749: 27 01       BEQ    $B74C
B74B: 39          RTS
B74C: CE DB 64    LDU    #$DB64
B74F: 7E 8D E8    JMP    $8DE8
B752: 6C 09       INC    $9,X
B754: CE DB 64    LDU    #$DB64
B757: 7E 8D E8    JMP    $8DE8
B75A: BD 95 6D    JSR    $956D
B75D: 26 0A       BNE    $B769
B75F: EC 18       LDD    -$8,X
B761: 27 01       BEQ    $B764
B763: 39          RTS
B764: C6 34       LDB    #$34
B766: 7E B4 29    JMP    $B429
B769: A6 01       LDA    $1,X
B76B: 88 03       EORA   #$03
B76D: A7 01       STA    $1,X
B76F: A7 07       STA    $7,X
B771: CE DB 64    LDU    #$DB64
B774: 7E 8D E8    JMP    $8DE8
B777: 6A 0A       DEC    $A,X
B779: 27 01       BEQ    $B77C
B77B: 39          RTS
B77C: CE DB 64    LDU    #$DB64
B77F: 7E 8D E8    JMP    $8DE8
B782: 6A 0A       DEC    $A,X
B784: 27 01       BEQ    $B787
B786: 39          RTS
B787: A6 05       LDA    $5,X
B789: 81 40       CMPA   #$40
B78B: 26 0A       BNE    $B797
B78D: 86 80       LDA    #$80
B78F: A7 05       STA    $5,X
B791: CE DB 64    LDU    #$DB64
B794: 7E 8D E8    JMP    $8DE8
B797: 86 40       LDA    #$40
B799: A7 05       STA    $5,X
B79B: CE DB 64    LDU    #$DB64
B79E: 7E 8D E8    JMP    $8DE8
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
B7B9: 7E B4 29    JMP    $B429
B7BC: A6 0C       LDA    $C,X
B7BE: 84 FD       ANDA   #$FD
B7C0: A7 0C       STA    $C,X
B7C2: C6 04       LDB    #$04
B7C4: 7E B4 29    JMP    $B429
B7C7: CE B8 04    LDU    #$B804
B7CA: A6 09       LDA    $9,X
B7CC: 48          ASLA
B7CD: 6E D6       JMP    [A,U]
B7CF: BD 95 6D    JSR    $956D
B7D2: 26 01       BNE    $B7D5
B7D4: 39          RTS
B7D5: CE DB 8C    LDU    #$DB8C
B7D8: 7E 8D E8    JMP    $8DE8
B7DB: 6A 0A       DEC    $A,X
B7DD: 27 01       BEQ    $B7E0
B7DF: 39          RTS
B7E0: A6 0C       LDA    $C,X
B7E2: 8A 20       ORA    #$20
B7E4: A7 0C       STA    $C,X
B7E6: 85 01       BITA   #$01
B7E8: 26 05       BNE    $B7EF
B7EA: C6 04       LDB    #$04
B7EC: 7E B4 29    JMP    $B429
B7EF: C6 48       LDB    #$48
B7F1: 7E B4 29    JMP    $B429
B7F4: B7 2B B7    STA    $2BB7
B7F7: 3E          XRES
B7F8: B7 5A B7    STA    $5AB7
B7FB: 77 B7 82    ASR    $B782
B7FE: B7 77 B7    STA    $77B7
B801: 77 B7 A1    ASR    $B7A1
B804: B7 CF B7    STA    $CFB7
B807: DB CC       ADDB   $CC
B809: 00 00       NEG    $00
B80B: ED 18       STD    -$8,X
B80D: 7E 8D C8    JMP    $8DC8
B810: CC 00 20    LDD    #$0020
B813: ED 18       STD    -$8,X
B815: 7E 8D C8    JMP    $8DC8
B818: CE B8 DE    LDU    #$B8DE
B81B: A6 09       LDA    $9,X
B81D: 48          ASLA
B81E: 6E D6       JMP    [A,U]
B820: 6A 0A       DEC    $A,X
B822: 27 01       BEQ    $B825
B824: 39          RTS
B825: CE DD 20    LDU    #$DD20
B828: 7E 8D E8    JMP    $8DE8
B82B: 6A 0A       DEC    $A,X
B82D: 27 01       BEQ    $B830
B82F: 39          RTS
B830: A6 05       LDA    $5,X
B832: 81 40       CMPA   #$40
B834: 27 0A       BEQ    $B840
B836: 86 40       LDA    #$40
B838: A7 05       STA    $5,X
B83A: CE DD 20    LDU    #$DD20
B83D: 7E 8D E8    JMP    $8DE8
B840: 86 80       LDA    #$80
B842: A7 05       STA    $5,X
B844: CE DD 20    LDU    #$DD20
B847: 7E 8D E8    JMP    $8DE8
B84A: 6A 0A       DEC    $A,X
B84C: 27 01       BEQ    $B84F
B84E: 39          RTS
B84F: CE DD 20    LDU    #$DD20
B852: 7E 8D E8    JMP    $8DE8
B855: BD 95 6D    JSR    $956D
B858: 26 0B       BNE    $B865
B85A: 6A 0A       DEC    $A,X
B85C: 27 01       BEQ    $B85F
B85E: 39          RTS
B85F: CE DD 20    LDU    #$DD20
B862: 7E 8D E8    JMP    $8DE8
B865: 6C 09       INC    $9,X
B867: 6C 09       INC    $9,X
B869: CE DD 20    LDU    #$DD20
B86C: 7E 8D E8    JMP    $8DE8
B86F: BD 95 6D    JSR    $956D
B872: 26 0B       BNE    $B87F
B874: 6A 0A       DEC    $A,X
B876: 27 01       BEQ    $B879
B878: 39          RTS
B879: CE DD 20    LDU    #$DD20
B87C: 7E 8D E8    JMP    $8DE8
B87F: 6C 09       INC    $9,X
B881: CE DD 20    LDU    #$DD20
B884: 7E 8D E8    JMP    $8DE8
B887: BD 95 6D    JSR    $956D
B88A: 26 01       BNE    $B88D
B88C: 39          RTS
B88D: CE DD 20    LDU    #$DD20
B890: 7E 8D E8    JMP    $8DE8
B893: 6A 0A       DEC    $A,X
B895: 27 01       BEQ    $B898
B897: 39          RTS
B898: CE DD 20    LDU    #$DD20
B89B: 7E 8D E8    JMP    $8DE8
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
B8B6: 7E B4 29    JMP    $B429
B8B9: A6 0C       LDA    $C,X
B8BB: 84 FD       ANDA   #$FD
B8BD: A7 0C       STA    $C,X
B8BF: C6 04       LDB    #$04
B8C1: 7E B4 29    JMP    $B429
B8C4: CE B8 EE    LDU    #$B8EE
B8C7: A6 09       LDA    $9,X
B8C9: 48          ASLA
B8CA: 6E D6       JMP    [A,U]
B8CC: BD 94 97    JSR    $9497
B8CF: 2A 01       BPL    $B8D2
B8D1: 39          RTS
B8D2: BD 95 6D    JSR    $956D
B8D5: 26 01       BNE    $B8D8
B8D7: 39          RTS
B8D8: CE DB 84    LDU    #$DB84
B8DB: 7E 8D E8    JMP    $8DE8
B8DE: B8 20 B8    EORA   $20B8
B8E1: 2B B8       BMI    $B89B
B8E3: 4A          DECA
B8E4: B8 55 B8    EORA   $55B8
B8E7: 6F B8 87    CLR    [-$79,Y]
B8EA: B8 93 B8    EORA   $93B8
B8ED: 9E B8       LDX    $B8
B8EF: CC B8 9E    LDD    #$B89E
B8F2: EC 1A       LDD    -$6,X
B8F4: 10 83 14 00 CMPD   #$1400
B8F8: 2C 46       BGE    $B940
B8FA: A6 02       LDA    $2,X
B8FC: 84 10       ANDA   #$10
B8FE: 26 07       BNE    $B907
B900: 86 01       LDA    #$01
B902: A7 08       STA    $8,X
B904: 7E 8D C8    JMP    $8DC8
B907: 86 03       LDA    #$03
B909: A7 08       STA    $8,X
B90B: 7E 8D C8    JMP    $8DC8
B90E: 6A 0A       DEC    $A,X
B910: 27 01       BEQ    $B913
B912: 39          RTS
B913: CE B9 1B    LDU    #$B91B
B916: A6 09       LDA    $9,X
B918: 48          ASLA
B919: 6E D6       JMP    [A,U]
B91B: B9 25 B9    ADCA   $25B9
B91E: 2B B9       BMI    $B8D9
B920: 34 B9       PSHS   PC,Y,X,DP,CC
B922: 25 B9       BCS    $B8DD
B924: 40          NEGA
B925: CE DB 94    LDU    #$DB94
B928: 7E 8D E8    JMP    $8DE8
B92B: BD B9 C6    JSR    $B9C6
B92E: CE DB 94    LDU    #$DB94
B931: 7E 8D E8    JMP    $8DE8
B934: 6A 08       DEC    $8,X
B936: 27 02       BEQ    $B93A
B938: 6F 09       CLR    $9,X
B93A: CE DB 94    LDU    #$DB94
B93D: 7E 8D E8    JMP    $8DE8
B940: A6 0D       LDA    $D,X
B942: 84 01       ANDA   #$01
B944: 27 0A       BEQ    $B950
B946: 7D 00 02    TST    >$0002
B949: 2B 0A       BMI    $B955
B94B: C6 04       LDB    #$04
B94D: 7E B4 29    JMP    $B429
B950: C6 70       LDB    #$70
B952: 7E B4 29    JMP    $B429
B955: C6 00       LDB    #$00
B957: 7E B4 29    JMP    $B429
B95A: A6 0C       LDA    $C,X
B95C: 8A 08       ORA    #$08
B95E: A7 0C       STA    $C,X
B960: A6 02       LDA    $2,X
B962: 84 10       ANDA   #$10
B964: 26 07       BNE    $B96D
B966: 86 01       LDA    #$01
B968: A7 08       STA    $8,X
B96A: 7E 8D C8    JMP    $8DC8
B96D: 86 03       LDA    #$03
B96F: A7 08       STA    $8,X
B971: 7E 8D C8    JMP    $8DC8
B974: 6A 0A       DEC    $A,X
B976: 27 01       BEQ    $B979
B978: 39          RTS
B979: CE B9 81    LDU    #$B981
B97C: A6 09       LDA    $9,X
B97E: 48          ASLA
B97F: 6E D6       JMP    [A,U]
B981: B9 8B B9    ADCA   $8BB9
B984: 91 B9       CMPA   $B9
B986: 9A B9       ORA    $B9
B988: 8B B9       ADDA   #$B9
B98A: A6 CE       LDA    W,U
B98C: DB A8       ADDB   $A8
B98E: 7E 8D E8    JMP    $8DE8
B991: BD BA 98    JSR    $BA98
B994: CE DB A8    LDU    #$DBA8
B997: 7E 8D E8    JMP    $8DE8
B99A: 6A 08       DEC    $8,X
B99C: 27 02       BEQ    $B9A0
B99E: 6F 09       CLR    $9,X
B9A0: CE DB A8    LDU    #$DBA8
B9A3: 7E 8D E8    JMP    $8DE8
B9A6: A6 0C       LDA    $C,X
B9A8: 84 F7       ANDA   #$F7
B9AA: A7 0C       STA    $C,X
B9AC: A6 0D       LDA    $D,X
B9AE: 84 01       ANDA   #$01
B9B0: 27 0A       BEQ    $B9BC
B9B2: 7D 00 02    TST    >$0002
B9B5: 2B 0A       BMI    $B9C1
B9B7: C6 14       LDB    #$14
B9B9: 7E B4 29    JMP    $B429
B9BC: C6 70       LDB    #$70
B9BE: 7E B4 29    JMP    $B429
B9C1: C6 10       LDB    #$10
B9C3: 7E B4 29    JMP    $B429
B9C6: CE 09 00    LDU    #$0900
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
BA98: CE 09 00    LDU    #$0900
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
BB6A: CC 00 70    LDD    #$0070
BB6D: ED 18       STD    -$8,X
BB6F: A6 07       LDA    $7,X
BB71: 84 02       ANDA   #$02
BB73: 26 08       BNE    $BB7D
BB75: CC 00 30    LDD    #$0030
BB78: ED 16       STD    -$A,X
BB7A: 7E 8D C8    JMP    $8DC8
BB7D: CC FF D0    LDD    #$FFD0
BB80: ED 16       STD    -$A,X
BB82: 7E 8D C8    JMP    $8DC8
BB85: CE BB C2    LDU    #$BBC2
BB88: A6 09       LDA    $9,X
BB8A: 48          ASLA
BB8B: 6E D6       JMP    [A,U]
BB8D: BD 94 97    JSR    $9497
BB90: 2A 01       BPL    $BB93
BB92: 39          RTS
BB93: BD 95 6D    JSR    $956D
BB96: EC 18       LDD    -$8,X
BB98: 27 01       BEQ    $BB9B
BB9A: 39          RTS
BB9B: CE DB BC    LDU    #$DBBC
BB9E: 7E 8D E8    JMP    $8DE8
BBA1: BD 94 97    JSR    $9497
BBA4: 2A 01       BPL    $BBA7
BBA6: 39          RTS
BBA7: BD 95 6D    JSR    $956D
BBAA: 26 01       BNE    $BBAD
BBAC: 39          RTS
BBAD: CE DB BC    LDU    #$DBBC
BBB0: 7E 8D E8    JMP    $8DE8
BBB3: 6A 0A       DEC    $A,X
BBB5: 27 01       BEQ    $BBB8
BBB7: 39          RTS
BBB8: CC 00 00    LDD    #$0000
BBBB: ED 18       STD    -$8,X
BBBD: C6 04       LDB    #$04
BBBF: 7E B4 29    JMP    $B429
BBC2: BB 8D BB    ADDA   $8DBB
BBC5: A1 BB       CMPA   [D,Y]
BBC7: B3 7E 8D    SUBD   $7E8D
BBCA: C8 6A       EORB   #$6A
BBCC: 0A 27       DEC    $27
BBCE: 01 39       NEG    $39
BBD0: C6 04       LDB    #$04
BBD2: 7E B4 29    JMP    $B429
BBD5: 6A 0A       DEC    $A,X
BBD7: 27 01       BEQ    $BBDA
BBD9: 39          RTS
BBDA: 6C 14       INC    -$C,X
BBDC: 39          RTS
BBDD: A6 0D       LDA    $D,X
BBDF: 85 20       BITA   #$20
BBE1: 26 12       BNE    $BBF5
BBE3: 85 01       BITA   #$01
BBE5: 26 13       BNE    $BBFA
BBE7: 85 08       BITA   #$08
BBE9: 26 05       BNE    $BBF0
BBEB: C6 3C       LDB    #$3C
BBED: 7E B4 29    JMP    $B429
BBF0: C6 08       LDB    #$08
BBF2: 7E B4 29    JMP    $B429
BBF5: C6 38       LDB    #$38
BBF7: 7E B4 29    JMP    $B429
BBFA: C6 04       LDB    #$04
BBFC: 7E B4 29    JMP    $B429
BBFF: 6A 0A       DEC    $A,X
BC01: 27 01       BEQ    $BC04
BC03: 39          RTS
BC04: CE BC 0C    LDU    #$BC0C
BC07: A6 09       LDA    $9,X
BC09: 48          ASLA
BC0A: 6E D6       JMP    [A,U]
BC0C: BC 1E BC    CMPX   $1EBC
BC0F: 26 BC       BNE    $BBCD
BC11: 2C BC       BGE    $BBCF
BC13: 2C BC       BGE    $BBD1
BC15: 2C BC       BGE    $BBD3
BC17: 2C BC       BGE    $BBD5
BC19: 2C BC       BGE    $BBD7
BC1B: 1E BC       EXG    DP,inv
BC1D: 55          LSRB
BC1E: A6 01       LDA    $1,X
BC20: 88 03       EORA   #$03
BC22: A7 01       STA    $1,X
BC24: A7 07       STA    $7,X
BC26: CE DB C8    LDU    #$DBC8
BC29: 7E 8D E8    JMP    $8DE8
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
BC48: 7E B4 29    JMP    $B429
BC4B: 85 04       BITA   #$04
BC4D: 27 F7       BEQ    $BC46
BC4F: CE DB C8    LDU    #$DBC8
BC52: 7E 8D E8    JMP    $8DE8
BC55: A6 0D       LDA    $D,X
BC57: 85 20       BITA   #$20
BC59: 27 0B       BEQ    $BC66
BC5B: E6 0C       LDB    $C,X
BC5D: C4 FB       ANDB   #$FB
BC5F: E7 0C       STB    $C,X
BC61: C6 04       LDB    #$04
BC63: 7E B4 29    JMP    $B429
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
BC7E: 7E B4 29    JMP    $B429
BC81: C6 08       LDB    #$08
BC83: 7E B4 29    JMP    $B429
BC86: A6 03       LDA    $3,X
BC88: 84 03       ANDA   #$03
BC8A: 27 05       BEQ    $BC91
BC8C: 6F 08       CLR    $8,X
BC8E: 7E 8D C8    JMP    $8DC8
BC91: 86 02       LDA    #$02
BC93: A7 08       STA    $8,X
BC95: A6 0C       LDA    $C,X
BC97: 8A 04       ORA    #$04
BC99: A7 0C       STA    $C,X
BC9B: 7E 8D C8    JMP    $8DC8
BC9E: 6A 0A       DEC    $A,X
BCA0: 27 01       BEQ    $BCA3
BCA2: 39          RTS
BCA3: CE BC AB    LDU    #$BCAB
BCA6: A6 09       LDA    $9,X
BCA8: 48          ASLA
BCA9: 6E D6       JMP    [A,U]
BCAB: BC BD BC    CMPX   $BDBC
BCAE: BD BC BD    JSR    $BCBD
BCB1: BC BD BC    CMPX   $BDBC
BCB4: C3 BD 24    ADDD   #$BD24
BCB7: BC BD BC    CMPX   $BDBC
BCBA: BD BD 3A    JSR    $BD3A
BCBD: CE DD 94    LDU    #$DD94
BCC0: 7E 8D E8    JMP    $8DE8
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
BCD7: B3 04 0A    SUBD   $040A
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
BD08: BD 93 02    JSR    $9302
BD0B: 81 23       CMPA   #$23
BD0D: 27 09       BEQ    $BD18
BD0F: 81 2F       CMPA   #$2F
BD11: 27 05       BEQ    $BD18
BD13: C6 28       LDB    #$28
BD15: 7E B4 29    JMP    $B429
BD18: A6 0C       LDA    $C,X
BD1A: 8A 20       ORA    #$20
BD1C: A7 0C       STA    $C,X
BD1E: CE DD 94    LDU    #$DD94
BD21: 7E 8D E8    JMP    $8DE8
BD24: A6 0D       LDA    $D,X
BD26: 84 21       ANDA   #$21
BD28: 26 0A       BNE    $BD34
BD2A: 6D 08       TST    $8,X
BD2C: 27 06       BEQ    $BD34
BD2E: 6A 08       DEC    $8,X
BD30: 86 03       LDA    #$03
BD32: A7 09       STA    $9,X
BD34: CE DD 94    LDU    #$DD94
BD37: 7E 8D E8    JMP    $8DE8
BD3A: A6 0D       LDA    $D,X
BD3C: 84 01       ANDA   #$01
BD3E: 26 0B       BNE    $BD4B
BD40: A6 0C       LDA    $C,X
BD42: 85 20       BITA   #$20
BD44: 26 0B       BNE    $BD51
BD46: C6 38       LDB    #$38
BD48: 7E B4 29    JMP    $B429
BD4B: A6 0C       LDA    $C,X
BD4D: 84 FB       ANDA   #$FB
BD4F: A7 0C       STA    $C,X
BD51: 85 01       BITA   #$01
BD53: 26 05       BNE    $BD5A
BD55: C6 04       LDB    #$04
BD57: 7E B4 29    JMP    $B429
BD5A: C6 48       LDB    #$48
BD5C: 7E B4 29    JMP    $B429
BD5F: A6 03       LDA    $3,X
BD61: 84 03       ANDA   #$03
BD63: 27 05       BEQ    $BD6A
BD65: 6F 08       CLR    $8,X
BD67: 7E 8D C8    JMP    $8DC8
BD6A: 86 02       LDA    #$02
BD6C: A7 08       STA    $8,X
BD6E: A6 0C       LDA    $C,X
BD70: 8A 04       ORA    #$04
BD72: A7 0C       STA    $C,X
BD74: 7E 8D C8    JMP    $8DC8
BD77: 6A 0A       DEC    $A,X
BD79: 27 01       BEQ    $BD7C
BD7B: 39          RTS
BD7C: CE BD 84    LDU    #$BD84
BD7F: A6 09       LDA    $9,X
BD81: 48          ASLA
BD82: 6E D6       JMP    [A,U]
BD84: BD 94 BD    JSR    $94BD
BD87: 94 BD       ANDA   $BD
BD89: 94 BD       ANDA   $BD
BD8B: 94 BD       ANDA   $BD
BD8D: 9A BE       ORA    $BE
BD8F: 0C BD       INC    $BD
BD91: 94 BE       ANDA   $BE
BD93: 22 CE       BHI    $BD63
BD95: DC FC       LDD    $FC
BD97: 7E 8D E8    JMP    $8DE8
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
BDB2: B3 04 0A    SUBD   $040A
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
BDEB: 7E B4 29    JMP    $B429
BDEE: CE 13 E0    LDU    #$13E0
BDF1: CC 00 03    LDD    #$0003
BDF4: BD 93 02    JSR    $9302
BDF7: C4 10       ANDB   #$10
BDF9: 27 05       BEQ    $BE00
BDFB: C6 2C       LDB    #$2C
BDFD: 7E B4 29    JMP    $B429
BE00: A6 0C       LDA    $C,X
BE02: 8A 20       ORA    #$20
BE04: A7 0C       STA    $C,X
BE06: CE DC FC    LDU    #$DCFC
BE09: 7E 8D E8    JMP    $8DE8
BE0C: A6 0D       LDA    $D,X
BE0E: 84 21       ANDA   #$21
BE10: 26 0A       BNE    $BE1C
BE12: 6D 08       TST    $8,X
BE14: 27 06       BEQ    $BE1C
BE16: 6A 08       DEC    $8,X
BE18: 86 03       LDA    #$03
BE1A: A7 09       STA    $9,X
BE1C: CE DC FC    LDU    #$DCFC
BE1F: 7E 8D E8    JMP    $8DE8
BE22: A6 0D       LDA    $D,X
BE24: 85 01       BITA   #$01
BE26: 26 0B       BNE    $BE33
BE28: A6 0C       LDA    $C,X
BE2A: 85 20       BITA   #$20
BE2C: 26 0B       BNE    $BE39
BE2E: C6 38       LDB    #$38
BE30: 7E B4 29    JMP    $B429
BE33: A6 0C       LDA    $C,X
BE35: 84 FB       ANDA   #$FB
BE37: A7 0C       STA    $C,X
BE39: 85 01       BITA   #$01
BE3B: 26 05       BNE    $BE42
BE3D: C6 04       LDB    #$04
BE3F: 7E B4 29    JMP    $B429
BE42: C6 48       LDB    #$48
BE44: 7E B4 29    JMP    $B429
BE47: 6A 0A       DEC    $A,X
BE49: 27 01       BEQ    $BE4C
BE4B: 39          RTS
BE4C: CE BE 54    LDU    #$BE54
BE4F: A6 09       LDA    $9,X
BE51: 48          ASLA
BE52: 6E D6       JMP    [A,U]
BE54: BE 66 BE    LDX    $66BE
BE57: 66 BE       ROR    [W,Y]
BE59: 5E          XCLRB
BE5A: BE 66 BE    LDX    $66BE
BE5D: 71 A6 01    NEG    $A601
BE60: 88 03       EORA   #$03
BE62: A7 01       STA    $1,X
BE64: A7 07       STA    $7,X
BE66: CE DB EC    LDU    #$DBEC
BE69: 7E 8D E8    JMP    $8DE8
BE6C: 6A 0A       DEC    $A,X
BE6E: 27 01       BEQ    $BE71
BE70: 39          RTS
BE71: A6 0C       LDA    $C,X
BE73: 84 FE       ANDA   #$FE
BE75: A7 0C       STA    $C,X
BE77: C6 04       LDB    #$04
BE79: 7E B4 29    JMP    $B429
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
BE93: CE DB EC    LDU    #$DBEC
BE96: 7E 8D E8    JMP    $8DE8
BE99: 6C 14       INC    -$C,X
BE9B: 39          RTS
BE9C: 6A 0A       DEC    $A,X
BE9E: 27 01       BEQ    $BEA1
BEA0: 39          RTS
BEA1: A6 0C       LDA    $C,X
BEA3: 85 08       BITA   #$08
BEA5: 27 05       BEQ    $BEAC
BEA7: C6 1C       LDB    #$1C
BEA9: 7E B4 29    JMP    $B429
BEAC: C6 10       LDB    #$10
BEAE: 7E B4 29    JMP    $B429
BEB1: 86 02       LDA    #$02
BEB3: A7 08       STA    $8,X
BEB5: 7E 8D C8    JMP    $8DC8
BEB8: 6A 0A       DEC    $A,X
BEBA: 27 01       BEQ    $BEBD
BEBC: 39          RTS
BEBD: CE BE C5    LDU    #$BEC5
BEC0: A6 09       LDA    $9,X
BEC2: 48          ASLA
BEC3: 6E D6       JMP    [A,U]
BEC5: BE C9 BE    LDX    $C9BE
BEC8: CF CE DB    XSTU   #$CEDB
BECB: 0C 7E       INC    $7E
BECD: 8D E8       BSR    $BEB7
BECF: A6 0D       LDA    $D,X
BED1: 85 01       BITA   #$01
BED3: 27 0E       BEQ    $BEE3
BED5: 6A 08       DEC    $8,X
BED7: 27 0A       BEQ    $BEE3
BED9: 86 FF       LDA    #$FF
BEDB: A7 09       STA    $9,X
BEDD: CE DB 0C    LDU    #$DB0C
BEE0: 7E 8D E8    JMP    $8DE8
BEE3: C6 14       LDB    #$14
BEE5: 7E B4 29    JMP    $B429
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
BF05: 7E B4 29    JMP    $B429
BF08: C6 88       LDB    #$88
BF0A: 7E B4 29    JMP    $B429
BF0D: C6 70       LDB    #$70
BF0F: 7E B4 29    JMP    $B429
BF12: C6 04       LDB    #$04
BF14: 7E B4 29    JMP    $B429
BF17: F6 00 24    LDB    >$0024
BF1A: 7E B4 29    JMP    $B429
BF1D: A6 07       LDA    $7,X
BF1F: 84 02       ANDA   #$02
BF21: 26 0A       BNE    $BF2D
BF23: CC 00 10    LDD    #$0010
BF26: ED 16       STD    -$A,X
BF28: ED 18       STD    -$8,X
BF2A: 7E 8D C8    JMP    $8DC8
BF2D: CC 00 10    LDD    #$0010
BF30: ED 16       STD    -$A,X
BF32: CC FF F0    LDD    #$FFF0
BF35: ED 16       STD    -$A,X
BF37: 7E 8D C8    JMP    $8DC8
BF3A: 6A 0A       DEC    $A,X
BF3C: 27 01       BEQ    $BF3F
BF3E: 39          RTS
BF3F: 6D 16       TST    -$A,X
BF41: 2B 08       BMI    $BF4B
BF43: CE BF 53    LDU    #$BF53
BF46: A6 09       LDA    $9,X
BF48: 48          ASLA
BF49: 6E D6       JMP    [A,U]
BF4B: CE BF 5F    LDU    #$BF5F
BF4E: A6 09       LDA    $9,X
BF50: 48          ASLA
BF51: 6E D6       JMP    [A,U]
BF53: BF 8A BF    STX    $8ABF
BF56: 8A BF       ORA    #$BF
BF58: 6B BF 8A BF XDEC   [$8ABF]
BF5C: 8A BF       ORA    #$BF
BF5E: C7 BF       XSTB   #$BF
BF60: 8A BF       ORA    #$BF
BF62: 8A BF       ORA    #$BF
BF64: 90 BF       SUBA   $BF
BF66: 8A BF       ORA    #$BF
BF68: 8A BF       ORA    #$BF
BF6A: F0 EC 1A    SUBB   $EC1A
BF6D: C3 00 C0    ADDD   #$00C0
BF70: 10 83 14 00 CMPD   #$1400
BF74: 2C 3F       BGE    $BFB5
BF76: ED 1A       STD    -$6,X
BF78: EC 1C       LDD    -$4,X
BF7A: C3 00 80    ADDD   #$0080
BF7D: 10 83 10 00 CMPD   #$1000
BF81: 2C 32       BGE    $BFB5
BF83: ED 1C       STD    -$4,X
BF85: BD 9C C1    JSR    $9CC1
BF88: 27 38       BEQ    $BFC2
BF8A: CE DC 00    LDU    #$DC00
BF8D: 7E 8D E8    JMP    $8DE8
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
BFAA: BD 9C D2    JSR    $9CD2
BFAD: 27 13       BEQ    $BFC2
BFAF: CE DC 00    LDU    #$DC00
BFB2: 7E 8D E8    JMP    $8DE8
BFB5: C6 FF       LDB    #$FF
BFB7: E7 84       STB    ,X
BFB9: 0A 33       DEC    $33
BFBB: 0A 39       DEC    $39
BFBD: 0A 31       DEC    $31
BFBF: 0A 37       DEC    $37
BFC1: 39          RTS
BFC2: C6 04       LDB    #$04
BFC4: 7E B4 29    JMP    $B429
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
BFE5: BD 9C C1    JSR    $9CC1
BFE8: 27 D8       BEQ    $BFC2
BFEA: CE DC 00    LDU    #$DC00
BFED: 7E 8D E8    JMP    $8DE8
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
C00E: BD 9C D2    JSR    $9CD2
C011: 27 AF       BEQ    $BFC2
C013: CE DC 00    LDU    #$DC00
C016: 7E 8D E8    JMP    $8DE8
C019: A6 07       LDA    $7,X
C01B: 84 02       ANDA   #$02
C01D: 26 0D       BNE    $C02C
C01F: CC 00 10    LDD    #$0010
C022: ED 16       STD    -$A,X
C024: CC FF F0    LDD    #$FFF0
C027: ED 18       STD    -$8,X
C029: 7E 8D C8    JMP    $8DC8
C02C: CC FF F0    LDD    #$FFF0
C02F: ED 18       STD    -$8,X
C031: ED 16       STD    -$A,X
C033: 7E 8D C8    JMP    $8DC8
C036: 6A 0A       DEC    $A,X
C038: 27 01       BEQ    $C03B
C03A: 39          RTS
C03B: 6D 16       TST    -$A,X
C03D: 2B 08       BMI    $C047
C03F: CE C0 4F    LDU    #$C04F
C042: A6 09       LDA    $9,X
C044: 48          ASLA
C045: 6E D6       JMP    [A,U]
C047: CE C0 5B    LDU    #$C05B
C04A: A6 09       LDA    $9,X
C04C: 48          ASLA
C04D: 6E D6       JMP    [A,U]
C04F: C0 67       SUBB   #$67
C051: C0 B0       SUBB   #$B0
C053: C0 B0       SUBB   #$B0
C055: C0 67       SUBB   #$67
C057: C0 B0       SUBB   #$B0
C059: C0 C8       SUBB   #$C8
C05B: C0 91       SUBB   #$91
C05D: C0 B0       SUBB   #$B0
C05F: C0 B0       SUBB   #$B0
C061: C0 91       SUBB   #$91
C063: C0 B0       SUBB   #$B0
C065: C0 C8       SUBB   #$C8
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
C081: BD 9D 90    JSR    $9D90
C084: 27 06       BEQ    $C08C
C086: CE DC 18    LDU    #$DC18
C089: 7E 8D E8    JMP    $8DE8
C08C: C6 05       LDB    #$05
C08E: 7E B4 29    JMP    $B429
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
C0AB: BD 9D A1    JSR    $9DA1
C0AE: 27 06       BEQ    $C0B6
C0B0: CE DC 18    LDU    #$DC18
C0B3: 7E 8D E8    JMP    $8DE8
C0B6: C6 06       LDB    #$06
C0B8: 7E B4 29    JMP    $B429
C0BB: C6 FF       LDB    #$FF
C0BD: E7 84       STB    ,X
C0BF: 0A 33       DEC    $33
C0C1: 0A 39       DEC    $39
C0C3: 0A 31       DEC    $31
C0C5: 0A 37       DEC    $37
C0C7: 39          RTS
C0C8: 86 FF       LDA    #$FF
C0CA: A7 09       STA    $9,X
C0CC: CE DC 18    LDU    #$DC18
C0CF: 7E 8D E8    JMP    $8DE8
C0D2: 7E 8D C8    JMP    $8DC8
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
C0F1: B3 04 0A    SUBD   $040A
C0F4: 2A 05       BPL    $C0FB
C0F6: 53          COMB
C0F7: 43          COMA
C0F8: C3 00 01    ADDD   #$0001
C0FB: 10 83 06 00 CMPD   #$0600
C0FF: 24 03       BCC    $C104
C101: 7E 8D C8    JMP    $8DC8
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
C117: CE C2 5B    LDU    #$C25B
C11A: A6 09       LDA    $9,X
C11C: 48          ASLA
C11D: 6E D6       JMP    [A,U]
C11F: EE 10       LDU    -$10,X
C121: A6 41       LDA    $1,U
C123: 8A 01       ORA    #$01
C125: A7 41       STA    $1,U
C127: 6A 0A       DEC    $A,X
C129: 27 01       BEQ    $C12C
C12B: 39          RTS
C12C: CE DC BC    LDU    #$DCBC
C12F: 7E 8D E8    JMP    $8DE8
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
C14C: CE DC BC    LDU    #$DCBC
C14F: 7E 8D E8    JMP    $8DE8
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
C18A: CE C2 69    LDU    #$C269
C18D: A6 09       LDA    $9,X
C18F: 48          ASLA
C190: 6E D6       JMP    [A,U]
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
C1B7: CE DC E4    LDU    #$DCE4
C1BA: 7E 8D E8    JMP    $8DE8
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
C1D1: CE DC E4    LDU    #$DCE4
C1D4: 7E 8D E8    JMP    $8DE8
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
C207: CE DC E4    LDU    #$DCE4
C20A: 7E 8D E8    JMP    $8DE8
C20D: 86 5E       LDA    #$5E
C20F: A7 01       STA    $1,X
C211: A7 07       STA    $7,X
C213: CE DC E4    LDU    #$DCE4
C216: 7E 8D E8    JMP    $8DE8
C219: 85 08       BITA   #$08
C21B: 27 05       BEQ    $C222
C21D: C6 08       LDB    #$08
C21F: 7E B4 29    JMP    $B429
C222: C6 3C       LDB    #$3C
C224: 7E B4 29    JMP    $B429
C227: 6A 0A       DEC    $A,X
C229: 27 01       BEQ    $C22C
C22B: 39          RTS
C22C: EE 10       LDU    -$10,X
C22E: A6 41       LDA    $1,U
C230: 84 FD       ANDA   #$FD
C232: A7 41       STA    $1,U
C234: 86 BF       LDA    #$BF
C236: A7 46       STA    $6,U
C238: CE DC E4    LDU    #$DCE4
C23B: 7E 8D E8    JMP    $8DE8
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
C253: 7E B4 29    JMP    $B429
C256: C6 04       LDB    #$04
C258: 7E B4 29    JMP    $B429
C25B: C1 1F       CMPB   #$1F
C25D: C1 1F       CMPB   #$1F
C25F: C1 32       CMPB   #$32
C261: C1 32       CMPB   #$32
C263: C1 32       CMPB   #$32
C265: C1 52       CMPB   #$52
C267: C1 71       CMPB   #$71
C269: C1 92       CMPB   #$92
C26B: C1 BD       CMPB   #$BD
C26D: C1 BD       CMPB   #$BD
C26F: C1 D7       CMPB   #$D7
C271: C2 27       SBCB   #$27
C273: C2 3E       SBCB   #$3E
C275: 7E 8D C8    JMP    $8DC8
C278: 7E 8D C8    JMP    $8DC8
C27B: 6A 0A       DEC    $A,X
C27D: 27 01       BEQ    $C280
C27F: 39          RTS
C280: CE C2 FA    LDU    #$C2FA
C283: A6 09       LDA    $9,X
C285: 48          ASLA
C286: 6E D6       JMP    [A,U]
C288: 86 40       LDA    #$40
C28A: A7 05       STA    $5,X
C28C: EC 1C       LDD    -$4,X
C28E: C3 00 20    ADDD   #$0020
C291: ED 1C       STD    -$4,X
C293: CE DC BC    LDU    #$DCBC
C296: 7E 8D E8    JMP    $8DE8
C299: C6 04       LDB    #$04
C29B: 7E B4 29    JMP    $B429
C29E: 6A 0A       DEC    $A,X
C2A0: 27 01       BEQ    $C2A3
C2A2: 39          RTS
C2A3: CE C3 0A    LDU    #$C30A
C2A6: A6 09       LDA    $9,X
C2A8: 48          ASLA
C2A9: 6E D6       JMP    [A,U]
C2AB: 86 80       LDA    #$80
C2AD: A7 05       STA    $5,X
C2AF: EC 1C       LDD    -$4,X
C2B1: 83 00 20    SUBD   #$0020
C2B4: ED 1C       STD    -$4,X
C2B6: CE DC DC    LDU    #$DCDC
C2B9: 7E 8D E8    JMP    $8DE8
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
C2D3: CE DC DC    LDU    #$DCDC
C2D6: 7E 8D E8    JMP    $8DE8
C2D9: 86 AE       LDA    #$AE
C2DB: A7 01       STA    $1,X
C2DD: A7 07       STA    $7,X
C2DF: CE DC DC    LDU    #$DCDC
C2E2: 7E 8D E8    JMP    $8DE8
C2E5: C6 08       LDB    #$08
C2E7: 7E B4 29    JMP    $B429
C2EA: A6 0D       LDA    $D,X
C2EC: 84 01       ANDA   #$01
C2EE: 27 05       BEQ    $C2F5
C2F0: C6 04       LDB    #$04
C2F2: 7E B4 29    JMP    $B429
C2F5: C6 38       LDB    #$38
C2F7: 7E B4 29    JMP    $B429
C2FA: C2 93       SBCB   #$93
C2FC: C2 93       SBCB   #$93
C2FE: C2 8C       SBCB   #$8C
C300: C2 8C       SBCB   #$8C
C302: C2 8C       SBCB   #$8C
C304: C2 88       SBCB   #$88
C306: C2 93       SBCB   #$93
C308: C2 99       SBCB   #$99
C30A: C2 B6       SBCB   #$B6
C30C: C2 B6       SBCB   #$B6
C30E: C2 AB       SBCB   #$AB
C310: C2 AF       SBCB   #$AF
C312: C2 AF       SBCB   #$AF
C314: C2 BC       SBCB   #$BC
C316: C2 B6       SBCB   #$B6
C318: C2 EA       SBCB   #$EA
C31A: 8D 3E       BSR    $C35A
C31C: 6D 06       TST    $6,X
C31E: 26 12       BNE    $C332
C320: CE C3 54    LDU    #$C354
C323: A6 84       LDA    ,X
C325: 84 FC       ANDA   #$FC
C327: 80 04       SUBA   #$04
C329: 44          LSRA
C32A: EC C6       LDD    A,U
C32C: CE 14 5E    LDU    #$145E
C32F: BD 88 B2    JSR    $88B2
C332: 6D 06       TST    $6,X
C334: 26 09       BNE    $C33F
C336: CE C3 48    LDU    #$C348
C339: 96 0F       LDA    $0F
C33B: 84 06       ANDA   #$06
C33D: 6E D6       JMP    [A,U]
C33F: CE C3 50    LDU    #$C350
C342: 96 0F       LDA    $0F
C344: 84 02       ANDA   #$02
C346: 6E D6       JMP    [A,U]
C348: C3 95 C4    ADDD   #$95C4
C34B: 1F C3       TFR    inv,U
C34D: DA C4       ORB    $C4
C34F: 1F C3       TFR    inv,U
C351: 95 C3       BITA   $C3
C353: DA 00       ORB    $00
C355: 30 00       LEAX   $0,X
C357: 40          NEGA
C358: 00 70       NEG    $70
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
C395: 6D 06       TST    $6,X
C397: 26 0F       BNE    $C3A8
C399: 10 8E 13 A0 LDY    #$13A0
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
C3C7: 7E 8D C8    JMP    $8DC8
C3CA: CC FF D0    LDD    #$FFD0
C3CD: ED 16       STD    -$A,X
C3CF: E6 01       LDB    $1,X
C3D1: C4 03       ANDB   #$03
C3D3: CB 60       ADDB   #$60
C3D5: E7 07       STB    $7,X
C3D7: 7E 8D C8    JMP    $8DC8
C3DA: 6D 06       TST    $6,X
C3DC: 26 0F       BNE    $C3ED
C3DE: 10 8E 13 A0 LDY    #$13A0
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
C40C: 7E 8D C8    JMP    $8DC8
C40F: CC FF D0    LDD    #$FFD0
C412: ED 16       STD    -$A,X
C414: E6 01       LDB    $1,X
C416: C4 03       ANDB   #$03
C418: CB 64       ADDB   #$64
C41A: E7 07       STB    $7,X
C41C: 7E 8D C8    JMP    $8DC8
C41F: 10 8E 13 A0 LDY    #$13A0
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
C436: 7E 8D C8    JMP    $8DC8
C439: CE C4 41    LDU    #$C441
C43C: A6 09       LDA    $9,X
C43E: 48          ASLA
C43F: 6E D6       JMP    [A,U]
C441: C4 57       ANDB   #$57
C443: C4 7F       ANDB   #$7F
C445: C4 AE       ANDB   #$AE
C447: C4 AE       ANDB   #$AE
C449: C4 AE       ANDB   #$AE
C44B: C4 B9       ANDB   #$B9
C44D: C4 AE       ANDB   #$AE
C44F: C4 AE       ANDB   #$AE
C451: C4 AE       ANDB   #$AE
C453: C4 AE       ANDB   #$AE
C455: C4 D3       ANDB   #$D3
C457: EC 16       LDD    -$A,X
C459: 27 16       BEQ    $C471
C45B: BD 94 97    JSR    $9497
C45E: 2A 01       BPL    $C461
C460: 39          RTS
C461: EC 16       LDD    -$A,X
C463: 2B 07       BMI    $C46C
C465: 83 00 04    SUBD   #$0004
C468: ED 16       STD    -$A,X
C46A: 20 05       BRA    $C471
C46C: C3 00 04    ADDD   #$0004
C46F: ED 16       STD    -$A,X
C471: BD 95 6D    JSR    $956D
C474: 6A 0A       DEC    $A,X
C476: 27 01       BEQ    $C479
C478: 39          RTS
C479: CE DC 30    LDU    #$DC30
C47C: 7E 8D E8    JMP    $8DE8
C47F: EC 16       LDD    -$A,X
C481: 27 16       BEQ    $C499
C483: BD 94 97    JSR    $9497
C486: 2A 01       BPL    $C489
C488: 39          RTS
C489: EC 16       LDD    -$A,X
C48B: 2B 07       BMI    $C494
C48D: 83 00 04    SUBD   #$0004
C490: ED 16       STD    -$A,X
C492: 20 05       BRA    $C499
C494: C3 00 04    ADDD   #$0004
C497: ED 16       STD    -$A,X
C499: BD 95 6D    JSR    $956D
C49C: 26 01       BNE    $C49F
C49E: 39          RTS
C49F: 6D 06       TST    $6,X
C4A1: 26 06       BNE    $C4A9
C4A3: CE DC 30    LDU    #$DC30
C4A6: 7E 8D E8    JMP    $8DE8
C4A9: C6 10       LDB    #$10
C4AB: 7E B4 29    JMP    $B429
C4AE: 6A 0A       DEC    $A,X
C4B0: 27 01       BEQ    $C4B3
C4B2: 39          RTS
C4B3: CE DC 30    LDU    #$DC30
C4B6: 7E 8D E8    JMP    $8DE8
C4B9: 6A 0A       DEC    $A,X
C4BB: 27 01       BEQ    $C4BE
C4BD: 39          RTS
C4BE: 10 8E 13 60 LDY    #$1360
C4C2: 96 E4       LDA    $E4
C4C4: C6 03       LDB    #$03
C4C6: E7 A6       STB    A,Y
C4C8: 4C          INCA
C4C9: 84 1F       ANDA   #$1F
C4CB: 97 E4       STA    $E4
C4CD: CE DC 30    LDU    #$DC30
C4D0: 7E 8D E8    JMP    $8DE8
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
C4E5: CE C4 ED    LDU    #$C4ED
C4E8: A6 09       LDA    $9,X
C4EA: 48          ASLA
C4EB: 6E D6       JMP    [A,U]
C4ED: C5 03       BITB   #$03
C4EF: C5 17       BITB   #$17
C4F1: C5 32       BITB   #$32
C4F3: C5 32       BITB   #$32
C4F5: C5 32       BITB   #$32
C4F7: C5 3D       BITB   #$3D
C4F9: C5 32       BITB   #$32
C4FB: C5 32       BITB   #$32
C4FD: C5 32       BITB   #$32
C4FF: C5 32       BITB   #$32
C501: C5 57       BITB   #$57
C503: BD 94 97    JSR    $9497
C506: 2A 01       BPL    $C509
C508: 39          RTS
C509: BD 95 6D    JSR    $956D
C50C: 6A 0A       DEC    $A,X
C50E: 27 01       BEQ    $C511
C510: 39          RTS
C511: CE DC 5C    LDU    #$DC5C
C514: 7E 8D E8    JMP    $8DE8
C517: BD 94 97    JSR    $9497
C51A: 2A 01       BPL    $C51D
C51C: 39          RTS
C51D: BD 95 6D    JSR    $956D
C520: 26 01       BNE    $C523
C522: 39          RTS
C523: 6D 06       TST    $6,X
C525: 26 06       BNE    $C52D
C527: CE DC 5C    LDU    #$DC5C
C52A: 7E 8D E8    JMP    $8DE8
C52D: C6 10       LDB    #$10
C52F: 7E B4 29    JMP    $B429
C532: 6A 0A       DEC    $A,X
C534: 27 01       BEQ    $C537
C536: 39          RTS
C537: CE DC 5C    LDU    #$DC5C
C53A: 7E 8D E8    JMP    $8DE8
C53D: 6A 0A       DEC    $A,X
C53F: 27 01       BEQ    $C542
C541: 39          RTS
C542: 10 8E 13 60 LDY    #$1360
C546: 96 E4       LDA    $E4
C548: C6 03       LDB    #$03
C54A: E7 A6       STB    A,Y
C54C: 4C          INCA
C54D: 84 1F       ANDA   #$1F
C54F: 97 E4       STA    $E4
C551: CE DC 5C    LDU    #$DC5C
C554: 7E 8D E8    JMP    $8DE8
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
C569: CE C5 71    LDU    #$C571
C56C: A6 09       LDA    $9,X
C56E: 48          ASLA
C56F: 6E D6       JMP    [A,U]
C571: C5 8B       BITB   #$8B
C573: C5 8B       BITB   #$8B
C575: C5 96       BITB   #$96
C577: C5 A7       BITB   #$A7
C579: C5 A7       BITB   #$A7
C57B: C5 B2       BITB   #$B2
C57D: C5 A7       BITB   #$A7
C57F: C5 A7       BITB   #$A7
C581: C5 A7       BITB   #$A7
C583: C5 A7       BITB   #$A7
C585: C5 A7       BITB   #$A7
C587: C5 A7       BITB   #$A7
C589: C5 D5       BITB   #$D5
C58B: 6A 0A       DEC    $A,X
C58D: 27 01       BEQ    $C590
C58F: 39          RTS
C590: CE DC 88    LDU    #$DC88
C593: 7E 8D E8    JMP    $8DE8
C596: BD 95 6D    JSR    $956D
C599: 26 01       BNE    $C59C
C59B: 39          RTS
C59C: 6A 0A       DEC    $A,X
C59E: 27 01       BEQ    $C5A1
C5A0: 39          RTS
C5A1: CE DC 88    LDU    #$DC88
C5A4: 7E 8D E8    JMP    $8DE8
C5A7: 6A 0A       DEC    $A,X
C5A9: 27 01       BEQ    $C5AC
C5AB: 39          RTS
C5AC: CE DC 88    LDU    #$DC88
C5AF: 7E 8D E8    JMP    $8DE8
C5B2: 6A 0A       DEC    $A,X
C5B4: 27 01       BEQ    $C5B7
C5B6: 39          RTS
C5B7: 6D 06       TST    $6,X
C5B9: 26 15       BNE    $C5D0
C5BB: 10 8E 13 60 LDY    #$1360
C5BF: 96 E4       LDA    $E4
C5C1: C6 03       LDB    #$03
C5C3: E7 A6       STB    A,Y
C5C5: 4C          INCA
C5C6: 84 1F       ANDA   #$1F
C5C8: 97 E4       STA    $E4
C5CA: CE DC 88    LDU    #$DC88
C5CD: 7E 8D E8    JMP    $8DE8
C5D0: C6 10       LDB    #$10
C5D2: 7E B4 29    JMP    $B429
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
C5E7: 7E 8D C8    JMP    $8DC8
C5EA: 6A 0A       DEC    $A,X
C5EC: 27 01       BEQ    $C5EF
C5EE: 39          RTS
C5EF: A6 09       LDA    $9,X
C5F1: 81 04       CMPA   #$04
C5F3: 27 06       BEQ    $C5FB
C5F5: CE DE 7C    LDU    #$DE7C
C5F8: 7E 8D E8    JMP    $8DE8
C5FB: C6 94       LDB    #$94
C5FD: 7E B4 29    JMP    $B429
C600: BD C3 5A    JSR    $C35A
C603: CE C6 0C    LDU    #$C60C
C606: 96 0F       LDA    $0F
C608: 84 02       ANDA   #$02
C60A: 6E D6       JMP    [A,U]
C60C: C6 10       LDB    #$10
C60E: C6 32       LDB    #$32
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
C627: 7E 8D C8    JMP    $8DC8
C62A: CC FF D0    LDD    #$FFD0
C62D: ED 16       STD    -$A,X
C62F: 7E 8D C8    JMP    $8DC8
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
C649: 7E 8D C8    JMP    $8DC8
C64C: CC FF D0    LDD    #$FFD0
C64F: ED 16       STD    -$A,X
C651: 7E 8D C8    JMP    $8DC8
C654: CE C6 5C    LDU    #$C65C
C657: A6 09       LDA    $9,X
C659: 48          ASLA
C65A: 6E D6       JMP    [A,U]
C65C: C6 62       LDB    #$62
C65E: C6 76       LDB    #$76
C660: C6 88       LDB    #$88
C662: BD 94 97    JSR    $9497
C665: 2A 01       BPL    $C668
C667: 39          RTS
C668: BD 95 6D    JSR    $956D
C66B: 6A 0A       DEC    $A,X
C66D: 27 01       BEQ    $C670
C66F: 39          RTS
C670: CE DC 30    LDU    #$DC30
C673: 7E 8D E8    JMP    $8DE8
C676: BD 94 97    JSR    $9497
C679: 2A 01       BPL    $C67C
C67B: 39          RTS
C67C: BD 95 6D    JSR    $956D
C67F: 26 01       BNE    $C682
C681: 39          RTS
C682: CE DC 30    LDU    #$DC30
C685: 7E 8D E8    JMP    $8DE8
C688: 6A 0A       DEC    $A,X
C68A: 27 01       BEQ    $C68D
C68C: 39          RTS
C68D: C6 10       LDB    #$10
C68F: 7E B4 29    JMP    $B429
C692: CE C6 9A    LDU    #$C69A
C695: A6 09       LDA    $9,X
C697: 48          ASLA
C698: 6E D6       JMP    [A,U]
C69A: C6 A0       LDB    #$A0
C69C: C6 B4       LDB    #$B4
C69E: C6 C6       LDB    #$C6
C6A0: BD 94 97    JSR    $9497
C6A3: 2A 01       BPL    $C6A6
C6A5: 39          RTS
C6A6: BD 95 6D    JSR    $956D
C6A9: 6A 0A       DEC    $A,X
C6AB: 27 01       BEQ    $C6AE
C6AD: 39          RTS
C6AE: CE DC 5C    LDU    #$DC5C
C6B1: 7E 8D E8    JMP    $8DE8
C6B4: BD 94 97    JSR    $9497
C6B7: 2A 01       BPL    $C6BA
C6B9: 39          RTS
C6BA: BD 95 6D    JSR    $956D
C6BD: 26 01       BNE    $C6C0
C6BF: 39          RTS
C6C0: CE DC 5C    LDU    #$DC5C
C6C3: 7E 8D E8    JMP    $8DE8
C6C6: 6A 0A       DEC    $A,X
C6C8: 27 01       BEQ    $C6CB
C6CA: 39          RTS
C6CB: C6 10       LDB    #$10
C6CD: 7E B4 29    JMP    $B429
C6D0: A6 07       LDA    $7,X
C6D2: A7 01       STA    $1,X
C6D4: 39          RTS
C6D5: CE C7 3E    LDU    #$C73E
C6D8: A6 07       LDA    $7,X
C6DA: 84 FC       ANDA   #$FC
C6DC: 44          LSRA
C6DD: 6E D6       JMP    [A,U]
C6DF: 10 AE 10    LDY    -$10,X
C6E2: A6 21       LDA    $1,Y
C6E4: 84 01       ANDA   #$01
C6E6: AB 22       ADDA   $2,Y
C6E8: 26 25       BNE    $C70F
C6EA: CE 04 10    LDU    #$0410
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
C70C: 7E 8D C8    JMP    $8DC8
C70F: A6 84       LDA    ,X
C711: 8A 80       ORA    #$80
C713: A7 84       STA    ,X
C715: 0A 33       DEC    $33
C717: 0A 39       DEC    $39
C719: 39          RTS
C71A: CE 04 10    LDU    #$0410
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
C73B: 7E B4 29    JMP    $B429
C73E: BB C8 B5    ADDA   $C8B5
C741: 23 8D       BLS    $C6D0
C743: C8 8D       EORB   #$8D
C745: C8 BE       EORB   #$BE
C747: B1 8D C8    CMPA   $8DC8
C74A: B8 F2 B9    EORA   $F2B9
C74D: 5A          DECB
C74E: B6 DD B6    LDA    $DDB6
C751: DD B7       STD    $B7
C753: 18          X18
C754: B8 08 B8    EORA   $08B8
C757: 10 B7 20 8D STA    $208D
C75B: C8 8D       EORB   #$8D
C75D: C8 B5       EORB   #$B5
C75F: 23 BB       BLS    $C71C
C761: 6A 8D C8 BF DEC    $9024,PCR
C765: 1D          SEX
C766: C0 19       SUBB   #$19
C768: 8D C8       BSR    $C732
C76A: C6 DF       LDB    #$DF
C76C: C0 D5       SUBB   #$D5
C76E: C3 1A C3    ADDD   #$1AC3
C771: 1A C3       ORCC   #$C3
C773: 1A C7       ORCC   #$C7
C775: 8C BB DD    CMPX   #$BBDD
C778: B7 06 C6    STA    $06C6
C77B: 00 C7       NEG    $C7
C77D: 8C C7 8C    CMPX   #$C78C
C780: C7 8D       XSTB   #$8D
C782: C7 8D       XSTB   #$8D
C784: C7 1A       XSTB   #$1A
C786: CA FE       ORB    #$FE
C788: CB 9A       ADDB   #$9A
C78A: C5 E7       BITB   #$E7
C78C: 39          RTS
C78D: 7E 8D C8    JMP    $8DC8
C790: CE C7 98    LDU    #$C798
C793: A6 09       LDA    $9,X
C795: 48          ASLA
C796: 6E D6       JMP    [A,U]
C798: C7 AC       XSTB   #$AC
C79A: C7 AC       XSTB   #$AC
C79C: C7 AC       XSTB   #$AC
C79E: C7 C6       XSTB   #$C6
C7A0: C8 0D       EORB   #$0D
C7A2: C8 4C       EORB   #$4C
C7A4: C8 8B       EORB   #$8B
C7A6: C7 AC       XSTB   #$AC
C7A8: C7 AC       XSTB   #$AC
C7AA: C8 C7       EORB   #$C7
C7AC: 6A 0A       DEC    $A,X
C7AE: 27 01       BEQ    $C7B1
C7B0: 39          RTS
C7B1: 10 8E 13 60 LDY    #$1360
C7B5: 96 E4       LDA    $E4
C7B7: C6 05       LDB    #$05
C7B9: E7 A6       STB    A,Y
C7BB: 4C          INCA
C7BC: 84 1F       ANDA   #$1F
C7BE: 97 E4       STA    $E4
C7C0: CE DD 40    LDU    #$DD40
C7C3: 7E 8D E8    JMP    $8DE8
C7C6: 6A 0A       DEC    $A,X
C7C8: 27 01       BEQ    $C7CB
C7CA: 39          RTS
C7CB: E6 01       LDB    $1,X
C7CD: C5 02       BITB   #$02
C7CF: 26 1E       BNE    $C7EF
C7D1: 86 68       LDA    #$68
C7D3: BD D5 17    JSR    $D517
C7D6: CC 7B 5C    LDD    #$7B5C
C7D9: ED 4E       STD    $E,U
C7DB: EC 1A       LDD    -$6,X
C7DD: C3 FE 90    ADDD   #$FE90
C7E0: ED 4A       STD    $A,U
C7E2: EC 1C       LDD    -$4,X
C7E4: C3 03 30    ADDD   #$0330
C7E7: ED 4C       STD    $C,U
C7E9: CE DD 40    LDU    #$DD40
C7EC: 7E 8D E8    JMP    $8DE8
C7EF: 86 68       LDA    #$68
C7F1: BD D5 17    JSR    $D517
C7F4: CC 7B 60    LDD    #$7B60
C7F7: ED 4E       STD    $E,U
C7F9: EC 1A       LDD    -$6,X
C7FB: C3 00 80    ADDD   #$0080
C7FE: ED 4A       STD    $A,U
C800: EC 1C       LDD    -$4,X
C802: C3 03 30    ADDD   #$0330
C805: ED 4C       STD    $C,U
C807: CE DD 40    LDU    #$DD40
C80A: 7E 8D E8    JMP    $8DE8
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
C82D: CE DD 40    LDU    #$DD40
C830: 7E 8D E8    JMP    $8DE8
C833: CC 7B 68    LDD    #$7B68
C836: ED 4E       STD    $E,U
C838: EC 1A       LDD    -$6,X
C83A: C3 FF E0    ADDD   #$FFE0
C83D: ED 4A       STD    $A,U
C83F: EC 1C       LDD    -$4,X
C841: C3 03 50    ADDD   #$0350
C844: ED 4C       STD    $C,U
C846: CE DD 40    LDU    #$DD40
C849: 7E 8D E8    JMP    $8DE8
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
C86C: CE DD 40    LDU    #$DD40
C86F: 7E 8D E8    JMP    $8DE8
C872: CC 7B 70    LDD    #$7B70
C875: ED 4E       STD    $E,U
C877: EC 1A       LDD    -$6,X
C879: C3 01 00    ADDD   #$0100
C87C: ED 4A       STD    $A,U
C87E: EC 1C       LDD    -$4,X
C880: C3 03 20    ADDD   #$0320
C883: ED 4C       STD    $C,U
C885: CE DD 40    LDU    #$DD40
C888: 7E 8D E8    JMP    $8DE8
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
C8B1: CE DD 40    LDU    #$DD40
C8B4: 7E 8D E8    JMP    $8DE8
C8B7: CC 7B A0    LDD    #$7BA0
C8BA: ED 4E       STD    $E,U
C8BC: CC FF F8    LDD    #$FFF8
C8BF: ED 46       STD    $6,U
C8C1: CE DD 40    LDU    #$DD40
C8C4: 7E 8D E8    JMP    $8DE8
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
C8E8: 7E B4 29    JMP    $B429
C8EB: C6 38       LDB    #$38
C8ED: 7E B4 29    JMP    $B429
C8F0: C6 3C       LDB    #$3C
C8F2: 7E B4 29    JMP    $B429
C8F5: C6 84       LDB    #$84
C8F7: 7E B4 29    JMP    $B429
C8FA: CE C9 02    LDU    #$C902
C8FD: A6 09       LDA    $9,X
C8FF: 48          ASLA
C900: 6E D6       JMP    [A,U]
C902: C9 16       ADCB   #$16
C904: C9 16       ADCB   #$16
C906: C9 30       ADCB   #$30
C908: C9 77       ADCB   #$77
C90A: C9 B6       ADCB   #$B6
C90C: C9 F5       ADCB   #$F5
C90E: CA 34       ORB    #$34
C910: CA 73       ORB    #$73
C912: C9 16       ADCB   #$16
C914: CA A9       ORB    #$A9
C916: 6A 0A       DEC    $A,X
C918: 27 01       BEQ    $C91B
C91A: 39          RTS
C91B: 10 8E 13 60 LDY    #$1360
C91F: 96 E4       LDA    $E4
C921: C6 05       LDB    #$05
C923: E7 A6       STB    A,Y
C925: 4C          INCA
C926: 84 1F       ANDA   #$1F
C928: 97 E4       STA    $E4
C92A: CE DD 68    LDU    #$DD68
C92D: 7E 8D E8    JMP    $8DE8
C930: 6A 0A       DEC    $A,X
C932: 27 01       BEQ    $C935
C934: 39          RTS
C935: E6 01       LDB    $1,X
C937: C5 02       BITB   #$02
C939: 26 1E       BNE    $C959
C93B: 86 69       LDA    #$69
C93D: BD D5 17    JSR    $D517
C940: CC 7B 74    LDD    #$7B74
C943: ED 4E       STD    $E,U
C945: EC 1A       LDD    -$6,X
C947: C3 00 10    ADDD   #$0010
C94A: ED 4A       STD    $A,U
C94C: EC 1C       LDD    -$4,X
C94E: C3 01 60    ADDD   #$0160
C951: ED 4C       STD    $C,U
C953: CE DD 68    LDU    #$DD68
C956: 7E 8D E8    JMP    $8DE8
C959: 86 69       LDA    #$69
C95B: BD D5 17    JSR    $D517
C95E: CC 7B 78    LDD    #$7B78
C961: ED 4E       STD    $E,U
C963: EC 1A       LDD    -$6,X
C965: C3 FF 00    ADDD   #$FF00
C968: ED 4A       STD    $A,U
C96A: EC 1C       LDD    -$4,X
C96C: C3 01 60    ADDD   #$0160
C96F: ED 4C       STD    $C,U
C971: CE DD 68    LDU    #$DD68
C974: 7E 8D E8    JMP    $8DE8
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
C997: CE DD 68    LDU    #$DD68
C99A: 7E 8D E8    JMP    $8DE8
C99D: CC 7B 80    LDD    #$7B80
C9A0: ED 4E       STD    $E,U
C9A2: EC 1A       LDD    -$6,X
C9A4: C3 01 40    ADDD   #$0140
C9A7: ED 4A       STD    $A,U
C9A9: EC 1C       LDD    -$4,X
C9AB: C3 02 20    ADDD   #$0220
C9AE: ED 4C       STD    $C,U
C9B0: CE DD 68    LDU    #$DD68
C9B3: 7E 8D E8    JMP    $8DE8
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
C9D6: CE DD 68    LDU    #$DD68
C9D9: 7E 8D E8    JMP    $8DE8
C9DC: CC 7B 88    LDD    #$7B88
C9DF: ED 4E       STD    $E,U
C9E1: EC 1A       LDD    -$6,X
C9E3: C3 01 30    ADDD   #$0130
C9E6: ED 4A       STD    $A,U
C9E8: EC 1C       LDD    -$4,X
C9EA: C3 02 B0    ADDD   #$02B0
C9ED: ED 4C       STD    $C,U
C9EF: CE DD 68    LDU    #$DD68
C9F2: 7E 8D E8    JMP    $8DE8
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
CA15: CE DD 68    LDU    #$DD68
CA18: 7E 8D E8    JMP    $8DE8
CA1B: CC 7B 90    LDD    #$7B90
CA1E: ED 4E       STD    $E,U
CA20: EC 1A       LDD    -$6,X
CA22: C3 01 30    ADDD   #$0130
CA25: ED 4A       STD    $A,U
CA27: EC 1C       LDD    -$4,X
CA29: C3 03 70    ADDD   #$0370
CA2C: ED 4C       STD    $C,U
CA2E: CE DD 68    LDU    #$DD68
CA31: 7E 8D E8    JMP    $8DE8
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
CA54: CE DD 68    LDU    #$DD68
CA57: 7E 8D E8    JMP    $8DE8
CA5A: CC 7B 98    LDD    #$7B98
CA5D: ED 4E       STD    $E,U
CA5F: EC 1A       LDD    -$6,X
CA61: C3 00 10    ADDD   #$0010
CA64: ED 4A       STD    $A,U
CA66: EC 1C       LDD    -$4,X
CA68: C3 03 70    ADDD   #$0370
CA6B: ED 4C       STD    $C,U
CA6D: CE DD 68    LDU    #$DD68
CA70: 7E 8D E8    JMP    $8DE8
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
CA93: CE DD 68    LDU    #$DD68
CA96: 7E 8D E8    JMP    $8DE8
CA99: CC 7B A0    LDD    #$7BA0
CA9C: ED 4E       STD    $E,U
CA9E: CC FF D8    LDD    #$FFD8
CAA1: ED 46       STD    $6,U
CAA3: CE DD 68    LDU    #$DD68
CAA6: 7E 8D E8    JMP    $8DE8
CAA9: 6A 0A       DEC    $A,X
CAAB: 27 01       BEQ    $CAAE
CAAD: 39          RTS
CAAE: A6 0D       LDA    $D,X
CAB0: 85 01       BITA   #$01
CAB2: 27 09       BEQ    $CABD
CAB4: A6 02       LDA    $2,X
CAB6: 2A 05       BPL    $CABD
CAB8: C6 88       LDB    #$88
CABA: 7E B4 29    JMP    $B429
CABD: C6 04       LDB    #$04
CABF: 7E B4 29    JMP    $B429
CAC2: CE 04 10    LDU    #$0410
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
CAEC: 7E 8D C8    JMP    $8DC8
CAEF: A6 84       LDA    ,X
CAF1: 8A 80       ORA    #$80
CAF3: A7 84       STA    ,X
CAF5: 86 80       LDA    #$80
CAF7: A7 01       STA    $1,X
CAF9: 0A 33       DEC    $33
CAFB: 0A 39       DEC    $39
CAFD: 39          RTS
CAFE: 7E 8D C8    JMP    $8DC8
CB01: CE CB 09    LDU    #$CB09
CB04: A6 09       LDA    $9,X
CB06: 48          ASLA
CB07: 6E D6       JMP    [A,U]
CB09: CB 29       ADDB   #$29
CB0B: CB 29       ADDB   #$29
CB0D: CB 29       ADDB   #$29
CB0F: CB 29       ADDB   #$29
CB11: CB 29       ADDB   #$29
CB13: CB 29       ADDB   #$29
CB15: CB 29       ADDB   #$29
CB17: CB 29       ADDB   #$29
CB19: CB 29       ADDB   #$29
CB1B: CB 29       ADDB   #$29
CB1D: CB 29       ADDB   #$29
CB1F: CB 29       ADDB   #$29
CB21: CB 29       ADDB   #$29
CB23: CB 34       ADDB   #$34
CB25: CB 52       ADDB   #$52
CB27: CB 5E       ADDB   #$5E
CB29: 6A 0A       DEC    $A,X
CB2B: 27 01       BEQ    $CB2E
CB2D: 39          RTS
CB2E: CE DD B8    LDU    #$DDB8
CB31: 7E 8D E8    JMP    $8DE8
CB34: 6A 0A       DEC    $A,X
CB36: 27 01       BEQ    $CB39
CB38: 39          RTS
CB39: CE 13 E0    LDU    #$13E0
CB3C: CC 00 FF    LDD    #$00FF
CB3F: BD 93 02    JSR    $9302
CB42: C5 02       BITB   #$02
CB44: 27 06       BEQ    $CB4C
CB46: C4 C0       ANDB   #$C0
CB48: E7 05       STB    $5,X
CB4A: 6C 09       INC    $9,X
CB4C: CE DD B8    LDU    #$DDB8
CB4F: 7E 8D E8    JMP    $8DE8
CB52: BD 95 6D    JSR    $956D
CB55: 26 01       BNE    $CB58
CB57: 39          RTS
CB58: CE DD B8    LDU    #$DDB8
CB5B: 7E 8D E8    JMP    $8DE8
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
CB71: 7E B4 29    JMP    $B429
CB74: C6 04       LDB    #$04
CB76: 7E B4 29    JMP    $B429
CB79: 6C 14       INC    -$C,X
CB7B: 39          RTS
CB7C: 6A 0A       DEC    $A,X
CB7E: 27 01       BEQ    $CB81
CB80: 39          RTS
CB81: A6 09       LDA    $9,X
CB83: 81 0D       CMPA   #$0D
CB85: 27 06       BEQ    $CB8D
CB87: CE DD FC    LDU    #$DDFC
CB8A: 7E 8D E8    JMP    $8DE8
CB8D: C6 FF       LDB    #$FF
CB8F: E7 84       STB    ,X
CB91: 0A 31       DEC    $31
CB93: 0A 37       DEC    $37
CB95: 0A 33       DEC    $33
CB97: 0A 39       DEC    $39
CB99: 39          RTS
CB9A: 7E 8D C8    JMP    $8DC8
CB9D: 6A 0A       DEC    $A,X
CB9F: 27 01       BEQ    $CBA2
CBA1: 39          RTS
CBA2: CE CB AA    LDU    #$CBAA
CBA5: A6 09       LDA    $9,X
CBA7: 48          ASLA
CBA8: 6E D6       JMP    [A,U]
CBAA: CB B8       ADDB   #$B8
CBAC: CB B8       ADDB   #$B8
CBAE: CB B2       ADDB   #$B2
CBB0: CB BE       ADDB   #$BE
CBB2: BD 97 D0    JSR    $97D0
CBB5: 27 01       BEQ    $CBB8
CBB7: 39          RTS
CBB8: CE DE 34    LDU    #$DE34
CBBB: 7E 8D E8    JMP    $8DE8
CBBE: C6 04       LDB    #$04
CBC0: 7E B4 29    JMP    $B429
CBC3: 6A 0A       DEC    $A,X
CBC5: 27 01       BEQ    $CBC8
CBC7: 39          RTS
CBC8: A6 09       LDA    $9,X
CBCA: 81 03       CMPA   #$03
CBCC: 27 06       BEQ    $CBD4
CBCE: CE DE 34    LDU    #$DE34
CBD1: 7E 8D E8    JMP    $8DE8
CBD4: 6C 14       INC    -$C,X
CBD6: 39          RTS
CBD7: 6A 0A       DEC    $A,X
CBD9: 27 01       BEQ    $CBDC
CBDB: 39          RTS
CBDC: A6 09       LDA    $9,X
CBDE: 81 04       CMPA   #$04
CBE0: 27 06       BEQ    $CBE8
CBE2: CE DE 90    LDU    #$DE90
CBE5: 7E 8D E8    JMP    $8DE8
CBE8: 6C 14       INC    -$C,X
CBEA: 39          RTS
CBEB: 6A 0A       DEC    $A,X
CBED: 27 01       BEQ    $CBF0
CBEF: 39          RTS
CBF0: A6 09       LDA    $9,X
CBF2: 81 04       CMPA   #$04
CBF4: 27 06       BEQ    $CBFC
CBF6: CE DE A4    LDU    #$DEA4
CBF9: 7E 8D E8    JMP    $8DE8
CBFC: 6C 14       INC    -$C,X
CBFE: A6 01       LDA    $1,X
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
CC23: CE DE B8    LDU    #$DEB8
CC26: 7E 8D E8    JMP    $8DE8
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
CC42: 7E 8D E8    JMP    $8DE8
CC45: 6C 14       INC    -$C,X
CC47: 39          RTS
CC48: 6A 0A       DEC    $A,X
CC4A: 27 01       BEQ    $CC4D
CC4C: 39          RTS
CC4D: A6 09       LDA    $9,X
CC4F: 81 02       CMPA   #$02
CC51: 27 06       BEQ    $CC59
CC53: CE DE FC    LDU    #$DEFC
CC56: 7E 8D E8    JMP    $8DE8
CC59: 6C 14       INC    -$C,X
CC5B: 39          RTS
CC5C: 6A 0A       DEC    $A,X
CC5E: 27 01       BEQ    $CC61
CC60: 39          RTS
CC61: A6 09       LDA    $9,X
CC63: 81 02       CMPA   #$02
CC65: 27 06       BEQ    $CC6D
CC67: CE DE F0    LDU    #$DEF0
CC6A: 7E 8D E8    JMP    $8DE8
CC6D: 6C 14       INC    -$C,X
CC6F: 39          RTS
CC70: 6A 0A       DEC    $A,X
CC72: 27 01       BEQ    $CC75
CC74: 39          RTS
CC75: A6 09       LDA    $9,X
CC77: 26 06       BNE    $CC7F
CC79: CE DF 1C    LDU    #$DF1C
CC7C: 7E 8D E8    JMP    $8DE8
CC7F: 6C 14       INC    -$C,X
CC81: 39          RTS
CC82: 6A 0A       DEC    $A,X
CC84: 27 01       BEQ    $CC87
CC86: 39          RTS
CC87: A6 09       LDA    $9,X
CC89: 26 06       BNE    $CC91
CC8B: CE DF 24    LDU    #$DF24
CC8E: 7E 8D E8    JMP    $8DE8
CC91: 6C 14       INC    -$C,X
CC93: 39          RTS
CC94: A6 07       LDA    $7,X
CC96: 84 02       ANDA   #$02
CC98: 26 08       BNE    $CCA2
CC9A: CC 00 10    LDD    #$0010
CC9D: ED 16       STD    -$A,X
CC9F: 7E 8D C8    JMP    $8DC8
CCA2: CC FF F0    LDD    #$FFF0
CCA5: ED 16       STD    -$A,X
CCA7: 7E 8D C8    JMP    $8DC8
CCAA: BD 94 97    JSR    $9497
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
CCC5: CE DF 2C    LDU    #$DF2C
CCC8: 7E 8D E8    JMP    $8DE8
CCCB: 6C 14       INC    -$C,X
CCCD: 39          RTS
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
CCE5: CE DF 84    LDU    #$DF84
CCE8: 7E 8D E8    JMP    $8DE8
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
CD05: 7E B4 29    JMP    $B429
CD08: 6C 14       INC    -$C,X
CD0A: 39          RTS
CD0B: A6 07       LDA    $7,X
CD0D: 84 02       ANDA   #$02
CD0F: 26 08       BNE    $CD19
CD11: CC 00 30    LDD    #$0030
CD14: ED 16       STD    -$A,X
CD16: 7E 8D C8    JMP    $8DC8
CD19: CC FF D0    LDD    #$FFD0
CD1C: ED 16       STD    -$A,X
CD1E: 7E 8D C8    JMP    $8DC8
CD21: 6D 0C       TST    $C,X
CD23: 27 07       BEQ    $CD2C
CD25: 86 24       LDA    #$24
CD27: A7 04       STA    $4,X
CD29: 6F 0C       CLR    $C,X
CD2B: 39          RTS
CD2C: 86 22       LDA    #$22
CD2E: A7 04       STA    $4,X
CD30: BD 94 97    JSR    $9497
CD33: 2A 01       BPL    $CD36
CD35: 39          RTS
CD36: A6 01       LDA    $1,X
CD38: 84 02       ANDA   #$02
CD3A: 26 0D       BNE    $CD49
CD3C: EC 1A       LDD    -$6,X
CD3E: 10 83 10 00 CMPD   #$1000
CD42: 2D 0D       BLT    $CD51
CD44: C6 48       LDB    #$48
CD46: 7E B4 29    JMP    $B429
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
CD6C: CE DF 9C    LDU    #$DF9C
CD6F: 7E 8D E8    JMP    $8DE8
CD72: 6C 14       INC    -$C,X
CD74: 39          RTS
CD75: 96 03       LDA    $03
CD77: 81 06       CMPA   #$06
CD79: 26 0A       BNE    $CD85
CD7B: 96 05       LDA    $05
CD7D: 81 07       CMPA   #$07
CD7F: 26 04       BNE    $CD85
CD81: 86 08       LDA    #$08
CD83: 97 E8       STA    $E8
CD85: 7E 8D C8    JMP    $8DC8
CD88: A6 0C       LDA    $C,X
CD8A: 81 FF       CMPA   #$FF
CD8C: 26 07       BNE    $CD95
CD8E: 6F 0C       CLR    $C,X
CD90: C6 44       LDB    #$44
CD92: 7E B4 29    JMP    $B429
CD95: CE CD 9D    LDU    #$CD9D
CD98: A6 09       LDA    $9,X
CD9A: 48          ASLA
CD9B: 6E D6       JMP    [A,U]
CD9D: CD          XHCF
CD9E: A5 CD B7 CD BITA   $856F,PCR
CDA2: B7 CD C2    STA    $CDC2
CDA5: EC 1A       LDD    -$6,X
CDA7: B3 04 0A    SUBD   $040A
CDAA: 10 83 0C 00 CMPD   #$0C00
CDAE: 2D 01       BLT    $CDB1
CDB0: 39          RTS
CDB1: CE DF 4C    LDU    #$DF4C
CDB4: 7E 8D E8    JMP    $8DE8
CDB7: 6A 0A       DEC    $A,X
CDB9: 27 01       BEQ    $CDBC
CDBB: 39          RTS
CDBC: CE DF 4C    LDU    #$DF4C
CDBF: 7E 8D E8    JMP    $8DE8
CDC2: EC 1A       LDD    -$6,X
CDC4: B3 04 0A    SUBD   $040A
CDC7: 10 83 06 00 CMPD   #$0600
CDCB: 2D 01       BLT    $CDCE
CDCD: 39          RTS
CDCE: C6 44       LDB    #$44
CDD0: 7E B4 29    JMP    $B429
CDD3: 6A 0A       DEC    $A,X
CDD5: 27 01       BEQ    $CDD8
CDD7: 39          RTS
CDD8: A6 09       LDA    $9,X
CDDA: 81 03       CMPA   #$03
CDDC: 27 06       BEQ    $CDE4
CDDE: CE DF 4C    LDU    #$DF4C
CDE1: 7E 8D E8    JMP    $8DE8
CDE4: 6C 14       INC    -$C,X
CDE6: 39          RTS
CDE7: 6A 0A       DEC    $A,X
CDE9: 27 01       BEQ    $CDEC
CDEB: 39          RTS
CDEC: A6 09       LDA    $9,X
CDEE: 81 07       CMPA   #$07
CDF0: 27 06       BEQ    $CDF8
CDF2: CE DF B4    LDU    #$DFB4
CDF5: 7E 8D E8    JMP    $8DE8
CDF8: 6C 14       INC    -$C,X
CDFA: 39          RTS
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
CE12: CE DF D4    LDU    #$DFD4
CE15: 7E 8D E8    JMP    $8DE8
CE18: A6 84       LDA    ,X
CE1A: 84 03       ANDA   #$03
CE1C: 26 05       BNE    $CE23
CE1E: C6 40       LDB    #$40
CE20: 7E B4 29    JMP    $B429
CE23: 6C 14       INC    -$C,X
CE25: 39          RTS
CE26: 6A 0A       DEC    $A,X
CE28: 27 01       BEQ    $CE2B
CE2A: 39          RTS
CE2B: A6 09       LDA    $9,X
CE2D: 81 03       CMPA   #$03
CE2F: 27 06       BEQ    $CE37
CE31: CE DF 74    LDU    #$DF74
CE34: 7E 8D E8    JMP    $8DE8
CE37: 6C 14       INC    -$C,X
CE39: 39          RTS
CE3A: 6A 0A       DEC    $A,X
CE3C: 27 01       BEQ    $CE3F
CE3E: 39          RTS
CE3F: A6 09       LDA    $9,X
CE41: 81 05       CMPA   #$05
CE43: 27 06       BEQ    $CE4B
CE45: CE DF 5C    LDU    #$DF5C
CE48: 7E 8D E8    JMP    $8DE8
CE4B: A6 84       LDA    ,X
CE4D: 84 03       ANDA   #$03
CE4F: 26 05       BNE    $CE56
CE51: C6 40       LDB    #$40
CE53: 7E B4 29    JMP    $B429
CE56: 6C 14       INC    -$C,X
CE58: 39          RTS
CE59: 6D 06       TST    $6,X
CE5B: 27 1A       BEQ    $CE77
CE5D: 10 8E 13 60 LDY    #$1360
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
CE7B: 7E 8D C8    JMP    $8DC8
CE7E: 6A 0A       DEC    $A,X
CE80: 27 01       BEQ    $CE83
CE82: 39          RTS
CE83: A6 09       LDA    $9,X
CE85: 81 06       CMPA   #$06
CE87: 27 06       BEQ    $CE8F
CE89: CE DF E8    LDU    #$DFE8
CE8C: 7E 8D E8    JMP    $8DE8
CE8F: 86 FF       LDA    #$FF
CE91: A7 84       STA    ,X
CE93: 0A 31       DEC    $31
CE95: 0A 37       DEC    $37
CE97: 0A 33       DEC    $33
CE99: 0A 39       DEC    $39
CE9B: 0C 1F       INC    $1F
CE9D: 39          RTS
CE9E: E6 01       LDB    $1,X
CEA0: E7 07       STB    $7,X
CEA2: 39          RTS
CEA3: 96 51       LDA    $51
CEA5: 26 03       BNE    $CEAA
CEA7: 97 53       STA    $53
CEA9: 39          RTS
CEAA: 8E 10 00    LDX    #$1000
CEAD: 97 55       STA    $55
CEAF: 0F 53       CLR    $53
CEB1: A6 84       LDA    ,X
CEB3: 81 FF       CMPA   #$FF
CEB5: 27 19       BEQ    $CED0
CEB7: 84 7F       ANDA   #$7F
CEB9: 81 48       CMPA   #$48
CEBB: 24 13       BCC    $CED0
CEBD: 8D 2B       BSR    $CEEA
CEBF: 2B 0A       BMI    $CECB
CEC1: CE CE DA    LDU    #$CEDA
CEC4: A6 84       LDA    ,X
CEC6: 80 40       SUBA   #$40
CEC8: 48          ASLA
CEC9: AD D6       JSR    [A,U]
CECB: 0A 55       DEC    $55
CECD: 26 01       BNE    $CED0
CECF: 39          RTS
CED0: 30 88 10    LEAX   $10,X
CED3: 8C 13 00    CMPX   #$1300
CED6: 25 D9       BCS    $CEB1
CED8: 20 FE       BRA    $CED8
CEDA: CF 21 CF    XSTU   #$21CF
CEDD: 21 CF       BRN    $CEAE
CEDF: 21 CF       BRN    $CEB0
CEE1: 20 CF       BRA    $CEB2
CEE3: 21 CF       BRN    $CEB4
CEE5: 21 CF       BRN    $CEB6
CEE7: 21 CF       BRN    $CEB8
CEE9: 21 DC       BRN    $CEC7
CEEB: 88 E3       EORA   #$E3
CEED: 0A ED       DEC    $ED
CEEF: 0A DC       DEC    $DC
CEF1: 8A E3       ORA    #$E3
CEF3: 0C ED       INC    $ED
CEF5: 0C 10       INC    $10
CEF7: 83 03 00    SUBD   #$0300
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
CF20: 39          RTS
CF21: CE CF 30    LDU    #$CF30
CF24: A6 01       LDA    $1,X
CF26: 84 01       ANDA   #$01
CF28: 48          ASLA
CF29: EE C6       LDU    A,U
CF2B: A6 02       LDA    $2,X
CF2D: 48          ASLA
CF2E: 6E D6       JMP    [A,U]
CF30: CF 34 CF    XSTU   #$34CF
CF33: 3E          XRES
CF34: D0 83       SUBB   $83
CF36: D0 44       SUBB   $44
CF38: D0 2B       SUBB   $2B
CF3A: D0 12       SUBB   $12
CF3C: CF F9 CF    XSTU   #$F9CF
CF3F: 48          ASLA
CF40: CF 90 CF    XSTU   #$90CF
CF43: B5 CF DA    BITA   $CFDA
CF46: CF F2 CE    XSTU   #$F2CE
CF49: CF 8C A6    XSTU   #$8CA6
CF4C: 84 84       ANDA   #$84
CF4E: 03 E6       COM    $E6
CF50: C6 10       LDB    #$10
CF52: 8E 13 A0    LDX    #$13A0
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
CF80: 76 67 77    ROR    $6777
CF83: 0C 77       INC    $77
CF85: B1 76 88    CMPA   $7688
CF88: 77 2D 77    ASR    $2D77
CF8B: D2 03       SBCB   $03
CF8D: 46          RORA
CF8E: 44          LSRA
CF8F: 00 A6       NEG    $A6
CF91: 01 84       NEG    $84
CF93: 3E          XRES
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
CFAF: 76 72 77    ROR    $7277
CFB2: 17 77 BC    LBSR   $4771
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
CFC7: CE CF D4    LDU    #$CFD4
CFCA: A6 84       LDA    ,X
CFCC: 80 40       SUBA   #$40
CFCE: 48          ASLA
CFCF: EC C6       LDD    A,U
CFD1: ED 0E       STD    $E,X
CFD3: 39          RTS
CFD4: 76 7D 77    ROR    $7D77
CFD7: 22 77       BHI    $D050
CFD9: C7 A6       XSTB   #$A6
CFDB: 01 84       NEG    $84
CFDD: 3E          XRES
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
CFF2: A6 01       LDA    $1,X
CFF4: 84 3E       ANDA   #$3E
CFF6: A7 01       STA    $1,X
CFF8: 39          RTS
CFF9: A6 03       LDA    $3,X
CFFB: 4C          INCA
CFFC: 84 03       ANDA   #$03
CFFE: A7 03       STA    $3,X
D000: 27 01       BEQ    $D003
D002: 39          RTS
D003: 6A 02       DEC    $2,X
D005: CE CF D4    LDU    #$CFD4
D008: A6 84       LDA    ,X
D00A: 80 40       SUBA   #$40
D00C: 48          ASLA
D00D: EC C6       LDD    A,U
D00F: ED 0E       STD    $E,X
D011: 39          RTS
D012: A6 03       LDA    $3,X
D014: 4C          INCA
D015: 84 03       ANDA   #$03
D017: A7 03       STA    $3,X
D019: 27 01       BEQ    $D01C
D01B: 39          RTS
D01C: 6A 02       DEC    $2,X
D01E: CE CF AF    LDU    #$CFAF
D021: A6 84       LDA    ,X
D023: 80 40       SUBA   #$40
D025: 48          ASLA
D026: EC C6       LDD    A,U
D028: ED 0E       STD    $E,X
D02A: 39          RTS
D02B: A6 03       LDA    $3,X
D02D: 4C          INCA
D02E: 84 03       ANDA   #$03
D030: A7 03       STA    $3,X
D032: 27 01       BEQ    $D035
D034: 39          RTS
D035: 6A 02       DEC    $2,X
D037: CE CF 80    LDU    #$CF80
D03A: A6 84       LDA    ,X
D03C: 80 40       SUBA   #$40
D03E: 48          ASLA
D03F: EC C6       LDD    A,U
D041: ED 0E       STD    $E,X
D043: 39          RTS
D044: A6 03       LDA    $3,X
D046: 4C          INCA
D047: 84 03       ANDA   #$03
D049: A7 03       STA    $3,X
D04B: 27 01       BEQ    $D04E
D04D: 39          RTS
D04E: CE D0 7F    LDU    #$D07F
D051: A6 84       LDA    ,X
D053: 84 03       ANDA   #$03
D055: E6 C6       LDB    A,U
D057: 10 8E 13 A0 LDY    #$13A0
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
D079: 76 25 76    ROR    $2576
D07C: CA 77       ORB    #$77
D07E: 6F 03       CLR    $3,X
D080: 46          RORA
D081: 44          LSRA
D082: 00 A6       NEG    $A6
D084: 01 85       NEG    $85
D086: 3A          ABX
D087: 27 01       BEQ    $D08A
D089: 39          RTS
D08A: 6D 06       TST    $6,X
D08C: 27 03       BEQ    $D091
D08E: 6A 06       DEC    $6,X
D090: 39          RTS
D091: 10 8E 04 30 LDY    #$0430
D095: CE E9 58    LDU    #$E958
D098: 96 C2       LDA    $C2
D09A: 48          ASLA
D09B: EE C6       LDU    A,U
D09D: 96 C4       LDA    $C4
D09F: 48          ASLA
D0A0: EE C6       LDU    A,U
D0A2: 96 81       LDA    $81
D0A4: 9B 0F       ADDA   $0F
D0A6: 84 1C       ANDA   #$1C
D0A8: A7 E2       STA    ,-S
D0AA: 44          LSRA
D0AB: 44          LSRA
D0AC: AB E0       ADDA   ,S+
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
D0E8: A7 E2       STA    ,-S
D0EA: AB 22       ADDA   $2,Y
D0EC: 84 03       ANDA   #$03
D0EE: AB E0       ADDA   ,S+
D0F0: 48          ASLA
D0F1: EC C6       LDD    A,U
D0F3: A7 24       STA    $4,Y
D0F5: E7 26       STB    $6,Y
D0F7: CE E9 40    LDU    #$E940
D0FA: A6 7F       LDA    -$1,S
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
D125: A7 E2       STA    ,-S
D127: 86 01       LDA    #$01
D129: B7 D8 03    STA    $D803
D12C: 8D 2F       BSR    $D15D
D12E: EC A1       LDD    ,Y++
D130: DD 5A       STD    $5A
D132: DC 56       LDD    $56
D134: 8B 20       ADDA   #$20
D136: 1F 03       TFR    D,U
D138: D6 58       LDB    $58
D13A: 96 5B       LDA    $5B
D13C: A7 E4       STA    ,S
D13E: A6 A0       LDA    ,Y+
D140: A7 C5       STA    B,U
D142: 5C          INCB
D143: A6 A0       LDA    ,Y+
D145: A7 C5       STA    B,U
D147: 5C          INCB
D148: C4 7F       ANDB   #$7F
D14A: 6A E4       DEC    ,S
D14C: 26 F0       BNE    $D13E
D14E: DC 56       LDD    $56
D150: C3 00 80    ADDD   #$0080
D153: 84 0F       ANDA   #$0F
D155: DD 56       STD    $56
D157: 0A 5A       DEC    $5A
D159: 26 D9       BNE    $D134
D15B: 35 82       PULS   A,PC
D15D: CE 13 C0    LDU    #$13C0
D160: E6 43       LDB    $3,U
D162: C4 70       ANDB   #$70
D164: 1D          SEX
D165: E3 0C       ADDD   $C,X
D167: 58          ASLB
D168: 49          ROLA
D169: A7 E2       STA    ,-S
D16B: 86 1D       LDA    #$1D
D16D: A0 E0       SUBA   ,S+
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
D199: 8D 03       BSR    $D19E
D19B: 0C 51       INC    $51
D19D: 39          RTS
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
D1B2: 96 40       LDA    $40
D1B4: 26 03       BNE    $D1B9
D1B6: 97 41       STA    $41
D1B8: 39          RTS
D1B9: 8E 09 00    LDX    #$0900
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
D1DE: CE D2 14    LDU    #$D214
D1E1: A6 84       LDA    ,X
D1E3: 80 60       SUBA   #$60
D1E5: 48          ASLA
D1E6: AD D6       JSR    [A,U]
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
D213: 39          RTS
D214: D2 2C       SBCB   $2C
D216: D3 8E       ADDD   $8E
D218: D4 C2       ANDB   $C2
D21A: D4 47       ANDB   $47
D21C: D2 13       SBCB   $13
D21E: D2 13       SBCB   $13
D220: D2 13       SBCB   $13
D222: D2 13       SBCB   $13
D224: D5 41       BITB   $41
D226: D5 41       BITB   $41
D228: D5 76       BITB   $76
D22A: D6 2D       LDB    $2D
D22C: CE D2 36    LDU    #$D236
D22F: A6 01       LDA    $1,X
D231: 84 0C       ANDA   #$0C
D233: 44          LSRA
D234: 6E D6       JMP    [A,U]
D236: D2 3E       SBCB   $3E
D238: D2 3E       SBCB   $3E
D23A: D2 F4       SBCB   $F4
D23C: D2 F4       SBCB   $F4
D23E: A6 01       LDA    $1,X
D240: 84 02       ANDA   #$02
D242: 26 58       BNE    $D29C
D244: BD D4 10    JSR    $D410
D247: 26 0B       BNE    $D254
D249: BD D6 9F    JSR    $D69F
D24C: 26 26       BNE    $D274
D24E: CE D4 FF    LDU    #$D4FF
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
D29C: BD D4 10    JSR    $D410
D29F: 26 0B       BNE    $D2AC
D2A1: BD D6 9F    JSR    $D69F
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
D2F4: A6 01       LDA    $1,X
D2F6: 84 02       ANDA   #$02
D2F8: 26 4A       BNE    $D344
D2FA: BD D4 10    JSR    $D410
D2FD: 26 0B       BNE    $D30A
D2FF: BD D6 9F    JSR    $D69F
D302: 26 1F       BNE    $D323
D304: CE D4 FF    LDU    #$D4FF
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
D344: BD D4 10    JSR    $D410
D347: 26 0B       BNE    $D354
D349: BD D6 9F    JSR    $D69F
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
D38E: A6 01       LDA    $1,X
D390: 84 02       ANDA   #$02
D392: 26 3E       BNE    $D3D2
D394: BD D4 10    JSR    $D410
D397: 26 0B       BNE    $D3A4
D399: BD D6 74    JSR    $D674
D39C: 26 19       BNE    $D3B7
D39E: CE D5 0B    LDU    #$D50B
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
D3D2: BD D4 10    JSR    $D410
D3D5: 26 0B       BNE    $D3E2
D3D7: BD D6 74    JSR    $D674
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
D410: EC 06       LDD    $6,X
D412: 2A 15       BPL    $D429
D414: E3 0A       ADDD   $A,X
D416: 10 83 FF 00 CMPD   #$FF00
D41A: 2D 15       BLT    $D431
D41C: ED 0A       STD    $A,X
D41E: CE 13 E0    LDU    #$13E0
D421: CC 01 01    LDD    #$0101
D424: 8D 2F       BSR    $D455
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
D447: 6A 03       DEC    $3,X
D449: 27 01       BEQ    $D44C
D44B: 39          RTS
D44C: C6 FF       LDB    #$FF
D44E: E7 84       STB    ,X
D450: 0A 40       DEC    $40
D452: 0A 41       DEC    $41
D454: 39          RTS
D455: 8D 20       BSR    $D477
D457: CE 40 00    LDU    #$4000
D45A: EC CB       LDD    D,U
D45C: C4 03       ANDB   #$03
D45E: C1 03       CMPB   #$03
D460: 27 02       BEQ    $D464
D462: 5F          CLRB
D463: 39          RTS
D464: CE E6 7C    LDU    #$E67C
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
D477: ED E3       STD    ,--S
D479: E6 41       LDB    $1,U
D47B: C4 70       ANDB   #$70
D47D: 1D          SEX
D47E: E3 0A       ADDD   $A,X
D480: 58          ASLB
D481: 49          ROLA
D482: AB E0       ADDA   ,S+
D484: 8B 04       ADDA   #$04
D486: 48          ASLA
D487: AB 45       ADDA   $5,U
D489: 84 7E       ANDA   #$7E
D48B: A7 E2       STA    ,-S
D48D: E6 43       LDB    $3,U
D48F: C4 70       ANDB   #$70
D491: 1D          SEX
D492: E3 0C       ADDD   $C,X
D494: 58          ASLB
D495: 49          ROLA
D496: AB 61       ADDA   $1,S
D498: A7 E2       STA    ,-S
D49A: 86 1D       LDA    #$1D
D49C: A0 E0       SUBA   ,S+
D49E: C6 80       LDB    #$80
D4A0: 3D          MUL
D4A1: E3 46       ADDD   $6,U
D4A3: 84 0F       ANDA   #$0F
D4A5: EB E1       ADDB   ,S++
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
D4C2: CE D4 F9    LDU    #$D4F9
D4C5: A6 02       LDA    $2,X
D4C7: 6C 02       INC    $2,X
D4C9: 48          ASLA
D4CA: 6E D6       JMP    [A,U]
D4CC: A6 01       LDA    $1,X
D4CE: 84 02       ANDA   #$02
D4D0: 26 06       BNE    $D4D8
D4D2: CC 7B 44    LDD    #$7B44
D4D5: ED 0E       STD    $E,X
D4D7: 39          RTS
D4D8: CC 7B 48    LDD    #$7B48
D4DB: ED 0E       STD    $E,X
D4DD: 39          RTS
D4DE: A6 01       LDA    $1,X
D4E0: 84 02       ANDA   #$02
D4E2: 26 06       BNE    $D4EA
D4E4: CC 7B 4C    LDD    #$7B4C
D4E7: ED 0E       STD    $E,X
D4E9: 39          RTS
D4EA: CC 7B 50    LDD    #$7B50
D4ED: ED 0E       STD    $E,X
D4EF: 39          RTS
D4F0: 86 FF       LDA    #$FF
D4F2: A7 84       STA    ,X
D4F4: 0A 40       DEC    $40
D4F6: 0A 41       DEC    $41
D4F8: 39          RTS
D4F9: D4 CC       ANDB   $CC
D4FB: D4 DE       ANDB   $DE
D4FD: D4 F0       ANDB   $F0
D4FF: 7B 0C 7B    XDEC   $0C7B
D502: 14          XHCF
D503: 7B 1C 7B    XDEC   $1C7B
D506: 10 7B 18 7B XDEC   $187B
D50A: 20 7B       BRA    $D587
D50C: 24 7B       BCC    $D589
D50E: 2C 7B       BGE    $D58B
D510: 34 7B       PSHS   U,Y,X,DP,A,CC
D512: 28 7B       BVC    $D58F
D514: 30 7B       LEAX   -$5,S
D516: 38 CE       XANDCC #$CE
D518: 09 00       ROL    $00
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
D541: 6D 02       TST    $2,X
D543: 26 01       BNE    $D546
D545: 39          RTS
D546: 8D 69       BSR    $D5B1
D548: 2E 01       BGT    $D54B
D54A: 39          RTS
D54B: 10 8E 13 A0 LDY    #$13A0
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
D576: BD D7 68    JSR    $D768
D579: 26 D0       BNE    $D54B
D57B: 8D 34       BSR    $D5B1
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
D60A: CE 13 E0    LDU    #$13E0
D60D: CC 01 00    LDD    #$0100
D610: BD D4 55    JSR    $D455
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
D62D: A6 02       LDA    $2,X
D62F: 81 02       CMPA   #$02
D631: 22 03       BHI    $D636
D633: BD D8 52    JSR    $D852
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
D64F: CE D6 5A    LDU    #$D65A
D652: 48          ASLA
D653: EC C6       LDD    A,U
D655: E3 0C       ADDD   $C,X
D657: ED 0C       STD    $C,X
D659: 39          RTS
D65A: 00 00       NEG    $00
D65C: 00 00       NEG    $00
D65E: 00 00       NEG    $00
D660: 01 10       NEG    $10
D662: 00 F0       NEG    $F0
D664: 00 40       NEG    $40
D666: 00 30       NEG    $30
D668: 00 10       NEG    $10
D66A: FF F0 00    STU    $F000
D66D: 40          NEGA
D66E: 00 00       NEG    $00
D670: 00 20       NEG    $20
D672: 00 20       NEG    $20
D674: CE 04 10    LDU    #$0410
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
D68C: ED E3       STD    ,--S
D68E: 58          ASLB
D68F: 49          ROLA
D690: 58          ASLB
D691: 49          ROLA
D692: E3 E1       ADDD   ,S++
D694: 10 8E E1 40 LDY    #$E140
D698: 31 AB       LEAY   D,Y
D69A: 7E D6 D9    JMP    $D6D9
D69D: 4F          CLRA
D69E: 39          RTS
D69F: 96 38       LDA    $38
D6A1: 9B 39       ADDA   $39
D6A3: 26 01       BNE    $D6A6
D6A5: 39          RTS
D6A6: 97 3B       STA    $3B
D6A8: CE 04 30    LDU    #$0430
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
D6BC: ED E3       STD    ,--S
D6BE: 58          ASLB
D6BF: 49          ROLA
D6C0: 58          ASLB
D6C1: 49          ROLA
D6C2: E3 E1       ADDD   ,S++
D6C4: 10 8E E1 40 LDY    #$E140
D6C8: 31 AB       LEAY   D,Y
D6CA: 8D 0D       BSR    $D6D9
D6CC: 27 01       BEQ    $D6CF
D6CE: 39          RTS
D6CF: 0A 3B       DEC    $3B
D6D1: 26 01       BNE    $D6D4
D6D3: 39          RTS
D6D4: 33 C8 20    LEAU   $20,U
D6D7: 20 D2       BRA    $D6AB
D6D9: EC 5C       LDD    -$4,U
D6DB: E3 A4       ADDD   ,Y
D6DD: A3 0C       SUBD   $C,X
D6DF: B3 E6 40    SUBD   $E640
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
D768: CE 04 10    LDU    #$0410
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
D780: ED E3       STD    ,--S
D782: 58          ASLB
D783: 49          ROLA
D784: 58          ASLB
D785: 49          ROLA
D786: E3 E1       ADDD   ,S++
D788: 10 8E E1 40 LDY    #$E140
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
D852: CE 04 10    LDU    #$0410
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
D86A: ED E3       STD    ,--S
D86C: 58          ASLB
D86D: 49          ROLA
D86E: 58          ASLB
D86F: 49          ROLA
D870: E3 E1       ADDD   ,S++
D872: 10 8E E1 40 LDY    #$E140
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
D93C: 02 00       XNC    $00
D93E: 6E 70       JMP    -$10,S
D940: 04 00       LSR    $00
D942: 6E CB       JMP    D,U
D944: 04 00       LSR    $00
D946: 6E D8 04    JMP    [$04,U]
D949: 0F 6E       CLR    $6E
D94B: EB 04       ADDB   $4,X
D94D: 00 6E       NEG    $6E
D94F: D8 06       EORB   $06
D951: 00 6E       NEG    $6E
D953: 97 06       STA    $06
D955: 00 6E       NEG    $6E
D957: A4 06       ANDA   $6,X
D959: 00 6E       NEG    $6E
D95B: B1 06 00    CMPA   $0600
D95E: 6E BE       JMP    [W,Y]
D960: 06 00       ROR    $00
D962: 6E 7D       JMP    -$3,S
D964: 06 00       ROR    $00
D966: 6E 8A       JMP    F,X
D968: 05 00       LSR    $00
D96A: 6E 97       JMP    [E,X]
D96C: 05 00       LSR    $00
D96E: 6E A4       JMP    ,Y
D970: 05 00       LSR    $00
D972: 6E B1       JMP    [,Y++]
D974: 05 00       LSR    $00
D976: 6E BE       JMP    [W,Y]
D978: 05 00       LSR    $00
D97A: 6E 7D       JMP    -$3,S
D97C: 05 00       LSR    $00
D97E: 6E 8A       JMP    F,X
D980: 1E 07       EXG    D,inv
D982: 6F 78       CLR    -$8,S
D984: 1E 07       EXG    D,inv
D986: 6F 85       CLR    B,X
D988: 1E 07       EXG    D,inv
D98A: 6F 78       CLR    -$8,S
D98C: 06 00       ROR    $00
D98E: 6F 92       CLR    Illegal Postbyte
D990: 1E 07       EXG    D,inv
D992: 6F 78       CLR    -$8,S
D994: 1E 07       EXG    D,inv
D996: 6F 85       CLR    B,X
D998: 1E 07       EXG    D,inv
D99A: 6F 78       CLR    -$8,S
D99C: 06 00       ROR    $00
D99E: 6F 92       CLR    Illegal Postbyte
D9A0: 01 04       NEG    $04
D9A2: 6F A5       CLR    B,Y
D9A4: 06 00       ROR    $00
D9A6: 6F B2       CLR    Illegal Postbyte
D9A8: 0E 00       JMP    $00
D9AA: 6F C5       CLR    B,U
D9AC: 04 08       LSR    $08
D9AE: 6F D8 04    CLR    [$04,U]
D9B1: 09 6F       ROL    $6F
D9B3: EB 06       ADDB   $6,X
D9B5: 09 6F       ROL    $6F
D9B7: F8 04 09    EORB   $0409
D9BA: 70 05 05    NEG    $0505
D9BD: 0F 70       CLR    $70
D9BF: 12          NOP
D9C0: 06 0F       ROR    $0F
D9C2: 70 25 07    NEG    $2507
D9C5: 0C 70       INC    $70
D9C7: 32 05       LEAS   $5,X
D9C9: 0C 70       INC    $70
D9CB: 45          LSRA
D9CC: 05 0A       LSR    $0A
D9CE: 70 58 06    NEG    $5806
D9D1: 0A 70       DEC    $70
D9D3: 6B 06       XDEC   $6,X
D9D5: 0B 70       XDEC   $70
D9D7: 7E 14 05    JMP    $1405
D9DA: 70 8B 06    NEG    $8B06
D9DD: 06 70       ROR    $70
D9DF: 9E 06       LDX    $06
D9E1: 0D 70       TST    $70
D9E3: B1 06 05    CMPA   $0605
D9E6: 70 8B 06    NEG    $8B06
D9E9: 06 70       ROR    $70
D9EB: 9E 06       LDX    $06
D9ED: 0D 70       TST    $70
D9EF: B1 14 05    CMPA   $1405
D9F2: 70 8B 06    NEG    $8B06
D9F5: 06 70       ROR    $70
D9F7: 9E 06       LDX    $06
D9F9: 0D 70       TST    $70
D9FB: B1 04 0E    CMPA   $040E
D9FE: 6E F8 06    JMP    [$06,S]
DA01: 0E 6F       JMP    $6F
DA03: 0B 06       XDEC   $06
DA05: 0E 6F       JMP    $6F
DA07: 1E 06       EXG    D,inv
DA09: 00 6F       NEG    $6F
DA0B: 2B 04       BMI    $DA11
DA0D: 0F 6F       CLR    $6F
DA0F: 3E          XRES
DA10: 06 0F       ROR    $0F
DA12: 6F 51       CLR    -$F,U
DA14: 06 0F       ROR    $0F
DA16: 6F 5E       CLR    -$2,U
DA18: 06 0F       ROR    $0F
DA1A: 6F 6B       CLR    $B,S
DA1C: 06 01       ROR    $01
DA1E: 70 C4 06    NEG    $C406
DA21: 04 70       LSR    $70
DA23: D1 06       CMPB   $06
DA25: 0C 70       INC    $70
DA27: E4 06       ANDB   $6,X
DA29: 01 70       NEG    $70
DA2B: F1 06 01    CMPB   $0601
DA2E: 70 FE 06    NEG    $FE06
DA31: 02 71       XNC    $71
DA33: 0B 06       XDEC   $06
DA35: 03 71       COM    $71
DA37: 18          X18
DA38: 06 01       ROR    $01
DA3A: 71 25 06    NEG    $2506
DA3D: 03 71       COM    $71
DA3F: 38 06       XANDCC #$06
DA41: 00 71       NEG    $71
DA43: 4B          XDECA
DA44: 06 01       ROR    $01
DA46: 71 58 06    NEG    $5806
DA49: 03 71       COM    $71
DA4B: 6B 04       XDEC   $4,X
DA4D: 21 71       BRN    $DAC0
DA4F: 7E 04 A1    JMP    $04A1
DA52: 71 8B 04    NEG    $8B04
DA55: A1 71       CMPA   -$F,S
DA57: 9E 04       LDX    $04
DA59: A1 71       CMPA   -$F,S
DA5B: B1 04 A1    CMPA   $04A1
DA5E: 71 C4 04    NEG    $C404
DA61: A1 71       CMPA   -$F,S
DA63: 7E 04 A1    JMP    $04A1
DA66: 72 0A 04    XNC    $0A04
DA69: A1 72       CMPA   -$E,S
DA6B: 0A 04       DEC    $04
DA6D: A1 72       CMPA   -$E,S
DA6F: 1D          SEX
DA70: 04 A1       LSR    $A1
DA72: 72 30 04    XNC    $3004
DA75: A1 72       CMPA   -$E,S
DA77: 43          COMA
DA78: 04 A1       LSR    $A1
DA7A: 71 FD 04    NEG    $FD04
DA7D: A1 71       CMPA   -$F,S
DA7F: FD 04 A1    STD    $04A1
DA82: 72 0A 04    XNC    $0A04
DA85: A1 72       CMPA   -$E,S
DA87: 1D          SEX
DA88: 04 A1       LSR    $A1
DA8A: 72 30 04    XNC    $3004
DA8D: A1 72       CMPA   -$E,S
DA8F: 43          COMA
DA90: 04 A1       LSR    $A1
DA92: 71 FD 0F    NEG    $FD0F
DA95: 83 72 95    SUBD   #$7295
DA98: 0F E8       CLR    $E8
DA9A: 72 A8 0F    XNC    $A80F
DA9D: E4 72       ANDB   -$E,S
DA9F: B5 0F 90    BITA   $0F90
DAA2: 72 C2 0F    XNC    $C20F
DAA5: 82 72       SBCA   #$72
DAA7: D5 0F       BITB   $0F
DAA9: 83 72 95    SUBD   #$7295
DAAC: 0F D7       CLR    $D7
DAAE: 72 EE 0F    XNC    $EE0F
DAB1: 98 73       EORA   $73
DAB3: 0D 0F       TST    $0F
DAB5: E7 73       STB    -$D,S
DAB7: 26 0F       BNE    $DAC8
DAB9: E6 73       LDB    -$D,S
DABB: 39          RTS
DABC: 0F E5       CLR    $E5
DABE: 73 4C 04    COM    $4C04
DAC1: E9 73       ADCB   -$D,S
DAC3: 93 04       SUBD   $04
DAC5: EA 73       ORB    -$D,S
DAC7: A0 04       SUBA   $4,X
DAC9: EB 73       ADDB   -$D,S
DACB: B3 04 EC    SUBD   $04EC
DACE: 73 C0 04    COM    $C004
DAD1: ED 73       STD    -$D,S
DAD3: CD          XHCF
DAD4: 04 EE       LSR    $EE
DAD6: 73 E6 04    COM    $E604
DAD9: EF 73       STU    -$D,S
DADB: F3 04 EC    ADDD   $04EC
DADE: 73 C0 04    COM    $C004
DAE1: 03 73       COM    $73
DAE3: 5F          CLRB
DAE4: 06 03       ROR    $03
DAE6: 73 6C 06    COM    $6C06
DAE9: 0E 6F       JMP    $6F
DAEB: 1E 06       EXG    D,inv
DAED: 00 6F       NEG    $6F
DAEF: 2B 04       BMI    $DAF5
DAF1: 0F 73       CLR    $73
DAF3: 79 06 0F    ROL    $060F
DAF6: 73 86 06    COM    $8606
DAF9: 0F 6F       CLR    $6F
DAFB: 5E          XCLRB
DAFC: 06 0F       ROR    $0F
DAFE: 6F 6B       CLR    $B,S
DB00: 08 01       ASL    $01
DB02: 60 00       NEG    $0,X
DB04: 08 01       ASL    $01
DB06: 6B 52       XDEC   -$E,U
DB08: 08 01       ASL    $01
DB0A: 60 85       NEG    B,X
DB0C: 08 11       ASL    $11
DB0E: 60 98 08    NEG    [$08,X]
DB11: 11 6B 65    XDEC   $5,S
DB14: 08 01       ASL    $01
DB16: 60 85       NEG    B,X
DB18: 06 01       ROR    $01
DB1A: 61 DA       NEG    [F,U]
DB1C: 06 01       ROR    $01
DB1E: 60 13       NEG    -$D,X
DB20: 06 01       ROR    $01
DB22: 60 26       NEG    $6,Y
DB24: 06 01       ROR    $01
DB26: 60 39       NEG    -$7,Y
DB28: 06 01       ROR    $01
DB2A: 60 4C       NEG    $C,U
DB2C: 06 01       ROR    $01
DB2E: 60 5F       NEG    -$1,U
DB30: 06 01       ROR    $01
DB32: 60 72       NEG    -$E,S
DB34: 04 01       LSR    $01
DB36: 60 13       NEG    -$D,X
DB38: 04 01       LSR    $01
DB3A: 60 26       NEG    $6,Y
DB3C: 04 01       LSR    $01
DB3E: 60 39       NEG    -$7,Y
DB40: 04 01       LSR    $01
DB42: 60 4C       NEG    $C,U
DB44: 04 01       LSR    $01
DB46: 60 5F       NEG    -$1,U
DB48: 04 01       LSR    $01
DB4A: 60 72       NEG    -$E,S
DB4C: 06 16       ROR    $16
DB4E: 61 17       NEG    -$9,X
DB50: 18          X18
DB51: 13          SYNC
DB52: 61 30       NEG    -$10,Y
DB54: 06 01       ROR    $01
DB56: 61 43       NEG    $3,U
DB58: 06 16       ROR    $16
DB5A: 61 17       NEG    -$9,X
DB5C: 18          X18
DB5D: 13          SYNC
DB5E: 61 30       NEG    -$10,Y
DB60: 06 01       ROR    $01
DB62: 61 43       NEG    $3,U
DB64: 08 26       ASL    $26
DB66: 6B D1       XDEC   [,U++]
DB68: 08 22       ASL    $22
DB6A: 6B E4       XDEC   ,S
DB6C: 08 22       ASL    $22
DB6E: 6B FD 08 1E XDEC   [$E390,PCR]
DB72: 6C 35       INC    -$B,Y
DB74: 08 1F       ASL    $1F
DB76: 6C 48       INC    $8,U
DB78: 08 15       ASL    $15
DB7A: 6C 5B       INC    -$5,U
DB7C: 08 14       ASL    $14
DB7E: 6C 74       INC    -$C,S
DB80: 08 0D       ASL    $0D
DB82: 6C 8D 08 19 INC    $E39F,PCR
DB86: 61 56       NEG    -$A,U
DB88: 04 01       LSR    $01
DB8A: 61 43       NEG    $3,U
DB8C: 10 19       DAA
DB8E: 61 56       NEG    -$A,U
DB90: 04 01       LSR    $01
DB92: 61 43       NEG    $3,U
DB94: 08 01       ASL    $01
DB96: 60 A5       NEG    B,Y
DB98: 0A 00       DEC    $00
DB9A: 60 B8 0A    NEG    [$0A,Y]
DB9D: 00 60       NEG    $60
DB9F: D1 0A       CMPB   $0A
DBA1: 00 60       NEG    $60
DBA3: B8 08 01    EORA   $0801
DBA6: 60 A5       NEG    B,Y
DBA8: 08 11       ASL    $11
DBAA: 60 EA       NEG    F,S
DBAC: 0A 11       DEC    $11
DBAE: 60 FD 0A 11 NEG    [$E5C3,PCR]
DBB2: 61 0A       NEG    $A,X
DBB4: 0A 11       DEC    $11
DBB6: 60 FD 08 11 NEG    [$E3CB,PCR]
DBBA: 60 EA       NEG    F,S
DBBC: 06 16       ROR    $16
DBBE: 61 17       NEG    -$9,X
DBC0: 06 13       ROR    $13
DBC2: 61 30       NEG    -$10,Y
DBC4: 04 01       LSR    $01
DBC6: 61 43       NEG    $3,U
DBC8: 08 01       ASL    $01
DBCA: 61 82       NEG    ,-X
DBCC: 08 23       ASL    $23
DBCE: 61 95       NEG    [B,X]
DBD0: 0C 23       INC    $23
DBD2: 61 A8 08    NEG    $08,Y
DBD5: 23 61       BLS    $DC38
DBD7: C1 08       CMPB   #$08
DBD9: 23 61       BLS    $DC3C
DBDB: A8 08       EORA   $8,X
DBDD: 23 61       BLS    $DC40
DBDF: C1 08       CMPB   #$08
DBE1: 23 61       BLS    $DC44
DBE3: A8 08       EORA   $8,X
DBE5: 23 61       BLS    $DC48
DBE7: 95 08       BITA   $08
DBE9: 01 61       NEG    $61
DBEB: 82 06       SBCA   #$06
DBED: 01 61       NEG    $61
DBEF: DA 06       ORB    $06
DBF1: 01 61       NEG    $61
DBF3: ED 06       STD    $6,X
DBF5: 01 62       NEG    $62
DBF7: 00 06       NEG    $06
DBF9: 23 62       BLS    $DC5D
DBFB: 13          SYNC
DBFC: 06 24       ROR    $24
DBFE: 62 26       XNC    $6,Y
DC00: 06 01       ROR    $01
DC02: 62 AB       XNC    D,Y
DC04: 06 01       ROR    $01
DC06: 62 BE       XNC    [W,Y]
DC08: 06 01       ROR    $01
DC0A: 62 D1       XNC    [,U++]
DC0C: 06 01       ROR    $01
DC0E: 62 E4       XNC    ,S
DC10: 06 01       ROR    $01
DC12: 62 F7       XNC    [E,S]
DC14: 06 01       ROR    $01
DC16: 63 0A       COM    $A,X
DC18: 06 01       ROR    $01
DC1A: 62 39       XNC    -$7,Y
DC1C: 06 03       ROR    $03
DC1E: 62 4C       XNC    $C,U
DC20: 06 00       ROR    $00
DC22: 62 5F       XNC    -$1,U
DC24: 06 01       ROR    $01
DC26: 62 72       XNC    -$E,S
DC28: 06 03       ROR    $03
DC2A: 62 85       XNC    B,X
DC2C: 06 00       ROR    $00
DC2E: 62 98 08    XNC    [$08,X]
DC31: 97 64       STA    $64
DC33: 73 08 A0    COM    $08A0
DC36: 64 8C 04    LSR    $DC3D,PCR
DC39: F0 64 AB    SUBB   $64AB
DC3C: 04 F0       LSR    $F0
DC3E: 64 C4       LSR    ,U
DC40: 18          X18
DC41: F0 65 67    SUBB   $6567
DC44: 08 F0       ASL    $F0
DC46: 65 80       LSR    ,X+
DC48: 08 F0       ASL    $F0
DC4A: 65 99 08 F0 LSR    [$08F0,X]
DC4E: 65 B2       LSR    Illegal Postbyte
DC50: 08 F0       ASL    $F0
DC52: 65 C5       LSR    B,U
DC54: 08 F1       ASL    $F1
DC56: 65 D8 08    LSR    [$08,U]
DC59: F1 65 DF    CMPB   $65DF
DC5C: 0A 83       DEC    $83
DC5E: 64 DD 08 F7 LSR    [$E559,PCR]
DC62: 64 F6       LSR    [A,S]
DC64: 04 F0       LSR    $F0
DC66: 64 AB       LSR    D,Y
DC68: 04 F0       LSR    $F0
DC6A: 64 C4       LSR    ,U
DC6C: 18          X18
DC6D: F0 65 67    SUBB   $6567
DC70: 08 F0       ASL    $F0
DC72: 65 80       LSR    ,X+
DC74: 08 F0       ASL    $F0
DC76: 65 99 08 F0 LSR    [$08F0,X]
DC7A: 65 B2       LSR    Illegal Postbyte
DC7C: 08 F0       ASL    $F0
DC7E: 65 C5       LSR    B,U
DC80: 08 F1       ASL    $F1
DC82: 65 D8 08    LSR    [$08,U]
DC85: F1 65 DF    CMPB   $65DF
DC88: 08 98       ASL    $98
DC8A: 65 09       LSR    $9,X
DC8C: 06 98       ROR    $98
DC8E: 65 22       LSR    $2,Y
DC90: 04 98       LSR    $98
DC92: 65 3B       LSR    -$5,Y
DC94: 18          X18
DC95: F0 65 54    SUBB   $6554
DC98: 08 F0       ASL    $F0
DC9A: 65 E6       LSR    A,S
DC9C: 08 F0       ASL    $F0
DC9E: 65 F9 08 F0 LSR    [$08F0,S]
DCA2: 66 0C       ROR    $C,X
DCA4: 08 F0       ASL    $F0
DCA6: 66 1F       ROR    -$1,X
DCA8: 08 F0       ASL    $F0
DCAA: 66 2C       ROR    $C,Y
DCAC: 08 F0       ASL    $F0
DCAE: 66 39       ROR    -$7,Y
DCB0: 08 F0       ASL    $F0
DCB2: 66 46       ROR    $6,U
DCB4: 08 F1       ASL    $F1
DCB6: 66 53       ROR    -$D,U
DCB8: 08 F1       ASL    $F1
DCBA: 66 5A       ROR    -$6,U
DCBC: 05 24       LSR    $24
DCBE: 63 1D       COM    -$3,X
DCC0: 05 23       LSR    $23
DCC2: 63 30       COM    -$10,Y
DCC4: 05 00       LSR    $00
DCC6: 63 43       COM    $3,U
DCC8: 05 F6       LSR    $F6
DCCA: 63 56       COM    -$A,U
DCCC: 05 F6       LSR    $F6
DCCE: 63 7C       COM    -$4,S
DCD0: 05 F6       LSR    $F6
DCD2: 63 8F       COM    ,W
DCD4: 05 F6       LSR    $F6
DCD6: 63 B5       COM    [B,Y]
DCD8: 05 F6       LSR    $F6
DCDA: 63 C8 05    COM    $05,U
DCDD: 81 61       CMPA   #$61
DCDF: DA 05       ORB    $05
DCE1: 81 64       CMPA   #$64
DCE3: 60 0C       NEG    $C,X
DCE5: F6 63 DB    LDB    $63DB
DCE8: 06 F6       ROR    $F6
DCEA: 64 01       LSR    $1,X
DCEC: 06 F6       ROR    $F6
DCEE: 64 14       LSR    -$C,X
DCF0: 06 00       ROR    $00
DCF2: 64 27       LSR    $7,Y
DCF4: 05 24       LSR    $24
DCF6: 64 3A       LSR    -$6,Y
DCF8: 05 25       LSR    $25
DCFA: 64 4D       LSR    $D,U
DCFC: 08 00       ASL    $00
DCFE: 69 4A       ROL    $A,U
DD00: 0A 1A       DEC    $1A
DD02: 66 87       ROR    E,X
DD04: 0A 1A       DEC    $1A
DD06: 66 9A       ROR    [F,X]
DD08: 0A 1A       DEC    $1A
DD0A: 66 B3       ROR    [,--Y]
DD0C: 08 1A       ASL    $1A
DD0E: 66 CC 08    ROR    $DD19,PCR
DD11: 1A 66       ORCC   #$66
DD13: E5 08       BITB   $8,X
DD15: 1A 69       ORCC   #$69
DD17: 37 08       PULU   DP
DD19: 00 69       NEG    $69
DD1B: 4A          DECA
DD1C: 08 01       ASL    $01
DD1E: 61 DA       NEG    [F,U]
DD20: 08 1B       ASL    $1B
DD22: 68 B3       ASL    [,--Y]
DD24: 08 21       ASL    $21
DD26: 68 C0       ASL    ,U+
DD28: 0A 1C       DEC    $1C
DD2A: 68 D9 0A 1D ASL    [$0A1D,U]
DD2E: 68 EC 04    ASL    $DD35,PCR
DD31: 21 69       BRN    $DD9C
DD33: 05 08       LSR    $08
DD35: 21 69       BRN    $DDA0
DD37: 1E 08       EXG    D,A
DD39: 1A 69       ORCC   #$69
DD3B: 37 08       PULU   DP
DD3D: 00 69       NEG    $69
DD3F: 4A          DECA
DD40: 06 1A       ROR    $1A
DD42: 69 5D       ROL    -$3,U
DD44: 06 1A       ROR    $1A
DD46: 69 76       ROL    -$A,S
DD48: 06 1A       ROR    $1A
DD4A: 69 8F       ROL    ,W
DD4C: 06 0E       ROR    $0E
DD4E: 69 A8 06    ROL    $06,Y
DD51: 10 69 C1    ROL    ,U++
DD54: 06 10       ROR    $10
DD56: 69 DA       ROL    [F,U]
DD58: 06 10       ROR    $10
DD5A: 69 F3       ROL    [,--S]
DD5C: 06 14       ROR    $14
DD5E: 6A 0C       DEC    $C,X
DD60: 06 12       ROR    $12
DD62: 6A 25       DEC    $5,Y
DD64: 06 04       ROR    $04
DD66: 6A 3E       DEC    -$2,Y
DD68: 06 00       ROR    $00
DD6A: 6A 57       DEC    -$9,U
DD6C: 06 00       ROR    $00
DD6E: 6A 6A       DEC    $A,S
DD70: 06 10       ROR    $10
DD72: 6A 7D       DEC    -$3,S
DD74: 06 10       ROR    $10
DD76: 6A 96       DEC    [A,X]
DD78: 06 10       ROR    $10
DD7A: 6A A9 06 10 DEC    $0610,Y
DD7E: 6A C2       DEC    ,-U
DD80: 06 10       ROR    $10
DD82: 6A DB       DEC    [D,U]
DD84: 06 00       ROR    $00
DD86: 6A F4       DEC    [,S]
DD88: 06 01       ROR    $01
DD8A: 6B 0D       XDEC   $D,X
DD8C: 06 01       ROR    $01
DD8E: 6B 26       XDEC   $6,Y
DD90: 06 02       ROR    $02
DD92: 6B 3F       XDEC   -$1,Y
DD94: 08 25       ASL    $25
DD96: 6B 98 0A    XDEC   [$0A,X]
DD99: 25 6B       BCS    $DE06
DD9B: AB 0A       ADDA   $A,X
DD9D: 25 6B       BCS    $DE0A
DD9F: 72 0A 25    XNC    $0A25
DDA2: 6B BE       XDEC   [W,Y]
DDA4: 08 25       ASL    $25
DDA6: 6B 72       XDEC   -$E,S
DDA8: 08 25       ASL    $25
DDAA: 6B 85       XDEC   B,X
DDAC: 08 25       ASL    $25
DDAE: 6B 72       XDEC   -$E,S
DDB0: 08 25       ASL    $25
DDB2: 6B AB       XDEC   D,Y
DDB4: 08 25       ASL    $25
DDB6: 6B 98 03    XDEC   [$03,X]
DDB9: F2 6C A0    SBCB   $6CA0
DDBC: 03 F2       COM    $F2
DDBE: 6C AD 03 F2 INC    $E1B4,PCR
DDC2: 6C C0       INC    ,U+
DDC4: 03 F2       COM    $F2
DDC6: 6C D3       INC    [,--U]
DDC8: 03 F2       COM    $F2
DDCA: 6C E6       INC    A,S
DDCC: 03 F2       COM    $F2
DDCE: 6C F9 03 F2 INC    [$03F2,S]
DDD2: 6D 0C       TST    $C,X
DDD4: 03 F2       COM    $F2
DDD6: 6D 1F       TST    -$1,X
DDD8: 03 1A       COM    $1A
DDDA: 6D 32       TST    -$E,Y
DDDC: 03 1A       COM    $1A
DDDE: 6D 4B       TST    $B,U
DDE0: 03 1A       COM    $1A
DDE2: 6D 6A       TST    $A,S
DDE4: 03 1A       COM    $1A
DDE6: 6D 89 03 1A TST    $031A,X
DDEA: 6D A8 03    TST    $03,Y
DDED: 1A 6D       ORCC   #$6D
DDEF: C1 08       CMPB   #$08
DDF1: 21 69       BRN    $DE5C
DDF3: 1E 08       EXG    D,A
DDF5: 1A 69       ORCC   #$69
DDF7: 37 08       PULU   DP
DDF9: 00 69       NEG    $69
DDFB: 4A          DECA
DDFC: 04 1A       LSR    $1A
DDFE: 6D C1       TST    ,U++
DE00: 04 1A       LSR    $1A
DE02: 6D A8 04    TST    $04,Y
DE05: 1A 6D       ORCC   #$6D
DE07: 89 04       ADCA   #$04
DE09: 1A 6D       ORCC   #$6D
DE0B: 6A 04       DEC    $4,X
DE0D: 1A 6D       ORCC   #$6D
DE0F: 4B          XDECA
DE10: 04 1A       LSR    $1A
DE12: 6D 32       TST    -$E,Y
DE14: 04 F2       LSR    $F2
DE16: 6D 1F       TST    -$1,X
DE18: 04 F2       LSR    $F2
DE1A: 6D 0C       TST    $C,X
DE1C: 04 F2       LSR    $F2
DE1E: 6C F9 04 F2 INC    [$04F2,S]
DE22: 6C E6       INC    A,S
DE24: 04 F2       LSR    $F2
DE26: 6C D3       INC    [,--U]
DE28: 04 F2       LSR    $F2
DE2A: 6C C0       INC    ,U+
DE2C: 04 F2       LSR    $F2
DE2E: 6C AD 04 F2 INC    $E324,PCR
DE32: 6C A0       INC    ,Y+
DE34: 06 0E       ROR    $0E
DE36: 6D DA       TST    [F,U]
DE38: 06 00       ROR    $00
DE3A: 6D F3       TST    [,--S]
DE3C: 06 02       ROR    $02
DE3E: 6E 0C       JMP    $C,X
DE40: 06 02       ROR    $02
DE42: 6E 2B       JMP    $B,Y
DE44: 0A 18       DEC    $18
DE46: 65 09       LSR    $9,X
DE48: 0A 18       DEC    $18
DE4A: 65 22       LSR    $2,Y
DE4C: 0A 18       DEC    $18
DE4E: 65 3B       LSR    -$5,Y
DE50: 0A 11       DEC    $11
DE52: 60 98 0A    NEG    [$0A,X]
DE55: 01 60       NEG    $60
DE57: 85 0A       BITA   #$0A
DE59: 01 60       NEG    $60
DE5B: 00 0A       NEG    $0A
DE5D: 01 6B       NEG    $6B
DE5F: 52          XNCB
DE60: 0A 17       DEC    $17
DE62: 64 73       LSR    -$D,S
DE64: 0A 20       DEC    $20
DE66: 64 8C 0A    LSR    $DE73,PCR
DE69: 20 64       BRA    $DECF
DE6B: 8C 0A 11    CMPX   #$0A11
DE6E: 60 98 0A    NEG    [$0A,X]
DE71: 01 60       NEG    $60
DE73: 85 0A       BITA   #$0A
DE75: 01 60       NEG    $60
DE77: 00 0A       NEG    $0A
DE79: 01 6B       NEG    $6B
DE7B: 52          XNCB
DE7C: 08 01       ASL    $01
DE7E: 60 85       NEG    B,X
DE80: 08 01       ASL    $01
DE82: 60 00       NEG    $0,X
DE84: 08 01       ASL    $01
DE86: 6B 52       XDEC   -$E,U
DE88: 08 01       ASL    $01
DE8A: 60 00       NEG    $0,X
DE8C: 08 01       ASL    $01
DE8E: 6B 52       XDEC   -$E,U
DE90: 08 8A       ASL    $8A
DE92: 68 54       ASL    -$C,U
DE94: 08 8A       ASL    $8A
DE96: 68 67       ASL    $7,S
DE98: 08 8A       ASL    $8A
DE9A: 68 7A       ASL    -$6,S
DE9C: 08 8A       ASL    $8A
DE9E: 68 8D 08 8A ASL    $E72C,PCR
DEA2: 68 A0       ASL    ,Y+
DEA4: 08 8A       ASL    $8A
DEA6: 67 F5       ASR    [B,S]
DEA8: 08 8A       ASL    $8A
DEAA: 68 08       ASL    $8,X
DEAC: 08 FF       ASL    $FF
DEAE: 68 1B       ASL    -$5,X
DEB0: 08 8A       ASL    $8A
DEB2: 68 2E       ASL    $E,Y
DEB4: 08 8A       ASL    $8A
DEB6: 68 41       ASL    $1,U
DEB8: 08 8A       ASL    $8A
DEBA: 67 5D       ASR    -$3,U
DEBC: 08 8A       ASL    $8A
DEBE: 67 70       ASR    -$10,S
DEC0: 08 8A       ASL    $8A
DEC2: 67 83       ASR    ,--X
DEC4: 08 8A       ASL    $8A
DEC6: 67 96       ASR    [A,X]
DEC8: 08 8A       ASL    $8A
DECA: 67 4A       ASR    $A,U
DECC: 08 8A       ASL    $8A
DECE: 67 4A       ASR    $A,U
DED0: 08 8A       ASL    $8A
DED2: 66 FE       ROR    [W,S]
DED4: 08 8A       ASL    $8A
DED6: 67 11       ASR    -$F,X
DED8: 08 8A       ASL    $8A
DEDA: 67 24       ASR    $4,Y
DEDC: 08 8A       ASL    $8A
DEDE: 67 37       ASR    -$9,Y
DEE0: 08 8A       ASL    $8A
DEE2: 67 24       ASR    $4,Y
DEE4: 08 8A       ASL    $8A
DEE6: 67 11       ASR    -$F,X
DEE8: 08 8A       ASL    $8A
DEEA: 66 FE       ROR    [W,S]
DEEC: 08 8A       ASL    $8A
DEEE: 67 4A       ASR    $A,U
DEF0: 08 8A       ASL    $8A
DEF2: 67 A9 10 8A ASR    $108A,Y
DEF6: 67 BC 08    ASR    [$DF01,PCR]
DEF9: 8A 67       ORA    #$67
DEFB: A9 08       ADCA   $8,X
DEFD: 8A 67       ORA    #$67
DEFF: CF 08 8A    XSTU   #$088A
DF02: 67 E2       ASR    ,-S
DF04: 08 8A       ASL    $8A
DF06: 67 CF       ASR    ,W++
DF08: 08 8A       ASL    $8A
DF0A: 68 41       ASL    $1,U
DF0C: 08 8A       ASL    $8A
DF0E: 68 2E       ASL    $E,Y
DF10: 08 FF       ASL    $FF
DF12: 68 1B       ASL    -$5,X
DF14: 08 8A       ASL    $8A
DF16: 68 08       ASL    $8,X
DF18: 08 8A       ASL    $8A
DF1A: 67 F5       ASR    [B,S]
DF1C: 08 24       ASL    $24
DF1E: 63 1D       COM    -$3,X
DF20: 08 23       ASL    $23
DF22: 63 30       COM    -$10,Y
DF24: 08 23       ASL    $23
DF26: 63 30       COM    -$10,Y
DF28: 08 24       ASL    $24
DF2A: 63 1D       COM    -$3,X
DF2C: 06 53       ROR    $53
DF2E: 6E 70       JMP    -$10,S
DF30: 06 53       ROR    $53
DF32: 6E 83       JMP    ,--X
DF34: 06 53       ROR    $53
DF36: 6E 96       JMP    [A,X]
DF38: 06 53       ROR    $53
DF3A: 6E A3       JMP    ,--Y
DF3C: 06 53       ROR    $53
DF3E: 6E B0 06 53 JMP    [$0653,W]
DF42: 6E C3       JMP    ,--U
DF44: 06 53       ROR    $53
DF46: 6E D6       JMP    [A,U]
DF48: 06 53       ROR    $53
DF4A: 6E E9 08 53 JMP    $0853,S
DF4E: 6E FC 08    JMP    [$DF59,PCR]
DF51: 53          COMB
DF52: 6F 09       CLR    $9,X
DF54: 08 53       ASL    $53
DF56: 6F 1C       CLR    -$4,X
DF58: 08 53       ASL    $53
DF5A: 6F 2F       CLR    $F,Y
DF5C: 08 53       ASL    $53
DF5E: 6F 3C       CLR    -$4,Y
DF60: 08 53       ASL    $53
DF62: 6F 4F       CLR    $F,U
DF64: 10 53       COMB
DF66: 6F 62       CLR    $2,S
DF68: 08 53       ASL    $53
DF6A: 6F 4F       CLR    $F,U
DF6C: 08 53       ASL    $53
DF6E: 6F 3C       CLR    -$4,Y
DF70: 08 53       ASL    $53
DF72: 6F 2F       CLR    $F,Y
DF74: 08 53       ASL    $53
DF76: 6F 75       CLR    -$B,S
DF78: 10 53       COMB
DF7A: 6F 88 08    CLR    $08,X
DF7D: 53          COMB
DF7E: 6F 75       CLR    -$B,S
DF80: 08 53       ASL    $53
DF82: 6F 2F       CLR    $F,Y
DF84: 06 53       ROR    $53
DF86: 6F 9B       CLR    [D,X]
DF88: 06 54       ROR    $54
DF8A: 6F AE       CLR    W,Y
DF8C: 06 54       ROR    $54
DF8E: 6F C1       CLR    ,U++
DF90: 06 55       ROR    $55
DF92: 6F D4       CLR    [,U]
DF94: 06 56       ROR    $56
DF96: 6F ED 06 56 CLR    $E5F0,PCR
DF9A: 70 06 04    NEG    $0604
DF9D: 57          ASRB
DF9E: 70 1F 04    NEG    $1F04
DFA1: 58          ASLB
DFA2: 70 38 04    NEG    $3804
DFA5: 58          ASLB
DFA6: 70 4B 04    NEG    $4B04
DFA9: 57          ASRB
DFAA: 70 5E 04    NEG    $5E04
DFAD: 59          ROLB
DFAE: 70 77 04    NEG    $7704
DFB1: 59          ROLB
DFB2: 70 8A 08    NEG    $8A08
DFB5: 53          COMB
DFB6: 71 03 08    NEG    $0308
DFB9: 53          COMB
DFBA: 71 10 08    NEG    $1008
DFBD: 53          COMB
DFBE: 71 23 08    NEG    $2308
DFC1: 53          COMB
DFC2: 71 36 08    NEG    $3608
DFC5: 53          COMB
DFC6: 71 49 08    NEG    $4908
DFC9: 53          COMB
DFCA: 71 5C 08    NEG    $5C08
DFCD: 53          COMB
DFCE: 71 10 08    NEG    $1008
DFD1: 53          COMB
DFD2: 71 03 06    NEG    $0306
DFD5: 5A          DECB
DFD6: 70 9D 06    NEG    $9D06
DFD9: 5A          DECB
DFDA: 70 AA 06    NEG    $AA06
DFDD: 5A          DECB
DFDE: 70 B7 06    NEG    $B706
DFE1: 5A          DECB
DFE2: 70 AA 06    NEG    $AA06
DFE5: 5A          DECB
DFE6: 70 9D 0A    NEG    $9D0A
DFE9: 81 71       CMPA   #$71
DFEB: 6F 0A       CLR    $A,X
DFED: 83 71 82    SUBD   #$7182
DFF0: 0A 83       DEC    $83
DFF2: 71 8F 0A    NEG    $8F0A
DFF5: 83 71 9C    SUBD   #$719C
DFF8: 0A F0       DEC    $F0
DFFA: 71 A9 0A    NEG    $A90A
DFFD: F0 71 B6    SUBB   $71B6
E000: 0A F0       DEC    $F0
E002: 71 C3 0F    NEG    $C30F
E005: F0 71 D0    SUBB   $71D0
E008: 0F 83       CLR    $83
E00A: 71 E9 0F    NEG    $E90F
E00D: 83 72 02    SUBD   #$7202
E010: 0F 83       CLR    $83
E012: 72 1B 00    XNC    $1B00
E015: 18          X18
E016: 20 18       BRA    $E030
E018: 05 19       LSR    $19
E01A: 25 19       BCS    $E035
E01C: 06 1A       ROR    $1A
E01E: 26 1A       BNE    $E03A
E020: 08 18       ASL    $18
E022: 28 18       BVC    $E03C
E024: 0C 18       INC    $18
E026: 2C 18       BGE    $E040
E028: 10 1C 20    ANDCC  #$20
E02B: 1C 11       ANDCC  #$11
E02D: 1D          SEX
E02E: 25 1D       BCS    $E04D
E030: 12          NOP
E031: 1E 26       EXG    Y,inv
E033: 1E 00       EXG    D,D
E035: 18          X18
E036: 20 18       BRA    $E050
E038: 10 1C 2C    ANDCC  #$2C
E03B: 1C 14       ANDCC  #$14
E03D: 1C 2C       ANDCC  #$2C
E03F: 1C 15       ANDCC  #$15
E041: 1D          SEX
E042: 21 1D       BRN    $E061
E044: 16 1E 22    LBRA   $FE69
E047: 1E 14       EXG    X,S
E049: 18          X18
E04A: 20 1C       BRA    $E068
E04C: 10 1C 2C    ANDCC  #$2C
E04F: 1C 00       ANDCC  #$00
E051: 18          X18
E052: 20 18       BRA    $E06C
E054: 05 19       LSR    $19
E056: 25 19       BCS    $E071
E058: 06 1A       ROR    $1A
E05A: 26 1A       BNE    $E076
E05C: 00 18       NEG    $18
E05E: 20 18       BRA    $E078
E060: 10 1C 2C    ANDCC  #$2C
E063: 1C 00       ANDCC  #$00
E065: 18          X18
E066: 20 18       BRA    $E080
E068: 05 19       LSR    $19
E06A: 25 19       BCS    $E085
E06C: 06 1A       ROR    $1A
E06E: 26 1A       BNE    $E08A
E070: 08 18       ASL    $18
E072: 28 18       BVC    $E08C
E074: 0C 1C       INC    $1C
E076: 2C 1C       BGE    $E094
E078: 14          XHCF
E079: 1C 2C       ANDCC  #$2C
E07B: 1C 15       ANDCC  #$15
E07D: 1D          SEX
E07E: 25 1D       BCS    $E09D
E080: 16 1E 26    LBRA   $FEA9
E083: 1E 14       EXG    X,S
E085: 18          X18
E086: 20 18       BRA    $E0A0
E088: 10 1C 2C    ANDCC  #$2C
E08B: 1C 28       ANDCC  #$28
E08D: 18          X18
E08E: 20 18       BRA    $E0A8
E090: 29 19       BVS    $E0AB
E092: 25 19       BCS    $E0AD
E094: 2A 1A       BPL    $E0B0
E096: 26 1A       BNE    $E0B2
E098: 28 18       BVC    $E0B2
E09A: 28 18       BVC    $E0B4
E09C: 10 18       X18
E09E: 2C 18       BGE    $E0B8
E0A0: 34 18       PSHS   X,DP
E0A2: 20 18       BRA    $E0BC
E0A4: 35 19       PULS   CC,DP,X
E0A6: 25 19       BCS    $E0C1
E0A8: 36 1A       PSHU   X,DP,A
E0AA: 26 1A       BNE    $E0C6
E0AC: 34 18       PSHS   X,DP
E0AE: 28 18       BVC    $E0C8
E0B0: 10 18       X18
E0B2: 2C 18       BGE    $E0CC
E0B4: 2C 18       BGE    $E0CE
E0B6: 20 18       BRA    $E0D0
E0B8: 2D 19       BLT    $E0D3
E0BA: 25 19       BCS    $E0D5
E0BC: 2E 1A       BGT    $E0D8
E0BE: 26 1A       BNE    $E0DA
E0C0: 2C 18       BGE    $E0DA
E0C2: 28 18       BVC    $E0DC
E0C4: 10 18       X18
E0C6: 2C 18       BGE    $E0E0
E0C8: 30 18       LEAX   -$8,X
E0CA: 20 18       BRA    $E0E4
E0CC: 31 19       LEAY   -$7,X
E0CE: 25 19       BCS    $E0E9
E0D0: 32 1A       LEAS   -$6,X
E0D2: 26 1A       BNE    $E0EE
E0D4: 30 18       LEAX   -$8,X
E0D6: 28 18       BVC    $E0F0
E0D8: 10 18       X18
E0DA: 2C 18       BGE    $E0F4
E0DC: 00 18       NEG    $18
E0DE: 20 18       BRA    $E0F8
E0E0: 41          NEGA
E0E1: 19          DAA
E0E2: 25 19       BCS    $E0FD
E0E4: 42          XNCA
E0E5: 1A 26       ORCC   #$26
E0E7: 1A 08       ORCC   #$08
E0E9: 18          X18
E0EA: 28 18       BVC    $E104
E0EC: 0C 18       INC    $18
E0EE: 2C 18       BGE    $E108
E0F0: 00 18       NEG    $18
E0F2: 20 18       BRA    $E10C
E0F4: 4D          TSTA
E0F5: 19          DAA
E0F6: 25 19       BCS    $E111
E0F8: 52          XNCB
E0F9: 1A 26       ORCC   #$26
E0FB: 1A 08       ORCC   #$08
E0FD: 18          X18
E0FE: 28 18       BVC    $E118
E100: 0C 18       INC    $18
E102: 2C 18       BGE    $E11C
E104: 00 18       NEG    $18
E106: 20 18       BRA    $E120
E108: 51          NEGB
E109: 19          DAA
E10A: 25 19       BCS    $E125
E10C: 4E          XCLRA
E10D: 1A 26       ORCC   #$26
E10F: 1A 08       ORCC   #$08
E111: 18          X18
E112: 28 18       BVC    $E12C
E114: 0C 18       INC    $18
E116: 2C 18       BGE    $E130
E118: 00 18       NEG    $18
E11A: 20 18       BRA    $E134
E11C: 51          NEGB
E11D: 19          DAA
E11E: 25 19       BCS    $E139
E120: 4E          XCLRA
E121: 1A 26       ORCC   #$26
E123: 1A 08       ORCC   #$08
E125: 18          X18
E126: 28 18       BVC    $E140
E128: 0C 18       INC    $18
E12A: 2C 18       BGE    $E144
E12C: 00 18       NEG    $18
E12E: 20 18       BRA    $E148
E130: 4D          TSTA
E131: 19          DAA
E132: 25 19       BCS    $E14D
E134: 52          XNCB
E135: 1A 26       ORCC   #$26
E137: 1A 08       ORCC   #$08
E139: 18          X18
E13A: 28 18       BVC    $E154
E13C: 0C 18       INC    $18
E13E: 2C 18       BGE    $E158
E140: 00 00       NEG    $00
E142: 03 70       COM    $70
E144: FF A0 FF    STU    $A0FF
E147: A0 00       SUBA   $0,X
E149: D0 00       SUBB   $00
E14B: 00 03       NEG    $03
E14D: 70 FF F0    NEG    $FFF0
E150: FF 50 00    STU    $5000
E153: D0 00       SUBB   $00
E155: 00 03       NEG    $03
E157: 70 00 30    NEG    >$0030
E15A: FF 10 00    STU    $1000
E15D: D0 00       SUBB   $00
E15F: 00 03       NEG    $03
E161: 70 FF 70    NEG    $FF70
E164: FF D0 00    STU    $D000
E167: D0 00       SUBB   $00
E169: 00 02       NEG    $02
E16B: E0 FF 70 FF SUBB   [$70FF]
E16F: D0 00       SUBB   $00
E171: D0 00       SUBB   $00
E173: 60 02       NEG    $2,X
E175: E0 FF B0 FF SUBB   [$B0FF]
E179: 90 00       SUBA   $00
E17B: D0 00       SUBB   $00
E17D: 00 02       NEG    $02
E17F: E0 FF C0 FF SUBB   [$C0FF]
E183: 80 00       SUBA   #$00
E185: D0 01       SUBB   $01
E187: 20 01       BRA    $E18A
E189: E0 00       SUBB   $0,X
E18B: 00 FF       NEG    $FF
E18D: 40          NEGA
E18E: 00 D0       NEG    $D0
E190: 01 A0       NEG    $A0
E192: 01 A0       NEG    $A0
E194: FF B0 FF    STU    $B0FF
E197: 90 00       SUBA   $00
E199: D0 02       SUBB   $02
E19B: 30 01       LEAX   $1,X
E19D: A0 FF B0 FF SUBA   [$B0FF]
E1A1: 90 00       SUBA   $00
E1A3: D0 01       SUBB   $01
E1A5: D0 01       SUBB   $01
E1A7: A0 FF 40 00 SUBA   [$4000]
E1AB: 00 00       NEG    $00
E1AD: D0 01       SUBB   $01
E1AF: C0 01       SUBB   #$01
E1B1: A0 FF 70 FF SUBA   [$70FF]
E1B5: D0 00       SUBB   $00
E1B7: D0 00       SUBB   $00
E1B9: 00 03       NEG    $03
E1BB: 20 FF       BRA    $E1BC
E1BD: 80 FF       SUBA   #$FF
E1BF: C0 00       SUBB   #$00
E1C1: D0 00       SUBB   $00
E1C3: 00 03       NEG    $03
E1C5: 00 FF       NEG    $FF
E1C7: D0 FF       SUBB   $FF
E1C9: 70 00 D0    NEG    >$00D0
E1CC: 00 00       NEG    $00
E1CE: 03 20       COM    $20
E1D0: FF 60 FF    STU    $60FF
E1D3: E0 00       SUBB   $0,X
E1D5: D0 00       SUBB   $00
E1D7: 00 02       NEG    $02
E1D9: 60 FF 50 FF NEG    [$50FF]
E1DD: F0 00 D0    SUBB   >$00D0
E1E0: 00 00       NEG    $00
E1E2: 03 70       COM    $70
E1E4: FF 40 00    STU    $4000
E1E7: 00 00       NEG    $00
E1E9: D0 00       SUBB   $00
E1EB: 00 02       NEG    $02
E1ED: 60 FF C0 FF NEG    [$C0FF]
E1F1: 80 00       SUBA   #$00
E1F3: D0 00       SUBB   $00
E1F5: 00 02       NEG    $02
E1F7: 60 FF 70 FF NEG    [$70FF]
E1FB: D0 00       SUBB   $00
E1FD: D0 00       SUBB   $00
E1FF: 50          NEGB
E200: 02 E0       XNC    $E0
E202: FF E0 FF    STU    $E0FF
E205: 60 00       NEG    $0,X
E207: D0 00       SUBB   $00
E209: 00 02       NEG    $02
E20B: A0 FF 70 FF SUBA   [$70FF]
E20F: D0 00       SUBB   $00
E211: D0 00       SUBB   $00
E213: 60 02       NEG    $2,X
E215: A0 FF A0 FF SUBA   [$A0FF]
E219: A0 00       SUBA   $0,X
E21B: D0 00       SUBB   $00
E21D: 00 03       NEG    $03
E21F: 20 FF       BRA    $E220
E221: F0 FF 50    SUBB   $FF50
E224: 00 D0       NEG    $D0
E226: FF 40 03    STU    $4003
E229: 00 00       NEG    $00
E22B: 40          NEGA
E22C: FF 00 00    STU    >$0000
E22F: D0 00       SUBB   $00
E231: 00 03       NEG    $03
E233: 00 00       NEG    $00
E235: 10 FF 30 00 STS    $3000
E239: D0 00       SUBB   $00
E23B: 00 03       NEG    $03
E23D: 70 00 00    NEG    >$0000
E240: FF 40 00    STU    $4000
E243: D0 00       SUBB   $00
E245: 00 03       NEG    $03
E247: 20 FF       BRA    $E248
E249: 80 FF       SUBA   #$FF
E24B: C0 00       SUBB   #$00
E24D: D0 00       SUBB   $00
E24F: 00 02       NEG    $02
E251: 00 FF       NEG    $FF
E253: 70 FF D0    NEG    $FFD0
E256: 00 D0       NEG    $D0
E258: 01 F0       NEG    $F0
E25A: 02 00       XNC    $00
E25C: FF A0 FF    STU    $A0FF
E25F: A0 00       SUBA   $0,X
E261: D0 01       SUBB   $01
E263: 50          NEGB
E264: 02 00       XNC    $00
E266: FF A0 FF    STU    $A0FF
E269: A0 00       SUBA   $0,X
E26B: D0 02       SUBB   $02
E26D: 10 02 00    XNC    $00
E270: 00 00       NEG    $00
E272: FF 40 00    STU    $4000
E275: D0 02       SUBB   $02
E277: 90 02       SUBA   $02
E279: 00 00       NEG    $00
E27B: 00 FF       NEG    $FF
E27D: 40          NEGA
E27E: 00 D0       NEG    $D0
E280: 00 30       NEG    $30
E282: 02 00       XNC    $00
E284: 00 20       NEG    $20
E286: FF 20 00    STU    $2000
E289: D0 00       SUBB   $00
E28B: 00 03       NEG    $03
E28D: C0 FF       SUBB   #$FF
E28F: B0 FF 90    SUBA   $FF90
E292: 00 D0       NEG    $D0
E294: 00 20       NEG    $20
E296: 03 F0       COM    $F0
E298: FF E0 FF    STU    $E0FF
E29B: 60 00       NEG    $0,X
E29D: D0 00       SUBB   $00
E29F: 00 03       NEG    $03
E2A1: 70 FF 60    NEG    $FF60
E2A4: FF E0 00    STU    $E000
E2A7: D0 00       SUBB   $00
E2A9: 00 03       NEG    $03
E2AB: 70 FF B0    NEG    $FFB0
E2AE: FF 90 00    STU    $9000
E2B1: D0 00       SUBB   $00
E2B3: 00 03       NEG    $03
E2B5: 70 FF F0    NEG    $FFF0
E2B8: FF 50 00    STU    $5000
E2BB: D0 00       SUBB   $00
E2BD: 00 02       NEG    $02
E2BF: A0 FF D0 FF SUBA   [$D0FF]
E2C3: 70 00 D0    NEG    >$00D0
E2C6: FF 50 03    STU    $5003
E2C9: 20 FF       BRA    $E2CA
E2CB: 90 FF       SUBA   $FF
E2CD: 80 01       SUBA   #$01
E2CF: 00 00       NEG    $00
E2D1: 00 02       NEG    $02
E2D3: 80 FF       SUBA   #$FF
E2D5: B0 FF 60    SUBA   $FF60
E2D8: 01 00       NEG    $00
E2DA: 00 00       NEG    $00
E2DC: 02 D0       XNC    $D0
E2DE: FF A0 FF    STU    $A0FF
E2E1: 70 01 00    NEG    $0100
E2E4: 00 B0       NEG    $B0
E2E6: 02 00       XNC    $00
E2E8: FF C0 FF    STU    $C0FF
E2EB: 50          NEGB
E2EC: 01 00       NEG    $00
E2EE: 00 00       NEG    $00
E2F0: 03 00       COM    $00
E2F2: FF 70 FF    STU    $70FF
E2F5: A0 01       SUBA   $1,X
E2F7: 00 00       NEG    $00
E2F9: 00 03       NEG    $03
E2FB: 00 FF       NEG    $FF
E2FD: 70 FF 80    NEG    $FF80
E300: 01 20       NEG    $20
E302: 00 00       NEG    $00
E304: 02 60       XNC    $60
E306: FF A0 FF    STU    $A0FF
E309: 50          NEGB
E30A: 01 20       NEG    $20
E30C: 00 00       NEG    $00
E30E: 02 00       XNC    $00
E310: FF C0 FF    STU    $C0FF
E313: 30 01       LEAX   $1,X
E315: 20 00       BRA    $E317
E317: E0 02       SUBB   $2,X
E319: 60 FF 70 FF NEG    [$70FF]
E31D: 80 01       SUBA   #$01
E31F: 20 01       BRA    $E322
E321: 00 02       NEG    $02
E323: 00 FF       NEG    $FF
E325: C0 FF       SUBB   #$FF
E327: 30 01       LEAX   $1,X
E329: 20 FF       BRA    $E32A
E32B: C0 02       SUBB   #$02
E32D: C0 FF       SUBB   #$FF
E32F: D0 FF       SUBB   $FF
E331: 20 01       BRA    $E334
E333: 20 00       BRA    $E335
E335: 00 02       NEG    $02
E337: 80 FF       SUBA   #$FF
E339: B0 FF 80    SUBA   $FF80
E33C: 00 E0       NEG    $E0
E33E: 00 50       NEG    $50
E340: 02 A0       XNC    $A0
E342: 00 10       NEG    $10
E344: FF 20 00    STU    $2000
E347: E0 01       SUBB   $1,X
E349: 00 02       NEG    $02
E34B: A0 00       SUBA   $0,X
E34D: 10 FF 20 00 STS    $2000
E351: E0 00       SUBB   $0,X
E353: 00 02       NEG    $02
E355: 40          NEGA
E356: FF E0 FF    STU    $E0FF
E359: 50          NEGB
E35A: 00 E0       NEG    $E0
E35C: 00 60       NEG    $60
E35E: 02 20       XNC    $20
E360: 00 00       NEG    $00
E362: FF 30 00    STU    $3000
E365: E0 00       SUBB   $0,X
E367: 50          NEGB
E368: 02 40       XNC    $40
E36A: 00 10       NEG    $10
E36C: FF 20 00    STU    $2000
E36F: E0 00       SUBB   $0,X
E371: 00 02       NEG    $02
E373: A0 00       SUBA   $0,X
E375: 20 FF       BRA    $E376
E377: 10 00 E0    NEG    $E0
E37A: 00 00       NEG    $00
E37C: 01 60       NEG    $60
E37E: FF C0 FF    STU    $C0FF
E381: B0 00 A0    SUBA   >$00A0
E384: 00 00       NEG    $00
E386: 01 00       NEG    $00
E388: FF 60 FF    STU    $60FF
E38B: B0 01 00    SUBA   $0100
E38E: 00 00       NEG    $00
E390: 01 C0       NEG    $C0
E392: FF C0 FF    STU    $C0FF
E395: B0 00 A0    SUBA   >$00A0
E398: 00 00       NEG    $00
E39A: 01 80       NEG    $80
E39C: FF 00 FE    STU    >$00FE
E39F: 30 02       LEAX   $2,X
E3A1: E0 00       SUBB   $0,X
E3A3: 00 01       NEG    $01
E3A5: 80 FF       SUBA   #$FF
E3A7: 50          NEGB
E3A8: FE 40 02    LDU    $4002
E3AB: 80 00       SUBA   #$00
E3AD: 00 01       NEG    $01
E3AF: 80 FF       SUBA   #$FF
E3B1: 50          NEGB
E3B2: FE A0 02    LDU    $A002
E3B5: 20 00       BRA    $E3B7
E3B7: 00 01       NEG    $01
E3B9: 80 FF       SUBA   #$FF
E3BB: 90 FF       SUBA   $FF
E3BD: 40          NEGA
E3BE: 01 40       NEG    $40
E3C0: 00 00       NEG    $00
E3C2: 01 80       NEG    $80
E3C4: FF 40 FF    STU    $40FF
E3C7: 90 01       SUBA   $01
E3C9: 40          NEGA
E3CA: 00 00       NEG    $00
E3CC: 01 00       NEG    $00
E3CE: FF 20 FE    STU    $20FE
E3D1: 30 02       LEAX   $2,X
E3D3: C0 00       SUBB   #$00
E3D5: 00 01       NEG    $01
E3D7: 80 FF       SUBA   #$FF
E3D9: 80 FF       SUBA   #$FF
E3DB: 10 01 80    NEG    $80
E3DE: 00 00       NEG    $00
E3E0: 01 C0       NEG    $C0
E3E2: FF 80 FF    STU    $80FF
E3E5: 90 01       SUBA   $01
E3E7: 00 00       NEG    $00
E3E9: 00 01       NEG    $01
E3EB: 80 FF       SUBA   #$FF
E3ED: 00 FE       NEG    $FE
E3EF: B0 02 60    SUBA   $0260
E3F2: 00 00       NEG    $00
E3F4: 01 00       NEG    $00
E3F6: FF 00 FF    STU    >$00FF
E3F9: 90 01       SUBA   $01
E3FB: 80 00       SUBA   #$00
E3FD: 00 01       NEG    $01
E3FF: 00 FF       NEG    $FF
E401: 00 FF       NEG    $FF
E403: 10 02 00    XNC    $00
E406: 00 00       NEG    $00
E408: 01 80       NEG    $80
E40A: FF 80 FE    STU    $80FE
E40D: 90 02       SUBA   $02
E40F: 00 00       NEG    $00
E411: 00 01       NEG    $01
E413: 40          NEGA
E414: FF 90 FF    STU    $90FF
E417: 80 01       SUBA   #$01
E419: 00 00       NEG    $00
E41B: 00 01       NEG    $01
E41D: 80 FF       SUBA   #$FF
E41F: C0 FE       SUBB   #$FE
E421: 30 02       LEAX   $2,X
E423: 20 00       BRA    $E425
E425: 80 01       SUBA   #$01
E427: 60 FF 90 FE NEG    [$90FE]
E42B: 20 02       BRA    $E42F
E42D: 60 00       NEG    $0,X
E42F: 00 02       NEG    $02
E431: 60 FF 10 00 NEG    [$1000]
E435: 00 01       NEG    $01
E437: 00 00       NEG    $00
E439: 00 03       NEG    $03
E43B: 20 FF       BRA    $E43C
E43D: 10 00 00    NEG    $00
E440: 01 00       NEG    $00
E442: 00 00       NEG    $00
E444: 01 80       NEG    $80
E446: FF 00 FF    STU    >$00FF
E449: D0 01       SUBB   $01
E44B: 40          NEGA
E44C: 01 D0       NEG    $D0
E44E: 01 40       NEG    $40
E450: FF 10 00    STU    $1000
E453: 40          NEGA
E454: 00 C0       NEG    $C0
E456: 01 B0       NEG    $B0
E458: 01 C0       NEG    $C0
E45A: FF 10 00    STU    $1000
E45D: 40          NEGA
E45E: 00 C0       NEG    $C0
E460: 01 00       NEG    $00
E462: 01 C0       NEG    $C0
E464: FF 90 FF    STU    $90FF
E467: C0 00       SUBB   #$00
E469: C0 00       SUBB   #$00
E46B: 00 01       NEG    $01
E46D: 00 FF       NEG    $FF
E46F: 40          NEGA
E470: FE D0 02    LDU    $D002
E473: 00 01       NEG    $01
E475: 60 02       NEG    $2,X
E477: 20 FF       BRA    $E478
E479: 10 00 00    NEG    $00
E47C: 01 00       NEG    $00
E47E: 00 00       NEG    $00
E480: 03 70       COM    $70
E482: FF 90 FF    STU    $90FF
E485: B0 00 D0    SUBA   >$00D0
E488: 00 00       NEG    $00
E48A: 03 70       COM    $70
E48C: FF 40 00    STU    $4000
E48F: 00 00       NEG    $00
E491: D0 00       SUBB   $00
E493: 00 03       NEG    $03
E495: 70 FE F0    NEG    $FEF0
E498: 00 50       NEG    $50
E49A: 00 D0       NEG    $D0
E49C: 00 00       NEG    $00
E49E: 03 70       COM    $70
E4A0: 00 80       NEG    $80
E4A2: FE C0 00    LDU    $C000
E4A5: D0 00       SUBB   $00
E4A7: 00 03       NEG    $03
E4A9: 70 FF E0    NEG    $FFE0
E4AC: FF 60 00    STU    $6000
E4AF: D0 00       SUBB   $00
E4B1: 00 03       NEG    $03
E4B3: 70 FF B0    NEG    $FFB0
E4B6: FF 90 00    STU    $9000
E4B9: D0 00       SUBB   $00
E4BB: 00 03       NEG    $03
E4BD: 70 00 00    NEG    >$0000
E4C0: FF 40 00    STU    $4000
E4C3: D0 00       SUBB   $00
E4C5: 00 03       NEG    $03
E4C7: 70 FF C0    NEG    $FFC0
E4CA: FF 80 00    STU    $8000
E4CD: D0 00       SUBB   $00
E4CF: 00 01       NEG    $01
E4D1: 00 FE       NEG    $FE
E4D3: 80 FE       SUBA   #$FE
E4D5: 90 03       SUBA   $03
E4D7: 00 01       NEG    $01
E4D9: 00 01       NEG    $01
E4DB: 50          NEGB
E4DC: FE C0 FF    LDU    $C0FF
E4DF: 00 02       NEG    $02
E4E1: 50          NEGB
E4E2: 01 00       NEG    $00
E4E4: 01 50       NEG    $50
E4E6: FF 50 FF    STU    $50FF
E4E9: 60 01       NEG    $1,X
E4EB: 60 02       NEG    $2,X
E4ED: 50          NEGB
E4EE: 00 B0       NEG    $B0
E4F0: FF 20 FF    STU    $20FF
E4F3: A0 01       SUBA   $1,X
E4F5: 50          NEGB
E4F6: 02 50       XNC    $50
E4F8: 00 B0       NEG    $B0
E4FA: FF 40 FF    STU    $40FF
E4FD: A0 01       SUBA   $1,X
E4FF: 30 02       LEAX   $2,X
E501: 50          NEGB
E502: 00 B0       NEG    $B0
E504: FF A0 FF    STU    $A0FF
E507: B0 00 C0    SUBA   >$00C0
E50A: 01 40       NEG    $40
E50C: 01 00       NEG    $00
E50E: FE E0 00    LDU    $E000
E511: A0 00       SUBA   $0,X
E513: 90 02       SUBA   $02
E515: 50          NEGB
E516: 00 B0       NEG    $B0
E518: 00 00       NEG    $00
E51A: FF A0 00    STU    $A000
E51D: 70 00 00    NEG    >$0000
E520: 02 A0       XNC    $A0
E522: FF F0 FF    STU    $F0FF
E525: 50          NEGB
E526: 00 D0       NEG    $D0
E528: 00 00       NEG    $00
E52A: 03 70       COM    $70
E52C: 00 C0       NEG    $C0
E52E: FE 80 00    LDU    $8000
E531: D0 00       SUBB   $00
E533: 00 01       NEG    $01
E535: A0 01       SUBA   $1,X
E537: 40          NEGA
E538: FE 00 00    LDU    >$0000
E53B: D0 00       SUBB   $00
E53D: 00 02       NEG    $02
E53F: 40          NEGA
E540: 01 40       NEG    $40
E542: FE 00 00    LDU    >$0000
E545: D0 00       SUBB   $00
E547: 00 02       NEG    $02
E549: 40          NEGA
E54A: 00 B0       NEG    $B0
E54C: FE 90 00    LDU    $9000
E54F: D0 00       SUBB   $00
E551: 00 03       NEG    $03
E553: 00 FF       NEG    $FF
E555: 00 00       NEG    $00
E557: 40          NEGA
E558: 00 D0       NEG    $D0
E55A: 00 00       NEG    $00
E55C: 03 B0       COM    $B0
E55E: FF E0 FF    STU    $E0FF
E561: 60 00       NEG    $0,X
E563: D0 00       SUBB   $00
E565: 00 02       NEG    $02
E567: C0 01       SUBB   #$01
E569: 50          NEGB
E56A: FD E0 00    STD    $E000
E56D: E0 00       SUBB   $0,X
E56F: 00 01       NEG    $01
E571: 80 00       SUBA   #$00
E573: 90 FE       SUBA   $FE
E575: 40          NEGA
E576: 01 40       NEG    $40
E578: 00 00       NEG    $00
E57A: 02 C0       XNC    $C0
E57C: FE F0 00    LDU    $F000
E57F: 30 00       LEAX   $0,X
E581: F0 00 00    SUBB   >$0000
E584: 03 10       COM    $10
E586: FF 00 00    STU    >$0000
E589: 40          NEGA
E58A: 00 D0       NEG    $D0
E58C: 00 00       NEG    $00
E58E: 01 80       NEG    $80
E590: FE 80 00    LDU    $8000
E593: 50          NEGB
E594: 01 40       NEG    $40
E596: 00 00       NEG    $00
E598: 01 80       NEG    $80
E59A: FE 90 FF    LDU    $90FF
E59D: A0 01       SUBA   $1,X
E59F: E0 00       SUBB   $0,X
E5A1: 00 02       NEG    $02
E5A3: E0 FE       SUBB   [W,S]
E5A5: A0 00       SUBA   $0,X
E5A7: 70 01 00    NEG    $0100
E5AA: 00 00       NEG    $00
E5AC: 01 40       NEG    $40
E5AE: FE E0 00    LDU    $E000
E5B1: B0 00 80    SUBA   >$0080
E5B4: 00 00       NEG    $00
E5B6: 03 20       COM    $20
E5B8: FF 40 00    STU    $4000
E5BB: 00 00       NEG    $00
E5BD: D0 00       SUBB   $00
E5BF: 00 00       NEG    $00
E5C1: 80 FF       SUBA   #$FF
E5C3: 90 FE       SUBA   $FE
E5C5: A0 01       SUBA   $1,X
E5C7: E0 00       SUBB   $0,X
E5C9: 00 03       NEG    $03
E5CB: 00 FE       NEG    $FE
E5CD: F0 00 20    SUBB   >$0020
E5D0: 01 00       NEG    $00
E5D2: 00 00       NEG    $00
E5D4: 01 00       NEG    $00
E5D6: FF C0 FF    STU    $C0FF
E5D9: 70 00 E0    NEG    >$00E0
E5DC: 00 00       NEG    $00
E5DE: 03 70       COM    $70
E5E0: FF A0 FF    STU    $A0FF
E5E3: A0 00       SUBA   $0,X
E5E5: D0 00       SUBB   $00
E5E7: F0 02 60    SUBB   $0260
E5EA: FE C0 00    LDU    $C000
E5ED: 50          NEGB
E5EE: 01 00       NEG    $00
E5F0: 00 00       NEG    $00
E5F2: 02 80       XNC    $80
E5F4: FF 60 FF    STU    $60FF
E5F7: B0 01 00    SUBA   $0100
E5FA: FC 10 01    LDD    $1001
E5FD: 40          NEGA
E5FE: 00 80       NEG    $80
E600: FE 90 01    LDU    $9001
E603: 00 01       NEG    $01
E605: A0 01       SUBA   $1,X
E607: 40          NEGA
E608: 00 80       NEG    $80
E60A: FE 90 01    LDU    $9001
E60D: 00 02       NEG    $02
E60F: 20 01       BRA    $E612
E611: 40          NEGA
E612: 00 80       NEG    $80
E614: FE 90 01    LDU    $9001
E617: 00 02       NEG    $02
E619: 60 01       NEG    $1,X
E61B: 40          NEGA
E61C: 00 80       NEG    $80
E61E: FE 90 01    LDU    $9001
E621: 00 02       NEG    $02
E623: 80 01       SUBA   #$01
E625: 40          NEGA
E626: 00 80       NEG    $80
E628: FE 90 01    LDU    $9001
E62B: 00 02       NEG    $02
E62D: C0 01       SUBB   #$01
E62F: 40          NEGA
E630: 00 80       NEG    $80
E632: FE 90 01    LDU    $9001
E635: 00 00       NEG    $00
E637: 60 01       NEG    $1,X
E639: 60 FF 00 FE NEG    [$00FE]
E63D: 30 02       LEAX   $2,X
E63F: E0 00       SUBB   $0,X
E641: 60 00       NEG    $0,X
E643: 40          NEGA
E644: 00 00       NEG    $00
E646: 00 00       NEG    $00
E648: 01 00       NEG    $00
E64A: 00 00       NEG    $00
E64C: 00 C0       NEG    $C0
E64E: 00 20       NEG    $20
E650: 00 20       NEG    $20
E652: 00 C0       NEG    $C0
E654: 00 00       NEG    $00
E656: 01 40       NEG    $40
E658: FF 60 00    STU    $6000
E65B: 60 01       NEG    $1,X
E65D: 40          NEGA
E65E: 02 F0       XNC    $F0
E660: 00 80       NEG    $80
E662: 01 00       NEG    $00
E664: FE 30 01    LDU    $3001
E667: D0 00       SUBB   $00
E669: 00 01       NEG    $01
E66B: 00 00       NEG    $00
E66D: 60 00       NEG    $0,X
E66F: 60 00       NEG    $0,X
E671: 40          NEGA
E672: 00 00       NEG    $00
E674: 01 00       NEG    $00
E676: 00 30       NEG    $30
E678: FF 30 01    STU    $3001
E67B: A0 E6       SUBA   A,S
E67D: 84 E6       ANDA   #$E6
E67F: C4 E7       ANDB   #$E7
E681: 04 E7       LSR    $E7
E683: 44          LSRA
E684: 82 82       SBCA   #$82
E686: 82 82       SBCA   #$82
E688: 82 82       SBCA   #$82
E68A: 82 82       SBCA   #$82
E68C: 00 00       NEG    $00
E68E: 00 00       NEG    $00
E690: 00 00       NEG    $00
E692: 00 00       NEG    $00
E694: 00 00       NEG    $00
E696: 00 00       NEG    $00
E698: 00 00       NEG    $00
E69A: 00 00       NEG    $00
E69C: 00 00       NEG    $00
E69E: 07 00       ASR    $00
E6A0: 00 00       NEG    $00
E6A2: 00 00       NEG    $00
E6A4: 00 00       NEG    $00
E6A6: 07 06       ASR    $06
E6A8: 00 00       NEG    $00
E6AA: 06 06       ROR    $06
E6AC: 00 00       NEG    $00
E6AE: 00 00       NEG    $00
E6B0: 00 00       NEG    $00
E6B2: 00 06       NEG    $06
E6B4: 00 00       NEG    $00
E6B6: 00 00       NEG    $00
E6B8: 00 00       NEG    $00
E6BA: 00 00       NEG    $00
E6BC: 00 00       NEG    $00
E6BE: 00 00       NEG    $00
E6C0: 00 00       NEG    $00
E6C2: 00 00       NEG    $00
E6C4: 82 82       SBCA   #$82
E6C6: 82 00       SBCA   #$00
E6C8: 82 82       SBCA   #$82
E6CA: 82 82       SBCA   #$82
E6CC: 08 08       ASL    $08
E6CE: 08 08       ASL    $08
E6D0: 00 00       NEG    $00
E6D2: 00 00       NEG    $00
E6D4: 00 00       NEG    $00
E6D6: 60 60       NEG    $0,S
E6D8: 66 66       ROR    $6,S
E6DA: 67 67       ASR    $7,S
E6DC: 43          COMA
E6DD: 47          ASRA
E6DE: 00 00       NEG    $00
E6E0: 10 47       ASRA
E6E2: 47          ASRA
E6E3: 86 82       LDA    #$82
E6E5: 42          XNCA
E6E6: 47          ASRA
E6E7: 86 47       LDA    #$47
E6E9: 47          ASRA
E6EA: 47          ASRA
E6EB: 47          ASRA
E6EC: 00 00       NEG    $00
E6EE: 00 01       NEG    $01
E6F0: 47          ASRA
E6F1: 47          ASRA
E6F2: 00 47       NEG    $47
E6F4: C2 00       SBCB   #$00
E6F6: 00 01       NEG    $01
E6F8: 00 46       NEG    $46
E6FA: 00 00       NEG    $00
E6FC: 00 00       NEG    $00
E6FE: 00 00       NEG    $00
E700: 00 00       NEG    $00
E702: 00 00       NEG    $00
E704: 87 87       XSTA   #$87
E706: 87 87       XSTA   #$87
E708: 87 87       XSTA   #$87
E70A: 87 87       XSTA   #$87
E70C: 10          FCB    $10
E70D: 10          FCB    $10
E70E: 10          FCB    $10
E70F: 10 A0 A0    SUBA   ,Y+
E712: A6 A6       LDA    A,Y
E714: A7 A7       STA    E,Y
E716: 00 00       NEG    $00
E718: 00 00       NEG    $00
E71A: 00 00       NEG    $00
E71C: 46          RORA
E71D: 00 00       NEG    $00
E71F: 00 08       NEG    $08
E721: 00 00       NEG    $00
E723: 86 82       LDA    #$82
E725: 42          XNCA
E726: 87 87       XSTA   #$87
E728: 87 87       XSTA   #$87
E72A: 87 87       XSTA   #$87
E72C: 00 00       NEG    $00
E72E: 00 00       NEG    $00
E730: 82 82       SBCA   #$82
E732: 00 87       NEG    $87
E734: C2 00       SBCB   #$00
E736: 00 01       NEG    $01
E738: 87 87       XSTA   #$87
E73A: 00 00       NEG    $00
E73C: 00 00       NEG    $00
E73E: 00 00       NEG    $00
E740: 00 00       NEG    $00
E742: 00 00       NEG    $00
E744: 87 87       XSTA   #$87
E746: 87 87       XSTA   #$87
E748: 87 87       XSTA   #$87
E74A: 87 87       XSTA   #$87
E74C: 00 00       NEG    $00
E74E: 00 00       NEG    $00
E750: 00 00       NEG    $00
E752: 00 00       NEG    $00
E754: 00 00       NEG    $00
E756: 00 00       NEG    $00
E758: 00 00       NEG    $00
E75A: 00 00       NEG    $00
E75C: 00 00       NEG    $00
E75E: 00 C6       NEG    $C6
E760: 00 00       NEG    $00
E762: 00 00       NEG    $00
E764: 00 00       NEG    $00
E766: 00 C6       NEG    $C6
E768: C7 C7       XSTB   #$C7
E76A: 00 00       NEG    $00
E76C: 00 00       NEG    $00
E76E: 00 00       NEG    $00
E770: 00 00       NEG    $00
E772: 00 00       NEG    $00
E774: C2 82       SBCB   #$82
E776: C7 00       XSTB   #$00
E778: 00 00       NEG    $00
E77A: 00 00       NEG    $00
E77C: 00 00       NEG    $00
E77E: 00 00       NEG    $00
E780: 00 00       NEG    $00
E782: 00 00       NEG    $00
E784: D9 3C       ADCB   $3C
E786: D9 50       ADCB   $50
E788: D9 40       ADCB   $40
E78A: D9 44       ADCB   $44
E78C: D9 48       ADCB   $48
E78E: D9 4C       ADCB   $4C
E790: D9 FC       ADCB   $FC
E792: DA 0C       ORB    $0C
E794: D9 80       ADCB   $80
E796: D9 90       ADCB   $90
E798: D9 A0       ADCB   $A0
E79A: D9 C8       ADCB   $C8
E79C: D9 E4       ADCB   $E4
E79E: D9 F0       ADCB   $F0
E7A0: D9 3C       ADCB   $3C
E7A2: D9 3C       ADCB   $3C
E7A4: D9 68       ADCB   $68
E7A6: D9 90       ADCB   $90
E7A8: D9 3C       ADCB   $3C
E7AA: DA 1C       ORB    $1C
E7AC: DA 34       ORB    $34
E7AE: D9 3C       ADCB   $3C
E7B0: DA 4C       ORB    $4C
E7B2: DA 64       ORB    $64
E7B4: DA 98       ORB    $98
E7B6: DA 9C       ORB    $9C
E7B8: DA A0       ORB    $A0
E7BA: DA A4       ORB    $A4
E7BC: D9 3C       ADCB   $3C
E7BE: D9 3C       ADCB   $3C
E7C0: D9 80       ADCB   $80
E7C2: D9 3C       ADCB   $3C
E7C4: D9 3C       ADCB   $3C
E7C6: D9 3C       ADCB   $3C
E7C8: D9 3C       ADCB   $3C
E7CA: D9 3C       ADCB   $3C
E7CC: D9 3C       ADCB   $3C
E7CE: D9 3C       ADCB   $3C
E7D0: D9 3C       ADCB   $3C
E7D2: D9 50       ADCB   $50
E7D4: DA E0       ORB    $E0
E7D6: DA F0       ORB    $F0
E7D8: DA 4C       ORB    $4C
E7DA: DA 7C       ORB    $7C
E7DC: D9 3C       ADCB   $3C
E7DE: D9 3C       ADCB   $3C
E7E0: D9 3C       ADCB   $3C
E7E2: D9 3C       ADCB   $3C
E7E4: D9 3C       ADCB   $3C
E7E6: D9 3C       ADCB   $3C
E7E8: D9 3C       ADCB   $3C
E7EA: D9 3C       ADCB   $3C
E7EC: D9 3C       ADCB   $3C
E7EE: DB 00       ADDB   $00
E7F0: DB 1C       ADDB   $1C
E7F2: DD 94       STD    $94
E7F4: DB 08       ADDB   $08
E7F6: DB 0C       ADDB   $0C
E7F8: DB 14       ADDB   $14
E7FA: DB 94       ADDB   $94
E7FC: DB A8       ADDB   $A8
E7FE: DB 4C       ADDB   $4C
E800: DB 58       ADDB   $58
E802: DB 64       ADDB   $64
E804: DD 20       STD    $20
E806: DB 84       ADDB   $84
E808: DB 8C       ADDB   $8C
E80A: DB C8       ADDB   $C8
E80C: DC FC       LDD    $FC
E80E: DB 34       ADDB   $34
E810: DB BC       ADDB   $BC
E812: DB EC       ADDB   $EC
E814: DC 00       LDD    $00
E816: DC 18       LDD    $18
E818: DB 18       ADDB   $18
E81A: DC BC       LDD    $BC
E81C: DC E4       LDD    $E4
E81E: DC 30       LDD    $30
E820: DC 5C       LDD    $5C
E822: DC 88       LDD    $88
E824: DC 30       LDD    $30
E826: DB 00       ADDB   $00
E828: DB 00       ADDB   $00
E82A: DC 30       LDD    $30
E82C: DC 5C       LDD    $5C
E82E: DB 00       ADDB   $00
E830: DD 40       STD    $40
E832: DD 68       STD    $68
E834: DD B8       STD    $B8
E836: DD FC       STD    $FC
E838: DE 34       LDU    $34
E83A: DE 7C       LDU    $7C
E83C: DB 1C       ADDB   $1C
E83E: DB 94       ADDB   $94
E840: DB A8       ADDB   $A8
E842: DC BC       LDD    $BC
E844: DC DC       LDD    $DC
E846: DE 90       LDU    $90
E848: DE A4       LDU    $A4
E84A: DE B8       LDU    $B8
E84C: DE C8       LDU    $C8
E84E: DE CC       LDU    $CC
E850: DE FC       LDU    $FC
E852: DE F0       LDU    $F0
E854: DF 1C       STU    $1C
E856: DF 24       STU    $24
E858: DF 4C       STU    $4C
E85A: DF 2C       STU    $2C
E85C: DF 4C       STU    $4C
E85E: DF 4C       STU    $4C
E860: DF 4C       STU    $4C
E862: DF 4C       STU    $4C
E864: DF B4       STU    $B4
E866: DF 4C       STU    $4C
E868: DF 4C       STU    $4C
E86A: DF 4C       STU    $4C
E86C: DF 4C       STU    $4C
E86E: DF 4C       STU    $4C
E870: DF 4C       STU    $4C
E872: DF 4C       STU    $4C
E874: DF 4C       STU    $4C
E876: DF 4C       STU    $4C
E878: DF 9C       STU    $9C
E87A: DF 5C       STU    $5C
E87C: DF D4       STU    $D4
E87E: DF 74       STU    $74
E880: DF 4C       STU    $4C
E882: DF 4C       STU    $4C
E884: DF 4C       STU    $4C
E886: DF 4C       STU    $4C
E888: DF E8       STU    $E8
E88A: DF E8       STU    $E8
E88C: DF E8       STU    $E8
E88E: DF E8       STU    $E8
E890: DF 4C       STU    $4C
E892: DF 4C       STU    $4C
E894: DF 4C       STU    $4C
E896: DF 4C       STU    $4C
E898: DF 4C       STU    $4C
E89A: DF 4C       STU    $4C
E89C: DF 4C       STU    $4C
E89E: DF 4C       STU    $4C
E8A0: DF 4C       STU    $4C
E8A2: DF 4C       STU    $4C
E8A4: DF 4C       STU    $4C
E8A6: DF 84       STU    $84
E8A8: DF 4C       STU    $4C
E8AA: DF 4C       STU    $4C
E8AC: DF 4C       STU    $4C
E8AE: DF 4C       STU    $4C
E8B0: E8 B8 E8    EORB   [-$18,Y]
E8B3: C2 E8       SBCB   #$E8
E8B5: CC E8 D6    LDD    #$E8D6
E8B8: 60 00       NEG    $0,X
E8BA: 62 24       XNC    $4,Y
E8BC: 64 B5       LSR    [B,Y]
E8BE: 66 99 68 85 ROR    [$6885,X]
E8C2: 6A 4F       DEC    $F,U
E8C4: 6D 0D       TST    $D,X
E8C6: 70 00 73    NEG    >$0073
E8C9: 3E          XRES
E8CA: 75 A2 60    LSR    $A260
E8CD: 00 62       NEG    $62
E8CF: 24 64       BCC    $E935
E8D1: A7 66       STA    $6,S
E8D3: 84 68       ANDA   #$68
E8D5: 70 6A 3A    NEG    $6A3A
E8D8: 6C F8 6F    INC    [$6F,S]
E8DB: EB 73       ADDB   -$D,S
E8DD: 29 75       BVS    $E954
E8DF: 8D 00       BSR    $E8E1
E8E1: 01 00       NEG    $00
E8E3: 01 00       NEG    $00
E8E5: 01 00       NEG    $00
E8E7: 01 04       NEG    $04
E8E9: 01 06       NEG    $06
E8EB: 01 08       NEG    $08
E8ED: 01 0A       NEG    $0A
E8EF: 01 0C       NEG    $0C
E8F1: 02 0E       XNC    $0E
E8F3: 02 10       XNC    $10
E8F5: 02 12       XNC    $12
E8F7: 02 50       XNC    $50
E8F9: 01 52       NEG    $52
E8FB: 02 54       XNC    $54
E8FD: 03 56       COM    $56
E8FF: 04 22       LSR    $22
E901: 19          DAA
E902: 22 19       BHI    $E91D
E904: 22 19       BHI    $E91F
E906: 22 19       BHI    $E921
E908: 00 01       NEG    $01
E90A: 00 01       NEG    $01
E90C: 00 01       NEG    $01
E90E: 00 01       NEG    $01
E910: 00 01       NEG    $01
E912: 00 01       NEG    $01
E914: 00 01       NEG    $01
E916: 00 01       NEG    $01
E918: 00 01       NEG    $01
E91A: 00 01       NEG    $01
E91C: 00 01       NEG    $01
E91E: 00 01       NEG    $01
E920: 14          XHCF
E921: 01 14       NEG    $14
E923: 01 14       NEG    $14
E925: 01 14       NEG    $14
E927: 01 28       NEG    $28
E929: 01 28       NEG    $28
E92B: 01 28       NEG    $28
E92D: 01 28       NEG    $28
E92F: 01 20       NEG    $20
E931: 01 20       NEG    $20
E933: 01 20       NEG    $20
E935: 01 20       NEG    $20
E937: 01 1A       NEG    $1A
E939: 01 1A       NEG    $1A
E93B: 01 1A       NEG    $1A
E93D: 01 1A       NEG    $1A
E93F: 01 FF       NEG    $FF
E941: F8 FF F8    EORB   $FFF8
E944: FF F8 FF    STU    $F8FF
E947: FA FF F8    ORB    $FFF8
E94A: FF F8 FF    STU    $F8FF
E94D: F8 FF F8    EORB   $FFF8
E950: FF FA FF    STU    $FAFF
E953: F4 FF FE    ANDB   $FFFE
E956: FF FA E9    STU    $FAE9
E959: 5C          INCB
E95A: E9 66       ADCB   $6,S
E95C: E9 70       ADCB   -$10,S
E95E: E9 98 E9    ADCB   [-$17,X]
E961: C0 E9       SUBB   #$E9
E963: E8 EA       EORB   F,S
E965: 10 EA 38    ORB    -$8,Y
E968: EA 60       ORB    $0,S
E96A: EA 88 EA    ORB    -$16,X
E96D: B0 EA D8    SUBA   $EAD8
E970: 04 5E       LSR    $5E
E972: 00 16       NEG    $16
E974: 00 04       NEG    $04
E976: 5E          XCLRB
E977: 00 18       NEG    $18
E979: 00 04       NEG    $04
E97B: 5E          XCLRB
E97C: 00 18       NEG    $18
E97E: 00 04       NEG    $04
E980: 5D          TSTB
E981: 00 1A       NEG    $1A
E983: 00 04       NEG    $04
E985: 5E          XCLRB
E986: 00 1A       NEG    $1A
E988: 00 04       NEG    $04
E98A: 5E          XCLRB
E98B: 05 1A       LSR    $1A
E98D: 00 04       NEG    $04
E98F: 5E          XCLRB
E990: 05 18       LSR    $18
E992: 00 08       NEG    $08
E994: 5D          TSTB
E995: 00 1A       NEG    $1A
E997: 00 04       NEG    $04
E999: 5E          XCLRB
E99A: 00 16       NEG    $16
E99C: 00 04       NEG    $04
E99E: 5E          XCLRB
E99F: 00 18       NEG    $18
E9A1: 00 04       NEG    $04
E9A3: 5E          XCLRB
E9A4: 00 18       NEG    $18
E9A6: 00 04       NEG    $04
E9A8: 5D          TSTB
E9A9: 00 1A       NEG    $1A
E9AB: 00 04       NEG    $04
E9AD: 5E          XCLRB
E9AE: 00 1A       NEG    $1A
E9B0: 00 04       NEG    $04
E9B2: 5E          XCLRB
E9B3: 05 1A       LSR    $1A
E9B5: 00 04       NEG    $04
E9B7: 5E          XCLRB
E9B8: 05 18       LSR    $18
E9BA: 00 08       NEG    $08
E9BC: 5D          TSTB
E9BD: 00 1A       NEG    $1A
E9BF: 00 04       NEG    $04
E9C1: 5E          XCLRB
E9C2: 00 16       NEG    $16
E9C4: 00 04       NEG    $04
E9C6: 5E          XCLRB
E9C7: 00 18       NEG    $18
E9C9: 00 04       NEG    $04
E9CB: 5E          XCLRB
E9CC: 05 18       LSR    $18
E9CE: 00 04       NEG    $04
E9D0: 5D          TSTB
E9D1: 00 1A       NEG    $1A
E9D3: 00 08       NEG    $08
E9D5: 5E          XCLRB
E9D6: 00 1A       NEG    $1A
E9D8: 00 04       NEG    $04
E9DA: 5E          XCLRB
E9DB: 05 1A       LSR    $1A
E9DD: 00 04       NEG    $04
E9DF: 5E          XCLRB
E9E0: 05 18       LSR    $18
E9E2: 00 08       NEG    $08
E9E4: 5D          TSTB
E9E5: 00 1A       NEG    $1A
E9E7: 00 04       NEG    $04
E9E9: 5E          XCLRB
E9EA: 00 16       NEG    $16
E9EC: 00 04       NEG    $04
E9EE: 5E          XCLRB
E9EF: 00 18       NEG    $18
E9F1: 00 08       NEG    $08
E9F3: 5E          XCLRB
E9F4: 05 18       LSR    $18
E9F6: 00 04       NEG    $04
E9F8: 5D          TSTB
E9F9: 00 1A       NEG    $1A
E9FB: 00 08       NEG    $08
E9FD: 5E          XCLRB
E9FE: 00 1A       NEG    $1A
EA00: 00 04       NEG    $04
EA02: 5E          XCLRB
EA03: 05 1A       LSR    $1A
EA05: 00 04       NEG    $04
EA07: 5E          XCLRB
EA08: 05 18       LSR    $18
EA0A: 00 08       NEG    $08
EA0C: 5D          TSTB
EA0D: 00 1A       NEG    $1A
EA0F: 00 08       NEG    $08
EA11: 5E          XCLRB
EA12: 20 16       BRA    $EA2A
EA14: 00 04       NEG    $04
EA16: 5E          XCLRB
EA17: 20 29       BRA    $EA42
EA19: 00 08       NEG    $08
EA1B: 5E          XCLRB
EA1C: 25 18       BCS    $EA36
EA1E: 00 04       NEG    $04
EA20: 5D          TSTB
EA21: 25 1A       BCS    $EA3D
EA23: 00 08       NEG    $08
EA25: 5E          XCLRB
EA26: 20 1A       BRA    $EA42
EA28: 00 04       NEG    $04
EA2A: 5E          XCLRB
EA2B: 25 1A       BCS    $EA47
EA2D: 00 04       NEG    $04
EA2F: 5E          XCLRB
EA30: 25 18       BCS    $EA4A
EA32: 00 08       NEG    $08
EA34: 5D          TSTB
EA35: 20 1A       BRA    $EA51
EA37: 00 08       NEG    $08
EA39: 5E          XCLRB
EA3A: 20 36       BRA    $EA72
EA3C: 00 04       NEG    $04
EA3E: 5E          XCLRB
EA3F: 25 3A       BCS    $EA7B
EA41: 00 08       NEG    $08
EA43: 5E          XCLRB
EA44: E3 3A       ADDD   -$6,Y
EA46: 00 04       NEG    $04
EA48: 5D          TSTB
EA49: 25 3A       BCS    $EA85
EA4B: 00 08       NEG    $08
EA4D: 5E          XCLRB
EA4E: E3 3A       ADDD   -$6,Y
EA50: 00 04       NEG    $04
EA52: 5E          XCLRB
EA53: 25 BA       BCS    $EA0F
EA55: 00 04       NEG    $04
EA57: 5E          XCLRB
EA58: 2A 38       BPL    $EA92
EA5A: 00 08       NEG    $08
EA5C: 5D          TSTB
EA5D: 20 3A       BRA    $EA99
EA5F: 00 08       NEG    $08
EA61: 5E          XCLRB
EA62: 00 36       NEG    $36
EA64: 00 04       NEG    $04
EA66: 5E          XCLRB
EA67: 05 38       LSR    $38
EA69: 00 08       NEG    $08
EA6B: 5E          XCLRB
EA6C: 00 3A       NEG    $3A
EA6E: 00 04       NEG    $04
EA70: 5D          TSTB
EA71: 05 3A       LSR    $3A
EA73: 00 08       NEG    $08
EA75: 5E          XCLRB
EA76: 0A BA       DEC    $BA
EA78: 00 04       NEG    $04
EA7A: 5E          XCLRB
EA7B: 05 BA       LSR    $BA
EA7D: 00 04       NEG    $04
EA7F: 5E          XCLRB
EA80: 05 3A       LSR    $3A
EA82: 00 08       NEG    $08
EA84: 5D          TSTB
EA85: 00 3A       NEG    $3A
EA87: 00 08       NEG    $08
EA89: 5E          XCLRB
EA8A: 25 36       BCS    $EAC2
EA8C: 00 04       NEG    $04
EA8E: 5E          XCLRB
EA8F: 35 3A       PULS   A,DP,X,Y
EA91: 00 08       NEG    $08
EA93: 5E          XCLRB
EA94: 2A 3A       BPL    $EAD0
EA96: 00 04       NEG    $04
EA98: 5D          TSTB
EA99: 25 3A       BCS    $EAD5
EA9B: 00 08       NEG    $08
EA9D: 5E          XCLRB
EA9E: 2A 3A       BPL    $EADA
EAA0: 00 04       NEG    $04
EAA2: 5E          XCLRB
EAA3: 25 3A       BCS    $EADF
EAA5: 00 04       NEG    $04
EAA7: 5E          XCLRB
EAA8: 25 BA       BCS    $EA64
EAAA: 00 08       NEG    $08
EAAC: 5D          TSTB
EAAD: 20 3A       BRA    $EAE9
EAAF: 00 08       NEG    $08
EAB1: 5E          XCLRB
EAB2: 25 36       BCS    $EAEA
EAB4: 00 04       NEG    $04
EAB6: 5E          XCLRB
EAB7: 25 3A       BCS    $EAF3
EAB9: 00 08       NEG    $08
EABB: 5E          XCLRB
EABC: E3 3A       ADDD   -$6,Y
EABE: 00 04       NEG    $04
EAC0: 5D          TSTB
EAC1: 25 3A       BCS    $EAFD
EAC3: 00 08       NEG    $08
EAC5: 5E          XCLRB
EAC6: 25 3A       BCS    $EB02
EAC8: 00 04       NEG    $04
EACA: 5E          XCLRB
EACB: 25 BA       BCS    $EA87
EACD: 00 08       NEG    $08
EACF: 5E          XCLRB
EAD0: 25 BA       BCS    $EA8C
EAD2: 00 08       NEG    $08
EAD4: 5D          TSTB
EAD5: 20 3A       BRA    $EB11
EAD7: 00 08       NEG    $08
EAD9: 5E          XCLRB
EADA: 25 36       BCS    $EB12
EADC: 00 04       NEG    $04
EADE: 5E          XCLRB
EADF: 25 3A       BCS    $EB1B
EAE1: 00 08       NEG    $08
EAE3: 5E          XCLRB
EAE4: 2A 3A       BPL    $EB20
EAE6: 00 04       NEG    $04
EAE8: 5D          TSTB
EAE9: BA BA 00    ORA    $BA00
EAEC: 04 5E       LSR    $5E
EAEE: 2A 3A       BPL    $EB2A
EAF0: 00 08       NEG    $08
EAF2: 5E          XCLRB
EAF3: 25 BA       BCS    $EAAF
EAF5: 00 08       NEG    $08
EAF7: 5E          XCLRB
EAF8: FF BA 00    STU    $BA00
EAFB: 08 5D       ASL    $5D
EAFD: 25 3A       BCS    $EB39
EAFF: 00 01       NEG    $01
EB01: 05 1D       LSR    $1D
EB03: 05 19       LSR    $19
EB05: 29 19       BVS    $EB20
EB07: 05 19       LSR    $19
EB09: 1D          SEX
EB0A: 05 05       LSR    $05
EB0C: 2D 19       BLT    $EB27
EB0E: 1D          SEX
EB0F: 1E 1E       EXG    X,inv
EB11: 1D          SEX
EB12: 1A 05       ORCC   #$05
EB14: 19          DAA
EB15: 05 08       LSR    $08
EB17: 29 19       BVS    $EB32
EB19: 19          DAA
EB1A: 05 05       LSR    $05
EB1C: 1D          SEX
EB1D: 1D          SEX
EB1E: 2D 1D       BLT    $EB3D
EB20: 19          DAA
EB21: 19          DAA
EB22: 05 1D       LSR    $1D
EB24: 19          DAA
EB25: 19          DAA
EB26: 80 EB       SUBA   #$EB
EB28: 67 EB       ASR    D,S
EB2A: 78 EB 87    ASL    $EB87
EB2D: EB 96       ADDB   [A,X]
EB2F: EB A9 EB B9 ADDB   -$1447,Y
EB33: EB C6       ADDB   A,U
EB35: EB D5       ADDB   [B,U]
EB37: EB E4       ADDB   ,S
EB39: EB F7       ADDB   [E,S]
EB3B: EC 08       LDD    $8,X
EB3D: EC 16       LDD    -$A,X
EB3F: EC 24       LDD    $4,Y
EB41: EC 31       LDD    -$F,Y
EB43: EC 41       LDD    $1,U
EB45: EC 4C       LDD    $C,U
EB47: EC 5B       LDD    -$5,U
EB49: EC 69       LDD    $9,S
EB4B: EC 74       LDD    -$C,S
EB4D: EC 7F       LDD    -$1,S
EB4F: EC 8F       LDD    ,W
EB51: EC A2       LDD    ,-Y
EB53: EC B2       LDD    Illegal Postbyte
EB55: EC C0       LDD    ,U+
EB57: EC CF       LDD    ,W++
EB59: EC DE       LDD    [W,U]
EB5B: EC EF       LDD    ,--W
EB5D: ED 00       STD    $0,X
EB5F: ED 12       STD    -$E,X
EB61: ED 23       STD    $3,Y
EB63: ED 34       STD    -$C,Y
EB65: ED 44       STD    $4,U
EB67: B1 B1 B5    CMPA   $B1B5
EB6A: B1 B6 B6    CMPA   $B6B6
EB6D: B1 B6 C5    CMPA   $B6C5
EB70: D2 06       SBCB   $06
EB72: 06 06       ROR    $06
EB74: F6 F6 F6    LDB    $F6F6
EB77: FF B1 B1    STU    $B1B1
EB7A: B5 B1 B1    BITA   $B1B1
EB7D: C1 B1       CMPB   #$B1
EB7F: D2 06       SBCB   $06
EB81: 4A          DECA
EB82: 05 95       LSR    $95
EB84: 95 95       BITA   $95
EB86: FF B1 B1    STU    $B1B1
EB89: C1 F3       CMPB   #$F3
EB8B: B1 B1 B6    CMPA   $B1B6
EB8E: B6 F5 B5    LDA    $F5B5
EB91: B5 F5 B1    BITA   $F5B1
EB94: B1 FF B1    CMPA   $FFB1
EB97: C5 F4       BITB   #$F4
EB99: B1 B6 B1    CMPA   $B6B1
EB9C: D2 96       SBCB   $96
EB9E: CE C5 B1    LDU    #$C5B1
EBA1: B5 B1 F2    BITA   $B1F2
EBA4: D2 96       SBCB   $96
EBA6: 96 96       LDA    $96
EBA8: FF B1 F4    STU    $B1F4
EBAB: B1 B5 B1    CMPA   $B5B1
EBAE: B1 F4 C9    CMPA   $F4C9
EBB1: D1 05       CMPB   $05
EBB3: CD          XHCF
EBB4: C9 B1       ADCB   #$B1
EBB6: B5 B5 FF    BITA   $B5FF
EBB9: B1 B6 B6    CMPA   $B6B6
EBBC: B1 D2 06    CMPA   $D206
EBBF: 06 06       ROR    $06
EBC1: F6 F6 F6    LDB    $F6F6
EBC4: F6 FF B1    LDB    $FFB1
EBC7: B5 F3 C1    BITA   $F3C1
EBCA: B5 B5 B5    BITA   $B5B5
EBCD: B5 F3 C1    BITA   $F3C1
EBD0: D2 06       SBCB   $06
EBD2: 06 06       ROR    $06
EBD4: FF B1 B1    STU    $B1B1
EBD7: B1 B1 F3    CMPA   $B1F3
EBDA: C1 B6       CMPB   #$B6
EBDC: B6 C2 F0    LDA    $C2F0
EBDF: D2 06       SBCB   $06
EBE1: 06 06       ROR    $06
EBE3: FF B9 B9    STU    $B9B9
EBE6: F0 F4 B9    SUBB   $F4B9
EBE9: B9 B9 F3    ADCA   $B9F3
EBEC: C1 B9       CMPB   #$B9
EBEE: B9 C9 D2    ADCA   $C9D2
EBF1: 06 06       ROR    $06
EBF3: 06 06       ROR    $06
EBF5: 06 FF       ROR    $FF
EBF7: B1 C9 B1    CMPA   $C9B1
EBFA: C9 B1       ADCB   #$B1
EBFC: C9 C9       ADCB   #$C9
EBFE: F4 C9 D2    ANDB   $C9D2
EC01: 06 06       ROR    $06
EC03: CE B1 C9    LDU    #$B1C9
EC06: C9 FF       ADCB   #$FF
EC08: B1 B1 B1    CMPA   $B1B1
EC0B: F4 C9 D2    ANDB   $C9D2
EC0E: 06 CE       ROR    $CE
EC10: C9 B1       ADCB   #$B1
EC12: B5 B1 F6    BITA   $B1F6
EC15: FF B1 B1    STU    $B1B1
EC18: B1 F4 C9    CMPA   $F4C9
EC1B: D1 05       CMPB   $05
EC1D: CD          XHCF
EC1E: C9 B9       ADCB   #$B9
EC20: B9 B9 F6    ADCA   $B9F6
EC23: FF 06 06    STU    $0606
EC26: 02 F5       XNC    $F5
EC28: 46          RORA
EC29: F6 F5 1A    LDB    $F51A
EC2C: F0 46 F6    SUBB   $46F6
EC2F: F6 FF 02    LDB    $FF02
EC32: 46          RORA
EC33: 06 4A       ROR    $4A
EC35: 05 49       LSR    $49
EC37: 06 4A       ROR    $4A
EC39: 05 49       LSR    $49
EC3B: 02 4E       XNC    $4E
EC3D: F4 4E F6    ANDB   $4EF6
EC40: FF 02 F6    STU    $02F6
EC43: 46          RORA
EC44: F6 F4 46    LDB    $F446
EC47: F6 F6 F6    LDB    $F6F6
EC4A: F6 FF 02    LDB    $FF02
EC4D: 46          RORA
EC4E: F5 F4 46    BITB   $F446
EC51: F5 46 F6    BITB   $46F6
EC54: 4E          XCLRA
EC55: 4E          XCLRA
EC56: F0 F0 46    SUBB   $F046
EC59: 46          RORA
EC5A: FF B2 B2    STU    $B2B2
EC5D: B6 B6 B6    LDA    $B6B6
EC60: B6 B2 B2    LDA    $B2B2
EC63: B5 B5 B5    BITA   $B5B5
EC66: B5 B1 B1    BITA   $B1B1
EC69: B2 B2 B2    SBCA   $B2B2
EC6C: B2 B2 B2    SBCA   $B2B2
EC6F: B6 B6 B2    LDA    $B6B2
EC72: B2 B2 B2    SBCA   $B2B2
EC75: B2 B2 B2    SBCA   $B2B2
EC78: B6 B6 B2    LDA    $B6B2
EC7B: B2 B2 B2    SBCA   $B2B2
EC7E: B2 B1 B6    SBCA   $B1B6
EC81: B6 B1 D2    LDA    $B1D2
EC84: 06 4A       ROR    $4A
EC86: 05 49       LSR    $49
EC88: 06 06       ROR    $06
EC8A: 06 F6       ROR    $F6
EC8C: F6 F6 FF    LDB    $F6FF
EC8F: B1 C9 B1    CMPA   $C9B1
EC92: C9 B1       ADCB   #$B1
EC94: C9 B1       ADCB   #$B1
EC96: C9 C9       ADCB   #$C9
EC98: B1 C9 C9    CMPA   $C9C9
EC9B: C9 B1       ADCB   #$B1
EC9D: D2 06       SBCB   $06
EC9F: 06 06       ROR    $06
ECA1: FF B1 B6    STU    $B1B6
ECA4: B6 B1 D2    LDA    $B1D2
ECA7: 06 CE       ROR    $CE
ECA9: 05 CD       LSR    $CD
ECAB: 06 06       ROR    $06
ECAD: 06 06       ROR    $06
ECAF: F6 F6 FF    LDB    $F6FF
ECB2: B1 B1 C1    CMPA   $B1C1
ECB5: B5 B5 B5    BITA   $B5B5
ECB8: B5 D2 06    BITA   $D206
ECBB: 06 06       ROR    $06
ECBD: 06 06       ROR    $06
ECBF: FF B1 B1    STU    $B1B1
ECC2: C1 B1       CMPB   #$B1
ECC4: B1 B6 B6    CMPA   $B6B6
ECC7: C9 C9       ADCB   #$C9
ECC9: B5 B5 B5    BITA   $B5B5
ECCC: C9 B5       ADCB   #$B5
ECCE: FF C9 F3    STU    $C9F3
ECD1: 06 06       ROR    $06
ECD3: 06 06       ROR    $06
ECD5: CE B1 B5    LDU    #$B1B5
ECD8: B1 B6 B1    CMPA   $B6B1
ECDB: B6 B1 FF    LDA    $B1FF
ECDE: B1 C9 C1    CMPA   $C9C1
ECE1: F4 C9 C9    ANDB   $C9C9
ECE4: F4 B1 B1    ANDB   $B1B1
ECE7: F4 B1 B1    ANDB   $B1B1
ECEA: D1 95       CMPB   $95
ECEC: 95 CD       BITA   $CD
ECEE: FF B1 C9    STU    $B1C9
ECF1: C2 D2       SBCB   #$D2
ECF3: 96 96       LDA    $96
ECF5: CE B1 B1    LDU    #$B1B1
ECF8: F4 B1 B1    ANDB   $B1B1
ECFB: F4 CA CA    ANDB   $CACA
ECFE: B1 FF 02    CMPA   $FF02
ED01: 46          RORA
ED02: F5 F0 06    BITB   $F006
ED05: 46          RORA
ED06: F6 F4 4A    LDB    $F44A
ED09: 05 05       LSR    $05
ED0B: 45          LSRA
ED0C: F6 F4 4A    LDB    $F44A
ED0F: 06 F6       ROR    $F6
ED11: FF B1 B1    STU    $B1B1
ED14: D1 05       CMPB   $05
ED16: F4 F2 95    ANDB   $F295
ED19: 95 49       BITA   $49
ED1B: 06 CE       ROR    $CE
ED1D: C9 B6       ADCB   #$B6
ED1F: B6 B6 B6    LDA    $B6B6
ED22: FF B1 B1    STU    $B1B1
ED25: D2 06       SBCB   $06
ED27: F4 F2 96    ANDB   $F296
ED2A: 96 4A       LDA    $4A
ED2C: 05 CD       LSR    $CD
ED2E: C9 B5       ADCB   #$B5
ED30: B5 B5 B5    BITA   $B5B5
ED33: FF B1 C9    STU    $B1C9
ED36: C2 D2       SBCB   #$D2
ED38: 96 96       LDA    $96
ED3A: CE B5 B6    LDU    #$B5B6
ED3D: B1 C9 B1    CMPA   $C9B1
ED40: B1 C9 F1    CMPA   $C9F1
ED43: FF B1 C9    STU    $B1C9
ED46: C1 D1       CMPB   #$D1
ED48: 95 95       BITA   $95
ED4A: CD          XHCF
ED4B: B5 B6 B1    BITA   $B6B1
ED4E: C9 B1       ADCB   #$B1
ED50: B1 C9 F1    CMPA   $C9F1

FFF2: 00 00       NEG    $00
FFF4: 00 00       NEG    $00
FFF6: 00 00       NEG    $00
FFF8: 81 73       CMPA   #$73
FFFA: 00 00       NEG    $00
FFFC: 81 73       CMPA   #$73
FFFE: 80 00       SUBA   #$00
