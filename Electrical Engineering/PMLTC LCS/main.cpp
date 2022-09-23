#include <iostream>
#include <fstream>
#include <string>
using namespace std;

struct Device
{
	Device()
	{
		name="";
		next=NULL;
	}
	Device(string n)
	{
		name=n;
		next=NULL;
	}
	Device(string n, Device * m)
	{
		name=n;
		next=m;
	}
	string name;
	Device *next;
};

class DeviceList
{
	public:
	DeviceList(string n)
	{
		name=n;
		firstDevice=NULL;
	}
	DeviceList (string n, Device *m)
	{
		name=n;
		firstDevice=m;
	}
	void addDevice(string n)
	{
		if (firstDevice)
		{
			Device * temp=firstDevice;
			while (temp->next)
			{
				temp=temp->next;
			}
			temp->next=new Device(n);
		}
		else
		{
			firstDevice=new Device(n);
		}
	}

	string name;
	Device *firstDevice;

};

class PanelList;

class Panel
{
public:
	Panel();
	//~Panel();
	Panel(string n, string s, string l, DeviceList *connected_Devices);
	Panel(string n, string s, string l);
	Panel *next;

	void addPanel(Panel *p);
	void print();

	string name;
	string system;
	string location;
	DeviceList *devicesList;
	PanelList *panelsList;
	
};

class PanelList
{
	public:
	PanelList(string n)
	{
		name=n;
		firstPanel=NULL;
	}
	PanelList (string n, Panel *p)
	{
		name=n;
		firstPanel=p;
	}
	void plusPanel(Panel *p)
	{
		if (firstPanel)
		{
			//cout<<"PanelListnotempty "<<firstPanel<<endl;
			Panel * temp=firstPanel;
			while (temp->next)
			{
				temp=temp->next;
			}
			temp->next=p;
			p->next=NULL;
		
		}
		else
		{
			//cout<<"Empty Panel List"<<endl;
			firstPanel=p;
			p->next=NULL;
		}
		//cout<<"Added "<<p->name<<endl;
	}
	void print()
	{
		if (firstPanel)
		{
			Panel * temp=firstPanel;
			cout<<" "<<(temp->name)<<" ";
			while(temp->next)
			{
				temp=temp->next;
				cout<<" "<<(temp->name)<<" ";
			}
		}
		cout<<endl;cout<<endl;
	}

	string name;
	Panel *firstPanel;
};

Panel::Panel(string n, string s, string l, DeviceList *connected_Devices){
	name=n;
	system=s;
	location=l;
	devicesList=connected_Devices;
	panelsList=new PanelList("");
	panelsList->firstPanel=NULL;
}

Panel::Panel(string n, string s, string l){
	name=n;
	system=s;
	location=l;
	devicesList=NULL;
	panelsList=new PanelList("");
	panelsList->firstPanel=NULL;
}

void Panel::addPanel(Panel *p)
{
	if(p)
	{
	//cout<<"Adding "<<p->name<<" to "<<name<<endl;
	}
	else{cout<<"fail1"<<endl;}
	if(panelsList)
		{
			//cout<<"Adding "<<p->name<<" to "<<name<<endl;
			panelsList->plusPanel(new Panel(p->name, p->system, p->location));
		}
	else{cout<<"fail2"<<endl;}
	
}

void Panel::print()
{
		cout<<endl;cout<<endl;
		cout<<"PanelName: "<<name<<endl;
		cout<<"System: "<<system<<endl;
		cout<<"Location: "<<location<<endl;
		cout<<"Connected Panels: ";
		panelsList->print();
		cout<<endl;cout<<endl;
}


int main(int argc, char** argv) {
	
	DeviceList *S2_LRI1A_Devices=new DeviceList("S2_LRI1A_Devices");
	S2_LRI1A_Devices->addDevice("DFU420_A201");
	S2_LRI1A_Devices->addDevice("DFU420_A202");

	DeviceList *S2_LRI1B_Devices=new DeviceList("S2_LRI1B_Devices");
	S2_LRI1B_Devices->addDevice("DFU420_A201");
	S2_LRI1B_Devices->addDevice("DFU420_A202");

	DeviceList *S2_LRI2A_Devices=new DeviceList("S2_LRI2A_Devices");
	S2_LRI2A_Devices->addDevice("DFU420_A201");
	S2_LRI2A_Devices->addDevice("DFU420_A202");

	DeviceList *S2_LRI2B_Devices=new DeviceList("S2_LRI2B_Devices");
	S2_LRI2B_Devices->addDevice("DFU420_A201");
	S2_LRI2B_Devices->addDevice("DFU420_A202");


	Panel *S2_LRI1A=new Panel("No. 1 35kV Reactor Interface A","","500 kV No. 1 Relay House", S2_LRI1A_Devices);
	Panel *S2_LRI1B=new Panel("No. 1 35kV Reactor Interface B","","500 kV No. 1 Relay House", S2_LRI1B_Devices);
	Panel *S2_LRI2A=new Panel("No. 2 35kV Reactor Interface A","","500 kV No. 1 Relay House", S2_LRI2A_Devices);
	Panel *S2_LRI2B=new Panel("No. 2 35kV Reactor Interface B","","500 kV No. 1 Relay House", S2_LRI2B_Devices);
	
	S2_LRI1A->addPanel(S2_LRI1B);
	S2_LRI1B->addPanel(S2_LRI1A);
	S2_LRI2A->addPanel(S2_LRI2B);
	S2_LRI2B->addPanel(S2_LRI2A);

	S2_LRI1A->print();
	S2_LRI1B->print();
	S2_LRI2A->print();
	S2_LRI2B->print();

	return 0;
}
