%{
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include "SPparser.tab.h"
extern "C" int yylex();
%}
letter  [a-zA-Z]
digit   [0-9]
semicolon       [;]
colon           [:]
underscore      [_]
apostrophe [']
lparen          [(]
rparen          [)]
lthan       [<]
gthan           [>]
gequal          ([>][=])
lequal          ([<][=])
equal           [=]
nequal          ([<][>])
comma           [,]
period          [\.]
assignop        [:][=]
plusop          [+]
minusop         [-]
multop      [*]
divop       [/]
modop       [%]
intliteral      (-?[1-9]{digit}*)
realliteral     ([+-]?([0-9]*[.])?[0-9]+)
charliteral     (\'.\')
booleanliteral  (true|false)
id              [a-zA-Z_][a-zA-Z0-9_]*
%%
[ \t]+                                          {/* do nothing */}
[\n]                                            {/* new line*/}
[Pp][Rr][Oo][Gg][Rr][Aa][Mm]                    {return PROGRAM;}
[Vv][Aa][Rr]                                    {return VAR;}
[Ii][Nn][Tt][Ee][Gg][Ee][Rr]                    {return INTEGER;}
[Rr][Ee][Aa][Ll]                                {return REAL;}
[Cc][Hh][Aa][Rr]                                {return CHAR;}
[Bb][Oo][Oo][Ll][Ee][Aa][Nn]                    {return BOOLEAN;}
[Bb][Ee][Gg][Ii][Nn]                            {return START;}
[Ee][Nn][Dd]                                    {return END;}
[Rr][Ee][Aa][Dd]                                {return READ;}
[Ww][Rr][Ii][Tt][Ee]                            {return WRITE;}
[Ii][Ff]                                        {return IF;}
[Tt][Hh][Ee][Nn]                                {return THEN;}
[Ww][Hh][Ii][Ll][Ee]                            {return WHILE;}
[Dd][Oo]                                        {return DO;}
[Aa][Nn][Dd]                                    {return AND;}
[Oo][Rr]                                        {return OR;}
[Nn][Oo][Tt]                                    {return NOT;}
{nequal}                                        {return NEQUAL;}
{lthan}                                         {return LTHAN;}
{gthan}                                         {return GTHAN;}
{gequal}                                        {return GEQUAL;}
{lequal}                                        {return LEQUAL;}
{equal}                                         {return EQUAL;}
{comma}                                         {return COMMA;}
{period}                                        {return PERIOD;}
{semicolon}                                     {return SEMICOLON;}
{colon}                                         {return COLON;}
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
{id}                                            {yylval.sval = strdup(yytext); return ID;}
%%