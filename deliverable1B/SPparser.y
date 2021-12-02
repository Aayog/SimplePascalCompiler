%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include "type.h"
extern "C" int yylex();
extern "C" int yyparse();
extern FILE * yyin;

int line_no = 1;
std::ofstream outFile;
using namespace std;
std::stringstream ss;

void assign (char [], char []);
void assignList (Type,char [], char []);
void decl_id ( char [], Type );
void decl_id ( char [], char[] );
void decl_list (string, int typeNum);
void finish();
char * gen_infix(char [], char [], char []);
void read_id (char []);
void write_expr(char []);
void error(const char []);
void yyerror(const char []);
Type typeCheck(std::string str, int flag);
%}
%union{
       int ival;
       char* sval;
       }
%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER REAL CHAR BOOLEAN INTLITERAL REALLITERAL CHARLITERAL BOOLEANLITERAL
%token LPAREN RPAREN COMMA PERIOD SEMICOLON COLON PLUSOP MINUSOP DIVIDEOP MODOP ID

NT%left PLUSOP MINUSOP MULTOP DIVIDEOP MODOP
NT%left LESSTHAN GREATERTHAN LESSOREQUAL GREATEROREQUAL NOTEQUAL ISEQUAL NOT AND OR
%type <sval>ident
%type <sval>expression
%type <sval>expr
%type <sval>term
%type <sval>op
%type <ival>type
%start system_goal
%%


program	    :	 PROGRAM {line_no++;} variables START {line_no++;} statement_list END PERIOD {line_no++;} 
		;
variables   :	SEMICOLON {line_no++;}
		 | VAR var_list {line_no++;}
		;
var_list    :   var_dec 
	         | var_list var_dec 
                ;
var_dec     :   type d_list SEMICOLON {line_no++;decl_list(ss.str(),$1);ss.str("");}
                 | d_list COLON type SEMICOLON {line_no++;decl_list(ss.str(),$3);ss.str("");}
               ;
type        :   INTEGER {$$=265;} //value from token.tab.h
	         | REAL {$$=266;}
                 | CHAR {$$=267;}
                 | BOOLEAN {$$=268;}
                ;
	       
d_list      :    ident {ss << " " << $1;}
                 | ident ASSIGNOP expression {ss << " store: " << $1 << " " << $3;}
                 | d_list COMMA ident  {ss << " " << $3;} 
                 | d_list COMMA ident ASSIGNOP expression {ss << " store: " << $3 << " " << $5;}
                ;
statement_list  :   statement
                 |  statement_list statement
		;
statement  :	ident ASSIGNOP expression {assign($1,$3);} SEMICOLON {line_no++;}
		;
statement  :	READ lparen id_list rparen SEMICOLON {line_no++;}
		;
statement  :	WRITE lparen expr_list rparen SEMICOLON {line_no++;}
		;
statement  :    SEMICOLON {line_no++;}
		;
id_list    :	ident      {read_id($1);}
  		| id_list COMMA ident {read_id($3);}
		;
expr_list  :	expression   {write_expr($1);}
                | expr_list COMMA expression {write_expr($3);}
		;
expression :	expr   {strcpy($$,$1);}
                ;
expr       :    term {$$ = strdup($1);}
                | expr op expr {strcpy($$,gen_infix($1,$2,$3));}
		| {error("EXPRESSION EXPECTED, BUT FOUND");}
		;
term      :	lparen expression rparen   {strcpy($$,$2);}
		;

term      :	INTLITERAL {strcpy($$,strdup(yylval.sval));}    
		//| {error("NUMERIC VALUE EXPECTED, BUT FOUND");}
		;
term      :     CHARLITERAL {strcpy($$,strdup(yylval.sval));}
	        ;
term      :	REALLITERAL {strcpy($$,strdup(yylval.sval));}    
		;
term      :	BOOLEANLITERAL {strcpy($$,strdup(yylval.sval));}    
		;
term      :     ident      {strcpy($$,$1);}
                ;
lparen    :	LPAREN
		| {error("( EXPECTED , BUT FOUND");}
		;
rparen    :	RPAREN
		| {error(") EXPECTED , BUT FOUND");}
		;
op        :	PLUSOP {strcpy ($$,"Add");}
		| MINUSOP {strcpy ($$,"Sub");}
		| MULTOP {strcpy ($$,"Mult");}
		| DIVIDEOP {strcpy ($$,"Divide");}
		| MODOP {strcpy ($$,"Mod");}
		;
ident     :	ID {strcpy($$, yylval.sval);}
		| {error("IDENTIFIER EXPECTED, BUT FOUND");}
		;
system_goal :	program  { finish(); }
		;
%%
int main( int argc, char **argv )
{
	char * loc;
	if( argc != 2 )
		std::cout << "Usage: SP inputfile\n";
	else
	{
		std::string srcFilePath = argv[1]; // assume you are not mucking with pointers
		yyin = fopen( *++argv, "r" );
		if( yyin == NULL )
		{
			std::cout << "SP: Couldn't open " << *argv << std::endl;
			exit( 1 );
		}
		
		std::string fileName = srcFilePath.substr(0, srcFilePath.rfind('.'));
		std::string asmFileName = fileName + ".asm";

		outFile.open(asmFileName);
		yyparse();
		fclose( yyin );
		outFile.close();
	}
}

void error( const char msg[] )
{
	std::cout << "LINE " << line_no << " : " << msg << std::endl;
	exit( -1 );
}

void yyerror(const char s[]) {
  std::cout << "EEK, parse error! Message: " << s << std::endl;
  // might as well halt now:
  exit(-1);
} 
