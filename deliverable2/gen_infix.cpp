#include "utilities.h"

extern std::ofstream outFile;
extern std::map<std::string, type> symbol_table;
extern void error(const char msg[]);

char* int_op(char iop[]){
  char* tempop;
  if(strcmp(iop, "Add") == 0){
        tempop =(char*)"iadd";}
        else if (strcmp(iop, "Sub") == 0){   
        tempop =(char*)"isub";}
        else if (strcmp(iop, "Mul") == 0){
        tempop =(char*)"imul";}
        else if (strcmp(iop, "Div") == 0){
        tempop =(char*)"idiv";}
        else if (strcmp(iop, "Mod") == 0){
        tempop =(char*)"imod";}
    return tempop;  
}


char* real_op(char rop[]){
  char *tempop;
  if(strcmp(rop, "Add") == 0){
        tempop =(char*)"radd";}
        else if (strcmp(rop, "Sub") == 0){   
        tempop =(char*)"rsub";}
        else if (strcmp(rop, "Mul") == 0){
        tempop =(char*)"rmul";}
        else if (strcmp(rop, "Div") == 0){
        tempop =(char*)"rdiv";}
        else if (strcmp(rop, "Mod") == 0){
        tempop =(char*)"rmod";}
    return tempop;
}

int is_relational(char op[]){
  if (strcmp(op, "Equ") == 0){
  return 1;
  }else if(strcmp(op, "NEqu") == 0){
  return 2;
  }else if(strcmp(op, "Greater") == 0 ){
  return 3;
  }else if(strcmp(op, "Less") == 0){
  return 4;
  }else if(strcmp(op, "Gequal") == 0){
  return 5;
  }else if(strcmp(op, "Lequal") == 0 ){
  return 6;
  } 
  return 0;
}

int is_logical(char op[]){
  if (strcmp(op, "And") == 0){
    return 1;
  }else if(strcmp(op, "Or") == 0){
    return 2;
  } 
  return 0;
}

char *gen_infix_not(char operand1[]){
  type type1 = symbol_table[operand1];
    if (type1 == TYPE_BOOL) {
        char *temp = tempi();
        symbol_table[temp] = TYPE_BOOL;
        outFile << "not " << operand1 << ", " << temp << std::endl;
        return temp;
    }
    else {
      error("not operation needs a boolean operand");
      }
  return operand1;    
}

char *gen_infix_equal(char operand1[], char operand2[]){
  char *temp = tempi();
  symbol_table[temp] = TYPE_BOOL;
  outFile << "equ " << operand1 << ", " << operand2 << ", " << temp << std::endl;
  return temp;
}


char *gen_infix_if(char *operand){
  if(symbol_table[operand] == TYPE_BOOL) {
    char *temp = temp_if_label();
      outFile << "jf " << operand << ", :" << temp << std::endl;;
      return temp;
    }
  error("Cannot find a boolean expression for if statement");
  return operand;
}

void gen_infix_if_end(char *if_end_label){
  outFile << ":" << if_end_label << std::endl;
}

char *gen_infix_while_start_label() {
    char *temp_label = temp_while_start_label();
    outFile << ":" << temp_label << std::endl;
    return temp_label;
}

char *gen_infix_while_loop(char *operand) {
  if(symbol_table[operand] == TYPE_BOOL) {
    char *temp_label = temp_while_end_label();
    outFile << "jf " << operand << ", " << temp_label << std::endl;;
    return temp_label;
  }
  error("Need a boolean expression for while loop");
  return operand;     
}

void gen_infix_while_end(char *while_start_label, char *while_end_label) {
  outFile << "jmp :" << while_start_label << std::endl;
	outFile << ":" << while_end_label << std::endl;
}

char * gen_infix(char operand1[], char op[], char operand2[]){
  type type1 = symbol_table[operand1];
  type type2 = symbol_table[operand2];
  char *tempop;
  int logical = is_logical(op);
  int relational = is_relational(op);

  //logical operations
  if (logical != 0){
      int op1_bool_lit = is_it_bool_literal(operand1);
      int op2_bool_lit = is_it_bool_literal(operand2);
      char *temp_op1;
      char *temp_op2;
      if(type1 != TYPE_BOOL || type2 != TYPE_BOOL){
        error("incompatible types of logical operands. Must be of type boolean.");
      }
      //In the case of boolean literals
      char * temp = tempi();
      symbol_table[temp] = TYPE_BOOL;
      if(op1_bool_lit == 0 ){
        temp_op1 = tempi();
        symbol_table[temp_op1] = TYPE_BOOL;
        outFile << "store " << '1' << ", " << temp_op1 << std::endl;
        if(logical == 1){
          outFile << "and " << temp_op1 << ", " << operand2 << " " << temp << std::endl; 
          return temp;
        }else if(logical == 2){
          outFile << "or " << temp_op1 << ", " << operand2 << " " << temp << std::endl; 
          return temp;
        }
      }else if(op1_bool_lit == 1){
        temp_op1 = tempi();
        symbol_table[temp_op1] = TYPE_BOOL;
        outFile << "store " << '0' << ", " << temp_op1 << std::endl;
        if(logical == 1){
          outFile << "and " << temp_op1 << ", " << operand2 << " " << temp << std::endl; 
          return temp;
        }else if(logical == 2){
          outFile << "or " << temp_op1 << ", " << operand2 << " " << temp << std::endl; 
          return temp;
        }
      }
      if(op2_bool_lit == 0) {
        temp_op2 = tempi();
        symbol_table[temp_op2] = TYPE_BOOL;
        outFile << "store " << '1' << ", " << temp_op2 << std::endl;
        if(logical == 1){
          outFile << "and " << operand1 << ", " << temp_op2 << " " << temp << std::endl; 
          return temp;
        }else if(logical == 2){
          outFile << "or " << operand1 << ", " << temp_op2 << " " << temp << std::endl; 
          return temp;
        }

      }else if(op2_bool_lit==1){
        temp_op2 = tempi();
        symbol_table[temp_op2] = TYPE_BOOL;
        outFile << "store " << '0' << ", " << temp_op2 << std::endl;
        if(logical == 1){
          outFile << "and " << operand1 << ", " << temp_op2 << " " << temp << std::endl; 
          return temp;
        }else if(logical == 2){
          outFile << "or " << operand1 << ", " << temp_op2 << " " << temp << std::endl; 
          return temp;
        }
      //Just boolean variables
      if(logical == 1){
        outFile << "and " << operand1 << ", " << operand2 << " " << temp << std::endl; 
        return temp;
      }else if(logical == 2){
        outFile << "or " << operand1 << ", " << operand2 << " " << temp << std::endl; 
        return temp;
      }



      }    


  }
  
  //relational operations
  if(relational != 0){
    char *op1, *op2;
    op1 = operand1;
    op2 = operand2;
    
    if(type1 == TYPE_BOOL || type1 == TYPE_CHAR || type2 == TYPE_BOOL || type2 == TYPE_CHAR){
      error("incompatible types of relational operands");
    }

    if(type1 != type2){
      if(type1 == TYPE_INT && type2 == TYPE_REAL){
        op1 = int_to_real_coercion(operand1);
      }else if(type1 == TYPE_REAL && type2 == TYPE_INT){
        op1 = int_to_real_coercion(operand2);
      }
    }
    if(relational == 1 ){
      return gen_infix_equal(op1, op2);
    }else if(relational == 2) {
      char *temp = gen_infix_equal(op1, op2);
      char *temp1 = gen_infix_not(temp);
      symbol_table[temp1] = TYPE_BOOL;
      return temp1;
    }else if(relational == 3) {
      char *temp = tempi();
      outFile << "high " << op1 << ", " << op2 << ", "<< temp << std::endl;
      symbol_table[temp] = TYPE_BOOL;
      return temp;
    }else if(relational == 4) {
      char *temp = tempi(); 
      outFile << "low " << op1 << ", " << op2 << ", "<< temp << std::endl;
      symbol_table[temp] = TYPE_BOOL;

      return temp;
    }else if(relational == 5) {
      char *temp = tempi();
      outFile << "high " << op1 << ", " << op2 << ", "<< temp << std::endl;
      char *temp1 = gen_infix_equal(op1, op2);
      char *temp2 = tempi();
      outFile << "or " << temp << ", " << temp1 << ", " << temp2 << std::endl;
      symbol_table[temp2] = TYPE_BOOL;
      return temp2;
    }else if(relational == 6) {
      char *temp = tempi();
      outFile << "low " << op1 << ", " << op2 << ", "<< temp << std::endl;
      char *temp1 = gen_infix_equal(op1, op2);
      char *temp2 = tempi();
      symbol_table[temp2] = TYPE_BOOL;
      outFile << "or " << temp << ", " << temp1 << ", " << temp2 << std::endl;
      return temp2;
    }
  }




  //Check for the need to for an int to real coercion
  if (type1 != type2) {
    if (type1 == TYPE_INT && type2 == TYPE_REAL){
      char *now_real = int_to_real_coercion(operand1);
      tempop = real_op(op);
      char *temp = tempr();
      outFile << tempop << " " << now_real << ", " << operand2 << ", " << temp << std::endl;
      return temp;

    } else if(type1 == TYPE_REAL && type2 == TYPE_INT){
      char*now_real = int_to_real_coercion(operand2);
      tempop = real_op(op);
      char *temp = tempr();
      outFile << tempop << " " << operand1 << ", " << now_real << ", " << temp << std::endl;
      return temp;
    }
  } else {
    if (type1 == TYPE_INT && type2 == TYPE_INT) {
      tempop = int_op(op);
      char *temp = tempi();
      outFile << tempop << " " << operand1 << ", " << operand2 << ", " << temp << std::endl;
      return temp;
      }
    else if (type1 == TYPE_REAL && type2 == TYPE_REAL) {
      tempop = real_op(op);
      char *temp = tempr();
      outFile << tempop << " " << operand1 << ", " << operand2 << ", " << temp << std::endl;
      return temp;
      }
      //Current version doesn ot support operations with boolean or char
    else {
       error("invalid operation");
      }
    } 
    error("invalid operation");
    return tempop;
}



