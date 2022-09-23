
_main:

;MyProject.c,15 :: 		void main() {
;MyProject.c,17 :: 		ANSELA  = 0;                                                 // Configure AN pins as digital I/O
	CLRF        ANSELA+0 
;MyProject.c,18 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;MyProject.c,19 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;MyProject.c,20 :: 		ANSELD = 0;
	CLRF        ANSELD+0 
;MyProject.c,21 :: 		ANSELE = 0;
	CLRF        ANSELE+0 
;MyProject.c,23 :: 		PORTB = 0;                                                  // clear PORTB
	CLRF        PORTB+0 
;MyProject.c,24 :: 		TRISB = 0;                                                  // set PORTB as output
	CLRF        TRISB+0 
;MyProject.c,26 :: 		Can_Init_Flags = 0;                                         //
	CLRF        _Can_Init_Flags+0 
;MyProject.c,27 :: 		Can_Send_Flags = 0;                                         // clear flags
	CLRF        _Can_Send_Flags+0 
;MyProject.c,28 :: 		Can_Rcv_Flags  = 0;                                         //
	CLRF        _Can_Rcv_Flags+0 
;MyProject.c,32 :: 		_CANSPI_TX_NO_RTR_FRAME;
	MOVLW       244
	MOVWF       _Can_Send_Flags+0 
;MyProject.c,38 :: 		_CANSPI_CONFIG_VALID_XTD_MSG;
	MOVLW       211
	MOVWF       _Can_Init_Flags+0 
;MyProject.c,41 :: 		SPI1_Init();                                                     // initialize SPI1 module
	CALL        _SPI1_Init+0, 0
;MyProject.c,43 :: 		CANSPIInitialize(1,3,3,3,1,Can_Init_Flags);                      // Initialize external CANSPI module
	MOVLW       1
	MOVWF       FARG_CANSPIInitialize_SJW+0 
	MOVLW       3
	MOVWF       FARG_CANSPIInitialize_BRP+0 
	MOVLW       3
	MOVWF       FARG_CANSPIInitialize_PHSEG1+0 
	MOVLW       3
	MOVWF       FARG_CANSPIInitialize_PHSEG2+0 
	MOVLW       1
	MOVWF       FARG_CANSPIInitialize_PROPSEG+0 
	MOVF        _Can_Init_Flags+0, 0 
	MOVWF       FARG_CANSPIInitialize_CANSPI_CONFIG_FLAGS+0 
	CALL        _CANSPIInitialize+0, 0
;MyProject.c,44 :: 		CANSPISetOperationMode(_CANSPI_MODE_CONFIG,0xFF);                // set CONFIGURATION mode
	MOVLW       128
	MOVWF       FARG_CANSPISetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSPISetOperationMode_WAIT+0 
	CALL        _CANSPISetOperationMode+0, 0
;MyProject.c,45 :: 		CANSPISetMask(_CANSPI_MASK_B1,-1,_CANSPI_CONFIG_XTD_MSG);        // set all mask1 bits to ones
	CLRF        FARG_CANSPISetMask_CANSPI_MASK+0 
	MOVLW       255
	MOVWF       FARG_CANSPISetMask_val+0 
	MOVLW       255
	MOVWF       FARG_CANSPISetMask_val+1 
	MOVWF       FARG_CANSPISetMask_val+2 
	MOVWF       FARG_CANSPISetMask_val+3 
	MOVLW       247
	MOVWF       FARG_CANSPISetMask_CANSPI_CONFIG_FLAGS+0 
	CALL        _CANSPISetMask+0, 0
;MyProject.c,46 :: 		CANSPISetMask(_CANSPI_MASK_B2,-1,_CANSPI_CONFIG_XTD_MSG);        // set all mask2 bits to ones
	MOVLW       1
	MOVWF       FARG_CANSPISetMask_CANSPI_MASK+0 
	MOVLW       255
	MOVWF       FARG_CANSPISetMask_val+0 
	MOVLW       255
	MOVWF       FARG_CANSPISetMask_val+1 
	MOVWF       FARG_CANSPISetMask_val+2 
	MOVWF       FARG_CANSPISetMask_val+3 
	MOVLW       247
	MOVWF       FARG_CANSPISetMask_CANSPI_CONFIG_FLAGS+0 
	CALL        _CANSPISetMask+0, 0
;MyProject.c,47 :: 		CANSPISetFilter(_CANSPI_FILTER_B2_F4,ID_2nd,_CANSPI_CONFIG_XTD_MSG);// set id of filter B2_F4 to 2nd node ID
	MOVLW       5
	MOVWF       FARG_CANSPISetFilter_CANSPI_FILTER+0 
	MOVLW       3
	MOVWF       FARG_CANSPISetFilter_val+0 
	MOVLW       0
	MOVWF       FARG_CANSPISetFilter_val+1 
	MOVLW       0
	MOVWF       FARG_CANSPISetFilter_val+2 
	MOVLW       0
	MOVWF       FARG_CANSPISetFilter_val+3 
	MOVLW       247
	MOVWF       FARG_CANSPISetFilter_CANSPI_CONFIG_FLAGS+0 
	CALL        _CANSPISetFilter+0, 0
;MyProject.c,49 :: 		CANSPISetOperationMode(_CANSPI_MODE_NORMAL,0xFF);                // set NORMAL mode
	CLRF        FARG_CANSPISetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSPISetOperationMode_WAIT+0 
	CALL        _CANSPISetOperationMode+0, 0
;MyProject.c,51 :: 		RxTx_Data[0] = 9;                                                // set initial data to be sent
	MOVLW       9
	MOVWF       _RxTx_Data+0 
;MyProject.c,53 :: 		CANSPIWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);               // send initial message
	MOVLW       79
	MOVWF       FARG_CANSPIWrite_id+0 
	MOVLW       47
	MOVWF       FARG_CANSPIWrite_id+1 
	MOVLW       0
	MOVWF       FARG_CANSPIWrite_id+2 
	MOVLW       0
	MOVWF       FARG_CANSPIWrite_id+3 
	MOVLW       _RxTx_Data+0
	MOVWF       FARG_CANSPIWrite_wr_data+0 
	MOVLW       hi_addr(_RxTx_Data+0)
	MOVWF       FARG_CANSPIWrite_wr_data+1 
	MOVLW       1
	MOVWF       FARG_CANSPIWrite_data_len+0 
	MOVF        _Can_Send_Flags+0, 0 
	MOVWF       FARG_CANSPIWrite_CANSPI_TX_MSG_FLAGS+0 
	CALL        _CANSPIWrite+0, 0
;MyProject.c,55 :: 		while(1) {                                                                 // endless loop
L_main0:
;MyProject.c,56 :: 		Msg_Rcvd = CANSPIRead(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);// receive message
	MOVLW       _Rx_ID+0
	MOVWF       FARG_CANSPIRead_id+0 
	MOVLW       hi_addr(_Rx_ID+0)
	MOVWF       FARG_CANSPIRead_id+1 
	MOVLW       _RxTx_Data+0
	MOVWF       FARG_CANSPIRead_rd_data+0 
	MOVLW       hi_addr(_RxTx_Data+0)
	MOVWF       FARG_CANSPIRead_rd_data+1 
	MOVLW       _Rx_Data_Len+0
	MOVWF       FARG_CANSPIRead_data_len+0 
	MOVLW       hi_addr(_Rx_Data_Len+0)
	MOVWF       FARG_CANSPIRead_data_len+1 
	MOVLW       _Can_Rcv_Flags+0
	MOVWF       FARG_CANSPIRead_CANSPI_RX_MSG_FLAGS+0 
	MOVLW       hi_addr(_Can_Rcv_Flags+0)
	MOVWF       FARG_CANSPIRead_CANSPI_RX_MSG_FLAGS+1 
	CALL        _CANSPIRead+0, 0
	MOVF        R0, 0 
	MOVWF       _Msg_Rcvd+0 
;MyProject.c,57 :: 		if ((Rx_ID == ID_2nd) && Msg_Rcvd) {                                     // if message received check id
	MOVF        _Rx_ID+3, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main8
	MOVF        _Rx_ID+2, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main8
	MOVF        _Rx_ID+1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main8
	MOVF        _Rx_ID+0, 0 
	XORLW       3
L__main8:
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
	MOVF        _Msg_Rcvd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main6:
;MyProject.c,58 :: 		PORTB = RxTx_Data[0];                                                  // id correct, output data at PORTC
	MOVF        _RxTx_Data+0, 0 
	MOVWF       PORTB+0 
;MyProject.c,59 :: 		RxTx_Data[0]++ ;                                                       // increment received data
	INCF        _RxTx_Data+0, 1 
;MyProject.c,60 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
;MyProject.c,61 :: 		CANSPIWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);                     // send incremented data back
	MOVLW       79
	MOVWF       FARG_CANSPIWrite_id+0 
	MOVLW       47
	MOVWF       FARG_CANSPIWrite_id+1 
	MOVLW       0
	MOVWF       FARG_CANSPIWrite_id+2 
	MOVLW       0
	MOVWF       FARG_CANSPIWrite_id+3 
	MOVLW       _RxTx_Data+0
	MOVWF       FARG_CANSPIWrite_wr_data+0 
	MOVLW       hi_addr(_RxTx_Data+0)
	MOVWF       FARG_CANSPIWrite_wr_data+1 
	MOVLW       1
	MOVWF       FARG_CANSPIWrite_data_len+0 
	MOVF        _Can_Send_Flags+0, 0 
	MOVWF       FARG_CANSPIWrite_CANSPI_TX_MSG_FLAGS+0 
	CALL        _CANSPIWrite+0, 0
;MyProject.c,62 :: 		}
L_main4:
;MyProject.c,63 :: 		}
	GOTO        L_main0
;MyProject.c,64 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
