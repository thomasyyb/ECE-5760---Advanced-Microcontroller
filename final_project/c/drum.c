///////////////////////////////////////
/// Audio
/// compile with
/// gcc drum.c -o drum -lm -O3 -lrt
/// works up to about drum size 30 or so for NO multiplies case
/// 
///////////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>
#include <sys/types.h>
#include <string.h>
// interprocess comm
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <time.h>
// network stuff
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
// timing analysis
#include <time.h>

#include "address_map_arm_brl4.h"

// fixed point
#define float2fix30(a) ((int)((a)*1073741824)) // 2^30

#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 

/* function prototypes */
void VGA_text (int, int, char *);
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;

// virtual to real address pointers

volatile unsigned int * red_LED_ptr = NULL ;
//volatile unsigned int * res_reg_ptr = NULL ;
//volatile unsigned int * stat_reg_ptr = NULL ;

// audio stuff
volatile unsigned int * audio_base_ptr = NULL ;
volatile unsigned int * audio_fifo_data_ptr = NULL ; //4bytes
volatile unsigned int * audio_left_data_ptr = NULL ; //8bytes
volatile unsigned int * audio_right_data_ptr = NULL ; //12bytes
// phase accumulator
// drum-specific multiply macros simulated by shifts
#define times0pt5(a) ((a)>>1) 
#define times0pt25(a) ((a)>>2) 
#define times2pt0(a) ((a)<<1) 
#define times4pt0(a) ((a)<<2) 
#define times0pt9998(a) ((a)-((a)>>12)) //>>10
#define times0pt9999(a) ((a)-((a)>>13)) //>>10
#define times0pt999(a) ((a)-((a)>>10)) //>>10
#define times_rho(a) (((a)>>5)) //>>2

// drum size paramenters
// drum will FAIL if size is too big
#define drum_size 34
#define drum_middle 17
int copy_size = drum_size*drum_size*4 ;

// fixed pt macros suitable for 32-bit sound
typedef signed int fix28 ;
//multiply two fixed 4:28
#define multfix28(a,b) ((fix28)(((( signed long long)(a))*(( signed long long)(b)))>>28)) 
//#define multfix28(a,b) ((fix28)((( ((short)((a)>>17)) * ((short)((b)>>17)) )))) 
#define float2fix28(a) ((fix28)((a)*268435456.0f)) // 2^28
#define fix2float28(a) ((float)(a)/268435456.0f) 
#define int2fix28(a) ((a)<<28)
#define fix2int28(a) ((a)>>28)
// shift fraction to 32-bit sound
#define fix2audio28(a) (a<<4)
// shift fraction to 16-bit sound
#define fix2audio16(a) (a>>12)

// some fixed point values
#define FOURfix28 0x40000000 
#define SIXTEENTHfix28 0x01000000
#define ONEfix28 0x10000000

// drum state variable arrays
fix28 drum_n[drum_size][drum_size] ;
// drup amp at last time
fix28 drum_n_1[drum_size][drum_size] ;
// drum updata
fix28 new_drum[drum_size][drum_size] ;
fix28 new_drum_temp ;

clock_t note_time ;

// the light weight buss base
void *h2p_lw_virtual_base;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

// /dev/mem file descriptor
int fd;

// shared memory 
key_t mem_key=0xf0;
int shared_mem_id; 
int *shared_ptr;
int audio_time;

// width of gaussian initial condition
float alpha = 64;
 
int main(void)
{
    printf("drum size = %d\n", drum_size);
	// Declare volatile pointers to I/O registers (volatile 	// means that IO load and store instructions will be used 	// to access these pointer locations, 
	// instead of regular memory loads and stores) 

  	// === shared memory =======================
	// with video process
	shared_mem_id = shmget(mem_key, 100, IPC_CREAT | 0666);
	shared_ptr = shmat(shared_mem_id, NULL, 0);
	
	// === need to mmap: =======================
	// FPGA_CHAR_BASE
	// FPGA_ONCHIP_BASE      
	// HW_REGS_BASE        
  
	// === get FPGA addresses ==================
    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
    // get virtual addr that maps to physical
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA LED control 
	red_LED_ptr =(unsigned int *)(h2p_lw_virtual_base +  	 			LEDR_BASE);

	// address to resolution register
	//res_reg_ptr =(unsigned int *)(h2p_lw_virtual_base +  	 	//		resOffset);

	 //addr to vga status
	//stat_reg_ptr = (unsigned int *)(h2p_lw_virtual_base +  	 	//		statusOffset);

	// audio addresses
	// base address is control register
	audio_base_ptr = (unsigned int *)(h2p_lw_virtual_base +  	 			AUDIO_BASE);
	audio_fifo_data_ptr  = audio_base_ptr  + 1 ; // word
	audio_left_data_ptr = audio_base_ptr  + 2 ; // words
	audio_right_data_ptr = audio_base_ptr  + 3 ; // words

	// === get VGA char addr =====================
	// get virtual addr that maps to physical
	vga_char_virtual_base = mmap( NULL, FPGA_CHAR_SPAN, ( 	PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_CHAR_BASE );	
	if( vga_char_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap2() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA LED control 
	vga_char_ptr =(unsigned int *)(vga_char_virtual_base);

	// === get VGA pixel addr ====================
	// get virtual addr that maps to physical
	vga_pixel_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( 	PROT_READ | PROT_WRITE ), MAP_SHARED, fd, 			FPGA_ONCHIP_BASE);	
	if( vga_pixel_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA pixel buffer
	vga_pixel_ptr =(unsigned int *)(vga_pixel_virtual_base);

	// ===========================================
	// drum index
	int i, j, dist2;
		
	// read the LINUX clock (microSec)
	// and set the time so that a not plays soon
	note_time = clock() - 2800000;

    // set some value for timing analysis
    double diff;
    struct timespec start, end;

	// This is for cos/sin evaluation
	float syn_x = 0.0, syn_y = 0.0;
	int num_of_coeff = 1;
	printf("num_of_coeff = %d\n", num_of_coeff);
	float analysis_out_x_coeff[num_of_coeff];
	float analysis_out_y_coeff[num_of_coeff];

	int freq_div_x = 100;
	int freq_div_y = 120;
	printf("freq_div_x = %d\n", freq_div_x);
	printf("freq_div_y = %d\n", freq_div_y);
	float dt_x = 1.0 / freq_div_x;
	float dt_y = 1.0 / freq_div_y;
	float omega_x = 0.0, omega_y = 0.0;
	printf("dt_x = %f, dt_y = %f\n", dt_x, dt_y);
	printf("dt_x = %f, dt_y = %f\n", dt_x, dt_y);

	for(i = num_of_coeff; i > 0; i--) {
		analysis_out_x_coeff[i-1] = (float)i * 0xFFF;
		analysis_out_y_coeff[i-1] = (float)i * 0xFFF;
	}
	int counter = 0;
	while(1){	
		counter = 0;
		// generate a drum simulation
		// load the FIFO until it is full
		while (((*audio_fifo_data_ptr>>24)& 0xff) > 1) {
            // start timer
            clock_gettime(CLOCK_MONOTONIC, &start);

			// do drum time sample
			// equation 2.18 
			// from http://people.ece.cornell.edu/land/courses/ece5760/LABS/s2018/WaveFDsoln.pdf
			// for (i=1; i<drum_size-1; i++){
			// 	for (j=1; j<drum_size-1; j++){
			// 		new_drum_temp = times_rho(drum_n[i-1][j] + drum_n[i+1][j] + drum_n[i][j-1] + drum_n[i][j+1] - times4pt0(drum_n[i][j]));
			// 		new_drum[i][j] = times0pt9999(new_drum_temp + times2pt0(drum_n[i][j]) - times0pt9998(drum_n_1[i][j])) ;
			// 	}
			// }

			// This statement affects the writing time
			printf("%d", counter++);

			// This is for cos/sin evaluation
			syn_x = analysis_out_x_coeff[0] * cos(2.0 * M_PI * omega_x);
			syn_y = analysis_out_y_coeff[0] * sin(2.0 * M_PI * omega_y);
			// printf("syn_x = %f, syn_y = %f\n", syn_x, syn_y );
			omega_x += dt_x;
			omega_y += dt_y;
			if(omega_x > 1.0) {
				omega_x = 0.0;
			}
			if(omega_y > 1.0) {
				omega_y = 0.0;
			}
			// printf("dt_x = %f, dt_y = %f\n", dt_x, dt_y);

            // stop timer
            clock_gettime(CLOCK_MONOTONIC, &end);

			// diff = (end.tv_sec - start.tv_sec) + ((double)(end.tv_nsec - start.tv_nsec))*1e-9;
            // printf("time = %lf\n", diff);
			
			// update the state arrays
			// memcpy((void*)drum_n_1, (void*)drum_n, copy_size);
			// memcpy((void*)drum_n, (void*)new_drum, copy_size);
			
			// send time sample to the audio FiFOs
			*audio_left_data_ptr = syn_y;
			*audio_right_data_ptr = syn_x;
			// *audio_left_data_ptr = fix2audio16(drum_n[drum_middle][drum_middle]);
			// *audio_right_data_ptr = fix2audio16(drum_n[drum_middle][drum_middle]);

            // // stop timer
            // clock_gettime(CLOCK_MONOTONIC, &end);

			// shared memory for possible graphics
			//*(shared_ptr+1) = fix2audio28(drum_n[drum_middle][drum_middle]);
			// share the audio sample time with video process
			//audio_time++ ;
			//*shared_ptr = audio_time/48000 ;
		} // end while (((*audio

        // printf("\n");
		
		if (clock()- note_time > 3000000) {
            // check out the time interval
            diff = (end.tv_sec - start.tv_sec) + ((double)(end.tv_nsec - start.tv_nsec))*1e-9;
            printf("time = %lf\n", diff);
			// strike the drum
			// this is a set up for zero initial displacment with
			// the strike as a velocity
			for (i=1; i<drum_size-1; i++){
				for (j=1; j<drum_size-1; j++){
					dist2 = (i-drum_middle)*(i-drum_middle)+(j-drum_middle)*(j-drum_middle);
					drum_n_1[i][j] = float2fix28(0.01*exp(-(float)dist2/alpha));
					drum_n[i][j] = 0 ;
				}
			}
			
			// read LINUX time for the next drum strike
			note_time = clock();
			
		};

	} // end while(1)
} // end main
