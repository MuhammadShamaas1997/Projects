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
#include "ns3/socket.h"
#include "ns3/event-id.h"
#include "ns3/random-variable-stream.h"
#include "ns3/rng-stream.h"
#include "ns3/rng-seed-manager.h"
#include "ns3/callback.h"
#include "ns3/point-to-point-helper.h"
#include "ns3/ipv4-static-routing-helper.h"
#include <string>
#include <cassert>
#include <stdlib.h>
#include <stdio.h>
#include <cmath>
#include <iostream>
#include <fstream>
using namespace ns3;
using namespace std;

ofstream myfile;
int Mean_InterArrival_Time=15;
int Mean_Packet_Size=50;
int number_of_operator_nodes=8;
bool * idleArray=new bool[number_of_operator_nodes];
int randm=0;
int simtime=5000;
double precision=Mean_Packet_Size;



class DistributorQueue{
	public:
		DistributorQueue()
		{
			Head=new Link;
			Tail=new Link;
			Head->Back=Tail;
			Head->Front=NULL;
			Tail->Front=Head;
			Tail->Back=NULL;
			TotalPackets=0;
			NumberOfPacketsInQueue=0;
			TotalPacketsDequeued=0;
		}

	struct Link{
		uint32_t Data;
		Link * Front;
		Link * Back;
		Ptr<Packet> pkt;
	};
	void Enqueue(Ptr<Packet> packet){

		uint32_t data=packet->GetSize();
		Link* p=new Link;
		p->Data=data;
		p->pkt=packet;
		Link * t=Tail->Front;
		Tail->Front=p;
		p->Front=t;
		t->Back=p;
		p->Back=Tail;
		NumberOfPacketsInQueue++;
		TotalPackets++;
		myfile<<endl<<"Enqueue"<<endl<<"["<<endl<<"PacketNumber: "<<TotalPackets<<endl<<"NumberOfPacketsInQueue: "<<NumberOfPacketsInQueue<<endl<<"PacketSize: "<<data<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
		
	} 


	Ptr<Packet> Dequeue()
	{
		if(NumberOfPacketsInQueue>0)
		{
		Link* p=Head->Back;
		Link* q=p->Back;
		Head->Back=q;
		q->Front=Head;
		NumberOfPacketsInQueue--;
		TotalPacketsDequeued++;
		myfile <<endl<<"Dequeue"<<endl<<"["<<endl<<"NumberOfPacketsInQueue: "<<NumberOfPacketsInQueue<<endl<<"PacketSize: "<<p->Data<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;		
		return p->pkt;
		}
		else
		{
			return 0;
		}
	}


int TotalPackets,NumberOfPacketsInQueue,TotalPacketsDequeued;
Link * Head;
Link * Tail;
};








class CallerApp:public Application{
	public:
		CallerApp(){
			socket=0;
			peer=Address();
			TotalPacketsSent=0;
			InterArrivalTimeGenerator=CreateObject<ExponentialRandomVariable>();
			PacketSizeGenerator=CreateObject<ExponentialRandomVariable>();

		}

	void Setup(Ptr<Socket> mysocket, Address address,
		uint32_t meantime,uint32_t boundtime,
		uint32_t meansize, uint32_t boundsize)
	{
		socket=mysocket;
		peer=address;
		InterArrivalTimeGenerator->SetAttribute("Mean",DoubleValue(meantime));
		
		PacketSizeGenerator->SetAttribute("Mean",DoubleValue(meansize));
	}
	
	void StartApplication(){
		socket->Bind();
		socket->Connect(peer);
		SendPacket();	
	}
	
	void SendPacket(){
		size=PacketSizeGenerator->GetInteger();
		for (int i = 0; i < randm; i++)
		{
		size=PacketSizeGenerator->GetInteger();	
		}
		while(size==0){size=PacketSizeGenerator->GetInteger();}
		Ptr<Packet> packet=Create<Packet>(size);
		
		socket->Send(packet);
		TotalPacketsSent++;

		//myfile <<endl<<"Call Sent"<<endl<<"["<<endl<<"PacketNumber: "<<TotalPacketsSent<<endl<<"PacketSize: "<<size<<endl<<"Packet Skill: "<<skill<<endl<<"Packet Waiting Time: "<<waitingtime<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
		myfile <<endl<<"Call Sent"<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"PacketSize: "<<size<<endl<<"]"<<endl;
		time=InterArrivalTimeGenerator->GetInteger();
		for (int i = 0; i < randm; i++)
		{
		time=InterArrivalTimeGenerator->GetInteger();	
		}
		while(time==0){time=InterArrivalTimeGenerator->GetInteger();}
		
		Time tnext(Seconds(static_cast<double>(time)));
		SendEvent=Simulator::Schedule(tnext,&CallerApp::SendPacket,this);
		
	}
	int TotalPacketsSent;
	uint32_t time,size;
	
	
	Ptr<Socket> socket;
	Address peer;
	EventId SendEvent;
	
	Ptr<ExponentialRandomVariable> InterArrivalTimeGenerator;
	Ptr<ExponentialRandomVariable> PacketSizeGenerator;
	
};





class DistributorApp: public Application{public:
	
	DistributorApp():MySocket(0),peer(),dataRate(0){}
	
	void Setup(Ptr<Socket> socket, DataRate datarate,Address operatoraddress,
	 DistributorQueue* myqueue,int mypeernumber,bool mytype){
		queue=myqueue;
		MySocket=socket;
		dataRate=datarate;
		PeerNumber=mypeernumber;
		peer=operatoraddress;
		type=mytype;
	}


	void StartApplication(){
		MySocket->Bind();
		MySocket->Connect(peer);
		if (type==1)
		{

			Time tnext(Seconds(1/precision));
			SendEvent=Simulator::Schedule(tnext,&DistributorApp::SendPacket,this);
		}
		MySocket->SetRecvCallback(MakeCallback(&DistributorApp::SocketRecv,this));

	}


	void SocketRecv(Ptr<Socket> socket)
	{
		if(type==0)
		{
			Address from;
			Ptr<Packet> packet=MySocket->RecvFrom(from);
			queue->Enqueue(packet);
		}

		MySocket->SetRecvCallback(MakeCallback(&DistributorApp::SocketRecv,this));
		
	}


	void SendPacket()
	{	
		if(idleArray[PeerNumber]&&(queue->NumberOfPacketsInQueue>0))
		{				
				MyPacket=queue->Dequeue();
				PacketSize=MyPacket->GetSize();
				idleArray[PeerNumber]=0;
				MySocket->Send(MyPacket);
				Time tnext(Seconds(PacketSize*8/static_cast<double>(dataRate.GetBitRate())));
				SendEvent=Simulator::Schedule(tnext,&DistributorApp::SendPacket,this);
				MySocket->SetRecvCallback(MakeCallback(&DistributorApp::SocketRecv,this));
		}
		else
		{
			Time tnext(Seconds(1/precision));
			SendEvent=Simulator::Schedule(tnext,&DistributorApp::SendPacket,this);
			MySocket->SetRecvCallback(MakeCallback(&DistributorApp::SocketRecv,this));
			
		}
		
	}


	DistributorQueue* queue;
	Ptr<Socket> MySocket;
	Address peer;
	int PeerNumber;
	DataRate dataRate;
	EventId SendEvent;
	uint32_t PacketSize;
	Ptr<Packet> MyPacket;
	bool type;
};
























class OperatorApp:public Application{
	public:
		OperatorApp(){
			MySocket=0;
			peer=Address();
			PacketSize=0;
			PacketsServed=0;
			SendEvent=EventId();
			mya=0;
			myp1=0;
			myp2=0;
		}
		
		void Setup(Ptr<Socket> socket,Address address, 
			int myoperatornumber,AnimationInterface* a,uint32_t p1,uint32_t p2){
			MySocket=socket;
			peer=address;
			OperatorNumber=myoperatornumber;
			mya=a;
			myp1=p1;
			myp2=p2;
			
		}
		
		void StartApplication(){
			MySocket->Bind();
			MySocket->Connect(peer);
			MySocket->SetRecvCallback(MakeCallback(&OperatorApp::SocketRecv,this));
		}
		
		void SocketRecv(Ptr<Socket> socket){
			mya->UpdateNodeImage (OperatorNumber+2, myp2); 
			MyPacket=MySocket->Recv();
			PacketSize=MyPacket->GetSize();
			PacketSize=PacketSize-40;
			//myfile <<endl<<"Operator Connected"<<endl<<"["<<endl<<"OperatorNumber: "<<OperatorNumber<<endl<<"OperatorSkill: "<<OperatorSkill<<endl<<"PacketsServed: "<<PacketsServed<<endl<<"PacketSize: "<<PacketSize<<endl<<"Packet Skill: "<<skillTag.GetTos()<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
			myfile <<endl<<"Operator Connected"<<endl<<"PacketSize:"<<PacketSize<<endl<<"Time: "<<Time(Seconds(Simulator::Now().GetSeconds()))<<endl<<"]"<<endl;
			
				Time tnext (Seconds(static_cast<double>(PacketSize)));
				SendEvent=Simulator::Schedule(tnext,&OperatorApp::SendPacket,this);	
		}
		
		void SendPacket(){			
			idleArray[OperatorNumber]=1;
			mya->UpdateNodeImage (OperatorNumber+2,myp1); 
			PacketsServed++;
			MySocket->SetRecvCallback(MakeCallback(&OperatorApp::SocketRecv,this));
		}
		
		uint32_t PacketSize;
		Ptr<Socket> MySocket;
		Ptr<Packet> MyPacket;
		Address peer;
		int PacketsServed;
		EventId SendEvent;
		int OperatorNumber;
		AnimationInterface* mya;
		uint32_t myp1;
		uint32_t myp2;
};



























class App:public Application{
	public:
		App(){
			MySocket=0;
			peer=Address();
		}
		
		void Setup(Ptr<Socket> socket,Address address){
			MySocket=socket;
			peer=address;
		}
		
		void StartApplication(){
			MySocket->Bind();
			MySocket->Connect(peer);
			Ptr<Packet> p = Create<Packet> (100);
            for(int i = 0; i<1; i++)
            {
             MySocket->Send(p);
            }

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

//int number_of_caller_nodes=1;
//int number_of_distributor_nodes=1;

CommandLine cmd;
// cmd.AddValue ("nue_node", "Number of \"extra\" CSMA nodes/devices", nue_node	);
//cmd.AddValue ("enb_node", "Number of \"extra\" CSMA nodes/devices", enb_node);
cmd.Parse (argc, argv);

  myfile.open ("Packets15_50_15d.txt");
  

  NodeContainer caller_node_container;
  caller_node_container.Create(1);
  
  NodeContainer distributor_node_container;
  distributor_node_container.Create(1);
  
  NodeContainer caller_distributor_nodes_container;
  caller_distributor_nodes_container.Add(caller_node_container);
  caller_distributor_nodes_container.Add(distributor_node_container);
  

  NodeContainer operator_nodes_container;
  operator_nodes_container.Create(number_of_operator_nodes);

  NodeContainer distributor_operators_node_container[number_of_operator_nodes];
  for (int i=0;i<number_of_operator_nodes;i++)
  {
  distributor_operators_node_container[i].Add(distributor_node_container.Get(0));	
  distributor_operators_node_container[i].Add(operator_nodes_container.Get(i));
  }

  NodeContainer c;
  c.Add(caller_node_container);
  c.Add(distributor_node_container);
  c.Add(operator_nodes_container);




  PointToPointHelper caller_distributor_p2p_Helper;
  caller_distributor_p2p_Helper.SetDeviceAttribute ("DataRate", StringValue ("64kbps"));
  caller_distributor_p2p_Helper.SetChannelAttribute ("Delay", StringValue ("0ms"));

  NetDeviceContainer caller_distributor_net_device_container;
  caller_distributor_net_device_container = caller_distributor_p2p_Helper.Install (caller_distributor_nodes_container);

  NetDeviceContainer distributor_operators_net_device_container_Array[number_of_operator_nodes];
  for(int i=0;i<number_of_operator_nodes;i++)
  {
  distributor_operators_net_device_container_Array[i] = caller_distributor_p2p_Helper.Install (distributor_operators_node_container[i]);
  }
  
  

InternetStackHelper stack;
stack.Install (c);
Ipv4AddressHelper address;
address.SetBase ("10.1.1.0", "255.255.255.0");
Ipv4InterfaceContainer interface=address.Assign (caller_distributor_net_device_container);
Ipv4Address Ipv4Addresses[number_of_operator_nodes+2];
Ipv4Addresses[0]=interface.GetAddress(0);
Ipv4Addresses[1]=interface.GetAddress(1);
Ipv4Address DistributorIpv4Addresses[number_of_operator_nodes];
Ipv4Address OperatorIpv4Addresses[number_of_operator_nodes];


Address NetDeviceAddresses[number_of_operator_nodes];
NetDeviceAddresses[0]=caller_distributor_net_device_container.Get(0)->GetAddress();
NetDeviceAddresses[1]=caller_distributor_net_device_container.Get(1)->GetAddress();
Address DistributorNetDeviceAddresses[number_of_operator_nodes];
Address OperatorNetDeviceAddresses[number_of_operator_nodes];

uint16_t Ports[number_of_operator_nodes+1];
Ports[0]=0;
Ports[1]=1;

char a[9]={'1','0','.','1','.','1','.','0'};
char b[10]={'1','0','.','1','.','1','0','.','0'};

char chars[8]={'2','3','4','5','6','7','8','9'};
char chars2[10]={'0','1','2','3','4','5','6','7','8','9'};

for (int i = 0; i < (number_of_operator_nodes); i++)
{
if(i<8){a[5]=chars[i];address.SetBase (a, "255.255.255.0");}
if(i>7 && i<18){b[6]=chars2[i-8];address.SetBase (b, "255.255.255.0");}
if(i>17 && i<28){b[5]='2';b[6]=chars2[i-18];address.SetBase (b, "255.255.255.0");}
if(i>27 && i<38){b[5]='3';b[6]=chars2[i-28];address.SetBase (b, "255.255.255.0");}
if(i>37 && i<48){b[5]='4';b[6]=chars2[i-38];address.SetBase (b, "255.255.255.0");}
if(i>47 && i<58){b[5]='5';b[6]=chars2[i-48];address.SetBase (b, "255.255.255.0");}
if(i>57 && i<68){b[5]='6';b[6]=chars2[i-58];address.SetBase (b, "255.255.255.0");}
if(i>67 && i<78){b[5]='7';b[6]=chars2[i-68];address.SetBase (b, "255.255.255.0");}
if(i>77 && i<88){b[5]='8';b[6]=chars2[i-78];address.SetBase (b, "255.255.255.0");}
if(i>87 && i<98){b[5]='9';b[6]=chars2[i-88];address.SetBase (b, "255.255.255.0");}
Ipv4InterfaceContainer interfaces = address.Assign (distributor_operators_net_device_container_Array[i]);
OperatorNetDeviceAddresses[i]=distributor_operators_net_device_container_Array[i].Get(1)->GetAddress();
DistributorNetDeviceAddresses[i]=distributor_operators_net_device_container_Array[i].Get(0)->GetAddress();
OperatorIpv4Addresses[i]=interfaces.GetAddress(1);
DistributorIpv4Addresses[i]=interfaces.GetAddress(0);
Ports[i]=i;
}
























Ptr<Socket> CallerSocket=Socket::CreateSocket(c.Get(0),TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
CallerSocket->Bind();
CallerSocket->BindToNetDevice(caller_distributor_net_device_container.Get(0));



Ptr<Socket> DistributorSocket=Socket::CreateSocket(c.Get(1),TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
DistributorSocket->Bind();
DistributorSocket->BindToNetDevice(caller_distributor_net_device_container.Get(1));


Ptr<Socket> OperatorSocketArray[number_of_operator_nodes];
for (int i = 0; i < number_of_operator_nodes; i++)
{
OperatorSocketArray[i]=Socket::CreateSocket(c.Get(i+2),TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
OperatorSocketArray[i]->Bind();
OperatorSocketArray[i]->BindToNetDevice(distributor_operators_net_device_container_Array[i].Get(1));
}

Ptr<Socket> DistributorSocketArray[number_of_operator_nodes];
for (int i = 0; i < number_of_operator_nodes; i++)
{
DistributorSocketArray[i]=Socket::CreateSocket(c.Get(1),TypeId::LookupByName ("ns3::Ipv4RawSocketFactory"));
DistributorSocketArray[i]->Bind();
DistributorSocketArray[i]->BindToNetDevice(distributor_operators_net_device_container_Array[i].Get(0));
}

for (int i = 0; i < number_of_operator_nodes; i++)
{
idleArray[i]=1;
}


DistributorQueue q=DistributorQueue();
DistributorQueue* queue= &q;
AnimationInterface* anim = new AnimationInterface ("anim1.xml");
uint32_t resourceId1 = anim->AddResource ("/root/NS3/ns-allinone-3.26/netanim-3.107/b.png");
uint32_t resourceId2 = anim->AddResource ("/root/NS3/ns-allinone-3.26/netanim-3.107/a.png");
uint32_t resourceId3 = anim->AddResource ("/root/NS3/ns-allinone-3.26/netanim-3.107/d.png");
uint32_t resourceId4 = anim->AddResource ("/root/NS3/ns-allinone-3.26/netanim-3.107/c.png");
//anim.SetBackgroundImage ("/home/eelab/workspace/ns-allinone-3.26/netanim-3.107/a.png", -50, -50, .1, .1, 1.0);


Ptr<CallerApp> capp = CreateObject<CallerApp> ();
capp->Setup (CallerSocket, InetSocketAddress (Ipv4Addresses[1], Ports[1]),
			uint32_t(Mean_InterArrival_Time),uint32_t(2*Mean_InterArrival_Time),
			uint32_t(Mean_Packet_Size),uint32_t(Mean_Packet_Size*3));
c.Get (0)->AddApplication (capp);
capp->SetStartTime (Seconds (1.));
capp->SetStopTime (Seconds (simtime));

Ptr<DistributorApp> dapp = CreateObject<DistributorApp> ();
dapp->Setup (DistributorSocket,DataRate("64kbps"), InetSocketAddress (Ipv4Addresses[0], Ports[0]),
			 queue,0,0);
c.Get (1)->AddApplication (dapp);
dapp->SetStartTime (Seconds (1.));
dapp->SetStopTime (Seconds (simtime));

for (int i = 0; i < number_of_operator_nodes; i++)
{
Ptr<OperatorApp> Oapp=CreateObject<OperatorApp>();
Oapp->Setup (OperatorSocketArray[i], InetSocketAddress (DistributorIpv4Addresses[i], Ports[1]),
	i,anim,resourceId3,resourceId4);
c.Get (i+2)->AddApplication (Oapp);
Oapp->SetStartTime (Seconds (1.));
Oapp->SetStopTime (Seconds (simtime));


Ptr<DistributorApp> Dapp=CreateObject<DistributorApp>();
Dapp->Setup (DistributorSocketArray[i],DataRate("64kbps"), InetSocketAddress (OperatorIpv4Addresses[i], Ports[i+2]),
	 queue,i,1);
c.Get (1)->AddApplication (Dapp);
Dapp->SetStartTime (Seconds (1.));
Dapp->SetStopTime (Seconds (simtime));
}



AsciiTraceHelper ascii;
//caller_distributor_p2p_Helper.EnableAsciiAll (ascii.CreateFileStream ("p2p.tr"));
 
//caller_distributor_p2p_Helper.EnablePcapAll ("simple-point-to-point-olsr");

Ipv4GlobalRoutingHelper Router = Ipv4GlobalRoutingHelper();
Router.PopulateRoutingTables();


anim->SetConstantPosition(caller_node_container.Get(0),0,10);
anim->SetConstantPosition(distributor_node_container.Get(0),10,10);
int sign=1;
for(int i=0;i<number_of_operator_nodes;i++)
{
anim->SetConstantPosition(operator_nodes_container.Get(i),20,10+sign*5*((i+1)/2));
sign=-sign;
}   

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
in.open("Packets15_50_15d.txt");
string buffer;
int totalcalls = 0;
int totalcalls1 = 0;
int calls=0;
int calls2=0;
unsigned long long *DequeueTimes=new unsigned long long[100000];
unsigned long long *EnqueueTimes=new unsigned long long[100000];
unsigned long long *WaitingTimes=new unsigned long long[100000];
unsigned long long *CallTimes=new unsigned long long[100000];
unsigned long long *PacketSizes=new unsigned long long[100000];
while (!(in.eof())){
getline(in, buffer);
if (buffer == "Enqueue")
{
getline(in, buffer);
getline(in, buffer);
getline(in, buffer);
getline(in, buffer);
getline(in, buffer);

std::size_t pos = buffer.find("+");      // position of "live" in str

std::string str3 = buffer.substr(pos + 1);
str3.erase(str3.end() - 7, str3.end());

std::string::size_type sz = 0;

unsigned long long li_dc = std::stoull(str3, &sz, 10);
EnqueueTimes[totalcalls1] = li_dc;
totalcalls1++;
}



if (buffer == "Call Sent")
{
getline(in, buffer);
std::size_t pos = buffer.find("+");      

std::string str3 = buffer.substr(pos + 1);
str3.erase(str3.end() - 7, str3.end());

std::string::size_type sz = 0;

unsigned long long li_dc = std::stoull(str3, &sz, 10);
CallTimes[calls] = li_dc;
calls++;
}



if (buffer == "Operator Connected")
{
getline(in, buffer);
std::size_t pos = buffer.find(":");      

std::string str3 = buffer.substr(pos + 1);
//str3.erase(str3.end() - 7, str3.end());

std::string::size_type sz = 0;

unsigned long long li_dc = std::stoull(str3, &sz, 10);
PacketSizes[calls2] = li_dc;
calls2++;
}



else if (buffer == "Dequeue")
{
getline(in, buffer);
getline(in, buffer);
getline(in, buffer);
getline(in, buffer);

std::size_t pos = buffer.find("+");      

std::string str3 = buffer.substr(pos+1);
str3.erase(str3.end() - 7, str3.end());

std::string::size_type sz = 0;
unsigned long long li_dec = std::stoull(str3, &sz,10);
DequeueTimes[totalcalls] = li_dec;
totalcalls++;
}
}




in.close();
unsigned long long sum=0,sum2=0,sum4=0;
//int lessthanmean = 0;
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
//cout << double(rest) / double(totalcalls) << endl;
for (int i = 1; i < calls; i++)
{
sum2+=(CallTimes[i]-CallTimes[i-1]);
}

for (int i = 0; i < calls2; i++)
{
sum4+=PacketSizes[i];

}
cout<<"Mean Packet Size: "<<double(sum4)/double(calls2)<<endl;
cout<<"Mean InterArrival Time: "<<(sum2/(calls-1))/1e6<<endl;
cout <<"Mean WaitingTime= "<<mean/1e6<< endl;
cout << "Total Calls= " << totalcalls1 << endl;

Simulator::Destroy ();
  return 0;
}

