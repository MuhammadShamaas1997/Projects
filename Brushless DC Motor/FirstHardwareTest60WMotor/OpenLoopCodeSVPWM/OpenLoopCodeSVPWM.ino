/*
Arduino Mega 2560
Brushless DC Motor Controller using IR2103
Phase a/b/c Upper Pins can only be connected on pins 2 - 13 or 44 - 46 for analogWrite(pin,dutyCycle) where 0<=dutyCycle<=255
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
int PhaseaUpperPin=44;
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

double oldthetam,newthetam,oldthetae,newthetae,dthetae,thetae,sector;
unsigned int T1=250,T2=250,T0=500,Ts=1000;
double oldspeedm,newspeedm,accelerationm,oldspeede,newspeede,acceleratione,Direction;
int Poles=4;

double IA,IB,IC;
double VA,VB,VC;
double Id,Iq,I0;
double Vd,Vq,V0;
double Vref,Vdc=15.0;
double Ialpha,Ibeta;
double Valpha,Vbeta;
double oldtime,newtime,dt;
double theta0e=PI/3.0;
double theta0m=theta0e/(Poles/2);

unsigned int dutyCycle=220;
int val=0;

void writeState (int s)
{
  if ((s==4)||(s==5)||(s==6)||(s==7))
  {digitalWrite(PhaseaUpperPin, HIGH);digitalWrite(PhaseaLowerPin, LOW);}
  else
  {digitalWrite(PhaseaUpperPin, LOW);digitalWrite(PhaseaLowerPin, HIGH);}
  if ((s==2)||(s==3)||(s==6)||(s==7))
  {digitalWrite(PhasebUpperPin, HIGH);digitalWrite(PhasebLowerPin, LOW);}
  else
  {digitalWrite(PhasebUpperPin, LOW);digitalWrite(PhasebLowerPin, HIGH);}
  if ((s==1)||(s==3)||(s==5)||(s==7))
  {digitalWrite(PhasecUpperPin, HIGH);digitalWrite(PhasecLowerPin, LOW);}
  else
  {digitalWrite(PhasecUpperPin, LOW);digitalWrite(PhasecLowerPin, HIGH);}
}


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

  //else
  {
  //Serial.println("MOSFETs Okay");
  HALLA=digitalRead(HallaPin);
  HALLB=digitalRead(HallbPin);
  HALLC=digitalRead(HallcPin);
  oldstate=newstate;  
  newstate=(HALLC<<2)|(HALLB<<1)|(HALLA);
  //Serial.println(newstate);

  val = analogRead(A0);//0-1023
  dutyCycle=val/10;//0-511;
  if(dutyCycle>90){dutyCycle=90;}
  
    PhaseaLower=LOW;
    PhaseaUpper=LOW;
    PhasebLower=LOW;
    PhasebUpper=LOW;
    PhasecLower=LOW;
    PhasecUpper=LOW;
    
  
  if(((newstate==6)&&(oldstate==4))||((newstate==4)&&(oldstate==6)))
  {
  checkMOSFETsStatus();
  }

  if(newstate!=oldstate)
  {
    oldtime=newtime;
    newtime=micros();
    dt=newtime-oldtime;
    oldthetam=newthetam;
    newthetam=oldthetam+theta0m;
    if(newthetam>(2.0*PI)){while(newthetam>(2.0*PI))newthetam=newthetam-(2.0*PI);}
    if(newthetam<(0.0*PI)){while(newthetam<(0.0*PI))newthetam=newthetam+(2.0*PI);}

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
    if(dt>((2.0*PI)/newspeede)){newspeede=0.0;newspeedm=0.0;}
    newthetam=newthetam+newspeedm*dt;
    newthetae=newthetae+newspeede*dt;
    if(newthetam>(2.0*PI)){while(newthetam>(2.0*PI))newthetam=newthetam-(2.0*PI);}
    if(newthetam<(0.0*PI)){while(newthetam<(0.0*PI))newthetam=newthetam+(2.0*PI);}            
    if(newthetae>(2.0*PI)){while(newthetae>(2.0*PI))newthetae=newthetae-(2.0*PI);}
    if(newthetae<(0.0*PI)){while(newthetae<(0.0*PI))newthetae=newthetae+(2.0*PI);}            
  }
/*  Iqref=kps*SpeedErrorNew+kis*(0.5)*(SpeedErrorNew+SpeedErrorOld)*Ts;
  Idref=0;
  I0ref=0;

  IqErrorOld=IqErrorNew;
  IdErrorOld=IqErrorNew;
  IqErrorNew=Iq-Iqref;
  IdErrorNew=Id-Idref;
  Vd=kp*IdErrorNew+ki*(0.5)*(IdErrorNew+IdErrorOld)*Ts;
  Vq=kp*IqErrorNew+ki*(0.5)*(IqErrorNew+IqErrorOld)*Ts;;
  */
  Vd=0.0;
  Vq=(dutyCycle/100.0)*Vdc;
  //Serial.println(Vq);
  Vref=sqrt(Vd*Vd+Vq*Vq);
  
  sector=int((newthetae/(PI/3.0))+1);
  thetae=newthetae-(sector-1)*(PI/3.0);
  thetae=(11*PI)/6.0;
    if(thetae>(PI/3.0)){while(thetae>(PI/3.0))thetae=thetae-(PI/3.0);}
    if(thetae<(0.0)){while(thetae<(0.0))thetae=thetae+(PI/3.0);}            
  
  T1=int(sqrt(3.0)*double(Ts)*(Vref/Vdc)*sin((PI/3.0)-thetae));
  T2=int(sqrt(3.0)*double(Ts)*(Vref/Vdc)*sin(thetae));
  T0=int(Ts-T1-T2);
  if((T1+T2)>Ts){T0=0;}
  /*Serial.println(Vref);
  Serial.println(T0);
  Serial.println(T1);
  Serial.println(T2);
  Serial.println("");
  */

  if (sector==1)
  {
    writeState(0);delayMicroseconds(T0/2);
    writeState(4);delayMicroseconds(T1);
    writeState(6);delayMicroseconds(T2);
    writeState(7);delayMicroseconds(T0);
    writeState(6);delayMicroseconds(T2);
    writeState(4);delayMicroseconds(T1);
    writeState(0);delayMicroseconds(T0/2);
  }

  if (sector==2)
  {
    writeState(0);delayMicroseconds(T0/2);
    writeState(2);delayMicroseconds(T2);
    writeState(6);delayMicroseconds(T1);
    writeState(7);delayMicroseconds(T0);
    writeState(6);delayMicroseconds(T1);
    writeState(2);delayMicroseconds(T2);
    writeState(0);delayMicroseconds(T0/2);
  }
  
  if (sector==3)
  {
    writeState(0);delayMicroseconds(T0/2);
    writeState(2);delayMicroseconds(T1);
    writeState(3);delayMicroseconds(T2);
    writeState(7);delayMicroseconds(T0);
    writeState(3);delayMicroseconds(T2);
    writeState(2);delayMicroseconds(T1);
    writeState(0);delayMicroseconds(T0/2);
  }
  
  if (sector==4)
  {
    writeState(0);delayMicroseconds(T0/2);
    writeState(1);delayMicroseconds(T2);
    writeState(3);delayMicroseconds(T1);
    writeState(7);delayMicroseconds(T0);
    writeState(3);delayMicroseconds(T1);
    writeState(1);delayMicroseconds(T2);
    writeState(0);delayMicroseconds(T0/2);
  }
  
  if (sector==5)
  {
    writeState(0);delayMicroseconds(T0/2);
    writeState(1);delayMicroseconds(T1);
    writeState(5);delayMicroseconds(T2);
    writeState(7);delayMicroseconds(T0);
    writeState(5);delayMicroseconds(T2);
    writeState(1);delayMicroseconds(T1);
    writeState(0);delayMicroseconds(T0/2);
  }
  
  if (sector==6)
  {
    writeState(0);delayMicroseconds(T0/2);
    writeState(1);delayMicroseconds(T2);
    writeState(3);delayMicroseconds(T1);
    writeState(7);delayMicroseconds(T0);
    writeState(3);delayMicroseconds(T1);
    writeState(1);delayMicroseconds(T2);
    writeState(0);delayMicroseconds(T0/2);
  }

 
  
 }
  
  

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
