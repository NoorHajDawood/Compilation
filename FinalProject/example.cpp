#include "ArrayUtils.hpp"
using namespace std;
int main()
{
	int i, fAvg;
	Array fib;
	fib[0] = 0;
	fib[1] = 1;
	i = 2;
	cout << 0 << ", " << 0 << endl;
	cout << 1 << ", " << 1 << endl;
	while(i < 16)
	{
		fib[i] = fib[(i - 2)] + fib[(i - 1)];
		cout << i << ", " << fib[i] << endl;
		i = i + 1;
	};
	cout << Array::dotProduct(fib, Array{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}) << endl;
	fAvg = Array::dotProduct(fib, Array{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}) / 16;
	cout << fAvg << endl;
	i = 2;
	while(i < 16)
	{
		if(fib[i] > fAvg)
		{
			cout << i << ", " << fib[i] << endl;
		};
		i = i + 1;
	};
}
