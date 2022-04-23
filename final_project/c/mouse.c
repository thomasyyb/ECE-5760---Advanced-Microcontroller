///////////////////////////////////////////////////////////////////////
// Mouse test from 
// http://stackoverflow.com/questions/11451618/how-do-you-read-the-mouse-button-state-from-dev-input-mice
//
// Native ARM GCC Compile: gcc mouse_test.c -o mouse
//
///////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char** argv)
{
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

    int mouse_x = 320, mouse_y = 240;
    int left, middle, right;
    signed char mouse_x_tmp, mouse_y_tmp;
    while(1)
    {
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
        }   
    }
    return 0; 
}
	