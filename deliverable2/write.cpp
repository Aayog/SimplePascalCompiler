#include "utilities.h"
extern std::ofstream outFile;
extern std::map<std::string, type> symbol_table;
extern std::string get_type(type string_type);

void write_expr(char id_name[])
{
   std::string theType = get_type(symbol_table[id_name]);
   outFile << "write " << id_name << ", " << theType << std::endl;
}
