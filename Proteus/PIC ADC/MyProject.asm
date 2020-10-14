
_main:

;MyProject.c,3 :: 		void main() {
;MyProject.c,4 :: 		ANSELA  = 0x04;              // Configure AN2 pin as analog
	MOVLW       4
	MOVWF       ANSELA+0 
;MyProject.c,5 :: 		ANSELB = 0;                 // Configure other AN pins as digital I/O
	CLRF        ANSELB+0 
;MyProject.c,6 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;MyProject.c,7 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;MyProject.c,8 :: 		ANSELE = 0;
	CLRF        ANSELE+0 
;MyProject.c,9 :: 		C1ON_bit = 0;               // Disable comparators
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;MyProject.c,10 :: 		C2ON_bit = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;MyProject.c,12 :: 		TRISA  = 0xFF;              // PORTA is input
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,13 :: 		TRISC  = 0;                 // PORTC is output
	CLRF        TRISC+0 
;MyProject.c,14 :: 		TRISB  = 0;                 // PORTB is output
	CLRF        TRISB+0 
;MyProject.c,16 :: 		do {
L_main0:
;MyProject.c,17 :: 		temp_res = ADC_Read(2);   // Get 10-bit results of AD conversion
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_res+0 
	MOVF        R1, 0 
	MOVWF       _temp_res+1 
;MyProject.c,18 :: 		PORTB = temp_res;         // Send lower 8 bits to PORTB
	MOVF        R0, 0 
	MOVWF       PORTB+0 
;MyProject.c,19 :: 		PORTC = temp_res >> 8;    // Send 2 most significant bits to RC1, RC0
	MOVF        R1, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVF        R2, 0 
	MOVWF       PORTC+0 
;MyProject.c,20 :: 		} while(1);
	GOTO        L_main0
;MyProject.c,21 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
