import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app_sqflite/models/todo.dart';

class DatabaseHelper {
  static final _dbName = 'TodoDatabase.db';
  static final _dbVersion = 1;

  static final table = 'todo';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnSubtitle = 'subtitle';
  static final columnIsFavorite = 'isFavorite';

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
                CREATE TABLE $table (
                  $columnId INTEGER PRIMARY KEY,
                  $columnTitle TEXT NOT NULL,
                  $columnSubtitle TEXT NOT NULL,
                  $columnIsFavorite INTEGER
                )
              ''');
  }

  Future<int> insert(Map<String, dynamic> todo) async {
    Database db = await instance.database;
    return await db.insert(table, todo);
  }

  Future delete(int id) async {
    Database db = await instance.database;
    db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future update(Map<String, dynamic> todo) async {
    Database db = await instance.database;
    return await db
        .update(table, todo, where: '$columnId = ?', whereArgs: [todo['_id']]);
  }

  Future<List<Todo>> queryAllFavourite() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(table,
        where: '$columnIsFavorite = ?',
        whereArgs: [1],
        orderBy: columnId + " DESC");
    List<Todo> todos = [];
    result.forEach((element) {
      todos.add(Todo.fromMap(element));
    });

    return todos;
  }

  Future<List<Todo>> queryAll() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.query(table, orderBy: columnId + " DESC");
    List<Todo> todos = [];
    result.forEach((element) {
      todos.add(Todo.fromMap(element));
    });
    return todos;
  }
}
