#line 1 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC ADC/MyProject.c"
unsigned int temp_res;

void main() {
 ANSELA = 0x04;
 ANSELB = 0;
 ANSELC = 0;
 ANSELD = 0;
 ANSELE = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 TRISA = 0xFF;
 TRISC = 0;
 TRISB = 0;

 do {
 temp_res = ADC_Read(2);
 PORTB = temp_res;
 PORTC = temp_res >> 8;
 } while(1);
}
