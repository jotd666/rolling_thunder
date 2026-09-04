;	map(0x1000, 0x13ff).rw(m_cus30, FUNC(namco_cus30_device::namcos1_cus30_r), FUNC(namco_cus30_device::namcos1_cus30_w));
;	map(0x1400, 0x1fff).ram();

nb_coins_inserted_98 = $98

F000: 4F       clra 
F001: 5F       clrb 
F002: 97 B0    sta  $B0
F004: B7 11 83 sta  nb_credits_1183
F007: FD 11 84 std  $1184
F00A: 7F 11 82 clr  $1182
F00D: 8E 13 FF lds  #$13FF
F010: BD F2 98 jsr  $F298
F013: BD F1 4A jsr  $F14A
F016: BD F0 BD jsr  $F0BD
F019: DE AE    ldx  $AE
F01B: EC 2E    ldd  $2E,x
F01D: DD AA    std  $AA
F01F: EC 2A    ldd  $2A,x
F021: DD AC    std  $AC
F023: DE AA    ldx  $AA
F025: AD 00    jsr  $00,x
F027: 96 08    lda  $08
F029: 4F       clra 
F02A: 5F       clrb 
F02B: DD 09    std  $09
F02D: 4C       inca 
F02E: DD 0B    std  $0B
F030: 96 08    lda  $08
F032: 8A 08    ora  #$08
F034: 97 08    sta  $08
F036: 0E       cli  
F037: 7F 11 91 clr  $1191
F03A: BD F0 DC jsr  $F0DC
F03D: BD F2 0A jsr  $F20A
F040: BD F0 95 jsr  $F095
F043: BD F0 B5 jsr  $F0B5
F046: 8E 00 C5 lds  #$00C5
F049: BD F2 AE jsr  $F2AE
F04C: DE AE    ldx  $AE
F04E: AE 12    lds  $12,x
F050: DE AE    ldx  $AE
F052: EE 1C    ldx  $1C,x
F054: AD 00    jsr  $00,x
F056: DE AE    ldx  $AE
F058: EE 28    ldx  $28,x
F05A: AD 00    jsr  $00,x
F05C: BD F2 49 jsr  $F249
F05F: DE AE    ldx  $AE
F061: EE 18    ldx  $18,x
F063: AD 00    jsr  $00,x
F065: 86 C0    lda  #$C0
F067: 97 14    sta  $14
F069: DE AE    ldx  $AE
F06B: 6D 7A    tst  $7A,x
F06D: 27 06    beq  $F075
F06F: 96 82    lda  $82
F071: 9B 80    adda $80
F073: 97 80    sta  $80
F075: 7F 00 82 clr  $0082
F078: DE AA    ldx  $AA
F07A: AD 00    jsr  $00,x
F07C: 86 A6    lda  #$A6
F07E: B7 11 82 sta  $1182
F081: DE AE    ldx  $AE
F083: EE 2C    ldx  $2C,x
F085: AD 00    jsr  $00,x
F087: DE AE    ldx  $AE
F089: EE 14    ldx  $14,x
F08B: AD 00    jsr  $00,x
F08D: DE AE    ldx  $AE
F08F: EE 16    ldx  $16,x
F091: AD 00    jsr  $00,x
F093: 20 EC    bra  $F081
F095: CC 40 FF ldd  #$40FF
F098: 97 00    sta  $00
F09A: D7 02    stb  $02
F09C: D7 00    stb  $00
F09E: D7 02    stb  $02
F0A0: CE F0 AD ldx  #$F0AD
F0A3: A6 00    lda  $00,x
F0A5: 27 05    beq  $F0AC
F0A7: 97 02    sta  $02
F0A9: 08       inx  
F0AA: 20 F7    bra  $F0A3
F0AC: 39       rts  
F0AD: C1 41    cmpb #$41
F0AF: 01       nop  
F0B0: 41       illegal
F0B1: C1 C0    cmpb #$C0
F0B3: E0 00    subb $00,x
F0B5: CE 11 00 ldx  #$1100
F0B8: C6 80    ldb  #$80
F0BA: 7E F3 5C jmp  $F35C
F0BD: DE AE    ldx  $AE
F0BF: E6 37    ldb  $37,x
F0C1: 27 34    beq  $F0F7
F0C3: 5F       clrb 
F0C4: F7 11 81 stb  $1181
F0C7: D7 CC    stb  $CC
F0C9: C6 A6    ldb  #$A6
F0CB: F7 11 80 stb  $1180
F0CE: F6 11 81 ldb  $1181
F0D1: C1 A6    cmpb #$A6
F0D3: 27 22    beq  $F0F7
F0D5: 7A 00 CC dec  $00CC
F0D8: 26 F4    bne  $F0CE
F0DA: 20 1B    bra  $F0F7
F0DC: DE AE    ldx  $AE
F0DE: E6 37    ldb  $37,x
F0E0: 27 15    beq  $F0F7
F0E2: 7F 11 81 clr  $1181
F0E5: C6 A6    ldb  #$A6
F0E7: F7 11 80 stb  $1180
F0EA: DE AE    ldx  $AE
F0EC: EE 14    ldx  $14,x
F0EE: AD 00    jsr  $00,x
F0F0: F6 11 81 ldb  $1181
F0F3: C1 A6    cmpb #$A6
F0F5: 26 F3    bne  $F0EA
F0F7: 7F 11 80 clr  $1180
F0FA: 39       rts  
F0FB: CE F0 00 ldx  #$F000
F0FE: 4F       clra 
F0FF: 5F       clrb 
F100: EB 00    addb $00,x
F102: 89 00    adca #$00
F104: 08       inx  
F105: 26 F9    bne  $F100
F107: 5D       tstb 
F108: 26 01    bne  $F10B
F10A: 39       rts  
F10B: 18       xgdx 
F10C: C6 05    ldb  #$05
F10E: 20 38    bra  $F148
F110: DE AE    ldx  $AE
F112: A6 30    lda  $30,x
F114: 8B 10    adda #$10
F116: 5F       clrb 
F117: CE 10 00 ldx  #$1000
F11A: BD F2 E3 jsr  $F2E3
F11D: 25 01    bcs  $F120
F11F: 39       rts  
F120: C6 02    ldb  #$02
F122: 20 24    bra  $F148
F124: B6 80 00 lda  $8000
F127: 81 A6    cmpa #$A6
F129: 26 19    bne  $F144
F12B: 5F       clrb 
F12C: DE AE    ldx  $AE
F12E: A6 31    lda  $31,x
F130: 8B 80    adda #$80
F132: DD A8    std  $A8
F134: CE 80 00 ldx  #$8000
F137: 4F       clra 
F138: EB 00    addb $00,x
F13A: 89 00    adca #$00
F13C: 08       inx  
F13D: 9C A8    cmpx $A8
F13F: 26 F7    bne  $F138
F141: 5D       tstb 
F142: 26 01    bne  $F145
F144: 39       rts  
F145: 18       xgdx 
F146: C6 03    ldb  #$03
F148: 20 41    bra  $F18B
F14A: CE 11 C0 ldx  #$11C0
F14D: DF AE    stx  $AE
F14F: DF C8    stx  $C8
F151: C6 7C    ldb  #$7C
F153: 3A       abx  
F154: DF CA    stx  $CA
F156: CE F1 8E ldx  #$F18E
F159: DF C6    stx  $C6
F15B: BD F3 64 jsr  $F364
F15E: B6 80 00 lda  $8000
F161: 81 A6    cmpa #$A6
F163: 26 23    bne  $F188
F165: CE 80 07 ldx  #$8007
F168: DF C6    stx  $C6
F16A: DE C6    ldx  $C6
F16C: E6 00    ldb  $00,x
F16E: C1 FF    cmpb #$FF
F170: 27 16    beq  $F188
F172: DE AE    ldx  $AE
F174: 3A       abx  
F175: DF C8    stx  $C8
F177: DE C6    ldx  $C6
F179: 08       inx  
F17A: E6 00    ldb  $00,x
F17C: 08       inx  
F17D: DF C6    stx  $C6
F17F: BD F3 64 jsr  $F364
F182: 9C CA    cmpx $CA
F184: 2E 03    bgt  $F189
F186: 20 E2    bra  $F16A
F188: 39       rts  
F189: C6 06    ldb  #$06
F18B: 7E F3 3F jmp  $F33F
F18E: C0 00    subb #$00
F190: 63 00    com  $00,x
F192: F0 0A 00 subb $0A00
F195: 00       illegal
F196: F3 CA 00 addd $CA00
F199: 01       nop  
F19A: F3 82 00 addd $8200
F19D: 02       illegal
F19E: 00       illegal
F19F: 03       illegal
F1A0: C7 FF    stb  #$FF
F1A2: F4 2B F4 andb $2BF4
F1A5: B1 F7 4E cmpa $F74E
F1A8: F7 87 FC stb  $87FC
F1AB: A2 FD    sbca $FD,x
F1AD: 6D F5    tst  $F5,x
F1AF: 06       tap  
F1B0: F5 F4 F6 bitb $F4F6
F1B3: 5E       illegal
F1B4: FD 97 FC std  $97FC
F1B7: D8 F3    eorb $F3
F1B9: 76 F3 7A ror  $F37A
F1BC: F3 7E 04 addd $7E04
F1BF: 20 08    bra  $F1C9
F1C1: 00       illegal
F1C2: CE C0 E0 ldx  #$C0E0
F1C5: 01       nop  
F1C6: FC 51 FF ldd  $51FF
F1C9: 64 FE    lsr  $FE,x
F1CB: F9 FF 01 adcb $FF01
F1CE: FE F3 FE ldx  $F3FE
F1D1: FF FE F1 stx  $FEF1
F1D4: FE F0 FE ldx  $F0FE
F1D7: FD 13 08 std  $1308
F1DA: 12       asx1 1,s
F1DB: 85 12    bita #$12
F1DD: C8 FE    eorb #$FE
F1DF: 81 FE    cmpa #$FE
F1E1: 81 00    cmpa #$00
F1E3: 12       asx1 1,s
F1E4: 3C       pshx 
F1E5: C0 7C    subb #$7C
F1E7: FE EA 12 ldx  $EA12
F1EA: 82 C0    sbca #$C0
F1EC: D7 04    stb  $04
F1EE: 0C       clc  
F1EF: 02       illegal
F1F0: 01       nop  
F1F1: 00       illegal
F1F2: 18       xgdx 
F1F3: 17       tba  
F1F4: 16       tab  
F1F5: 15       illegal
F1F6: 14       illegal
F1F7: 01       nop  
F1F8: 01       nop  
F1F9: 00       illegal
F1FA: 00       illegal
F1FB: 00       illegal
F1FC: F2 C7 00 sbcb $C700
F1FF: 03       illegal
F200: F2 D7 08 sbcb $D708
F203: 02       illegal
F204: 0A       clv  
F205: 63 02    com  $02,x
F207: 03       illegal
F208: 00       illegal
F209: 00       illegal
F20A: DE AE    ldx  $AE
F20C: DF C6    stx  $C6
F20E: EE 00    ldx  $00,x
F210: 27 0D    beq  $F21F
F212: DF C8    stx  $C8
F214: DF CA    stx  $CA
F216: C6 7C    ldb  #$7C
F218: BD F3 64 jsr  $F364
F21B: DE CA    ldx  $CA
F21D: DF AE    stx  $AE
F21F: 39       rts  
F220: DE AE    ldx  $AE
F222: EC 33    ldd  $33,x
F224: CE 00 B1 ldx  #$00B1
F227: BD F2 E3 jsr  $F2E3
F22A: 25 01    bcs  $F22D
F22C: 39       rts  
F22D: C6 01    ldb  #$01
F22F: 20 15    bra  $F246
F231: DE AE    ldx  $AE
F233: A6 32    lda  $32,x
F235: 27 0C    beq  $F243
F237: EC 35    ldd  $35,x
F239: 27 08    beq  $F243
F23B: CE C0 00 ldx  #$C000
F23E: BD F2 E3 jsr  $F2E3
F241: 25 03    bcs  $F246
F243: 39       rts  
F244: C6 04    ldb  #$04
F246: 7E F3 3F jmp  $F33F
F249: DE AE    ldx  $AE
F24B: A6 6B    lda  $6B,x
F24D: 26 3E    bne  $F28D
F24F: EC 57    ldd  $57,x
F251: DD C8    std  $C8
F253: 86 02    lda  #$02
F255: 97 C7    sta  $C7
F257: 3C       pshx 
F258: 4F       clra 
F259: E6 70    ldb  $70,x
F25B: 05       asld 
F25C: D3 C8    addd $C8
F25E: 37       pshb 
F25F: 36       psha 
F260: E6 71    ldb  $71,x
F262: 38       pulx 
F263: 8D 17    bsr  $F27C
F265: 38       pulx 
F266: 3C       pshx 
F267: EE 6E    ldx  $6E,x
F269: 3A       abx  
F26A: DC 87    ldd  $87
F26C: DD 85    std  $85
F26E: EC 00    ldd  $00,x
F270: DD 87    std  $87
F272: 38       pulx 
F273: C6 04    ldb  #$04
F275: 3A       abx  
F276: 7A 00 C7 dec  $00C7
F279: 26 DC    bne  $F257
F27B: 39       rts  
F27C: D7 C6    stb  $C6
F27E: 4F       clra 
F27F: E6 01    ldb  $01,x
F281: 08       inx  
F282: 08       inx  
F283: 48       asla 
F284: 1B       aba  
F285: 7A 00 C6 dec  $00C6
F288: 26 F5    bne  $F27F
F28A: 48       asla 
F28B: 16       tab  
F28C: 39       rts  
F28D: EE 6C    ldx  $6C,x
F28F: EC 00    ldd  $00,x
F291: DD 85    std  $85
F293: EC 02    ldd  $02,x
F295: DD 87    std  $87
F297: 39       rts  
F298: CE 00 B1 ldx  #$00B1
F29B: C6 1D    ldb  #$1D
F29D: 96 14    lda  $14
F29F: 84 80    anda #$80
F2A1: B7 11 8F sta  $118F
F2A4: 26 05    bne  $F2AB
F2A6: CE 00 80 ldx  #$0080
F2A9: C6 80    ldb  #$80
F2AB: 7E F3 5C jmp  $F35C
F2AE: DE AE    ldx  $AE
F2B0: A6 30    lda  $30,x
F2B2: 8B 10    adda #$10
F2B4: 5F       clrb 
F2B5: DD A8    std  $A8
F2B7: CE 11 88 ldx  #$1188
F2BA: 6F 00    clr  $00,x
F2BC: 8D 70    bsr  $F32E
F2BE: 9C A8    cmpx $A8
F2C0: 26 F8    bne  $F2BA
F2C2: 97 A6    sta  $A6
F2C4: 97 A7    sta  $A7
F2C6: 39       rts  
F2C7: 01       nop  
F2C8: 01       nop  
F2C9: 01       nop  
F2CA: 02       illegal
F2CB: 01       nop  
F2CC: 03       illegal
F2CD: 01       nop  
F2CE: 05       asld 
F2CF: 01       nop  
F2D0: 06       tap  
F2D1: 02       illegal
F2D2: 01       nop  
F2D3: 02       illegal
F2D4: 03       illegal
F2D5: 03       illegal
F2D6: 01       nop  
F2D7: 01       nop  
F2D8: 01       nop  
F2D9: 01       nop  
F2DA: 02       illegal
F2DB: 02       illegal
F2DC: 01       nop  
F2DD: 02       illegal
F2DE: 03       illegal
F2DF: C6 07    ldb  #$07
F2E1: 20 5C    bra  $F33F
F2E3: DD A8    std  $A8
F2E5: 3C       pshx 
F2E6: 4F       clra 
F2E7: 4C       inca 
F2E8: 27 FD    beq  $F2E7
F2EA: A7 00    sta  $00,x
F2EC: 8D 40    bsr  $F32E
F2EE: 9C A8    cmpx $A8
F2F0: 26 F5    bne  $F2E7
F2F2: 38       pulx 
F2F3: 3C       pshx 
F2F4: 4F       clra 
F2F5: 4C       inca 
F2F6: 27 FD    beq  $F2F5
F2F8: A1 00    cmpa $00,x
F2FA: 26 2E    bne  $F32A
F2FC: 8D 30    bsr  $F32E
F2FE: 9C A8    cmpx $A8
F300: 26 F3    bne  $F2F5
F302: 38       pulx 
F303: 3C       pshx 
F304: 4F       clra 
F305: 4C       inca 
F306: 27 FD    beq  $F305
F308: 43       coma 
F309: A7 00    sta  $00,x
F30B: 43       coma 
F30C: 8D 20    bsr  $F32E
F30E: 9C A8    cmpx $A8
F310: 26 F3    bne  $F305
F312: 38       pulx 
F313: 3C       pshx 
F314: 4F       clra 
F315: 4C       inca 
F316: 27 FD    beq  $F315
F318: 43       coma 
F319: A1 00    cmpa $00,x
F31B: 26 0D    bne  $F32A
F31D: 6F 00    clr  $00,x
F31F: 43       coma 
F320: 8D 0C    bsr  $F32E
F322: 9C A8    cmpx $A8
F324: 26 EF    bne  $F315
F326: 31       ins  
F327: 31       ins  
F328: 0C       clc  
F329: 39       rts  
F32A: 31       ins  
F32B: 31       ins  
F32C: 0D       sec  
F32D: 39       rts  
F32E: 08       inx  
F32F: 8C 11 00 cmpx #$1100
F332: 26 03    bne  $F337
F334: C6 80    ldb  #$80
F336: 3A       abx  
F337: 9C AE    cmpx $AE
F339: 26 03    bne  $F33E
F33B: C6 7C    ldb  #$7C
F33D: 3A       abx  
F33E: 39       rts  
F33F: 7F 11 82 clr  $1182
F342: F7 11 85 stb  $1185
F345: FF 11 86 stx  $1186
F348: 86 A6    lda  #$A6
F34A: B7 11 84 sta  $1184
F34D: DE AE    ldx  $AE
F34F: 86 01    lda  #$01
F351: A7 37    sta  $37,x
F353: BD F0 DC jsr  $F0DC
F356: DE AE    ldx  $AE
F358: EE 04    ldx  $04,x
F35A: AD 00    jsr  $00,x
F35C: 4F       clra 
F35D: A7 00    sta  $00,x
F35F: 08       inx  
F360: 5A       decb 
F361: 26 FA    bne  $F35D
F363: 39       rts  
F364: DE C6    ldx  $C6
F366: A6 00    lda  $00,x
F368: 08       inx  
F369: DF C6    stx  $C6
F36B: DE C8    ldx  $C8
F36D: A7 00    sta  $00,x
F36F: 08       inx  
F370: DF C8    stx  $C8
F372: 5A       decb 
F373: 26 EF    bne  $F364
F375: 39       rts  
F376: B7 20 00 sta  $2000
F379: 39       rts  
F37A: B7 40 00 sta  $4000
F37D: 39       rts  
F37E: B7 60 00 sta  $6000
F381: 39       rts  
F382: 33       pulb 
F383: 34       des  
F384: 36       psha 
F385: DE AE    ldx  $AE
F387: 96 08    lda  $08
F389: DC 0B    ldd  $0B
F38B: E3 02    addd $02,x
F38D: DD 0B    std  $0B
F38F: B6 11 82 lda  $1182
F392: 81 A6    cmpa #$A6
F394: 26 2E    bne  $F3C4
F396: DE C6    ldx  $C6
F398: 3C       pshx 
F399: DE C8    ldx  $C8
F39B: 3C       pshx 
F39C: DE CA    ldx  $CA
F39E: 3C       pshx 
F39F: DE CC    ldx  $CC
F3A1: 3C       pshx 
F3A2: 96 08    lda  $08
F3A4: 84 F7    anda #$F7
F3A6: 97 08    sta  $08
F3A8: 0E       cli  
F3A9: DE AE    ldx  $AE
F3AB: EE 1A    ldx  $1A,x
F3AD: AD 00    jsr  $00,x
F3AF: 0F       sei  
F3B0: 96 08    lda  $08
F3B2: 8A 08    ora  #$08
F3B4: 97 08    sta  $08
F3B6: 38       pulx 
F3B7: DF CC    stx  $CC
F3B9: 38       pulx 
F3BA: DF CA    stx  $CA
F3BC: 38       pulx 
F3BD: DF C8    stx  $C8
F3BF: 38       pulx 
F3C0: DF C6    stx  $C6
F3C2: 32       pula 
F3C3: 3B       rti  
F3C4: DE AC    ldx  $AC
F3C6: AD 00    jsr  $00,x
F3C8: 32       pula 
F3C9: 3B       rti  
F3CA: B6 11 82 lda  $1182
F3CD: 81 A6    cmpa #$A6
F3CF: 26 4F    bne  $F420
F3D1: 33       pulb 
F3D2: 34       des  
F3D3: 36       psha 
F3D4: DE C6    ldx  $C6
F3D6: 3C       pshx 
F3D7: DE C8    ldx  $C8
F3D9: 3C       pshx 
F3DA: DE CA    ldx  $CA
F3DC: 3C       pshx 
F3DD: DE CC    ldx  $CC
F3DF: 3C       pshx 
F3E0: DE AE    ldx  $AE
F3E2: EE 1E    ldx  $1E,x
F3E4: AD 00    jsr  $00,x
F3E6: DE AA    ldx  $AA
F3E8: AD 00    jsr  $00,x
F3EA: DE AE    ldx  $AE
F3EC: EE 2C    ldx  $2C,x
F3EE: AD 00    jsr  $00,x
F3F0: DE AC    ldx  $AC
F3F2: AD 00    jsr  $00,x
F3F4: DE AE    ldx  $AE
F3F6: EE 20    ldx  $20,x
F3F8: AD 00    jsr  $00,x
F3FA: DE AE    ldx  $AE
F3FC: EE 22    ldx  $22,x
F3FE: AD 00    jsr  $00,x
F400: DE AE    ldx  $AE
F402: EE 24    ldx  $24,x
F404: AD 00    jsr  $00,x
F406: DE AE    ldx  $AE
F408: EE 26    ldx  $26,x
F40A: AD 00    jsr  $00,x
F40C: DE AE    ldx  $AE
F40E: EE 28    ldx  $28,x
F410: AD 00    jsr  $00,x
F412: 38       pulx 
F413: DF CC    stx  $CC
F415: 38       pulx 
F416: DF CA    stx  $CA
F418: 38       pulx 
F419: DF C8    stx  $C8
F41B: 38       pulx 
F41C: DF C6    stx  $C6
F41E: 32       pula 
F41F: 3B       rti  
F420: DE AA    ldx  $AA
F422: AD 00    jsr  $00,x
F424: DE AE    ldx  $AE
F426: EE 2C    ldx  $2C,x
F428: AD 00    jsr  $00,x
F42A: 3B       rti  
F42B: C6 A6    ldb  #$A6
F42D: B6 11 80 lda  $1180
F430: 11       cba  
F431: 27 07    beq  $F43A
F433: B6 11 82 lda  $1182
F436: 11       cba  
F437: 27 01    beq  $F43A
F439: 39       rts  
F43A: CE 11 91 ldx  #$1191
F43D: E6 00    ldb  $00,x
F43F: 27 0E    beq  $F44F
F441: C1 08    cmpb #$08
F443: 24 0A    bcc  $F44F
F445: 5A       decb 
F446: 58       aslb 
F447: CE F4 53 ldx  #$F453
F44A: 3A       abx  
F44B: EE 00    ldx  $00,x
F44D: AD 00    jsr  $00,x
F44F: 7F 11 91 clr  $1191
F452: 39       rts  
F453: F4 61 F4 andb $61F4
F456: 6E F4    jmp  $F4,x
F458: 7B F4 A0 tim  #$F4,$A0
F45B: F4 A6 F4 andb $A6F4
F45E: AE F4    lds  $F4,x
F460: AB FE    adda $FE,x
F462: 11       cba  
F463: 93 A6    subd $A6
F465: 00       illegal
F466: 08       inx  
F467: FF 11 93 stx  $1193
F46A: B7 11 92 sta  $1192
F46D: 39       rts  
F46E: B6 11 92 lda  $1192
F471: FE 11 93 ldx  $1193
F474: A7 00    sta  $00,x
F476: 08       inx  
F477: FF 11 93 stx  $1193
F47A: 39       rts  
F47B: CE 11 91 ldx  #$1191
F47E: EC 02    ldd  $02,x
F480: DD C6    std  $C6
F482: EC 04    ldd  $04,x
F484: DD C8    std  $C8
F486: EC 06    ldd  $06,x
F488: DD CA    std  $CA
F48A: DE C6    ldx  $C6
F48C: A6 00    lda  $00,x
F48E: 08       inx  
F48F: DF C6    stx  $C6
F491: DE C8    ldx  $C8
F493: A7 00    sta  $00,x
F495: 08       inx  
F496: DF C8    stx  $C8
F498: DE CA    ldx  $CA
F49A: 09       dex  
F49B: DF CA    stx  $CA
F49D: 26 EB    bne  $F48A
F49F: 39       rts  
F4A0: B6 11 92 lda  $1192
F4A3: 97 89    sta  $89
F4A5: 39       rts  
F4A6: 86 01    lda  #$01
F4A8: 97 8A    sta  $8A
F4AA: 39       rts  
F4AB: 71 7F 14 aim  #$7F,$14
F4AE: 7E FF BE jmp  $FFBE
F4B1: B6 11 82 lda  $1182
F4B4: 81 A6    cmpa #$A6
F4B6: 26 41    bne  $F4F9
F4B8: F6 11 83 ldb  nb_credits_1183
F4BB: 96 B0    lda  $B0
F4BD: 26 32    bne  $F4F1
F4BF: 5D       tstb 
F4C0: 27 37    beq  $F4F9
F4C2: 7F 11 82 clr  $1182
F4C5: BD F0 95 jsr  $F095
F4C8: 8E 13 FF lds  #$13FF
F4CB: BD F0 FB jsr  $F0FB
F4CE: BD F1 24 jsr  $F124
F4D1: BD F2 20 jsr  $F220
F4D4: 8E 00 C5 lds  #$00C5
F4D7: BD F1 10 jsr  $F110
F4DA: BD F2 31 jsr  $F231
F4DD: CC A6 00 ldd  #$A600
F4E0: FD 11 84 std  $1184
F4E3: 86 01    lda  #$01
F4E5: B7 11 83 sta  nb_credits_1183
F4E8: 97 B0    sta  $B0
F4EA: 0F       sei  
F4EB: DE AE    ldx  $AE
F4ED: EE 04    ldx  $04,x
F4EF: AD 00    jsr  $00,x
F4F1: 5D       tstb 
F4F2: 26 05    bne  $F4F9
F4F4: D7 B0    stb  $B0
F4F6: F7 11 84 stb  $1184
F4F9: 39       rts  
F4FA: 00       illegal
F4FB: D2 DF    sbcb $DF
F4FD: D3 DD    addd $DD
F4FF: D1 00    cmpb $00
F501: EF E7    stx  $E7,x
F503: E8 EC    eorb $EC,x
F505: 00       illegal
F506: DE AE    ldx  $AE
F508: EE 5D    ldx  $5D,x
F50A: DF C8    stx  $C8
F50C: D6 8A    ldb  $8A
F50E: 96 89    lda  $89
F510: 36       psha 
F511: 7F 00 8A clr  $008A
F514: 7F 00 89 clr  $0089
F517: B6 11 83 lda  nb_credits_1183
F51A: 26 06    bne  $F522
F51C: 5D       tstb 
F51D: 27 05    beq  $F524
F51F: 7F 00 80 clr  $0080
F522: 31       ins  
F523: 39       rts  
F524: 96 80    lda  $80
F526: 97 81    sta  $81
F528: DE AE    ldx  $AE
F52A: A1 77    cmpa $77,x
F52C: 25 03    bcs  $F531
F52E: 7E F5 C5 jmp  $F5C5
F531: BD F5 DB jsr  $F5DB
F534: DE AE    ldx  $AE
F536: E6 65    ldb  $65,x
F538: EE 57    ldx  $57,x
F53A: DF C6    stx  $C6
F53C: 58       aslb 
F53D: 3A       abx  
F53E: A6 00    lda  $00,x
F540: 27 28    beq  $F56A
F542: 7C 00 83 inc  $0083
F545: 96 83    lda  $83
F547: 91 85    cmpa $85
F549: 25 09    bcs  $F554
F54B: 7F 00 83 clr  $0083
F54E: 96 86    lda  $86
F550: 9B 80    adda $80
F552: 97 80    sta  $80
F554: DE AE    ldx  $AE
F556: E6 62    ldb  $62,x
F558: DE C8    ldx  $C8
F55A: 3A       abx  
F55B: 6C 00    inc  $00,x
F55D: 96 98    lda  nb_coins_inserted_98
F55F: 8B 01    adda #$01
F561: 19       daa  
F562: 16       tab  
F563: 96 97    lda  $97
F565: 89 00    adca #$00
F567: 19       daa  
F568: DD 97    std  $97
F56A: DE AE    ldx  $AE
F56C: E6 66    ldb  $66,x
F56E: DE C6    ldx  $C6
F570: 58       aslb 
F571: 3A       abx  
F572: A6 00    lda  $00,x
F574: 27 28    beq  $F59E
F576: 7C 00 84 inc  $0084
F579: 96 84    lda  $84
F57B: 91 87    cmpa $87
F57D: 25 09    bcs  $F588
F57F: 7F 00 84 clr  $0084
F582: 96 88    lda  $88
F584: 9B 80    adda $80
F586: 97 80    sta  $80
F588: DE AE    ldx  $AE
F58A: E6 63    ldb  $63,x
F58C: DE C8    ldx  $C8
F58E: 3A       abx  
F58F: 6C 00    inc  $00,x
F591: 96 9A    lda  $9A
F593: 8B 01    adda #$01
F595: 19       daa  
F596: 16       tab  
F597: 96 99    lda  $99
F599: 89 00    adca #$00
F59B: 19       daa  
F59C: DD 99    std  $99
F59E: 96 80    lda  $80
F5A0: DE AE    ldx  $AE
F5A2: A1 77    cmpa $77,x
F5A4: 24 1F    bcc  $F5C5
F5A6: 32       pula 
F5A7: 34       des  
F5A8: 9B 80    adda $80
F5AA: 97 80    sta  $80
F5AC: A1 77    cmpa $77,x
F5AE: 24 15    bcc  $F5C5
F5B0: E6 64    ldb  $64,x
F5B2: DE C6    ldx  $C6
F5B4: 58       aslb 
F5B5: 3A       abx  
F5B6: A6 00    lda  $00,x
F5B8: 27 0D    beq  $F5C7
F5BA: 7C 00 80 inc  $0080
F5BD: D6 80    ldb  $80
F5BF: DE AE    ldx  $AE
F5C1: E1 77    cmpb $77,x
F5C3: 25 02    bcs  $F5C7
F5C5: 8D 18    bsr  $F5DF
F5C7: D6 80    ldb  $80
F5C9: 17       tba  
F5CA: 90 81    suba $81
F5CC: 25 06    bcs  $F5D4
F5CE: BB 11 8B adda $118B
F5D1: B7 11 8B sta  $118B
F5D4: 8D 14    bsr  $F5EA
F5D6: FD 11 89 std  $1189
F5D9: 31       ins  
F5DA: 39       rts  
F5DB: 86 01    lda  #$01
F5DD: 20 01    bra  $F5E0
F5DF: 4F       clra 
F5E0: DE AE    ldx  $AE
F5E2: E6 61    ldb  $61,x
F5E4: EE 5D    ldx  $5D,x
F5E6: 3A       abx  
F5E7: A7 00    sta  $00,x
F5E9: 39       rts  
F5EA: 86 FF    lda  #$FF
F5EC: 4C       inca 
F5ED: C0 0A    subb #$0A
F5EF: 24 FB    bcc  $F5EC
F5F1: CB 0A    addb #$0A
F5F3: 39       rts  
F5F4: B6 11 83 lda  nb_credits_1183
F5F7: BA 11 9B ora  $119B
F5FA: BA 11 8C ora  $118C
F5FD: BA 11 8D ora  $118D
F600: 26 5B    bne  $F65D
F602: 97 82    sta  $82
F604: 96 80    lda  $80
F606: 27 55    beq  $F65D
F608: DE AE    ldx  $AE
F60A: E6 67    ldb  $67,x
F60C: EE 57    ldx  $57,x
F60E: 58       aslb 
F60F: 3A       abx  
F610: A6 00    lda  $00,x
F612: 26 2B    bne  $F63F
F614: 96 80    lda  $80
F616: DE AE    ldx  $AE
F618: A1 78    cmpa $78,x
F61A: 25 41    bcs  $F65D
F61C: DE AE    ldx  $AE
F61E: E6 68    ldb  $68,x
F620: EE 57    ldx  $57,x
F622: 58       aslb 
F623: 3A       abx  
F624: A6 00    lda  $00,x
F626: 27 35    beq  $F65D
F628: DE AE    ldx  $AE
F62A: E6 78    ldb  $78,x
F62C: D7 82    stb  $82
F62E: 96 80    lda  $80
F630: 10       sba  
F631: 97 80    sta  $80
F633: 86 01    lda  #$01
F635: B7 11 8E sta  $118E
F638: DE 8D    ldx  $8D
F63A: 08       inx  
F63B: DF 8D    stx  $8D
F63D: 20 0F    bra  $F64E
F63F: C6 01    ldb  #$01
F641: D7 82    stb  $82
F643: 7A 00 80 dec  $0080
F646: 7F 11 8E clr  $118E
F649: DE 8B    ldx  $8B
F64B: 08       inx  
F64C: DF 8B    stx  $8B
F64E: 86 01    lda  #$01
F650: B7 11 8C sta  $118C
F653: DE AE    ldx  $AE
F655: A6 7B    lda  $7B,x
F657: 27 04    beq  $F65D
F659: 4F       clra 
F65A: 5F       clrb 
F65B: DD 83    std  $83
F65D: 39       rts  
F65E: D6 A7    ldb  $A7
F660: 5A       decb 
F661: 26 10    bne  $F673
F663: 96 A6    lda  $A6
F665: 4A       deca 
F666: 26 02    bne  $F66A
F668: 86 21    lda  #$21
F66A: 97 A6    sta  $A6
F66C: C6 3C    ldb  #$3C
F66E: 81 0E    cmpa #$0E
F670: 25 01    bcs  $F673
F672: 5C       incb 
F673: D7 A7    stb  $A7
F675: F7 11 90 stb  $1190
F678: 5A       decb 
F679: 26 11    bne  $F68C
F67B: CE 00 93 ldx  #$0093
F67E: BD F7 23 jsr  $F723
F681: B6 11 8C lda  $118C
F684: 27 06    beq  $F68C
F686: CE 00 8F ldx  #$008F
F689: BD F7 23 jsr  $F723
F68C: DE AE    ldx  $AE
F68E: A6 76    lda  $76,x
F690: 97 C6    sta  $C6
F692: E6 79    ldb  $79,x
F694: CE 11 80 ldx  #$1180
F697: A6 1B    lda  $1B,x
F699: 26 05    bne  $F6A0
F69B: B6 11 8C lda  $118C
F69E: 26 57    bne  $F6F7
F6A0: A6 1A    lda  $1A,x
F6A2: 6F 1A    clr  $1A,x
F6A4: 4D       tsta 
F6A5: 27 21    beq  $F6C8
F6A7: 96 80    lda  $80
F6A9: 10       sba  
F6AA: 25 4B    bcs  $F6F7
F6AC: D7 82    stb  $82
F6AE: 97 80    sta  $80
F6B0: 96 A7    lda  $A7
F6B2: 81 3D    cmpa #$3D
F6B4: 25 01    bcs  $F6B7
F6B6: 4A       deca 
F6B7: A7 20    sta  $20,x
F6B9: 86 01    lda  #$01
F6BB: A7 1B    sta  $1B,x
F6BD: 96 C6    lda  $C6
F6BF: C6 3C    ldb  #$3C
F6C1: 3D       mul  
F6C2: E3 1E    addd $1E,x
F6C4: ED 1E    std  $1E,x
F6C6: 6F 1D    clr  $1D,x
F6C8: 5F       clrb 
F6C9: A6 1D    lda  $1D,x
F6CB: 27 05    beq  $F6D2
F6CD: 4F       clra 
F6CE: ED 1E    std  $1E,x
F6D0: A7 1B    sta  $1B,x
F6D2: EC 1E    ldd  $1E,x
F6D4: 26 04    bne  $F6DA
F6D6: 86 01    lda  #$01
F6D8: A7 1D    sta  $1D,x
F6DA: A6 1B    lda  $1B,x
F6DC: 27 19    beq  $F6F7
F6DE: 96 A7    lda  $A7
F6E0: A1 20    cmpa $20,x
F6E2: 26 13    bne  $F6F7
F6E4: A6 1C    lda  $1C,x
F6E6: 26 0F    bne  $F6F7
F6E8: EC 1E    ldd  $1E,x
F6EA: 83 00 01 subd #$0001
F6ED: ED 1E    std  $1E,x
F6EF: 26 06    bne  $F6F7
F6F1: 86 01    lda  #$01
F6F3: A7 1D    sta  $1D,x
F6F5: 6F 1B    clr  $1B,x
F6F7: 86 FF    lda  #$FF
F6F9: 97 C7    sta  $C7
F6FB: EC 1E    ldd  $1E,x
F6FD: 7C 00 C7 inc  $00C7
F700: 83 00 3C subd #$003C
F703: 24 F8    bcc  $F6FD
F705: CB 3C    addb #$3C
F707: BD F5 EA jsr  $F5EA
F70A: ED 23    std  $23,x
F70C: D6 C7    ldb  $C7
F70E: BD F5 EA jsr  $F5EA
F711: ED 21    std  $21,x
F713: CE 00 80 ldx  #$0080
F716: DF C6    stx  $C6
F718: CE 11 A5 ldx  #$11A5
F71B: DF C8    stx  $C8
F71D: C6 1B    ldb  #$1B
F71F: BD F3 64 jsr  $F364
F722: 39       rts  
F723: A6 03    lda  $03,x
F725: 4C       inca 
F726: 81 3C    cmpa #$3C
F728: 25 01    bcs  $F72B
F72A: 4F       clra 
F72B: A7 03    sta  $03,x
F72D: 26 12    bne  $F741
F72F: A6 02    lda  $02,x
F731: 4C       inca 
F732: 81 3C    cmpa #$3C
F734: 25 01    bcs  $F737
F736: 4F       clra 
F737: A7 02    sta  $02,x
F739: 26 06    bne  $F741
F73B: EC 00    ldd  $00,x
F73D: 8D 03    bsr  $F742
F73F: ED 00    std  $00,x
F741: 39       rts  
F742: 36       psha 
F743: 17       tba  
F744: 8B 01    adda #$01
F746: 19       daa  
F747: 36       psha 
F748: 33       pulb 
F749: 32       pula 
F74A: 89 00    adca #$00
F74C: 19       daa  
F74D: 39       rts  
F74E: 4F       clra 
F74F: 97 C0    sta  $C0
F751: B7 11 8B sta  $118B
F754: C6 80    ldb  #$80
F756: DE AE    ldx  $AE
F758: EE 4E    ldx  $4E,x
F75A: BD F3 5C jsr  $F35C
F75D: DE AE    ldx  $AE
F75F: EE 4C    ldx  $4C,x
F761: DF BD    stx  $BD
F763: C6 43    ldb  #$43
F765: BD F3 5C jsr  $F35C
F768: DE AE    ldx  $AE
F76A: EC 48    ldd  $48,x
F76C: DD C6    std  $C6
F76E: EC 4A    ldd  $4A,x
F770: DD C8    std  $C8
F772: C6 20    ldb  #$20
F774: BD F3 64 jsr  $F364
F777: DE AE    ldx  $AE
F779: EC 3A    ldd  $3A,x
F77B: DD C6    std  $C6
F77D: CC 10 00 ldd  #$1000
F780: DD C8    std  $C8
F782: 5F       clrb 
F783: BD F3 64 jsr  $F364
F786: 39       rts  
F787: DE AE    ldx  $AE
F789: EC 4E    ldd  $4E,x
F78B: DD C6    std  $C6
F78D: CC 11 00 ldd  #$1100
F790: DD CA    std  $CA
F792: 86 08    lda  #$08
F794: 6D 54    tst  $54,x
F796: 27 01    beq  $F799
F798: 48       asla 
F799: 97 BF    sta  $BF
F79B: 0F       sei  
F79C: DE C6    ldx  $C6
F79E: EC 00    ldd  $00,x
F7A0: DE CA    ldx  $CA
F7A2: ED 00    std  $00,x
F7A4: DE C6    ldx  $C6
F7A6: EC 02    ldd  $02,x
F7A8: DE CA    ldx  $CA
F7AA: ED 02    std  $02,x
F7AC: DE C6    ldx  $C6
F7AE: A6 04    lda  $04,x
F7B0: DE CA    ldx  $CA
F7B2: A7 04    sta  $04,x
F7B4: 18       xgdx 
F7B5: C3 00 08 addd #$0008
F7B8: DD CA    std  $CA
F7BA: DC C6    ldd  $C6
F7BC: C3 00 08 addd #$0008
F7BF: DD C6    std  $C6
F7C1: 7A 00 BF dec  $00BF
F7C4: 26 D6    bne  $F79C
F7C6: 0E       cli  
F7C7: DE AE    ldx  $AE
F7C9: C6 40    ldb  #$40
F7CB: 6D 54    tst  $54,x
F7CD: 27 01    beq  $F7D0
F7CF: 58       aslb 
F7D0: EE 4E    ldx  $4E,x
F7D2: BD F3 5C jsr  $F35C
F7D5: B6 11 8B lda  $118B
F7D8: 16       tab  
F7D9: 90 C0    suba $C0
F7DB: D7 C0    stb  $C0
F7DD: DE BD    ldx  $BD
F7DF: AB 00    adda $00,x
F7E1: A7 00    sta  $00,x
F7E3: E6 41    ldb  $41,x
F7E5: 27 1F    beq  $F806
F7E7: E6 42    ldb  $42,x
F7E9: 26 08    bne  $F7F3
F7EB: DE AE    ldx  $AE
F7ED: EE 44    ldx  $44,x
F7EF: DF C4    stx  $C4
F7F1: 20 19    bra  $F80C
F7F3: 4F       clra 
F7F4: C6 1F    ldb  #$1F
F7F6: DE BD    ldx  $BD
F7F8: A7 01    sta  $01,x
F7FA: 08       inx  
F7FB: 5A       decb 
F7FC: 26 FA    bne  $F7F8
F7FE: C6 1F    ldb  #$1F
F800: A7 02    sta  $02,x
F802: 08       inx  
F803: 5A       decb 
F804: 26 FA    bne  $F800
F806: DE AE    ldx  $AE
F808: EE 46    ldx  $46,x
F80A: DF C4    stx  $C4
F80C: DE C4    ldx  $C4
F80E: E6 00    ldb  $00,x
F810: C1 FF    cmpb #$FF
F812: 27 42    beq  $F856
F814: D7 C3    stb  $C3
F816: DE BD    ldx  $BD
F818: 3A       abx  
F819: A6 00    lda  $00,x
F81B: 3C       pshx 
F81C: DE BD    ldx  $BD
F81E: 6D 40    tst  $40,x
F820: 26 0C    bne  $F82E
F822: DE AE    ldx  $AE
F824: EE 42    ldx  $42,x
F826: 3A       abx  
F827: E6 00    ldb  $00,x
F829: 27 13    beq  $F83E
F82B: 5A       decb 
F82C: 27 16    beq  $F844
F82E: 38       pulx 
F82F: 4D       tsta 
F830: 27 06    beq  $F838
F832: 6F 00    clr  $00,x
F834: 6F 20    clr  $20,x
F836: 20 10    bra  $F848
F838: 6D 20    tst  $20,x
F83A: 27 13    beq  $F84F
F83C: 20 0A    bra  $F848
F83E: 38       pulx 
F83F: 4D       tsta 
F840: 27 0B    beq  $F84D
F842: 20 04    bra  $F848
F844: 38       pulx 
F845: 4D       tsta 
F846: 27 07    beq  $F84F
F848: BD F8 57 jsr  $F857
F84B: 20 02    bra  $F84F
F84D: 6F 20    clr  $20,x
F84F: DE C4    ldx  $C4
F851: 08       inx  
F852: DF C4    stx  $C4
F854: 20 B6    bra  $F80C
F856: 39       rts  
F857: 4F       clra 
F858: 97 C1    sta  $C1
F85A: 4C       inca 
F85B: 97 C2    sta  $C2
F85D: D6 C3    ldb  $C3
F85F: DE AE    ldx  $AE
F861: EE 3C    ldx  $3C,x
F863: 58       aslb 
F864: 3A       abx  
F865: EE 00    ldx  $00,x
F867: DF C6    stx  $C6
F869: DF CC    stx  $CC
F86B: DE BD    ldx  $BD
F86D: 54       lsrb 
F86E: 3A       abx  
F86F: A6 20    lda  $20,x
F871: 26 57    bne  $F8CA
F873: 6C 20    inc  $20,x
F875: DE AE    ldx  $AE
F877: EE 3E    ldx  $3E,x
F879: 58       aslb 
F87A: 3A       abx  
F87B: EE 00    ldx  $00,x
F87D: DF CA    stx  $CA
F87F: DE CA    ldx  $CA
F881: EC 00    ldd  $00,x
F883: 08       inx  
F884: 08       inx  
F885: DF CA    stx  $CA
F887: 81 11    cmpa #$11
F889: 27 37    beq  $F8C2
F88B: DE C6    ldx  $C6
F88D: ED 00    std  $00,x
F88F: DE CA    ldx  $CA
F891: EC 00    ldd  $00,x
F893: 08       inx  
F894: 08       inx  
F895: DF CA    stx  $CA
F897: 48       asla 
F898: 48       asla 
F899: 48       asla 
F89A: DE C6    ldx  $C6
F89C: ED 02    std  $02,x
F89E: DE CA    ldx  $CA
F8A0: EC 00    ldd  $00,x
F8A2: 08       inx  
F8A3: 08       inx  
F8A4: DF CA    stx  $CA
F8A6: DE C6    ldx  $C6
F8A8: ED 04    std  $04,x
F8AA: 6F 06    clr  $06,x
F8AC: BD FA 22 jsr  $FA22
F8AF: DE C6    ldx  $C6
F8B1: CC 00 00 ldd  #$0000
F8B4: ED 0D    std  $0D,x
F8B6: ED 0F    std  $0F,x
F8B8: 97 C2    sta  $C2
F8BA: 18       xgdx 
F8BB: C3 00 11 addd #$0011
F8BE: DD C6    std  $C6
F8C0: 20 BD    bra  $F87F
F8C2: DE C6    ldx  $C6
F8C4: A7 00    sta  $00,x
F8C6: DE CC    ldx  $CC
F8C8: DF C6    stx  $C6
F8CA: DE C6    ldx  $C6
F8CC: A6 06    lda  $06,x
F8CE: 84 F0    anda #$F0
F8D0: D6 C1    ldb  $C1
F8D2: C0 10    subb #$10
F8D4: 25 13    bcs  $F8E9
F8D6: D7 C1    stb  $C1
F8D8: 11       cba  
F8D9: 25 02    bcs  $F8DD
F8DB: 97 C1    sta  $C1
F8DD: E6 02    ldb  $02,x
F8DF: DE AE    ldx  $AE
F8E1: EE 4E    ldx  $4E,x
F8E3: 3A       abx  
F8E4: 6F 00    clr  $00,x
F8E6: 7E FA 0C jmp  $FA0C
F8E9: 97 C1    sta  $C1
F8EB: A6 06    lda  $06,x
F8ED: 6B 04 04 tim  #$04,$04,x
F8F0: 27 03    beq  $F8F5
F8F2: 7E F9 A3 jmp  $F9A3
F8F5: DE AE    ldx  $AE
F8F7: EE 40    ldx  $40,x
F8F9: DF CA    stx  $CA
F8FB: DE C6    ldx  $C6
F8FD: E6 05    ldb  $05,x
F8FF: 58       aslb 
F900: DE CA    ldx  $CA
F902: 3A       abx  
F903: EE 00    ldx  $00,x
F905: DF CA    stx  $CA
F907: DE C6    ldx  $C6
F909: E6 0B    ldb  $0B,x
F90B: DE CA    ldx  $CA
F90D: 3A       abx  
F90E: A6 00    lda  $00,x
F910: 81 10    cmpa #$10
F912: 24 03    bcc  $F917
F914: 7E F9 A3 jmp  $F9A3
F917: DF CA    stx  $CA
F919: 84 0F    anda #$0F
F91B: CE F9 25 ldx  #$F925
F91E: 36       psha 
F91F: 12       asx1 1,s
F920: EE 00    ldx  $00,x
F922: 32       pula 
F923: 6E 00    jmp  $00,x
F925: F9 66 F9 adcb $66F9
F928: 6D F9    tst  $F9,x
F92A: 60 F9    neg  $F9,x
F92C: 35       txs  
F92D: F9 7C F9 adcb $7CF9
F930: 8E F9 9D lds  #$F99D
F933: F9 9D DE adcb $9DDE
F936: C6 A6    ldb  #$A6
F938: 0C       clc  
F939: 81 FF    cmpa #$FF
F93B: 27 17    beq  $F954
F93D: DE CA    ldx  $CA
F93F: E6 01    ldb  $01,x
F941: 5C       incb 
F942: 11       cba  
F943: 26 08    bne  $F94D
F945: C6 FF    ldb  #$FF
F947: DE C6    ldx  $C6
F949: E7 0C    stb  $0C,x
F94B: 20 56    bra  $F9A3
F94D: 4A       deca 
F94E: DE C6    ldx  $C6
F950: A7 0C    sta  $0C,x
F952: 20 53    bra  $F9A7
F954: DE CA    ldx  $CA
F956: 09       dex  
F957: A6 00    lda  $00,x
F959: 4A       deca 
F95A: DE C6    ldx  $C6
F95C: A7 0C    sta  $0C,x
F95E: 20 47    bra  $F9A7
F960: DE C6    ldx  $C6
F962: 6F 0B    clr  $0B,x
F964: 20 8F    bra  $F8F5
F966: DE CA    ldx  $CA
F968: 09       dex  
F969: A6 00    lda  $00,x
F96B: 20 3A    bra  $F9A7
F96D: DE CA    ldx  $CA
F96F: 09       dex  
F970: A6 00    lda  $00,x
F972: DE C6    ldx  $C6
F974: A1 0A    cmpa $0A,x
F976: 23 2F    bls  $F9A7
F978: A6 0A    lda  $0A,x
F97A: 20 2B    bra  $F9A7
F97C: DE CA    ldx  $CA
F97E: 08       inx  
F97F: DF CA    stx  $CA
F981: E6 00    ldb  $00,x
F983: DE C6    ldx  $C6
F985: 61 0F 07 aim  #$0F,$07,x
F988: EA 07    orb  $07,x
F98A: E7 07    stb  $07,x
F98C: 20 15    bra  $F9A3
F98E: DE CA    ldx  $CA
F990: 08       inx  
F991: DF CA    stx  $CA
F993: E6 00    ldb  $00,x
F995: DE C6    ldx  $C6
F997: EB 07    addb $07,x
F999: E7 07    stb  $07,x
F99B: 20 06    bra  $F9A3
F99D: DE AE    ldx  $AE
F99F: EE 52    ldx  $52,x
F9A1: AD 00    jsr  $00,x
F9A3: DE C6    ldx  $C6
F9A5: 6C 0B    inc  $0B,x
F9A7: DE C6    ldx  $C6
F9A9: 61 F0 06 aim  #$F0,$06,x
F9AC: 84 0F    anda #$0F
F9AE: AA 06    ora  $06,x
F9B0: A7 06    sta  $06,x
F9B2: DE C6    ldx  $C6
F9B4: E6 02    ldb  $02,x
F9B6: DE AE    ldx  $AE
F9B8: EE 4E    ldx  $4E,x
F9BA: 3A       abx  
F9BB: DF CA    stx  $CA
F9BD: DE C6    ldx  $C6
F9BF: EC 06    ldd  $06,x
F9C1: 84 0F    anda #$0F
F9C3: 6B 04 04 tim  #$04,$04,x
F9C6: 27 01    beq  $F9C9
F9C8: 4F       clra 
F9C9: DE CA    ldx  $CA
F9CB: ED 00    std  $00,x
F9CD: DE C6    ldx  $C6
F9CF: EC 08    ldd  $08,x
F9D1: DE CA    ldx  $CA
F9D3: ED 02    std  $02,x
F9D5: DE C6    ldx  $C6
F9D7: E6 02    ldb  $02,x
F9D9: C0 08    subb #$08
F9DB: C4 78    andb #$78
F9DD: DE AE    ldx  $AE
F9DF: 6D 54    tst  $54,x
F9E1: 26 02    bne  $F9E5
F9E3: C4 38    andb #$38
F9E5: DE C6    ldx  $C6
F9E7: 6B 02 04 tim  #$02,$04,x
F9EA: 26 0D    bne  $F9F9
F9EC: DE AE    ldx  $AE
F9EE: EE 4E    ldx  $4E,x
F9F0: 3A       abx  
F9F1: A6 04    lda  $04,x
F9F3: 84 7F    anda #$7F
F9F5: A7 04    sta  $04,x
F9F7: 20 0B    bra  $FA04
F9F9: DE AE    ldx  $AE
F9FB: EE 4E    ldx  $4E,x
F9FD: 3A       abx  
F9FE: A6 04    lda  $04,x
FA00: 8A 80    ora  #$80
FA02: A7 04    sta  $04,x
FA04: DE C6    ldx  $C6
FA06: 6A 0A    dec  $0A,x
FA08: 26 02    bne  $FA0C
FA0A: 8D 16    bsr  $FA22
FA0C: DE C6    ldx  $C6
FA0E: A6 11    lda  $11,x
FA10: 81 11    cmpa #$11
FA12: 26 01    bne  $FA15
FA14: 39       rts  
FA15: 7F 00 C2 clr  $00C2
FA18: DC C6    ldd  $C6
FA1A: C3 00 11 addd #$0011
FA1D: DD C6    std  $C6
FA1F: 7E F8 CA jmp  $F8CA
FA22: DE CA    ldx  $CA
FA24: 3C       pshx 
FA25: DE C6    ldx  $C6
FA27: 6B 02 04 tim  #$02,$04,x
FA2A: 27 1F    beq  $FA4B
FA2C: EE 00    ldx  $00,x
FA2E: A6 00    lda  $00,x
FA30: 26 0C    bne  $FA3E
FA32: 08       inx  
FA33: 18       xgdx 
FA34: DE C6    ldx  $C6
FA36: ED 00    std  $00,x
FA38: 18       xgdx 
FA39: A6 00    lda  $00,x
FA3B: 7E FB 07 jmp  $FB07
FA3E: DE C6    ldx  $C6
FA40: A7 09    sta  $09,x
FA42: 61 F0 06 aim  #$F0,$06,x
FA45: 61 FB 04 aim  #$FB,$04,x
FA48: 7E FA DA jmp  $FADA
FA4B: EE 00    ldx  $00,x
FA4D: A6 00    lda  $00,x
FA4F: 81 E0    cmpa #$E0
FA51: 25 03    bcs  $FA56
FA53: 7E FB 07 jmp  $FB07
FA56: 84 F0    anda #$F0
FA58: 81 C0    cmpa #$C0
FA5A: 27 76    beq  $FAD2
FA5C: DE C6    ldx  $C6
FA5E: 61 F0 06 aim  #$F0,$06,x
FA61: 61 FB 04 aim  #$FB,$04,x
FA64: E6 03    ldb  $03,x
FA66: D7 BF    stb  $BF
FA68: C4 0F    andb #$0F
FA6A: 44       lsra 
FA6B: 44       lsra 
FA6C: 44       lsra 
FA6D: 44       lsra 
FA6E: 1B       aba  
FA6F: 97 CA    sta  $CA
FA71: 48       asla 
FA72: 9B CA    adda $CA
FA74: 16       tab  
FA75: CE FC 51 ldx  #$FC51
FA78: 3A       abx  
FA79: 3C       pshx 
FA7A: 4F       clra 
FA7B: 5F       clrb 
FA7C: DD CA    std  $CA
FA7E: EC 00    ldd  $00,x
FA80: DE C6    ldx  $C6
FA82: ED 07    std  $07,x
FA84: 38       pulx 
FA85: A6 02    lda  $02,x
FA87: DE C6    ldx  $C6
FA89: A7 09    sta  $09,x
FA8B: D6 BF    ldb  $BF
FA8D: 54       lsrb 
FA8E: 54       lsrb 
FA8F: 54       lsrb 
FA90: 54       lsrb 
FA91: 27 17    beq  $FAAA
FA93: D7 BF    stb  $BF
FA95: EC 07    ldd  $07,x
FA97: DD CA    std  $CA
FA99: DC CA    ldd  $CA
FA9B: E3 08    addd $08,x
FA9D: ED 08    std  $08,x
FA9F: A6 07    lda  $07,x
FAA1: 89 00    adca #$00
FAA3: A7 07    sta  $07,x
FAA5: 7A 00 BF dec  $00BF
FAA8: 26 EF    bne  $FA99
FAAA: EE 00    ldx  $00,x
FAAC: A6 00    lda  $00,x
FAAE: 84 0F    anda #$0F
FAB0: 27 14    beq  $FAC6
FAB2: DE AE    ldx  $AE
FAB4: 6D 54    tst  $54,x
FAB6: 27 03    beq  $FABB
FAB8: 4A       deca 
FAB9: 27 0B    beq  $FAC6
FABB: DE C6    ldx  $C6
FABD: 64 07    lsr  $07,x
FABF: 66 08    ror  $08,x
FAC1: 66 09    ror  $09,x
FAC3: 4A       deca 
FAC4: 26 F7    bne  $FABD
FAC6: DE C6    ldx  $C6
FAC8: A6 04    lda  $04,x
FACA: 84 F0    anda #$F0
FACC: AA 07    ora  $07,x
FACE: A7 07    sta  $07,x
FAD0: 20 08    bra  $FADA
FAD2: DE C6    ldx  $C6
FAD4: 61 F0 06 aim  #$F0,$06,x
FAD7: 62 04 04 oim  #$04,$04,x
FADA: DE C6    ldx  $C6
FADC: EE 00    ldx  $00,x
FADE: DF CA    stx  $CA
FAE0: DE AE    ldx  $AE
FAE2: EE 4A    ldx  $4A,x
FAE4: D6 C3    ldb  $C3
FAE6: 3A       abx  
FAE7: A6 00    lda  $00,x
FAE9: DE CA    ldx  $CA
FAEB: E6 01    ldb  $01,x
FAED: 3D       mul  
FAEE: DE C6    ldx  $C6
FAF0: E7 0A    stb  $0A,x
FAF2: DE CA    ldx  $CA
FAF4: 08       inx  
FAF5: 08       inx  
FAF6: 37       pshb 
FAF7: 18       xgdx 
FAF8: DE C6    ldx  $C6
FAFA: ED 00    std  $00,x
FAFC: 33       pulb 
FAFD: 6F 0B    clr  $0B,x
FAFF: 86 FF    lda  #$FF
FB01: A7 0C    sta  $0C,x
FB03: 38       pulx 
FB04: DF CA    stx  $CA
FB06: 39       rts  
FB07: DE C6    ldx  $C6
FB09: EE 00    ldx  $00,x
FB0B: DF CA    stx  $CA
FB0D: E6 01    ldb  $01,x
FB0F: CE FB 26 ldx  #$FB26
FB12: 84 1F    anda #$1F
FB14: 81 26    cmpa #$26
FB16: 25 06    bcs  $FB1E
FB18: DE AE    ldx  $AE
FB1A: EE 50    ldx  $50,x
FB1C: 6E 00    jmp  $00,x
FB1E: 48       asla 
FB1F: 36       psha 
FB20: 13       asx2 1,s
FB21: 31       ins  
FB22: EE 00    ldx  $00,x
FB24: 6E 00    jmp  $00,x
FB26: FB E8 FB addb $E8FB
FB29: 6F FB    clr  $FB,x
FB2B: 7A FB 82 dec  $FB82
FB2E: FB 88 FB addb $88FB
FB31: AC FB    cmpx $FB,x
FB33: A0 FB    suba $FB,x
FB35: C8 FB    eorb #$FB
FB37: BC FB 66 cmpx $FB66
FB3A: FB 4C FB addb $4CFB
FB3D: 59       rolb 
FB3E: FA D2 FB orb  $D2FB
FB41: 92 FB    sbca $FB
FB43: 98 FB    eora $FB
FB45: FE FC 12 ldx  $FC12
FB48: FC 1E FC ldd  $1EFC
FB4B: 36       psha 
FB4C: DE C6    ldx  $C6
FB4E: 62 02 04 oim  #$02,$04,x
FB51: DE CA    ldx  $CA
FB53: 08       inx  
FB54: DF CA    stx  $CA
FB56: 7E FB DF jmp  $FBDF
FB59: DE C6    ldx  $C6
FB5B: 61 FD 04 aim  #$FD,$04,x
FB5E: DE CA    ldx  $CA
FB60: 08       inx  
FB61: DF CA    stx  $CA
FB63: 7E FB DF jmp  $FBDF
FB66: DE CA    ldx  $CA
FB68: EE 01    ldx  $01,x
FB6A: DF CA    stx  $CA
FB6C: 7E FB DF jmp  $FBDF
FB6F: DE C6    ldx  $C6
FB71: 61 0F 04 aim  #$0F,$04,x
FB74: EA 04    orb  $04,x
FB76: E7 04    stb  $04,x
FB78: 20 2A    bra  $FBA4
FB7A: DE C6    ldx  $C6
FB7C: EB 04    addb $04,x
FB7E: E7 04    stb  $04,x
FB80: 20 22    bra  $FBA4
FB82: DE C6    ldx  $C6
FB84: E7 05    stb  $05,x
FB86: 20 1C    bra  $FBA4
FB88: DE C6    ldx  $C6
FB8A: EB 05    addb $05,x
FB8C: C4 0F    andb #$0F
FB8E: E7 05    stb  $05,x
FB90: 20 12    bra  $FBA4
FB92: DE C6    ldx  $C6
FB94: E7 03    stb  $03,x
FB96: 20 0C    bra  $FBA4
FB98: DE C6    ldx  $C6
FB9A: EB 03    addb $03,x
FB9C: E7 03    stb  $03,x
FB9E: 20 04    bra  $FBA4
FBA0: DE C6    ldx  $C6
FBA2: E7 0E    stb  $0E,x
FBA4: DE CA    ldx  $CA
FBA6: 08       inx  
FBA7: 08       inx  
FBA8: DF CA    stx  $CA
FBAA: 20 33    bra  $FBDF
FBAC: DE C6    ldx  $C6
FBAE: A6 0E    lda  $0E,x
FBB0: 26 26    bne  $FBD8
FBB2: 6C 0D    inc  $0D,x
FBB4: E1 0D    cmpb $0D,x
FBB6: 26 18    bne  $FBD0
FBB8: 6F 0D    clr  $0D,x
FBBA: 20 1C    bra  $FBD8
FBBC: DE C6    ldx  $C6
FBBE: 6C 10    inc  $10,x
FBC0: E1 10    cmpb $10,x
FBC2: 26 14    bne  $FBD8
FBC4: 6F 10    clr  $10,x
FBC6: 20 08    bra  $FBD0
FBC8: DE C6    ldx  $C6
FBCA: 6C 0F    inc  $0F,x
FBCC: E1 0F    cmpb $0F,x
FBCE: 26 08    bne  $FBD8
FBD0: DE CA    ldx  $CA
FBD2: EE 02    ldx  $02,x
FBD4: DF CA    stx  $CA
FBD6: 20 07    bra  $FBDF
FBD8: DC CA    ldd  $CA
FBDA: C3 00 04 addd #$0004
FBDD: DD CA    std  $CA
FBDF: DC CA    ldd  $CA
FBE1: DE C6    ldx  $C6
FBE3: ED 00    std  $00,x
FBE5: 7E FA 25 jmp  $FA25
FBE8: DE BD    ldx  $BD
FBEA: 96 C3    lda  $C3
FBEC: 16       tab  
FBED: AA 40    ora  $40,x
FBEF: 26 05    bne  $FBF6
FBF1: 3A       abx  
FBF2: 6A 00    dec  $00,x
FBF4: 20 03    bra  $FBF9
FBF6: 3A       abx  
FBF7: 6F 00    clr  $00,x
FBF9: 6F 20    clr  $20,x
FBFB: 38       pulx 
FBFC: 38       pulx 
FBFD: 39       rts  
FBFE: DE C6    ldx  $C6
FC00: 6B 01 04 tim  #$01,$04,x
FC03: 26 9F    bne  $FBA4
FC05: 61 0F 06 aim  #$0F,$06,x
FC08: 58       aslb 
FC09: 58       aslb 
FC0A: 58       aslb 
FC0B: 58       aslb 
FC0C: EA 06    orb  $06,x
FC0E: E7 06    stb  $06,x
FC10: 20 92    bra  $FBA4
FC12: DE C6    ldx  $C6
FC14: 61 0F 06 aim  #$0F,$06,x
FC17: DE CA    ldx  $CA
FC19: 08       inx  
FC1A: DF CA    stx  $CA
FC1C: 20 C1    bra  $FBDF
FC1E: 96 C2    lda  $C2
FC20: 27 0C    beq  $FC2E
FC22: 17       tba  
FC23: DE AE    ldx  $AE
FC25: EE 4A    ldx  $4A,x
FC27: D6 C3    ldb  $C3
FC29: 3A       abx  
FC2A: AB 00    adda $00,x
FC2C: A7 00    sta  $00,x
FC2E: DE CA    ldx  $CA
FC30: 08       inx  
FC31: 08       inx  
FC32: DF CA    stx  $CA
FC34: 20 A9    bra  $FBDF
FC36: 96 C2    lda  $C2
FC38: 27 10    beq  $FC4A
FC3A: D6 C3    ldb  $C3
FC3C: DE AE    ldx  $AE
FC3E: EE 48    ldx  $48,x
FC40: 3A       abx  
FC41: A6 00    lda  $00,x
FC43: DE AE    ldx  $AE
FC45: EE 4A    ldx  $4A,x
FC47: 3A       abx  
FC48: A7 00    sta  $00,x
FC4A: DE CA    ldx  $CA
FC4C: 08       inx  
FC4D: DF CA    stx  $CA
FC4F: 20 8E    bra  $FBDF
FC51: 01       nop  
FC52: A5 E4    bita $E4,x
FC54: 01       nop  
FC55: BE FB 01 lds  $FB01
FC58: D9 9A    adcb $9A
FC5A: 01       nop  
FC5B: F5 C3 02 bitb $C302
FC5E: 13       asx2 1,s
FC5F: 8B 02    adda #$02
FC61: 33       pulb 
FC62: 34       des  
FC63: 02       illegal
FC64: 54       lsrb 
FC65: A8 02    eora $02,x
FC67: 78 28 02 asl  $2802
FC6A: 9D B4    jsr  $B4
FC6C: 02       illegal
FC6D: C5 78    bitb #$78
FC6F: 02       illegal
FC70: EF CB    stx  $CB,x
FC72: 03       illegal
FC73: 1C       illegal
FC74: 82 03    sbca #$03
FC76: 4B       illegal
FC77: C8 03    eorb #$03
FC79: 7D F6 03 tst  $F603
FC7C: B3 35 03 subd $3503
FC7F: EB 87    addb $87,x
FC81: 04       lsrd 
FC82: 27 17    beq  $FC9B
FC84: 04       lsrd 
FC85: 66 69    ror  $69,x
FC87: 04       lsrd 
FC88: A9 50    adca $50,x
FC8A: 04       lsrd 
FC8B: F0 50 05 subb $5005
FC8E: 3B       rti  
FC8F: 68 05    asl  $05,x
FC91: 8A F0    ora  #$F0
FC93: 05       asld 
FC94: DF 96    stx  $96
FC96: 06       tap  
FC97: 39       rts  
FC98: 04       lsrd 
FC99: 06       tap  
FC9A: 97 90    sta  $90
FC9C: 06       tap  
FC9D: FB EC 07 addb $EC07
FCA0: 66 6A    ror  $6A,x
FCA2: DE AE    ldx  $AE
FCA4: 86 23    lda  #$23
FCA6: E6 69    ldb  $69,x
FCA8: 3D       mul  
FCA9: D7 B9    stb  $B9
FCAB: 05       asld 
FCAC: E3 57    addd $57,x
FCAE: DD B1    std  $B1
FCB0: 86 03    lda  #$03
FCB2: E6 6A    ldb  $6A,x
FCB4: 3D       mul  
FCB5: D7 B8    stb  $B8
FCB7: E3 5D    addd $5D,x
FCB9: DD B3    std  $B3
FCBB: DE AE    ldx  $AE
FCBD: E6 69    ldb  $69,x
FCBF: 27 08    beq  $FCC9
FCC1: DE B1    ldx  $B1
FCC3: 86 15    lda  #$15
FCC5: 3D       mul  
FCC6: BD F3 5C jsr  $F35C
FCC9: DE AE    ldx  $AE
FCCB: EE 5D    ldx  $5D,x
FCCD: D6 B8    ldb  $B8
FCCF: 27 06    beq  $FCD7
FCD1: 86 03    lda  #$03
FCD3: 3D       mul  
FCD4: BD F3 5C jsr  $F35C
FCD7: 39       rts  
FCD8: 8D 04    bsr  $FCDE
FCDA: BD FD 29 jsr  $FD29
FCDD: 39       rts  
FCDE: DE AE    ldx  $AE
FCE0: A6 69    lda  $69,x
FCE2: 26 01    bne  $FCE5
FCE4: 39       rts  
FCE5: 97 CC    sta  $CC
FCE7: DE B1    ldx  $B1
FCE9: 7F 00 CD clr  $00CD
FCEC: A6 01    lda  $01,x
FCEE: 97 B6    sta  $B6
FCF0: D6 CD    ldb  $CD
FCF2: BD FE B7 jsr  $FEB7
FCF5: 43       coma 
FCF6: 48       asla 
FCF7: 48       asla 
FCF8: 48       asla 
FCF9: A7 01    sta  $01,x
FCFB: E6 02    ldb  $02,x
FCFD: 53       comb 
FCFE: 9A B6    ora  $B6
FD00: A4 02    anda $02,x
FD02: A7 02    sta  $02,x
FD04: A6 01    lda  $01,x
FD06: 94 B6    anda $B6
FD08: AA 02    ora  $02,x
FD0A: A7 02    sta  $02,x
FD0C: E4 02    andb $02,x
FD0E: E7 00    stb  $00,x
FD10: 08       inx  
FD11: 08       inx  
FD12: 08       inx  
FD13: 7C 00 CD inc  $00CD
FD16: 96 CD    lda  $CD
FD18: 84 07    anda #$07
FD1A: 81 07    cmpa #$07
FD1C: 26 CE    bne  $FCEC
FD1E: 7A 00 CC dec  $00CC
FD21: 27 05    beq  $FD28
FD23: 7C 00 CD inc  $00CD
FD26: 20 C4    bra  $FCEC
FD28: 39       rts  
FD29: DE AE    ldx  $AE
FD2B: EE 57    ldx  $57,x
FD2D: DF C8    stx  $C8
FD2F: DE B1    ldx  $B1
FD31: 8D 0D    bsr  $FD40
FD33: DE AE    ldx  $AE
FD35: EE 57    ldx  $57,x
FD37: 08       inx  
FD38: DF C8    stx  $C8
FD3A: DE B1    ldx  $B1
FD3C: 08       inx  
FD3D: 8D 01    bsr  $FD40
FD3F: 39       rts  
FD40: DF CA    stx  $CA
FD42: DE AE    ldx  $AE
FD44: A6 69    lda  $69,x
FD46: C6 07    ldb  #$07
FD48: 3D       mul  
FD49: D7 CD    stb  $CD
FD4B: 86 05    lda  #$05
FD4D: 97 B5    sta  $B5
FD4F: DE CA    ldx  $CA
FD51: E6 00    ldb  $00,x
FD53: 08       inx  
FD54: 08       inx  
FD55: 08       inx  
FD56: DF CA    stx  $CA
FD58: DE C8    ldx  $C8
FD5A: 4F       clra 
FD5B: 05       asld 
FD5C: A7 00    sta  $00,x
FD5E: 08       inx  
FD5F: 08       inx  
FD60: 7A 00 B5 dec  $00B5
FD63: 26 F5    bne  $FD5A
FD65: DF C8    stx  $C8
FD67: 7A 00 CD dec  $00CD
FD6A: 26 DF    bne  $FD4B
FD6C: 39       rts  
FD6D: 7F 11 88 clr  $1188
FD70: DE AE    ldx  $AE
FD72: EC 55    ldd  $55,x
FD74: DD C6    std  $C6
FD76: EC 57    ldd  $57,x
FD78: DD C8    std  $C8
FD7A: 96 B9    lda  $B9
FD7C: 97 B6    sta  $B6
FD7E: DE C8    ldx  $C8
FD80: EC 00    ldd  $00,x
FD82: 08       inx  
FD83: 08       inx  
FD84: DF C8    stx  $C8
FD86: DE C6    ldx  $C6
FD88: ED 00    std  $00,x
FD8A: 08       inx  
FD8B: 08       inx  
FD8C: DF C6    stx  $C6
FD8E: 7A 00 B6 dec  $00B6
FD91: 26 EB    bne  $FD7E
FD93: 7C 11 88 inc  $1188
FD96: 39       rts  
FD97: 8D 04    bsr  $FD9D
FD99: BD FE 23 jsr  $FE23
FD9C: 39       rts  
FD9D: DE AE    ldx  $AE
FD9F: EC 5B    ldd  $5B,x
FDA1: DD C6    std  $C6
FDA3: EC 5D    ldd  $5D,x
FDA5: DD C8    std  $C8
FDA7: DC B3    ldd  $B3
FDA9: DD CA    std  $CA
FDAB: EC 59    ldd  $59,x
FDAD: DD CC    std  $CC
FDAF: 96 B8    lda  $B8
FDB1: 97 B5    sta  $B5
FDB3: DE CC    ldx  $CC
FDB5: A6 00    lda  $00,x
FDB7: 27 39    beq  $FDF2
FDB9: DE CA    ldx  $CA
FDBB: A6 01    lda  $01,x
FDBD: 26 2F    bne  $FDEE
FDBF: A6 00    lda  $00,x
FDC1: 27 0C    beq  $FDCF
FDC3: 6F 00    clr  $00,x
FDC5: DE AE    ldx  $AE
FDC7: A6 60    lda  $60,x
FDC9: DE CA    ldx  $CA
FDCB: A7 01    sta  $01,x
FDCD: 20 1F    bra  $FDEE
FDCF: DC C6    ldd  $C6
FDD1: DE CC    ldx  $CC
FDD3: 6D 01    tst  $01,x
FDD5: 26 02    bne  $FDD9
FDD7: DC C8    ldd  $C8
FDD9: 18       xgdx 
FDDA: A6 00    lda  $00,x
FDDC: 27 29    beq  $FE07
FDDE: 6A 00    dec  $00,x
FDE0: DE CA    ldx  $CA
FDE2: 86 01    lda  #$01
FDE4: A7 00    sta  $00,x
FDE6: DE AE    ldx  $AE
FDE8: A6 5F    lda  $5F,x
FDEA: DE CA    ldx  $CA
FDEC: A7 01    sta  $01,x
FDEE: 6A 01    dec  $01,x
FDF0: 20 15    bra  $FE07
FDF2: DC C6    ldd  $C6
FDF4: DE CC    ldx  $CC
FDF6: 6D 01    tst  $01,x
FDF8: 26 02    bne  $FDFC
FDFA: DC C8    ldd  $C8
FDFC: 18       xgdx 
FDFD: A6 00    lda  $00,x
FDFF: 27 02    beq  $FE03
FE01: 86 01    lda  #$01
FE03: DE CA    ldx  $CA
FE05: A7 00    sta  $00,x
FE07: DE C6    ldx  $C6
FE09: 08       inx  
FE0A: DF C6    stx  $C6
FE0C: DE C8    ldx  $C8
FE0E: 08       inx  
FE0F: DF C8    stx  $C8
FE11: DE CA    ldx  $CA
FE13: 08       inx  
FE14: 08       inx  
FE15: DF CA    stx  $CA
FE17: DE CC    ldx  $CC
FE19: 08       inx  
FE1A: 08       inx  
FE1B: DF CC    stx  $CC
FE1D: 7A 00 B5 dec  $00B5
FE20: 26 91    bne  $FDB3
FE22: 39       rts  
FE23: DE AE    ldx  $AE
FE25: A6 6A    lda  $6A,x
FE27: 48       asla 
FE28: 48       asla 
FE29: 48       asla 
FE2A: 97 CC    sta  $CC
FE2C: 86 F8    lda  #$F8
FE2E: 97 B5    sta  $B5
FE30: DE B3    ldx  $B3
FE32: 4F       clra 
FE33: E6 00    ldb  $00,x
FE35: 54       lsrb 
FE36: 49       rola 
FE37: E6 02    ldb  $02,x
FE39: 54       lsrb 
FE3A: 49       rola 
FE3B: E6 04    ldb  $04,x
FE3D: 54       lsrb 
FE3E: 49       rola 
FE3F: D6 B5    ldb  $B5
FE41: CB 08    addb #$08
FE43: D1 CC    cmpb $CC
FE45: 27 0A    beq  $FE51
FE47: D7 B5    stb  $B5
FE49: BD FE 52 jsr  $FE52
FE4C: C6 06    ldb  #$06
FE4E: 3A       abx  
FE4F: 20 E1    bra  $FE32
FE51: 39       rts  
FE52: 3C       pshx 
FE53: 37       pshb 
FE54: CE 00 BA ldx  #$00BA
FE57: 54       lsrb 
FE58: 54       lsrb 
FE59: 54       lsrb 
FE5A: 3A       abx  
FE5B: 36       psha 
FE5C: 31       ins  
FE5D: 33       pulb 
FE5E: A1 00    cmpa $00,x
FE60: 27 1E    beq  $FE80
FE62: A7 00    sta  $00,x
FE64: 8D 1C    bsr  $FE82
FE66: CA 40    orb  #$40
FE68: D7 02    stb  $02
FE6A: CA C0    orb  #$C0
FE6C: D7 02    stb  $02
FE6E: 8D 2D    bsr  $FE9D
FE70: 8A C0    ora  #$C0
FE72: 97 02    sta  $02
FE74: 84 9F    anda #$9F
FE76: 97 02    sta  $02
FE78: 8A C0    ora  #$C0
FE7A: 97 02    sta  $02
FE7C: 8A E0    ora  #$E0
FE7E: 97 02    sta  $02
FE80: 38       pulx 
FE81: 39       rts  
FE82: 36       psha 
FE83: 17       tba  
FE84: C4 07    andb #$07
FE86: 84 18    anda #$18
FE88: 27 0F    beq  $FE99
FE8A: 85 10    bita #$10
FE8C: 27 05    beq  $FE93
FE8E: CE FE E2 ldx  #$FEE2
FE91: 20 03    bra  $FE96
FE93: CE FE DA ldx  #$FEDA
FE96: 3A       abx  
FE97: E6 00    ldb  $00,x
FE99: 1B       aba  
FE9A: 16       tab  
FE9B: 32       pula 
FE9C: 39       rts  
FE9D: C5 18    bitb #$18
FE9F: 27 15    beq  $FEB6
FEA1: C5 10    bitb #$10
FEA3: 27 05    beq  $FEAA
FEA5: CE FE E2 ldx  #$FEE2
FEA8: 20 03    bra  $FEAD
FEAA: CE FE DA ldx  #$FEDA
FEAD: 16       tab  
FEAE: C4 07    andb #$07
FEB0: 84 18    anda #$18
FEB2: 3A       abx  
FEB3: E6 00    ldb  $00,x
FEB5: 1B       aba  
FEB6: 39       rts  
FEB7: 3C       pshx 
FEB8: 8D C8    bsr  $FE82
FEBA: CA 60    orb  #$60
FEBC: D7 02    stb  $02
FEBE: CA E0    orb  #$E0
FEC0: D7 02    stb  $02
FEC2: 86 E0    lda  #$E0
FEC4: 97 00    sta  $00
FEC6: 86 A0    lda  #$A0
FEC8: 97 02    sta  $02
FECA: 96 02    lda  $02
FECC: 8D CF    bsr  $FE9D
FECE: C6 E0    ldb  #$E0
FED0: D7 02    stb  $02
FED2: C6 FF    ldb  #$FF
FED4: D7 00    stb  $00
FED6: 84 1F    anda #$1F
FED8: 38       pulx 
FED9: 39       rts  
FEDA: 00       illegal
FEDB: 02       illegal
FEDC: 01       nop  
FEDD: 03       illegal
FEDE: 04       lsrd 
FEDF: 06       tap  
FEE0: 05       asld 
FEE1: 07       tpa  
FEE2: 00       illegal
FEE3: 04       lsrd 
FEE4: 02       illegal
FEE5: 06       tap  
FEE6: 01       nop  
FEE7: 05       asld 
FEE8: 03       illegal
FEE9: 07       tpa  
FEEA: 01       nop  
FEEB: 00       illegal
FEEC: 01       nop  
FEED: 00       illegal
FEEE: 00       illegal
FEEF: 00       illegal
FEF0: 01       nop  
FEF1: 00       illegal
FEF2: FF FE F5 stx  $FEF5
FEF5: 0F       sei  
FEF6: 16       tab  
FEF7: 04       lsrd 
FEF8: 12       asx1 1,s
FEF9: 13       asx2 1,s
FEFA: 28 13    bvc  $FF0F
FEFC: 5C       incb 
FEFD: 02       illegal
FEFE: 02       illegal
FEFF: 00       illegal
FF00: 00       illegal
FF01: FF 05 FF stx  $05FF
FF04: 54       lsrb 
FF05: FF 12 04 stx  $1204
FF08: 06       tap  
FF09: 00       illegal
FF0A: 00       illegal
FF0B: FF 33 05 stx  $3305
FF0E: 16       tab  
FF0F: 00       illegal
FF10: 00       illegal
FF11: 11       cba  
FF12: 03       illegal
FF13: 08       inx  
FF14: B4 08 03 anda $0803
FF17: 08       inx  
FF18: 23 08    bls  $FF22
FF1A: 43       coma 
FF1B: 08       inx  
FF1C: 53       comb 
FF1D: 08       inx  
FF1E: 23 08    bls  $FF28
FF20: 43       coma 
FF21: 08       inx  
FF22: 43       coma 
FF23: 08       inx  
FF24: 23 08    bls  $FF2E
FF26: 53       comb 
FF27: 08       inx  
FF28: 43       coma 
FF29: 08       inx  
FF2A: 23 08    bls  $FF34
FF2C: 03       illegal
FF2D: 08       inx  
FF2E: B4 08 03 anda $0803
FF31: 08       inx  
FF32: E0 03    subb $03,x
FF34: 08       inx  
FF35: 23 08    bls  $FF3F
FF37: 43       coma 
FF38: 08       inx  
FF39: 53       comb 
FF3A: 08       inx  
FF3B: 73 08 93 com  $0893
FF3E: 08       inx  
FF3F: B3 08 02 subd $0802
FF42: 08       inx  
FF43: 02       illegal
FF44: 08       inx  
FF45: B3 08 93 subd $0893
FF48: 08       inx  
FF49: 73 08 53 com  $0853
FF4C: 08       inx  
FF4D: 43       coma 
FF4E: 08       inx  
FF4F: 23 08    bls  $FF59
FF51: 03       illegal
FF52: 08       inx  
FF53: E0 FF    subb $FF,x
FF55: 5B       illegal
FF56: 01       nop  
FF57: 09       dex  
FF58: 00       illegal
FF59: 00       illegal
FF5A: 11       cba  
FF5B: EA 20    orb  $20,x
FF5D: 08       inx  
FF5E: 40       nega 
FF5F: 08       inx  
FF60: 80 08    suba #$08
FF62: 00       illegal
FF63: E0 00    subb $00,x
FF65: 11       cba  
FF66: 22 33    bhi  $FF9B
FF68: 44       lsra 
FF69: 55       illegal
FF6A: 66 77    ror  $77,x
FF6C: 88 99    eora #$99
FF6E: AA BB    ora  $BB,x
FF70: CC DD EE ldd  #$DDEE
FF73: FF 86 FF stx  $86FF
FF76: 97 05    sta  $05
FF78: B6 80 00 lda  $8000
FF7B: 81 A6    cmpa #$A6
FF7D: 26 05    bne  $FF84
FF7F: FE 80 03 ldx  $8003
FF82: 26 51    bne  $FFD5
FF84: C6 08    ldb  #$08
FF86: 7E F3 3F jmp  $F33F
FF89: DE AE    ldx  $AE
FF8B: EE 10    ldx  $10,x
FF8D: 6E 00    jmp  $00,x
FF8F: DE AE    ldx  $AE
FF91: EE 0E    ldx  $0E,x
FF93: 6E 00    jmp  $00,x
FF95: DE AE    ldx  $AE
FF97: EE 0C    ldx  $0C,x
FF99: 6E 00    jmp  $00,x
FF9B: DE AE    ldx  $AE
FF9D: EE 0A    ldx  $0A,x
FF9F: 6E 00    jmp  $00,x
FFA1: DE AE    ldx  $AE
FFA3: EE 08    ldx  $08,x
FFA5: 6E 00    jmp  $00,x
FFA7: DE AE    ldx  $AE
FFA9: EE 06    ldx  $06,x
FFAB: 6E 00    jmp  $00,x
FFAD: B6 80 00 lda  $8000
FFB0: 81 A6    cmpa #$A6
FFB2: 26 05    bne  $FFB9
FFB4: FE 80 05 ldx  $8005
FFB7: 26 1C    bne  $FFD5
FFB9: C6 09    ldb  #$09
FFBB: 7E F3 3F jmp  $F33F
FFBE: 0F       sei  
FFBF: 72 40 14 oim  #$40,$14
FFC2: 86 FF    lda  #$FF
FFC4: 97 05    sta  $05
FFC6: B6 80 00 lda  $8000
FFC9: 81 A6    cmpa #$A6
FFCB: 26 05    bne  $FFD2
FFCD: FE 80 01 ldx  $8001
FFD0: 26 03    bne  $FFD5
FFD2: 7E F0 00 jmp  $F000
FFD5: 6E 00    jmp  $00,x

