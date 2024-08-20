import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? userType;
  bool? status;

  UserModel({
    this.id,
    this.name,
    required this.email,
    this.password,
    this.userType,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        userType: json["userType"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "email": email,
      "password": password,
    };

    if (name != null) {
      data["name"] = name;
    }

    if (userType != null) {
      data["userType"] = userType;
    }

    if (id != null) {
      data["id"] = id;
    }

    return data;
  }
}
