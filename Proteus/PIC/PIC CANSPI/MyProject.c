unsigned char Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags; // can flags
unsigned char Rx_Data_Len;                                   // received data length in bytes
char RxTx_Data[8];                                           // can rx/tx data buffer
char Msg_Rcvd;                                               // reception flag
const long ID_1st = 12111, ID_2nd = 3;                       // node IDs
long Rx_ID;

// CANSPI module connections
sbit CanSpi_CS            at  RC0_bit;
sbit CanSpi_CS_Direction  at  TRISC0_bit;
sbit CanSpi_Rst           at  RC2_bit;
sbit CanSpi_Rst_Direction at  TRISC2_bit;
// End CANSPI module connections

void main() {

  ANSELA  = 0;                                                 // Configure AN pins as digital I/O
  ANSELB = 0;
  ANSELC = 0;
  ANSELD = 0;
  ANSELE = 0;

  PORTB = 0;                                                  // clear PORTB
  TRISB = 0;                                                  // set PORTB as output

  Can_Init_Flags = 0;                                         //
  Can_Send_Flags = 0;                                         // clear flags
  Can_Rcv_Flags  = 0;                                         //

  Can_Send_Flags = _CANSPI_TX_PRIORITY_0 &                    // form value to be used
                   _CANSPI_TX_XTD_FRAME &                     //     with CANSPIWrite
                   _CANSPI_TX_NO_RTR_FRAME;

  Can_Init_Flags = _CANSPI_CONFIG_SAMPLE_THRICE &             // Form value to be used
                   _CANSPI_CONFIG_PHSEG2_PRG_ON &             //  with CANSPIInit
                   _CANSPI_CONFIG_XTD_MSG &
                   _CANSPI_CONFIG_DBL_BUFFER_ON &
                   _CANSPI_CONFIG_VALID_XTD_MSG;


  SPI1_Init();                                                     // initialize SPI1 module

  CANSPIInitialize(1,3,3,3,1,Can_Init_Flags);                      // Initialize external CANSPI module
  CANSPISetOperationMode(_CANSPI_MODE_CONFIG,0xFF);                // set CONFIGURATION mode
  CANSPISetMask(_CANSPI_MASK_B1,-1,_CANSPI_CONFIG_XTD_MSG);        // set all mask1 bits to ones
  CANSPISetMask(_CANSPI_MASK_B2,-1,_CANSPI_CONFIG_XTD_MSG);        // set all mask2 bits to ones
  CANSPISetFilter(_CANSPI_FILTER_B2_F4,ID_2nd,_CANSPI_CONFIG_XTD_MSG);// set id of filter B2_F4 to 2nd node ID

  CANSPISetOperationMode(_CANSPI_MODE_NORMAL,0xFF);                // set NORMAL mode

  RxTx_Data[0] = 9;                                                // set initial data to be sent

  CANSPIWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);               // send initial message

  while(1) {                                                                 // endless loop
    Msg_Rcvd = CANSPIRead(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);// receive message
    if ((Rx_ID == ID_2nd) && Msg_Rcvd) {                                     // if message received check id
      PORTB = RxTx_Data[0];                                                  // id correct, output data at PORTC
      RxTx_Data[0]++ ;                                                       // increment received data
      Delay_ms(10);
      CANSPIWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);                     // send incremented data back
    }
  }
}

