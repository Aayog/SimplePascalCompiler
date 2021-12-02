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
comma       [,]
period		[\.]
assignop    [:][=]
plusop		[+]
minusop  	[-]
multiplyop	[*]
divideop	[/]
modop		[%]
characterliteral	[']({letter}|{digit})[']
realliteral	(0|-?[1-9]{digit}*)[\.]{digit}+
boolliteral	([Tt][Rr][Uu][Ee])|([Ff][Aa][Ll][Ss][Ee])
intliteral      (0|-?[1-9]{digit}*)
id              ({letter}|{underscore})({letter}|{digit}|{underscore})*
notop   [Nn][Oo][Tt]
andop   [Aa][Nn][Dd]
orop    [Oo][Rr]
equal   [\=]
notequal    [<][>]
greaterthan [>]
lessthan    [<]
gequal      [>][=]
lequal      [<][=]
if          [Ii][Ff]
then        [Tt][Hh][Ee][Nn]
while       [Ww][Hh][Ii][Ll][Ee]
do          [Dd][Oo]
%%
[ \t]+                                          {/* do nothing */}
[\n]                                            {/* new line*/}
[Pp][Rr][Oo][Gg][Rr][Aa][Mm]			{return PROGRAM;}
[Vv][Aa][Rr]					{return VAR;}
[Ii][Nn][Tt][Ee][Gg][Ee][Rr]			{return INTEGER;}
[Rr][Ee][Aa][Ll]				{return REAL;}
[Cc][Hh][Aa][Rr]				{return CHAR;}
[Bb][Oo][Oo][Ll][Ee][Aa][Nn]			{return BOOLEAN;}
[Bb][Ee][Gg][Ii][Nn]                            {return START;}
[Ee][Nn][Dd]                                    {return END;}
[Rr][Ee][Aa][Dd]                                {return READ;}
[Ww][Rr][Ii][Tt][Ee]                            {return WRITE;}
{notop}                 {return NOTOP;}
{andop}                 {return ANDOP;}
{orop}                  {return OROP;}
{equal}                 {return EQUAL;}
{notequal}              {return NOTEQUAL;}
{greaterthan}           {return GREATERTHAN;}
{lessthan}              {return LESSTHAN;}
{gequal}                {return GEQUAL;}
{lequal}                {return LEQUAL;}
{if}                    {return IF;}
{then}                  {return THEN;}
{while}                 {return WHILE;}
{do}                    {return DO;}
{comma}                                         {return COMMA;}
{period}					{return PERIOD;}
{semicolon}                                     {return SEMICOLON;}
{colon}						{return COLON;}
{lparen}                                        {return LPAREN;}
{rparen}                                        {return RPAREN;}
{assignop}                                      {return ASSIGNOP;}
{plusop}                                        {return PLUSOP;}
{minusop}                                       {return MINUSOP;}
{multiplyop}					{return MULTIPLYOP;}
{divideop}					{return DIVIDEOP;}
{modop}						{return MODOP;}
{intliteral}                                    {yylval.sval = strdup(yytext); return INTLITERAL;}
{characterliteral}				{yylval.sval = strdup(yytext); return CHARACTERLITERAL;}
{realliteral}					{yylval.sval = strdup(yytext); return REALLITERAL;}
{boolliteral}					{yylval.sval = strdup(yytext); return BOOLLITERAL;}
{id}                                            {yylval.sval = strdup(yytext); return ID;}
[^,]		{std::cout << "SYNTAX ERROR: " << yytext << " IS ILLEGAL" << std::endl;}
%%

