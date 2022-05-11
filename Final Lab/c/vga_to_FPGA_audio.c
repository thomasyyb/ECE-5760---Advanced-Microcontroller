///////////////////////////////////////
/// 640x480 version! 16-bit color
/// This code will segfault the original
/// DE1 computer
/// compile with
/// gcc vga_to_FPGA_audio.c -o vga_to_FPGA_audio -O3 -lm -lpthread -lrt
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
#include <time.h>
#include <string.h>
// network stuff
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include "address_map_arm_brl4.h"
// timing analysis
#include <time.h>

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

#define PIO_A_OFFSET	      0x00
#define PIO_B_OFFSET	      0x10
#define PIO_C_OFFSET	      0x20
#define PIO_D_OFFSET	      0x30
#define PIO_RESET_OFFSET      0x40
#define PIO_WR_EN_OFFSET      0x50
#define PIO_WR_ADDR_OFFSET    0x60

// audio stuff
volatile unsigned int * audio_base_ptr = NULL ;
volatile unsigned int * audio_fifo_data_ptr = NULL ; //4bytes
volatile unsigned int * audio_left_data_ptr = NULL ; //8bytes
volatile unsigned int * audio_right_data_ptr = NULL ; //12bytes

// shift fraction to 32-bit sound
#define fix2audio28(a) (a<<4)
// shift fraction to 16-bit sound
#define fix2audio16(a) (a>>12)

// convert floating point to fixed point with 8 bit decimal
#define float_to_fix8(a) (int)(round(a*(1<<18)))

// Fourier primitives
void analysis(float*, float*, int, int, float**, float**, float*);
void synthesis (float L, float* coeff, float* l, int K, int n, float out);
struct Mouse_Input {
	int x, y; 
}; 
void mouse_record(struct Mouse_Input* mi);
float fill_coefficients (struct Mouse_Input* mi, int morph);

#define N				 20 		// number of mouse inputs (n in Fourier analysis)
#define th_harmonic 	 21			// starts from 0th harmonic

/*************** Drum stuff *****************/
// drum-specific multiply macros simulated by shifts
#define times0pt5(a) ((a)>>1) 
#define times0pt25(a) ((a)>>2) 
#define times2pt0(a) ((a)<<1) 
#define times4pt0(a) ((a)<<2) 
#define times0pt9998(a) ((a)-((a)>>12)) //>>10
#define times0pt9999(a) ((a)-((a)>>13)) //>>10
#define times0pt999(a) ((a)-((a)>>10)) //>>10
// #define times_rho(a) (((a)>>4)) //>>2

inline signed int times_rho(signed int a, signed int u_center) {
	double rho = ( 0.49 > (0.25+((u_center*u_center)>>8)) ) ? (0.25+(u_center*u_center>>8)) : 0.49;
	// signed int rho = 1>>4;
	// printf("a>>4 = %d, (signed int)(0.0625*a) = %d\n", a>>4, (signed int)(0.0625 * a));
	return (signed int)(a >> 4);
}

// drum size paramenters
// drum will FAIL if size is too big
#define drum_size 20
#define drum_middle 10
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

// width of gaussian initial condition
float alpha = 64;
/*************** Drum stuff *****************/


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

volatile unsigned int * pio_a_write_ptr		  = NULL ;
volatile unsigned int * pio_b_write_ptr		  = NULL ;
volatile unsigned int * pio_c_write_ptr		  = NULL ;
volatile unsigned int * pio_d_write_ptr		  = NULL ;
volatile unsigned int * pio_reset_write_ptr   = NULL ;
volatile unsigned int * pio_wr_en_write_ptr   = NULL ;
volatile unsigned int * pio_wr_addr_write_ptr = NULL ;

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
		if(scanf("%s", input_buffer) == 0) {
			printf("input is wrong!\n");
			exit(1);
		}
		pthread_mutex_unlock(&print_lock);
		pthread_cond_signal(&enter_cond); 
	}

}

// float analysis_out_x_coeff[2*th_harmonic+1];
// float analysis_out_y_coeff[2*th_harmonic+1];
float* analysis_out_x_coeff;
float* analysis_out_y_coeff;
float* analysis_out_x_coeff_2;
float* analysis_out_y_coeff_2; 
// I think a parter to bounce the signals 
int pause_flag = 0;
int redraw_flag = 0;
int morph_flag = 0;
unsigned int sleep_time = 10000;
void *write_status() {
	sleep(1);  // cond would be sent before pthread_cond_wait
	pthread_cond_signal(&print_cond); 
	
	while(1) {
		// print depending on the enter value "input buffer"
		pthread_mutex_lock(&enter_lock);
		pthread_cond_wait(&enter_cond, &enter_lock);
	
		// r for redraw
		if(!strcmp(input_buffer, "r")) {
			redraw_flag = 1;
		}
		// c for coeff change
		else if(!strcmp(input_buffer, "c")) {
			// Get harmonic
			printf("Which dimension? x or y?\n");
			char dimension[1];
			if(scanf("%s", dimension) == 0) {
				printf("input is wrong!\n");
				exit(1);
			}
			printf("dimension is %s\n", dimension);
			
			
			// Get harmonic
			printf("Which harmonic?(1~21)\n");
			char harmonic[2];
			if(scanf("%s", harmonic) == 0) {
				printf("input is wrong!\n");
				exit(1);
			}
			int harm = atoi(harmonic);
			if(strcmp(dimension, "x") == 0) {

			
				// Change coefficient
				printf("The current coefficients for harmonic %d is :\n", harm);
				printf("coeff_sin: %d, coeff_cos: %d:\n", (int)analysis_out_x_coeff[harm], (int)analysis_out_x_coeff[harm+th_harmonic]);
				int new_sin_coeff, new_cos_coeff;
				printf("Input new value:\n");
				printf("coeff_sin and coeff_cos: (0~100)\n");
				if(scanf("%i %i", &new_sin_coeff, &new_cos_coeff) == 0) {
					printf("input is wrong!\n");
					exit(1);
				}
				analysis_out_x_coeff[harm] = new_sin_coeff;
				analysis_out_x_coeff[harm+th_harmonic] = new_cos_coeff;
			} else if (strcmp(dimension, "y") == 0) {
				// Change coefficient
				printf("The current coefficients for harmonic %d is :\n", harm);
				printf("coeff_sin: %d, coeff_cos: %d:\n", (int)analysis_out_y_coeff[harm], (int)analysis_out_y_coeff[harm+th_harmonic]);
				int new_sin_coeff, new_cos_coeff;
				printf("Input new value:\n");
				printf("coeff_sin and coeff_cos: (0~100)\n");
				if(scanf("%i %i", &new_sin_coeff, &new_cos_coeff) == 0) {
					printf("input is wrong!\n");
					exit(1);
				}
				analysis_out_y_coeff[harm] = new_sin_coeff;
				analysis_out_y_coeff[harm+th_harmonic] = new_cos_coeff;
			} else {
				printf("I asked x or y, you troll\n");
			}
			// clear screen
			VGA_box(0, 0, 639, 479, 0x0000);
			// Redraw the spectrum
			int amp_x, amp_y;
			int x_coor_for_spec = 20;
			int i = 0;
			for(i = 1; i <= th_harmonic; i++, x_coor_for_spec+=3) {
				amp_x = (int)round(sqrt(pow(analysis_out_x_coeff[i], 2) + pow(analysis_out_x_coeff[i+th_harmonic], 2))/5);
				amp_y = (int)round(sqrt(pow(analysis_out_y_coeff[i], 2) + pow(analysis_out_y_coeff[i+th_harmonic], 2))/5);
				VGA_line(x_coor_for_spec, 480 - 100, x_coor_for_spec, 480 - 100 - amp_x, colors[6]);
				VGA_line(x_coor_for_spec, 480 - 30, x_coor_for_spec, 480 - 30 - amp_y, colors[6]);
			}
			// Writing coefficients to FPGA
			*pio_reset_write_ptr = 0;
			*pio_reset_write_ptr = 1;
			*pio_reset_write_ptr = 0;

			*pio_wr_en_write_ptr = 0;
			*pio_wr_addr_write_ptr = 0;

			// i = 1 because audio synthesis has no offsets
			for(i = 1; i <= th_harmonic; i++) {
				*pio_a_write_ptr = float_to_fix8(analysis_out_x_coeff[i]);
				*pio_b_write_ptr = float_to_fix8(analysis_out_x_coeff[i + th_harmonic]);
				*pio_c_write_ptr = float_to_fix8(analysis_out_y_coeff[i]);
				*pio_d_write_ptr = float_to_fix8(analysis_out_y_coeff[i + th_harmonic]);
				*pio_wr_addr_write_ptr = i-1;
				*pio_wr_en_write_ptr = 1;
				*pio_wr_en_write_ptr = 0;
			}
		} else if (!strcmp(input_buffer, "m")) {
			// clear the screen
			morph_flag = 1;
			// VGA_box (0, 0, 639, 479, 0x0000);
			
			// analysis_out_
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

int main(void)
{
  
	// for-loop counters
	int i, j, k; 

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
	// audio addresses
	// base address is control register
	audio_base_ptr = (unsigned int *)(h2p_lw_virtual_base + AUDIO_BASE);
	audio_fifo_data_ptr  = audio_base_ptr  + 1 ; // word
	audio_left_data_ptr = audio_base_ptr  + 2 ; // words
	audio_right_data_ptr = audio_base_ptr  + 3 ; // words
	// printf("audio_base_ptr       = %p\n", audio_base_ptr      );
	// printf("audio_fifo_data_ptr  = %p\n", audio_fifo_data_ptr );
	// printf("audio_left_data_ptr  = %p\n", audio_left_data_ptr );
	// printf("audio_right_data_ptr = %p\n\n", audio_right_data_ptr);

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
    pio_a_write_ptr			=(unsigned int *)(h2p_pio_virtual_base+PIO_A_OFFSET	);
	pio_b_write_ptr			=(unsigned int *)(h2p_pio_virtual_base+PIO_B_OFFSET	);
	pio_c_write_ptr			=(unsigned int *)(h2p_pio_virtual_base+PIO_C_OFFSET	);
	pio_d_write_ptr			=(unsigned int *)(h2p_pio_virtual_base+PIO_D_OFFSET	);
	pio_reset_write_ptr		=(unsigned int *)(h2p_pio_virtual_base+PIO_RESET_OFFSET);
	pio_wr_en_write_ptr		=(unsigned int *)(h2p_pio_virtual_base+PIO_WR_EN_OFFSET);
	pio_wr_addr_write_ptr	=(unsigned int *)(h2p_pio_virtual_base+PIO_WR_ADDR_OFFSET);

	// printf("Pointers initialization finished\n");
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

	// clear the screen
	VGA_box (0, 0, 639, 479, 0x0000);
	// clear the text
	VGA_text_clear();

	// thread instantiations
	// thread handles 
	pthread_t thread_r, thread_w;

	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

	// create threads
	pthread_create(&thread_r, &attr, read_input, NULL);
	pthread_create(&thread_w, &attr, write_status, NULL);

	
	while(1) {
		// //==============================================================
		// //===================== MOUSE ==================================
		// //==============================================================
		// int fd_mouse, bytes;
		// unsigned char data[3];
		// int mouse_x = 320, mouse_y = 240, mouse_x_old = 320, mouse_y_old = 240;
		// int click_x_new=0, click_y_new=0, click_x_old=0, click_y_old=0;
		// int left = 0; 
		// int right = 0; 
		// int middle;
		// signed char mouse_x_tmp, mouse_y_tmp;
		// // int first_click = 1;
		// const char *pDevice = "/dev/input/mice";
		// struct Mouse_Input mi[N];
		// int mi_count = 0; 
		// int debounce_left = 1; 

		// // Open Mouse
		// fd_mouse = open(pDevice, O_RDWR);
		// if(fd_mouse == -1)
		// {
		// 	printf("ERROR Opening %s\n", pDevice);
		// 	return -1;
		// }

		// // initialize Mouse_Input
		// for (i = 0; i < N; i++) {
		// 	mi[i].x = -1; mi[i].y = -1;
		// }

		// // draw the mouse starting point
		// VGA_circle(320, 240, 1, colors[7]);

		// printf("Receiving mouse inputs..\n");

		// while (right < 2) { // right == 2 when clicked (signals end of inputs for analysis)

		// 	// Read Mouse     
		// 	bytes = read(fd_mouse, data, sizeof(data));

		// 	if (bytes > 0)
		// 	{
		// 		left = data[0] & 0x1;
		// 		right = data[0] & 0x2;
		// 		middle = data[0] & 0x4;

		// 		mouse_x_tmp = data[1];
		// 		mouse_y_tmp = data[2];
		// 		// printf("mouse_x_tmp=%d, mouse_y_tmp=%d, left=%d, middle=%d, right=%d, ", mouse_x_tmp, mouse_y_tmp, left, middle, right);

		// 		mouse_x_old = mouse_x;
		// 		mouse_y_old = mouse_y;

		// 		mouse_x += mouse_x_tmp;
		// 		if(mouse_x > 639) {
		// 			mouse_x = 639;
		// 		}
		// 		if(mouse_x < 0) {
		// 			mouse_x = 0;
		// 		}
		// 		mouse_y -= mouse_y_tmp;
		// 		if(mouse_y > 479) {
		// 			mouse_y = 479;
		// 		}
		// 		if(mouse_y < 0) {
		// 			mouse_y = 0;
		// 		}
		// 		// printf("mouse_x=%d, mouse_y=%d, left=%d, middle=%d, right=%d\n",  mouse_x, mouse_y, left, middle, right);

		// 		// printf("mouse_x=%d, mouse_y=%d\n", mouse_x, mouse_y);

		// 		VGA_circle(mouse_x_old, mouse_y_old, 1, colors[10]);
		// 		VGA_circle(mouse_x, mouse_y, 1, colors[7]);
				
		// 		if (left && debounce_left) {
		// 			debounce_left = 0; 

		// 			click_x_old = click_x_new;
		// 			click_y_old = click_y_new;
		// 			click_x_new = mouse_x;
		// 			click_y_new = mouse_y;

		// 			printf("mouse_x = %d, mouse_y = %d\n", mouse_x, mouse_y);

		// 			// if (mi_count > 0) {
		// 			// 	if ((mi[mi_count-1].x == mi[mi_count].x) && (mi[mi_count-1].y == mi[mi_count].y)) {
		// 			// 		mi[mi_count].x = mi[mi_count-1].x++;
		// 			// 	}
		// 			// }

		// 			mi[mi_count].x = mouse_x;
		// 			mi[mi_count].y = mouse_y; 
		// 			mi_count++;

		// 			printf("mi_count: %d\n", mi_count);

		// 			if(mi_count == 1) {
		// 				;
		// 			} else { // red lines 
		// 				VGA_line(click_x_old, click_y_old, click_x_new, click_y_new, colors[0]);	
		// 				if (mi_count == N) {
		// 					VGA_line(click_x_new, click_y_new, mi[0].x, mi[0].y, colors[0]);
		// 				}
		// 			}

		// 			if (mi_count == N) break; 
		// 		} else if (!left) {
		// 			debounce_left = 1; 
		// 		}

		// 		// TODO: less than N clicks

		// 	}
		// }
		struct Mouse_Input mi[N];
		mouse_record(mi);
		//==============================================================
		// end of MOUSE ================================================
		//==============================================================

		//==============================================================
		//===================== ANALYSIS ===============================
		//==============================================================

		analysis_out_x_coeff = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));
		analysis_out_y_coeff = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));		
		analysis_out_x_coeff_2 = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));
		analysis_out_y_coeff_2 = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));
		float L = fill_coefficients(mi, 0);	
		// float* analysis_x = (float*) malloc((N+1) * sizeof(float));
		// float* analysis_y = (float*) malloc((N+1) * sizeof(float));
		// int analysis_count = 0; 

		// for (i = 0; i < N; i++) {
		// 	if (mi[i].x < 0) break;
		// 	analysis_x[i] = (float) mi[i].x;
		// 	analysis_y[i] = (float) mi[i].y;
		// 	// printf("analysis_x[%d] = %f, analysis_y[%d] = %f\n", i, analysis_x[i], i, analysis_y[i]);
		// 	analysis_count++; 
		// }
		// analysis_x[analysis_count] = (float) mi[0].x;
		// analysis_y[analysis_count] = (float) mi[0].y;

		// float L = 0.0;

		// analysis_out_x_coeff = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));
		// float* analysis_out_x_l 	= (float*) malloc(analysis_count * sizeof(float));
		
		// analysis_out_y_coeff = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));
		// float* analysis_out_y_l 	= (float*) malloc(analysis_count * sizeof(float));

		// float* analysis_out_L 		= &L; 

		// // th_harmonic = analysis_count;
		// analysis(analysis_x, analysis_y, analysis_count, th_harmonic, &analysis_out_x_coeff, &analysis_out_x_l, analysis_out_L);
		// analysis(analysis_y, analysis_x, analysis_count, th_harmonic, &analysis_out_y_coeff, &analysis_out_y_l, analysis_out_L);

		// // sanity check : x_L == y_L (allows 1% error) (x_l[i] == y_l[i])
		// // float threshold = ((*analysis_out_L) * 0.01);
		// // float error = (*analysis_out_L) - (*analysis_out_L);
		// // if (error < 0) {
		// // 	if (threshold < (-1 * error)) { // TODO: abs function may not work sometimes? 
		// // 		printf("ERROR: x_L != y_L [x_L: %2.8e, y_L: %2.8e]", x_L, y_L);
		// // 		return -1; 
		// // 	} 
		// // } else {
		// // 	if (threshold < error) {
		// // 		printf("ERROR: x_L != y_L [x_L: %2.8e, y_L: %2.8e]", x_L, y_L);
		// // 		return -1;
		// // 	}
		// // }

		// free(analysis_x); free(analysis_y);

		// for (i = 0; i < (2 * th_harmonic + 1); i++) {
		// 	printf("analysis_out_x_coeff[%d]: %f\n", i, analysis_out_x_coeff[i]);
		// }

		// for (i = 0; i < (2 * th_harmonic + 1); i++) {
		// 	printf("analysis_out_y_coeff[%d]: %f\n", i, analysis_out_y_coeff[i]);
		// }

		// printf("analysis_out_L: %f\n", L);

		//==============================================================
		// end of ANALYSIS =============================================
		//==============================================================

		// printf("===============================================\n");
		// printf("====================SYNTHESIS==================\n");
		// printf("===============================================\n");

		//==============================================================
		//===================== SYNTHESIS ==============================
		//==============================================================

		
		// printf("float_to_fix8(analysis_out_x_coeff[%d]) = 0x%x\n", 1, float_to_fix8(analysis_out_x_coeff[1]));
		// printf("float_to_fix8(analysis_out_y_coeff[%d]) = 0x%x\n", 1, float_to_fix8(analysis_out_y_coeff[1]));

		// printing spectrum
		int amp_x, amp_y;
		int x_coor_for_spec = 20;
		char x_text[40] = "x spectrum\0";
		char y_text[40] = "y spectrum\0";
		VGA_text(2, 48, x_text);
		VGA_text(2, 57, y_text);
		for(i = 1; i <= th_harmonic; i++, x_coor_for_spec+=3) {
			amp_x = (int)round(sqrt(pow(analysis_out_x_coeff[i], 2) + pow(analysis_out_x_coeff[i+th_harmonic], 2))/5);
			amp_y = (int)round(sqrt(pow(analysis_out_y_coeff[i], 2) + pow(analysis_out_y_coeff[i+th_harmonic], 2))/5);
			VGA_line(x_coor_for_spec, 480 - 100, x_coor_for_spec, 480 - 100 - amp_x, colors[6]);
			VGA_line(x_coor_for_spec, 480 - 30, x_coor_for_spec, 480 - 30 - amp_y, colors[6]);
		}
		

		// Writing coefficients to FPGA
		*pio_reset_write_ptr = 0;
		*pio_reset_write_ptr = 1;
		*pio_reset_write_ptr = 0;

		*pio_wr_en_write_ptr = 0;
		*pio_wr_addr_write_ptr = 0;

		// i = 1 because audio synthesis has no offsets
		for(i = 1; i <= th_harmonic; i++) {
			*pio_a_write_ptr = float_to_fix8(analysis_out_x_coeff[i]);
			*pio_b_write_ptr = float_to_fix8(analysis_out_x_coeff[i + th_harmonic]);
			*pio_c_write_ptr = float_to_fix8(analysis_out_y_coeff[i]);
			*pio_d_write_ptr = float_to_fix8(analysis_out_y_coeff[i + th_harmonic]);
			*pio_wr_addr_write_ptr = i-1;
			*pio_wr_en_write_ptr = 1;
			*pio_wr_en_write_ptr = 0;
			// printf("float_to_fix8(analysis_out_x_coeff[%d]) = 0x%x\n", i, float_to_fix8(analysis_out_x_coeff[i]));
			// printf("float_to_fix8(analysis_out_x_coeff[%d+th_harmonic]) = 0x%x\n", i, float_to_fix8(analysis_out_x_coeff[i + th_harmonic]));
		}

		// Drawing
		float syn_t = 0.0;
		float syn_x = 0.0, syn_y = 0.0;
		float syn_x_old = 0.0, syn_y_old = 0.0;

		syn_x = 0;
		syn_y = 0;
		syn_x += analysis_out_x_coeff[0];
		syn_y += analysis_out_y_coeff[0];
		for (i = 1; i <= th_harmonic; i++) {
			syn_x += analysis_out_x_coeff[i]    		   * cos(2.0 * M_PI * i * syn_t/L); // a_n
			syn_x += analysis_out_x_coeff[i + th_harmonic] * sin(2.0 * M_PI * i * syn_t/L); // b_n
			syn_y += analysis_out_y_coeff[i]     		   * cos(2.0 * M_PI * i * syn_t/L); // c_n
			syn_y += analysis_out_y_coeff[i + th_harmonic] * sin(2.0 * M_PI * i * syn_t/L); // d_n
		}
		// int counter = 0;
		int left_audio = 0xFFFF, right_audio = 0x6FFF;
		//// morphing stuff
		float *deltaStep_x = (float*) calloc ((2 * th_harmonic + 1) , sizeof(float));
		float *deltaStep_y = (float*) calloc ((2 * th_harmonic + 1) , sizeof(float));
		float deltaL;
		int step = 0; // steps for morphing, goes to 30 
		int morph_steps = 30;
		while(1) {
			VGA_box (0, 0, 639, 479, 0x0000);
			while(syn_t <= L) {
				syn_x_old = syn_x;
				syn_y_old = syn_y;
				
				syn_x = 0;
				syn_y = 0;	
				syn_x += analysis_out_x_coeff[0];
				syn_y += analysis_out_y_coeff[0];
				for (i = 1; i <= th_harmonic; i++) {
					syn_x += analysis_out_x_coeff[i]    		   * cos(2.0 * M_PI * i * syn_t/L); // a_n
					syn_x += analysis_out_x_coeff[i + th_harmonic] * sin(2.0 * M_PI * i * syn_t/L); // b_n
					syn_y += analysis_out_y_coeff[i]     		   * cos(2.0 * M_PI * i * syn_t/L); // c_n
					syn_y += analysis_out_y_coeff[i + th_harmonic] * sin(2.0 * M_PI * i * syn_t/L); // d_n
				}
				syn_t += 10;
				VGA_line((int)syn_x_old, (int)syn_y_old, (int)syn_x, (int)syn_y, colors[6]); // yellow 
				
			}
			syn_t = 0.0;
			// syn_t += 10;
			// if(syn_t > L) {
			// 	syn_t = 0.0;
			// }

			// redraw spectrum
			int x_coor_for_spec = 20;
			char x_text[40] = "x spectrum\0";
			char y_text[40] = "y spectrum\0";
			VGA_text(2, 48, x_text);
			VGA_text(2, 57, y_text);
			for(i = 1; i <= th_harmonic; i++, x_coor_for_spec+=3) {
				amp_x = (int)round(sqrt(pow(analysis_out_x_coeff[i], 2) + pow(analysis_out_x_coeff[i+th_harmonic], 2))/5);
				amp_y = (int)round(sqrt(pow(analysis_out_y_coeff[i], 2) + pow(analysis_out_y_coeff[i+th_harmonic], 2))/5);
				VGA_line(x_coor_for_spec, 480 - 100, x_coor_for_spec, 480 - 100 - amp_x, colors[6]);
				VGA_line(x_coor_for_spec, 480 - 30, x_coor_for_spec, 480 - 30 - amp_y, colors[6]);
			}
			

			// printf("syn_x = %d, syn_y = %d\n", (int)syn_x, (int)syn_y);
			if(redraw_flag) {
				redraw_flag = 0;
				// clear the screen
				VGA_box (0, 0, 639, 479, 0x0000);
				break;
			}

			if(morph_flag) {
				morph_flag = 0; 
				step = 0;
				// new mouse input struct 
				struct Mouse_Input mi_new[N];
				mouse_record(mi_new);
				float L_new = fill_coefficients(mi_new, 1);  // later morph distance too
				deltaL = (L_new - L)/morph_steps;
				// create a delta array that adds 
				deltaStep_x[0] = (analysis_out_x_coeff_2[0] - analysis_out_x_coeff[0])/morph_steps;
				deltaStep_y[0] = (analysis_out_y_coeff_2[0] - analysis_out_y_coeff[0])/morph_steps;
				for(i = 1; i <= th_harmonic; i++ ) {
					deltaStep_x[i] = (analysis_out_x_coeff_2[i] - analysis_out_x_coeff[i])/morph_steps;
					deltaStep_x[i+th_harmonic] = (analysis_out_x_coeff_2[i+th_harmonic] - analysis_out_x_coeff[i+th_harmonic])/morph_steps;
					deltaStep_y[i] = (analysis_out_y_coeff_2[i] - analysis_out_y_coeff[i])/morph_steps;
					deltaStep_y[i+th_harmonic] = (analysis_out_y_coeff_2[i+th_harmonic] - analysis_out_y_coeff[i+th_harmonic])/morph_steps;
				}
				// increment analysis_out_x_coeff by deltaStep
			}

			if(step < morph_steps) {
				analysis_out_x_coeff[0] += deltaStep_x[0];
				analysis_out_y_coeff[0] += deltaStep_y[0];
				for(i = 1; i <= th_harmonic; i++ ) {
					analysis_out_x_coeff[i] += deltaStep_x[i];
					analysis_out_x_coeff[i+th_harmonic] += deltaStep_x[i+th_harmonic];
					analysis_out_y_coeff[i] += deltaStep_y[i];
					analysis_out_y_coeff[i+th_harmonic] += deltaStep_y[i+th_harmonic];
				}
				L += deltaL;
				step++;
			}

						// Writing coefficients to FPGA
			*pio_reset_write_ptr = 0;
			*pio_reset_write_ptr = 1;
			*pio_reset_write_ptr = 0;

			*pio_wr_en_write_ptr = 0;
			*pio_wr_addr_write_ptr = 0;

			// i = 1 because audio synthesis has no offsets
			for(i = 1; i <= th_harmonic; i++) {
				*pio_a_write_ptr = float_to_fix8(analysis_out_x_coeff[i]);
				*pio_b_write_ptr = float_to_fix8(analysis_out_x_coeff[i + th_harmonic]);
				*pio_c_write_ptr = float_to_fix8(analysis_out_y_coeff[i]);
				*pio_d_write_ptr = float_to_fix8(analysis_out_y_coeff[i + th_harmonic]);
				*pio_wr_addr_write_ptr = i-1;
				*pio_wr_en_write_ptr = 1;
				*pio_wr_en_write_ptr = 0;
				// printf("float_to_fix8(analysis_out_x_coeff[%d]) = 0x%x\n", i, float_to_fix8(analysis_out_x_coeff[i]));
				// printf("float_to_fix8(analysis_out_x_coeff[%d+th_harmonic]) = 0x%x\n", i, float_to_fix8(analysis_out_x_coeff[i + th_harmonic]));
			}
 		} // end while(1)

		//==============================================================
		// end of SYNTHESIS ============================================
		//==============================================================
	}

} // end main

// Fourier analysis 
void analysis (float* x, float* y, int K, int n, float** out_coeff, float** out_l, float* out_L) {
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
    // for(i = 0; i < K; i++) {
    //     printf("dx[%d] = %f\n", i, x_j[i]);

    // }
    for(i = 0; i < K; i++) {
        // printf("dl[%d] = %f\n", i, l_j[i]);
    }
    // for(i = 0; i < K; i++) {
    //     printf("al[%d] = %f\n", i, al_j[i]);
    // }   
        

    // compute offset a0
    float a0 = x[0]*al_j[0] + 0.5*x_j[0]*al_j[0]*al_j[0]/l_j[0];
    for(i = 1; i < K; i++) {
        float sum = (x[i]-(x_j[i]*al_j[i-1]/l_j[i]))*(al_j[i]-al_j[i-1]) + ((x_j[i]/l_j[i])*(al_j[i]*al_j[i] - al_j[i-1]*al_j[i-1])) / 2;
        // printf("sum = %f\n", sum);
        a0 += sum;        
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
        // printf("a%d = %f\n", harm, a_n[harm-1]);
        // printf("b%d = %f\n", harm, b_n[harm-1]);
    }

    float* coeff = (float*) malloc ((2*n+1)*sizeof(float));
    coeff[0] = a0;
    for(i = 0; i < n; i++) {
        coeff[i+1] = a_n[i];
        coeff[i+1+n] = b_n[i];
		// printf("a_n[%d] = %f\n", i, a_n[i]);
		// printf("b_n[%d] = %f\n", i, b_n[i]);
    }
    
    *out_coeff = coeff;
    *out_l = l_j;
    *out_L = L;
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


void mouse_record(struct Mouse_Input* mi) {
		//==============================================================
		//===================== MOUSE ==================================
		//==============================================================
		int fd_mouse, bytes;
		unsigned char data[3];
		int mouse_x = 320, mouse_y = 240, mouse_x_old = 320, mouse_y_old = 240;
		int click_x_new=0, click_y_new=0, click_x_old=0, click_y_old=0;
		int left = 0; 
		int right = 0; 
		int middle;
		signed char mouse_x_tmp, mouse_y_tmp;
		// int first_click = 1;
		const char *pDevice = "/dev/input/mice";
		// struct Mouse_Input mi[N];
		int mi_count = 0; 
		int debounce_left = 1; 
		int i;
		
		// Open Mouse
		fd_mouse = open(pDevice, O_RDWR);
		if(fd_mouse == -1)
		{
			printf("ERROR Opening %s\n", pDevice);
			// return -1;
		}

		// initialize Mouse_Input
		for (i = 0; i < N; i++) {
			mi[i].x = -1; mi[i].y = -1;
		}

		// draw the mouse starting point
		VGA_circle(320, 240, 1, colors[7]);

		printf("Receiving mouse inputs..\n");

		while (right < 2) { // right == 2 when clicked (signals end of inputs for analysis)

			// Read Mouse     
			bytes = read(fd_mouse, data, sizeof(data));

			if (bytes > 0)
			{
				left = data[0] & 0x1;
				right = data[0] & 0x2;
				middle = data[0] & 0x4;

				mouse_x_tmp = data[1];
				mouse_y_tmp = data[2];
				// printf("mouse_x_tmp=%d, mouse_y_tmp=%d, left=%d, middle=%d, right=%d, ", mouse_x_tmp, mouse_y_tmp, left, middle, right);

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
				// printf("mouse_x=%d, mouse_y=%d, left=%d, middle=%d, right=%d\n",  mouse_x, mouse_y, left, middle, right);

				// printf("mouse_x=%d, mouse_y=%d\n", mouse_x, mouse_y);

				VGA_circle(mouse_x_old, mouse_y_old, 1, colors[10]);
				VGA_circle(mouse_x, mouse_y, 1, colors[7]);
				
				if (left && debounce_left) {
					debounce_left = 0; 

					click_x_old = click_x_new;
					click_y_old = click_y_new;
					click_x_new = mouse_x;
					click_y_new = mouse_y;

					printf("mouse_x = %d, mouse_y = %d\n", mouse_x, mouse_y);

					// if (mi_count > 0) {
					// 	if ((mi[mi_count-1].x == mi[mi_count].x) && (mi[mi_count-1].y == mi[mi_count].y)) {
					// 		mi[mi_count].x = mi[mi_count-1].x++;
					// 	}
					// }

					mi[mi_count].x = mouse_x;
					mi[mi_count].y = mouse_y; 
					mi_count++;

					printf("mi_count: %d\n", mi_count);

					if(mi_count == 1) {
						;
					} else { // red lines 
						VGA_line(click_x_old, click_y_old, click_x_new, click_y_new, colors[0]);	
						if (mi_count == N) {
							VGA_line(click_x_new, click_y_new, mi[0].x, mi[0].y, colors[0]);
						}
					}

					if (mi_count == N) break; 
				} else if (!left) {
					debounce_left = 1; 
				}

				// TODO: less than N clicks

			}
		}
}

float fill_coefficients (struct Mouse_Input* mi, int morph) {
		float* analysis_x = (float*) malloc((N+1) * sizeof(float));
		float* analysis_y = (float*) malloc((N+1) * sizeof(float));
		int analysis_count = 0; 
		int i ;
		for (i = 0; i < N; i++) {
			if (mi[i].x < 0) break;
			analysis_x[i] = (float) mi[i].x;
			analysis_y[i] = (float) mi[i].y;
			// printf("analysis_x[%d] = %f, analysis_y[%d] = %f\n", i, analysis_x[i], i, analysis_y[i]);
			analysis_count++; 
		}
		analysis_x[analysis_count] = (float) mi[0].x;
		analysis_y[analysis_count] = (float) mi[0].y;

		float L = 0.0;

		// analysis_out_x_coeff = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));
		float* analysis_out_x_l 	= (float*) malloc(analysis_count * sizeof(float));
		
		// analysis_out_y_coeff = (float*) malloc((2 * th_harmonic + 1) * sizeof(float));
		float* analysis_out_y_l 	= (float*) malloc(analysis_count * sizeof(float));

		float* analysis_out_L 		= &L; 

		// th_harmonic = analysis_count;
		if(!morph) {
			analysis(analysis_x, analysis_y, analysis_count, th_harmonic, &analysis_out_x_coeff, &analysis_out_x_l, analysis_out_L);
			analysis(analysis_y, analysis_x, analysis_count, th_harmonic, &analysis_out_y_coeff, &analysis_out_y_l, analysis_out_L);
		} else {
			analysis(analysis_x, analysis_y, analysis_count, th_harmonic, &analysis_out_x_coeff_2, &analysis_out_x_l, analysis_out_L);
			analysis(analysis_y, analysis_x, analysis_count, th_harmonic, &analysis_out_y_coeff_2, &analysis_out_y_l, analysis_out_L);
		}

		// sanity check : x_L == y_L (allows 1% error) (x_l[i] == y_l[i])
		// float threshold = ((*analysis_out_L) * 0.01);
		// float error = (*analysis_out_L) - (*analysis_out_L);
		// if (error < 0) {
		// 	if (threshold < (-1 * error)) { // TODO: abs function may not work sometimes? 
		// 		printf("ERROR: x_L != y_L [x_L: %2.8e, y_L: %2.8e]", x_L, y_L);
		// 		return -1; 
		// 	} 
		// } else {
		// 	if (threshold < error) {
		// 		printf("ERROR: x_L != y_L [x_L: %2.8e, y_L: %2.8e]", x_L, y_L);
		// 		return -1;
		// 	}
		// }

		free(analysis_x); free(analysis_y);
		return L;
}