import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? firstName;
  String? lastName;
  String email;
  String? password;
  String? Usertype;
  String? level;
  double? paymentValue;
  int? paymentDate;
  DateTime? lastPaymentDate;
  int? teacherId;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.password,
    this.Usertype,
    this.level,
    this.paymentValue,
    this.paymentDate,
    this.lastPaymentDate,
    this.teacherId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "email": email,
      "senha": password,
    };

    if (lastName != null) {
      data["firstName"] = firstName;
    }

    if (lastName != null) {
      data["lastName"] = lastName;
    }

    if (lastName != null) {
      data["lastName"] = lastName;
    }

    if (id != null) {
      data["id"] = id;
    }

    return data;
  }
}
