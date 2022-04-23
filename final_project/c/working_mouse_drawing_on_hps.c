///////////////////////////////////////
/// 640x480 version! 16-bit color
/// This code will segfault the original
/// DE1 computer
/// compile with
/// gcc working_vga_draw_on_hps.c -o c_hps -O2 -lm -lpthread
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

// video display
#define SDRAM_BASE            0xC0000000
#define SDRAM_END             0xC3FFFFFF
#define SDRAM_SPAN			  0x04000000
// characters
#define FPGA_CHAR_BASE        0xC9000000 
#define FPGA_CHAR_END         0xC9001FFF
#define FPGA_CHAR_SPAN        0x00002000
/* Cyclone V FPGA devices */
#define HW_REGS_BASE          0xff200000
//#define HW_REGS_SPAN        0x00200000 
#define HW_REGS_SPAN          0x00005000

// PIO
#define PIO_BASE              0xC4000000
#define PIO_SPAN			  0x10
#define PIO_LCLOCK_OFFSET     0x00
#define PIO_LRESET_OFFSET     0x10
// PIO phasor
#define PIO_PHASOR_OUT_1_OFFSET   0x20
#define PIO_PHASOR_OUT_2_OFFSET   0x30
#define PIO_COS_MAG_OFFSET   	  0x60
#define PIO_SIN_MAG_OFFSET        0x70
#define PIO_FREQ_OFFSET           0x80

// Fourier primitives
float* analysis(float*, float*, int, int);

// graphics primitives
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_rect (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;
void VGA_Vline(int, int, int, short) ;
void VGA_Hline(int, int, int, short) ;
void VGA_disc (int, int, int, short);
void VGA_circle (int, int, int, int);
// 16-bit primary colors
#define red  (0+(0<<5)+(31<<11))
#define dark_red (0+(0<<5)+(15<<11))
#define green (0+(63<<5)+(0<<11))
#define dark_green (0+(31<<5)+(0<<11))
#define blue (31+(0<<5)+(0<<11))
#define dark_blue (15+(0<<5)+(0<<11))
#define yellow (0+(63<<5)+(31<<11))
#define cyan (31+(63<<5)+(0<<11))
#define magenta (31+(0<<5)+(31<<11))
#define black (0x0000)
#define gray (15+(31<<5)+(51<<11))
#define white (0xffff)
int colors[] = {red, dark_red, green, dark_green, blue, 
				dark_blue, yellow, cyan, magenta, gray, 
				black, white};

// pixel macro
#define VGA_PIXEL(x,y,color) do{\
	int  *pixel_ptr ;\
	pixel_ptr = (int*)((char *)vga_pixel_ptr + (((y)*640+(x))<<1)) ; \
	*(short *)pixel_ptr = (color);\
} while(0)

// the light weight bus base
void *h2p_lw_virtual_base;

// the heavy weight bus base for the PIO
void *h2p_pio_virtual_base;
volatile unsigned int * pio_lclock_write_ptr = NULL ;
volatile unsigned int * pio_lreset_write_ptr = NULL ;
volatile unsigned int * pio_phasor_out_1_read_ptr = NULL ;
volatile unsigned int * pio_phasor_out_2_read_ptr = NULL ;
volatile unsigned int * pio_cos_mag_write_ptr   = NULL ;
volatile unsigned int * pio_sin_mag_write_ptr   = NULL ;
volatile unsigned int * pio_freq_write_ptr      = NULL ;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

// /dev/mem file id
int fd;

// measure time
struct timeval t1, t2;
double elapsedTime;
	

// print strings
float sigma, rho, beta;
int dt_power;

// float mag1, mag2;
signed int cos_mag[2];
signed int sin_mag[2];
unsigned int freq[2];

// pthread everything 
char input_buffer[64];

/* create a message to be displayed on the VGA 
          and LCD displays */
char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
char text_bottom_row[40] = "Cornell ece5760\0";
char text_next[40] = "Lab 1: Lorenz System\0";

char text_xy[40] = "XY Projection\0";
char text_xz[40] = "XZ Projection\0";
char text_yz[40] = "YZ Projection\0";

pthread_mutex_t enter_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t print_lock = PTHREAD_MUTEX_INITIALIZER;
// pthread conditions 
pthread_cond_t enter_cond;
pthread_cond_t print_cond; 

void * read_input() {
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
int pause_flag = 0;
int reset_flag = 0;
unsigned int sleep_time = 10000;
void *write_status() {
	sleep(1);  // cond would be sent before pthread_cond_wait
	pthread_cond_signal(&print_cond); 
	
	while(1) {
		// print depending on the enter value "input buffer"
		pthread_mutex_lock(&enter_lock);
		pthread_cond_wait(&enter_cond, &enter_lock);
	
		// do command-dependant functions	
		// update flag: pause flag, update speed, resset flag
		if(!strcmp(input_buffer, "p")) {
			pause_flag = !pause_flag;
		}
		if(!strcmp(input_buffer, "r")) {
			reset_flag = 1;
		}
		if(!strcmp(input_buffer, "s")) {
			sleep_time *= 2;
		}
		if(!strcmp(input_buffer, "f")) {
			sleep_time /= 2;
		}
		if(!strcmp(input_buffer, "c")) {
			VGA_box (0, 0, 639, 479, 0x0000);
		}
		if(!strcmp(input_buffer, "set")) {

			pause_flag = 1;

			// printf("Enter x0: ");
			// scanf("%s", input_buffer);
			// *pio_x0_write_ptr = convert720(input_buffer);

			// clear the screen
			VGA_box (0, 0, 639, 479, 0x0000);
			// clear the text
			VGA_text_clear();
			// write text
			// VGA_text (10, 1, text_top_row);
			// VGA_text (10, 2, text_bottom_row);
			// VGA_text (10, 3, text_next);

			// VGA_text (16, 32, text_xy);
			// VGA_text (56, 32, text_xz);
			// VGA_text (36, 55, text_yz);

			pause_flag = 0;

		}

		pthread_mutex_unlock(&enter_lock);
		pthread_cond_signal(&print_cond);  

	}
}

int convert720(char* str) {
	double d = atof(str);
	int d_fixed = (int)(round(d*(1<<20)));
	return d_fixed;
}

// int convert720(char* str) {
// 	double d = atof(str);
// 	int d_fixed = (int)(round(d*(1<<20)));
// 	return d_fixed;
// }

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
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
    

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
	vga_pixel_virtual_base = mmap( NULL, SDRAM_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, SDRAM_BASE);	
	if( vga_pixel_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA pixel buffer
	vga_pixel_ptr =(unsigned int *)(vga_pixel_virtual_base);


	// === get PIO addr ====================
	// get virtual addr that maps to physical
	h2p_pio_virtual_base = mmap( NULL, PIO_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, PIO_BASE);	
	if( h2p_pio_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap4() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA pixel buffer
	pio_lclock_write_ptr 	      =(unsigned int *)(h2p_pio_virtual_base+PIO_LCLOCK_OFFSET);
	pio_lreset_write_ptr 	      =(unsigned int *)(h2p_pio_virtual_base+PIO_LRESET_OFFSET);
	pio_phasor_out_1_read_ptr 	  =(unsigned int *)(h2p_pio_virtual_base+PIO_PHASOR_OUT_1_OFFSET);
	pio_phasor_out_2_read_ptr     =(unsigned int *)(h2p_pio_virtual_base+PIO_PHASOR_OUT_2_OFFSET);
	pio_cos_mag_write_ptr		  =(unsigned int *)(h2p_pio_virtual_base+PIO_COS_MAG_OFFSET);
	pio_sin_mag_write_ptr		  =(unsigned int *)(h2p_pio_virtual_base+PIO_SIN_MAG_OFFSET);
	pio_freq_write_ptr			  =(unsigned int *)(h2p_pio_virtual_base+PIO_FREQ_OFFSET);

	// ===========================================

	char num_string[20], time_string[20] ;
	sigma = 10.0;
	beta = 2.666;
	rho = 28.0;
	dt_power = -8;

	char color_index = 0 ;
	int color_counter = 0 ;
	
	// position of disk primitive
	int disc_x = 0;
	// position of circle primitive
	int circle_x = 0 ;
	// position of box primitive
	int box_x = 5 ;
	// position of vertical line primitive
	int Vline_x = 350;
	// position of horizontal line primitive
	int Hline_y = 250;

	//VGA_text (34, 1, text_top_row);
	//VGA_text (34, 2, text_bottom_row);
	// clear the screen
	VGA_box (0, 0, 639, 479, 0x0000);
	// clear the text
	VGA_text_clear();
	// write text
	// VGA_text (10, 1, text_top_row);
	// VGA_text (10, 2, text_bottom_row);
	// VGA_text (10, 3, text_next);

	// VGA_text (16, 32, text_xy);
	// VGA_text (56, 32, text_xz);
	// VGA_text (36, 55, text_yz);

	
	// R bits 11-15 mask 0xf800
	// G bits 5-10  mask 0x07e0
	// B bits 0-4   mask 0x001f
	// so color = B+(G<<5)+(R<<11);
	

	// int x_value, y_value, z_value;
	// int x_old, y_old, z_old;

	// *pio_sigma_write_ptr = (10 << 20);
	// *pio_beta_write_ptr = 0x2AAAAA;
	// *pio_rho_write_ptr = 28 << 20;

	// *pio_x0_write_ptr = 0x7F00000;
	// *pio_y0_write_ptr= 0x19999;
	// *pio_z0_write_ptr = 25 << 20;

	printf("Default? (y/n)");
	scanf("%s", input_buffer);
	if(!strcmp(input_buffer, "y")) {
		// *pio_sigma_write_ptr = (10 << 20);
		// *pio_beta_write_ptr = 0x2AAAAA;
		// *pio_rho_write_ptr = 28 << 20;

		// *pio_x0_write_ptr = 0x7F00000;
		// *pio_y0_write_ptr= 0x19999;
		// *pio_z0_write_ptr = 25 << 20;
		// *pio_dt_write_ptr = -8;

		*pio_cos_mag_write_ptr = 0x23;	
		*pio_sin_mag_write_ptr = 0x56;	
		*pio_freq_write_ptr	  = 0x27;		

	} else {	
		// printf("Enter sigma: ");
		// scanf("%s", input_buffer);
		// sigma = atof(input_buffer);
		// *pio_sigma_write_ptr = convert720(input_buffer); 	

		printf("Enter cos mag1: ");
		scanf("%s", input_buffer);
		cos_mag[0] = atoi(input_buffer);

		printf("Enter sin mag1: ");
		scanf("%s", input_buffer);
		sin_mag[0] = atoi(input_buffer);
		
		printf("Enter freq1: ");
		scanf("%s", input_buffer);
		freq[0] = atoi(input_buffer);

		printf("Enter cos mag2: ");
		scanf("%s", input_buffer);
		cos_mag[1] = atoi(input_buffer);
		*pio_cos_mag_write_ptr = (cos_mag[0] << 4) + cos_mag[1];

		printf("Enter sin mag2: ");
		scanf("%s", input_buffer);
		sin_mag[1] = atoi(input_buffer);
		*pio_sin_mag_write_ptr = (sin_mag[0] << 4) + sin_mag[1];

		printf("Enter freq2: ");
		scanf("%s", input_buffer);
		freq[1] = atoi(input_buffer);
		*pio_freq_write_ptr = (freq[0] << 4) + freq[1];

		printf("cos_mag = 0x%x\n", (cos_mag[0] << 4) + cos_mag[1]);
		printf("sin_mag = 0x%x\n", (sin_mag[0] << 4) + sin_mag[1]);
		printf("freq = 0x%x\n", (freq[0] << 4) + freq[1]);

	}

	// drive the clk and reset
	*pio_lclock_write_ptr = 1;
	*pio_lclock_write_ptr = 0;

	// // This is Lorenz reset, which is triggered low
	// *pio_lreset_write_ptr = 0;
	// usleep(17000);
	// // make a posedge of the clk to trigger the reset
	// *pio_lclock_write_ptr = 0;
	// *pio_lclock_write_ptr = 1;
	// usleep(17000);
	// *pio_lreset_write_ptr = 1;

	// This is the phasor reset, which is triggered high
	*pio_lreset_write_ptr = 1;
	usleep(17000);
	// make a posedge of the clk to trigger the reset
	*pio_lclock_write_ptr = 0;
	*pio_lclock_write_ptr = 1;
	usleep(17000);

	*pio_lreset_write_ptr = 0;
	*pio_lclock_write_ptr = 1;
	*pio_lclock_write_ptr = 0;
	*pio_lclock_write_ptr = 1;

	// phasor initial values
	int x, y, x_old, y_old; 

	x = (int)(*pio_phasor_out_1_read_ptr) ;
	y = (int)(*pio_phasor_out_2_read_ptr) ;

	printf("x = 0x%x, y = 0x%x\n", x, y);

	x = x << 12;
	y = y << 12;

	x = x >> 22;
	y = y >> 22;

	printf("x_shifted = 0x%x, y_shifted = 0x%x\n", x, y);


// thread instantiations
// thread handles 
	pthread_t thread_r, thread_w;

	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

// create threads
	pthread_create(&thread_r, &attr, read_input, NULL);
	pthread_create(&thread_w, &attr, write_status, NULL);

	int x_coordinate = 0;

	int phasor_sum_sin, phasor_sum_cos; 
	int phasor_sum_sin_old, phasor_sum_cos_old; 

	int center_x, center_y; 
	center_x = 320;
	center_y = 240;

	//===================== MOUSE ==================================
	int fd_mouse, bytes;
    unsigned char data[3];

    const char *pDevice = "/dev/input/mice";

    // Open Mouse
    fd_mouse = open(pDevice, O_RDWR);
    if(fd_mouse == -1)
    {
        printf("ERROR Opening %s\n", pDevice);
        return -1;
    }

    int mouse_x = 320, mouse_y = 240, mouse_x_old = 320, mouse_y_old = 240;
	int click_x_new=0, click_y_new=0, click_x_old=0, click_y_old=0;
    int left, middle, right;
    signed char mouse_x_tmp, mouse_y_tmp;
	int first_click = 1;

	// draw the mouse starting point
	VGA_circle(320, 240, 2, colors[7]);

	// end of MOUSE ================================================

	while(1) 
	{
		// if( x_coordinate++ == 600 ) {
		// 	x_coordinate = 40;
		// }

		x_old = x;
		y_old = y;

		x = (int)(*pio_phasor_out_1_read_ptr) ;
		y = (int)(*pio_phasor_out_2_read_ptr) ;

		x = x << 12;
		y = y << 12;

		x = x >> 22;
		y = y >> 22;

		printf("x = 0x%x, y = 0x%x\n", x, y);

		// phasor_sum_sin_old = phasor_1_sin_old + phasor_2_sin_old;
		// phasor_sum_cos_old = phasor_1_cos_old + phasor_2_cos_old;
		// phasor_sum_sin = phasor_1_sin + phasor_2_sin;
		// phasor_sum_cos = phasor_1_cos + phasor_2_cos;

		// ==========================================
		// // Delete the previous arrow by recoloring with black line (sum of the arrows; single arrow)
		// VGA_line(center_x, 					    center_y, 
		// 		 center_x + phasor_sum_sin_old,  phasor_sum_cos_old + center_y, colors[10]);
		// // Draw a new arrow (sum of the arrows; single arrow)
		// VGA_line(center_x, 					    center_y, 
		// 		 center_x + phasor_sum_sin,  phasor_sum_cos + center_y, colors[11]);
		// ==========================================

		// Delete the previous arrow by recoloring with black line 
		VGA_line(center_x, 					    center_y, 
				 center_x + x_old,   			center_y + y_old, colors[10]);
		// VGA_line(center_x + phasor_1_sin_old, 	center_y + phasor_1_cos_old, 
		// 		center_x + phasor_1_sin_old + phasor_2_sin_old,  center_y + phasor_1_cos_old + phasor_2_cos_old, colors[10]);
		// Draw a new arrow 
		VGA_line(center_x, 					    center_y, 
				 center_x + x, 					center_y + y, colors[7]); // inner arrow (cyan)
		// VGA_line(center_x + phasor_1_cos, 		center_y + phasor_1_cos, // outer arrow (magenta)
		// 		center_x + phasor_1_sin + phasor_2_sin, center_y + phasor_1_cos + phasor_2_cos, colors[8]);
		// Draw the shape 
		VGA_line(center_x + x_old, 				center_y + y_old,
				 center_x + x, 					center_y + y, colors[6]); // yellow 

		// sum up
		// VGA_line(phasor_1_sin_old+phasor_1_cos_old+320, phasor_2_sin_old+phasor_2_cos_old+240,
		// 		 phasor_1_sin+phasor_1_cos+320, phasor_2_sin+phasor_2_cos+240, colors[2]);

		// VGA_line(x_coordinate, phasor_1_old+160, x_coordinate, phasor_1+160, colors[1]);
		// VGA_line(x_coordinate, phasor_2_old+320, x_coordinate, phasor_2+320, colors[1]);

		//void VGA_circle(int x, int y, int r, short pixel_color)
		// VGA_circle(320, 240, cos_mag[0] * 10, colors[4]);

		if(pause_flag) {
			*pio_lclock_write_ptr = 0;
		} else {
			*pio_lclock_write_ptr = !(*pio_lclock_write_ptr);
			*pio_lclock_write_ptr = !(*pio_lclock_write_ptr);
		}
		usleep(sleep_time);

		if(reset_flag) {
			*pio_lreset_write_ptr = 0;
			// make a posedge of the clk to trigger the reset
			*pio_lclock_write_ptr = 0;
			*pio_lclock_write_ptr = 1;
			usleep(10000);
			*pio_lreset_write_ptr = 1;
			// clear the screen
			VGA_box (0, 0, 639, 479, 0x0000);

			// initial values
			// x_value = (int)(*pio_x_read_ptr);
			// y_value = (int)(*pio_y_read_ptr);
			// z_value = (int)(*pio_z_read_ptr);

			// // printf("value_x = 0x%x, value_y = 0x%x, value_z = 0x%x\n", x_value, y_value, z_value);

			// x_value = x_value << 5;
			// y_value = y_value << 5;
			// z_value = z_value << 5;

			// x_value = x_value >> 23;
			// y_value = y_value >> 23;
			// z_value = z_value >> 23;

			// x_old = x_value;
			// y_old = y_value;
			// z_old = z_value;

			sleep_time = 10000;

			// clear the screen
			VGA_box (0, 0, 639, 479, 0x0000);
			// clear the text
			VGA_text_clear();
			// write text
			// VGA_text (10, 1, text_top_row);
			// VGA_text (10, 2, text_bottom_row);
			// VGA_text (10, 3, text_next);

			// VGA_text (16, 32, text_xy);
			// VGA_text (56, 32, text_xz);
			// VGA_text (36, 55, text_yz);

			reset_flag = 0;
			pause_flag = 0;
		}

		// start timer
		gettimeofday(&t1, NULL);
		
		// stop timer
		gettimeofday(&t2, NULL);

		char str_buffer[36];
		// sprintf(str_buffer, "sigma = %3.3f", sigma);
		// VGA_text (10, 4, str_buffer);
		// sprintf(str_buffer, "rho = %3.3f", rho);
		// VGA_text (10, 5, str_buffer);
		// sprintf(str_buffer, "beta = %3.3f", beta);
		// VGA_text (10, 6, str_buffer);
		// sprintf(str_buffer, "dt's power = %d", dt_power);
		// VGA_text (10, 7, str_buffer);
		// set frame rate
		// usleep(17000);
		
		//===================== MOUSE ==================================

		// Read Mouse     
        bytes = read(fd_mouse, data, sizeof(data));

        if(bytes > 0)
        {
            left = data[0] & 0x1;
            right = data[0] & 0x2;
            middle = data[0] & 0x4;

            mouse_x_tmp = data[1];
            mouse_y_tmp = data[2];
            printf("mouse_x_tmp=%d, mouse_y_tmp=%d, left=%d, middle=%d, right=%d, ", mouse_x_tmp, mouse_y_tmp, left, middle, right);

			mouse_x_old = mouse_x;
			mouse_y_old = mouse_y;

            mouse_x += mouse_x_tmp;
            if(mouse_x > 639) {
                mouse_x = 639;
            }
            if(mouse_x < 0) {
                mouse_x = 0;
            }
            mouse_y -= mouse_y_tmp;
            if(mouse_y > 479) {
                mouse_y = 479;
            }
            if(mouse_y < 0) {
                mouse_y = 0;
            }
            printf("mouse_x=%d, mouse_y=%d\n", mouse_x, mouse_y);

			VGA_circle(mouse_x_old, mouse_y_old, 1, colors[10]);
			VGA_circle(mouse_x, mouse_y, 1, colors[7]);
			
			if(left) {
				click_x_old = click_x_new;
				click_y_old = click_y_new;
				click_x_new = mouse_x;
				click_y_new = mouse_y;
				if(first_click) {
					first_click = 0;
				} else {
					VGA_line(click_x_old, click_y_old, click_x_new, click_y_new, colors[7]);
				}
			}
        }
		// end of MOUSE ================================================

		// ========================= Analysis ==========================

		

		// end of Analysis ================================================




	} // end while(1)
} // end main

// Fourier analysis 
float* analysis (float* x, float* y, int K, int n) {
    float L = 0;
    float* x_j = (float*)malloc(K*sizeof(float));
    float* l_j = (float*)malloc(K*sizeof(float));
    
    float* a_n = (float*)malloc((n)*sizeof(float)); // n harmonics + offset
    float* b_n = (float*)malloc(n*sizeof(float));
    float* al_j = (float*)malloc(K*sizeof(float));
    int i, j;

    // clear memory to 0
    for(i = 0; i < K; i++) {
        x_j[i] = 0;
        l_j[i] = 0;
        al_j[i] = 0;
    }
    for(i = 0; i < n; i++) {
        a_n[i] = 0;
        b_n[i] = 0;
    }
    // compute parameters  
    
    for(i = 0; i < K; i++) {
        float dx = x[i+1] - x[i];
        float dy = y[i+1] - y[i];
        l_j[i] = sqrt(dx*dx + dy*dy);     
        L += l_j[i];
        
        x_j[i] = dx;
        al_j[i] = L;
    }

    // print all parameters 
    printf("L = %f\n", L);
    for(i = 0; i < K; i++) {
        printf("dx[%d] = %f\n", i, x_j[i]);

    }
    for(i = 0; i < K; i++) {
        printf("dl[%d] = %f\n", i, l_j[i]);
    }
    for(i = 0; i < K; i++) {
        printf("al[%d] = %f\n", i, al_j[i]);
    }   
        

    // compute offset a0
    float a0 = x[0]*al_j[0] + 0.5*x_j[0]*al_j[0]*al_j[0]/l_j[0];
    for(i = 1; i < K; i++) {
        float sum = (x[i]-(x_j[i]*al_j[i-1]/l_j[i]))*(al_j[i]-al_j[i-1]) + ((x_j[i]/l_j[i])*(al_j[i]*al_j[i] - al_j[i-1]*al_j[i-1])) / 2;
        // printf("sum = %f\n", sum);
        a_n[0] += sum;        
    }
    a0 = a0/L;

    // compute harmonics
    int harm;
    for(harm = 1; harm <= n; harm++) {
        
        float tempa = (x_j[0]/l_j[0])*(cos(2*M_PI*harm*al_j[0]/L) - 1);
        float tempb = (x_j[0]/l_j[0])*(sin(2*M_PI*harm*al_j[0]/L));

        for(i = 1; i < K; i++) {
            tempa += (x_j[i]/l_j[i])*(cos(2*M_PI*harm*al_j[i]/L) - cos(2*M_PI*harm*al_j[i-1]/L));
            tempb += (x_j[i]/l_j[i])*(sin(2*M_PI*harm*al_j[i]/L) - sin(2*M_PI*harm*al_j[i-1]/L));

        }

        a_n[harm-1] = tempa * L / (2*M_PI*M_PI*harm*harm);
        b_n[harm-1] = tempb * L / (2*M_PI*M_PI*harm*harm);
        printf("a%d = %f\n", harm, a_n[harm-1]);
        printf("b%d = %f\n", harm, b_n[harm-1]);
    }

    float* coeff = (float*) malloc ((2*n+1)*sizeof(float));
    coeff[0] = a0;
    for(i = 0; i < n; i++) {
        coeff[i+1] = a_n[i];
        coeff[i+1+n] = b_n[i];
    }
    return coeff;

}

/****************************************************************************************
 * Subroutine to send a string of text to the VGA monitor 
****************************************************************************************/
void VGA_text(int x, int y, char * text_ptr)
{
  	volatile char * character_buffer = (char *) vga_char_ptr ;	// VGA character buffer
	int offset;
	/* assume that the text string fits on one line */
	offset = (y << 7) + x;
	while ( *(text_ptr) )
	{
		// write to the character buffer
		*(character_buffer + offset) = *(text_ptr);	
		++text_ptr;
		++offset;
	}
}

/****************************************************************************************
 * Subroutine to clear text to the VGA monitor 
****************************************************************************************/
void VGA_text_clear()
{
  	volatile char * character_buffer = (char *) vga_char_ptr ;	// VGA character buffer
	int offset, x, y;
	for (x=0; x<79; x++){
		for (y=0; y<59; y++){
	/* assume that the text string fits on one line */
			offset = (y << 7) + x;
			// write to the character buffer
			*(character_buffer + offset) = ' ';		
		}
	}
}

/****************************************************************************************
 * Draw a filled rectangle on the VGA monitor 
****************************************************************************************/
#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 

void VGA_box(int x1, int y1, int x2, int y2, short pixel_color)
{
	char  *pixel_ptr ; 
	int row, col;

	/* check and fix box coordinates to be valid */
	if (x1>639) x1 = 639;
	if (y1>479) y1 = 479;
	if (x2>639) x2 = 639;
	if (y2>479) y2 = 479;
	if (x1<0) x1 = 0;
	if (y1<0) y1 = 0;
	if (x2<0) x2 = 0;
	if (y2<0) y2 = 0;
	if (x1>x2) SWAP(x1,x2);
	if (y1>y2) SWAP(y1,y2);
	for (row = y1; row <= y2; row++)
		for (col = x1; col <= x2; ++col)
		{
			//640x480
			//pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
			// set pixel color
			//*(char *)pixel_ptr = pixel_color;	
			VGA_PIXEL(col,row,pixel_color);	
		}
}

/****************************************************************************************
 * Draw a outline rectangle on the VGA monitor 
****************************************************************************************/
#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 

void VGA_rect(int x1, int y1, int x2, int y2, short pixel_color)
{
	char  *pixel_ptr ; 
	int row, col;

	/* check and fix box coordinates to be valid */
	if (x1>639) x1 = 639;
	if (y1>479) y1 = 479;
	if (x2>639) x2 = 639;
	if (y2>479) y2 = 479;
	if (x1<0) x1 = 0;
	if (y1<0) y1 = 0;
	if (x2<0) x2 = 0;
	if (y2<0) y2 = 0;
	if (x1>x2) SWAP(x1,x2);
	if (y1>y2) SWAP(y1,y2);
	// left edge
	col = x1;
	for (row = y1; row <= y2; row++){
		//640x480
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;	
		VGA_PIXEL(col,row,pixel_color);		
	}
		
	// right edge
	col = x2;
	for (row = y1; row <= y2; row++){
		//640x480
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;	
		VGA_PIXEL(col,row,pixel_color);		
	}
	
	// top edge
	row = y1;
	for (col = x1; col <= x2; ++col){
		//640x480
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;	
		VGA_PIXEL(col,row,pixel_color);
	}
	
	// bottom edge
	row = y2;
	for (col = x1; col <= x2; ++col){
		//640x480
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;
		VGA_PIXEL(col,row,pixel_color);
	}
}

/****************************************************************************************
 * Draw a horixontal line on the VGA monitor 
****************************************************************************************/
#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 

void VGA_Hline(int x1, int y1, int x2, short pixel_color)
{
	char  *pixel_ptr ; 
	int row, col;

	/* check and fix box coordinates to be valid */
	if (x1>639) x1 = 639;
	if (y1>479) y1 = 479;
	if (x2>639) x2 = 639;
	if (x1<0) x1 = 0;
	if (y1<0) y1 = 0;
	if (x2<0) x2 = 0;
	if (x1>x2) SWAP(x1,x2);
	// line
	row = y1;
	for (col = x1; col <= x2; ++col){
		//640x480
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;	
		VGA_PIXEL(col,row,pixel_color);		
	}
}

/****************************************************************************************
 * Draw a vertical line on the VGA monitor 
****************************************************************************************/
#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 

void VGA_Vline(int x1, int y1, int y2, short pixel_color)
{
	char  *pixel_ptr ; 
	int row, col;

	/* check and fix box coordinates to be valid */
	if (x1>639) x1 = 639;
	if (y1>479) y1 = 479;
	if (y2>479) y2 = 479;
	if (x1<0) x1 = 0;
	if (y1<0) y1 = 0;
	if (y2<0) y2 = 0;
	if (y1>y2) SWAP(y1,y2);
	// line
	col = x1;
	for (row = y1; row <= y2; row++){
		//640x480
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;	
		VGA_PIXEL(col,row,pixel_color);			
	}
}


/****************************************************************************************
 * Draw a filled circle on the VGA monitor 
****************************************************************************************/

void VGA_disc(int x, int y, int r, short pixel_color)
{
	char  *pixel_ptr ; 
	int row, col, rsqr, xc, yc;
	
	rsqr = r*r;
	
	for (yc = -r; yc <= r; yc++)
		for (xc = -r; xc <= r; xc++)
		{
			col = xc;
			row = yc;
			// add the r to make the edge smoother
			if(col*col+row*row <= rsqr+r){
				col += x; // add the center point
				row += y; // add the center point
				//check for valid 640x480
				if (col>639) col = 639;
				if (row>479) row = 479;
				if (col<0) col = 0;
				if (row<0) row = 0;
				//pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
				// set pixel color
				//*(char *)pixel_ptr = pixel_color;
				VGA_PIXEL(col,row,pixel_color);	
			}
					
		}
}

/****************************************************************************************
 * Draw a  circle on the VGA monitor 
****************************************************************************************/

void VGA_circle(int x, int y, int r, int pixel_color)
{
	char  *pixel_ptr ; 
	int row, col, rsqr, xc, yc;
	int col1, row1;
	rsqr = r*r;
	
	for (yc = -r; yc <= r; yc++){
		//row = yc;
		col1 = (int)sqrt((float)(rsqr + r - yc*yc));
		// right edge
		col = col1 + x; // add the center point
		row = yc + y; // add the center point
		//check for valid 640x480
		if (col>639) col = 639;
		if (row>479) row = 479;
		if (col<0) col = 0;
		if (row<0) row = 0;
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;
		VGA_PIXEL(col,row,pixel_color);	
		// left edge
		col = -col1 + x; // add the center point
		//check for valid 640x480
		if (col>639) col = 639;
		if (row>479) row = 479;
		if (col<0) col = 0;
		if (row<0) row = 0;
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;
		VGA_PIXEL(col,row,pixel_color);	
	}
	for (xc = -r; xc <= r; xc++){
		//row = yc;
		row1 = (int)sqrt((float)(rsqr + r - xc*xc));
		// right edge
		col = xc + x; // add the center point
		row = row1 + y; // add the center point
		//check for valid 640x480
		if (col>639) col = 639;
		if (row>479) row = 479;
		if (col<0) col = 0;
		if (row<0) row = 0;
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;
		VGA_PIXEL(col,row,pixel_color);	
		// left edge
		row = -row1 + y; // add the center point
		//check for valid 640x480
		if (col>639) col = 639;
		if (row>479) row = 479;
		if (col<0) col = 0;
		if (row<0) row = 0;
		//pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
		// set pixel color
		//*(char *)pixel_ptr = pixel_color;
		VGA_PIXEL(col,row,pixel_color);	
	}
}

// =============================================
// === Draw a line
// =============================================
//plot a line 
//at x1,y1 to x2,y2 with color 
//Code is from David Rodgers,
//"Procedural Elements of Computer Graphics",1985
void VGA_line(int x1, int y1, int x2, int y2, short c) {
	int e;
	signed int dx,dy,j, temp;
	signed int s1,s2, xchange;
     signed int x,y;
	char *pixel_ptr ;
	
	/* check and fix line coordinates to be valid */
	if (x1>639) x1 = 639;
	if (y1>479) y1 = 479;
	if (x2>639) x2 = 639;
	if (y2>479) y2 = 479;
	if (x1<0) x1 = 0;
	if (y1<0) y1 = 0;
	if (x2<0) x2 = 0;
	if (y2<0) y2 = 0;
        
	x = x1;
	y = y1;
	
	//take absolute value
	if (x2 < x1) {
		dx = x1 - x2;
		s1 = -1;
	}

	else if (x2 == x1) {
		dx = 0;
		s1 = 0;
	}

	else {
		dx = x2 - x1;
		s1 = 1;
	}

	if (y2 < y1) {
		dy = y1 - y2;
		s2 = -1;
	}

	else if (y2 == y1) {
		dy = 0;
		s2 = 0;
	}

	else {
		dy = y2 - y1;
		s2 = 1;
	}

	xchange = 0;   

	if (dy>dx) {
		temp = dx;
		dx = dy;
		dy = temp;
		xchange = 1;
	} 

	e = ((int)dy<<1) - dx;  
	 
	for (j=0; j<=dx; j++) {
		//video_pt(x,y,c); //640x480
		//pixel_ptr = (char *)vga_pixel_ptr + (y<<10)+ x; 
		// set pixel color
		//*(char *)pixel_ptr = c;
		VGA_PIXEL(x,y,c);			
		 
		if (e>=0) {
			if (xchange==1) x = x + s1;
			else y = y + s2;
			e = e - ((int)dx<<1);
		}

		if (xchange==1) y = y + s2;
		else x = x + s1;

		e = e + ((int)dy<<1);
	}
}