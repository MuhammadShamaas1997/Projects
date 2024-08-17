int IrReceiverPin = 12; // Connect Black diode reverse bias in series with light LED
int IrTransmitterPin = 8; // Connnect White LED to 5V (Forward bias)

void setup()
{
  pinMode(IrTransmitterPin, OUTPUT);
  digitalWrite(IrTransmitterPin, HIGH);
}


void loop() {
  delay(1000);
}