///////////////////////////////////////
/// 640x480 version! 16-bit color
/// This code will segfault the original
/// DE1 computer
/// compile with
/// gcc graphics_video_16bit.c -o gr -O2 -lm
///
///////////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include <math.h>
#include <pthread.h>
//#include "address_map_arm_brl4.h"

// // video display
// #define SDRAM_BASE            0xC0000000
// #define SDRAM_END             0xC3FFFFFF
// #define SDRAM_SPAN			  0x04000000
// // characters
// #define FPGA_CHAR_BASE        0xC9000000 
// #define FPGA_CHAR_END         0xC9001FFF
// #define FPGA_CHAR_SPAN        0x00002000
// /* Cyclone V FPGA devices */
// #define HW_REGS_BASE          0xff200000
// //#define HW_REGS_SPAN        0x00200000 
// #define HW_REGS_SPAN          0x00005000

// PIO
#define PIO_BASE              0xff200000
#define PIO_SPAN			  0x10

// #define PIO_D_OFFSET          0x10
#define PIO_X_OFFSET          0x00
#define PIO_Y_OFFSET 		  0x10
#define PIO_SCALE_OFFSET	  0x20
// #define PIO_WR_ADDR_OFFSET    0x20
// #define PIO_READY_OFFSET      0x30
// #define PIO_DONE_OFFSET       0x40
// #define PIO_RESET_OFFSET      0x50


// the light weight bus base
void *h2p_lw_virtual_base;

// the heavy weight bus base for the PIO
void *h2p_pio_virtual_base;
// volatile unsigned int * pio_d_read_ptr = NULL ;
volatile unsigned int * pio_x_read_ptr = NULL;
volatile unsigned int * pio_y_read_ptr = NULL;
volatile unsigned int * pio_scale_read_ptr = NULL;
// volatile unsigned int * pio_wr_addr_read_ptr = NULL ;
// volatile unsigned int * pio_ready_read_ptr = NULL ;
// volatile unsigned int * pio_done_read_ptr = NULL ;
// volatile unsigned int * pio_reset_read_ptr = NULL ;


// /dev/mem file id
int fd;

// measure time
struct timeval t1, t2;
double elapsedTime;


int main(void)
{
  	
	// === need to mmap: =======================
	// FPGA_CHAR_BASE
	// FPGA_ONCHIP_BASE      
	// HW_REGS_BASE    
	// PIO_BASE
  
	// === get FPGA addresses ==================
    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
    // get virtual addr that maps to physical
	h2p_lw_virtual_base = mmap( NULL, PIO_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, PIO_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}

	// === get PIO addr ====================
	// get virtual addr that maps to physical
	// h2p_pio_virtual_base = mmap( NULL, PIO_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, PIO_BASE);	
	// if( h2p_pio_virtual_base == MAP_FAILED ) {
	// 	printf( "ERROR: mmap4() failed...\n" );
	// 	close( fd );
	// 	return(1);
	// }
    
    // Get the address that maps to the FPGA pixel buffer
	pio_x_read_ptr = (unsigned int*)(h2p_lw_virtual_base+PIO_X_OFFSET);
	pio_y_read_ptr = (unsigned int*)(h2p_lw_virtual_base+PIO_Y_OFFSET);
	pio_scale_read_ptr = (unsigned int*)(h2p_lw_virtual_base+PIO_SCALE_OFFSET);

	unsigned int cx_uint, cy_uint;
	int cx_int, cy_int;
	int cx_abs, cy_abs;
	int sign_bit_x, sign_bit_y;
	unsigned int scale;

	double center_x, center_y;
	double top, bottom, left, right;
	double divisor;
	
	while(1) 
	{
		cx_uint = *pio_x_read_ptr;
		cy_uint = *pio_y_read_ptr;
		scale   = *pio_scale_read_ptr;

		// printf("\nnot converted > cr: 0x%x, ci: 0x%x \n", cx_uint, cy_uint);

		cx_int = (int)(cx_uint << 5);
		cy_int = (int)(cy_uint << 5);

		// printf("left shifted  > cr: 0x%x, ci: 0x%x \n", cx_int, cy_int);

		cx_int = cx_int >> 5;
		cy_int = cy_int >> 5;
		// cx_int = cx_int >> 5;
		// cy_int = cy_int >> 5;

		// printf("shifted back  > cr: 0x%x, ci: 0x%x \n", cx_int, cy_int);

		center_x = cx_int / pow(2, 23); 
		center_y = -1 * cy_int / pow(2, 23);  // It seems inverted...I don't know why

		printf("\nZoom in level: %d \n", scale);
		printf("Center: (%f, %f) \n", center_x, center_y);

		if(scale!=0)
			divisor = (double)pow(2, scale);
		else
			divisor = 1;

		top    = center_y + (240.0/divisor) * 0.00625;
		bottom = center_y - (240.0/divisor) * 0.00625;
		left   = center_x - (320.0/divisor) * 0.00625;
		right  = center_x + (320.0/divisor) * 0.00625;

		printf("Top: %8lf   Bottom: %8lf \n", top, bottom);
		printf("Left:%8lf   Right:  %8lf \n", left, right);

		// sign_bit_x = (cx_int > 0) ? 0 : 1 ; 
		// sign_bit_y = (cy_int > 0) ? 0 : 1 ;  // It seems inverted...I don't know why

		// printf("sign bits     > cr: %d,   ci: %d \n", sign_bit_x, sign_bit_y);

		// cx_abs = (unsigned int)cx_int; 
		// cy_abs = (unsigned int)cy_int;

		// printf("fixed  > cr: 0x%x, ci: 0x%x \n", cx_abs, cy_abs);

		// center_x = cx_abs / pow(2, 23); 
		// center_y = cy_abs / pow(2, 23); 

		// if (sign_bit_x) {
		// 	center_x = (-1) * cx_abs / pow(2, 23); 
		// } else {
		// 	center_x = cx_abs / pow(2, 23); 
		// }

		// if (sign_bit_y) {
		// 	center_y = (-1) * cy_abs / pow(2, 23); 
		// } else {
		// 	center_y = cy_abs / pow(2, 23); 
		// }

		// printf("converted > cr: %f, ci: %f \n", center_x, center_y);

		usleep(10000);

		// center_x = *pio_x_read_ptr;
		// center_y = *pio_y_read_ptr;
		// double center_y = 0;
		// center_x = ((float)*pio_x_read_ptr) / pow(2, 23);
		// center_y = ((float)*pio_y_read_ptr) / pow(2, 23);
	} // end while(1)
} // end main


