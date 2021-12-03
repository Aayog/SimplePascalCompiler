#include <string>

enum Type {Integer,
	Real,
	Char,
	Boolean,
	DNE};
static const char* TypeStrings[] = {"integer","real","char","boolean","INVALID"};

struct ID {
    Type type;
    std::string name;
};

extern int max_temp;
