#include <iostream>
#include <sstream>
#include <fstream>
#include <string.h>
#include "type.h"
using namespace std;
int max_temp = 0;
extern std::ofstream outFile;
extern Type lookupID(string name);
extern ID typeCheck(string str);
extern void error(const char msg[]);
extern string rtoi(string identifier); 
extern string itor(string identifier);
extern void decl_id(char identifier[], Type type);
void assign (char target[], char source[])
{
  Type targetType = lookupID(target);
  if (targetType == DNE) {
    error("store: Target Error");
  }
  ID sourceID = typeCheck(source);
  switch (targetType) {
    case Integer:
      if (sourceID.type == Real) {
        sourceID.name = rtoi(source);
      } 
      if (sourceID.type == Char) {
        error("store: Source Error INTEGER TO CHAR");
      }
      break;
    case Real:
      if (sourceID.type == Integer || sourceID.type == Boolean) {
        sourceID.name = itor(source);
      }
      if (sourceID.type == Char) {
        error("store: Source Error REAL TO CHAR");
      }      
      break;
    case Char:
      if ((lookupID(sourceID.name) == DNE && sourceID.name.length() != 3) || 
		     (lookupID(sourceID.name) != DNE && sourceID.type != Char)) {
        error("store: Source Error NOT A CHAR");
      }
      break;
     case Boolean:
      if (sourceID.type == Char || sourceID.type == Integer 
		      || sourceID.type == Real) {
        error("store: Source Error NOT A BOOLEAN");
      }
      break;
  }
     /* Generate code for assignment. */
    	outFile << "store " << sourceID.name << ", " << target << std::endl;
}

