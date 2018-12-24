'use strict';

//==============================================================================
//Global references and variables

//seem to need this to be able to install better-sqlite:
//npm config set unsafe-perm=true

const fs = require('fs');
const sqliteParser = require('sqlite-parser');
const Database = require('better-sqlite3');

var db;
var db_schema;

//==============================================================================
//DB Fuctions

function createDatabase(dbName){
  try{
    //get sql
    let schema_sql = fs.readFileSync(`database/sql/${dbName}_schema.sql`, 'utf8');
    let data_sql = fs.readFileSync(`database/sql/${dbName}_data.sql`, 'utf8');

    //create schema json file
    let ast = sqliteParser(schema_sql);
    ast = ast.statement;
    ast = ast.filter(obj => !(obj.variant == "transaction" && (obj.action === "begin" || obj.action === "commit")));
    ast = ast.filter(obj => !(obj.variant === "drop"));
    fs.writeFileSync(`database/database/${dbName}_schema.json`, JSON.stringify(ast, null, 2));

    //create database file
    let db = new Database(`database/database/${dbName}.db`);
    db.pragma('defer_foreign_keys = true'); //defer foreign key constraints until the end of the next transaction
    db.exec(schema_sql);
    db.pragma('defer_foreign_keys = true');
    db.exec(data_sql);
    db.close();
  }
  catch (err){
    console.log(err);
  }
}

function deleteDatabase(dbName){
  try{
    fs.unlinkSync(`database/database/${dbName}_schema.json`);
    fs.unlinkSync(`database/database/${dbName}.db`);
  }
  catch (err){
    console.log(err);
  }
}

//---------------------------------

function openDatabase(dbName){
  try{
    db = new Database(`database/database/${dbName}.db`);
    db_schema = JSON.parse(fs.readFileSync(`database/database/${dbName}_schema.json`, 'utf8'));
  }
  catch(err){
    console.log(err);
  }
}

function closeDatabase(){
  try{
    db = undefined;
    db_schema = undefined;
  }
  catch(err){
    console.log(err);
  }
}

//---------------------------------

/*
Choice of how to design this database API is difficult because there are many different options
which vary in terms of simplicity, performance, safety, flexibility etc...

Ultimately, I can't concretely know what we actually need because it depends entirely on the capabilities
of the editing table that we want support.

Some things I have kept in mind:
-Don't use exec, use prepare and get/all/run.
-Bind all sql values into statement instead of including them manually to prevent sql injection
-For all other variables which can't be bound to prepared statements (e.g. table and field names),
use a lookup to the schema json to confirm their identity before executing any sql.
-For the sake of performance, attempt to use as few prepared statements and schema lookups as possible.
-This means designing your functions to execute accross many records rather than just one and passing around
of prepared statement once it has been created once.
-Insert statements automatically make use of default values. Also there is a special insert statement for only
inserting default values/nulls for all fields.

Simple:

1. SELECT * FROM table                                                          (get table)
2. SELECT * FROM table WHERE primarykey = pkID                                  (get row of table)
3. SELECT field FROM table WHERE primarykey = pkID                              (get cell of table)

4. INSERT INTO table VALUES(values)                                             (for creating new row with all data)
5. INSERT INTO table DEFAULT VALUES                                             (for creating a new row)

More complicated:

6. UPDATE table SET field = value WHERE PRIMARYKEY = pkID
7. INSERT INTO table(fields) VALUES (values)                                    (for creating row with some/all data)
*/

//==============================================================================
//Exec

deleteDatabase("chinook");
createDatabase("chinook");
openDatabase("chinook");
closeDatabase();
