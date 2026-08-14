import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hse_inspections.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE inspections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        checklistId TEXT NOT NULL,
        checklistTitle TEXT NOT NULL,
        assetLabel TEXT,
        assetValue TEXT,
        inspectorName TEXT,
        location TEXT,
        inspectionDate TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE inspection_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        inspectionId INTEGER NOT NULL,
        itemId TEXT NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        correctiveAction TEXT,
        note TEXT,
        FOREIGN KEY (inspectionId) REFERENCES inspections (id) ON DELETE CASCADE
      )
    ''');
  }
}
