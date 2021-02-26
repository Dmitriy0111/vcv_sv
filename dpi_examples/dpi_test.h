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
#ifndef INCLUDED_DPI_TEST
#define INCLUDED_DPI_TEST

#ifdef __cplusplus
#define DPI_LINK_DECL  extern "C" 
#else
#define DPI_LINK_DECL 
#endif

#include "svdpi.h"



DPI_LINK_DECL DPI_DLLESPEC
int
dpi_comp_arr(
    const svOpenArrayHandle arr,
    int size_0,
    int size_1);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_create_tda(
    int size_0,
    int size_1);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_free_tda();

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_get_dv(
    int* val);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_get_e_tda(
    int pos_0,
    int pos_1,
    int* element);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_get_tda(
    const svOpenArrayHandle arr,
    int size_0,
    int size_1);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_print_tda(
    int size_0,
    int size_1);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_rand_tda(
    int size_0,
    int size_1);

DPI_LINK_DECL DPI_DLLESPEC
int
dpi_ret_e_tda(
    int pos_0,
    int pos_1);

DPI_LINK_DECL DPI_DLLESPEC
void
dpi_set_tda(
    const svOpenArrayHandle arr,
    int size_0,
    int size_1);

#endif 
