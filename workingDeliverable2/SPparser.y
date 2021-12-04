%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <string>
#include <iostream>
#include <fstream>
#include "symbol_table.h"
#include "labelTracker.h"

extern "C" int yylex();
extern "C" int yyparse();
extern FILE * yyin;

SymbolTable st;
labelTracker lt;
int line_no = 1;
char type[10];
std::ofstream outFile;
void assign (char [], char []);
void decl_id (char [], char []);
void finish();
std::string gen_infix(std::string, std::string, std::string);
std::string gen_bool(std::string, std::string, std::string);
std::string gen_bool(std::string);
void read_id (char[]);
void write_expr(char[], char[]);
void while_expr();
void while_end_expr(char []);
void end_expr();
void if_expr(char []);
void if_end();
void error(const char []);
void yyerror(const char []);
%}
%union{
       int ival;
       std::string sval;
           bool bval;
           char cval;
           float rval;
       }
%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER INTLITERAL
%token LPAREN RPAREN COMMA PERIOD SEMICOLON COLON PLUSOP MINUSOP ID
%token DIVOP MULTOP MODOP CHAR REAL BOOLEAN CHARLITERAL REALLITERAL
%token BOOLEANLITERAL APOSTROPHE IF THEN LTHAN GTHAN GEQUAL LEQUAL
%token EQUAL NEQUAL AND OR WHILE DO NOT TRUE FALSE

%left PLUSOP MINUSOP DIVOP MULTOP MODOP AND NOT

%type <sval>ident
%type <sval>expression
%type <sval>expr
%type <sval>term
%type <sval>add_op
%type <sval>sub_op
%type <sval>div_op
%type <sval>mult_op
%type <sval>mod_op
%type <sval>bexpr
%type <sval>booleanexpr
%type <sval>boolterm
%type <sval>lthan
%type <sval>gthan
%type <sval>gequal
%type <sval>lequal
%type <sval>equal
%type <sval>nequal
%type <sval>and
%type <sval>or

%start system_goal
%%

program     :    PROGRAM {line_no++;} decl_section START {line_no++;} statement_list END PERIOD {line_no++;}
                ;
decl_section  :  SEMICOLON {line_no++;}
                | VAR {line_no++;} vars_section
                ;
vars_section:   variables
                | vars_section variables
                ;
variables   :    INTEGER {type =  "integer");} d_list SEMICOLON {line_no++;}
                 | CHAR {type =  "char");} d_list SEMICOLON {line_no++;}
                 | REAL {type =  "real");} d_list SEMICOLON {line_no++;}
                 | BOOLEAN {type =  "boolean");} d_list SEMICOLON {line_no++;}
                ;
d_list      :  ident  { decl_id($1, type); }
                 | d_list COMMA ident { decl_id($3, type);}
                 | ident ASSIGNOP expression { decl_id($1, type); assign($1, $3); }
             | d_list COMMA ident ASSIGNOP expression { decl_id($3, type); assign($3,$5); }
                ;
statement_list  :   statement
                 |  statement_list statement
                ;
statement  :    ident ASSIGNOP expression {assign($1,$3);} SEMICOLON {line_no++;}
                ;
statement  :    IF bexpr {if_expr($2);} THEN {line_no++;} START {line_no++;} statement_list END {if_end(); line_no++;}
                ;
statement : WHILE {while_expr();} bexpr {while_end_expr($3);} DO {line_no++;} START {line_no++;} statement_list END {end_expr(); line_no++;}
        ;
statement  :    READ lparen id_list rparen SEMICOLON {line_no++;}
                ;
statement  :    WRITE lparen expr_list rparen SEMICOLON {line_no++;}
                ;
statement  :    SEMICOLON {line_no++;}
                ;
id_list    :    ident      {read_id($1);}
                | id_list COMMA ident {read_id($3);}
                ;
expr_list  :    expression   {write_expr($1, type);}
                | expr_list COMMA expression {write_expr($3, type);}
                ;
expression :    expr   {strcpy($$,$1);}
                ;
bexpr      : booleanexpr {strcpy($$, $1);}
        | bexpr and bexpr {strcpy($$, gen_bool($1, $2, $3));}
        | bexpr or bexpr {strcpy($$, gen_bool($1, $2, $3));}
        | NOT bexpr {strcpy($$, gen_bool($2));}
        | LPAREN booleanexpr RPAREN {strcpy($$, $2);}
                ;
booleanexpr : boolterm {$$ = strdup($1);}
        | bexpr nequal boolterm {strcpy($$, gen_bool($1, $2, $3));}
        | bexpr lthan boolterm {strcpy($$, gen_bool($1, $2, $3));}
        | bexpr gthan boolterm {strcpy($$, gen_bool($1, $2, $3));}
        | bexpr gequal boolterm {strcpy($$, gen_bool($1, $2, $3));}
        | bexpr lequal boolterm {strcpy($$, gen_bool($1, $2, $3));}
        | bexpr equal boolterm {strcpy($$, gen_bool($1, $2, $3));}
        ;
boolterm : lparen bexpr rparen {strcpy($$, $2);}
        ;
boolterm : ident {strcpy($$, $1);}
        ;
boolterm : BOOLEANLITERAL {strcpy($$,strdup(yylval.sval)); strcpy(type, "boolean");}
        ;
expr       :    term {$$ = strdup($1);}
                | expr div_op term {$$ = gen_infix($1,$2,$3);}
                | expr mult_op term {$$ = gen_infix($1,$2,$3);}
                | expr mod_op term {$$ = gen_infix($1,$2,$3);}
                | expr add_op term {$$ = gen_infix($1,$2,$3);}
                | expr sub_op term {$$ = gen_infix($1,$2,$3);}
                | {error("EXPRESSION EXPECTED, BUT FOUND");}
                ;
term      :     lparen expression rparen   {strcpy($$,$2);}
                ;
term      :     ident      {strcpy($$,$1);}
                ;
term      :     INTLITERAL {$$ = strdup(yylval.sval); type = "integer";}
                | REALLITERAL {$$ = strdup(yylval.sval); type = "real";}
               | CHARLITERAL{$$ =  strdup(yylval.sval); type = "char";}
               | BOOLEANLITERAL {$$ = strdup(yylval.sval); type = "boolean";}
               | {error("NUMERIC VALUE EXPECTED, BUT FOUND");}
                ;
lparen    :     LPAREN
                | {error("( EXPECTED , BUT FOUND");}
                ;
rparen    :     RPAREN
                | {error(") EXPECTED , BUT FOUND");}
                ;
add_op    :     PLUSOP {strcpy ($$,"Add");}
                ;
sub_op    :     MINUSOP {strcpy ($$,"Sub");}
                ;
mod_op    : MODOP {strcpy ($$,"Mod");}
                ;
div_op    : DIVOP {strcpy ($$,"Div");}
                ;
mult_op   : MULTOP {strcpy ($$,"Mult");}
                ;
nequal  :   NEQUAL {strcpy($$, "nequal");}
        ;
lthan   :   LTHAN {strcpy($$, "lthan");}
        ;
gthan    :   GTHAN {strcpy($$, "gthan");}
        ;
gequal  :   GEQUAL {strcpy($$, "gequal");}
        ;
lequal  :   LEQUAL {strcpy($$, "lequal");}
        ;
equal   :   EQUAL {strcpy($$, "equal");}
        ;
or     :   OR {strcpy($$, "or");}
        ;
and     :   AND {strcpy($$, "and");}
        ;
ident     :     ID {strcpy($$, yylval.sval);}
                | {error("IDENTIFIER EXPECTED, BUT NOT FOUND");}
                ;
system_goal :   program  { finish(); }
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