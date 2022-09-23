
_InitMain:

;MyProject.c,30 :: 		void InitMain() {
;MyProject.c,31 :: 		ANSELA  = 0;                         // Configure AN pins as digital
	CLRF        ANSELA+0 
;MyProject.c,32 :: 		ANSELB  = 0;
	CLRF        ANSELB+0 
;MyProject.c,33 :: 		ANSELC  = 0;
	CLRF        ANSELC+0 
;MyProject.c,34 :: 		ANSELD  = 0;
	CLRF        ANSELD+0 
;MyProject.c,35 :: 		ANSELE = 0;
	CLRF        ANSELE+0 
;MyProject.c,36 :: 		C1ON_bit = 0;                       // Disable comparators
	BCF         C1ON_bit+0, BitPos(C1ON_bit+0) 
;MyProject.c,37 :: 		C2ON_bit = 0;
	BCF         C2ON_bit+0, BitPos(C2ON_bit+0) 
;MyProject.c,39 :: 		PORTA = 255;
	MOVLW       255
	MOVWF       PORTA+0 
;MyProject.c,40 :: 		TRISA = 255;                        // configure PORTA pins as input
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,41 :: 		PORTB = 0;                          // set PORTB to 0
	CLRF        PORTB+0 
;MyProject.c,42 :: 		TRISB = 0;                          // designate PORTB pins as output
	CLRF        TRISB+0 
;MyProject.c,43 :: 		PORTC = 0;                          // set PORTC to 0
	CLRF        PORTC+0 
;MyProject.c,44 :: 		TRISC = 0;                          // designate PORTC pins as output
	CLRF        TRISC+0 
;MyProject.c,45 :: 		PWM1_Init(20000);                    // Initialize PWM1 module at 5KHz
	BCF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;MyProject.c,46 :: 		PWM2_Init(20000);                    // Initialize PWM2 module at 5KHz
	BCF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM2_Init+0, 0
;MyProject.c,47 :: 		}
L_end_InitMain:
	RETURN      0
; end of _InitMain

_main:

;MyProject.c,49 :: 		void main() {
;MyProject.c,50 :: 		InitMain();
	CALL        _InitMain+0, 0
;MyProject.c,51 :: 		current_duty  = 16;                 // initial value for current_duty
	MOVLW       16
	MOVWF       _current_duty+0 
;MyProject.c,52 :: 		current_duty1 = 16;                 // initial value for current_duty1
	MOVLW       16
	MOVWF       _current_duty1+0 
;MyProject.c,54 :: 		PWM1_Start();                       // start PWM1
	CALL        _PWM1_Start+0, 0
;MyProject.c,55 :: 		PWM2_Start();                       // start PWM2
	CALL        _PWM2_Start+0, 0
;MyProject.c,56 :: 		PWM1_Set_Duty(current_duty);        // Set current duty for PWM1
	MOVF        _current_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;MyProject.c,57 :: 		PWM2_Set_Duty(current_duty1);       // Set current duty for PWM2
	MOVF        _current_duty1+0, 0 
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;MyProject.c,59 :: 		while (1) {                         // endless loop
L_main0:
;MyProject.c,60 :: 		if (RA0_bit) {                    // button on RA0 pressed
	BTFSS       RA0_bit+0, BitPos(RA0_bit+0) 
	GOTO        L_main2
;MyProject.c,61 :: 		Delay_ms(40);
	MOVLW       104
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	NOP
;MyProject.c,62 :: 		current_duty++;                 // increment current_duty
	INCF        _current_duty+0, 1 
;MyProject.c,63 :: 		PWM1_Set_Duty(current_duty);
	MOVF        _current_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;MyProject.c,64 :: 		}
L_main2:
;MyProject.c,66 :: 		if (RA1_bit) {                    // button on RA1 pressed
	BTFSS       RA1_bit+0, BitPos(RA1_bit+0) 
	GOTO        L_main4
;MyProject.c,67 :: 		Delay_ms(40);
	MOVLW       104
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
;MyProject.c,68 :: 		current_duty--;                 // decrement current_duty
	DECF        _current_duty+0, 1 
;MyProject.c,69 :: 		PWM1_Set_Duty(current_duty);
	MOVF        _current_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;MyProject.c,70 :: 		}
L_main4:
;MyProject.c,72 :: 		if (RA2_bit) {                    // button on RA2 pressed
	BTFSS       RA2_bit+0, BitPos(RA2_bit+0) 
	GOTO        L_main6
;MyProject.c,73 :: 		Delay_ms(40);
	MOVLW       104
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_main7:
	DECFSZ      R13, 1, 1
	BRA         L_main7
	DECFSZ      R12, 1, 1
	BRA         L_main7
	NOP
;MyProject.c,74 :: 		current_duty1++;                // increment current_duty1
	INCF        _current_duty1+0, 1 
;MyProject.c,75 :: 		PWM2_Set_Duty(current_duty1);
	MOVF        _current_duty1+0, 0 
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;MyProject.c,76 :: 		}
L_main6:
;MyProject.c,78 :: 		if (RA3_bit) {                    // button on RA3 pressed
	BTFSS       RA3_bit+0, BitPos(RA3_bit+0) 
	GOTO        L_main8
;MyProject.c,79 :: 		Delay_ms(40);
	MOVLW       104
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	NOP
;MyProject.c,80 :: 		current_duty1--;                // decrement current_duty1
	DECF        _current_duty1+0, 1 
;MyProject.c,81 :: 		PWM2_Set_Duty(current_duty1);
	MOVF        _current_duty1+0, 0 
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;MyProject.c,82 :: 		}
L_main8:
;MyProject.c,84 :: 		Delay_ms(5);                      // slow down change pace a little
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	NOP
	NOP
;MyProject.c,85 :: 		}
	GOTO        L_main0
;MyProject.c,86 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
