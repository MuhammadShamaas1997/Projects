#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

using namespace std;

int main(){

std::string line;
std::ifstream infile("Sites.txt");
while (std::getline(infile, line))
{
    std::istringstream iss(line);
	
	std::string target_string1("https://www.facebook.com/groups/");
	size_t substring_length1 = 0;
	substring_length1 = line.find(target_string1);
	if ((substring_length1 = line.find(target_string1)) != std::string::npos) {
        cout<<line<<endl;
	}
	
}
}
