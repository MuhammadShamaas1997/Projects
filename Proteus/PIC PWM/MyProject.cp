#line 1 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC/MyProject.c"
#line 28 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC/MyProject.c"
unsigned short current_duty, old_duty, current_duty1, old_duty1;

void InitMain() {
 ANSELA = 0;
 ANSELB = 0;
 ANSELC = 0;
 ANSELD = 0;
 ANSELE = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 PORTA = 255;
 TRISA = 255;
 PORTB = 0;
 TRISB = 0;
 PORTC = 0;
 TRISC = 0;
 PWM1_Init(20000);
 PWM2_Init(20000);
}

void main() {
 InitMain();
 current_duty = 16;
 current_duty1 = 16;

 PWM1_Start();
 PWM2_Start();
 PWM1_Set_Duty(current_duty);
 PWM2_Set_Duty(current_duty1);

 while (1) {
 if (RA0_bit) {
 Delay_ms(40);
 current_duty++;
 PWM1_Set_Duty(current_duty);
 }

 if (RA1_bit) {
 Delay_ms(40);
 current_duty--;
 PWM1_Set_Duty(current_duty);
 }

 if (RA2_bit) {
 Delay_ms(40);
 current_duty1++;
 PWM2_Set_Duty(current_duty1);
 }

 if (RA3_bit) {
 Delay_ms(40);
 current_duty1--;
 PWM2_Set_Duty(current_duty1);
 }

 Delay_ms(5);
 }
}
