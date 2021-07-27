#line 1 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC/PIC Button/MyProject.c"
bit oldstate;

void main() {

 ANSELA = 0;
 ANSELB = 0;
 ANSELC = 0;
 ANSELD = 0;
 ANSELE = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 TRISB0_bit = 1;

 TRISC = 0x00;
 PORTC = 0xFF;
 oldstate = 0;

 do {
 if (Button(&PORTB, 0, 1, 1)) {
 oldstate = 1;
 }
 if (oldstate && Button(&PORTB, 0, 1, 0)) {
 PORTC = ~PORTC;
 oldstate = 0;
 }
 } while(1);
}
