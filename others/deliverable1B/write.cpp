#include <stdio.h> 
#include <iostream>
#include <fstream>
#include "type.h"
extern std::ofstream outFile;
extern void error(const char msg[]);
extern ID typeCheck(std::string str);
extern const char* typeToString(Type type);
void write_expr(char id_name[])
{
  ID expr = typeCheck(id_name);
  if (expr.type == DNE || expr.type == Boolean) {
    error("UNDECLARED VARIABLE"); // check if it's an error
  }	
  outFile << "write " << expr.name << ", " << typeToString(expr.type) << std::endl;
}
