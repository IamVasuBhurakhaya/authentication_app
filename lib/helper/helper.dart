import 'package:sqflite/sqflite.dart';
import '../modal/modal.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();
  Database? db;

  final String tUser = 'user';
  final String id = 'id';
  final String name = 'name';
  final String email = 'email';
  final String password = 'password';

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/user.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) {
        db.execute('''
          CREATE TABLE $tUser(
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $name TEXT NOT NULL,
            $email TEXT UNIQUE NOT NULL,
            $password TEXT NOT NULL
          );
        ''');
      },
    );
  }

  Future<int> insertUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await database;
    return await db.insert(
      tUser,
      {
        'name': name,
        'email': email,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserModal>> getUsersByEmail(String userEmail) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tUser,
      where: '$email = ?',
      whereArgs: [userEmail],
    );
    return result.map((e) => UserModal.fromMap(e)).toList();
  }

  Future<List<UserModal>> getUsers() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(tUser);
    return result.map((e) => UserModal.fromMap(e)).toList();
  }

  Future<int> deleteUser(int userId) async {
    final db = await database;
    return await db.delete(
      tUser,
      where: '$id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateUser({
    required int id,
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await database;
    return await db.update(
      tUser,
      {
        'name': name,
        'email': email,
        'password': password,
      },
      where: '$id = ?',
      whereArgs: [id],
    );
  }
}
