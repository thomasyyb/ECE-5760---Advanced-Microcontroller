#include "iio.c"				// for image input/output


int main(int argc, char *argv[])
{
	/* Load input image */
	int w, h, pixeldim;
	float *im = iio_read_image_float_vec(argv[argc-1], &w, &h, &pixeldim);
	double *imdouble = malloc(w*h*sizeof(double));
	printf("\nINPUT IMAGE:\n\n\t%s\n\tDimensions: %d x %d pixeles. Channels: %d.\n",argv[argc-1],w,h,pixeldim);
	for ( int i=0; i<w*h; i++ ) {
		imdouble[i] = (double)im[i];
	}
	
    return 0;
}