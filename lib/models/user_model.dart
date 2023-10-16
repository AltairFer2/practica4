class UserModel {
  late int id; // El campo id se asignará automáticamente por la base de datos
  String username;
  String password;

  UserModel({required this.username, required this.password});

  // Método para convertir un mapa a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      password: map['password'],
    );
  }

  // Método para convertir UserModel a un mapa
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}
