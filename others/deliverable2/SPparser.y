%{
#include "utilities.h"

extern "C" int yylex();
extern "C" int yyparse();
extern FILE * yyin;

std::map<std::string, type> symbol_table;
type token_type = TYPE_INT;

extern int line_no;
int line_no = 1;
std::ofstream outFile;

void assign (char [], char []);
void decl_id (char [], type);
void finish();
char * gen_infix(char [], char [], char []);
char * gen_infix_not(char[]);
char * gen_infix_if(char[]);
void gen_infix_while_end(char*, char*);
char * gen_infix_while_loop(char*);
char * gen_infix_while_start_label();
void gen_infix_if_end(char []);
void read_id (char []);
void write_expr(char []);
void error(const char []);
void yyerror(const char []);
%}
%union{
       int ival;
       char * sval;
       }
%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER INTLITERAL
%token CHAR CHARACTERLITERAL BOOLEAN BOOLLITERAL REAL REALLITERAL
%token LPAREN RPAREN COMMA PERIOD SEMICOLON COLON PLUSOP MINUSOP ID
%token MULTIPLYOP DIVIDEOP MODOP
%token NOTOP ANDOP OROP EQUAL NOTEQUAL GREATERTHAN LESSTHAN GEQUAL LEQUAL
%token IF THEN WHILE DO

%left OROP
%left ANDOP
%left NOTOP
%left EQUAL NOTEQUAL GREATERTHAN LESSTHAN GEQUAL LEQUAL
%left PLUSOP MINUSOP
%left MULTIPLYOP DIVIDEOP MODOP

%type <sval>ident
%type <sval>expression
%type <sval>expr
%type <sval>term
%type <sval>INTLITERAL
%type <sval>CHARACTERLITERAL
%type <sval>REALLITERAL
%type <sval>BOOLLITERAL
%type <sval>if_statement
%type <sval>if_body
%type <sval>while_bexpr
%type <sval>WHILE
%type <sval>while_statement
%type <sval>while_start
%type <sval>if_bexpr
%type <sval>DO
%start system_goal
%%

program	    :	 PROGRAM {line_no++;} variables START {line_no++;} statement_list END PERIOD {line_no++;} 
		;

vartype		: INTEGER {token_type = TYPE_INT;}
	 	| REAL	{token_type = TYPE_REAL;}
		| BOOLEAN {token_type = TYPE_BOOL;}
		| CHAR	{token_type = TYPE_CHAR;}
		;

variables   :	SEMICOLON {line_no++;}
		| VAR declgroup 
		;

declgroup   : vartype d_list SEMICOLON {line_no++;}
	    | declgroup vartype d_list SEMICOLON {line_no++;}
	    | d_list COLON vartype SEMICOLON {line_no++;}
	    | declgroup d_list COLON vartype SEMICOLON {line_no++;}
	    | /*empty*/
	    ;

d_list      :   decl  
		 | d_list COMMA decl
		;
decl		: ident {decl_id($1, token_type);}
      		| ident ASSIGNOP expression {decl_id($1,token_type); assign($1,$3);}
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
statement	:	if_statement {gen_infix_if_end($1);} 	
		;	
statement	:	while_statement 
		;	
if_statement	: 	if_bexpr if_body 
		;
if_bexpr	:	IF expression THEN {$$ = gen_infix_if($2); line_no++;}
		;
if_body		:	START statement_list END {line_no++;}
		;
while_statement :	while_start while_bexpr while_body {gen_infix_while_end($1,$2);}
		;
while_start		:	WHILE {$$ = gen_infix_while_start_label();}
				;
while_bexpr		: expression DO {$$ = gen_infix_while_loop($1); line_no++;}
	;
while_body		: START {line_no++;} statement_list END {line_no++;}
	;
id_list    :	ident      {read_id($1);}
  		| id_list COMMA ident {read_id($3);}
		;
expr_list  :	expression   {write_expr($1);}
                | expr_list COMMA expression {write_expr($3);}
		;
expression :	expr   {$$ = strdup($1);}
                ;
expr       :    term {$$ = strdup($1);}
                | expr PLUSOP expr {$$ = strdup(gen_infix($1,strdup("Add"),$3));}
				| expr MINUSOP expr {$$ = strdup(gen_infix($1,strdup("Sub"),$3));}
				| expr MULTIPLYOP expr {$$ = strdup(gen_infix($1,strdup("Mul"),$3));}
				| expr DIVIDEOP expr {$$ = strdup(gen_infix($1,strdup("Div"),$3));}
				| expr MODOP expr {$$ = strdup(gen_infix($1,strdup("Mod"),$3));}
				| expr ANDOP expr {$$ = strdup(gen_infix($1,strdup("And"),$3));}
				| expr OROP expr {$$ = strdup(gen_infix($1,strdup("Or"),$3));}
				| expr EQUAL expr {$$ = strdup(gen_infix($1,strdup("Equ"),$3));}
				| expr NOTEQUAL expr {$$ = strdup(gen_infix($1,strdup("NEqu"),$3));}
				| expr GREATERTHAN expr {$$ = strdup(gen_infix($1,strdup("Greater"),$3));}
				| expr LESSTHAN expr {$$ = strdup(gen_infix($1,strdup("Less"),$3));}
				| expr GEQUAL expr {$$ = strdup(gen_infix($1,strdup("Gequal"),$3));}
				| expr LEQUAL expr {$$ = strdup(gen_infix($1,strdup("Lequal"),$3));}
				| NOTOP expr {$$ = strdup(gen_infix_not($2));}
		| {error("EXPRESSION EXPECTED, BUT NOT FOUND");}
		;
term      :	lparen expression rparen   {$$ = strdup($2);}
		;
term      :	ident      {if (symbol_table.find($1) == symbol_table.end()){ 
                            error("IDENTIFIER NOT DEFINED");}
						else {
							$$ = strdup($1);
							}
						}
		;
term      :	INTLITERAL {$$ = strdup(strdup(yylval.sval)); symbol_table[strdup(yyval.sval)] = TYPE_INT; }    
		|CHARACTERLITERAL {$$ = strdup(strdup(yylval.sval)); symbol_table[strdup(yyval.sval)] = TYPE_CHAR; }
     	|REALLITERAL	{$$ = strdup(strdup(yyval.sval)); symbol_table[strdup(yyval.sval)] = TYPE_REAL; }
     	|BOOLLITERAL	{$$ = strdup(strdup(yyval.sval)); symbol_table[strdup(yyval.sval)] = TYPE_BOOL; }
	;

lparen    :	LPAREN
		| {error("( EXPECTED , BUT NOT FOUND");}
		;
rparen    :	RPAREN
		| {error(") EXPECTED , BUT NOT FOUND");}
		;
ident     :	ID {$$ = strdup(yylval.sval);}
		| /*empty*/ {error("IDENTIFIER EXPECTED, BUT NOT FOUND");}
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
