// File:  main.cpp
// Test the IntArray class
#include <iostream>
#include "IntArray.cpp"
using namespace std;

int main() {
	IntArray myIntArray(100);

	myIntArray[99] = 10;
	cout << "After \"myIntArray[99] = 10;\": " << endl;
	cout << "myIntArray[99] = " << myIntArray[99] << endl;

	myIntArray[0] = 100;
	cout << "After \"myIntArray[0] = 100;\": " << endl;
	cout << "myIntArray[0] = " << myIntArray[0] << endl;

	cout << "Attempting \"myIntArray[-1] = 100;\": " << endl;
	myIntArray[-1] = 100;
	
	cout << "Attempting \"myIntArray[100] = 100;\": " << endl;
	myIntArray[100] = 100;

} // end main