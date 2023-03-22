#include "ArrayUtils.hpp"
using namespace std;
int main()
{
	int x, y, z;
	x = 5;
	y = x / 5;
	z = y * 3 / x;
	cout << x << ", " << y - 2 << ", " << z * 3 << endl;
	Array a, b, c;
	a = 5;
	a[10] = -13;
	c = Array{0, 3, 9, 111};
	b = Array{4, 6};
	cout << a + b + c << ", " << a << ", " << b << ", " << c << endl;
}
