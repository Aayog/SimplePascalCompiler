#include <stdio.h>
#include <iostream>
#include <fstream>
#include "type.h"
extern std::ofstream outFile;
extern void error(const char msg[]);
extern Type lookupID(std::string name);
extern const char* typeToString(Type type);
void read_id (char id_name[])
{
     Type type = lookupID(id_name);
     if (type == DNE) {
        error("UNDECLARED VARIABLE"); // check if it's an error
     } // check if you can read in literals
     outFile << "read " << id_name << ", " << typeToString(type) << std::endl;;
}
