#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
	int x;
	int y;
	int j;
	int v1[6];
	int v2[6];
	int v3[6];
	int e0 = 2;
	x = e0;
	int e1 = 2;
	int e2 = e1 * x;
	for(int i = 0; i < 6; i++){
		v1[i] = e2;
	}
	printf("[");
	for(int i = 0; i < 6 - 1; i++){
		printf("%d,",v1[i]);
	}
	printf("%d", v1[6 - 1]);
	printf("]\n");
	int e3[] = {1,1,2,2,3,3};
	memcpy(v2, e3, sizeof(v2));
	int e4 = 0;
	for(int i = 0; i < 6; i++){
		e4 += v1[i] * v2[i];
	}
	printf("%d\n", e4);
	int e5 = 4;
	int e6 = 0;
	if(e5 >= 0 && e5 < 6){
		e6 = v2[e5];
	}
	else{fprintf(stderr, "index out of range"); exit(0);}
	y = e6;
	printf("%d\n", y);
	int e7 = 0;
	j = e7;
	for(int i = 0; i < y; i++){
	int e8 = 0;
	if(j >= 0 && j < 6){
		e8 = v1[j];
	}
	else{fprintf(stderr, "index out of range"); exit(0);}
	e8 = j;
	int e9 = 1;
	int e10 = j + e9;
	j = e10;
	}
	int e11[6] = {0};
	for(int i = 0; i < 6; i++){
		if(v1[i] >= 0 && v1[i] < 6){
			e11[i] = v2[v1[i]];
		}
		else{fprintf(stderr, "index out of range"); exit(0);}
	}
	printf("[");
	for(int i = 0; i < 6 - 1; i++){
		printf("%d,",e11[i]);
	}
	printf("%d", e11[6 - 1]);
	printf("]\n");
	int e12[6] = {0};
	for(int i = 0; i < 6; i++){
		if(v1[i] >= 0 && v1[i] < 6){
			e12[i] = v2[v1[i]];
		}
		else{fprintf(stderr, "index out of range"); exit(0);}
	}
	int e13[] = {5,4,3,2,1,0};
	int e14[6] = {0};
	for(int i = 0; i < 6; i++){
		if(e13[i] >= 0 && e13[i] < 6){
			e14[i] = e12[e13[i]];
		}
		else{fprintf(stderr, "index out of range"); exit(0);}
	}
	printf("[");
	for(int i = 0; i < 6 - 1; i++){
		printf("%d,",e14[i]);
	}
	printf("%d", e14[6 - 1]);
	printf("]\n");
	int e15[6];
	for(int i = 0; i < 6; i++){
		e15[i] = v1[i] + v2[i];
	}
	memcpy(v3, e15, sizeof(v3));
	printf("[");
	for(int i = 0; i < 6 - 1; i++){
		printf("%d,",v3[i]);
	}
	printf("%d", v3[6 - 1]);
	printf("]\n");
	int e16[] = {2,1,0,2,2,0};
	int e17 = 0;
	for(int i = 0; i < 6; i++){
		e17 += e16[i] * v3[i];
	}
	int e18 = 10;
	int e19 = e17 / e18;
	int e20 = 0;
	if(e19 >= 0 && e19 < 6){
		e20 = v2[e19];
	}
	else{fprintf(stderr, "index out of range"); exit(0);}
	printf("%d\n", e20);
	int a[3];
	int e21[] = {10,0,20};
	memcpy(a, e21, sizeof(a));
	int e22 = 0;
	j = e22;
	int e23 = 3;
	for(int i = 0; i < e23; i++){
	int e24[] = {1,0,0};
	int e25 = 0;
	for(int i = 0; i < 3; i++){
		e25 += a[i] * e24[i];
	}
	if(e25){
	printf("%d", j);
	printf(": ");
	printf("[");
	for(int i = 0; i < 3 - 1; i++){
		printf("%d,",a[i]);
	}
	printf("%d", a[3 - 1]);
	printf("]\n");
	int e26[] = {2,0,1};
	int e27[3] = {0};
	for(int i = 0; i < 3; i++){
		if(e26[i] >= 0 && e26[i] < 3){
			e27[i] = a[e26[i]];
		}
		else{fprintf(stderr, "index out of range"); exit(0);}
	}
	memcpy(a, e27, sizeof(a));
	}
	int e28 = 1;
	int e29 = j + e28;
	j = e29;
	}
	int z[4];
	int e30 = 10;
	for(int i = 0; i < 4; i++){
		z[i] = e30;
	}
	int e31[] = {2,4,6,8};
	int e32[4];
	for(int i = 0; i < 4; i++){
		e32[i] = z[i] + e31[i];
	}
	int e33 = 2;
	int e34[4];
	for(int i = 0; i < 4; i++){
		e34[i] = e32[i] / e33;
	}
	memcpy(z, e34, sizeof(z));
	int e35 = 3;
	int e36[4];
	for(int i = 0; i < 4; i++){
		e36[i] = z[i] - e35;
	}
	int e37[] = {2,3,4,5};
	int e38[4];
	for(int i = 0; i < 4; i++){
		e38[i] = e36[i] + e37[i];
	}
	memcpy(z, e38, sizeof(z));
	printf("[");
	for(int i = 0; i < 4 - 1; i++){
		printf("%d,",z[i]);
	}
	printf("%d", z[4 - 1]);
	printf("]\n");
	int e39[] = {1,1,1,1};
	int e40 = 0;
	for(int i = 0; i < 4; i++){
		e40 += z[i] * e39[i];
	}
	printf("%d\n", e40);

	return 0;
}