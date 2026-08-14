import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // نمونه واحد (Singleton)
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hse_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // جدول بازرسی‌ها
        await db.execute('''
          CREATE TABLE inspections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            checklistTitle TEXT,
            assetLabel TEXT,
            assetValue TEXT,
            inspectorName TEXT,
            date TEXT
          )
        ''');

        // جدول پاسخ‌ها
        await db.execute('''
          CREATE TABLE inspection_answers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inspectionId INTEGER,
            itemText TEXT,
            answer TEXT,
            note TEXT
          )
        ''');
      },
    );
  }

  // ===== توابع جدید (قدم ۷) =====

  // ۱) ذخیره یک بازرسی
  Future<int> insertInspection(Map<String, dynamic> inspectionData) async {
    final db = await database;
    return db.insert('inspections', inspectionData);
  }

  // ۲) ذخیره پاسخ‌های یک بازرسی
  Future<int> insertAnswer(Map<String, dynamic> answerData) async {
    final db = await database;
    return db.insert('inspection_answers', answerData);
  }

  // ۳) دریافت همه بازرسی‌ها (جدیدترین اول)
  Future<List<Map<String, dynamic>> getInspections() async {
    final db = await database;
    return db.query('inspections', orderBy: 'id DESC');
  }

  // ۴) دریافت پاسخ‌های یک بازرسی خاص
  Future<List<Map<String, dynamic>>> getAnswersByInspectionId(int inspectionId) async {
    final db = await database;
    return db.query(
      'inspection_answers',
      where: 'inspectionId = ?',
      whereArgs: [inspectionId],
    );
  }

  // ۵) حذف یک بازرسی
  Future<int> deleteInspection(int inspectionId) async {
    final db = await database;
    return db.delete(
      'inspections',
      where: 'id = ?',
      whereArgs: [inspectionId],
    );
  }
}
