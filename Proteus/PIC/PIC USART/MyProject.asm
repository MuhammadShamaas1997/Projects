
_main:

;MyProject.c,3 :: 		void main(){
;MyProject.c,4 :: 		ANSELA =  0;                            // Configure AN pins as digital I/O
	CLRF        ANSELA+0 
;MyProject.c,5 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;MyProject.c,6 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;MyProject.c,7 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;MyProject.c,8 :: 		ANSELE = 0;
	CLRF        ANSELE+0 
;MyProject.c,9 :: 		C1ON_bit = 0;                          // Disable comparators
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;MyProject.c,10 :: 		C2ON_bit = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;MyProject.c,12 :: 		PORTB = 0;
	CLRF        PORTB+0 
;MyProject.c,13 :: 		PORTC = 0;
	CLRF        PORTC+0 
;MyProject.c,14 :: 		PORTD = 0;
	CLRF        PORTD+0 
;MyProject.c,16 :: 		TRISB = 0;
	CLRF        TRISB+0 
;MyProject.c,17 :: 		TRISC = 0;
	CLRF        TRISC+0 
;MyProject.c,18 :: 		TRISD = 0;
	CLRF        TRISD+0 
;MyProject.c,19 :: 		while(1){
L_main0:
;MyProject.c,20 :: 		for(ii = 0; ii < 32; ii++)             // Fill data buffer
	CLRF        _ii+0 
L_main2:
	MOVLW       32
	SUBWF       _ii+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main3
;MyProject.c,21 :: 		EEPROM_Write(0x80+ii, ii);           // Write data to address 0x80+ii
	MOVF        _ii+0, 0 
	ADDLW       128
	MOVWF       FARG_EEPROM_Write_address+0 
	CLRF        FARG_EEPROM_Write_address+1 
	MOVLW       0
	ADDWFC      FARG_EEPROM_Write_address+1, 1 
	MOVF        _ii+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyProject.c,20 :: 		for(ii = 0; ii < 32; ii++)             // Fill data buffer
	INCF        _ii+0, 1 
;MyProject.c,21 :: 		EEPROM_Write(0x80+ii, ii);           // Write data to address 0x80+ii
	GOTO        L_main2
L_main3:
;MyProject.c,23 :: 		EEPROM_Write(0x02,0xAA);               // Write some data at address 2
	MOVLW       2
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       170
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyProject.c,24 :: 		EEPROM_Write(0x50,0x55);               // Write some data at address 0150
	MOVLW       80
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       85
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;MyProject.c,26 :: 		Delay_ms(1000);                        // Blink PORTB and PORTC LEDs
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	DECFSZ      R11, 1, 1
	BRA         L_main5
	NOP
	NOP
;MyProject.c,27 :: 		PORTB = 0xFF;                          //   to indicate reading start
	MOVLW       255
	MOVWF       PORTB+0 
;MyProject.c,28 :: 		PORTC = 0xFF;
	MOVLW       255
	MOVWF       PORTC+0 
;MyProject.c,29 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
	DECFSZ      R11, 1, 1
	BRA         L_main6
	NOP
	NOP
;MyProject.c,30 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;MyProject.c,31 :: 		PORTC = 0x00;
	CLRF        PORTC+0 
;MyProject.c,32 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main7:
	DECFSZ      R13, 1, 1
	BRA         L_main7
	DECFSZ      R12, 1, 1
	BRA         L_main7
	DECFSZ      R11, 1, 1
	BRA         L_main7
	NOP
	NOP
;MyProject.c,34 :: 		PORTB = EEPROM_Read(0x02);             // Read data from address 2 and display it on PORTB
	MOVLW       2
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       PORTB+0 
;MyProject.c,35 :: 		PORTC = EEPROM_Read(0x50);             // Read data from address 0x50 and display it on PORTC
	MOVLW       80
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       0
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       PORTC+0 
;MyProject.c,37 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main8:
	DECFSZ      R13, 1, 1
	BRA         L_main8
	DECFSZ      R12, 1, 1
	BRA         L_main8
	DECFSZ      R11, 1, 1
	BRA         L_main8
	NOP
	NOP
;MyProject.c,39 :: 		for(ii = 0; ii < 32; ii++)
	CLRF        _ii+0 
L_main9:
	MOVLW       32
	SUBWF       _ii+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main10
;MyProject.c,41 :: 		PORTD = EEPROM_Read(0x80+ii);        //   and display data on PORTD
	MOVF        _ii+0, 0 
	ADDLW       128
	MOVWF       FARG_EEPROM_Read_address+0 
	CLRF        FARG_EEPROM_Read_address+1 
	MOVLW       0
	ADDWFC      FARG_EEPROM_Read_address+1, 1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       PORTD+0 
;MyProject.c,42 :: 		Delay_ms(250);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	DECFSZ      R12, 1, 1
	BRA         L_main12
	DECFSZ      R11, 1, 1
	BRA         L_main12
	NOP
	NOP
;MyProject.c,39 :: 		for(ii = 0; ii < 32; ii++)
	INCF        _ii+0, 1 
;MyProject.c,43 :: 		}
	GOTO        L_main9
L_main10:
;MyProject.c,44 :: 		}
	GOTO        L_main0
;MyProject.c,45 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
