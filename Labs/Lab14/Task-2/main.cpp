#include <stack>
#include <string>
#include <iostream>
#include <fstream>
using namespace std;

int main() {

	std::stack<int> s;
	ifstream  fin;          // declare input file stream object
        fin.open ("data.txt");  //open data text

	int i;

	//-------Read data file---------

	while (fin >> i) {
	    s.push(i);
	    if (fin.peek() == ',')
         
	}

	//--------Call your sort function here----------

	//-------Print final sorted stack---------
 	for(int i=0; i<s.size(); i++){
        	cout << s.top()<< " ,";
	        s.pop();
	}


}
