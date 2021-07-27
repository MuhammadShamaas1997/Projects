
_main:

;MyProject.c,3 :: 		void main() {
;MyProject.c,5 :: 		ANSELA  = 0;                                    // Configure AN pins as digital I/O
	CLRF        ANSELA+0 
;MyProject.c,6 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;MyProject.c,7 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;MyProject.c,8 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;MyProject.c,9 :: 		ANSELE = 0;
	CLRF        ANSELE+0 
;MyProject.c,10 :: 		C1ON_bit = 0;                                  // Disable comparators
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;MyProject.c,11 :: 		C2ON_bit = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;MyProject.c,13 :: 		TRISB0_bit = 1;                                // set RB0 pin as input
	BSF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
;MyProject.c,15 :: 		TRISC = 0x00;                                  // Configure PORTC as output
	CLRF        TRISC+0 
;MyProject.c,16 :: 		PORTC = 0xFF;                                  // Initial PORTC value
	MOVLW       255
	MOVWF       PORTC+0 
;MyProject.c,17 :: 		oldstate = 0;
	BCF         _oldstate+0, BitPos(_oldstate+0) 
;MyProject.c,19 :: 		do {
L_main0:
;MyProject.c,20 :: 		if (Button(&PORTB, 0, 1, 1)) {               // Detect logical one
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main3
;MyProject.c,21 :: 		oldstate = 1;                              // Update flag
	BSF         _oldstate+0, BitPos(_oldstate+0) 
;MyProject.c,22 :: 		}
L_main3:
;MyProject.c,23 :: 		if (oldstate && Button(&PORTB, 0, 1, 0)) {   // Detect one-to-zero transition
	BTFSS       _oldstate+0, BitPos(_oldstate+0) 
	GOTO        L_main6
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
L__main7:
;MyProject.c,24 :: 		PORTC = ~PORTC;                            // Invert PORTC
	COMF        PORTC+0, 1 
;MyProject.c,25 :: 		oldstate = 0;                              // Update flag
	BCF         _oldstate+0, BitPos(_oldstate+0) 
;MyProject.c,26 :: 		}
L_main6:
;MyProject.c,27 :: 		} while(1);                                    // Endless loop
	GOTO        L_main0
;MyProject.c,28 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
