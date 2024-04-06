int ledPinA = 13;
int ledPinB = 12;
int ledPinC = 11;
int ledPinD = 10;
int ledPinE = 9;
int ledPinF = 8;
int ledPinG = 7; 
int number = 0; 
unsigned long previousMillis = 0;  // will store last time LED was updated
const long interval = 1000;  // interval at which to blink (milliseconds)
void setup() {
  pinMode(ledPinA, OUTPUT);
  pinMode(ledPinB, OUTPUT);
  pinMode(ledPinC, OUTPUT);
  pinMode(ledPinD, OUTPUT);
  pinMode(ledPinE, OUTPUT);
  pinMode(ledPinF, OUTPUT);
  pinMode(ledPinG, OUTPUT);
}

void loop() {
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    displayNumber();
    number = number + 1;
    if (number == 10){number = 0;}
  }
}

void displayNumber(){
  if (number == 0){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, LOW);
    digitalWrite(ledPinE, LOW);
    digitalWrite(ledPinF, LOW);
    digitalWrite(ledPinG, HIGH);
  }
  if (number == 1){
    digitalWrite(ledPinA, HIGH);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, HIGH);
    digitalWrite(ledPinE, HIGH);
    digitalWrite(ledPinF, HIGH);
    digitalWrite(ledPinG, HIGH);
  }
  if (number == 2){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, HIGH);
    digitalWrite(ledPinD, LOW);
    digitalWrite(ledPinE, LOW);
    digitalWrite(ledPinF, HIGH);
    digitalWrite(ledPinG, LOW);
  }
  if (number == 3){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, LOW);
    digitalWrite(ledPinE, HIGH);
    digitalWrite(ledPinF, HIGH);
    digitalWrite(ledPinG, LOW);
  }
  if (number == 4){
    digitalWrite(ledPinA, HIGH);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, HIGH);
    digitalWrite(ledPinE, HIGH);
    digitalWrite(ledPinF, LOW);
    digitalWrite(ledPinG, LOW);
  }
  if (number == 5){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, HIGH);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, LOW);
    digitalWrite(ledPinE, HIGH);
    digitalWrite(ledPinF, LOW);
    digitalWrite(ledPinG, LOW);
  }
  if (number == 6){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, HIGH);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, LOW);
    digitalWrite(ledPinE, LOW);
    digitalWrite(ledPinF, LOW);
    digitalWrite(ledPinG, LOW);
  }
  if (number == 7){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, HIGH);
    digitalWrite(ledPinE, HIGH);
    digitalWrite(ledPinF, HIGH);
    digitalWrite(ledPinG, HIGH);
  }
  if (number == 8){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, LOW);
    digitalWrite(ledPinE, LOW);
    digitalWrite(ledPinF, LOW);
    digitalWrite(ledPinG, LOW);
  }
  if (number == 9){
    digitalWrite(ledPinA, LOW);
    digitalWrite(ledPinB, LOW);
    digitalWrite(ledPinC, LOW);
    digitalWrite(ledPinD, HIGH);
    digitalWrite(ledPinE, HIGH);
    digitalWrite(ledPinF, LOW);
    digitalWrite(ledPinG, LOW);
  }
}