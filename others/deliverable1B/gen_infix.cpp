#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "type.h"
using namespace std;

string temp(char type);
extern std::ofstream outFile;
// find all the couts
extern void error( const char msg[]);
extern ID typeCheck(string input);
extern Type lookupID(string name);
extern bool isInteger(string input);
extern bool isReal(string input);
extern int isBoolean(string input);
extern void decl_id (string, Type type);
extern string rtoi(string identifier);
extern string itor(string identifier); 
extern string temp(Type type);
char * gen_infix(char operand1[], char op[], char operand2[])
{
  string result;
  char tempop[8];

  ID op1 = typeCheck(operand1);
  if (op1.type == Boolean) {
     op1.type == Integer;
  } else if (op1.type == Char) {
     error("INVALID TYPE");
  }

  ID op2 = typeCheck(operand2);
  if (op2.type == Boolean) {
     op2.type == Integer;
  } else if (op2.type == Char) {
     error("INVALID TYPE");
  } 

  if ((op1.type == Integer && op2.type == Integer) || strcmp(op,"Mod") == 0) {
     if (op1.type != Integer) {	
	op1.name.assign(rtoi(op1.name));
     }       
     if (op2.type != Integer) {
	op2.name.assign(rtoi(op2.name));
     }
     sprintf(tempop,"%s","i"); //operator type
     //declares the temp that stores the result
     //max_temp++;
     //sprintf(tempname, "&tempi%d" ,max_temp);
     result.assign(temp(Integer));
     decl_id(result,Integer);
  } else {
        if (op1.type != Real) {
	  op1.name.assign(itor(op1.name));
	}	
	if (op2.type != Real) {
	  op2.name.assign(itor(op2.name));
	}
     sprintf(tempop,"%s","r"); //operator type
     //declares the temp that stores the result
     //max_temp++;
     //sprintf(tempname, "&tempr%d" ,max_temp); 
     result.assign(temp(Real));
     decl_id(result,Real);
  }

  if ( strcmp( op, "Add") == 0 ) { 
     sprintf(tempop,"%s%s",tempop,"add");
  } else if (strcmp(op, "Sub") == 0) { 
     sprintf(tempop,"%s%s",tempop,"sub");
  } else if (strcmp(op, "Mult") == 0) {
     sprintf(tempop,"%s%s",tempop,"mult");
  } else if (strcmp(op, "Divide") == 0) {
     sprintf(tempop,"%s%s",tempop,"div");
  } else { // mod
     sprintf(tempop,"%s%s",tempop,"mod");
  }

  // prints 3 address operation
  outFile << tempop << " " << op1.name << ", " << op2.name << ", " << result << std::endl;
  return strdup(result.c_str());
}
