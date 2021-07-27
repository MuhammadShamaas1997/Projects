#include <iostream>
#include <fstream>
#include <string>
using namespace std;
/* run this program using the console pauser or add your own getch, system("pause") or input loop */

int i=0;


int main(int argc, char** argv) {
string S;
string * words=new string[100];	
	ifstream IN("A.txt");
	//ofstream OUT;
	//OUT.open("Ordered.txt");
	cout<<"aaaa"<<endl;
	if(IN.is_open()){
	while(!IN.eof()){
		getline(IN,S);

		cout<<S<<endl;
		//OUT<<S;
		words[i]=S;
		i++;
	}}else{cout<<"aaaa"<<endl;
	}
	
	for (int i=1;i<15;i++){
		for(int j=0;j<10000;j++){
	cout<<words[j].length()<<" "<<i<<" "<<(words[j].length()==i)<<endl;
			if(words[j].length()==i){
	//			OUT<<words[j]<<endl;
			}
		}
	}
	
	//OUT.close();
	
	return 0;
}
