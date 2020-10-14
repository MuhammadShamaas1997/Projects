int PhaseaUpperPin=2;
int PhaseaLowerPin=3;
int PhasebUpperPin=4;
int PhasebLowerPin=5;
int PhasecUpperPin=6;
int PhasecLowerPin=7;
int ErrorPin=8;
int HallaPin=9;
int HallbPin=10;
int HallcPin=11;

int Vdd=0;
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

  pinMode(ErrorPin,OUTPUT);

  
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
  if((Shutdowna>0)||(Shutdownb>0)||(Shutdownc>0))
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

  val = analogRead(A4);//0-1023
  val=val/2;//0-511;
  if(val>255){dutyCycle=val-255;Direction=1;}
  if(val==255){dutyCycle=0;}
  if(val<255){dutyCycle=255-val;Direction=-1;}
  
  if(dutyCycle>220){dutyCycle=220;}
  //Serial.println(val/2);
  
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

  
  //if(((newstate==6)&&(oldstate==4))||((newstate==4)&&(oldstate==6)))
  //if(newstate!=oldstate)
  {
  //checkMOSFETsStatus();
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
  delayMicroseconds(1000);

  Vdd=analogRead(A0);if(Vdd<150){Shutdowna=Shutdowna+1;Shutdownb=Shutdownb+1;Shutdownc=Shutdownc+1;}
  if(analogRead(A1)>(Vdd/2)){Shutdowna=Shutdowna+1;}//Serial.println("A LOW Failure");
  if(analogRead(A2)>(Vdd/2)){Shutdownb=Shutdownb+1;}//Serial.println("B LOW Failure");
  if(analogRead(A3)>(Vdd/2)){Shutdownc=Shutdownc+1;}//Serial.println("C LOW Failure");
  
  /*Serial.println(Vdd);
  Serial.println(analogRead(A1));
  Serial.println(analogRead(A2));
  Serial.println(analogRead(A3));
  Serial.println(analogRead(A1)>(Vdd/2));
  Serial.println(analogRead(A2)>(Vdd/2));
  Serial.println(analogRead(A3)>(Vdd/2));
  Serial.println();*/
  
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
  delayMicroseconds(1000);
  
  if(analogRead(A1)<(Vdd/2)){Shutdowna=Shutdowna+1;}//Serial.println("A LOW Failure");
  if(analogRead(A2)<(Vdd/2)){Shutdownb=Shutdownb+1;}//Serial.println("B LOW Failure");
  if(analogRead(A3)<(Vdd/2)){Shutdownc=Shutdownc+1;}//Serial.println("C LOW Failure");

  /*Serial.println(Vdd);
  Serial.println(analogRead(A1));
  Serial.println(analogRead(A2));
  Serial.println(analogRead(A3));
  Serial.println(analogRead(A1)<(Vdd/2));
  Serial.println(analogRead(A2)<(Vdd/2));
  Serial.println(analogRead(A3)<(Vdd/2));
  Serial.println();*/

  if((Shutdowna>0)||(Shutdownb>0)||(Shutdownc>0)){digitalWrite(ErrorPin,LOW);}else{digitalWrite(ErrorPin,HIGH);}

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
