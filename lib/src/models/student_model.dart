import 'dart:convert';

import 'package:mobile/src/models/user_model.dart';

StudentModel studentFromJson(String str) =>
    StudentModel.fromJson(json.decode(str));

String studentToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  int? id;
  String? level;
  int? paymentDay;
  UserModel user;
  int? teacherId;

  StudentModel({
    this.id,
    this.level,
    this.paymentDay,
    required this.user,
    this.teacherId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json["id"],
        level: json["level"],
        paymentDay: json["paymentDay"],
        user: UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "id": id,
      "level": level,
      "paymentDay": paymentDay,
      "teacherId": teacherId,
    };

    data["user"] = user.toJson();

    return data;
  }
}
