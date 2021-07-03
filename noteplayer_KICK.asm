.label acr = $e84b
.label shregister = $e84a
.label timer2 = $e848
.label pstlb = $fd
.label psthb = $fe
*=$0401        //pet build
        .byte $0b,$04
//###########  TOGGLE BLOCK COMMENTS TO BUILD FOR PET (above) OR C64  ############
/* *=$0801         //c64/debugger build
         .byte $0b,$08
.label acr = $DD0B
.label shregister = $DD0A
.label timer2 = $DD08
.label pstlb = $fd
.label psthb = $fe
 */
 //###############################################################################
        .byte $0a,$00,$9e,$34,$30,$39,$36,$00
        .byte $00,$00

//soundfiles: octave, note, duration ,repeat. end with zero-byte.
sound_00:
        .byte $0f,$5d,$e0,$33,$ec,$e0,$00
sound_01:
        .byte $0f,$d2,$e0,$0f,$9d,$50,$00
sound_02:
        .byte $33,$ec,$40,$33,$d2,$40
        .byte $33,$bb,$80,$33,$8b,$e0
        .byte $33,$9d,$40,00
sound_03:
        .byte $0f,$75,$40,$0f,$68,$40
        .byte $0f,$5c,$80,$0f,$45,$e0
        .byte $0f,$4d,$40,00
sound_04:
        .byte $55,$75,$40,$55,$68,$40
        .byte $55,$5c,$80,$55,$45,$e0
        .byte $55,$4d,$40,00
sound_05:
        .byte $00,$00,$00,$00,$00,$00,$00
sound_06:
        .byte $00,$00,$00,$00,$00,$00,$00

playsoundtable:  //soundfile vectors
    .word sound_00
    .word sound_01
    .word sound_02
    .word sound_03
    .word sound_04
    .word sound_05
    .word sound_06

*=$1000
        ldx #$03        //play sound in x register
        jsr playsoundfromnumber
        rts

playsoundfromnumber:
        txa
        asl     //*2
        tax
        lda playsoundtable,x    //get play sound pointer low byte
        sta pstlb
        lda playsoundtable+1,x  //get play sound pointer high byte
        sta psthb        
        lda #$10
        sta acr         //start acr in free running mode
notestart:
        ldy #$00        //set index to zero
        lda (pstlb),y   //get octave
        beq se6d0       //zero-byte ends the soundfile
        sta shregister  //store into shift register
        iny
        lda (pstlb),y   //get note
        sta timer2      //put into timer2
        iny
        lda (pstlb),y   //get duration of note
        tay
durloop:
        dey             //duration loop
        bne durloop
        sec
        sbc #$01
        bne durloop
        clc
        lda pstlb
        adc #$03        //increase soundfile pointer by 3
        sta pstlb
        bcc notestart
        inc psthb
        bne notestart   //go play next note
se6d0:
        lda #$00
        sta shregister  //shift register and
        sta acr         //acr hold #$00. stops sound.
        rts
//====================================================
//  note table:
//
//           octave=$0f     octave=$33     octave$55
//  note    oct.0 oct.1  ! oct.1 oct.2 ! oct.2 oct.3
//  freq  ------------------+-------------+-----------
//   b     fa 250   124 7c  !  251   125  !  251   125
//   c     ec 236   117 75  !  238   118  !  238   118
//   c#    df 223   110 6e  !  224   110  !  224   110
//   d     d2 210   104 68  !  210   104  !  210   104
//   d#    c6 198    98 62  !  199    99  !  199    99
//   e     bbx187    93 5c  !  188    93  !  188    93
//   f     b0x176    87 57  !  177    88  !  177    88
//   f#    a6x166    82 52  !  168    83  !  168    83
//   g     9dx157    77 4d  !  158    78  !  158    78
//   g#    94x148    73 49  !  149    74  !  149    74
//   a     8b 139    69 45  !  140    69  !  140    69
//   a#    84 132    65 41  !  133    65  !  133    65
//====================================================
//======= octave1 0f note 68 sounds better than ======
//======= octave1 33 note d2.                   ======
//======= x notes e to g# are weak in volume    ======
//====================================================