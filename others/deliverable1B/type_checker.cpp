#include <vector>
#include <string.h>
#include "type.h"
#include <iostream>
using namespace std;

extern void error(const char msg[]);

vector<ID> symbolTable;

// determiens if input is a declared variable or valid literal

Type lookupID(string name) { // returns the type if found AND DNE/-1 if not found
    for (const ID symbol : symbolTable) {
        if (symbol.name == name) {
             return symbol.type;
	}
    } 
    return DNE;
}

void createID(string name, Type type) {// adds to the table
    //duplicate error
    const Type lookup = lookupID(name);
    if (lookup != DNE) {
        error("Duplicate ID");
        return;
    }
    symbolTable.push_back({type,name});
}

bool isInteger(string input) {
  for (char i : input) {
    if (!isdigit(i)) {
      return false;
    }
  }
  return true; 
}

bool isReal(string input) {
  for (char i : input) {
    if (!isdigit(i) && i != '.') {
      return false;
    }
  }
  return true;
}

int isBoolean(string input) { // returns 1 if true, 0 if false, and -1 if not a boolean
  // convert input to lowercase
  for (int i = 0; i < input.length(); i++) {
     input[i] = tolower(input[i]);
  }
  if (input.compare("true") == 0) {
     return 1;
  } else if (input.compare("false") == 0) {
     return 0;
  } else {
     return -1;
  }
}

const char* typeToString(Type type) {
  return TypeStrings[type];
}

ID typeCheck(string str) {
  ID input;
  input.name = str;
  input.type = lookupID(str);
  if (input.type == DNE) {
    if (isInteger(input.name)) {
       input.type = Integer;
    } else if (isReal(input.name)) {
       input.type = Real;
    } else if (isBoolean(input.name) == 1) {
       input.type = Boolean;
       input.name = "1";
    } else if (isBoolean(input.name) == 0) {
       input.type = Boolean;
       input.name = "0";
    } else if (input.type == DNE && input.name.length() == 1) {
       input.type = Char;
    } else {
       input.type = DNE;
    }
  }
  return input;
}

Type typeCheck(string str, int flag) {
  ID value = typeCheck(str);
  return value.type;
}
