#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

using namespace std;

int main(){

std::string line;
std::ifstream infile("Babar Block Garden Town Lahore _ Facebook.html");
while (std::getline(infile, line))
{
    std::istringstream iss(line);
	
	std::string target_string1("Lahore");
	size_t substring_length1 = 0;
	substring_length1 = line.find(target_string1);
	if ((substring_length1 = line.find(target_string1)) != std::string::npos) {
        cout<<line<<endl;
	}
	
}
}
