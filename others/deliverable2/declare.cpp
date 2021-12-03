#include "utilities.h"

extern std::ofstream outFile;
extern void error(const char msg[]);
extern std::map<std::string, type> symbol_table;

void decl_id (char identifier[], type typ )
{
	
     /* Generate code for declaration. */
   	if(symbol_table.find(identifier) == symbol_table.end()){
	symbol_table[identifier] = typ;	
	outFile << "declare " << identifier << ", " << get_type(typ) << std::endl;
	}else {

		error("SYMBOL ALREADY DEFINED" );
	}
}


    
