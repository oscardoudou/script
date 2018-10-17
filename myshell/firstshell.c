#include <stdio.h>
#include <stdlib.h>

char *fgets_wrapper(char* buffer, size_t buflen, FILE *fp){
	if(fgets(buffer, buflen, fp) != 0)
	{
		size_t len = strlen(buffer);
		//terminate scan when encounter enter
		if(len > 0 && buffer[len-1] == '\n')
			buffer[len-1] = '\0';
		return buffer;
	}
	return 0;
}

int main(){
	int child_pid;
	char cmd[1024];
	// fills the first 1024 bytes of the memory area pointed to by cmd with the constant byte 0
	memset(cmd, 0, 1024);
	fprintf(stderr, "yichi$ ");
	while(fgets_wrapper(cmd,1024,stdin)){
		//only one special command: exit
		if(strcmp("exit", cmd) == 0)
			exit(1);
		//otherwise, consider user want me to execute another(external) program
		child_pid = fork();
		if(child_pid == 0)
			execvp(cmd, NULL);
		//clean buffer, start receiving input
		else{
			fprintf(stderr, "yichi$ ");
			memset(cmd, 0, 1024);
		}
	}
	return 0;
}