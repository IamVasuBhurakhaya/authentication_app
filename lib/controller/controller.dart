import 'package:authentication_app/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/helper.dart';

class UserController extends GetxController {
  Future<List<UserModal>>? userList;

  int? userIndex;

  UserController() {
    getUser();
  }

  void updateUserIndex({required int index}) {
    userIndex = index;
    update();
  }

  void resetUserIndex() {
    userIndex = null;
    update();
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String password,
  }) async {
    int? res = await DBHelper.dbHelper
        .insertUser(name: name, email: email, password: password);
    if (res != null) {
      Get.snackbar('User Added', ' $name added successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'Insertion failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }

  void getUser() async {
    userList = DBHelper.dbHelper.getUser();
    update();
  }

  Future<void> updateUser({required UserModal model}) async {
    int? res = await DBHelper.dbHelper.updateUser(model: model);
    if (res != null) {
      getUser();
      Get.snackbar('User Updated', 'User updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'Update failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }

  Future<void> deleteUser({required int id}) async {
    int? res = await DBHelper.dbHelper.deleteUser(id: id);
    if (res != null) {
      getUser();
      Get.snackbar('User Deleted', 'user deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'Deletion failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }
}
