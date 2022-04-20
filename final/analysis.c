/*
    (x, y) := list of coordinates (beginning coordinate should be the same as end coordinate)
    K      := size of list of coordinates
    n      := number of harmonics desired

    returns array {a0, an, bn} concatenated an, bn have size of n, array is length 2n+1

    NOTE:
    For x dimension coefficients, could reverse input and get y dimension coefficients
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>



// convert float to integer 

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


// for n=1:N
//     tempa = dx(1)/dL(1)*(cos(2*pi*n*Lcum(1)/L)-1);
//     tempb = dx(1)/dL(1)*sin(2*pi*n*Lcum(1)/L);
//     tempc = dy(1)/dL(1)*(cos(2*pi*n*Lcum(1)/L)-1);
//     tempd = dy(1)/dL(1)*sin(2*pi*n*Lcum(1)/L);
//     for i=2:K
//         tempa = tempa + ...
//             dx(i)/dL(i)*(cos(2*pi*n*Lcum(i)/L)-cos(2*pi*n*Lcum(i-1)/L));
//         tempb = tempb + ...
//             dx(i)/dL(i)*(sin(2*pi*n*Lcum(i)/L)-sin(2*pi*n*Lcum(i-1)/L)); 
//         tempc = tempc + ...
//             dy(i)/dL(i)*(cos(2*pi*n*Lcum(i)/L)-cos(2*pi*n*Lcum(i-1)/L));
//         tempd = tempd + ...
//             dy(i)/dL(i)*(sin(2*pi*n*Lcum(i)/L)-sin(2*pi*n*Lcum(i-1)/L));  
//     end
//     a(n) = tempa * L /(2*pi^2*n^2);
//     b(n) = tempb * L /(2*pi^2*n^2);
//     c(n) = tempc * L /(2*pi^2*n^2);
//     d(n) = tempd * L /(2*pi^2*n^2);
// end
}

int main(int argc, char*argv[]) {
    int K = 6; 

    // p(1,:) = [0 0];
    // p(2,:) = [1.5 0];
    // p(3,:) = [1.5 .5];
    // p(4,:) = [.5 .5];
    // p(5,:) = [.5 1.25];
    // p(6,:) = [0 1.25];
    float x[7] = {0.0, 1.5, 1.5, 0.5, 0.5, 0.0, 0.0};
    float y[7] = {0.0, 0.0, 0.5, 0.5, 1.25, 1.25, 0.0};


    float* a_n = analysis(x, y, K, 10);
    // printf("%f\n", a_n[0]);
    // int i;
    // for(i = 0; i < K; i++) {
        
    // }
    return 0;
}