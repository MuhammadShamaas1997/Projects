
#include <string>
#include <sstream>

/**
 * Represents an item in the book store
 */ 
class Item {

 public:

    Item(int isbn, std::string title);

    virtual Item* clone() const = 0;

    virtual ~Item();

    int getIsbn() const;
    
    std::string getTitle() const;

    /**
     * @return true if given keyword appears in the title
     * of this item, false otherwise
     */
    virtual bool matches(std::string keyword) const;
    
    virtual std::string toString() const;
    
 private:

    int _isbn;
    std::string _title;

};

