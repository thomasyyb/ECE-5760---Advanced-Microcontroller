#include <stdio.h> 
#include <pthread.h>
#include <stdlib.h> 

char input_buffer[64];

pthread_mutex_t enter_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t print_lock = PTHREAD_MUTEX_INITIALIZER;
// pthread conditions 
pthread_cond_t enter_cond;
pthread_cond_t print_cond; 

void * read() {
	while(1){
		pthread_mutex_lock(&print_lock);
		pthread_cond_wait(&print_cond, &print_lock);
		printf("Enter command: ");
		scanf("%s", input_buffer);
		
		pthread_mutex_unlock(&print_lock);
		pthread_cond_signal(&enter_cond); 
	}

}


// I think a parter to bounce the signals 
void *write() {
	sleep(1);  // cond would be sent before pthread_cond_wait
	pthread_cond_signal(&print_cond); 
	
	while(1) {
		// print depending on the enter value "input buffer"
		pthread_mutex_lock(&enter_lock);
		pthread_cond_wait(&enter_cond, &enter_lock); 
	
		// do command-dependant functions	
		if(!strcmp(input_buffer, "p")) {
			printf("You paused me\n");
		} 		

		pthread_mutex_unlock(&enter_lock);
		pthread_cond_signal(&print_cond);  

	}
}


int main() {
	
// thread handles 
	pthread_t thread_r, thread_w;

	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

// create threads
	pthread_create(&thread_r, &attr, read, NULL);
	pthread_create(&thread_w, &attr, write, NULL);

	// join blocks the main code indefinitly since read and write run forever
	pthread_join(thread_r, NULL);
	pthread_join(thread_w, NULL);
	return 0;


}
