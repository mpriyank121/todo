import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'to_do_model.dart';

class DB_helper {
  static final DB_helper instance = DB_helper._init();
  static Database? _database;

  DB_helper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    print('Initialize');
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isChecked INTEGER NOT NULL
      )
    ''');
    print('created');
  }

  // Insert Task
  Future<int> insertTask(Todo task) async {
    final db = await instance.database;
    return await db.insert('todo', task.toMap());
  }

  // Fetch Tasks
  Future<List<Todo>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query('todo');
    return result.map((json) => Todo.fromMap(json)).toList();
  }

  // Update Task
  Future<int> updateTask(Todo task) async {
    final db = await instance.database;
    return await db.update(
      'todo',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete Task
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
