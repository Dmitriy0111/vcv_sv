/*
*  File            :   image.c
*  Autor           :   Vlasov D.V
*  Data            :   01.06.2019
*  Language        :   C
*  Description     :   This image dpi functions
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

#include "../dpi_h/dpiheader.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"

// image matrix pointer
unsigned char *image_p;
/*
    function for opening  image file
*/
int dpi_open_image(const char* path, int width, int height) {
    int channels = 3;
    image_p = stbi_load (
                            path,
                            &width,
                            &height,
                            &channels,
                            STBI_rgb
                        );
    vpi_printf("Opening input image %s\n", path);
    if( image_p == NULL ) {
        vpi_printf("[ Error ] Input image %s is not open.\n", path);
        return 1;
    }
    else {
        vpi_printf("[ Pass  ] Input image %s is open.\n", path);
        return 0;
    }
}
/*
    function for getting pixel from image
*/
int dpi_get_pix(int pix_pos, unsigned int * R, unsigned int * G, unsigned int * B) {
    if(image_p == NULL) {
        vpi_printf("[ Error ] Input image is NULL\n");
        return 0;
    }
    *R = image_p[pix_pos+0];
    *G = image_p[pix_pos+1];
    *B = image_p[pix_pos+2];
    return 1;
}
/*
    function for closing image matrix
*/
int dpi_free_image() {
    stbi_image_free(image_p);
    return 1;
}
/*
    function for creating image matrix
*/
int dpi_create_image(int width, int height) {
    image_p = (unsigned char *) malloc(sizeof(unsigned char ) * (width*height*3));
    if(image_p == NULL) {
        vpi_printf("[ Error ] : Creating image array is not successful.\n");
        return 0;
    }
    return 1;
}
/*
    function for storing RGB matrix to image matrix
*/
void dpi_store_img(int Width, int Height, svOpenArrayHandle R, svOpenArrayHandle G, svOpenArrayHandle B) {
    int i,j;
    for( i = 0 ; i < Width ; i++ )
        for( j = 0 ; j < Height ; j++ ) {
            image_p[ ( ( i + j * Width ) * 3 ) + 0 ] = *(int**)svGetArrElemPtr(R,i,j);
            image_p[ ( ( i + j * Width ) * 3 ) + 1 ] = *(int**)svGetArrElemPtr(G,i,j);
            image_p[ ( ( i + j * Width ) * 3 ) + 2 ] = *(int**)svGetArrElemPtr(B,i,j);
        }
}
/*
    function for saving image file in jpg format
*/
void dpi_save_image_jpg(const char* path, int width, int height) {
    if(stbi_write_jpg(path, width, height, STBI_rgb, image_p, 200))
        vpi_printf("[ Pass  ] Saving image to file %s is successful.\n", path);
    else
        vpi_printf("[ Error ] Saving image to file %s is not successful.\n", path);
}
/*
    function for saving image file in png format
*/
void dpi_save_image_png(const char* path, int width, int height) {
    if(stbi_write_png(path, width, height, STBI_rgb, image_p, 0))
        vpi_printf("[ Pass  ] Saving image to file %s is successful.\n", path);
    else
        vpi_printf("[ Error ] Saving image to file %s is not successful.\n", path);
}
/*
    function for saving image file in bmp format
*/
void dpi_save_image_bmp(const char* path, int width, int height) {
    if(stbi_write_bmp(path, width, height, STBI_rgb, image_p))
        vpi_printf("[ Pass  ] Saving image to file %s is successful.\n", path);
    else
        vpi_printf("[ Error ] Saving image to file %s is not successful.\n", path);
}
/*
    function for saving image file in tga format
*/
void dpi_save_image_tga(const char* path, int width, int height) {
    if(stbi_write_tga(path, width, height, STBI_rgb, image_p))
        vpi_printf("[ Pass  ] Saving image to file %s is successful.\n", path);
    else
        vpi_printf("[ Error ] Saving image to file %s is not successful.\n", path);
}
