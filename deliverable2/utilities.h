#include <map>
#include <string>
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>


enum type{TYPE_INT, TYPE_CHAR, TYPE_BOOL, TYPE_REAL};
std::string get_type(type string_type);
char *tempi();
char *tempr();
char *tempb();
char *tempc();
char *temp_if_label();
char *temp_while_start_label();
char*temp_while_end_label();
char *int_to_real_coercion(char symbol[]);
char *real_to_int_coercion(char symbol[]);
int is_it_bool_literal(char symbol[]);

