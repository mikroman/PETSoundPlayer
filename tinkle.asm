; 10 SYS4096

*=$0401

        BYTE    $0B, $04, $0A, $00, $9E, $34, $30, $39, $36, $00, $00, $00

timer2low                       ;notes/Timer 2 LO Values
        byte $0E, $1E, $3E, $7E, $3E, $1E, $0E

*=$1000

InitRestTime
           LDY #$10             ;note duration
           STY $E7
iE6A7
           LDY $E7
           BEQ sE6D0
           LDA #$10
           STA $E84B            ;ACR in free running mode
           LDA #$0F
           STA $E84A            ;shift register holds 00001111
           LDX #$06             ;number of notes-1
iE6B7
           LDA timer2low,x      ;Timer 2 LO table
           STA $E848            ;Put into timer2
           LDA $E7              ;note duration
iE6BF
           DEY
           BNE iE6BF
           SEC
           SBC #$01
           BNE iE6BF
           DEX
           BNE iE6B7            ;play next note
           STX $E84A            ;shift register and
           STX $E84B            ;ACR hold #$00. STOP SOUND
sE6D0
           RTS