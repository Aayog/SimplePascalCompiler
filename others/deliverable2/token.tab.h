/* A Bison parser, made by GNU Bison 3.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_TOKEN_TAB_H_INCLUDED
# define YY_YY_TOKEN_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PROGRAM = 258,
    VAR = 259,
    START = 260,
    END = 261,
    READ = 262,
    WRITE = 263,
    ASSIGNOP = 264,
    INTEGER = 265,
    INTLITERAL = 266,
    CHAR = 267,
    CHARACTERLITERAL = 268,
    BOOLEAN = 269,
    BOOLLITERAL = 270,
    REAL = 271,
    REALLITERAL = 272,
    LPAREN = 273,
    RPAREN = 274,
    COMMA = 275,
    PERIOD = 276,
    SEMICOLON = 277,
    COLON = 278,
    PLUSOP = 279,
    MINUSOP = 280,
    ID = 281,
    MULTIPLYOP = 282,
    DIVIDEOP = 283,
    MODOP = 284,
    NOTOP = 285,
    ANDOP = 286,
    OROP = 287,
    EQUAL = 288,
    NOTEQUAL = 289,
    GREATERTHAN = 290,
    LESSTHAN = 291,
    GEQUAL = 292,
    LEQUAL = 293,
    IF = 294,
    THEN = 295,
    WHILE = 296,
    DO = 297
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 30 "SPparser.y"

       int ival;
       char * sval;
       

#line 106 "token.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_TOKEN_TAB_H_INCLUDED  */
