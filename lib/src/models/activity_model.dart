import 'dart:convert';

ActivityModel activityFromJson(String str) =>
    ActivityModel.fromJson(json.decode(str));

String activityToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  int? id;
  String title;
  String description;
  String date;

  ActivityModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json["id"],
        title: json["titulo"],
        description: json["descricao"],
        date: json["data"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "titulo": title,
      "descricao": description,
      "data": date,
    };

    if (id != null) {
      data["id"] = id;
    }

    return data;
  }
}
