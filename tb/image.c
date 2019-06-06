/*
*  File            :   image.c
*  Autor           :   Vlasov D.V
*  Data            :   01.06.2019
*  Language        :   C
*  Description     :   This dpi functions
*  Copyright(c)    :   2019 Vlasov D.V
*/

#include "image.h"
#include <stdio.h>
#include <string.h>
#define STB_IMAGE_IMPLEMENTATION
#include "../stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "../stb/stb_image_write.h"

unsigned char *image_p;     // image pointer
/*
    function for open image file
*/
int open_image(const char* path, int width, int height){
    int channels = 3;
    image_p = stbi_load (
                            path,
                            &width,
                            &height,
                            &channels,
                            STBI_rgb
                        );
    printf("Opening input image\n");
    if( image_p == NULL ){
        printf("[ Error ] Input image is not open.\n");
        return 0;
    }
    else{
        printf("[ Pass  ] Input image is open.\n");
        return 1;
    }
}
/*
    function for loading pixel from image
*/
int load_pix(int pix_pos, unsigned int * R, unsigned int * G, unsigned int * B){
    if(image_p == NULL){
        printf("[ Error ] Input image is NULL\n");
        return 0;
    }
    *R = image_p[pix_pos+0];
    *G = image_p[pix_pos+1];
    *B = image_p[pix_pos+2];
    return 1;
}
/*
    function for closing input array
*/
int free_image(){
    stbi_image_free(image_p);
    return 1;
}
/*
    function for creating output array
*/
svLogic create_image(int width, int height){
    image_p = (unsigned char *) malloc(sizeof(unsigned char ) * (width*height*3));
}
/*
    function for storing pixel in output array
*/
svLogic store_pix(int pix_pos, int R, int G, int B){
    if(image_p == NULL){
        printf("[ Error ] : Storing pixel to output image is not successful.\n");
    }
    image_p[pix_pos+0] = R;
    image_p[pix_pos+1] = G;
    image_p[pix_pos+2] = B;
}
/*
    function for saving image file
*/
svLogic save_image(const char* path, int width, int height){
    if(stbi_write_jpg(path, width, height, STBI_rgb,image_p, 200))
        printf("[ Pass  ] Saving image to file %s is successful.\n", path);
    else
        printf("[ Error ] Saving image to file %s is not successful.\n", path);
}
