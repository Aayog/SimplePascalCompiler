%{
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include "token.tab.h"
extern "C" int yylex();
%}
letter  [a-zA-Z]
digit   [0-9]
semicolon	[;]
colon		[:]
underscore	[_]
lparen		[(]
rparen		[)]
comma           [,]
period		[\.]
assignop        [:][=]
plusop		[+]
minusop  	[-]
multop      [*]
divop       [/]
modop       [%]
intliteral      (0|-?[1-9]{digit}*)
realliteral     ([+-]?([0-9]*[.])?[0-9]+)
charliteral     (.)
booleanliteral  (true|false)
and             [&&]
or              [||]
not             [!]
LT              [<]
GT              [<]
EQ              [=]
LE              [<=]
GE              [>=]
NE              [<>] 
id              ({letter}|{underscore})({letter}|{digit}|{underscore})*
%%
[ \t]+                                          {/* do nothing */}
[\n]                                            {/* new line*/}
[Pp][Rr][Oo][Gg][Rr][Aa][Mm]			{return PROGRAM;}
[Vv][Aa][Rr]					{return VAR;}
[Ii][Nn][Tt][Ee][Gg][Ee][Rr]			{return INTEGER;}
[Rr][Ee][Aa][Ll]                        {return REAL;}
[Cc][Hh][Aa][Rr]                        {return CHAR;}
[Bb][Oo][Oo][Ll][Ee][Aa][Nn]            {return BOOLEAN;}
[Bb][Ee][Gg][Ii][Nn]                            {return START;}
[Ee][Nn][Dd]                                    {return END;}
[Rr][Ee][Aa][Dd]                                {return READ;}
[Ww][Rr][Ii][Tt][Ee]                            {return WRITE;}
{comma}                                         {return COMMA;}
{period}					{return PERIOD;}
{semicolon}                                     {return SEMICOLON;}
{colon}						{return COLON;}
{lparen}                                        {return LPAREN;}
{rparen}                                        {return RPAREN;}
{assignop}                                      {return ASSIGNOP;}
{plusop}                                        {return PLUSOP;}
{minusop}                                       {return MINUSOP;}
{multop}                                        {return MULTOP;}
{divop}                                         {return DIVOP;}
{modop}                                         {return MODOP;}
{intliteral}                                    {yylval.sval = strdup(yytext); return INTLITERAL;}
{realliteral}                                   {yylval.sval = strdup(yytext); return REALLITERAL;}
{charliteral}                                   {yylval.sval = strdup(yytext); return CHARLITERAL;}
{booleanliteral}                                {yylval.sval = strdup(yytext); return BOOLEANLITERAL;}
{id}                                            {yylval.sval = strdup(yytext); return ID;}
{and}                                           {return AND;}
{or}                                            {return OR; } 
{not}                                           {return NOT;}
{LT}                                            {return LT; } 
{GT}                                            {return GT; } 
{EQ}                                            {return EQ; } 
{LE}                                            {return LE; } 
{GE}                                            {return GE; } 
{NE}                                            {return NE; }  
[^,]		{std::cout << "SYNTAX ERROR: " << yytext << " IS ILLEGAL" << std::endl;}
%%

