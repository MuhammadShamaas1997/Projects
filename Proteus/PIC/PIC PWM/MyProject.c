/*void main() {

  TRISA = 0;           // set direction to be output
  TRISB = 0;           // set direction to be output
  TRISC = 0;           // set direction to be output
  TRISD = 0;           // set direction to be output
  TRISE = 0;           // set direction to be output

  do {
    LATA = 0x00;       // Turn OFF LEDs on PORTA
    LATB = 0x00;       // Turn OFF LEDs on PORTB
    LATC = 0x00;       // Turn OFF LEDs on PORTC
    LATD = 0x00;       // Turn OFF LEDs on PORTD
    LATE = 0x00;       // Turn OFF LEDs on PORTE
    Delay_ms(1000);    // 1 second delay

    LATA = 0xFF;       // Turn ON LEDs on PORTA
    LATB = 0xFF;       // Turn ON LEDs on PORTB
    LATC = 0xFF;       // Turn ON LEDs on PORTC
    LATD = 0xFF;       // Turn ON LEDs on PORTD
    LATE = 0xFF;       // Turn ON LEDs on PORTE
    Delay_ms(1000);    // 1 second delay
  } while(1);          // Endless loop
}*/



unsigned short current_duty, old_duty, current_duty1, old_duty1;

void InitMain() {
  ANSELA  = 0;                         // Configure AN pins as digital
  ANSELB  = 0;
  ANSELC  = 0;
  ANSELD  = 0;
  ANSELE = 0;
  C1ON_bit = 0;                       // Disable comparators
  C2ON_bit = 0;

  PORTA = 255;
  TRISA = 255;                        // configure PORTA pins as input
  PORTB = 0;                          // set PORTB to 0
  TRISB = 0;                          // designate PORTB pins as output
  PORTC = 0;                          // set PORTC to 0
  TRISC = 0;                          // designate PORTC pins as output
  PWM1_Init(20000);                    // Initialize PWM1 module at 5KHz
  PWM2_Init(20000);                    // Initialize PWM2 module at 5KHz
}

void main() {
  InitMain();
  current_duty  = 16;                 // initial value for current_duty
  current_duty1 = 16;                 // initial value for current_duty1

  PWM1_Start();                       // start PWM1
  PWM2_Start();                       // start PWM2
  PWM1_Set_Duty(current_duty);        // Set current duty for PWM1
  PWM2_Set_Duty(current_duty1);       // Set current duty for PWM2

  while (1) {                         // endless loop
    if (RA0_bit) {                    // button on RA0 pressed
      Delay_ms(40);
      current_duty++;                 // increment current_duty
      PWM1_Set_Duty(current_duty);
     }

    if (RA1_bit) {                    // button on RA1 pressed
      Delay_ms(40);
      current_duty--;                 // decrement current_duty
      PWM1_Set_Duty(current_duty);
     }

    if (RA2_bit) {                    // button on RA2 pressed
      Delay_ms(40);
      current_duty1++;                // increment current_duty1
      PWM2_Set_Duty(current_duty1);
     }

    if (RA3_bit) {                    // button on RA3 pressed
      Delay_ms(40);
      current_duty1--;                // decrement current_duty1
      PWM2_Set_Duty(current_duty1);
     }

    Delay_ms(5);                      // slow down change pace a little
  }
}

