/* Program name: AIDGSQL.db
*  Author: Nooreddin Hellalat
*  Date last updated: 10/11/2024
* Purpose: The program will be a text menu-based application that allows someone to manipulate and access/connect the data in AIDG.db
*/
#include <iostream>
#include <string>
#include <sqlite3.h>  // Include the SQLite library
#include <limits>     
using namespace std;

// Function to connect to the database
sqlite3* connectDB() {
    sqlite3* DB;
    int exit = sqlite3_open("AIDG.db", &DB); //AIDG database
    if (exit) {
        cerr << "Error in connection to database: " << sqlite3_errmsg(DB) << endl; //Error
        return nullptr;
    }
    return DB;
}

// Function to get a valid integer input validation
int getValidInt() {
    int value;
    while (true) {
        cout << "Enter an integer value: ";
        cin >> value;
        if (cin.fail()) {
            cin.clear(); // clear the error flag
            cin.ignore(numeric_limits<streamsize>::max(), '\n'); // discard invalid input
            cout << "Invalid input. Please enter a valid integer." << endl;
        } else {
            cin.ignore(numeric_limits<streamsize>::max(), '\n'); // discard any remaining input
            return value;
        }
    }
}

// Function to get a valid double input validation
double getValidDouble() {
    double value;
    while (true) {
        cout << "Enter a double value: ";
        cin >> value;
        if (cin.fail()) {
            cin.clear(); // clear the error flag
            cin.ignore(numeric_limits<streamsize>::max(), '\n'); // discard invalid input
            cout << "Invalid input. Please enter a valid double." << endl;
        } else {
            cin.ignore(numeric_limits<streamsize>::max(), '\n'); // discard any remaining input
            return value;
        }
    }
}

// Function to add a record to the Suits_Programmers table
void addSuitsProgrammers(sqlite3* db) {
    int P_ID, AIDG_ID;
    double expenses, net_worth;
    string role;
    //Menu
    cout << "Enter P_ID: ";
    P_ID = getValidInt();
    cout << "Enter AIDG_ID: ";
    AIDG_ID = getValidInt();
    cout << "Enter Expenses: ";
    expenses = getValidDouble();
    cout << "Enter Net Worth: ";
    net_worth = getValidDouble();
    cout << "Enter Role: ";
    cin.ignore(); 
    getline(cin, role);

    string sql = "INSERT INTO Suits_Programmers (P_ID, AIDG_ID, Expenses, Net_worth, Role) VALUES (?, ?, ?, ?, ?)";
    sqlite3_stmt* stmt;

    sqlite3_prepare_v2(db, sql.c_str(), -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, P_ID);
    sqlite3_bind_int(stmt, 2, AIDG_ID);
    sqlite3_bind_double(stmt, 3, expenses);
    sqlite3_bind_double(stmt, 4, net_worth);
    sqlite3_bind_text(stmt, 5, role.c_str(), -1, SQLITE_STATIC);

    if (sqlite3_step(stmt) != SQLITE_DONE) {
        cout << "Error inserting data: " << sqlite3_errmsg(db) << endl; //Error
    } else {
        cout << "Record added successfully." << endl; //Record add success
    }
    
    sqlite3_finalize(stmt);
}

// Function to update a record in the Supply table
void updateSupply(sqlite3* db) {
    int supply_id, stock_level;
    double cost;
    //Sub menu
    cout << "Enter Supply_ID to update: ";
    supply_id = getValidInt(); //Variable Validation
    cout << "Enter new Stock Level: ";
    stock_level = getValidInt(); //Variable Validation
    cout << "Enter new Cost: ";
    cost = getValidDouble(); //Variable Validation

    string sql = "UPDATE Supply SET Stock_Level = ?, Cost = ? WHERE Supply_ID = ?";
    sqlite3_stmt* stmt;

    sqlite3_prepare_v2(db, sql.c_str(), -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, stock_level);
    sqlite3_bind_double(stmt, 2, cost);
    sqlite3_bind_int(stmt, 3, supply_id);

    if (sqlite3_step(stmt) != SQLITE_DONE) {
        cout << "Error updating data: " << sqlite3_errmsg(db) << endl; //Error
    } else {
        cout << "Record updated successfully." << endl; //Record add success
    }

    sqlite3_finalize(stmt);
}

// Function to delete a record from the Appointment table
void deleteAppointment(sqlite3* db) {
    int appointment_number;

    cout << "Enter Appointment_number to delete: ";
    appointment_number = getValidInt();

    string sql = "DELETE FROM Appointment WHERE Appointment_number = ?";
    sqlite3_stmt* stmt;

    sqlite3_prepare_v2(db, sql.c_str(), -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, appointment_number);

    if (sqlite3_step(stmt) != SQLITE_DONE) {
        cout << "Error deleting data: " << sqlite3_errmsg(db) << endl; //Error
    } else {
        cout << "Record deleted successfully." << endl; //Record add success
    }

    sqlite3_finalize(stmt);
}

// Function to handle the transaction for an order
void handleTransaction(sqlite3* db) {
    int order_id, product_id, quantity, customer_id;
    double order_total;
    // Begin transaction
    sqlite3_exec(db, "BEGIN TRANSACTION;", nullptr, nullptr, nullptr);

    // Step 1: Create an order in the Order_Supplies table
    cout << "Enter Order ID: ";
    order_id = getValidInt(); //Variable Validation
    cout << "Enter Customer ID: ";
    customer_id = getValidInt(); //Variable Validation
    cout << "Enter Order Total: ";
    order_total = getValidDouble(); //Variable Validation
    
    //Inserts
    string createOrderSql = "INSERT INTO Order_Supplies (Order_ID, Customer_ID, Total) VALUES (?, ?, ?)";
    sqlite3_stmt* stmt;
    sqlite3_prepare_v2(db, createOrderSql.c_str(), -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, order_id);
    sqlite3_bind_int(stmt, 2, customer_id);
    sqlite3_bind_double(stmt, 3, order_total);
    
    //Rollback error
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        cout << "Error inserting order: " << sqlite3_errmsg(db) << endl;
        sqlite3_exec(db, "ROLLBACK;", nullptr, nullptr, nullptr);
        sqlite3_finalize(stmt);
        return;
    }
    sqlite3_finalize(stmt);
    
    // Step 2: Update the stock level for the product
    cout << "Enter Product ID: ";
    product_id = getValidInt(); //Variable Validation
    cout << "Enter Quantity: ";
    quantity = getValidInt(); //Variable Validation
    
    //Update
    string updateStockSql = "UPDATE Supply SET Stock_Level = Stock_Level - ? WHERE Product_ID = ?";
    sqlite3_prepare_v2(db, updateStockSql.c_str(), -1, &stmt, nullptr);
    sqlite3_bind_int(stmt, 1, quantity);
    sqlite3_bind_int(stmt, 2, product_id);
    
    //Rollback error
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        cout << "Error updating stock: " << sqlite3_errmsg(db) << endl;
        sqlite3_exec(db, "ROLLBACK;", nullptr, nullptr, nullptr);
        sqlite3_finalize(stmt);
        return;
    }
    sqlite3_finalize(stmt);

    // Step 3: Commit the transaction
    sqlite3_exec(db, "COMMIT;", nullptr, nullptr, nullptr);
    cout << "Transaction completed successfully." << endl; //Transaction complete
}

// Function to display a joined report
void displayJoinReport(sqlite3* db) {
    string sql = "SELECT Customer.Name, Appointment.Schedule_date, AI_Detail_Guy.Customer_cars "
                 "FROM Customer "
                 "JOIN Appointment ON Customer.Customer_ID = Appointment.Customer_ID "
                 "JOIN AI_Detail_Guy ON Appointment.AIDG_ID = AI_Detail_Guy.AIDG_ID";
    
    sqlite3_stmt* stmt;
    sqlite3_prepare_v2(db, sql.c_str(), -1, &stmt, nullptr);
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        string name = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 0));
        string date = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
        string car = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 2));
        
        cout << "Customer: " << name << ", Date: " << date << ", Car: " << car << endl;
    }
    
    sqlite3_finalize(stmt);
}

// Main menu
void showMenu() {
    cout << "1. Add Record\n";
    cout << "2. Update Record\n";
    cout << "3. Delete Record\n";
    cout << "4. Handle Transaction\n";
    cout << "5. Display Join Report\n";
    cout << "6. Exit\n";
}

// Main function
int main() {
    sqlite3* db = connectDB();
    if (!db) return 1;
    
    int choice;
    
    while (true) {
        showMenu();
        cout << "Choose an option: ";
        choice = getValidInt(); //Variable Validation
        
        switch (choice) {
            case 1: addSuitsProgrammers(db); break;
            case 2: updateSupply(db); break;
            case 3: deleteAppointment(db); break;
            case 4: handleTransaction(db); break;
            case 5: displayJoinReport(db); break;
            case 6: sqlite3_close(db); return 0; // Close the database
            default: cout << "Invalid option. Please try again." << endl;
        }
    }

    sqlite3_close(db); // Close the database before exiting
    return 0;
}
