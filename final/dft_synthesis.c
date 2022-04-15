/*
* DFT calculation using direct digital synthesis (DDS)
* DDS reference page: https://vanhunteradams.com/DDS/DDS.html#Examples-and-Analysis 
* 
* compile with: gcc dft_synthesis.c -O2 -lm
* run with:     /a.out 
*/

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

// sine DDS lookup table variables 
/* Fs (sampling frequency) : the rate at the new sample will be sent to the VGA; once set, 
*  do not change
*/ 
#define Fs                  25000000            // TODO: set sampling  frequency 
#define two32               4294967296.0        // 2^32
#define sine_table_size     256
volatile _Accum sine_table[sine_table_size];    // _Accum = s16.15 fixed point supported by gcc
#define Fout                200.0               // frequency we want
volatile unsigned int DDS_increment = 34360;    // Fout / Fs * 2^32 (later change this so shifting op)
volatile _Accum x_max_ampitude = 200 // 640 x 480 

void main(void)
{

    // Generate the sine table 
    int i;
    for (i = 0; i < sine_table_size; i++) {
        sine_table[i] = (_Accum)(sin((float)i * 6.283 / (float)sine_table_size));
    }

    

}


