import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? name;
  String email;
  String? password;
  String? userType;
  String? level;

  UserModel({
    this.id,
    this.name,
    required this.email,
    this.password,
    this.userType,
    this.level,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["firstName"] + " " + json["lastName"],
        email: json["email"],
        password: json["password"],
        userType: json["userType"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "email": email,
      "password": password,
    };

    if (name?.isNotEmpty ?? false) {
      List<String> nameParts = name!.split(' ');
      data["firstName"] = nameParts.first;
      data["lastName"] = nameParts.length > 1 ? nameParts.last : '';
    }

    if (level != null) {
      data["level"] = level;
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
