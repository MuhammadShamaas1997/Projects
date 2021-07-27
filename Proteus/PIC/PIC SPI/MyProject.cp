#line 1 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC/PIC SPI/MyProject.c"

sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;


unsigned int value;

void InitMain() {
 TRISA0_bit = 1;
 TRISA1_bit = 1;
 Chip_Select = 1;
 Chip_Select_Direction = 0;
 SPI1_Init();
}


void DAC_Output(unsigned int valueDAC) {
 char temp;

 Chip_Select = 0;


 temp = (valueDAC >> 8) & 0x0F;
 temp |= 0x30;
 SPI1_Write(temp);


 temp = valueDAC;
 SPI1_Write(temp);

 Chip_Select = 1;
}

void main() {
 ANSELA = 0;
 ANSELB = 0;
 ANSELC = 0;
 ANSELD = 0;
 ANSELE = 0;
 InitMain();

 value = 2048;


 while (1) {

 if ((RA0_bit) && (value < 4095)) {
 value++;
 }
 else {
 if ((RA1_bit) && (value > 0)) {
 value--;
 }
 }
 DAC_Output(value);
 Delay_ms(1);
 }
}
