import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
//final String tableWords = 'words';
//final String columnId = '_id';
//final String columnWord = 'word';
//final String columnFrequency = 'frequency';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "uberCritique.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    print("initializing DB...");
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print("path: $path");
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    print("creating TABLE...");

    String script = await rootBundle.loadString("assets/sql/init.sql");
    List<String> scripts = script.split(";");
    scripts.forEach((v) {
      if (v.isNotEmpty) {
        print(v.trim());
        db.execute(v.trim());
      }
    });

    /*await db.execute('''
              CREATE TABLE $tableWords (
                $columnId INTEGER PRIMARY KEY,
                $columnWord TEXT NOT NULL,
                $columnFrequency INTEGER NOT NULL
              )
              ''');*/
  }

  Future checkDB() async {
    Database? db = await database;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print("path: $path");
    File f = new File(path);
    if (!(await f.exists())) {
      print("DB does not exists!!!");
    } else {
      print("Exists!!!");
    }
  }

  Future removeDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print("path: $path");
    File f = new File(path);
    f.delete();
    print("DB File deleted");
  }

  /*Future insert(dataModel) async {
    Database db = await database;
    int id = await db.insert(dataModel.tableName, dataModel.toMap());
    return id;
  }

  Future queryAll(tableName) async {
    Database db = await database;
    List<Map> result = await db.query(tableName);
    result.forEach((row) {
      print(row);
    });
  }*/

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
