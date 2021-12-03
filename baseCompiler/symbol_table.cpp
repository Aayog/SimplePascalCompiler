#include <iostream>
#include <unordered_map>
#include "symbol_table.h"

using namespace std;
const int MAX = 1000;
unordered_map<std::string, Node> data;

bool SymbolTable::exists(string id) {
	auto check = data.find(id);
	return check != data.end();
}

Node SymbolTable::find(string id) {
	if (exists(id)) return data.at(id);
	// This likely won't get called since the data should be checked to exist first. There as a backup.
	return Node("", "", "");
}

bool SymbolTable::modify(string id, string value, string type) {
	if (!exists(id)) return false;
	Node current = find(id);
	current.setValue(value);
	current.setType(type);
	data.at(id) = current;
	return true;
}

bool SymbolTable::deleteRecord(string id) {
	data.erase(id);
	return false;
}

string SymbolTable::getValue(string id) {
	if (!exists(id)) return "";
	return find(id).getValue();
}

string SymbolTable::getType(string id) {
	if (!exists(id)) return "";
	return find(id).getType();
}

bool SymbolTable::insert(string id, string value, string type) {
	data[id] = Node(id, value, type);
	return true;
}
