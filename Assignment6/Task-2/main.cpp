#include <iostream>
#include "Item.cpp"
#include "Inventory.cpp"
#include "Book.cpp"
#include "Movie.cpp"

using namespace std;

#define BUF_SIZE 4096

void instructions() {

    cout << "Welcome to the bookstore inventory management system\n";
    cout << "Please select one of the options below:\n";
    cout << "1: List inventory\n";
    cout << "2: Add a book to the inventory\n";
    cout << "3: Add a movie to the inventory\n";
    cout << "4: Remove an item from inventory\n";
    cout << "5: Lookup item by ISBN\n";
    cout << "6: Lookup items by keyword\n";
    cout << "7: Quit\n";

}

/**
 * Prompts the user for an ISBN number
 * @return zero if an error occurs during input,
 * and the ISBN number otherwise.
 */
int readIsbn() {

    int isbn;
    cout << "ISBN number: ";    
    cin >> isbn;

    if ( cin.fail() ) {
        cout << " Format error" << endl;
        cin.clear();
        cin.ignore(BUF_SIZE,'\n');
        return 0;
    }
    
    // Need to get rid of the end-of-line
    cin.ignore(BUF_SIZE,'\n');
    return isbn;
}

void addBook(Inventory inventory) {

    cout << "Adding a book to the inventory" << endl;
    int isbn = readIsbn();

    if ( isbn ) {
        char buffer[BUF_SIZE];

        cout << "Book title: ";
        cin.getline(buffer,BUF_SIZE);
        string title(buffer);

        cout << "Author name: ";
        cin.getline(buffer,BUF_SIZE);
        string author(buffer);
   
        Book new_book(isbn,title,author);
        inventory.addItem(new_book);

    }

}

void addMovie(Inventory inventory) {

    cout << "Adding a movie to the inventory is under construction" << endl;

}

void removeItem(Inventory inventory) {

    int isbn = readIsbn();

    if ( isbn ) {  
        cout << "Removing item " << isbn << " from the inventory" << endl;
        inventory.removeItem(isbn);
    }

}


void lookupItem(const Inventory& inventory) {

    cout << "Looking-up an item in the inventory" << endl;
    int isbn = readIsbn();
    
    if ( isbn ) {

        Item *item = inventory.lookupItem(isbn);
        if ( item ) {
            cout << item->toString() << endl;
            delete item;
        }
    }
}


void lookupItemsByKeyword(const Inventory& inventory) {

    cout << "Looking-up an item in the inventory" << endl;
    string keyword;

    cout << "keyword: ";    
    cin >> keyword;

    IsbnList list = inventory.lookupItemsByKeyword(keyword);

    // Print the results
    // Add your code here

}



int main() {

    Inventory inventory;

    Book  b1(1001,"Hello World","Alice");
    Book  b2(2002,"Hi There", "Chuck");
    Movie m1(3003,"Blockbuster nb 1", "John");

    inventory.addItem(b1);
    inventory.addItem(m1);
    inventory.addItem(b2);

    cout << inventory.toString() << endl;

    instructions();
    cout << "> ";

    char choice;
    cin >> choice;

    while ( choice != '7' ) {

        switch ( choice ) {

        case '1':
            cout << inventory.toString();
            break;

        case '2':
            addBook(inventory);
            break;

        case '3':
            addMovie(inventory);
            break;

        case '4':
            removeItem(inventory);
            break;

        case '5':
            lookupItem(inventory);
            break;

        case '6':
            lookupItemsByKeyword(inventory);
            break;

        default:
            instructions();
            break;
        }

        cout << "> ";
        cin >> choice;
    }

    return 0;

}


