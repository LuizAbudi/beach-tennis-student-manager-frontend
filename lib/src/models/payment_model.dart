import 'dart:convert';

PaymentModel userFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String userToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  int? id;
  String? paymentStatus;
  String? paymentDate;

  PaymentModel({
    this.id,
    this.paymentStatus,
    this.paymentDate,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        paymentStatus: json["paymentStatus"],
        paymentDate: json["paymentDate"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "paymentStatus": paymentStatus,
      "paymentDate": paymentDate,
    };

    if (id != null) {
      data["id"] = id;
    }

    return data;
  }
}
