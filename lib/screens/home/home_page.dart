import 'package:authentication_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../../modal/modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController controller = Get.put(UserController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Home Page",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.offNamed(AppRoutes.login);
            },
            icon: const Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(child: Text("No users found!"));
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            UserModal user = controller.users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                leading: CircleAvatar(child: Text(user.name[0])),
                title: Text("ID: ${user.id} - ${user.name}"),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deleteUser(id: user.id);
                  },
                ),
                onLongPress: () {
                  // Open Update Dialog
                  showUpdateDialog(user);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add User"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      inputTextField(idController, "User ID", "Enter ID",
                          isNumber: true),
                      inputTextField(
                          nameController, "Username", "Enter username"),
                      inputTextField(emailController, "Email", "Enter email"),
                      inputTextField(
                          passwordController, "Password", "Enter password",
                          isPassword: true),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            int? userId = int.tryParse(idController.text);
                            if (userId == null) {
                              Get.snackbar('Error', 'Invalid ID!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red);
                              return;
                            }

                            controller.addUser(
                              id: userId,
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            idController.clear();
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();

                            Navigator.pop(context);
                          } else {
                            Get.snackbar('Error', 'Please fill all fields',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                          }
                        },
                        child: const Text("Done"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.person, size: 30),
      ),
    );
  }

  void showUpdateDialog(UserModal user) {
    nameController.text = user.name;
    emailController.text = user.email;
    passwordController.text = user.password;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update User"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                inputTextField(nameController, "Username", "Enter username"),
                inputTextField(emailController, "Email", "Enter email"),
                inputTextField(passwordController, "Password", "Enter password",
                    isPassword: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.updateUser(
                        id: user.id,
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Navigator.pop(context);
                    } else {
                      Get.snackbar('Error', 'Please fill all fields',
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: Colors.white,
                          backgroundColor: Colors.red);
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTextField(
      TextEditingController controller, String label, String hint,
      {bool isPassword = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}
