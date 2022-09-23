#include "RPC.cpp"

int main() {
	Scissors *s = new Scissors(5);
	Paper *p = new Paper(7);
	Rock *r = new Rock(9);

	cout << s->fight(p) << ' ' << p->fight(s) << endl;
	cout << p->fight(r) << ' ' << r->fight(p) << endl;
	cout << r->fight(r) << ' ' << r->fight(r) << endl;
}
