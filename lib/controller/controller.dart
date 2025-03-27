import 'dart:ui';
import 'package:authentication_app/helper/helper.dart';
import 'package:get/get.dart';
import '../modal/modal.dart';

class UserController extends GetxController {
  var users = <UserModal>[].obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final List<UserModal> userList = await DBHelper.dbHelper.getUsers();
    users.assignAll(userList);
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    List<UserModal> existingUsers =
        await DBHelper.dbHelper.getUsersByEmail(email);
    if (existingUsers.isNotEmpty) {
      Get.snackbar("Error", "Email already registered",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xffFF0000));
      return;
    }

    int newId = users.isEmpty ? 1 : (users.last.id + 1);

    await addUser(id: newId, name: name, email: email, password: password);

    Get.snackbar("Success", "Account created successfully!",
        snackPosition: SnackPosition.BOTTOM);
    Get.offNamed('/login');
  }

  Future<void> addUser({
    required int id,
    required String name,
    required String email,
    required String password,
  }) async {
    await DBHelper.dbHelper
        .insertUser(name: name, email: email, password: password);
    fetchUsers();
  }

  Future<void> deleteUser({required int id}) async {
    await DBHelper.dbHelper.deleteUser(id);
    fetchUsers();
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    List<UserModal> userList = await DBHelper.dbHelper.getUsersByEmail(email);

    if (userList.isEmpty) {
      Get.snackbar("Error", "No account found with this email",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xffFF0000));
      return;
    }

    UserModal user = userList.first;
    if (user.password != password) {
      Get.snackbar("Error", "Incorrect password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xffFF0000));
      return;
    }

    isLoggedIn.value = true;
    Get.snackbar("Success", "Login successful!",
        snackPosition: SnackPosition.BOTTOM);
    Get.offNamed('/home');
  }

  Future<void> updateUser({
    required int id,
    required String name,
    required String email,
    required String password,
  }) async {
    await DBHelper.dbHelper
        .updateUser(id: id, name: name, email: email, password: password);
    fetchUsers();
  }
}
