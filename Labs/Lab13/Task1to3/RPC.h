#include <iostream>

using namespace std;

class Tool {
	// your code here
};

class Rock : public Tool {
	public:
	Rock(int b);
	bool fight(Tool *t);
	int getStrength();
};