#include <Servo.h>
Servo servo;
int angle = 10;

// VCC(Red wire) - 5V
// SIG(yellow/orange) - D8
// GND(Black/Brown) - GN

void setup() {
  servo.attach(8);
  servo.write(angle);
}
void loop() 
{ 
 // scan from 0 to 180 degrees
  for(angle = 10; angle < 180; angle++)  
  {                                  
    servo.write(angle);               
    delay(15);                   
  } 
  // now scan back from 180 to 0 degrees
  for(angle = 180; angle > 10; angle--)    
  {                                
    servo.write(angle);           
    delay(15);       
  } 
}