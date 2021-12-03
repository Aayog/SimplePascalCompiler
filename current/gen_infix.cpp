#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
extern std::ofstream outFile;

char * gen_infix(char operand1[], char op[], char operand2[])
{
  static int max_temp=0;
  static char tempname[30];
  
  char tempop[8];
  
  if ( strcmp( op, "Add")==0 )
    strcpy(tempop,"iadd" );
  else if ( strcmp( op, "Sub") == 0)
	  strcpy(tempop,"isub" );
  else if ( strcmp( op, "Mult") == 0)
    strcpy(tempop, "imult");
  else if ( strcmp( op, "Div") == 0)
    strcpy(tempop, "idiv");
  else
    strcpy(tempop, "imod");
  max_temp++;
  sprintf(tempname, "&tempi%d" ,max_temp);
  outFile << tempop << " " << operand1 << ", " << operand2 << ", " << tempname << std::endl;
  return (tempname);
}
