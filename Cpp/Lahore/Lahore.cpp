#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

using namespace std;

int main(){

std::string line;
std::ifstream infile("ListOfLahore.txt");
while (std::getline(infile, line))
{
    std::istringstream iss(line);
	
	std::string target_string1("Block");
	std::string target_string2("Town");
	std::string target_string3("Society");
	std::string target_string4("Colony");
	size_t substring_length1 = 0;
	size_t substring_length2 = 0;
	size_t substring_length3 = 0;
	size_t substring_length4 = 0;
	substring_length1 = line.find(target_string1);
	substring_length2 = line.find(target_string2);
	substring_length3 = line.find(target_string3);
	substring_length4 = line.find(target_string4);
    if ((substring_length1 = line.find(target_string1)) != std::string::npos) {
        //cout<<line<<endl;
	}
	else if ((substring_length2 = line.find(target_string2)) != std::string::npos) {
        //cout<<line<<endl;
	}
	else if ((substring_length3 = line.find(target_string3)) != std::string::npos) {
        //cout<<line<<endl;
	}
	else if ((substring_length4 = line.find(target_string4)) != std::string::npos) {
        //cout<<line<<endl;
	}
	else {
		cout<<line<<endl;
	}
}
}
