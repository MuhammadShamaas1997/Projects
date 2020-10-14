unsigned int temp_res;

void main() {
  ANSELA  = 0x04;              // Configure AN2 pin as analog
  ANSELB = 0;                 // Configure other AN pins as digital I/O
  ANSELC = 0;
  ANSELD = 0;
  ANSELE = 0;
  C1ON_bit = 0;               // Disable comparators
  C2ON_bit = 0;

  TRISA  = 0xFF;              // PORTA is input
  TRISC  = 0;                 // PORTC is output
  TRISB  = 0;                 // PORTB is output

  do {
    temp_res = ADC_Read(2);   // Get 10-bit results of AD conversion
    PORTB = temp_res;         // Send lower 8 bits to PORTB
    PORTC = temp_res >> 8;    // Send 2 most significant bits to RC1, RC0
  } while(1);
}

