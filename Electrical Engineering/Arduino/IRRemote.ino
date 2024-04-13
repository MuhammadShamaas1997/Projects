#include <IRremote.h>
int runMotor = 0;
int IrReceiverPin = 12;                 // Turn the variable "IrReceiverPin" to pin 13
IRrecv irrecv(IrReceiverPin);           // create a new instance of "irrecv" and save this instance in variabele "IRrecv"
decode_results results;                 // define the variable "results" to store the received button code

void setup()
{
  pinMode(LED_BUILTIN, OUTPUT);       // Initialise digitale pin LED_BUILTIN as output
  pinMode(7, OUTPUT);
  irrecv.enableIRIn();                // start the IR-receiver
  digitalWrite(LED_BUILTIN, LOW);     // Turn off the builtin LED
}


void loop() {
    if (irrecv.decode(&results)) {
        irrecv.resume();
        if (results.value) {
          if (runMotor == 1){
            digitalWrite(LED_BUILTIN, LOW);   // Turn LED on    
            runMotor = 0; 
          } else {
            digitalWrite(LED_BUILTIN, HIGH);   // Turn LED on    
            runMotor = 1;
          }
        }
    }
    if (runMotor) {
      digitalWrite(7, HIGH);
    } else {
       digitalWrite(7, LOW);
    }
  delay(100);      // pause 100ms
}