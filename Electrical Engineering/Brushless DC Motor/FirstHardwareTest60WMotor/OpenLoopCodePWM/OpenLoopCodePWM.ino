/*
Arduino Mega 2560
Brushless DC Motor Controller using IR2103
Phase a/b/c Upper Pins can only be connected on pins 2 - 13 or 44 - 46 for analogWrite(pin, dutyCycle) where 0<=dutyCycle<=255
Phase a/b/c Lower Pins can only be connected on digital pins. The logic for these pins must be inverted for IR2103 to work properly.
Hall a/b/c Pins can only be connected on digital pins. 
The HALL a/b/c logic bits are combined as newstate=(HALLC<<2)|(HALLB<<1)|(HALLA) e.g. HALLC=1, HALLB=0, HALLA=1 => newstate=(1<<2)|(0<<1)|1=101 
Speed Reference Pin is connected on analog pin A0 with ADC. The analog input ranges from 0-5 V. The ADC output ranges from 0-1023
The Motor runs in forward direction if (ADC_output/2)>255 and dutyCycle=ADC_output-255
The Motor runs in reverse direction if (ADC_output/2)<255 and dutyCycle=255-ADC_output 
MOSFETS a/b/c StatusInputPins can only be connected on digital pins. They are used to check switching of a/b/c inverter phases respectively
MOSFETS a/b/c StatusOutputPins can only be connected on digital pins. They are used to output status of a/b/c inverter phases respectively
*/

int PhaseaLowerPin=26;
int PhaseaUpperPin=12;
int PhasebLowerPin=4;
int PhasebUpperPin=5;
int PhasecLowerPin=10;
int PhasecUpperPin=11;
int HallaPin=48;
int HallbPin=50;
int HallcPin=52;
int MOSFETSaStatusInputPin=28;
int MOSFETSaStatusOutputPin=30;
int MOSFETSbStatusInputPin=3;
int MOSFETSbStatusOutputPin=2;
int MOSFETScStatusInputPin=9;
int MOSFETScStatusOutputPin=8;
/*int IaPin=A0;
int IbPin=A1;
int IcPin=A2;
int VaPin=A3;
int VbPin=A4;
int VcPin=A5;
*/

int HALLA=LOW;
int HALLB=LOW;
int HALLC=LOW;
int PhaseaLower=LOW;
int PhaseaUpper=LOW;
int PhasebLower=LOW;
int PhasebUpper=LOW;
int PhasecLower=LOW;
int PhasecUpper=LOW;
int oldstate, newstate;
int Shutdowna=0;
int Shutdownb=0;
int Shutdownc=0;

double oldthetam,newthetam,oldthetae,newthetae,dthetae;
double oldspeedm,newspeedm,accelerationm,oldspeede,newspeede,acceleratione,Direction;
int Poles=4;

double IA,IB,IC;
double VA,VB,VC;
double Id,Iq,I0;
double Vd,Vq,V0;
double Ialpha,Ibeta;
double Valpha,Vbeta;
double oldtime,newtime,dt;
double theta0e=PI/3.0;
double theta0m=theta0e/(Poles/2);

unsigned int dutyCycle=220;
int val=0;

void setup()
{
  //Serial.begin(1200);
  pinMode(PhaseaLowerPin, OUTPUT);
  pinMode(PhaseaUpperPin, OUTPUT);
  pinMode(PhasebLowerPin, OUTPUT);
  pinMode(PhasebUpperPin, OUTPUT);
  pinMode(PhasecLowerPin, OUTPUT);
  pinMode(PhasecUpperPin, OUTPUT);  

  pinMode(HallaPin, INPUT);
  pinMode(HallbPin, INPUT);
  pinMode(HallcPin, INPUT);
  
  HALLA=digitalRead(HallaPin);
  HALLB=digitalRead(HallbPin);
  HALLC=digitalRead(HallcPin);
  
  //attachInterrupt(digitalPinToInterrupt(HallaPin), blinka, CHANGE);
  //attachInterrupt(digitalPinToInterrupt(HallbPin), blinkb, CHANGE);
  //attachInterrupt(digitalPinToInterrupt(HallcPin), blinkc, CHANGE);

  pinMode(MOSFETSaStatusInputPin,INPUT);
  pinMode(MOSFETSbStatusInputPin,INPUT);
  pinMode(MOSFETScStatusInputPin,INPUT);
  pinMode(MOSFETSaStatusOutputPin,OUTPUT);
  pinMode(MOSFETSbStatusOutputPin,OUTPUT);
  pinMode(MOSFETScStatusOutputPin,OUTPUT);


  digitalWrite(MOSFETSaStatusOutputPin,HIGH);
  digitalWrite(MOSFETSbStatusOutputPin,HIGH);
  digitalWrite(MOSFETScStatusOutputPin,HIGH);

  
  checkMOSFETsStatus();
  if((Shutdowna==1)||(Shutdownb==1)||(Shutdownc==1))
  {
    //Serial.println("Shutdown");
  }
  else
  {
    //Serial.println("Okay");
  }


}

void loop()
{
  if((Shutdowna==1)||(Shutdownb==1)||(Shutdownc==1))
  {
    //Serial.println("Shutdown");
  digitalWrite(PhaseaLowerPin, !LOW);
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhasebLowerPin, !LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasecLowerPin, !LOW);
  digitalWrite(PhasecUpperPin, LOW);
  delayMicroseconds(100);
  checkMOSFETsStatus();

  }

  else
  {
  //Serial.println("MOSFETs Okay");
  HALLA=digitalRead(HallaPin);
  HALLB=digitalRead(HallbPin);
  HALLC=digitalRead(HallcPin);
  oldstate=newstate;  
  newstate=(HALLC<<2)|(HALLB<<1)|(HALLA);
  //Serial.println(newstate);

  /*val = analogRead(A0);//0-1023
  val=val/2;//0-511;
  if(val>255){dutyCycle=val-255;Direction=1;}
  if(val==255){dutyCycle=0;}
  if(val<255){dutyCycle=255-val;Direction=-1;}
  */
  //if(dutyCycle>220){dutyCycle=220;}
  //Serial.println(val/2);
  dutyCycle=200;
  Direction=1;
  
    PhaseaLower=LOW;
    PhaseaUpper=LOW;
    PhasebLower=LOW;
    PhasebUpper=LOW;
    PhasecLower=LOW;
    PhasecUpper=LOW;
    
  if(Direction==1){
  if(newstate==1){PhaseaUpper=HIGH; PhasecLower=HIGH;}
  if(newstate==2){PhaseaLower=HIGH; PhasebUpper=HIGH;}
  if(newstate==3){PhasebUpper=HIGH; PhasecLower=HIGH;}
  if(newstate==4){PhasebLower=HIGH; PhasecUpper=HIGH;}
  if(newstate==5){PhaseaUpper=HIGH; PhasebLower=HIGH;}
  if(newstate==6){PhaseaLower=HIGH; PhasecUpper=HIGH;}
  }

  if(Direction==(-1)){
  if(newstate==1){PhaseaLower=HIGH; PhasecUpper=HIGH;}
  if(newstate==2){PhaseaUpper=HIGH; PhasebLower=HIGH;}
  if(newstate==3){PhasebLower=HIGH; PhasecUpper=HIGH;}
  if(newstate==4){PhasebUpper=HIGH; PhasecLower=HIGH;}
  if(newstate==5){PhaseaLower=HIGH; PhasebUpper=HIGH;}
  if(newstate==6){PhaseaUpper=HIGH; PhasecLower=HIGH;}
  }

  
  if(((newstate==6)&&(oldstate==4))||((newstate==4)&&(oldstate==6)))
  //if(newstate!=oldstate)
  {
  checkMOSFETsStatus();
  }



 
 digitalWrite(PhaseaLowerPin, !PhaseaLower);
 if(PhaseaUpper){analogWrite(PhaseaUpperPin, dutyCycle);}else{digitalWrite(PhaseaUpperPin, LOW);}
 digitalWrite(PhasebLowerPin, !PhasebLower);
 if(PhasebUpper){analogWrite(PhasebUpperPin, dutyCycle);}else{digitalWrite(PhasebUpperPin, LOW);}
 digitalWrite(PhasecLowerPin, !PhasecLower);
 if(PhasecUpper){analogWrite(PhasecUpperPin, dutyCycle);}else{digitalWrite(PhasecUpperPin, LOW);}
  
 }
  
  /*
  if(newstate!=oldstate)
  {
    oldtime=newtime;
    newtime=micros();
    dt=newtime-oldtime;
    oldthetam=newthetam;
    newthetam=oldthetam+theta0m;
    if(newthetam>(2.0*PI)){newthetam=newthetam-(2.0*PI);}
    if(newthetam<(2.0*PI)){newthetam=newthetam+(2.0*PI);}

    oldthetae=newthetae;
    if (newstate==6){newthetae=0.0*(PI/3.0);}
    if (newstate==2){newthetae=1.0*(PI/3.0);}
    if (newstate==3){newthetae=2.0*(PI/3.0);}
    if (newstate==1){newthetae=3.0*(PI/3.0);}
    if (newstate==5){newthetae=4.0*(PI/3.0);}
    if (newstate==4){newthetae=5.0*(PI/3.0);}
    
    oldspeedm=newspeedm;
    newspeedm=theta0m/dt;
    oldspeede=newspeede;
    newspeede=theta0e/dt;
    double dthetae=newthetae-oldthetae;
    if((dthetae>0.0)|| ( dthetae <= (-4.0*(PI/3.0)) ) ){Direction= 1.0;newspeede=Direction*newspeede;newspeedm=Direction*newspeedm;}
    if((dthetae<0.0)|| ( dthetae >= ( 4.0*(PI/3.0)) ) ){Direction=-1.0;newspeede=Direction*newspeede;newspeedm=Direction*newspeedm;}
    
    accelerationm=(newspeedm-oldspeedm)/dt;
    acceleratione=(newspeede-oldspeede)/dt;
  }
  else
  {
    dt=micros()-newtime;
    newthetam=newthetam+newspeedm*dt;
    newthetae=newthetae+newspeede*dt;
    if(newthetam>(2.0*PI)){newthetam=newthetam-(2.0*PI);}
    if(newthetam<(2.0*PI)){newthetam=newthetam+(2.0*PI);}            
    if(newthetae>(2.0*PI)){newthetae=newthetae-(2.0*PI);}
    if(newthetae<(2.0*PI)){newthetae=newthetae+(2.0*PI);}            
  }
*/
  //Serial.println(newspeedm);
/*
  IA=analogRead(IaPin);
  IB=analogRead(IbPin);
  IC=analogRead(IcPin);
  Ialpha=(2/3)*((1)  *IA+(-1/2)     *IB+(-1/2)      *IC);
  Ibeta =(2/3)*((0)  *IA+(sqrt(3)/2)*IB+(-sqrt(3)/2)*IC);
  I0=    (2/3)*((1/2)*IA+(1/2)      *IB+(1/2)       *IC);
  Id=Ialpha*( cos(newthetae))+Ibeta*(sin(newthetae));
  Iq=Ialpha*(-sin(newthetae))+Ibeta*(cos(newthetae));

  VA=analogRead(VaPin);
  VB=analogRead(VbPin);
  VC=analogRead(VcPin);
  Valpha=(2/3)*((1)  *VA+(-1/2)     *VB+(-1/2)      *VC);
  Vbeta =(2/3)*((0)  *VA+(sqrt(3)/2)*VB+(-sqrt(3)/2)*VC);
  V0=    (2/3)*((1/2)*VA+(1/2)      *VB+(1/2)       *VC);
  Vd=Valpha*( cos(newthetae))+Vbeta*(sin(newthetae));
  Vq=Valpha*(-sin(newthetae))+Vbeta*(cos(newthetae));
*/
}

int checkMOSFETsStatus()
{

  Shutdowna=0;
  Shutdownb=0;
  Shutdownc=0;
  digitalWrite(PhaseaLowerPin, !LOW);
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhasebLowerPin, !LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasecLowerPin, !LOW);
  digitalWrite(PhasecUpperPin, LOW);
  delayMicroseconds(1);
  
  digitalWrite(PhaseaLowerPin,!HIGH);
  digitalWrite(PhasebLowerPin,!HIGH);
  digitalWrite(PhasecLowerPin,!HIGH);
  delayMicroseconds(100);
  if(digitalRead(MOSFETSaStatusInputPin)){Shutdowna=1;}//Serial.println("A LOW Failure");
  if(digitalRead(MOSFETSbStatusInputPin)){Shutdownb=1;}//Serial.println("B LOW Failure");
  if(digitalRead(MOSFETScStatusInputPin)){Shutdownc=1;}//Serial.println("C LOW Failure");

  digitalWrite(PhaseaLowerPin, !LOW);
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhasebLowerPin, !LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasecLowerPin, !LOW);
  digitalWrite(PhasecUpperPin, LOW);
  delayMicroseconds(1);

  digitalWrite(PhaseaUpperPin,HIGH);
  digitalWrite(PhasebUpperPin,HIGH);
  digitalWrite(PhasecUpperPin,HIGH);
  delayMicroseconds(100);
  
  if(!digitalRead(MOSFETSaStatusInputPin)){Shutdowna=1;}//Serial.println("A HIGH Failure");
  if(!digitalRead(MOSFETSbStatusInputPin)){Shutdownb=1;}//Serial.println("B HIGH Failure");
  if(!digitalRead(MOSFETScStatusInputPin)){Shutdownc=1;}//Serial.println("C HIGH Failure");

  if(Shutdowna==1){digitalWrite(MOSFETSaStatusOutputPin,LOW);}else{digitalWrite(MOSFETSaStatusOutputPin,HIGH);}
  if(Shutdownb==1){digitalWrite(MOSFETSbStatusOutputPin,LOW);}else{digitalWrite(MOSFETSbStatusOutputPin,HIGH);}
  if(Shutdownc==1){digitalWrite(MOSFETScStatusOutputPin,LOW);}else{digitalWrite(MOSFETScStatusOutputPin,HIGH);}

  digitalWrite(PhaseaLowerPin, !LOW);
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhasebLowerPin, !LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasecLowerPin, !LOW);
  digitalWrite(PhasecUpperPin, LOW);
  delayMicroseconds(1);

}

void blinka() {HALLA = digitalRead(HallaPin);}
void blinkb() {HALLB = digitalRead(HallbPin);}
void blinkc() {HALLC = digitalRead(HallcPin);}
