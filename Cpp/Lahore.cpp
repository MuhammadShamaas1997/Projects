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
	
	std::string target_string("Block");
	size_t substring_length = 0;
	substring_length = line.find(target_string);
    if ((substring_length = line.find(target_string)) != std::string::npos) {
     	//std::cout << "Length of matched substring = " << substring_length << std::endl;
        cout<<line<<endl;
	}
}
}
