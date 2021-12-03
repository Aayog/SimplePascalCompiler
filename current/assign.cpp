#include <iostream>
#include <fstream>
#include "symbol_table.h"

extern std::ofstream outFile;
extern SymbolTable st;

void assign (char target[], char source[])
{
     /* Generate code for assignment. */
     if (st.exists(target)) {
		 st.modify(target, source, st.getType(target));
		 outFile << "store " << source << ", " << target << std::endl;
	 } else outFile << target << " does not exist in current context" << std::endl;
}

  
  
  
