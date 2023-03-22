#include <stdio.h>
#include <stdlib.h>

void vecToScl(int* arr, int size, int val) {
	for(int i=0; i<size; i++) {
		arr[i] = val;
	}
}

void vecToVec(int* arr, int size, int* arr2) {
	for(int i=0; i<size; i++) {
		arr[i] = arr2[i];
	}
}

int* vectorsIndex(int* arr, int size, int* arr2) {
	int* tmp = malloc(sizeof(int)*size);
	for(int i=0; i<size; i++) {
		tmp[i] = arr[arr2[i]];
	}
	return tmp;
}

int* vecOpScl(int* arr, int size, int scl, char op) {
	int* tmp = malloc(sizeof(int)*size);
	switch(op) {
		case '+':
			for(int i=0; i<size; i++) tmp[i] = arr[i] + scl;
			break;
		case '-':
			for(int i=0; i<size; i++) tmp[i] = arr[i] - scl;
			break;
		case '*':
			for(int i=0; i<size; i++) tmp[i] = arr[i] * scl;
			break;
		case '/':
			for(int i=0; i<size; i++) tmp[i] = arr[i] / scl;
			break;
		}
	return tmp;
}

int* vecOpVec(int* arr, int size, int* arr2, char op) {
	int* tmp = malloc(sizeof(int)*size);
	switch(op) {
		case '+':
			for(int i=0; i<size; i++) tmp[i] = arr[i] + arr2[i];
			break;
		case '-':
			for(int i=0; i<size; i++) tmp[i] = arr[i] - arr2[i];
			break;
		case '*':
			for(int i=0; i<size; i++) tmp[i] = arr[i] * arr2[i];
			break;
		case '/':
			for(int i=0; i<size; i++) tmp[i] = arr[i] / arr2[i];
			break;
		}
	return tmp;
}

int vecDotVec(int* arr, int size, int* arr2) {
	int sum = 0;
	for(int i=0; i<size; i++) { sum += arr[i] * arr2[i]; }
	return sum;
}

void printVec(int* arr, int size) {
	printf("[");
	for(int i=0; i<size-1; i++) {
		printf("%d, ", arr[i]);
	}
	printf("%d", arr[size-1]);
	printf("]\n");
}

int main(void) {

	int iter_idx=0;

	int x;
	int y;
	int i;
	int v1[6];
	int v2[6];
	int v3[6];
	x=2;
	vecToScl(v1, 6, 2*x);
	printVec(v1, 6);
	int tmpVec0[] = {1,1,2,2,3,3};
	vecToVec(v2, 6, tmpVec0);
	printf("%d\n", 	vecDotVec(v1, 6, v2));
	y=v2[4];
	printf("%d\n", y);
	i=0;
	for(iter_idx=0; iter_idx<y; iter_idx++) {
	v1[i]=i;
	i=i+1;
	}
	int* tempVec1 = vectorsIndex(v2,6,v1);
	printVec(tempVec1, 6);
	int tmpVec2[] = {5,4,3,2,1,0};
	int* tempVec3 = vectorsIndex(v1,6,tmpVec2);
	int* tempVec4 = vectorsIndex(v2,6,tempVec3);
	printVec(tempVec4, 6);
	int* tempVec5 = vecOpVec(v1, 6, v2, '+');
	vecToVec(v3, 6, tempVec5);
	printVec(v3, 6);
	int tmpVec6[] = {2,1,0,2,2,0};
	printf("%d\n", v2[(	vecDotVec(tmpVec6, 6, v3)/10)]);
	int a[3];
	int tmpVec7[] = {10,0,20};
	vecToVec(a, 3, tmpVec7);
	i=0;
	for(iter_idx=0; iter_idx<3; iter_idx++) {
	int tmpVec8[] = {1,0,0};
	if(	vecDotVec(a, 3, tmpVec8)) {
	printf("%d\n", i);
	printVec(a, 3);
	int tmpVec9[] = {2,0,1};
	int* tempVec10 = vectorsIndex(a,3,tmpVec9);
	vecToVec(a, 3, tempVec10);
	}
	i=i+1;
	}
	int z[4];
	vecToScl(z, 4, 10);
	int tmpVec11[] = {2,4,6,8};
	int* tempVec12 = vecOpVec(z, 4, tmpVec11, '+');
	int* tempVec13 = vecOpScl(tempVec12, 4, 2, '/');
	vecToVec(z, 4, tempVec13);
	printVec(z, 4);
	int* tempVec14 = vecOpScl(z, 4, 3, '-');
	int tmpVec15[] = {2,3,4,5};
	int* tempVec16 = vecOpVec(tempVec14, 4, tmpVec15, '+');
	vecToVec(z, 4, tempVec16);
	printVec(z, 4);
	int tmpVec17[] = {1,1,1,1};
	printf("%d\n", 	vecDotVec(z, 4, tmpVec17));
	return 0;
}