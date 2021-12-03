#include "utilities.h"


extern void error(const char msg[]);
extern void decl_id(char identifier[], type typ );
extern void assign (char target[], char source[]);
extern std::ofstream outFile;

std::string get_type(type string_type) {
	if (string_type == TYPE_INT){
	return "integer";
	}else if(string_type == TYPE_REAL){
	return "real";
	}else if(string_type == TYPE_CHAR) {
	return "char";
	}else if(string_type == TYPE_BOOL) {
	return "boolean";
	}else {
	error("invalid type");
	}
return "string";
}

char *tempi() {
	static int max_int_temp=0;
	static char int_tempname[30];
	max_int_temp++;

	sprintf(int_tempname, "&tempi%d",max_int_temp);
	decl_id(int_tempname, TYPE_INT);
	return (strdup(int_tempname));
}

char *tempr() {
	static int max_real_temp=0;
	static char real_tempname[30];
	max_real_temp++;

	sprintf(real_tempname, "&tempr%d",max_real_temp);
	decl_id(real_tempname, TYPE_REAL);
	return (strdup(real_tempname));
}

char *tempb() {
	static int max_bool_temp=0;
	static char bool_tempname[30];
	max_bool_temp++;

	sprintf(bool_tempname, "&tempb%d",max_bool_temp);
	decl_id(bool_tempname, TYPE_BOOL);
	return (strdup(bool_tempname));

}

char *tempc() {
	static int max_char_temp=0;
	static char char_tempname[30];
	max_char_temp++;

	sprintf(char_tempname, "&tempc%d",max_char_temp);
	decl_id(char_tempname, TYPE_CHAR);
	return (strdup(char_tempname));
}

char *temp_if_label() {
	static int max_label_temp=0;
	static char label_tempname[30];
	max_label_temp++;
	sprintf(label_tempname, "&tempifend%d",max_label_temp);
	return (strdup(label_tempname));

}

char*temp_while_start_label() {
	static int max_while_label_temp=0;
	static char while_label_tempname[30];
	max_while_label_temp++;
	sprintf(while_label_tempname, "&labelwhilestart%d",max_while_label_temp);
	return (strdup(while_label_tempname));
}

char*temp_while_end_label() {
	static int max_while_end_label_temp=0;
	static char while_end_label_tempname[30];
	max_while_end_label_temp++;
	sprintf(while_end_label_tempname, "&labelwhileend%d",max_while_end_label_temp);
	return (strdup(while_end_label_tempname));
}

char *int_to_real_coercion(char symbol[]) {
	char *int_temp = tempi();
	outFile << "store " << symbol << ", " << int_temp << std::endl;
	char *real_temp = tempr();
	outFile << "itor " << int_temp << ", " << real_temp << std::endl; 
	return real_temp;

}

char *real_to_int_coercion(char symbol[]) {
	char *real_temp = tempr();
	outFile << "store " << symbol << ", " << real_temp << std::endl;
	char *int_temp = tempi();
	outFile << "rtoi " << real_temp << ", " << int_temp << std::endl; 
	return int_temp;

}

int is_it_bool_literal(char symbol[]) {
	if (strcasecmp(symbol, "true") == 0){
		return 0;
	}else if (strcasecmp(symbol, "false") == 0){
		return 1;
	}else{
		//Not a boolean literal!
		return 3;
	}
}
