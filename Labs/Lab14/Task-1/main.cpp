#include "merge.h"

/* Program to test  functions */
int main()
{
    int arrint[] = {12, 11, 13, 5, 6, 7};
	double arrdouble[] = {12.44, 11.55, 13.5, 5.8, 6.2, 733.3};
	string arrstring[] = {"12", "11", "13", "qq5", "aasda", "azs", "gzzaass"};
	char arrchar[] = { 'H', 'e', 'l', 'l', 'o', '\0' };
	
	// -------------Calculate the size of the input array---------
    int arr_size = sizeof(arrint)/sizeof(arrint[0]);
	
 //--------------------Int array--------------------
    cout<< "Given int array is \n";
    printArray(arrint, arr_size);
 
    mergeSort(arrint, 0, arr_size - 1);
 
    cout<< "\nSorted array is \n";
    printArray(arrint, arr_size);
	/*
	
	//--------------------Double array--------------------
	cout<< "Given double array is \n";
    printArray(arrdouble, arr_size);
 
    mergeSort(arrdouble, 0, arr_size - 1);
 
    cout<< "\nSorted array is \n";
    printArray(arrdouble, arr_size);
	
	//--------------------Char array--------------------
	cout<< "Given char array is \n";
    printArray(arrchar, arr_size);
 
    mergeSort(arrchar, 0, arr_size - 1);
 
    cout<< "\nSorted array is \n";
    printArray(arrchar, arr_size);
	
	//--------------------String array--------------------
	cout<< "Given char array is \n";
    printArray(arrstring, arr_size);
 
    mergeSort(arrstring, 0, arr_size - 1);
 
    cout<< "\nSorted array is \n";
    printArray(arrstring, arr_size); 
	
	*/
    return 0;
}