
_InitMain:

;MyProject.c,8 :: 		void InitMain() {
;MyProject.c,9 :: 		TRISA0_bit = 1;                        // Set RA0 pin as input
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;MyProject.c,10 :: 		TRISA1_bit = 1;                        // Set RA1 pin as input
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;MyProject.c,11 :: 		Chip_Select = 1;                       // Deselect DAC
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;MyProject.c,12 :: 		Chip_Select_Direction = 0;             // Set CS# pin as Output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;MyProject.c,13 :: 		SPI1_Init();                           // Initialize SPI module
	CALL        _SPI1_Init+0, 0
;MyProject.c,14 :: 		}
L_end_InitMain:
	RETURN      0
; end of _InitMain

_DAC_Output:

;MyProject.c,17 :: 		void DAC_Output(unsigned int valueDAC) {
;MyProject.c,20 :: 		Chip_Select = 0;                       // Select DAC chip
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;MyProject.c,23 :: 		temp = (valueDAC >> 8) & 0x0F;         // Store valueDAC[11..8] to temp[3..0]
	MOVF        FARG_DAC_Output_valueDAC+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;MyProject.c,24 :: 		temp |= 0x30;                          // Define DAC setting, see MCP4921 datasheet
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;MyProject.c,25 :: 		SPI1_Write(temp);                      // Send high byte via SPI
	CALL        _SPI1_Write+0, 0
;MyProject.c,29 :: 		SPI1_Write(temp);                      // Send low byte via SPI
	MOVF        FARG_DAC_Output_valueDAC+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;MyProject.c,31 :: 		Chip_Select = 1;                       // Deselect DAC chip
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;MyProject.c,32 :: 		}
L_end_DAC_Output:
	RETURN      0
; end of _DAC_Output

_main:

;MyProject.c,34 :: 		void main() {
;MyProject.c,35 :: 		ANSELA = 0;
	CLRF        ANSELA+0 
;MyProject.c,36 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;MyProject.c,37 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;MyProject.c,38 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;MyProject.c,39 :: 		ANSELE = 0;
	CLRF        ANSELE+0 
;MyProject.c,40 :: 		InitMain();                            // Perform main initialization
	CALL        _InitMain+0, 0
;MyProject.c,42 :: 		value = 2048;                          // When program starts, DAC gives
	MOVLW       0
	MOVWF       _value+0 
	MOVLW       8
	MOVWF       _value+1 
;MyProject.c,45 :: 		while (1) {                             // Endless loop
L_main0:
;MyProject.c,47 :: 		if ((RA0_bit) && (value < 4095)) {   // If RA0 button is pressed
	BTFSS       RA0_bit+0, BitPos(RA0_bit+0) 
	GOTO        L_main4
	MOVLW       15
	SUBWF       _value+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVLW       255
	SUBWF       _value+0, 0 
L__main15:
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
L__main11:
;MyProject.c,48 :: 		value++;                           //   increment value
	INFSNZ      _value+0, 1 
	INCF        _value+1, 1 
;MyProject.c,49 :: 		}
	GOTO        L_main5
L_main4:
;MyProject.c,51 :: 		if ((RA1_bit) && (value > 0)) {    // If RA1 button is pressed
	BTFSS       RA1_bit+0, BitPos(RA1_bit+0) 
	GOTO        L_main8
	MOVLW       0
	MOVWF       R0 
	MOVF        _value+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main16
	MOVF        _value+0, 0 
	SUBLW       0
L__main16:
	BTFSC       STATUS+0, 0 
	GOTO        L_main8
L__main10:
;MyProject.c,52 :: 		value--;                         //   decrement value
	MOVLW       1
	SUBWF       _value+0, 1 
	MOVLW       0
	SUBWFB      _value+1, 1 
;MyProject.c,53 :: 		}
L_main8:
;MyProject.c,54 :: 		}
L_main5:
;MyProject.c,55 :: 		DAC_Output(value);                   // Send value to DAC chip
	MOVF        _value+0, 0 
	MOVWF       FARG_DAC_Output_valueDAC+0 
	MOVF        _value+1, 0 
	MOVWF       FARG_DAC_Output_valueDAC+1 
	CALL        _DAC_Output+0, 0
;MyProject.c,56 :: 		Delay_ms(1);                         // Slow down key repeat pace
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	NOP
	NOP
;MyProject.c,57 :: 		}
	GOTO        L_main0
;MyProject.c,58 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
