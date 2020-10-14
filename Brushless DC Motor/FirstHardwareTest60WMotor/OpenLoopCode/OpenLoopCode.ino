int PhaseaLowerPin=26;
int PhaseaUpperPin=24;
int PhasebLowerPin=4;
int PhasebUpperPin=5;
int PhasecLowerPin=10;
int PhasecUpperPin=11;
int HallaPin=48;
int HallbPin=50;
int HallcPin=52;
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

int MOSFETSaStatusInputPin=28;
int MOSFETSaStatusOutputPin=30;
int MOSFETSbStatusInputPin=3;
int MOSFETSbStatusOutputPin=2;
int MOSFETScStatusInputPin=9;
int MOSFETScStatusOutputPin=8;
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

unsigned int dutyCycle=500;

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

  
  if(newstate==1){
    PhaseaLower=LOW;
    PhaseaUpper=HIGH;
    PhasebLower=LOW;
    PhasebUpper=LOW;
    PhasecLower=HIGH;
    PhasecUpper=LOW;
    }
    
    if(newstate==2){
    PhaseaLower=HIGH;
    PhaseaUpper=LOW;
    PhasebLower=LOW;
    PhasebUpper=HIGH;
    PhasecLower=LOW;
    PhasecUpper=LOW;
    }

    if(newstate==3){
    PhaseaLower=LOW;
    PhaseaUpper=LOW;
    PhasebLower=LOW;
    PhasebUpper=HIGH;
    PhasecLower=HIGH;
    PhasecUpper=LOW;
    }

    if(newstate==4){
    PhaseaLower=LOW;
    PhaseaUpper=LOW;
    PhasebLower=HIGH;
    PhasebUpper=LOW;
    PhasecLower=LOW;
    PhasecUpper=HIGH;
    }

    if(newstate==5){
    PhaseaLower=LOW;
    PhaseaUpper=HIGH;
    PhasebLower=HIGH;
    PhasebUpper=LOW;
    PhasecLower=LOW;
    PhasecUpper=LOW;
    }

    if(newstate==6){
    PhaseaLower=HIGH;
    PhaseaUpper=LOW;
    PhasebLower=LOW;
    PhasebUpper=LOW;
    PhasecLower=LOW;
    PhasecUpper=HIGH;
    }
  
  
  if(newstate!=oldstate)
  {
  digitalWrite(PhaseaLowerPin, !LOW);
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhasebLowerPin, !LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasecLowerPin, !LOW);
  digitalWrite(PhasecUpperPin, LOW);
  delayMicroseconds(1);
  checkMOSFETsStatus();
  }



 digitalWrite(PhaseaLowerPin, !PhaseaLower);
 digitalWrite(PhaseaUpperPin, LOW);
 digitalWrite(PhasebLowerPin, !PhasebLower);
 digitalWrite(PhasebUpperPin, LOW);
 digitalWrite(PhasecLowerPin, !PhasecLower);
 digitalWrite(PhasecUpperPin, LOW);

 delayMicroseconds(0.5*(1000-dutyCycle));
 
 digitalWrite(PhaseaLowerPin, !PhaseaLower);
 digitalWrite(PhaseaUpperPin, PhaseaUpper);
 digitalWrite(PhasebLowerPin, !PhasebLower);
 digitalWrite(PhasebUpperPin, PhasebUpper);
 digitalWrite(PhasecLowerPin, !PhasecLower);
 digitalWrite(PhasecUpperPin, PhasecUpper);

 delayMicroseconds(dutyCycle);

 digitalWrite(PhaseaLowerPin, !PhaseaLower);
 digitalWrite(PhaseaUpperPin, LOW);
 digitalWrite(PhasebLowerPin, !PhasebLower);
 digitalWrite(PhasebUpperPin, LOW);
 digitalWrite(PhasecLowerPin, !PhasecLower);
 digitalWrite(PhasecUpperPin, LOW);

 delayMicroseconds(0.5*(1000-dutyCycle));
  
 }
  
  
  if(newstate!=oldstate)
  {
    oldtime=newtime;
    newtime=millis();
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
    dt=millis()-newtime;
    newthetam=newthetam+newspeedm*dt;
    newthetae=newthetae+newspeede*dt;
    if(newthetam>(2.0*PI)){newthetam=newthetam-(2.0*PI);}
    if(newthetam<(2.0*PI)){newthetam=newthetam+(2.0*PI);}            
    if(newthetae>(2.0*PI)){newthetae=newthetae-(2.0*PI);}
    if(newthetae<(2.0*PI)){newthetae=newthetae+(2.0*PI);}            
  }

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
  delayMicroseconds(100);
  
  //if(digitalRead(MOSFETSaStatusInputPin)){Shutdowna=1;}
  //if(digitalRead(MOSFETSbStatusInputPin)){Shutdownb=1;}
  //if(digitalRead(MOSFETScStatusInputPin)){Shutdownc=1;}

  digitalWrite(PhaseaLowerPin,!HIGH);delayMicroseconds(100);
  if(digitalRead(MOSFETSaStatusInputPin))
  {
    Shutdowna=1;
  //Serial.println("A LOW Failure");
  }
  digitalWrite(PhasebLowerPin,!HIGH);delayMicroseconds(100);
  if(digitalRead(MOSFETSbStatusInputPin))
  {
    Shutdownb=1;
  //Serial.println("B LOW Failure");
  }
  digitalWrite(PhasecLowerPin,!HIGH);delayMicroseconds(100);
  if(digitalRead(MOSFETScStatusInputPin))
  {
    Shutdownc=1;
    //Serial.println("C LOW Failure");
  }

  //if(Shutdowna==1){digitalWrite(MOSFETSaStatusOutputPin,LOW);}else{digitalWrite(MOSFETSaStatusOutputPin,HIGH);}
  //if(Shutdownb==1){digitalWrite(MOSFETSbStatusOutputPin,LOW);}else{digitalWrite(MOSFETSbStatusOutputPin,HIGH);}
  //if(Shutdownc==1){digitalWrite(MOSFETScStatusOutputPin,LOW);}else{digitalWrite(MOSFETScStatusOutputPin,HIGH);}

  digitalWrite(PhaseaLowerPin, !LOW);
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhasebLowerPin, !LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasecLowerPin, !LOW);
  digitalWrite(PhasecUpperPin, LOW);
  delayMicroseconds(100);

  digitalWrite(PhaseaUpperPin,HIGH);delayMicroseconds(100);
  if(!digitalRead(MOSFETSaStatusInputPin))
  {
    Shutdowna=1;
    //Serial.println("A HIGH Failure");
  }
  digitalWrite(PhasebUpperPin,HIGH);delayMicroseconds(100);
  if(!digitalRead(MOSFETSbStatusInputPin))
  {
    Shutdownb=1;
    //Serial.println("B HIGH Failure");
  }
  digitalWrite(PhasecUpperPin,HIGH);delayMicroseconds(100);
  if(!digitalRead(MOSFETScStatusInputPin))
  {
    Shutdownc=1;
    //Serial.println("C HIGH Failure");
  }

  if(Shutdowna==1){digitalWrite(MOSFETSaStatusOutputPin,LOW);}else{digitalWrite(MOSFETSaStatusOutputPin,HIGH);}
  if(Shutdownb==1){digitalWrite(MOSFETSbStatusOutputPin,LOW);}else{digitalWrite(MOSFETSbStatusOutputPin,HIGH);}
  if(Shutdownc==1){digitalWrite(MOSFETScStatusOutputPin,LOW);}else{digitalWrite(MOSFETScStatusOutputPin,HIGH);}

  digitalWrite(PhaseaLowerPin, !LOW);
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhasebLowerPin, !LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasecLowerPin, !LOW);
  digitalWrite(PhasecUpperPin, LOW);
  delayMicroseconds(100);

}

void blinka() {HALLA = digitalRead(HallaPin);}
void blinkb() {HALLB = digitalRead(HallbPin);}
void blinkc() {HALLC = digitalRead(HallcPin);}
