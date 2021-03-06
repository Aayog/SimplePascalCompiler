%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <string>
#include <iostream>
#include <fstream>
#include "symbol_table.h"

extern "C" int yylex();
extern "C" int yyparse();
extern FILE * yyin;

SymbolTable st;
int line_no = 1;
std::ofstream outFile;
void assign (char [], char []);
void decl_id (char []);
void finish();
char * gen_infix(char [], char [], char []);
void read_id (char []);
void write_expr(char []);
void error(const char []);
void yyerror(const char []);
%}
%union{
       int ival;
       char * sval;
	   bool bval;
	   char cval;
	   float rval;
       }
%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER INTLITERAL
%token LPAREN RPAREN COMMA PERIOD SEMICOLON COLON PLUSOP MINUSOP ID
%token DIVOP MULTOP MODOP CHAR REAL BOOLEAN CHARLITERAL REALLITERAL
%token BOOLEANLITERAL LT GT EQ LE GE NE AND OR NOT 

%left PLUSOP MINUSOP DIVOP MULTOP MODOP

%type <sval>ident
%type <sval>expression
%type <sval>expr
%type <sval>bexpr
%type <sval>term
%type <sval>add_op
%type <sval>sub_op
%type <sval>div_op
%type <sval>mult_op
%type <sval>mod_op

%start system_goal
%%

program	    :	 PROGRAM {line_no++;} variables START {line_no++;} statement_list END PERIOD {line_no++;} 
		;
variables   :	SEMICOLON {line_no++;}
		 | VAR d_list COLON INTEGER SEMICOLON {line_no++;}
		 | VAR d_list COLON CHAR SEMICOLON {line_no++;}
		 | VAR d_list COLON REAL SEMICOLON {line_no++;}
		 | VAR d_list COLON BOOLEAN SEMICOLON {line_no++;}
		;
d_list      :   ident  { decl_id($1); }
		 | d_list COMMA ident  { decl_id($3); }
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
		| expr div_op term {strcpy($$,gen_infix($1,$2,$3));}
		| expr mult_op term {strcpy($$,gen_infix($1,$2,$3));}
		| expr mod_op term {strcpy($$,gen_infix($1,$2,$3));}
		| expr add_op term {strcpy($$,gen_infix($1,$2,$3));}
		| expr sub_op term {strcpy($$,gen_infix($1,$2,$3));}
		| {error("EXPRESSION EXPECTED, BUT FOUND");}
		;
term      :	lparen expression rparen   {strcpy($$,$2);}
		;
term      :	ident      {strcpy($$,$1);}
		;
term      :	INTLITERAL {strcpy($$,strdup(yylval.sval));}    
		| REALLITERAL {strcpy($$,strdup(yylval.sval));}    
		| CHARLITERAL {strcpy($$,strdup(yylval.sval));}    
		| BOOLEANLITERAL {strcpy($$,strdup(yylval.sval));}    
		| {error("NUMERIC VALUE EXPECTED, BUT FOUND");}
		;
lparen    :	LPAREN
		| {error("( EXPECTED , BUT FOUND");}
		;
rparen    :	RPAREN
		| {error(") EXPECTED , BUT FOUND");}
		;
add_op    :	PLUSOP {strcpy ($$,"Add");}
		;
sub_op    :	MINUSOP {strcpy ($$,"Sub");}
		;
mod_op	  : MODOP {strcpy ($$,"Mod");}
		;
div_op	  : DIVOP {strcpy ($$,"Div");}
		;
mult_op	  : MULTOP {strcpy ($$,"Mult");}
		;
bexpr : bterm {$$ = strdup($1);}
		| bexpr OR bterm

bterm : bterm and bfactor {strcpy($$,gen_infix($1,$2,$3));}
	| bfactor {strcpy($$, $1);}
bfactor : not bFactor {strcpy($$,gen_infix_unary($1,$2));} 
	| true {strcpy ($$, "true")} 
	| false {strcpy ($$, "false")}

		
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
  std::cout << "EEK, parse error!  Message: " << s << std::endl;
  // might as well halt now:
  exit(-1);
} 
