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
#include <malloc.h>
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
#define PIO_BASE               0xC0000000
#define PIO_SPAN			   0x10
#define PIO_D_OFFSET           0x10
#define PIO_WR_ADDR_OFFSET     0x20
#define PIO_READY_OFFSET       0x30
#define PIO_DONE_OFFSET        0x40
#define PIO_RESET_OFFSET       0x50
#define PIO_HEIGHT_OFFSET      0x60
#define PIO_WR_EN_OFFSET       0x70
#define PIO_STRING_INIT_OFFSET 0x80

#define WIDTH		173
// #define HEIGHT		41
#define WIDTH_MID	(WIDTH >> 1)
// #define HEIGHT_MID	(HEIGHT >> 1)


// the light weight bus base
void *h2p_lw_virtual_base;

// the heavy weight bus base for the PIO
void *h2p_pio_virtual_base;
volatile unsigned int * pio_d_write_ptr = NULL ;
volatile unsigned int * pio_wr_addr_write_ptr = NULL ;
volatile unsigned int * pio_ready_read_ptr = NULL ;
volatile unsigned int * pio_done_read_ptr = NULL ;
volatile unsigned int * pio_reset_write_ptr = NULL ;
volatile unsigned int * pio_height_write_ptr = NULL ;
volatile unsigned int * pio_wr_en_write_ptr = NULL ;
volatile unsigned int * pio_string_init_write_ptr = NULL ;


// /dev/mem file id
int fd;

// measure time
struct timeval t1, t2;
double elapsedTime;

void mem_init(unsigned int *mem, unsigned int width, unsigned int height) {
	unsigned int i=0, j=0, temp=0;
	unsigned int height_mid = (height >> 1);
	double factor = 0.0, resolution = 0.0;

	printf("i = %d, j = %d, WIDTH_MID = %d, height_mid = %d\n", i, j, WIDTH_MID, height_mid);
	for(i = 0; i < height; i++) {
		// mem[WIDTH_MID][i] = temp;
		*(mem + WIDTH_MID*height + i) = temp;
		if(i<height_mid)
			temp += 0x400;
		else
			temp -= 0x400;
		printf("%x ", *(mem + WIDTH_MID*height + i));
	}
	printf("Halfway!\n");

	for(j = 0; j < WIDTH_MID; j++) {
		resolution = (1.0 / WIDTH_MID);
		factor = 1.0 - resolution * (WIDTH_MID - j);
		for(i = 0; i < height; i++) {
			*(mem + j*height + i) = factor * (*(mem + WIDTH_MID*height + i));
			*(mem + (WIDTH-1-j)*height + i) = factor * (*(mem + WIDTH_MID*height + i));
			printf("%x ", *(mem + j*height + i));
		}
		printf("\n");
	}
	printf("Finished\n");
}


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
	// h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	// if( h2p_lw_virtual_base == MAP_FAILED ) {
	// 	printf( "ERROR: mmap1() failed...\n" );
	// 	close( fd );
	// 	return(1);
	// }

	// === get PIO addr ====================
	// get virtual addr that maps to physical
	h2p_pio_virtual_base = mmap( NULL, PIO_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, PIO_BASE);	
	if( h2p_pio_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap4() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA pixel buffer
	pio_d_write_ptr =(unsigned int *)(h2p_pio_virtual_base+PIO_D_OFFSET);
	pio_wr_addr_write_ptr =(unsigned int *)(h2p_pio_virtual_base+PIO_WR_ADDR_OFFSET);
	pio_ready_read_ptr =(unsigned int *)(h2p_pio_virtual_base+PIO_READY_OFFSET);
	pio_done_read_ptr =(unsigned int *)(h2p_pio_virtual_base+PIO_DONE_OFFSET);
	pio_reset_write_ptr =(unsigned int *)(h2p_pio_virtual_base+PIO_RESET_OFFSET);
	pio_height_write_ptr = (unsigned int *)(h2p_pio_virtual_base+PIO_HEIGHT_OFFSET);
	pio_wr_en_write_ptr = (unsigned int *)(h2p_pio_virtual_base+PIO_WR_EN_OFFSET);
	pio_string_init_write_ptr = (unsigned int *)(h2p_pio_virtual_base+PIO_STRING_INIT_OFFSET);

	// Memory initialization
	// unsigned int mem[WIDTH][HEIGHT];
	// mem_init(mem);
	// int i=0, j=0;
	// for(i=0; i<WIDTH; i++) {
	// 	for(j=0; j<HEIGHT; j++) {
	// 		// printf("%04x ", mem[i][j]);
	// 	}
	// 	// printf("\n");
	// }


	unsigned int temp = 0x000;

	while(1) 
	{

		printf("\nEnter the height!\n");

		unsigned int height = 0;
		if (scanf("%u", &height) == 1) {
			printf("height = %u\n", height);
		} else {
			printf("Failed to read integer.\n");
		}		

		// Memory initialization
		unsigned int *mem = (unsigned int *)malloc(WIDTH*height*sizeof(unsigned int));
		mem_init(mem, WIDTH, height);
		printf("mem initialized!\n");
		int i=0, j=0;
		for(i=0; i<WIDTH; i++) {
			for(j=0; j<height; j++) {
				printf("%04x ", *(mem + i*height + j));
			}
			printf("\n");
		}

		*pio_wr_en_write_ptr = 1;
		*pio_d_write_ptr = 0;
		*pio_wr_addr_write_ptr = 0;
		*pio_string_init_write_ptr = 0;
		*pio_height_write_ptr = height;

		*pio_reset_write_ptr = 1;
		*pio_reset_write_ptr = 0;
		// *pio_string_init_write_ptr = 1;

		if(!(*pio_done_read_ptr)) {
			for(i=0; i<WIDTH; i++) {
				// clear this to zero or the next string's done signal goes high immediately
				*pio_wr_addr_write_ptr = 0;
				// specify the string to write
				*pio_string_init_write_ptr = i;
				for(j=0; j<height; j++) {
					// change the data and address first before write enable becomes 1
					*pio_wr_addr_write_ptr = j;
					*pio_d_write_ptr = *(mem + i*height + j);
					// printf("%04x ", mem[i][j]);
					*pio_wr_en_write_ptr = 1;
					// usleep(2000);  // let it write
					*pio_wr_en_write_ptr = 0;

					// printf("\npio_done = %d\n", *pio_done_read_ptr);
				}
				// printf("\ni = %d, pio_done = %d\n\n", i, *pio_done_read_ptr);
				// usleep(20000);
			}
			printf("\ni = %d, pio_done = %d\n\n", i, *pio_done_read_ptr);
			printf("mem loaded from C\n");
		}
		else {
			printf("Done!\n");
			// usleep(2000000);
		}
		usleep(100000);

	} // end while(1)
} // end main