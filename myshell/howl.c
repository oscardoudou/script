#include <stdio.h>
#include <stdlib.h>

int main(){
	fork();
	printf("wow\n");
	fork();
	printf("miao\n");
	fork();
	printf("wang\n");
	return 0;
}