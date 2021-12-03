%{
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include "SPparser.tab.h"
extern "C" int yylex();
%}
letter  [a-zA-Z]
digit   [0-9]
semicolon	[;]
colon		[:]
underscore	[_]
apostrophe [']
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
intliteral      (-?[1-9]{digit}*)
realliteral     ([+-]?([0-9]*[.])?[0-9]+)
charliteral     ([a-zA-Z0-9])
booleanliteral  ([Tt][Rr][Uu][Ee]|[Ff][Aa][Ll][Ss][Ee])
and             [&&]
or              [||]
not             [!]
LT              [<]
GT              [<]
EQ              [=]
LE              [<=]
GE              [>=]
NE              [<>]
id              [a-zA-Z_][a-zA-Z0-9_]*
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
{apostrophe}                                    {return APOSTROPHE;}
{intliteral}                                    {yylval.sval = strdup(yytext); return INTLITERAL;}
{realliteral}                                   {yylval.sval = strdup(yytext); return REALLITERAL;}
{charliteral}                                   {yylval.sval = strdup(yytext); return CHARLITERAL;}
{booleanliteral}                                {yylval.sval = strdup(yytext); return BOOLEANLITERAL;}
{and}                                           {return AND;}
{or}                                            {return OR; } 
{not}                                           {return NOT;}
{LT}                                            {return LT; } 
{GT}                                            {return GT; } 
{EQ}                                            {return EQ; } 
{LE}                                            {return LE; } 
{GE}                                            {return GE; } 
{NE}                                            {return NE; } 
{id}                                            {yylval.sval = strdup(yytext); return ID;}
%%

