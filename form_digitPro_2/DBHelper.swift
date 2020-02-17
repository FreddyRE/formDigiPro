//
//  DBHelper.swift
//  form_digitPro_2
//
//  Created by Freddy Romero Espinosa on 2/17/20.
//  Copyright © 2020 Freddy Romero Espinosa. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()

    }

    let dbPath: String = "PersonDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,name TEXT,lastName TEXT,secondLastN TEXT,email TEXT,phone TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {

                 
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    
    
    func insert(id:Int, name:String, lastName:String, secondLastName:String, email:String, phone:String)
    {
        let persons = read()
        for p in persons
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO person (Id, name, lastName, secondLastN, email, phone) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (secondLastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (phone as NSString).utf8String, -1, nil)

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                ItemListVC.wasSavedDataCorrectly = true
                
            } else {
                ItemListVC.wasSavedDataCorrectly = false

                print("Could not insert row.")
            }
        } else {
            ItemListVC.wasSavedDataCorrectly = false

            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Person] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let secondLastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let phone = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))


                psns.append(Person(id: Int(id), name: name, lastName: lastName, secondLastN: secondLastName, email: email, phone: phone))
                print("Query Result:")
                print("\(id) | \(name) | \(lastName) | \(secondLastName) | \(email) | \(phone)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func readId() -> Int32 {
        let queryStatementString = "SELECT * FROM person WHERE Id = (SELECT MAX(Id)  FROM person);"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
              
                print("Query ID:")
                print("\(id)")
                
                return id
            }
        } else {
            print("SELECT ID could not be loaded")
        }
        sqlite3_finalize(queryStatement)
        return 0
        
    }
    
    
    
}
