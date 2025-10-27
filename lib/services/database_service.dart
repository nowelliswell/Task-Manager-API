import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late Database _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal() {
    _database = sqlite3.open('tasks_manager.db');
    _initTables();
  }

  Database get db => _database;

  void _initTables() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      );
    ''');

    _database.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        is_completed INTEGER,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users(id)
      );
    ''');
  }
}
