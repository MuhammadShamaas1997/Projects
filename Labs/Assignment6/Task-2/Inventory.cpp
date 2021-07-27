#include <iostream>
#include "Inventory.h"

using namespace std;

Inventory::Inventory() {
}

Inventory::Inventory(const Inventory& old) {

    ItemTable::const_iterator i;
    
    for ( i = old._table.begin(); i != old._table.end(); ++i ) {
        addItem(*(i->second));
    }

}

Inventory::~Inventory() {

    ItemTable::const_iterator i;

    for ( i = _table.begin(); i != _table.end(); ++i ) {
        delete i->second;
    }

}

void 
Inventory::addItem(const Item& new_item) {

    // Lookup item in inventory
    ItemTable::const_iterator i = _table.find(new_item.getIsbn());
    
    // If item does not yet exist, add it
    if ( i == _table.end() ) {        
        Item *ptrItem = new_item.clone();
        _table[ptrItem->getIsbn()] = ptrItem;
    } else {
        cout << "Warning: Item with isbn " << new_item.getIsbn() 
             << " already exists" << endl;
    }
    
}

void
Inventory::removeItem(int isbn) {

   cout << "Removing item from inventory is under construction" << endl; 

}

Item* 
Inventory::lookupItem(int isbn) const {
   
    // Lookup item in inventory
    ItemTable::const_iterator i = _table.find(isbn);
    
    // If item does not yet exist, print a warning
    if ( i == _table.end() ) {        
        cout << "Warning: item " << isbn << " is not in the inventory" << endl;
        return NULL;
    } else {
        Item *ptrItem = i->second;
        return ptrItem->clone();
    }

}
 
IsbnList
Inventory::lookupItemsByKeyword(string keyword) const {

    IsbnList list;

    ItemTable::const_iterator i;
    for ( i = _table.begin(); i != _table.end(); ++i ) {
        
        if ( i->second->matches(keyword) ) {
            list.push_back(i->second->getIsbn());
        }

    }

    return list;

}


string 
Inventory::toString() const {

    stringstream s;
   
    s << "Inventory={\n";

    ItemTable::const_iterator i;
    for ( i = _table.begin(); i != _table.end(); ++i ) {

        //int isbn = i->first;  // Not needed, but shown here as example      
        Item *item = i->second;
        s << "\t" << item->toString() << endl;
    }
    s << "}\n";

    return s.str();
}





