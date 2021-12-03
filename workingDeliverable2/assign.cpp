#include <iostream>
#include <fstream>
#include <string>
#include "symbol_table.h"

extern std::ofstream outFile;
extern SymbolTable st;

void assign (char target[], char source[])
{
     /* Generate code for assignment. */
     if (st.exists(target)) {
     	if (st.getType(target).equals("char")) {
     		source.insert(source.length(), 1, '\'');
     		source.insert(0, 1, '\'');
     	}
     	st.modify(target, source, st.getType(target));
     	outFile << "store " << source << ", " << target << std::endl;
	 } else outFile << target << " does not exist in current context" << std::endl;
}

  
  
  
