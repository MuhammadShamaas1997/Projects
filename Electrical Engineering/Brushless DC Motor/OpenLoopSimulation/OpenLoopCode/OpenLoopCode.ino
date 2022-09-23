int PhaseaUpperPin=2;
int PhaseaLowerPin=3;
int PhasebUpperPin=4;
int PhasebLowerPin=5;
int PhasecUpperPin=6;
int PhasecLowerPin=7;
int HallaPin=18;
int HallbPin=19;
int HallcPin=20;
int IaPin=A0;
int IbPin=A1;
int IcPin=A2;
int VaPin=A3;
int VbPin=A4;
int VcPin=A5;

int HALLA=LOW;
int HALLB=LOW;
int HALLC=LOW;

int oldstate, newstate;
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

void setup()
{
  Serial.begin(9600);
  pinMode(PhaseaUpperPin, OUTPUT);
  pinMode(PhaseaLowerPin, OUTPUT);
  pinMode(PhasebUpperPin, OUTPUT);
  pinMode(PhasebLowerPin, OUTPUT);
  pinMode(PhasecUpperPin, OUTPUT);
  pinMode(PhasecLowerPin, OUTPUT);  
  
  pinMode(HallaPin, INPUT);
  pinMode(HallbPin, INPUT);
  pinMode(HallcPin, INPUT);
  
  HALLA=digitalRead(HallaPin);
  HALLB=digitalRead(HallbPin);
  HALLC=digitalRead(HallcPin);

  attachInterrupt(digitalPinToInterrupt(HallaPin), blinka, CHANGE);
  attachInterrupt(digitalPinToInterrupt(HallbPin), blinkb, CHANGE);
  attachInterrupt(digitalPinToInterrupt(HallcPin), blinkc, CHANGE);

  
  digitalWrite(PhaseaUpperPin, LOW);
  digitalWrite(PhaseaLowerPin, LOW);
  digitalWrite(PhasebUpperPin, LOW);
  digitalWrite(PhasebLowerPin, LOW);
  digitalWrite(PhasecUpperPin, LOW);
  digitalWrite(PhasecLowerPin, LOW);
}

void loop()
{

  HALLA=digitalRead(HallaPin);
  HALLB=digitalRead(HallbPin);
  HALLC=digitalRead(HallcPin);
  oldstate=newstate;  
  newstate=(HALLC<<2)|(HALLB<<1)|(HALLA);

  digitalWrite(PhaseaUpperPin, (newstate==1)||(newstate==5) );
  digitalWrite(PhaseaLowerPin, (newstate==2)||(newstate==6) );
  digitalWrite(PhasebUpperPin, (newstate==2)||(newstate==3) );
  digitalWrite(PhasebLowerPin, (newstate==4)||(newstate==5) );
  digitalWrite(PhasecUpperPin, (newstate==4)||(newstate==6) );
  digitalWrite(PhasecLowerPin, (newstate==1)||(newstate==3) );

  
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
    dt=millis()-newtime;
    newthetam=newthetam+newspeedm*dt;
    newthetae=newthetae+newspeede*dt;
    if(newthetam>(2.0*PI)){newthetam=newthetam-(2.0*PI);}
    if(newthetam<(2.0*PI)){newthetam=newthetam+(2.0*PI);}            
    if(newthetae>(2.0*PI)){newthetae=newthetae-(2.0*PI);}
    if(newthetae<(2.0*PI)){newthetae=newthetae+(2.0*PI);}            
  }
  Serial.print("Angle: ");
  Serial.print(newthetae*(180.0/PI));
  Serial.print("  Speed(rpm): ");
  Serial.println(newspeedm*((60.0*1000000.0)/(2*PI)));
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

void blinka() {HALLA = digitalRead(HallaPin);}
void blinkb() {HALLB = digitalRead(HallbPin);}
void blinkc() {HALLC = digitalRead(HallcPin);}
