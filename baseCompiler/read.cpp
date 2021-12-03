#include <stdio.h>
#include <iostream>
#include <fstream>
#include "symbol_table.h"

extern std::ofstream outFile;
extern SymbolTable st;

void read_id (char id_name[])
{
     if (st.exists(id_name)) {
          outFile << "read " << id_name << ", " << st.getType(id_name) << std::endl;
     } else {
          outFile << id_name << " does not exist in current context." << std::endl;
     }
}
