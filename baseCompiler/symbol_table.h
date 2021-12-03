#include <iostream>
#include <unordered_map>
#include "Node.h"

class SymbolTable {
private:
    std::unordered_map<std::string, Node> data;

public:
    SymbolTable() {

    }

    bool exists(std::string id);
    Node find(std::string id);
    bool insert(std::string id, std::string value, std::string type);
    bool deleteRecord(std::string id);
    bool modify(std::string id, std::string value, std::string type);
    std::string getType(std::string id);
    std::string getValue(std::string id);
};
