
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


// Fourier synthesis
/*
    K : the size of the l array 
	n : nth harmonic 
*/
void synthesis (float** coeff, float** l, float* L, int K, int n, float scale_l, float out) {

	int i; 
	float x_tmp = 0.0; // accumulate x 

    // int l_size =  0.0;sizeof(l) / sizeof(**l);
    // printf("l_size: %d\n", l_size);
    printf("K: %d\n", K);

	for (i = 0; i < n; i++) {
		if (i == 0) {
			x_tmp += coeff[i];
		} else {
			x_tmp = coeff[i] * cos(2*M_PI*i*l[i-1]/L); // a_n
			x_tmp = coeff[i + n] * sin(2*M_PI*i*l[i-1+n]/L); // b_n
		}
	}


}

int main(int argc, char*argv[]) {
    int K = 6; 



    synthesis(x, y, K, 10);

    return 0;
}