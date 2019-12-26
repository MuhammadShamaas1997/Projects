#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"
#include "ns3/onoff-application.h"
#include "ns3/netanim-module.h"
#include "ns3/csma-module.h"
#include "ns3/animation-interface.h"
#include "ns3/ipv4-address-helper.h"
#include "ns3/internet-stack-helper.h"
#include "ns3/ipv4-global-routing-helper.h"
#include "ns3/ipv4-global-routing.h"
#include "ns3/callback.h"
#include "ns3/point-to-point-helper.h"
#include "ns3/simulator.h"
#include "ns3/gnuplot.h"
#include <string>
#include <cstring>
#include <sstream>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>
using namespace ns3;
using namespace std;

ifstream INSTREAM;
ifstream IN1;
ifstream IN2;
ofstream COPY;
ofstream o;
ofstream e;
ofstream OUTSTREAM;
//ofstream myfile;

string BUFFER;
string agent="AGENT";
string noSERVER="NO_SERVER";
string day="991201";
string Month="december.txt";
int RoutingType=1;//1-SBR, 2-FSF, 3-LIF, 4-LCR
int Mean_InterArrival_Time      =5;
int Mean_Packet_Size            =50;
int Mean_Patience               =60;
int number_of_Agent_nodes       =5;
int simtime                     =86500;
int randm                       =1;
int Maximum_Queue_Length        =65;
int MaxCallsPerHour             =0;
int TOTALCALLS                  =0;
int SUM                         =0;
int SUM1                        =0;
int SUM2                        =0;
int SUM3                        =0;
int SUM4                        =0;
int MAX_Q                       =0;
int COUNT                       =0;
int MaxCallDuration             =0;
int MaxPatience                 =0;
int DurationScalingFactor       =0;
int PatienceScalingFactor       =0;

double   precision              =1;
double   MaxCallLength          =0;

uint32_t WagePerCall            =100;
uint32_t AverageServiceTime     =45;
uint32_t meanskill              =2;
uint32_t meanVRUTime            =10;
uint32_t TotalWages             =0;

int      **TABLE                =new int   *  [25];
int      **AG_SER               =new int   *[90000];
int      *VRU_ENTRY             =new int    [90000];
bool     *idleArray             =new bool    [number_of_Agent_nodes];
bool     *Servicing             =new bool    [number_of_Agent_nodes];
uint32_t *SkillArray            =new uint32_t[number_of_Agent_nodes];
uint32_t *WagesArray            =new uint32_t[number_of_Agent_nodes];
uint32_t *AvgServiceTimeArray   =new uint32_t[number_of_Agent_nodes];
uint32_t *TimeOfLastServiceArray=new uint32_t[number_of_Agent_nodes];
string   **TEMP3                =new string*[90000];
string   **AVAIL_AGENT          =new string*[90000];
string   *TEMP                  =new string [90000];
string   *ENTRYTIME             =new string [90000];
string   *ordered               =new string [90000];
Ptr<Node> DistributorN;


string buffer;
 int HourlyWage                  =400;  // per hour
 int var                         =0;
 int calls                       =0;
 int Drops                       =0;
 int totalcalls                  =0;
 int Abandonements               =0;
 unsigned long long  sum7        =0;
 unsigned long long avgCalTime   =0;
 unsigned long long delay        =3;
 double Promoter                 =0;
 double Detractor                =0;
 double Passive                  =0;
 double prob                     =0;
 int counter                     =0;
 int QS                          =0;
 int pep                         =0;
 int servicelevel                =0;
 int qsize                       =0;
 int sum8                        =0;
 double v                                               [1000000];
 unsigned long long swait        = (1/precision);
 unsigned long long *Patience    =new unsigned long long[1000000];
 unsigned long long *DequeueTimes=new unsigned long long[1000000];
 unsigned long long *EnqueueTimes=new unsigned long long[1000000];
 unsigned long long *WaitingTimes=new unsigned long long[1000000];
 unsigned long long *CallTimes   =new unsigned long long[1000000];
 unsigned long long *PacketSizes =new unsigned long long[1000000];
 unsigned long long  HourlyAverageQueueWaitingTimes [24];
 unsigned long long CallsPerHour [24]; 
 unsigned long long CallsArrivingPerHour [24];
 unsigned long long AgentsAvailablePerHourN [24];
 std::string AgentsAvailablePerHour [24];
 std::string x;


class DistributorQueue{
public:
DistributorQueue(int m,AnimationInterface* anim)
{    
 MyLink                =0;
 Head                  =new Link;
 Tail                  =new Link;
 TotalPackets          =0;
 Head->Back            =Tail;
 Tail->Back            =NULL;
 Head->Front           =NULL;
 Tail->Front           =Head;
 MaximumQueueLimit     =m;
 TotalPacketsDequeued  =0;
 NumberOfPacketsInQueue=0;
 MyAnimator=anim;            
}


struct Link
{    
 Link *      Back;
 Link *      Front;
 uint32_t    Data;
 uint32_t    Skill;
 Ptr<Packet> pkt;
 long        EnqueueTime;
 uint32_t    QueueWaitingTime;
 uint32_t    VRUtime;
};
   

void Enqueue(Ptr<Packet> packet)
{
  //e<<"EnqueueS"<<endl;
 if(NumberOfPacketsInQueue<MaximumQueueLimit)
  {
  uint32_t data           =packet->GetSize();
  SocketIpTosTag          skillTag;
  SocketIpTtlTag          waitingtimeTag;
  packet                  ->RemovePacketTag (skillTag);
  packet                  ->RemovePacketTag (waitingtimeTag);
  uint32_t skill          =(uint32_t)skillTag      .GetTos ();
  uint32_t waitingtime    =(uint32_t)waitingtimeTag.GetTtl ();
  packet                  ->AddPacketTag(skillTag);        
  packet                  ->AddPacketTag(waitingtimeTag);                    
  Link* p                 =new Link;
  p->Data                 =data;
  p->Skill                =skill;
  p->QueueWaitingTime     =waitingtime*PatienceScalingFactor;
  if(int(p->QueueWaitingTime)>MaxPatience){MaxPatience=int(p->QueueWaitingTime);}
  p->pkt                  =packet;
  p->EnqueueTime          =(long(Simulator::Now().GetSeconds()));
  Link * t                =Tail->Front;
  Tail->Front             =p;
  p->Front                =t;
  t->Back                 =p;
  p->Back                 =Tail;
  NumberOfPacketsInQueue  ++;
  TotalPackets            ++;
  stringstream ss;
  ss<<(NumberOfPacketsInQueue);
  MyAnimator->UpdateNodeDescription(DistributorN,ss.str());
  //o<<"Enqueue "<<p<<endl;
  //o<<"Queue ";
  //PrintQueue();
  }
 else
  {
  
      Drops++;
    QS -= 1;

  }

  //e<<"EnqueueE"<<endl;
} 
  

void CountDown()
{//e<<"CountdownS"<<endl;
 if(NumberOfPacketsInQueue>0)
 {
  Link* a             =Head;
  while(a!=Tail)
  {
    //o<<a<<" ";
   a                  =a->Back;
   //o<<a<<" "<<Head<<" "<<Tail<<endl;
  if(a!=Tail)
  { a                  ->QueueWaitingTime=((a->QueueWaitingTime)-1);
   if(a->QueueWaitingTime==0)
   {
   Link* b            =a->Back;
   Link* c            =a->Front;    
   b->Front           =c;
   c->Back            =b;
   NumberOfPacketsInQueue--;
   //o<<"Abandonement "<<a<<endl;
    Abandonements++;
 //unsigned long long li_dec = (long(Simulator::Now().GetSeconds()))-long(a->EnqueueTime);
 //unsigned long long li_dec2= (long(Simulator::Now().GetSeconds()));

 //HourlyAverageQueueWaitingTimes[int((li_dec2)/3600)]+=li_dec;

 //CallsPerHour[int(li_dec2/3600)]++;
 //o<<li_dec<<" "<<CallsPerHour[int(li_dec2/3600)]<<endl;
 QS -= 1;
   }
 }
  }
  //o<<endl;
 }
 //e<<"CountdownE"<<endl;
}


/*
 The code is very similar to Enqueue funcion.
 Make a Link, put the packet, EnqueueTime and VRUtime in it.
 Do not add Skill, Data or QueueWaitingTime of Link. 
 Enqueue it at tail of VRUQueue. 
 Even when there is no packet in Queue, the Head and Tail Links must be present. 
*/
void VRUEnqueue(Ptr<Packet> packet,uint32_t VRUTime)
{
  //e<<"VRUEnqueueS"<<endl;
  Link* p                 =new Link;
  p->VRUtime              =VRUTime;
  p->pkt                  =packet;
  p->EnqueueTime          =(long(Simulator::Now().GetSeconds()));
  Link * t                =Tail->Front;
  Tail->Front             =p;
  p->Front                =t;
  t->Back                 =p;
  p->Back                 =Tail;
  NumberOfPacketsInQueue  ++;
  TotalPackets            ++;

  //o<<"VRUEnqueue "<<p<<" "<<packet->GetSize()<<endl;
//e<<"VRUEnqueueE"<<endl;
//o<<"VRU ";
//PrintQueue();
}

void PrintQueue()
{
 Link * a=Head;
 o<<a<<" ";
 while(a!=Tail)
 {
  a=a->Back;
  o<<a<<" ";
 }
 o<<endl;
}
/*
 The function is very similar to Countdown function.
 Start from the Head Link of the VRU Queue and go Back towards the Tail Link.
 Decement VRUtime in every Link except the Head and Tail Links. 
 If any Link has VRUtime=0, remove it's link from VRUQueue and enqueue it in Callers queue.
 The pointer for Caller's queue is the input of the VRUCountDown Function, DistributorQueue * queue.
*/
void VRUCountDown(DistributorQueue * queue)
{
 //e<<"VRUCountDownS"<<endl;
  if(NumberOfPacketsInQueue>0)
 {
  Link* a             =Head;
  while(a!=Tail)
   {
    
     a                  =a->Back;
    
     if(a!=Tail){
     a                  ->VRUtime=((a->VRUtime)-1);
     if(a->VRUtime==0)
     {
        Link* b            =a->Back;
        Link* c            =a->Front;    
        b->Front           =c;
        c->Back            =b;
        NumberOfPacketsInQueue--;
        //o<<"VRUDequeue "<<a<<endl;
        //o<<"VRU ";
        //PrintQueue();
        queue->Enqueue(a->pkt);
        
      }
    }
  
    }
 
 }
 
 //e<<"VRUCountDownE"<<endl;
}


Ptr<Packet> Dequeue()
{
  //e<<"DequeueS"<<endl;
 if(NumberOfPacketsInQueue>0)
  {
  Link* p    =Head      ->Back;
  Link* q    =p         ->Back;
  Head       ->Back     =q;
  q          ->Front    =Head;
  NumberOfPacketsInQueue--;
  TotalPacketsDequeued  ++;        

 double addr               = (((p->Data)<<16)+((p->Skill)<<8)+((p->QueueWaitingTime)));

 EnqueueTimes[totalcalls]  = long(p->EnqueueTime);

 DequeueTimes[totalcalls]  = (long(Simulator::Now().GetSeconds()));

 unsigned long long li_dec2=DequeueTimes[totalcalls],li_dec=EnqueueTimes[totalcalls];

 HourlyAverageQueueWaitingTimes[int((li_dec2)/3600)]+=li_dec2-li_dec;
 CallsPerHour[int((li_dec2)/3600)]++;
 //o<<(li_dec2-li_dec)<<" "<<CallsPerHour[int(li_dec2/3600)]<<" A"<<endl;
 totalcalls++;
 QS = QS+1;
 for(int i=0;i<counter;i++)
 {
    if(v[i]==addr)
    {
        prob++;i=counter;QS = QS-1;
    }
 }
 v[counter]=addr;
 counter++;



  stringstream ss;
  ss<<(NumberOfPacketsInQueue);
  MyAnimator->UpdateNodeDescription(DistributorN,ss.str());      
  //e<<"DequeueE"<<endl;
  //o<<"Dequeue "<<p<<" "<<p->pkt->GetSize()<<endl;
  //o<<"Queue ";
  //PrintQueue();
  return p->pkt;
  }
 else
  {
    //e<<"DequeueE"<<endl;
    return 0;}

}


Link * Head;
Link * Tail;
Link * MyLink;
AnimationInterface* MyAnimator;
int TotalPackets,NumberOfPacketsInQueue,TotalPacketsDequeued,MaximumQueueLimit;

};






        

class CallerApp:public Application{
public:
CallerApp()
{
 socket                   =0;
 peer                     =Address();
 TotalPacketsSent         =0;
 PacketSizeGenerator      =CreateObject<ExponentialRandomVariable>();
 SkillTypeGenerator       =CreateObject<ExponentialRandomVariable>();
 WaitingTimeGenerator     =CreateObject<ExponentialRandomVariable>();
 InterArrivalTimeGenerator=CreateObject<ExponentialRandomVariable>();
}


void Setup(Ptr<Socket> mysocket, Address address,uint32_t meantime, uint32_t meansize, uint32_t meanwaitingtime, uint32_t minskill, uint32_t boundskill)
{
 InterArrivalTimeGenerator->SetAttribute("Mean",DoubleValue(meantime));
 PacketSizeGenerator      ->SetAttribute("Mean",DoubleValue(meansize));
 WaitingTimeGenerator     ->SetAttribute("Mean",DoubleValue(meanwaitingtime));
 SkillTypeGenerator       ->SetAttribute("Mean" ,DoubleValue(boundskill));
 //SkillTypeGenerator       ->SetAttribute("Max" ,DoubleValue(boundskill));
 peer        =address;
 socket      =mysocket;
 myboundskill=boundskill;
}
 

void StartApplication()
{
  //e<<"CallerStartApplicationS"<<endl;
 socket->Bind();
 bool ipRecvTtl=true;
 bool ipRecvTos=true;
 socket        ->SetIpRecvTos (ipRecvTos);
 socket        ->SetIpRecvTtl (ipRecvTtl);
 socket        ->Connect(peer);
 SetHourlyPacketInterArrivalTime();
 SendPacket();
 //e<<"CallerStartApplicationE"<<endl; 
}


void StopApplication ()
{
  //e<<"CallerStopApplicationS"<<endl;
     if (SendEvent.IsRunning ())
       {
         Simulator::Cancel (SendEvent);
       }
       if (SendEvent1.IsRunning ())
       {
         Simulator::Cancel (SendEvent1);
       }
       if (socket)
       {
         socket->Close ();
       }
  //e<<"CallerStopApplicationE"<<endl;
}


void SetHourlyPacketInterArrivalTime()
{
  //e<<"SetHourlyPacketInterArrivalTimeS"<<endl;
 {
  if(TABLE[int(Simulator::Now().GetSeconds())/3600][3]>0){
 //  cout<<TABLE[int(Simulator::Now().GetSeconds())/3600][3]<<endl;
  InterArrivalTimeGenerator->SetAttribute("Mean",DoubleValue(3600/(1+TABLE[int(Simulator::Now().GetSeconds())/3600][3])));}
 }

 if((int((Simulator::Now().GetSeconds()))+3600)<(simtime-10))
 {
  cout<<(int((Simulator::Now().GetSeconds()))*100)/simtime<<" %"<<endl;
  Time       tnext(Seconds(3600));  
  SendEvent1=Simulator::Schedule(tnext,&CallerApp::SetHourlyPacketInterArrivalTime,this);
 
 //o<<(TABLE[int(Simulator::Now().GetSeconds())/3600][0])/11<<endl;
  for (int i = AgentsAvailablePerHourN[(int(Simulator::Now().GetSeconds())/3600)]; i >=0; i--)
  {
  if(!Servicing[i])
  {idleArray[i]=1;}
     TimeOfLastServiceArray[i]=uint32_t(Simulator::Now().GetSeconds())-i;
  }
 
  for (int i = AgentsAvailablePerHourN[(int(Simulator::Now().GetSeconds())/3600)]; i < number_of_Agent_nodes; i++)
  {
  idleArray[i]=0;
  TimeOfLastServiceArray[i]=uint32_t(simtime+10);
  }
 }
  //e<<"SetHourlyPacketInterArrivalTimeE"<<endl;
}


void SendPacket()
{
  //e<<"CallerSendPacketS"<<endl;
 time=1;
 if(TABLE[int(Simulator::Now().GetSeconds())/3600][3]>0)
 {for (int i = 0; i < randm; i++)
 {size      =PacketSizeGenerator      ->GetInteger();    
 waitingtime=WaitingTimeGenerator     ->GetInteger();
 skill      =SkillTypeGenerator       ->GetInteger();
 time       =InterArrivalTimeGenerator->GetInteger();}

 size=0;
 time=0;
 skill=0;
 waitingtime=0;
        
 while((size<=0)|(size>1450))            {size        =PacketSizeGenerator      ->GetInteger();}
 while((waitingtime<=0) )                {waitingtime =WaitingTimeGenerator     ->GetInteger();}
 while((skill<0) | (skill>5))            {skill       =1<<(SkillTypeGenerator       ->GetInteger());}
 while(time<=0)                          {time        =InterArrivalTimeGenerator->GetInteger();}

 socket->SetIpTos(skill);
 socket->SetIpTtl(waitingtime);

 Ptr<Packet> packet=Create<Packet>(size);

 socket->Send(packet);
 //o<<"Call Sent"<<endl;
 TotalPacketsSent++;
 PacketSizes[calls]        = size*DurationScalingFactor;
 sum7                      += time;
 Patience[calls]           = waitingtime*PatienceScalingFactor;
 CallTimes[calls]          = (long(Simulator::Now().GetSeconds()));
 calls++;
 qsize++;
 CallsArrivingPerHour[(long(Simulator::Now().GetSeconds()))/3600]++;
 }
 
 if((int((Simulator::Now().GetSeconds()))+int(time))<(simtime-10))
 {
 Time tnext(Seconds(static_cast<double>(time)));
 SendEvent=Simulator::Schedule(tnext,&CallerApp::SendPacket,this);
 }   
     
  //e<<"CallerSendPacketE"<<endl;
}
    
Address                        peer;
EventId                        SendEvent;
EventId                        SendEvent1;  
Ptr<Socket>                    socket;
int                            TotalPacketsSent;
Ptr<ExponentialRandomVariable> PacketSizeGenerator;
Ptr<ExponentialRandomVariable> SkillTypeGenerator;
Ptr<ExponentialRandomVariable> WaitingTimeGenerator;
Ptr<ExponentialRandomVariable> InterArrivalTimeGenerator;
uint32_t time,size,waitingtime,skill,myboundsize,myboundwaitingtime,myboundskill;
    
};

/*....Random Generator for the Agent's efficiency....
-Shoud be -ve exponential random variable with some mean and interarrival rate.......// Check the distributin from Ammara 

## IN Function Main::
Ptr<ExponentialRandomVariable> EfficiencyGenerator;

## in DEfault Constructor
EfficiencyGenerator ->SetAttribute("Mean",DoubleValue(meansize));

##
*/




// 
class ReceiverApp: public Application{
public:
ReceiverApp():peer(),MySocket(0)
{
 VRUTimeGenerator     =CreateObject<ExponentialRandomVariable>();
}
  

void Setup(Ptr<Socket> socket,Address Agentaddress,DistributorQueue* myqueue,int mypeernumber,uint32_t meanwaitingtime,DistributorQueue* VRUqueue)
{
 queue      =myqueue;
 VRUQueue   =VRUqueue; 
 MySocket   =socket;
 peer       =Agentaddress;
 PeerNumber =mypeernumber;
 VRUTimeGenerator     ->SetAttribute("Mean",DoubleValue(meanwaitingtime));
}


void StartApplication()
{
  //e<<"RecStartApplicationS"<<endl;
 MySocket->Bind();
    
 bool ipRecvTtl=true;
 bool ipRecvTos=true;


 MySocket      ->SetIpRecvTos (ipRecvTos);
 MySocket      ->SetIpRecvTtl (ipRecvTtl);
 MySocket      ->Connect(peer);
                
 MySocket->    SetRecvCallback(MakeCallback(&ReceiverApp::SocketRecv,this));
 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10)){ 
 Time          tnext(Seconds(1));
 Simulator::Schedule(tnext,&ReceiverApp::CountDown,this);
 }
 //e<<"RecStartApplicationE"<<endl;
}

 void StopApplication ()
 {
  //e<<"RecStopApplicationS"<<endl;
     if (SendEvent.IsRunning ())
       {
         Simulator::Cancel (SendEvent);
       }
       if (MySocket)
       {
         MySocket->Close ();
       }
  //e<<"RecStopApplicationE"<<endl;
 }

void SocketRecv(Ptr<Socket> socket)
{
 //e<<"RecSocketRecvS"<<endl;
 for (int i = 0; i < randm; i++)
 {
 VRUtime=VRUTimeGenerator->GetInteger();
 }

 VRUtime = 0;

 while((VRUtime<=0)){VRUtime =VRUTimeGenerator->GetInteger();}
 Address from;
 Ptr<Packet> packet=MySocket->RecvFrom(from);
  
 VRUQueue->VRUEnqueue(packet,VRUtime);
 MySocket->SetRecvCallback(MakeCallback(&ReceiverApp::SocketRecv,this));
 //e<<"RecSocketRecvE"<<endl;
}


void CountDown()
{
  //e<<"RecCountdownS"<<endl;
 queue->    CountDown();
 VRUQueue-> VRUCountDown(queue);
 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10)){
 Time       tnext(Seconds(1));
 SendEvent=Simulator::Schedule(tnext,&ReceiverApp::CountDown,this);
}
//e<<"RecCountdownE"<<endl;
}

  
Address           peer;
int               PeerNumber;
EventId           SendEvent;
uint32_t          PacketSize;
Ptr<Packet>       MyPacket;
Ptr<Socket>       MySocket;
Ptr<ExponentialRandomVariable> VRUTimeGenerator;
DistributorQueue* queue;
DistributorQueue* VRUQueue;
uint32_t VRUtime;
};







class DistributorApp: public Application{
public:
DistributorApp():peer(),dataRate(0),MySocket(0){}
  
void Setup(Ptr<Socket> socket, DataRate datarate,Address Agentaddress,uint32_t* mySkillArray,DistributorQueue* myqueue,bool* myidle,int mypeernumber,AnimationInterface * anim)
{
 idle       =myidle;
 queue      =myqueue;
 MySocket   =socket;
 dataRate   =datarate;
 peer       =Agentaddress;
 PeerNumber =mypeernumber;
 SkillArray =mySkillArray;
 MyAnimator = anim;
}


void StartApplication()
{
  //e<<"DisStartApplicationS"<<endl;
 MySocket->Bind();
  
 bool ipRecvTtl=true;
 bool ipRecvTos=true;

 MySocket      ->SetIpRecvTos (ipRecvTos);
 MySocket      ->SetIpRecvTtl (ipRecvTtl);
 MySocket      ->Connect(peer);
 
 if(RoutingType==1){
 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10))     
 {
  Time      tnext(Seconds(1/precision));
  SendEvent=Simulator::Schedule(tnext,&DistributorApp::SkillBasedRouting,this);// call the send packet func after each ms and sends the packets in a queue.
 } 
 }

 if(RoutingType==2){
 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10))     
 {
  Time      tnext(Seconds(1/precision));
  SendEvent=Simulator::Schedule(tnext,&DistributorApp::FSF,this);// call the send packet func after each ms and sends the packets in a queue.
 } 
 }

 if(RoutingType==3){
 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10))     
 {
  Time      tnext(Seconds(1/precision));
  SendEvent=Simulator::Schedule(tnext,&DistributorApp::LIF,this);// call the send packet func after each ms and sends the packets in a queue.
 } 
 }

 if(RoutingType==4){
 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10))     
 {
  Time      tnext(Seconds(1/precision));
  SendEvent=Simulator::Schedule(tnext,&DistributorApp::LCR,this);// call the send packet func after each ms and sends the packets in a queue.
 } 
 }
//e<<"DisStartApplicationE"<<endl;
}


void StopApplication ()
{
  //e<<"DisStopApplicationS"<<endl;
    if (SendEvent.IsRunning ())
    {
      Simulator::Cancel (SendEvent);
    }
    if (MySocket)
       {
         MySocket->Close ();
       }
//e<<"DisStopApplicationE"<<endl;
}


void SendPacket(int AgentNumber) 
{ 
  //e<<"DisSendPacketS"<<endl;
 MyPacket = queue->Dequeue(); 
 idle[AgentNumber] = 0; 
 MySocket ->Send(MyPacket);
 stringstream ss;
 ss<<(queue->NumberOfPacketsInQueue);
 MyAnimator->UpdateNodeDescription(DistributorN,ss.str());
//e<<"DisSendPacketE"<<endl;
}   

 

void swap(uint32_t* Arr,int a, int b) 
{
  //e<<"DisswapS"<<endl;
  uint32_t  temp = Arr[a];
  Arr[a] = Arr[b];
  Arr[b] = temp; 
//e<<"DisswapE"<<endl;
} 


uint32_t * SortMax(uint32_t Array[], int n) 
{
  //e<<"DisSortMaxS"<<endl;
  uint32_t * Array1 =new uint32_t[n];
  for (int i = 0; i < n; i++)
  {
     Array1 [i]=Array[i];
  }

  int i=0,j=0,max_index=0;
  for (i = 0; i < (n-1); i++)
  {
    max_index = i;
    for (j = (i+1); j < n; j++)
      {
      if (Array1[j] > Array1[i])
        {max_index = j;
      swap(Array1,max_index,i);}
      }
    }
//e<<"DisSortMaxE"<<endl;
    return Array1;

}


//Fastest Server First Routing Scheme...
void FSF() 
{ 
  //e<<"FSFS"<<endl;
 if(idle[PeerNumber]&&(queue->NumberOfPacketsInQueue>0)) 
 { 
 bool IsIdle=0; 
 uint32_t * MaxServiceArray = new uint32_t[number_of_Agent_nodes]; 
 int index=0; 
 //maxServiceArray has the agent nodes indexes in the sorted form. 
 MaxServiceArray =SortMax(AvgServiceTimeArray,number_of_Agent_nodes); 
 for(int i=0; i<number_of_Agent_nodes;i++) {
  //e<<MaxServiceArray[i]<<" ";
 }
 //e<<endl;
 for(int i=0; i<number_of_Agent_nodes;i++) 
 { 
 // index... AT which index of the maxServiceArray is the peer number. All //agents before that will have higher speed.  
 if(MaxServiceArray[i] == AvgServiceTimeArray[PeerNumber]) 
 {index = i;} 
 } 
 // check if All AgentsFasterThan MyAgentAreBusy. Use idleArray  
 if(index!=(number_of_Agent_nodes-1)){
 for(int i = (int(index)+1); i<number_of_Agent_nodes; i++) 
 { 
  for (int j = 0; j < number_of_Agent_nodes; j++)
  {
      if(MaxServiceArray[i]==AvgServiceTimeArray[j]) 
       {
          //e<<AvgServiceTimeArray[PeerNumber]<<" "<<AvgServiceTimeArray[j]<<endl;

         if(idleArray[j])
         {
          IsIdle=1;
          i=number_of_Agent_nodes;j=number_of_Agent_nodes;
         }
       } 
    }
 } 
 }
 // AllAgentsFasterThanMyAgentAreBusy, Dequeue Packet from queue and send it to My Agent. 
 // send packet to peerNumber...ASK!! 
 if(!IsIdle){
 SendPacket(PeerNumber);
 //e<<"Sent"<<endl;
 }
 else{
  //e<<"Not Sent"<<endl;
 }
 }

 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10))     
 {
 Time      tnext(Seconds(1/precision)); 
 SendEvent=Simulator::Schedule(tnext,&DistributorApp::FSF,this); 
 } 
 //e<<"FSFE"<<endl;
} 


//Longest Idle First...
void LIF() 
{
  //e<<"LIFS"<<endl;
 if(idle[PeerNumber]&&(queue->NumberOfPacketsInQueue>0)) 
 { 
  bool IsIdle=0; 
 uint32_t * MaxTimeOfLastServiceArray=new uint32_t[number_of_Agent_nodes]; 
 int index=0; 
 // MaxTimeOfLastServiceArray has the agent nodes indexes in the sorted form. 

 MaxTimeOfLastServiceArray=SortMax(TimeOfLastServiceArray,number_of_Agent_nodes); 
 for(int i=0; i<number_of_Agent_nodes;i++) 
 { 
  //e<<MaxTimeOfLastServiceArray[i]<<" ";
 if(MaxTimeOfLastServiceArray [i] == TimeOfLastServiceArray[PeerNumber]) 
 {index = i;} 
 } 
  //e<<endl;
 // check if All AgentsHavingLargerWaitingTimeThan MyAgentAreBusy. Use  

 //MySocket ->Send(MyPacket); 
 if(index!=(number_of_Agent_nodes-1)){
 for(int i = (int(index)+1); i<number_of_Agent_nodes; i++) 
 { 
  for (int j = 0; j < number_of_Agent_nodes; j++)
  {
    //e<<TimeOfLastServiceArray[PeerNumber]<<" "<<MaxTimeOfLastServiceArray[i]<<endl;
      if(MaxTimeOfLastServiceArray[i]==TimeOfLastServiceArray[j]) 
       {
         if(idleArray[j])
         {
          IsIdle=1;
          i=number_of_Agent_nodes;j=number_of_Agent_nodes;
         }
         else
          {
            //e<<"Busy"<<endl;
          }
       } 
    }
 } 
 }

 if(!IsIdle){
 SendPacket(PeerNumber);
 //e<<"Sent"<<endl;
 }
 else{
  //e<<"Not Sent"<<endl;
 }
 }

 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10))     
 {
 Time      tnext(Seconds(1/precision));
 SendEvent=Simulator::Schedule(tnext,&DistributorApp::LIF,this); 
 }
 //e<<"LIFE"<<endl;
} 


// Lowest Cost First routing Scheme..
void LCR()
{ 
 //e<<"LCRS"<<endl;
 if(idle[PeerNumber]&&(queue->NumberOfPacketsInQueue>0)) 
 { 
 bool IsIdle=0; 
 uint32_t * MaxCostArray = new uint32_t[number_of_Agent_nodes]; 
 int index=0; 
 //maxServiceArray has the agent nodes indexes in the sorted form. 
 MaxCostArray =SortMax(WagesArray,number_of_Agent_nodes); 
 // index... AT which index of the maxServiceArray is the peer number. All //agents before that will have higher speed.  
 for(int i=0; i<number_of_Agent_nodes;i++) 
 {
  //e<<" "<<MaxCostArray[i]<<" ";
 }
 for(int i=0; i<number_of_Agent_nodes;i++) 
 {
  //e<<" "<<WagesArray[i]<<" ";
 }
 //e<<endl;
 for(int i=0; i<number_of_Agent_nodes;i++) 
 { 
 if(MaxCostArray[i] == WagesArray[PeerNumber]) 
 {index = i;} 
 } 
 //e<<index<<" "<<WagesArray[PeerNumber]<<" "<<number_of_Agent_nodes<<endl;
 // check if All Agents having lower cost Than MyAgentAreBusy. Use //idleArray  
 if(index!=(number_of_Agent_nodes-1)){
 for(int i = int(index+1); i<number_of_Agent_nodes; i++) 
 { 
  for (int j = 0; j < number_of_Agent_nodes; j++)
  {
      if(MaxCostArray[i]==WagesArray[j]) 
       {
        //e<<j<<" "<<MaxCostArray[i]<<" "<<WagesArray[j]<<endl;
         if(idleArray[j])
         {
          //e<<idleArray[j]<<endl;
          IsIdle=1;
          i=number_of_Agent_nodes;j=number_of_Agent_nodes;

         }
       } 
    }
 } 
 }
 // AllAgentshaving lesser costThanMyAgentAreBusy, Dequeue Packet from //queue and send it to My Agent. 
 // send packet to peerNumber...ASK!! 
 if(!IsIdle){
 SendPacket(PeerNumber);
 //e<<"Sent"<<endl;
 }
 
 }

 if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10))     
 {
 Time      tnext(Seconds(1/precision));
 SendEvent=Simulator::Schedule(tnext,&DistributorApp::LCR,this); 
 }
  
 //e<<"LCRE"<<endl;
} 


void SkillBasedRouting()
{ //e<<"SkillBasedRoutingS"<<endl;
 // Fastest Service Firt...........

 // Skill based routing........
 //  e<<idle[PeerNumber]<<" "<<queue->NumberOfPacketsInQueue<<endl;
    if(idle[PeerNumber]&&(queue->NumberOfPacketsInQueue>0))
  { 
   bool found=0;
   DistributorQueue::Link* a=queue->Head->Back;
   DistributorQueue::Link* b=0;
   while(a!=queue->Tail)
   {

    //e<<SkillArray[PeerNumber]<<" "<<a->Skill<<endl;
    if((SkillArray[PeerNumber] & a->Skill)==a->Skill)
    {
     found=1;
     b    =a;
     a    =queue->Tail->Front;
    }
    a=a->Back;
   }
   if(found)
    {
       MyPacket=b->pkt;
     queue->NumberOfPacketsInQueue=queue->NumberOfPacketsInQueue-1;
     queue->TotalPacketsDequeued  =queue->TotalPacketsDequeued+1;
     b->Back->Front               =b->Front;
     b->Front->Back               =b->Back;
     PacketSize                   =MyPacket->GetSize();
     idle[PeerNumber]             =0;
     MySocket                     ->Send(MyPacket);
     

 double addr               = (((b->Data)<<16)+((b->Skill)<<8)+((b->QueueWaitingTime)));

 EnqueueTimes[totalcalls]  = long(b->EnqueueTime);

 DequeueTimes[totalcalls]  = (long(Simulator::Now().GetSeconds()));

 unsigned long long li_dec2=DequeueTimes[totalcalls],li_dec=EnqueueTimes[totalcalls];

 HourlyAverageQueueWaitingTimes[int((li_dec2)/3600)]+=li_dec2-li_dec;
 CallsPerHour[int((li_dec2)/3600)]++;
 // o<<(li_dec2-li_dec)<<" "<<CallsPerHour[int(li_dec2/3600)]<<" B "<< li_dec2<<" "<<li_dec;
 totalcalls++;
 QS = QS+1;
 for(int i=0;i<counter;i++)
 {
    if(v[i]==addr)
    {
        prob++;i=counter;QS = QS-1;
    }
 }
 v[counter]=addr;
 counter++;



     stringstream ss;
     ss<<(queue->NumberOfPacketsInQueue);
     MyAnimator->UpdateNodeDescription(DistributorN,ss.str());

     if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10)){
     Time                         tnext(Seconds(1/precision));
     SendEvent                    =Simulator::Schedule(tnext,&DistributorApp::SkillBasedRouting,this);
     }
    }
   else
    {
      if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10)){
     Time      tnext(Seconds(1/precision));
     SendEvent=Simulator::Schedule(tnext,&DistributorApp::SkillBasedRouting,this);
     }
    }   
  }
  else
  {
    if((int((Simulator::Now().GetSeconds()))+1)<(simtime-10)){
   Time      tnext(Seconds(1/precision));
   SendEvent=Simulator::Schedule(tnext,&DistributorApp::SkillBasedRouting,this);
   }
  }
  //e<<"SkillBasedRoutingE"<<endl;
}

bool *            idle;
Address           peer;
int               PeerNumber;
DataRate          dataRate;
EventId           SendEvent;
uint32_t          PacketSize;
Ptr<Packet>       MyPacket;
uint32_t *        SkillArray;
Ptr<Socket>       MySocket;
DistributorQueue* queue;
AnimationInterface* MyAnimator;
};











class AgentApp:public Application{
public:
AgentApp()
{ 
 mya          =0;
 myp1         =0;
 myp2         =0;
 MySocket     =0;
 PacketSize   =0;
 peer         =Address();
 PacketsServed=0;
 SendEvent    =EventId();
 EfficiencyGenerator = CreateObject<ExponentialRandomVariable>();
}
    
void Setup(Ptr<Socket> socket,Address address, uint32_t myAgentskill,int myAgentnumber,AnimationInterface* animator,uint32_t pic1,uint32_t pic2, uint32_t wage, uint32_t AvgServiceTime)
{
 mya           =animator;
 myp1          =pic1;
 myp2          =pic2;
 peer          =address;
 MySocket      =socket;
 AgentSkill    =myAgentskill;
 AgentNumber   =myAgentnumber;
 WagePerCall   = wage;
 AverageServiceTime  = AvgServiceTime;
 EfficiencyGenerator ->SetAttribute("Mean", DoubleValue(AverageServiceTime));
}

void StartApplication()
{
  //e<<"AgentStartApplicationS"<<endl;
 MySocket->Bind();
 bool ipRecvTtl=true;
 bool ipRecvTos=true;

 MySocket->SetIpRecvTos (ipRecvTos);
 MySocket->SetIpRecvTtl (ipRecvTtl);
 MySocket->Connect(peer);
 MySocket->SetRecvCallback(MakeCallback(&AgentApp::SocketRecv,this));
  //e<<"AgentStartApplicationE"<<endl;
}

 void StopApplication ()
 {
  //e<<"AgentStopApplicationS"<<endl;
     if (SendEvent.IsRunning ())
       {
         Simulator::Cancel (SendEvent);
       }
       if (MySocket)
       {
         MySocket->Close ();
       }

  //e<<"AgentStopApplicationE"<<endl;
 }    

void SocketRecv(Ptr<Socket> socket)
{
  //e<<"AgentSocketRecvS"<<endl;
 mya            ->UpdateNodeImage (AgentNumber+2, myp2); 
 MyPacket       =MySocket->Recv();
 PacketSize     =MyPacket->GetSize();
 PacketSize     =PacketSize-40;
 SocketIpTosTag skillTag;
 MyPacket       ->RemovePacketTag(skillTag);
 MyPacket       ->AddPacketTag(skillTag);
 TimeOfLastArrival = (uint32_t(Simulator::Now().GetSeconds()));
 
 for(int i = 0; i < randm; i++)
 {OP_Efficiency = EfficiencyGenerator->GetInteger();}

 OP_Efficiency = 0;

 while(OP_Efficiency<=0){OP_Efficiency = EfficiencyGenerator->GetInteger();}
 

 if((int((Simulator::Now().GetSeconds()))+int((0.5*PacketSize+0.5*OP_Efficiency)*DurationScalingFactor/1))<(simtime-10)){
  Servicing[AgentNumber]=1;
 Time           tnext (Seconds(static_cast<double>((0.5*PacketSize+0.5*OP_Efficiency)*DurationScalingFactor/1)));
 if(((0.5*PacketSize+0.5*OP_Efficiency)*DurationScalingFactor/1)>MaxCallLength){MaxCallLength=(DurationScalingFactor*(0.5*PacketSize+0.5*OP_Efficiency)/1);}
 if (!(SendEvent.IsRunning ())){
  //e<<(int(Simulator::Now().GetSeconds())/3600)<<endl;
  //e<<(int(Simulator::Now().GetSeconds()+((0.8*PacketSize+0.2*OP_Efficiency)/1))/3600)<<endl;
  if((int((Simulator::Now().GetSeconds()))+int((0.5*PacketSize+0.5*OP_Efficiency)*DurationScalingFactor/1))<(simtime-10)){
 SendEvent      =Simulator::Schedule(tnext,&AgentApp::ServiceComplete,this);}
 }
 }
 //e<<"AgentSocketRecvE"<<endl;
}
    
void ServiceComplete()
{
  //e<<"AgentServiceCompleteS"<<endl;     
 idleArray[AgentNumber]=1;
 Servicing[AgentNumber]=0;
 mya                      ->UpdateNodeImage (AgentNumber+2,myp1); 
 PacketsServed            ++;
 CallsRecieved_SinceJoined = PacketsServed;
 MySocket                 ->SetRecvCallback(MakeCallback(&AgentApp::SocketRecv,this));
 TimeOfLastService = (uint32_t(Simulator::Now().GetSeconds()));
 TimeOfLastServiceArray[AgentNumber]=TimeOfLastService;
 TotalWages+=WagePerCall;
  TimeOfLastService = (uint32_t(Simulator::Now().GetSeconds()));
//e<<"AgentServiceCompleteE"<<endl;
}
    
Address             peer;
uint32_t CallsRecieved_InADay; //......to model the exhaustion level.
uint32_t CallsRecieved_SinceJoined; //......to model the experience level.
uint32_t AverageServiceTime;
uint32_t WagePerCall; //......to model the wages.
uint32_t TimeOfLastService; //..... For Longest Idle First Routing scheme.
uint32_t TimeOfLastArrival; //..... For Longest Idle First Routing scheme.
uint32_t breaks; //......to model the .
uint32_t            myp1;
uint32_t            myp2;
int                 PacketsServed;
EventId             SendEvent;
int                 AgentNumber;
uint32_t            PacketSize;
Ptr<Socket>         MySocket;
Ptr<Packet>         MyPacket;
uint32_t            AgentSkill;
AnimationInterface* mya;
//EFFICIENCY OF THE Agent.
uint32_t OP_Efficiency; 
Ptr<ExponentialRandomVariable> EfficiencyGenerator;

};
// Random variable generator with meani Avg service time->time of Service.
// Routing Schemens LIR,FSF, Lowest cost 































 
void Create2DPlot ()
{
     std::string fileNameWithNoExtension = "plot";
     std::string graphicsFileName        = fileNameWithNoExtension + ".png";
     std::string plotFileName            = fileNameWithNoExtension + ".plt";
     std::string plotTitle               = "2-D Plot With Error Bars";
     std::string dataTitle               = "2-D Data With Error Bars";
   
     // Instantiate the plot and set its title.
     Gnuplot plot (graphicsFileName);
     plot.SetTitle (plotTitle);
   
     // Make the graphics file, which the plot file will create when it
     // is used with Gnuplot, be a PNG file.
     plot.SetTerminal ("png");
   
     // Set the labels for each axis.
     plot.SetLegend ("X Values", "Y Values");
   
     // Set the range for the x axis.
     plot.AppendExtra ("set xrange [-6:+6]");
   
     // Instantiate the dataset, set its title, and make the points be
     // plotted with no connecting lines.
     Gnuplot2dDataset dataset;
     dataset.SetTitle (dataTitle);
     dataset.SetStyle (Gnuplot2dDataset::POINTS);
   
     // Make the dataset have error bars in both the x and y directions.
     dataset.SetErrorBars (Gnuplot2dDataset::XY);
   
     double x;
     double xErrorDelta;
     double y;
     double yErrorDelta;
   
     // Create the 2-D dataset.
     for (x = -5.0; x <= +5.0; x += 1.0)
       {
         // Calculate the 2-D curve
         // 
         //            2
         //     y  =  x   .
         //  
         y = x * x;
   
         // Make the uncertainty in the x direction be constant and make
       // the uncertainty in the y direction be a constant fraction of
         // y's value.
         xErrorDelta = 0.25;
         yErrorDelta = 0.1 * y;
   
         // Add this point with uncertainties in both the x and y
        // direction.
         dataset.Add (x, y, xErrorDelta, yErrorDelta);
       }
   
     // Add the dataset to the plot.
     plot.AddDataset (dataset);
   
     // Open the plot file.
     std::ofstream plotFile (plotFileName.c_str());
   
     // Write the plot file.
     plot.GenerateOutput (plotFile);
   
     // Close the plot file.
     plotFile.close ();
}






















int stringtoint(string S)
{
 stringstream ss(S);
 int H;
 ss>>H;
 return H;
}












NS_LOG_COMPONENT_DEFINE ("CallCenterSimulation");
int
main (int argc, char *argv[])
{
 LogComponentEnable ("CallCenterSimulation", LOG_LEVEL_INFO);
 int ab;
 CommandLine cmd;
 cmd.AddValue ("RoutingType", "Routing", RoutingType);
 cmd.AddValue ("Date", "date", ab);
 cmd.Parse (argc, argv);
 stringstream ss;
 ss << ab;
 day = ss.str();
 
 for(int i=0;i<90000;i++)
 {
  TEMP3[i]=new string[9];
  AVAIL_AGENT[i]=new string[2];
  AG_SER[i]=new int[4];AG_SER[i][0]=0;AG_SER[i][1]=0;AG_SER[i][2]=0;AG_SER[i][3]=0;
 }

 for(int i=0;i<90000;i++)
 {
  ordered[i]="a";
 }

 for(int i=0;i<25;i++)
 {TABLE[i]=new int[4];TABLE[i][0]=0;TABLE[i][1]=0;TABLE[i][2]=0;TABLE[i][3]=0;
 }

 for (int i = 0; i < 24; i++)
 {
  CallsPerHour[i]=0;
  AgentsAvailablePerHourN[i]=0;
  AgentsAvailablePerHour[i]="a";
 }

 for (int i = 0; i < 24; i++)
 {
  CallsArrivingPerHour[i]=0;
 }
 INSTREAM.open(Month);
 IN1.open("results.txt");
 COPY.open("COPY.txt");
 while (!IN1.eof())
 {
 getline(IN1,BUFFER);
 COPY<<BUFFER;COPY<<endl; 
 }
 IN1.close();
 COPY.close();

 IN2.open("COPY.txt");
 o.open("results.txt");
 while (!IN2.eof())
 {
 getline(IN2,BUFFER);
 o<<BUFFER;o<<endl; 
 }
 o<<endl<<endl<<endl;
 BUFFER="a";
 IN2.close();
 e.open("debug.txt");

 getline(INSTREAM,BUFFER);
 int index  =0;

 while(!(INSTREAM.eof()))
 {
 getline(INSTREAM,BUFFER);
 istringstream ss(BUFFER);

 for(int j=0;j<17;j++){ ss>>TEMP[j];}
 
 ENTRYTIME[index]=TEMP[6];


 
 
 if(TEMP[5].compare(day)==0)
   {

     int POS1           = ENTRYTIME[index].find(":");      
     int HRS = stringtoint(ENTRYTIME[index].substr(0,POS1))*3600;
     TABLE[stringtoint(ENTRYTIME[index].substr(0,POS1))][3]++;
     if(TEMP[12].compare(agent)==0){
     TABLE[stringtoint(ENTRYTIME[index].substr(0,POS1))][0]++;
     //if(stringtoint(TEMP[11])>90){cout<<"*"<<endl;}
     TABLE[stringtoint(ENTRYTIME[index].substr(0,POS1))][1]+=stringtoint(TEMP[11]);
     TABLE[stringtoint(ENTRYTIME[index].substr(0,POS1))][2]+=stringtoint(TEMP[15]);
     }
     string TEMP1       = ENTRYTIME[index].erase(0,POS1+1);
     int POS2=TEMP1.find(":");
     if(stringtoint(TEMP[11])<5){SUM4++;}
     VRU_ENTRY[index]=HRS+stringtoint(TEMP1.substr(0,POS2))*60+stringtoint(TEMP1.substr(POS2+1));
     ordered[VRU_ENTRY[index]]=BUFFER;
     /* 
     TYPE        [VRU_ENTRY[index]]=TEMP[4];
     DATE        [VRU_ENTRY[index]]=TEMP[5];
     VRU_DURATION[VRU_ENTRY[index]]=TEMP[8];
     Q_TIME      [VRU_ENTRY[index]]=TEMP[11];
     OUTCOME     [VRU_ENTRY[index]]=TEMP[12];
     SERV_TIME   [VRU_ENTRY[index]]=TEMP[15];
     SERVER      [VRU_ENTRY[index]]=TEMP[16];
     */

     TEMP3[TOTALCALLS][1]=TEMP[4];
     TEMP3[TOTALCALLS][2]=TEMP[5];
     TEMP3[TOTALCALLS][3]=TEMP[6];
     TEMP3[TOTALCALLS][4]=TEMP[8];
     TEMP3[TOTALCALLS][5]=TEMP[11];
     TEMP3[TOTALCALLS][6]=TEMP[12];
     TEMP3[TOTALCALLS][7]=TEMP[15];
     TEMP3[TOTALCALLS][8]=TEMP[16];
     TOTALCALLS++;
     //cout<<TEMP[15]<<" ";
    }
 index++;
 }
 cout<<endl;




 for(int i=0;i<TOTALCALLS;i++)
 {

 SUM1+=stringtoint(TEMP3[i][5]);
 int POS=0;

 if((TEMP3[i][8].compare(noSERVER))!=0)
   {
  
      bool PRESENT=0;
   for(int h=0;h<COUNT;h++)
     {
       if((AVAIL_AGENT[h][0].find(TEMP3[i][8]))==0){PRESENT=1;POS=h;h=COUNT;}
       }
  
   if(!PRESENT)
     {

       AVAIL_AGENT[COUNT][0]=TEMP3[i][8];
      int POS1           = TEMP3[i][3].find(":");      

 if ((AgentsAvailablePerHour[stringtoint(TEMP3[i][3].substr(0,POS1))].find(TEMP3[i][8]))!=4294967295){}
 else{      

 //      AgentsAvailablePerHour[stringtoint(TEMP3[i][3].substr(0,POS1))]+=" ";
 AgentsAvailablePerHour[stringtoint(TEMP3[i][3].substr(0,POS1))]+=TEMP3[i][8];
       AgentsAvailablePerHourN[stringtoint(TEMP3[i][3].substr(0,POS1))]++;
       }
       AVAIL_AGENT[COUNT][1]+=TEMP3[i][1];AVAIL_AGENT[COUNT][1]+="-";

       AG_SER[COUNT][0]+=stringtoint(TEMP3[i][7]);
      if(stringtoint(TEMP3[i][7])>MaxCallDuration){MaxCallDuration=stringtoint(TEMP3[i][7]);}
       AG_SER[COUNT][1]+=1;
       if(TEMP3[i][1]=="PS"){AG_SER[COUNT][3]|=(1<<0);}
       if(TEMP3[i][1]=="NW"){AG_SER[COUNT][3]|=(1<<1);}
       if(TEMP3[i][1]=="NE"){AG_SER[COUNT][3]|=(1<<2);}
       if(TEMP3[i][1]=="TT"){AG_SER[COUNT][3]|=(1<<3);}
       if(TEMP3[i][1]=="IN"){AG_SER[COUNT][3]|=(1<<4);}
       if(TEMP3[i][1]=="PE"){AG_SER[COUNT][3]|=(1<<5);}
  
       //SUM1+=stringtoint(TEMP3[i][5]);
       SUM2+=stringtoint(TEMP3[i][4]);
       if(stringtoint(TEMP3[i][5])>MAX_Q){MAX_Q=stringtoint(TEMP3[i][5]); }
       COUNT++;
     }
  
   if(PRESENT) 
     {
      int POS1           = TEMP3[i][3].find(":");      
 if ((AgentsAvailablePerHour[stringtoint(TEMP3[i][3].substr(0,POS1))].find(TEMP3[i][8]))!=4294967295){}
 else{  //    AgentsAvailablePerHour[stringtoint(TEMP3[i][3].substr(0,POS1))]+=" ";
 AgentsAvailablePerHour[stringtoint(TEMP3[i][3].substr(0,POS1))]+=TEMP3[i][8];
       AgentsAvailablePerHourN[stringtoint(TEMP3[i][3].substr(0,POS1))]++;
       }
              AVAIL_AGENT[POS][1]+=TEMP3[i][1];AVAIL_AGENT[POS][1]+="-";
  
       AG_SER[POS][0]+=stringtoint(TEMP3[i][7]);
       AG_SER[POS][1]+=1;
       if(TEMP3[i][1]=="PS"){AG_SER[POS][3]|=(1<<0);}
       if(TEMP3[i][1]=="NW"){AG_SER[POS][3]|=(1<<1);}
       if(TEMP3[i][1]=="NE"){AG_SER[POS][3]|=(1<<2);}
       if(TEMP3[i][1]=="TT"){AG_SER[POS][3]|=(1<<3);}
       if(TEMP3[i][1]=="IN"){AG_SER[POS][3]|=(1<<4);}
       if(TEMP3[i][1]=="PE"){AG_SER[POS][3]|=(1<<5);}
       //SUM1+=stringtoint(TEMP3[i][5]);
       SUM2+=stringtoint(TEMP3[i][4]);
       if(stringtoint(TEMP3[i][5])>MAX_Q){MAX_Q=stringtoint(TEMP3[i][5]); }
     }
  
    }
 }





 o<<"Date:- "<<day<<endl;
 o<<"RoutingType:- ";
 if (RoutingType==1){o<<"SBR"<<endl;}
 if (RoutingType==2){o<<"FSF"<<endl;}
 if (RoutingType==3){o<<"LIF"<<endl;}
 if (RoutingType==4){o<<"LCR"<<endl;}
 o<<endl;
 for(int i=0;i<COUNT;i++)
 {

  AG_SER[i][2]=AG_SER[i][0]/AG_SER[i][1];     
  //o<<AVAIL_AGENT[i][0]<<" ";//<<AVAIL_AGENT[i][1];
  //o<<endl;
  //o<<"TotalAnswerTime:    "<<AG_SER[i][0]<<endl;
  //o<<"TotalcallsAnswered: "<<AG_SER[i][1]<<endl;
  //o<<"AverageServiceTime: "<<AG_SER[i][2]<<endl;
  //o<<"Agent Skill:        "<<AG_SER[i][3]<<endl<<endl;
    SUM +=AG_SER[i][0];
    //if(AG_SER[i][0]>MaxCallDuration){MaxCallDuration=AG_SER[i][0];}
    SUM3+=AG_SER[i][1];
 }
 cout<<endl;
 TABLE[24][0]=0;

 o<<"Calls Arriving Per Hour="<<endl;
 for(int i=0;i<24;i++)
 {
 o<<TABLE[i][3]<<" ";
 if (TABLE[i][3]>MaxCallsPerHour){MaxCallsPerHour=TABLE[i][3];}
 }
 o<<endl<<endl;
 cout<<endl;


 o<<"Calls Serviced Per Hour="<<endl;
 for(int i=0;i<24;i++)
 {
  //cout<<i<<" "<<AgentsAvailablePerHourN[i]<<endl;
 //cout<<AgentsAvailablePerHour[i].find("AVI")<<endl;
 o<<TABLE[i][0]<<" ";
 }
 o<<endl<<endl;
 cout<<endl;

 o<<"AgentsAvailablePerHour"<<endl;
 for(int i=0;i<24;i++)
 {
  o<<AgentsAvailablePerHourN[i]<<" ";
 }
 o<<endl<<endl;

 o<<"Average Queue Times per Hour="<<endl;
 for(int i=0;i<24;i++)
 {
  if(double(TABLE[i][0])!=0)
  {
      o<<double(TABLE[i][1])/double(TABLE[i][0])<<" ";
  }
    else{
      o<<0<<" ";
    }
 }
 o<<endl<<endl;



 o<<"Average Service Times per Hour="<<endl;
 for(int i=0;i<24;i++)
 {
  if(double(TABLE[i][0])!=0)
  {
    o<<double(TABLE[i][2])/double(TABLE[i][0])<<" ";
  }
    else
    {
      o<<0<<" ";
    }
 }
 o<<endl<<endl;


 o<<"TotalAgents=               "<<COUNT<<endl;
 o<<"Total Calls Answered=      "<<SUM3<<" / "<<TOTALCALLS<<endl;
 o<<"Average Duration of Call=  "<<SUM/SUM3<<endl;
 o<<"Maximum Duration of Call=  "<<MaxCallDuration<<endl;
 o<<"Average Queue Time=        "<<SUM1/TOTALCALLS<<endl;
 o<<"Maximum Patience in Queue= "<<MAX_Q<<endl;
 o<<"Average VRUQueue Time=     "<<SUM2/SUM3<<endl;
 o<<"Probaility Of Wait=        "<<(double(TOTALCALLS-SUM4)*100)/double(TOTALCALLS)<<endl;
 INSTREAM.close();
 
 /*Ptr<ExponentialRandomVariable> PacketSizeGenerator      =CreateObject<ExponentialRandomVariable>();
 PacketSizeGenerator      ->SetAttribute("Mean",DoubleValue(2));
 for(int i=0;i<SUM3;i++){
 int number=PacketSizeGenerator->GetInteger();
 while(number<=0||number>=5)
 {number=PacketSizeGenerator->GetInteger();}
  cout<<number<<" ";} 
 cout<<endl;
 */
 OUTSTREAM.open("ordered.txt");
 for(int i=0;i<90000;i++)
 {
  if(ordered[i]!="a")
  OUTSTREAM<<ordered[i]<<endl;
 }
 OUTSTREAM.close();
 

 DurationScalingFactor       =MaxCallDuration/1500;
 DurationScalingFactor       =2;
 Mean_Packet_Size            =(SUM/SUM3)/DurationScalingFactor;
 PatienceScalingFactor       =MAX_Q/255;
 PatienceScalingFactor       =2;
 Mean_Patience               =(SUM1/TOTALCALLS)/PatienceScalingFactor;
 number_of_Agent_nodes       =COUNT;
 WagePerCall                 =100;
 AverageServiceTime          =SUM/SUM3;
 meanVRUTime                 =SUM2/SUM3;

 //cout<<endl<<DurationScalingFactor<<" "<<PatienceScalingFactor<<endl; 
 
 idleArray                =new bool    [number_of_Agent_nodes];
 SkillArray               =new uint32_t[number_of_Agent_nodes];
 WagesArray               =new uint32_t[number_of_Agent_nodes];
 AvgServiceTimeArray      =new uint32_t[number_of_Agent_nodes];
 TimeOfLastServiceArray   =new uint32_t[number_of_Agent_nodes];
 Servicing                =new bool    [number_of_Agent_nodes];


 for (int i = 0; i < number_of_Agent_nodes; i++)
 {
 SkillArray[i]         =AG_SER[i][3];
 idleArray[i]          =1;
 WagesArray[i]         =i+AG_SER[i][3];
 AvgServiceTimeArray[i]=AG_SER[i][2]/DurationScalingFactor;
 TimeOfLastServiceArray[i]=0;
 Servicing[i]          =0;
 }






  
 //myfile.open ("Packets.txt");
  

 NodeContainer caller_node_container;
 NodeContainer distributor_node_container;
 NodeContainer caller_distributor_nodes_container;
 NodeContainer Agent_nodes_container;
 NodeContainer distributor_Agents_node_container[number_of_Agent_nodes];
 NodeContainer c;
  
 caller_node_container                   .Create(1);
 distributor_node_container              .Create(1);
 Agent_nodes_container                   .Create(number_of_Agent_nodes);

 caller_distributor_nodes_container      .Add(caller_node_container);
 caller_distributor_nodes_container      .Add(distributor_node_container);
  
 for (int i=0;i<number_of_Agent_nodes;i++)
 {distributor_Agents_node_container[i]   .Add(distributor_node_container.Get(0));    
 distributor_Agents_node_container[i]    .Add(Agent_nodes_container  .Get(i));}

 c                                       .Add(caller_node_container);
 c                                       .Add(distributor_node_container);
 c                                       .Add(Agent_nodes_container);




 PointToPointHelper caller_distributor_p2p_Helper;
 caller_distributor_p2p_Helper.SetDeviceAttribute ("DataRate", StringValue ("64kbps"));
 caller_distributor_p2p_Helper.SetChannelAttribute("Delay"   , StringValue ("3s"    ));

 NetDeviceContainer caller_distributor_net_device_container;
 NetDeviceContainer distributor_Agents_net_device_container_Array[number_of_Agent_nodes];
  
 caller_distributor_net_device_container = caller_distributor_p2p_Helper.Install (caller_distributor_nodes_container);
 for(int i=0;i<number_of_Agent_nodes;i++){distributor_Agents_net_device_container_Array[i] = caller_distributor_p2p_Helper.Install (distributor_Agents_node_container[i]);}
  
  

 InternetStackHelper stack;
 Ipv4AddressHelper address;
 stack  .Install (c);
 address.SetBase ("10.1.1.0", "255.255.255.0");
 Ipv4InterfaceContainer interface     =address.Assign (caller_distributor_net_device_container);
 Ipv4Address Ipv4Addresses            [number_of_Agent_nodes+2];
 Ipv4Addresses                        [0]=interface.GetAddress(0);
 Ipv4Addresses                        [1]=interface.GetAddress(1);
 Ipv4Address DistributorIpv4Addresses [number_of_Agent_nodes];
 Ipv4Address AgentIpv4Addresses       [number_of_Agent_nodes];
 Address NetDeviceAddresses           [number_of_Agent_nodes];
 Address DistributorNetDeviceAddresses[number_of_Agent_nodes];
 Address AgentNetDeviceAddresses      [number_of_Agent_nodes];

 NetDeviceAddresses[0]=caller_distributor_net_device_container.Get(0)->GetAddress();
 NetDeviceAddresses[1]=caller_distributor_net_device_container.Get(1)->GetAddress();

 uint16_t Ports[number_of_Agent_nodes+1];
 Ports[0]=0;
 Ports[1]=1;

 char a     [9]  ={'1','0','.','1','.','1','.','0'};
 char b     [10] ={'1','0','.','1','.','1','0','.','0'};
 char chars [8]  ={'2','3','4','5','6','7','8','9'};
 char chars2[10] ={'0','1','2','3','4','5','6','7','8','9'};

 for (int i = 0; i < (number_of_Agent_nodes); i++)
 {
 if(i<8){a[5]=chars[i];address.SetBase (a, "255.255.255.0");}
 if(i>7  && i<18){b[5]='1';b[6]=chars2[i- 8];address.SetBase (b, "255.255.255.0");}
 if(i>17 && i<28){b[5]='2';b[6]=chars2[i-18];address.SetBase (b, "255.255.255.0");}
 if(i>27 && i<38){b[5]='3';b[6]=chars2[i-28];address.SetBase (b, "255.255.255.0");}
 if(i>37 && i<48){b[5]='4';b[6]=chars2[i-38];address.SetBase (b, "255.255.255.0");}
 if(i>47 && i<58){b[5]='5';b[6]=chars2[i-48];address.SetBase (b, "255.255.255.0");}
 if(i>57 && i<68){b[5]='6';b[6]=chars2[i-58];address.SetBase (b, "255.255.255.0");}
 if(i>67 && i<78){b[5]='7';b[6]=chars2[i-68];address.SetBase (b, "255.255.255.0");}
 if(i>77 && i<88){b[5]='8';b[6]=chars2[i-78];address.SetBase (b, "255.255.255.0");}
 if(i>87 && i<98){b[5]='9';b[6]=chars2[i-88];address.SetBase (b, "255.255.255.0");}

 Ipv4InterfaceContainer interfaces =address   .Assign (distributor_Agents_net_device_container_Array[i] );
 AgentNetDeviceAddresses[i]        =distributor_Agents_net_device_container_Array[i].Get(1)->GetAddress();
 DistributorNetDeviceAddresses[i]  =distributor_Agents_net_device_container_Array[i].Get(0)->GetAddress();
 AgentIpv4Addresses[i]             =interfaces.GetAddress(1);
 DistributorIpv4Addresses[i]       =interfaces.GetAddress(0);
 Ports[i]                          =i;
 }




 Ptr<Socket> CallerSocket        = Socket::CreateSocket(c.Get(0)  ,TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
 CallerSocket                    ->Bind();
 CallerSocket                    ->BindToNetDevice(caller_distributor_net_device_container.Get(0));

 Ptr<Socket> DistributorSocket   = Socket::CreateSocket(c.Get(1)  ,TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
 DistributorSocket               ->Bind();
 DistributorSocket               ->BindToNetDevice(caller_distributor_net_device_container.Get(1));


 Ptr<Socket> AgentSocketArray      [number_of_Agent_nodes];
 Ptr<Socket> DistributorSocketArray[number_of_Agent_nodes];

 for (int i = 0; i < number_of_Agent_nodes; i++)
 {
 AgentSocketArray   [i]          = Socket::CreateSocket(c.Get(i+2),TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
 AgentSocketArray   [i]          ->Bind();
 AgentSocketArray   [i]          ->BindToNetDevice(distributor_Agents_net_device_container_Array[i].Get(1));
 DistributorSocketArray[i]       = Socket::CreateSocket(c.Get(1)  ,TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
 DistributorSocketArray[i]       ->Bind();
 DistributorSocketArray[i]       ->BindToNetDevice(distributor_Agents_net_device_container_Array[i].Get(0));
 }



 


 AnimationInterface* anim = new AnimationInterface ("anim1.xml");
 DistributorQueue q          =DistributorQueue(Maximum_Queue_Length,anim);
 DistributorQueue* queue     = &q;
 DistributorQueue Q          =DistributorQueue(1000,anim);
 DistributorQueue* VRUqueue  = &Q;
 uint32_t resourceId1     = anim->AddResource      ("/home/user/NS3/ns-allinone-3.26/netanim-3.107/b.png");
 uint32_t resourceId2     = anim->AddResource      ("/home/user/NS3/ns-allinone-3.26/netanim-3.107/a.png");
 uint32_t resourceId3     = anim->AddResource      ("/home/user/NS3/ns-allinone-3.26/netanim-3.107/d.png");
 uint32_t resourceId4     = anim->AddResource      ("/home/user/NS3/ns-allinone-3.26/netanim-3.107/c.png");

 DistributorN = c.Get(1);
 Ptr<CallerApp>      capp = CreateObject<CallerApp>      ();
 Ptr<ReceiverApp>    rapp = CreateObject<ReceiverApp>    ();

 capp->Setup (CallerSocket, InetSocketAddress (Ipv4Addresses[1], Ports[1]),uint32_t(Mean_InterArrival_Time),uint32_t(Mean_Packet_Size),uint32_t(Mean_Patience),uint32_t(1),uint32_t(meanskill));
 c.Get (0)  ->AddApplication (capp             );
 capp       ->SetStartTime   (Seconds (1.     ));
 capp       ->SetStopTime    (Seconds (simtime-10));

 rapp->Setup (DistributorSocket, InetSocketAddress (Ipv4Addresses[0], Ports[0]), queue,0,meanVRUTime,VRUqueue);
 c.Get (1)  ->AddApplication (rapp             );
 rapp       ->SetStartTime   (Seconds (1.     ));
 rapp       ->SetStopTime    (Seconds (simtime-10));

 for (int i = 0; i < number_of_Agent_nodes; i++)
 {
 Ptr<AgentApp>    Oapp   =CreateObject<AgentApp>   ();
 Ptr<DistributorApp> Dapp=CreateObject<DistributorApp>();

 Oapp->Setup (AgentSocketArray[i], InetSocketAddress (DistributorIpv4Addresses[i], Ports[1]),SkillArray[i],i,anim,resourceId3,resourceId4,WagesArray[i],AvgServiceTimeArray[i]);
 c.Get (i+2)->AddApplication (Oapp             );
 Oapp       ->SetStartTime   (Seconds (1.     ));
 Oapp       ->SetStopTime    (Seconds (simtime-10));

 Dapp->Setup (DistributorSocketArray[i],DataRate("64kbps"), InetSocketAddress (AgentIpv4Addresses[i], Ports[i+2]),SkillArray, queue,idleArray,i,anim);
 c.Get (1)  ->AddApplication (Dapp             );
 Dapp       ->SetStartTime   (Seconds (1.     ));
 Dapp       ->SetStopTime    (Seconds (simtime-10));
 }





 AsciiTraceHelper ascii;
 //caller_distributor_p2p_Helper.EnableAsciiAll (ascii.CreateFileStream ("p2p.tr"));
 
 //caller_distributor_p2p_Helper.EnablePcapAll ("simple-point-to-point-olsr");

 Ipv4GlobalRoutingHelper Router = Ipv4GlobalRoutingHelper();
 Router.PopulateRoutingTables();


 anim->SetConstantPosition(caller_node_container     .Get(0), 0,10);
 anim->SetConstantPosition(distributor_node_container.Get(0),10,10);
 int sign=1;
 for(int i=0;i<number_of_Agent_nodes;i++)
 {anim->SetConstantPosition(Agent_nodes_container.Get(i),20,10+sign*5*((i+1)/2));
 sign =-sign;}   

 //anim->SetBackgroundImage ("/home/eelab/workspace/ns-allinone-3.26/netanim-3.107/a.png", -50, -50, .1, .1, 1.0);

 anim->UpdateNodeImage (0, resourceId1);
 anim->UpdateNodeImage (1, resourceId2);

 for (int i = 2; i <= number_of_Agent_nodes+1; i++)
 {
 anim->UpdateNodeImage (i, resourceId3); 
 }
   
 Simulator::Stop (Seconds (simtime));
 Simulator::Run ();
 NS_LOG_INFO("Ending Topology"); 
 
 //myfile.close();

 

 ofstream out;
 
 unsigned long long sum=0,sum2=0,sum4=0,sum5=0;
 int rest = 0;
 for (int i = 0; i < totalcalls; i++)
 {
 //if ((DequeueTimes[i]>0) && (EnqueueTimes[i] > 0)&&(DequeueTimes[i]>EnqueueTimes[i]))
 {
 WaitingTimes[i] = DequeueTimes[i] - EnqueueTimes[i];
 //o<<EnqueueTimes[i]<<"  "<<DequeueTimes[i]<<"  "<<WaitingTimes[i]<<endl;
 sum += WaitingTimes[i]; 
 rest++;
 }
 }
 //o<<sum<<" "<<rest<<" "<<totalcalls<<endl;
 unsigned long long mean = sum / rest;
 sum5+=Patience[0];
 sum4+=PacketSizes[0];
 for (int i = 0; i < calls; i++)
 {
 sum2+=(CallTimes[i]-CallTimes[i-1]);
 sum5+=Patience[i];
 sum4+=PacketSizes[i];
 //o<<CallTimes[i]<<" "<<CallTimes[i-1]<<" "<<Patience[i]<<" "<<PacketSizes[i]<<endl;
 }

 Promoter = totalcalls*9;
 Detractor = Abandonements*4;
 Passive = ((Drops)+(0.5*totalcalls))*7;

 avgCalTime = ((sum) +(totalcalls*(sum4/calls))+(delay*calls)+(delay*totalcalls))/(calls);

 var = totalcalls*(sum4/calls);

 for(int k=0;k<calls;k++)
 {
   if(WaitingTimes[k]>swait)
    {
        pep++;
    }
 }
 
 for (int i=0;i<totalcalls;i++){if(WaitingTimes[i]<=1){sum8++;}}
 servicelevel = (double(sum8)/double(totalcalls))*100;
 o<<endl<<endl<<"Simulation Results:- "<<endl;
 o<<"CallsArrivingPerHour="<<endl;
 for (int i = 0; i < 24; i++)
 {
  o<<CallsArrivingPerHour[i]<<" ";
 }
 o<<endl;
 o<<"CallsServicedPerHour="<<endl;
 for (int i = 0; i < 24; i++)
 {
  o<<CallsPerHour[i]<<" ";
 }
 o<<endl;
 o<<"HourlyAverageQueueWaitingTimes="<<endl;
 for (int i = 0; i < 24; i++)
 {
  if(CallsPerHour[i]>0)
  {
  o<<(double(HourlyAverageQueueWaitingTimes[i])/double(CallsPerHour[i]))<<" ";}
  else {o<<0<<" ";}
 }
 o                                                                                                                                             <<endl;
 o                                                                                                                                             <<endl; 
 o<<"Arrivals per Minute=           "<<60/((double(sum2)/double(calls-1)))                                                                 <<endl;
 o<<"Mean InterArrivalTime=         "<<((double(sum7)/double(calls)))                                                                     <<"s"<<endl;
 o<<"Mean Packet Size=              "<<(double(sum4)/double(calls))                                                                            <<endl;
 o<<"Total Calls=                   "<< calls                                                                                                  <<endl;
 o<<"Total Problem Resolution=      "<< totalcalls                                                                                             <<endl;
 o<<"Percentage of calls serviced=  "<< (double(totalcalls)/double(calls))*100                                                            <<"%"<<endl;
 o<<"Total Blocked Calls=           "<<Drops<<endl;
 o<<"Blocking Percentage=           "<<((double(Drops)*100)/double(calls))                                                                <<"%"<<endl;
 o<<"Total Abandonements=           "<<Abandonements<<endl;
 o<<"Abandonements Percentage=      "<<((double(Abandonements)*100)/double(calls))                                                        <<"%"<<endl;
 o<<"Average Patience=              "<<(double(sum5)/double(calls))                                                                       <<"s"<<endl;
 o<<"Mean WaitingTime=              "<<(double(mean))                                                                                 <<"s"<<endl;
 o<<"First Call Resolution=         "<< ((double(calls)-double(prob))/double(calls))*100                                                  <<"%"<<endl;
 o<<"Net Promotor Score=            "<<(((double(Promoter)-double(Detractor)))/(double(Promoter)+double(Passive)+double(Detractor)))*100       <<endl;
 o<<"Percentage of time Agents busy="<<((double(totalcalls)*(double(sum4)/double(calls)))/(double(simtime*number_of_Agent_nodes)))*100    <<"%"<<endl;
 o<<"Average Caller time in system= "<<(double(avgCalTime))                                                                               <<"s"<<endl;
 //o<<"Total Agents Salary=           "<<(double((var/3600)*HourlyWage))                                                                   <<"Rs"<<endl;
 o<<"Quality Score=                 "<<(double(QS))                                                                                            <<endl;
 o<<"Prob of waiting=               "<<(double(pep)/double(calls))*100                                                                    <<"%"<<endl;
 o<<"Service Level=                 "<<double(servicelevel)                                                                               <<"%"<<endl;
 o<<"Traffic Intensity=             "<<(double(double(calls-1)*1000000)/((double(sum2))))*(double(sum4)/double(calls))                         <<endl;     
 o<<"Total Wages=                   "<<TotalWages                                                                                              <<endl;
 o<<"Maximum CallLength=            "<<MaxCallLength                                                                                           <<endl;
 o<<"Maximum Patience=              "<<MaxPatience                                                                                             <<endl;
 

 o.close();                                                                                                       
 Simulator::Destroy ();
 return 0;

}
