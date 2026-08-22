import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SessionDatabase {
  SessionDatabase._();

  static final SessionDatabase instance = SessionDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'kine_connect.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE session_notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            note INTEGER NOT NULL,
            patient TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertSession({
    required int note,
    required String date,
    required String patient,
  }) async {
    final db = await database;

    return db.insert('session_notes', {
      'note': note,
      'patient': patient,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await database;
    return db.query('session_notes', orderBy: 'date ASC');
  }

  Future<void> deleteAllSessions() async {
    final db = await database;
    await db.delete('session_notes');
  }
}
