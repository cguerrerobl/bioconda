/*
    NMF, file: print_error_nmf.c
    Copyright (C) 2013 François Mathieu, Eric Frichot

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#include "print_snmf.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// print_error_nmf

void print_error_nmf(char* msg, char*file, int n) 
{
	printf("\n");
	if (!strcmp(msg,"cmd")) {
	        printf("ERROR: no value for %s.\n\n",file);
		print_help_snmf();
	} else if (!strcmp(msg,"option")) {
	        printf("ERROR: the following option is mandatory: %s.\n\n",file);
		print_help_snmf();
	} else if (!strcmp(msg,"missing")) {
	        printf("ERROR: one of the following options is missing or not positive: -K / -c / -i / -m / -p.\n\n");
		print_help_snmf();
	} else if (!strcmp(msg,"missing")) {
	        printf("ERROR: one of the following options is missing: -e / -a / -m \n\n");
		print_help_snmf();
	} else if (!strcmp(msg,"basic")) {
	        printf("ERROR: the command is not written correctly.\n\n");
		print_help_snmf();
	} else if (!strcmp(msg,"specific")) {
	        printf("ERROR: %s.\n\n",file);
		print_help_snmf();
	} else {
		printf("ERROR: Internal error.\n");
	}

	printf("\n");
	exit(1); 

}
