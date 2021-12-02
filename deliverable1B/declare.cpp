#include <iostream>
#include <fstream>
#include <sstream>
#include <string.h>
#include "type.h"
using namespace std;
extern std::ofstream outFile;
extern Type lookupID(string name);
extern void createID(string name, Type type);
extern char* typeToString(Type type);
void assign (char target[], char source[]);
void decl_id (char identifier[], Type type)
{ 
     createID(identifier,type);
     /* Generate code for declaration. */
    	outFile << "declare " << identifier << ", " << typeToString(type) << std::endl;

}

void decl_id (string identifier, Type type)
{
     createID(identifier,type);
     /* Generate code for declaration. */
        outFile << "declare " << identifier << ", " << typeToString(type) << std::endl;

}

void decl_id (char identifier[], char typeString[]) {
 Type type;
 int typeNum = stoi(typeString);
 switch (typeNum) {
    case 265:
      type = Integer;
      break;
    case 266:
      type = Real;
      break;
    case 267:
      type = Char;
      break;
    case 268:
      type = Boolean;
      break;
 }
  decl_id(identifier,type);
}
void decl_list (std::string identifiers, int typeNum) {
 // cout << "identifiers " << identifiers << endl;
  std::stringstream ss(identifiers);
 Type type;
 switch (typeNum) {
    case 265:
      type = Integer;
      break;
    case 266:
      type = Real;
      break;
    case 267:
      type = Char;
      break;
    case 268:
      type = Boolean;
      break;
 }
  string next;
  while (ss >> next) {
     if (next == "store:") {
       ss >> next; // target
       //cout << "target: " << next << endl;
       char str[next.length()];
       strcpy(str,next.c_str());
       decl_id(str,type);
       ss >> next; // source
       //cout << "source: " << next << endl;
       char str2[next.length()];
       strcpy(str2,next.c_str());
       assign(str,str2);
     } else {
       char str[next.length()];
       strcpy(str,next.c_str());
       decl_id(str,type);
     }
  }
}
/*
void decl_list (char identifiers[], int typeNum) {
  cout << "identifiers " << identifiers << endl;
  std::stringstream ss(identifiers);
 Type type;
 switch (typeNum) {
    case 265:
      type = Integer;
      break;
    case 266:
      type = Real;
      break;
    case 267:
      type = Char;
      break;
    case 268:
      type = Boolean;
      break;
 }
  string next; 
  while (ss >> next) {
     if (next == "store:") {
       ss >> next; // target
       cout << "target: " << next << endl;
       char str[next.length()];
       strcpy(str,next.c_str());
       decl_id(str,type);
       ss >> next; // source
       cout << "source: " << next << endl;
       char str2[next.length()];
       strcpy(str2,next.c_str());
       assign(str,str2); 
     }  
     char str[next.length()]; 
     strcpy(str,next.c_str());
     decl_id(str,type);
  }
}

*/
