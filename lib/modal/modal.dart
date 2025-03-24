class UserModal {
  int id;
  String name;
  String email;
  String password;

  UserModal({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModal.fromMap({required Map<String, dynamic> map}) {
    return UserModal(
      id: map['id '],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}
