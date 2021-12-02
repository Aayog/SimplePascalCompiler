#include <iostream>
#include <fstream>
#include <string.h>
#include "type.h"
using namespace std;
extern void decl_id(char* identifier, Type type);
extern std::ofstream outFile;

string rtoi(string identifier) {
  max_temp++;
  char tempname[30];
  sprintf(tempname, "&tempi%d" ,max_temp);
  decl_id(tempname,Integer);
  outFile << "rtoi" << " " << identifier << ", " << tempname << std::endl;
  return strdup(tempname);
}

string itor(string identifier) {
  max_temp++;
  char tempname[30];
  sprintf(tempname, "&tempr%d" ,max_temp);
  decl_id(tempname,Real);
  outFile << "itor" << " " << identifier << ", " << tempname << std::endl;
  return strdup(tempname);
}

string temp(Type type) {
  max_temp++;
  char tempname[30];
  char tempType;
  if (type == Integer) {
    tempType = 'i';
  } else { // must be real then 
    tempType = 'r';	
  }
  sprintf(tempname,"&temp%c%d",tempType,max_temp);
  return strdup(tempname);
}
