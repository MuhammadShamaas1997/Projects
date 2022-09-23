#line 1 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC/PIC CAN_SPI/MyProject.c"
unsigned char Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned char Rx_Data_Len;
char RxTx_Data[8];
char Msg_Rcvd;
const long ID_1st = 12111, ID_2nd = 3;
long Rx_ID;


sbit CanSpi_CS at RC0_bit;
sbit CanSpi_CS_Direction at TRISC0_bit;
sbit CanSpi_Rst at RC2_bit;
sbit CanSpi_Rst_Direction at TRISC2_bit;


void main() {

 ANSELA = 0;
 ANSELB = 0;
 ANSELC = 0;
 ANSELD = 0;
 ANSELE = 0;

 PORTB = 0;
 TRISB = 0;

 Can_Init_Flags = 0;
 Can_Send_Flags = 0;
 Can_Rcv_Flags = 0;

 Can_Send_Flags = _CANSPI_TX_PRIORITY_0 &
 _CANSPI_TX_XTD_FRAME &
 _CANSPI_TX_NO_RTR_FRAME;

 Can_Init_Flags = _CANSPI_CONFIG_SAMPLE_THRICE &
 _CANSPI_CONFIG_PHSEG2_PRG_ON &
 _CANSPI_CONFIG_XTD_MSG &
 _CANSPI_CONFIG_DBL_BUFFER_ON &
 _CANSPI_CONFIG_VALID_XTD_MSG;


 SPI1_Init();

 CANSPIInitialize(1,3,3,3,1,Can_Init_Flags);
 CANSPISetOperationMode(_CANSPI_MODE_CONFIG,0xFF);
 CANSPISetMask(_CANSPI_MASK_B1,-1,_CANSPI_CONFIG_XTD_MSG);
 CANSPISetMask(_CANSPI_MASK_B2,-1,_CANSPI_CONFIG_XTD_MSG);
 CANSPISetFilter(_CANSPI_FILTER_B2_F4,ID_2nd,_CANSPI_CONFIG_XTD_MSG);

 CANSPISetOperationMode(_CANSPI_MODE_NORMAL,0xFF);

 RxTx_Data[0] = 9;

 CANSPIWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);

 while(1) {
 Msg_Rcvd = CANSPIRead(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);
 if ((Rx_ID == ID_2nd) && Msg_Rcvd) {
 PORTB = RxTx_Data[0];
 RxTx_Data[0]++ ;
 Delay_ms(10);
 CANSPIWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);
 }
 }
}
