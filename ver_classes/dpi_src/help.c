/*
*  File            :   help.c
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   C
*  Description     :   This help dpi functions
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

#include "../dpi_h/dpiheader.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

int get_current_time() {
    struct timeval t;

    gettimeofday(&t,NULL);

    return t.tv_sec*1000+t.tv_usec/1000;
}

int run_other_app(const char * prog_param) {
    vpi_printf("Start program: %s %d\n", prog_param, get_current_time());
    system(prog_param);
    vpi_printf("Complete program: %s %d\n", prog_param, get_current_time());
}
