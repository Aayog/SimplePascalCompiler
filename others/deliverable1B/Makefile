SPcompiler: SPparser.tab.c lex.yy.c assign.o declare.o finish.o gen_infix.o read.o write.o type_checker.o convert.o
	g++ SPparser.tab.c lex.yy.c assign.o declare.o finish.o gen_infix.o read.o write.o type_checker.o convert.o -lfl -o SPcompiler
	chmod 777 SPcompiler
	make clean
SPparser.tab.c: token.tab.h SPparser.y
	bison --defines=token.tab.h SPparser.y
lex.yy.c: SPscanner.l
	flex SPscanner.l
assign.o: assign.cpp
	g++ -c assign.cpp
declare.o: declare.cpp
	g++ -c declare.cpp
finish.o: finish.cpp
	g++ -c finish.cpp
gen_infix.o: gen_infix.cpp
	g++ -c gen_infix.cpp
read.o: read.cpp
	g++ -c read.cpp
write.o: write.cpp
	g++ -c write.cpp
type_checker.o: type_checker.cpp
	g++ -c type_checker.cpp
convert.o:
	g++ -c convert.cpp
clean:
	rm SPparser.tab.c
	rm lex.yy.c
	rm *.o
