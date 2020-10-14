bit oldstate;                                    // Old state flag

void main() {

  ANSELA  = 0;                                    // Configure AN pins as digital I/O
  ANSELB = 0;
  ANSELC = 0;
  ANSELD = 0;
  ANSELE = 0;
  C1ON_bit = 0;                                  // Disable comparators
  C2ON_bit = 0;

  TRISB0_bit = 1;                                // set RB0 pin as input

  TRISC = 0x00;                                  // Configure PORTC as output
  PORTC = 0xFF;                                  // Initial PORTC value
  oldstate = 0;

  do {
    if (Button(&PORTB, 0, 1, 1)) {               // Detect logical one
      oldstate = 1;                              // Update flag
    }
    if (oldstate && Button(&PORTB, 0, 1, 0)) {   // Detect one-to-zero transition
      PORTC = ~PORTC;                            // Invert PORTC
      oldstate = 0;                              // Update flag
    }
  } while(1);                                    // Endless loop
}
