import 'dart:convert';

List<ClassModel> classModelsFromJson(String str) => List<ClassModel>.from(
    json.decode(str).map((x) => ClassModel.fromJson(x))
);

String classModelsToJson(List<ClassModel> data) => json.encode(
    List<dynamic>.from(data.map((x) => x.toJson()))
);
class ClassModel {
  int? id;
  int? classDay;
  String? startTime;
  String? endTime;
  int? teacherId;
  List<int>? studentIds;

  ClassModel({
    this.id,
    required this.classDay,
    required this.startTime,
    required this.endTime,
    this.teacherId,
    this.studentIds,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
        id: json["id"],
        classDay: json["classDay"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        teacherId: json["teacherId"],
        studentIds: json["studentIds"] == null
            ? null
            : List<int>.from(json["studentIds"].map((x) => x)),
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
