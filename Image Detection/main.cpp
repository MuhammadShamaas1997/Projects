#include <iostream>
#include <fstream>
#include <string>
using namespace std;
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
char S;
int i=0;
int main(int argc, char** argv) {
	ifstream IN("PIC.bmp");
	ofstream OUT;
	OUT.open("LOG.txt");
	for(int j=0;j<54;j++){
		IN>>S;
	}
	while(!IN.eof()){
	//for (int k=0;k<2;k++){
		IN>>S;
		OUT<<S;i++;
		if(i==240){
		OUT<<endl;i=0;
		}
	}
	OUT.close();
	
	return 0;
}
