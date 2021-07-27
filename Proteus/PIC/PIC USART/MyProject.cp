#line 1 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC/PIC USART/MyProject.c"
char ii;

void main(){
 ANSELA = 0;
 ANSELB = 0;
 ANSELC = 0;
 ANSELD = 0;
 ANSELE = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 PORTB = 0;
 PORTC = 0;
 PORTD = 0;

 TRISB = 0;
 TRISC = 0;
 TRISD = 0;
 while(1){
 for(ii = 0; ii < 32; ii++)
 EEPROM_Write(0x80+ii, ii);

 EEPROM_Write(0x02,0xAA);
 EEPROM_Write(0x50,0x55);

 Delay_ms(1000);
 PORTB = 0xFF;
 PORTC = 0xFF;
 Delay_ms(1000);
 PORTB = 0x00;
 PORTC = 0x00;
 Delay_ms(1000);

 PORTB = EEPROM_Read(0x02);
 PORTC = EEPROM_Read(0x50);

 Delay_ms(1000);

 for(ii = 0; ii < 32; ii++)
 {
 PORTD = EEPROM_Read(0x80+ii);
 Delay_ms(250);
 }
 }
}
