ACR = $E84B
ShRegister = $E84A
Timer2 = $E848
pstLB = $FD
pstHB = $FE
;###############################################################################
*=$0401        ;PET build
        byte $0B,$04
;###########  TOGGLE COMMENTS TO BUILD FOR PET OR C64  #########################
;*=$0801         ;C64/debugger build
;        byte $0B,$08
;acr = $DD0B
;shregister = $DD0A
;timer2 = $DD08
;pstlb = $fd
;psthb = $fe
;###############################################################################

        byte $0A,$00,$9E,$34,$30,$39,$36,$00
        byte $00,$00

;soundfiles: octave, note, duration ,repeat. End with zero-byte.
Sound_00
        byte $33,$BC,$50,$33,$EE,$E0,$00
Sound_01
        byte $0F,$D2,$E0,$0F,$9E,$50,$00
Sound_02
        byte $0F,$EE,$40,$0F,$D2,$40
        byte $0F,$BC,$80,$0F,$8C,$A0
        byte $0F,$9E,$20,00
Sound_03
        byte $00,$00,$00,$00,$00,$00,$00
Sound_04
        byte $00,$00,$00,$00,$00,$00,$00
Sound_05
        byte $00,$00,$00,$00,$00,$00,$00
Sound_06
        byte $00,$00,$00,$00,$00,$00,$00

playsoundtable  ;soundfile RAM locations
    word Sound_00
    word Sound_01
    word Sound_02
    word Sound_03
    word Sound_04
    word Sound_05
    word Sound_06

*=$1000

        ldx #$00        ;play sound in X register
        jsr PlaySoundFromNumber
        rts

PlaySoundFromNumber
        TXA
        ASL     ;*2
        TAX
        LDA playsoundtable,X    ;get play sound pointer low byte
        STA pstLB
        LDA playsoundtable+1,X  ;get play sound pointer high byte
        STA pstHB        
        LDA #$10
        STA ACR         ;start ACR in free running mode
NoteStart
        LDY #$00        ;set index to zero
        LDA (pstLB),y   ;get octave
        BEQ sE6D0       ;zero-byte ends the soundfile
        STA ShRegister  ;store into shift register
        INY
        LDA (pstLB),y   ;get note
        STA Timer2      ;Put into timer2
        INY
        LDA (pstLB),y   ;get duration of note
        TAY
DurLoop
        DEY             ;duration loop
        BNE DurLoop
        SEC
        SBC #$01
        BNE DurLoop
        CLC
        LDA pstLB
        ADC #$03        ;increase soundfile pointer by 3
        STA pstLB
        BCC NoteStart
        INC pstHB
        BNE NoteStart   ;go play next note
sE6D0
        LDA #$00
        STA ShRegister  ;shift register and
        STA ACR         ;ACR hold #$00. Stops sound.
        RTS
;==================================================
;  Note Table:
;
;           octave=$0F     octave=$33     octave$55
;  Note    Oct.0 Oct.1  ! Oct.1 Oct.2 ! Oct.2 Oct.3
;  Freq  ------------------+-------------+-----------
;   B     FB 251   125 7D  !  251   125  !  251   125
;   C     EE 238   118 76  !  238   118  !  238   118
;   C#    E0 224   110 6E  !  224   110  !  224   110
;   D     D2 210   104 68  !  210   104  !  210   104
;   D#    C7 199    99 63  !  199    99  !  199    99
;   E     BC 188    93 5D  !  188    93  !  188    93
;   F     B1 177    88 58  !  177    88  !  177    88
;   F#    A8 168    83 53  !  168    83  !  168    83
;   G     9E 158    78 4E  !  158    78  !  158    78
;   G#    95 149    74 4A  !  149    74  !  149    74
;   A     8C 140    69 45  !  140    69  !  140    69
;   A#    85 133    65 41  !  133    65  !  133    65
;=====================================================
