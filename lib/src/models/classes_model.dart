import 'dart:convert';

import 'package:mobile/src/models/user_model.dart';

List<ClassModel> classModelsFromJson(String str) =>
    List<ClassModel>.from(json.decode(str).map((x) => ClassModel.fromJson(x)));

String classModelsToJson(List<ClassModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassModel {
  int? id;
  int? classDay;
  String? startTime;
  String? endTime;
  int? teacherId;
  List<int>? studentIds;
  UserModel? teacher;
  List<UserModel>? students;

  ClassModel({
    this.id,
    required this.classDay,
    required this.startTime,
    required this.endTime,
    this.teacherId,
    this.studentIds,
    this.teacher,
    this.students,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
        id: json["id"],
        classDay: json["classDay"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        teacherId: json["teacherId"],
        teacher: json["teacher"] != null
            ? UserModel.fromJson(json['teacher']['user'])
            : null,
        studentIds: json["studentIds"] == null
            ? null
            : List<int>.from(json["studentIds"].map((x) => x)),
        students: json["students"] == null
            ? null
            : List<UserModel>.from(
                json["students"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "classDay": classDay,
      "startTime": startTime,
      "endTime": endTime,
      "teacherId": teacherId,
      "studentIds": studentIds == null
          ? []
          : List<dynamic>.from(studentIds!.map((x) => x)),
    };

    return data;
  }
}
