import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? name;
  String email;
  String? password;

  UserModel({
    this.id,
    this.name,
    required this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["nome"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "email": email,
      "senha": password,
    };

    if (name != null) {
      data["nome"] = name;
    }

    if (id != null) {
      data["id"] = id;
    }

    return data;
  }
}
