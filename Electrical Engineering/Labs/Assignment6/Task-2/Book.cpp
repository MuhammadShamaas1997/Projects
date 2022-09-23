#include <iostream>
#include "Book.h"

using namespace std;

Book::Book(int isbn, std::string title, std::string author)
    : Item(isbn,title),
      _author(author) {
}

Book* 
Book::clone() const { 
    return new Book(*this); 
}
 
std::string 
Book::getAuthor() const { 
    return _author; 
}


bool 
Book::matches(std::string keyword) const { 
    return ( (_author.find(keyword) != std::string::npos)
             || Item::matches(keyword)); 
}
    

std::string 
Book::toString() const {

    std::stringstream s;
    s << "Book={" 
      << Item::toString()
      << ", author=" << _author
      << "}";
    return s.str();
}

