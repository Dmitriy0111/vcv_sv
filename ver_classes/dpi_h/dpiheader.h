/* MTI_DPI */

/*
 * Copyright 2002-2016 Mentor Graphics Corporation.
 *
 * Note:
 *   This file is automatically generated.
 *   Please do not edit this file - you will lose your edits.
 *
 * Settings when this file was generated:
 *   PLATFORM = 'win64'
 */
#ifndef INCLUDED_DPIHEADER
#define INCLUDED_DPIHEADER

#ifdef __cplusplus
#define DPI_LINK_DECL  extern "C" 
#else
#define DPI_LINK_DECL 
#endif

#include "svdpi.h"



DPI_LINK_DECL DPI_DLLESPEC
int
dpi_create_image(
    int width,
    int height);

DPI_LINK_DECL DPI_DLLESPEC
int
dpi_free_image();

DPI_LINK_DECL DPI_DLLESPEC
int
dpi_get_pix(
    int pix_pos,
    unsigned int* R,
    unsigned int* G,
    unsigned int* B);

DPI_LINK_DECL DPI_DLLESPEC
int
dpi_open_image(
    const char* path,
    int width,
    int height);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_save_image_bmp(
    const char* path,
    int width,
    int height);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_save_image_jpg(
    const char* path,
    int width,
    int height);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_save_image_png(
    const char* path,
    int width,
    int height);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_save_image_tga(
    const char* path,
    int width,
    int height);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_store_img(
    int Width,
    int Height,
    const svOpenArrayHandle R,
    const svOpenArrayHandle G,
    const svOpenArrayHandle B);

DPI_LINK_DECL DPI_DLLESPEC
int
get_current_time();

#endif 
