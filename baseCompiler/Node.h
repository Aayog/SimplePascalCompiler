#include <iostream>

class Node {
    // I know you wanted type to be enum but I wasn't really sure how to implement that
    std::string identifier, value, type;

public:
    Node() {

    }

    Node(std::string identifier, std::string value, std::string type) {
        this->identifier = identifier;
        this->value = value;
        this->type = type;
    }

    std::string getValue() { return value; }
    std::string getType() { return type; }
    std::string getId() { return identifier; }
    void setValue(std::string value) { this->value = value; }
    void setType(std::string type) { this->type = type; }

    friend class SymbolTable;
};