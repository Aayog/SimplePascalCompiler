
#include "utilities.h"

extern std::ofstream outFile;
extern std::map<std::string, type> symbol_table;
extern void error(const char msg[]);

void assign_bool (char target[], type target_type, char source[], type source_type){
     int bool_case = is_it_bool_literal(source);

     //Assign boolean to int
     if(target_type == TYPE_INT){
          if(bool_case == 0){
               outFile << "store " << '1' << ", " << target << std::endl;
          }
          else if(bool_case == 1 ){
               outFile << "store " << '0' << ", " << target << std::endl;
          }else {
		outFile <<"store " << source << ", " << target << std::endl;
	     }
     //Assign boolean to real
     }else if(target_type == TYPE_REAL){
          if(bool_case == 0){
               char* temp_int = int_to_real_coercion((char*)"1");
               outFile << "store " << temp_int << " ," << target << std::endl;
          }
          else if(bool_case == 1 ){
               char* temp_int = int_to_real_coercion((char*)"0");
               outFile << "store " << temp_int << " ," << target << std::endl;
          }
	     else{
            char* temp_real = int_to_real_coercion(source);
		  outFile <<"store " << temp_real << ", " << target <<std::endl;
	     }
     //Assign bool to bool
     }else if (target_type ==TYPE_BOOL){
          if(bool_case == 0){
               outFile << "store " << '1' << ", " << target << std::endl;
          }
          else if(bool_case == 1 ){
               outFile << "store " << '0' << ", " << target << std::endl;
          }
          }else{
          outFile << "store " << source << ", " << target << std::endl;
          }
}





void assign (char target[], char source[]){

     char *tempop;
     type target_type = symbol_table[target];
     type source_type = symbol_table[source];
     
            /* integer variable on the left may have integer expressions, real expressions, or a boolean value on the right*/
     if(target_type == TYPE_INT && (source_type == TYPE_REAL || source_type == TYPE_BOOL || source_type == TYPE_INT)){
          if (source_type == TYPE_REAL) {
               char* now_real = real_to_int_coercion(source);
               outFile << "store " << now_real << " ," << target << std::endl;
          }else if (source_type == TYPE_BOOL) {
                  assign_bool(target, target_type, source, source_type);
          }else{
               outFile << "store " << source << " ," << target << std::endl;
          }
     }  
          /*real variables on the left may have integer expressions, real expressions, or a boolean on the right*/
     else if(target_type == TYPE_REAL && (source_type == TYPE_REAL || source_type == TYPE_BOOL || source_type == TYPE_INT)){
               if(source_type == TYPE_INT) {
                    char *now_real = int_to_real_coercion(source);
                    outFile << "store " << now_real << ", " << target << std::endl;
               }else if (source_type == TYPE_BOOL) {
                  assign_bool(target, target_type, source, source_type);
               }
               else {
                    outFile << "store " << source << ", " << target << std::endl;
               }
          } 
          /* char variables on the left shall have a char value on the right*/
     else if(source_type == TYPE_CHAR && target_type == TYPE_CHAR){
               outFile << "store " << source << ", " << target << std::endl;
          }
          //* boolean variables shall have a boolean value on the right
     else if(target_type == TYPE_BOOL && source_type == TYPE_BOOL) {
          assign_bool(target,target_type,source,source_type);

     }else {
          error("incompatible types for assignment");
          } 
     

}

  

  
  
  
