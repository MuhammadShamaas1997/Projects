// DAC module connections
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
// End DAC module connections

unsigned int value;

void InitMain() {
  TRISA0_bit = 1;                        // Set RA0 pin as input
  TRISA1_bit = 1;                        // Set RA1 pin as input
  Chip_Select = 1;                       // Deselect DAC
  Chip_Select_Direction = 0;             // Set CS# pin as Output
  SPI1_Init();                           // Initialize SPI module
}

// DAC increments (0..4095) --> output voltage (0..Vref)
void DAC_Output(unsigned int valueDAC) {
  char temp;

  Chip_Select = 0;                       // Select DAC chip

  // Send High Byte
  temp = (valueDAC >> 8) & 0x0F;         // Store valueDAC[11..8] to temp[3..0]
  temp |= 0x30;                          // Define DAC setting, see MCP4921 datasheet
  SPI1_Write(temp);                      // Send high byte via SPI

  // Send Low Byte
  temp = valueDAC;                       // Store valueDAC[7..0] to temp[7..0]
  SPI1_Write(temp);                      // Send low byte via SPI

  Chip_Select = 1;                       // Deselect DAC chip
}

void main() {
  ANSELA = 0;
  ANSELB = 0;
  ANSELC = 0;
  ANSELD = 0;
  ANSELE = 0;
  InitMain();                            // Perform main initialization

  value = 2048;                          // When program starts, DAC gives
                                         //   the output in the mid-range

 while (1) {                             // Endless loop

    if ((RA0_bit) && (value < 4095)) {   // If RA0 button is pressed
      value++;                           //   increment value
      }
    else {
      if ((RA1_bit) && (value > 0)) {    // If RA1 button is pressed
        value--;                         //   decrement value
        }
      }
    DAC_Output(value);                   // Send value to DAC chip
    Delay_ms(1);                         // Slow down key repeat pace
  }
}
