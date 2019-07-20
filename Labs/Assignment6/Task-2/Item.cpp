#include <iostream>
#include "Item.h"

using namespace std;

Item::Item(int isbn, std::string title) 
    : _isbn(isbn), _title(title) {
}

Item::~Item() {
}

int 
Item::getIsbn() const { 
    return _isbn; 
}

std::string 
Item::getTitle() const { 
    return _title; 
}

bool 
Item::matches(std::string keyword) const { 
    return (_title.find(keyword) != std::string::npos); 
}
    

std::string 
Item::toString() const {
        
    std::stringstream s;
    s << "Item={" 
      << "isbn=" << _isbn
      << ",title=" << _title
      << "}";
    return s.str();

}

