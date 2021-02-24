/*
*  File            :   dpi_test.c
*  Autor           :   Vlasov D.V
*  Data            :   12.05.2020
*  Language        :   C
*  Description     :   This dpi functions
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

#include "dpi_test.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int ** tda;

void dpi_get_dv(int * val) {
    scanf("%d", val);
}

void dpi_create_tda(int size_0, int size_1) {
    int i;
    tda = (int **) malloc(sizeof(int *) * (size_0));
    for( i = 0 ; i < size_0 ; i++ )
        tda[i] = (int *) malloc(sizeof(int) * (size_1));
}

void dpi_free_tda() {
    free(tda);
}

void dpi_print_tda(int size_0, int size_1) {
    int i;
    int j;
    for( i = 0 ; i < size_0 ; i++ )
        for( j = 0 ; j < size_1 ; j++ ) {
            vpi_printf("tda[%4d][%4d] = %d\n",i,j,tda[i][j]);
        }
}

void dpi_rand_tda(int size_0, int size_1) {
    int i;
    int j;
    for( i = 0 ; i < size_0 ; i++ )
        for( j = 0 ; j < size_1 ; j++ ) {
            int val = rand() % 100;
            tda[i][j] = val;
            vpi_printf("tda[%4d][%4d] = %x\n",i,j,tda[i][j]);
        }
}

int dpi_ret_e_tda(int pos_0, int pos_1) {
    return tda[pos_0][pos_1];
}

void dpi_get_e_tda(int pos_0, int pos_1, int * element) {
    *element = tda[pos_0][pos_1];
}

void dpi_get_tda(svOpenArrayHandle arr, int size_0, int size_1) {
    int i;
    int j;
    for( i = 0 ; i < size_0 ; i++ )
        for( j = 0 ; j < size_1 ; j++ )
            *(int**)svGetArrElemPtr(arr,i,j) = tda[i][j];
}

void dpi_set_tda(svOpenArrayHandle arr, int size_0, int size_1) {
    int i;
    int j;
    for( i = 0 ; i < size_0 ; i++ )
        for( j = 0 ; j < size_1 ; j++ )
            tda[i][j] = *(int**)svGetArrElemPtr(arr,i,j);
}

int dpi_comp_arr(svOpenArrayHandle arr, int size_0, int size_1) {
    int arr_element;
    int i;
    int j;
    for( i = 0 ; i < size_0 ; i++ )
        for( j = 0 ; j < size_1 ; j++ ) {
            arr_element = *(int**)svGetArrElemPtr(arr,i,j);
            if( tda[i][j] != arr_element )
                vpi_printf("Error! tda_c[%d][%d] = %d, tda_sv[%d][%d] = %d\n",i,j,tda[i][j],i,j,arr_element);
        }
}
