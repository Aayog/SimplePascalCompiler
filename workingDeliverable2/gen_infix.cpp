#include <ctype.h>
#include <string>
#include <iostream>
#include <fstream>
#include "symbol_table.h"

extern std::ofstream outFile;
extern SymbolTable st;
void error(std::string msg);
int stringcmp(std::string a, std::string b);
	static int max_temp_int = 0;
	static int max_temp_real = 0;
	static int max_temp_bool = 0;
	static int max_temp_char = 0;
char * getTemp(std::string type) {
	// converting the previous iteration where only an int is needed
	// into all data types

	static char tempname[30];

	if (stringcmp("integer", type) == 0) {
	    max_temp_int++;
	    sprintf(tempname, "&tempi%d", max_temp_int);
	    outFile << "declare " << tempname << ", integer" << std::endl;
	} else if (stringcmp("real", type) == 0) {
	    max_temp_real++;
            sprintf(tempname, "&tempr%d", max_temp_real);
            outFile << "declare " << tempname << ", real" << std::endl;
	} else if (stringcmp("boolean", type) == 0) {
	    max_temp_bool++;
            sprintf(tempname, "&tempb%d", max_temp_bool);
            outFile << "declare " << tempname << ", boolean" << std::endl;
	} else if (stringcmp("char", type) == 0) {
	    max_temp_char++;
            sprintf(tempname, "&tempc%d", max_temp_char);
            outFile << "declare " << tempname << ", char" << std::endl;
	}
	return tempname;
}

/* To do:
 * Figure out if operator is a literal or a ID on symbol table
 * Based on that, figure out the type of the operator
 * Build method to figure out type, one from the data, and one from the symbol table
 * Based on type, convert types if necessary.  Example: rtoi for dividing into an int
 * 
 */

std::string getOpType(std::string operand) {
  if (st.exists(operand)){
    return st.getType(operand);
  } else {
    std::string err = "ERROR OPERAND NOT FOUND";
    error(err);
  }
  /* In theory we can do this because we add every literal to the symbol table
   * If this is not working, then the symbol table is not handling non std::string values very well
   *
   */ 
}
std::string getOp(bool intOps, std::string op) {
  if (intOps) {
    if (stringcmp("Add", op) == 0) {
      return "iadd";
    } else if (stringcmp("Sub", op) == 0) {
      return "isub";
    } else if (stringcmp("Mul", op) == 0) {
      return "imult";
    } else if (stringcmp("Div", op) == 0) {
      return "idiv";
    } else if (stringcmp("Mod", op) == 0) {
      return "imod";
    }
  } else {
    if (stringcmp("Add", op) == 0) {
      return "radd";
    } else if (stringcmp("Sub", op) == 0) {
      return "rsub";
    } else if (stringcmp("Mul", op) == 0) {
      return "rmult";
    } else if (stringcmp("Div", op) == 0) {
      return "rdiv";
    } else if (stringcmp("Mod", op) == 0) {
      error("MODULUS NOT ALLOWED WITH REAL OPERANDS");
    }
  }
  error("UNKNOWN OPERATION: " + std::string(op));
  return nullptr;
}

std::string coerceType(std::string operand, std::string type){
  std::string currType = st.getType(operand);
  if (stringcmp(currType, type) != 0){
    if ((stringcmp(currType, "integer") == 0 || stringcmp(currType, "boolean") == 0)  && stringcmp("real", type) == 0) {
       std::string temp = getTemp(type);
       outFile << "itor " << operand << ", " << temp << std::endl;
       return temp;
    } else if (stringcmp(currType, "real") == 0 && stringcmp("integer", type) == 0) {
	std::string temp = getTemp(type);
	outFile << "rtoi " << operand << ", " << temp << std::endl;
	return temp;
    }
  }
  return operand;
  

}

std::string gen_infix(std::string operand1, std::string op, std::string operand2)
{  
  // char tempop[8];
  // this is a placeholeder, need to design a way to get the type from operands!
  bool intOps = true;  //true if int ops, false if real ops
  auto type1 = getOpType(operand1);
  auto type2 = getOpType(operand2);
  std::string op1 = operand1;
  std::string op2 = operand2;
  if (stringcmp("real", type1) == 0 && stringcmp("integer", type2) == 0) {
	// want to change type to reals
    type2 = "real";
    op2 = coerceType(operand2, type2);
    intOps = false;
  } else if (stringcmp("integer", type1) == 0 && stringcmp("real", type2) == 0) {
	// want to change type to reals
    type1 = "real";
    op1 = coerceType(operand1, type1);
    intOps = false;
  }

  std::string tempop = getOp(intOps, op);
  std::string tempname = getTemp(type1);
  sprintf(tempname, "&tempi%d" ,max_temp);
  outFile << tempop << " " << op1 << ", " << op2 << ", " << tempname << std::endl;
  return (tempname);
}

std::string gen_infix_not(std::string operand1){
  std::string type1 = getOpType(operand1);
    if (type1 == "boolean") {
        std::string temp = getTemp(type1);
        symbol_table[temp] = "boolean";
        outFile << "not " << operand1 << ", " << temp << std::endl;
        return temp;
    }
    else {
      error("NOT OPERATION NEEDS A BOOLEAN OPERAND");
      }
  return operand1;
}

void error(std::string msg) {
  throw msg;
}

int stringcmp(std::string a, std::string b) {
  if (a == b) {
    return 0;
  } else if (a < b){
    return -1;
  } else {
    return 1;
  }
}