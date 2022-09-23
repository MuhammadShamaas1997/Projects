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
#include <string>
#include <iostream>
#include <fstream>
using namespace ns3;
using namespace std;

ofstream myfile;
int Mean_InterArrival_Time  =30;
int Mean_Packet_Size        =86;
int Mean_Patience           =500;
int number_of_operator_nodes=3;
int simtime                 =3600;
int randm                   =0;
int Maximum_Queue_Length    =5;
uint32_t WagePerCall        =100;
uint32_t AverageServiceTime =86;
double precision            =10;
uint32_t maxskill           =1;
bool * idleArray            =new bool[number_of_operator_nodes];
bool * WagesArray           =new bool[number_of_operator_nodes];
bool * AvgServiceTimeArray  =new bool[number_of_operator_nodes];
Ptr<Node> DistributorN;

class DistributorQueue{
public:
DistributorQueue(int m, AnimationInterface* anim)
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
MyAnimator            =anim; 
}

struct Link{	
Link *      Back;
Link *      Front;
uint32_t    Data;
uint32_t    Skill;
Ptr<Packet> pkt;
Time        EnqueueTime;
uint32_t    QueueWaitingTime;
};
	
void Enqueue(Ptr<Packet> packet)
{
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
  p->QueueWaitingTime     =waitingtime;
  p->pkt                  =packet;
  p->EnqueueTime          =Time(Seconds(Simulator::Now().GetSeconds()));
  Link * t                =Tail->Front;
  Tail->Front             =p;
  p->Front                =t;
  t->Back                 =p;
  p->Back                 =Tail;
  NumberOfPacketsInQueue  ++;
  TotalPackets            ++;
  //myfile <<endl<<"Enqueue"<<endl<<"["<<endl<<"PacketNumber: "<<TotalPackets<<endl<<"NumberOfPacketsInQueue: "<<NumberOfPacketsInQueue<<endl<<"PacketSize: "<<data<<endl<<"Packet Skill: "<<skill<<endl<<"Packet Waiting Time: "<<waitingtime<<endl<<"EnqueueTime: "<<p->EnqueueTime<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
  myfile <<endl<<"Enqueue"<<endl<<"NumberOfPacketsInQueue:"<<NumberOfPacketsInQueue<<endl;
  stringstream ss;
  ss<<(NumberOfPacketsInQueue);
  MyAnimator              ->UpdateNodeDescription(DistributorN,ss.str());
  }
 else
  {
  myfile<<endl<<"Packet Dropped , MaximumQueueLimit Exceeded"<<endl;
  }
} 
	
void CountDown()
{
if(NumberOfPacketsInQueue>0)
 {
  Link* a             =Head;
  while(a!=Tail)
  {
   a                  =a->Back;
   a                  ->QueueWaitingTime=((a->QueueWaitingTime)-1);
   if(a->QueueWaitingTime==0)
   {
   Link* b            =a->Back;
   Link* c            =a->Front;	
   b->Front           =c;
   c->Back            =b;
   NumberOfPacketsInQueue--;
   myfile <<endl<<"Queue Abandonement "<<endl<<"Packet Waiting Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))-a->EnqueueTime<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
   }
  }
 }
}


Ptr<Packet> Dequeue()
{
 if(NumberOfPacketsInQueue>0)
  {
  Link* p    =Head      ->Back;
  Link* q    =p         ->Back;
  Head       ->Back     =q;
  q          ->Front    =Head;
  NumberOfPacketsInQueue--;
  TotalPacketsDequeued  ++;		
  //myfile <<endl<<"Dequeue"<<endl<<"["<<endl<<"NumberOfPacketsInQueue: "<<NumberOfPacketsInQueue<<endl<<"PacketSize: "<<p->Data<<endl<<"Packet Skill: "<<p->Skill<<endl<<"Packet Waiting Time: "<<p->QueueWaitingTime<<endl<<"EnqueueTime: "<<p->EnqueueTime<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;		
  return p->pkt;
  stringstream ss;
  ss<<(NumberOfPacketsInQueue);
  MyAnimator              ->UpdateNodeDescription(DistributorN,ss.str());
  }
 else
  {return 0;}
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
SkillTypeGenerator       =CreateObject<UniformRandomVariable>();
WaitingTimeGenerator     =CreateObject<ExponentialRandomVariable>();
InterArrivalTimeGenerator=CreateObject<ExponentialRandomVariable>();
}

void Setup(Ptr<Socket> mysocket, Address address,uint32_t meantime, uint32_t meansize, uint32_t meanwaitingtime, uint32_t minskill, uint32_t boundskill)
{
InterArrivalTimeGenerator->SetAttribute("Mean",DoubleValue(meantime));
PacketSizeGenerator      ->SetAttribute("Mean",DoubleValue(meansize));
WaitingTimeGenerator     ->SetAttribute("Mean",DoubleValue(meanwaitingtime));
SkillTypeGenerator       ->SetAttribute("Min" ,DoubleValue(minskill));
SkillTypeGenerator       ->SetAttribute("Max" ,DoubleValue(boundskill));
peer        =address;
socket      =mysocket;
myboundskill=boundskill;
}
	
void StartApplication(){
socket->Bind();
bool ipRecvTtl=true;
bool ipRecvTos=true;
socket        ->SetIpRecvTos (ipRecvTos);
socket        ->SetIpRecvTtl (ipRecvTtl);
socket        ->Connect(peer);
SendPacket();
}
	
	
void SendPacket(){
for (int i = 0; i < randm; i++)
{size      =PacketSizeGenerator      ->GetInteger();	
waitingtime=WaitingTimeGenerator     ->GetInteger();
skill      =SkillTypeGenerator       ->GetInteger();
time       =InterArrivalTimeGenerator->GetInteger();}

size=0;
time=0;
skill=0;
waitingtime=0;
		
while((size<=0))                        {size        =PacketSizeGenerator      ->GetInteger();}
while((waitingtime<=0) )                {waitingtime =WaitingTimeGenerator     ->GetInteger();}
while((skill<=0) | (skill>myboundskill)){skill       =SkillTypeGenerator       ->GetInteger();}
while(time<=0)                          {time        =InterArrivalTimeGenerator->GetInteger();}

socket->SetIpTos(skill);
socket->SetIpTtl(waitingtime);

Ptr<Packet> packet=Create<Packet>(size);

socket->Send(packet);
TotalPacketsSent++;

Time tnext(Seconds(static_cast<double>(time)));
SendEvent=Simulator::Schedule(tnext,&CallerApp::SendPacket,this);
myfile <<endl<<"Call Sent"<<endl<<"PacketSize:"<<size<<endl<<"InterArrivalTime:"<<time<<endl<<"Packet Waiting Time:"<<waitingtime<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;	
}
	
Address                        peer;
EventId                        SendEvent;
Ptr<Socket>                    socket;
int                            TotalPacketsSent;
Ptr<ExponentialRandomVariable> PacketSizeGenerator;
Ptr<UniformRandomVariable>     SkillTypeGenerator;
Ptr<ExponentialRandomVariable> WaitingTimeGenerator;
Ptr<ExponentialRandomVariable> InterArrivalTimeGenerator;
uint32_t time,size,waitingtime,skill,myboundsize,myboundwaitingtime,myboundskill;
	
};


















// 
class ReceiverApp: public Application{
public:
ReceiverApp():peer(),MySocket(0){}
	
void Setup(Ptr<Socket> socket,Address operatoraddress,DistributorQueue* myqueue,int mypeernumber){
queue      =myqueue;
MySocket   =socket;
peer       =operatoraddress;
PeerNumber =mypeernumber;
}

void StartApplication()
{
 MySocket->Bind();
	
 bool ipRecvTtl=true;
 bool ipRecvTos=true;

 MySocket      ->SetIpRecvTos (ipRecvTos);
 MySocket      ->SetIpRecvTtl (ipRecvTtl);
 MySocket      ->Connect(peer);
				
 MySocket->    SetRecvCallback(MakeCallback(&ReceiverApp::SocketRecv,this));
 Time          tnext(Seconds(1));
 Simulator::Schedule(tnext,&ReceiverApp::CountDown,this);
}

void CountDown()
{
 queue->    CountDown();
 Time       tnext(Seconds(1));
 Simulator::Schedule(tnext,&ReceiverApp::CountDown,this);
}

void SocketRecv(Ptr<Socket> socket)
{
 Address from;
 Ptr<Packet> packet=MySocket->RecvFrom(from);
 queue                      ->Enqueue(packet);// place the received paket in a queue
 MySocket->SetRecvCallback(MakeCallback(&ReceiverApp::SocketRecv,this));
}
	
Address           peer;
int               PeerNumber;
EventId           SendEvent;
uint32_t          PacketSize;
Ptr<Packet>       MyPacket;
Ptr<Socket>       MySocket;
DistributorQueue* queue;
};






































class DistributorApp: public Application{
public:
DistributorApp():peer(),dataRate(0),MySocket(0){}
	
void Setup(Ptr<Socket> socket, DataRate datarate,Address operatoraddress,uint32_t* mySkillArray,DistributorQueue* myqueue,bool* myidle,int mypeernumber){
idle       =myidle;
queue      =myqueue;
MySocket   =socket;
dataRate   =datarate;
peer       =operatoraddress;
PeerNumber =mypeernumber;
SkillArray =mySkillArray;
}

void StartApplication()
{
 MySocket->Bind();
	
 bool ipRecvTtl=true;
 bool ipRecvTos=true;

 MySocket      ->SetIpRecvTos (ipRecvTos);
 MySocket      ->SetIpRecvTtl (ipRecvTtl);
 MySocket      ->Connect(peer);
		 
 {
  Time      tnext(Seconds(1/precision));
  SendEvent=Simulator::Schedule(tnext,&DistributorApp::SendPacket,this);// call the send packet func after each ms and sends the packets in a queue.
 } 
}
// Skill based routin
void SendPacket()
{	
    if(idle[PeerNumber]&&(queue->NumberOfPacketsInQueue>0))
	{	
	 bool found=0;
	 DistributorQueue::Link* a=queue->Head->Back;
	 DistributorQueue::Link* b=0;
	 while(a!=queue->Tail)
	 {
	  if((SkillArray[PeerNumber] & a->Skill)== a->Skill)
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
	   myfile <<endl<<"Packet Removed from Queue"<<endl<<"Packet Address:"<<(((b->Data)<<16)+((b->Skill)<<8)+((b->QueueWaitingTime)))<<endl<<"PacketEnqueueTime: "<<b->EnqueueTime<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
	   queue->NumberOfPacketsInQueue=queue->NumberOfPacketsInQueue-1;
	   queue->TotalPacketsDequeued  =queue->TotalPacketsDequeued+1;
	   b->Back->Front               =b->Front;
	   b->Front->Back               =b->Back;
	   PacketSize                   =MyPacket->GetSize();
	   idle[PeerNumber]             =0;
	   MySocket                     ->Send(MyPacket);
	   Time                         tnext(Seconds(PacketSize*8/static_cast<double>(dataRate.GetBitRate())));
	   SendEvent                    =Simulator::Schedule(tnext,&DistributorApp::SendPacket,this);
	   
	  }
	 else
	  {
	   Time      tnext(Seconds(1/precision));
	   SendEvent=Simulator::Schedule(tnext,&DistributorApp::SendPacket,this);
	  }		
	}
	else
	{
	 Time      tnext(Seconds(1/precision));
	 SendEvent=Simulator::Schedule(tnext,&DistributorApp::SendPacket,this);
	 
	}
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
};
























class OperatorApp:public Application{
public:
OperatorApp()
{ 
 mya          =0;
 myp1         =0;
 myp2         =0;
 MySocket     =0;
 PacketSize   =0;
 peer         =Address();
 PacketsServed=0;
 SendEvent    =EventId();
}
		
void Setup(Ptr<Socket> socket,Address address, uint32_t myoperatorskill,int myoperatornumber,AnimationInterface* animator,uint32_t pic1,uint32_t pic2, uint32_t wage, uint32_t AvgServiceTime)
{
 mya           =animator;
 myp1          =pic1;
 myp2          =pic2;
 peer          =address;
 MySocket      =socket;
 OperatorSkill =myoperatorskill;
 OperatorNumber=myoperatornumber;
 WagePerCall   = wage;
 AverageServiceTime = AvgServiceTime;
}		
void StartApplication()
{
 MySocket->Bind();
 bool ipRecvTtl=true;
 bool ipRecvTos=true;

 MySocket->SetIpRecvTos (ipRecvTos);
 MySocket->SetIpRecvTtl (ipRecvTtl);
 MySocket->Connect(peer);
 MySocket->SetRecvCallback(MakeCallback(&OperatorApp::SocketRecv,this));
}
		
void SocketRecv(Ptr<Socket> socket)
{
 mya            ->UpdateNodeImage (OperatorNumber+2, myp2); 
 MyPacket       =MySocket->Recv();
 PacketSize     =MyPacket->GetSize();

 PacketSize     =PacketSize-40;
 SocketIpTosTag skillTag;
 MyPacket       ->RemovePacketTag(skillTag);
 MyPacket       ->AddPacketTag(skillTag);
 TimeOfLastArrival = Time(Seconds(Simulator::Now().GetSeconds()));
 //myfile <<endl<<"Operator Connected"<<endl<<"["<<endl<<"OperatorNumber: "<<OperatorNumber<<endl<<"OperatorSkill: "<<OperatorSkill<<endl<<"PacketsServed: "<<PacketsServed<<endl<<"PacketSize:"<<PacketSize<<endl<<"Packet Skill: "<<((uint32_t)skillTag.GetTos())<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
 Time           tnext (Seconds(static_cast<double>(PacketSize)));
 SendEvent      =Simulator::Schedule(tnext,&OperatorApp::SendPacket,this);
			
}
		
void SendPacket()
{			
 idleArray[OperatorNumber]=1;
 mya                      ->UpdateNodeImage (OperatorNumber+2,myp1); 
 PacketsServed            ++;
 CallsRecieved_SinceJoined = PacketsServed;
 MySocket                 ->SetRecvCallback(MakeCallback(&OperatorApp::SocketRecv,this));
 //myfile <<endl<<"Operator Reply"<<endl<<"["<<endl<<"OperatorNumber: "<<OperatorNumber<<endl<<"OperatorSkill: "<<OperatorSkill<<endl<<"PacketsServed: "<<PacketsServed<<endl<<"PacketSize: "<<PacketSize<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;TimeOfLastService = Time(Seconds(Simulator::Now().GetSeconds()));
}
		
Address             peer;
uint32_t CallsRecieved_InADay; //......to model the exhaustion level.
uint32_t CallsRecieved_SinceJoined; //......to model the experience level.
uint32_t AverageServiceTime;
uint32_t WagePerCall; //......to model the wages.
Time TimeOfLastService; //..... For Longest Idle First Routing scheme.
Time TimeOfLastArrival; //..... For Longest Idle First Routing scheme.
uint32_t breaks; //......to model the .
uint32_t            myp1;
uint32_t            myp2;
int                 PacketsServed;
EventId             SendEvent;
int                 OperatorNumber;
uint32_t            PacketSize;
Ptr<Socket>         MySocket;
Ptr<Packet>         MyPacket;
uint32_t            OperatorSkill;
AnimationInterface* mya;		
};
// Random variable generator with meani Avg service time->time of Service.
// Routing Schemens LIR,FSF, Lowest cost 


























class App:public Application{
	public:
		App(){
			MySocket=0;
			peer=Address();
		}
		
		void Setup(Ptr<Socket> socket,Address address){
			peer=address;
			MySocket=socket;
		}
		
		void StartApplication(){
			MySocket->Bind();
			MySocket->Connect(peer);
			Ptr<Packet> p = Create<Packet> (100);
            for(int i = 0; i<1; i++){MySocket->Send(p);}

			MySocket->SetRecvCallback(MakeCallback(&App::SocketRecv,this));
		}
		
		void SocketRecv(Ptr<Socket> socket)
		{
			MyPacket=MySocket->Recv();
			MySocket->Send(MyPacket);
		}

		Address peer;
		Ptr<Socket> MySocket;
		Ptr<Packet> MyPacket;
				
};
































NS_LOG_COMPONENT_DEFINE ("Call Center Simulation");
int
main (int argc, char *argv[])
{
LogComponentEnable ("Call Center Simulation", LOG_LEVEL_ALL);


CommandLine cmd;
// cmd.AddValue ("nue_node", "Number of \"extra\" CSMA nodes/devices", nue_node	);
//cmd.AddValue ("enb_node", "Number of \"extra\" CSMA nodes/devices", enb_node);
cmd.Parse (argc, argv);
  
myfile.open ("Packets.txt");
  

NodeContainer caller_node_container;
NodeContainer distributor_node_container;
NodeContainer caller_distributor_nodes_container;
NodeContainer operator_nodes_container;
NodeContainer distributor_operators_node_container[number_of_operator_nodes];
NodeContainer c;
  
caller_node_container                   .Create(1);
distributor_node_container              .Create(1);
operator_nodes_container                .Create(number_of_operator_nodes);

caller_distributor_nodes_container      .Add(caller_node_container);
caller_distributor_nodes_container      .Add(distributor_node_container);
  
for (int i=0;i<number_of_operator_nodes;i++)
{distributor_operators_node_container[i].Add(distributor_node_container.Get(0));	
 distributor_operators_node_container[i].Add(operator_nodes_container  .Get(i));}

c                                       .Add(caller_node_container);
c                                       .Add(distributor_node_container);
c                                       .Add(operator_nodes_container);




PointToPointHelper caller_distributor_p2p_Helper;
caller_distributor_p2p_Helper.SetDeviceAttribute ("DataRate", StringValue ("64kbps"));
caller_distributor_p2p_Helper.SetChannelAttribute("Delay"   , StringValue ("3s"    ));

NetDeviceContainer caller_distributor_net_device_container;
NetDeviceContainer distributor_operators_net_device_container_Array[number_of_operator_nodes];
  
caller_distributor_net_device_container = caller_distributor_p2p_Helper.Install (caller_distributor_nodes_container);
for(int i=0;i<number_of_operator_nodes;i++){distributor_operators_net_device_container_Array[i] = caller_distributor_p2p_Helper.Install (distributor_operators_node_container[i]);}
  
  

InternetStackHelper stack;
Ipv4AddressHelper address;
stack  .Install (c);
address.SetBase ("10.1.1.0", "255.255.255.0");
Ipv4InterfaceContainer interface     =address.Assign (caller_distributor_net_device_container);
Ipv4Address Ipv4Addresses            [number_of_operator_nodes+2];
Ipv4Addresses                        [0]=interface.GetAddress(0);
Ipv4Addresses                        [1]=interface.GetAddress(1);
Ipv4Address DistributorIpv4Addresses [number_of_operator_nodes];
Ipv4Address OperatorIpv4Addresses    [number_of_operator_nodes];
Address NetDeviceAddresses           [number_of_operator_nodes];
Address DistributorNetDeviceAddresses[number_of_operator_nodes];
Address OperatorNetDeviceAddresses   [number_of_operator_nodes];

NetDeviceAddresses[0]=caller_distributor_net_device_container.Get(0)->GetAddress();
NetDeviceAddresses[1]=caller_distributor_net_device_container.Get(1)->GetAddress();

uint16_t Ports[number_of_operator_nodes+1];
Ports[0]=0;
Ports[1]=1;

char a     [9]  ={'1','0','.','1','.','1','.','0'};
char b     [10] ={'1','0','.','1','.','1','0','.','0'};
char chars [8]  ={'2','3','4','5','6','7','8','9'};
char chars2[10] ={'0','1','2','3','4','5','6','7','8','9'};

for (int i = 0; i < (number_of_operator_nodes); i++)
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

Ipv4InterfaceContainer interfaces =address   .Assign (distributor_operators_net_device_container_Array[i] );
OperatorNetDeviceAddresses[i]     =distributor_operators_net_device_container_Array[i].Get(1)->GetAddress();
DistributorNetDeviceAddresses[i]  =distributor_operators_net_device_container_Array[i].Get(0)->GetAddress();
OperatorIpv4Addresses[i]          =interfaces.GetAddress(1);
DistributorIpv4Addresses[i]       =interfaces.GetAddress(0);
Ports[i]                          =i;
}
























Ptr<Socket> CallerSocket        = Socket::CreateSocket(c.Get(0)  ,TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
CallerSocket                    ->Bind();
CallerSocket                    ->BindToNetDevice(caller_distributor_net_device_container.Get(0));

Ptr<Socket> DistributorSocket   = Socket::CreateSocket(c.Get(1)  ,TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
DistributorSocket               ->Bind();
DistributorSocket               ->BindToNetDevice(caller_distributor_net_device_container.Get(1));


Ptr<Socket> OperatorSocketArray   [number_of_operator_nodes];
Ptr<Socket> DistributorSocketArray[number_of_operator_nodes];

for (int i = 0; i < number_of_operator_nodes; i++)
{
OperatorSocketArray   [i]       = Socket::CreateSocket(c.Get(i+2),TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
OperatorSocketArray   [i]       ->Bind();
OperatorSocketArray   [i]       ->BindToNetDevice(distributor_operators_net_device_container_Array[i].Get(1));
DistributorSocketArray[i]       = Socket::CreateSocket(c.Get(1)  ,TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
DistributorSocketArray[i]       ->Bind();
DistributorSocketArray[i]       ->BindToNetDevice(distributor_operators_net_device_container_Array[i].Get(0));
}



Ptr<UniformRandomVariable> SkillTypeGenerator=CreateObject<UniformRandomVariable>();
SkillTypeGenerator                          ->SetAttribute("Min",DoubleValue(1));
SkillTypeGenerator                          ->SetAttribute("Max",DoubleValue(maxskill));

uint32_t * SkillArray=new uint32_t[number_of_operator_nodes];

for (int i = 0; i < number_of_operator_nodes; i++)
{
uint32_t skill=0;
for  (int i = 0; i < randm; i++)    {skill=SkillTypeGenerator->GetInteger();}
while((skill<=0) | (skill>maxskill)){skill=SkillTypeGenerator->GetInteger();}
SkillArray[i]=skill;
}

for (int i = 0; i < number_of_operator_nodes; i++){idleArray[i]=1;WagesArray[i]=100;AvgServiceTimeArray[i]=50;}



AnimationInterface* anim = new AnimationInterface ("anim1.xml");
DistributorQueue q       =DistributorQueue(Maximum_Queue_Length,anim);
DistributorQueue* queue  = &q;
uint32_t resourceId1     = anim->AddResource      ("/root/NS3/ns-allinone-3.26/netanim-3.107/b.png");
uint32_t resourceId2     = anim->AddResource      ("/root/NS3/ns-allinone-3.26/netanim-3.107/a.png");
uint32_t resourceId3     = anim->AddResource      ("/root/NS3/ns-allinone-3.26/netanim-3.107/d.png");
uint32_t resourceId4     = anim->AddResource      ("/root/NS3/ns-allinone-3.26/netanim-3.107/c.png");

DistributorN = c.Get(1);
Ptr<CallerApp>      capp = CreateObject<CallerApp>      ();
Ptr<ReceiverApp>    rapp = CreateObject<ReceiverApp>    ();

capp->Setup (CallerSocket, InetSocketAddress (Ipv4Addresses[1], Ports[1]),uint32_t(Mean_InterArrival_Time),uint32_t(Mean_Packet_Size),uint32_t(Mean_Patience),uint32_t(1),uint32_t(maxskill));
c.Get (0)  ->AddApplication (capp             );
capp       ->SetStartTime   (Seconds (1.     ));
capp       ->SetStopTime    (Seconds (simtime));

rapp->Setup (DistributorSocket, InetSocketAddress (Ipv4Addresses[0], Ports[0]), queue,0);
c.Get (1)  ->AddApplication (rapp             );
rapp       ->SetStartTime   (Seconds (1.     ));
rapp       ->SetStopTime    (Seconds (simtime));

for (int i = 0; i < number_of_operator_nodes; i++)
{
Ptr<OperatorApp>    Oapp=CreateObject<OperatorApp>   ();
Ptr<DistributorApp> Dapp=CreateObject<DistributorApp>();

Oapp->Setup (OperatorSocketArray[i], InetSocketAddress (DistributorIpv4Addresses[i], Ports[1]),SkillArray[i],i,anim,resourceId3,resourceId4,WagesArray[i],AvgServiceTimeArray[i]);
c.Get (i+2)->AddApplication (Oapp             );
Oapp       ->SetStartTime   (Seconds (1.     ));
Oapp       ->SetStopTime    (Seconds (simtime));

Dapp->Setup (DistributorSocketArray[i],DataRate("64kbps"), InetSocketAddress (OperatorIpv4Addresses[i], Ports[i+2]),SkillArray, queue,idleArray,i);
c.Get (1)  ->AddApplication (Dapp             );
Dapp       ->SetStartTime   (Seconds (1.     ));
Dapp       ->SetStopTime    (Seconds (simtime));
}





AsciiTraceHelper ascii;
//caller_distributor_p2p_Helper.EnableAsciiAll (ascii.CreateFileStream ("p2p.tr"));
 
//caller_distributor_p2p_Helper.EnablePcapAll ("simple-point-to-point-olsr");

Ipv4GlobalRoutingHelper Router = Ipv4GlobalRoutingHelper();
Router.PopulateRoutingTables();


anim->SetConstantPosition(caller_node_container     .Get(0), 0,10);
anim->SetConstantPosition(distributor_node_container.Get(0),10,10);
int sign=1;
for(int i=0;i<number_of_operator_nodes;i++)
{anim->SetConstantPosition(operator_nodes_container.Get(i),20,10+sign*5*((i+1)/2));
sign =-sign;}   

//anim->SetBackgroundImage ("/home/eelab/workspace/ns-allinone-3.26/netanim-3.107/a.png", -50, -50, .1, .1, 1.0);

anim->UpdateNodeImage (0, resourceId1);
anim->UpdateNodeImage (1, resourceId2);

for (int i = 2; i <= number_of_operator_nodes+1; i++)
{
anim->UpdateNodeImage (i, resourceId3); 
}
   
Simulator::Stop (Seconds (simtime));
Simulator::Run ();
NS_LOG_INFO("Ending Topology"); 

myfile.close();



ifstream in;
in.open("Packets.txt");
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
int counter                     =0;
double prob                     =0;
int QS                          =0;
double              v                                  [1000000];
unsigned long long *Patience    =new unsigned long long[1000000];
unsigned long long *DequeueTimes=new unsigned long long[1000000];
unsigned long long *EnqueueTimes=new unsigned long long[1000000];
unsigned long long *WaitingTimes=new unsigned long long[1000000];
unsigned long long *CallTimes   =new unsigned long long[1000000];
unsigned long long *PacketSizes =new unsigned long long[1000000];


std::string x;
while (!(in.eof())){
getline(in, buffer);


if (buffer == "Call Sent")
{
getline(in, buffer);
std::size_t pos           = buffer.find(":");      
std::string str3          = buffer.substr(pos + 1);
std::string::size_type sz = 0;
unsigned long long li_dc  = std::stoull(str3, &sz, 10);
PacketSizes[calls]        = li_dc;


getline(in, buffer);
pos                       = buffer.find(":");      
str3                      = buffer.substr(pos + 1);
sz                        = 0;
li_dc                     = std::stoull(str3, &sz, 10);
sum7                      += li_dc;

getline(in, buffer);
pos                       = buffer.find(":");      
str3                      = buffer.substr(pos + 1);
sz                        = 0;
li_dc                     = std::stoull(str3, &sz, 10);
Patience[calls]           = li_dc;

getline(in, buffer);
pos                       = buffer.find("+");      
str3                      = buffer.substr(pos + 1);
str3                      .erase(str3.end() - 7, str3.end());
sz                        = 0;
li_dc                     = std::stoull(str3, &sz, 10);
CallTimes[calls]          = li_dc;
calls++;
}


if (buffer == "Packet Removed from Queue")
{
std::size_t pos;      
std::string str3;
std::string::size_type sz = 0;

getline(in, buffer);
pos                       = buffer.find(":");
x                         = buffer.substr(pos+1);
double addr               = stod(x,&sz);

getline(in, buffer);
pos                       = buffer.find("+");      
str3                      = buffer.substr(pos+1);
str3                      .erase(str3.end() - 7, str3.end());
sz                        = 0;
unsigned long long li_dec = std::stoull(str3, &sz,10);
EnqueueTimes[totalcalls]  = li_dec;

getline(in, buffer);
pos                       = buffer.find("+");      
str3                      = buffer.substr(pos+1);
str3                      .erase(str3.end() - 7, str3.end());
sz                        = 0;
li_dec                    = std::stoull(str3, &sz,10);
DequeueTimes[totalcalls]  = li_dec;

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


}



if (buffer == "Queue Abandonement ")
{
Abandonements++;
QS -= 1;
}


if(buffer == "Packet Dropped , MaximumQueueLimit Exceeded")
{
	Drops++;
	QS -= 1;
}
}




in.close();
unsigned long long sum=0,sum2=0,sum4=0,sum5=0;
int rest = 0;
for (int i = 0; i < totalcalls; i++)
{
if ((DequeueTimes[i]>0) && (EnqueueTimes[i] > 0)&&(DequeueTimes[i]>EnqueueTimes[i])){
WaitingTimes[i] = DequeueTimes[i] - EnqueueTimes[i];
//cout<<EnqueueTimes[i]<<"  "<<DequeueTimes[i]<<"  "<<WaitingTimes[i]<<endl;
sum += WaitingTimes[i]; 
rest++;
}
}

unsigned long  long mean = sum / rest;

sum5+=Patience[0];
sum4+=PacketSizes[0];
for (int i = 0; i < calls; i++)
{
sum2+=(CallTimes[i]-CallTimes[i-1]);
sum5+=Patience[i];
sum4+=PacketSizes[i];
//cout<<CallTimes[i]<<" "<<CallTimes[i-1]<<" "<<Patience[i]<<" "<<PacketSizes[i]<<endl;
}

Promoter = totalcalls*9;
Detractor = Abandonements*4;
Passive = ((Drops)+(0.5*totalcalls))*7;
avgCalTime = ((sum/1e6) +(totalcalls*(sum4/calls))+(delay*calls)+(delay*totalcalls))/(calls);
var = totalcalls*(sum4/calls);




cout                                                                                                                                             <<endl; 
cout<<"Arrivals per Minute=           "<<60/((double(sum2)/double(calls-1))/1e6)                                                                 <<endl;
cout<<"InterArrivalTime=              "<<((double(sum7)/double(calls)))                                                                     <<"s"<<endl;
cout<<"Mean Packet Size=              "<<(double(sum4)/double(calls))                                                                            <<endl;
cout<<"Blocking Percentage=           "<<((double(Drops)*100)/double(calls))                                                                <<"%"<<endl;
cout<<"Average Patience=              "<<(double(sum5)/double(calls))                                                                       <<"s"<<endl;
cout<<"Abandonements Percentage=      "<<((double(Abandonements)*100)/double(calls))                                                        <<"%"<<endl;
cout<<"Mean WaitingTime=              "<<(double(mean)/1e6)                                                                                 <<"s"<<endl;
cout<<"Total Calls=                   "<< calls                                                                                                  <<endl;
cout<<"Total Problem Resolution=      "<< totalcalls                                                                                             <<endl;
cout<<"Percentage of calls serviced=  "<< ((double(calls)-double(Abandonements)-double(Drops))/double(calls))*100                           <<"%"<<endl;
cout<<"First Call Resolution=         "<< ((double(calls)-double(prob))/double(calls))*100                                                  <<"%"<<endl;
cout<<"Net Promotor Score=            "<<(((double(Promoter)-double(Detractor)))/(double(Promoter)+double(Passive)+double(Detractor)))*100       <<endl;
cout<<"Percentage of time Agents busy="<<((double(totalcalls)*(double(sum4)/double(calls)))/(double(simtime*number_of_operator_nodes)))*100 <<"%"<<endl;
cout<<"Average Caller time in system= "<<(double(avgCalTime))                                                                               <<"s"<<endl;
cout<<"Total Agents Salary=           "<<(double((var/60)*HourlyWage))                                                                     <<"Rs"<<endl;
cout<<"Quality Score=                 "<<(double(QS))                                                                                            <<endl;
Simulator::Destroy ();
return 0;

}

