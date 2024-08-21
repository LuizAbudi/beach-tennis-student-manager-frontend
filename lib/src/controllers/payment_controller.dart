import 'dart:convert';

import 'package:mobile/src/models/payment_model.dart';
import 'package:mobile/src/services/http_client.dart';

abstract class IPaymentController {
  Future<List<PaymentModel>> getStudentPayments(int id);
}

class PaymentController implements IPaymentController {
  final IHttpClient client;
  late final String baseUrl;

  PaymentController({required this.client}) {
    baseUrl = "/api/payments";
  }

  @override
  Future<List<PaymentModel>> getStudentPayments(int id) async {
    final response = await client.get(url: "$baseUrl/$id/payment");

    if (response.statusCode == 200) {
      final List<PaymentModel> payments = [];

      final responseMock = jsonEncode([
        {"id": 1, "paymentStatus": "paid", "paymentDate": "2024-08-20"},
        {"id": 2, "paymentStatus": "paid", "paymentDate": "2024-07-20"},
        {"id": 3, "paymentStatus": "pendent", "paymentDate": "2024-07-20"},
        {"id": 4, "paymentStatus": "pendent", "paymentDate": "2024-07-20"},
        {"id": 5, "paymentStatus": "paid", "paymentDate": "2024-07-20"},
        {"id": 6, "paymentStatus": "paid", "paymentDate": "2024-07-20"},
      ]);

      final body = jsonDecode(responseMock);

      body.map((item) {
        final PaymentModel payment = PaymentModel.fromJson(item);
        payments.add(payment);
      }).toList();

      return payments;
    } else {
      return [];
    }
  }
}
