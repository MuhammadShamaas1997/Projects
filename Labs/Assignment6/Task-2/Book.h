
//#include "Item.h"


/**
 * Represents a book
 * Objects of type Book are immutable
 */
class Book : public Item {

 public:

    Book(int isbn, std::string title, std::string author);

    virtual Book* clone() const;
 
    std::string getAuthor() const;

    virtual bool matches(std::string keyword) const;

    virtual std::string toString() const;

 private:

    std::string _author;

};


