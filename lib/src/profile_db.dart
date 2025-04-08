import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper _instance = LocalDatabaseHelper._internal();
  factory LocalDatabaseHelper() => _instance;
  LocalDatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'profile.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            profile TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveProfile(String profileJson) async {
    final db = await database;
    await db.delete('user_profile');
    await db.insert('user_profile', {'profile': profileJson});
  }

  Future<String?> getSavedProfile() async {
    final db = await database;
    final result = await db.query('user_profile');
    if (result.isNotEmpty) {
      return result.first['profile'] as String?;
    }
    return null;
  }
}
