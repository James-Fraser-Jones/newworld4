'use strict';

//==============================================================================
//Global references and variables

const fs = require('fs');
const sqliteParser = require('sqlite-parser');
const Database = require('better-sqlite3');

//==============================================================================
//Fuctions

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

//==============================================================================
//Exec

deleteDatabase("chinook");
createDatabase("chinook");
