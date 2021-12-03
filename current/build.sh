flex SPscanner.l
bison --defines=token.tab.h SPparser.y
g++ assign.cpp declare.cpp finish.cpp gen_infix.cpp read.cpp symbol_table.cpp write.cpp lex.yy.c SPparser.tab.c -lfl -oS
