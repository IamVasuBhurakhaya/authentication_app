import 'package:authentication_app/modal/modal.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();

  Database? database;

  String tUser = 'user';
  String name = 'name';
  String email = 'email';
  String password = 'password';

  Future<void> initDB() async {
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/user.db';

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) {
        String query = ''' CREATE TABLE $tUser(
          user_id INTEGER PRIMARY KEY AUTOINCREMENT,
          $name TEXT NOT NULL,
          $email TEXT NOT NULL,
          $password TEXT NOT NULL
        );''';

        db
            .execute(query)
            .then(
              (value) => print("1 Table Create"),
            )
            .onError((error, _) => print(error.toString()));
      },
    );
  }

  Future<int?> insertUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (database == null) await initDB();
    String query =
        "INSERT INTO $tUser($name, $email, ${this.password}) VALUES(?, ? , ?);";
    List values = [name, email, password];
    try {
      int? result = await database?.rawInsert(query, values);
      print("Insert Success: ID $result");
      return result;
    } catch (e) {
      print("Insert failed: $e");
      return null;
    }
  }

  Future<List<UserModal>> getUser() async {
    await initDB();
    String query = "SELECT * FROM $tUser";
    List<Map<String, dynamic>> result = await database?.rawQuery(query) ?? [];
    return result
        .map((Map<String, dynamic> e) => UserModal.fromMap(map: e))
        .toList();
  }

  Future<int?> deleteUser({required int id}) async {
    if (database == null) await initDB();
    String query = "DELETE FROM $tUser WHERE user_id = $id";
    return await database?.rawDelete(query);
  }

  Future<int?> updateUser({
    required UserModal model,
  }) async {
    if (database == null) await initDB();
    String query =
        "UPDATE $tUser SET $name = ?, $email = ?, $password = ? WHERE user_id = ${model.id}";
    List values = [model.name, model.email, model.password];
    return await database?.rawUpdate(query, values);
  }
}
