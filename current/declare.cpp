#include <iostream>
#include <fstream>
#include "symbol_table.h"

extern std::ofstream outFile;
extern SymbolTable st;

void decl_id (char identifier[])
{
     /* Generate code for declaration. */
     auto type = "integer";
	if(st.insert(identifier, "", type))
    		outFile << "declare " << identifier << ", " << type << std::endl;
	else
		outFile << "Error declaring " <<identifier << std::endl;
}

  
  
  
