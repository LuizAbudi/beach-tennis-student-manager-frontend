import 'dart:convert';

import 'package:mobile/src/models/payment_model.dart';
import 'package:mobile/src/services/http_client.dart';

abstract class IPaymentController {
  Future<List<PaymentModel>> getStudentPayments(int id);
  Future<void> createPayment(int studentId);
}

class PaymentController implements IPaymentController {
  final IHttpClient client;
  late final String baseUrl;

  PaymentController({required this.client}) {
    baseUrl = "/api/payments";
  }
  
  @override
  Future<void> createPayment(int studentId) async{
    final response = await client.post(url: "/api/payments/$studentId/create-payment", body: null);

    if (response.statusCode == 201){

    }
  }

  @override
  Future<List<PaymentModel>> getStudentPayments(int id) async {
    final response = await client.get(url: "$baseUrl/$id/payment");

    if (response.statusCode == 200) {
      final List<PaymentModel> payments = [];
      final body = jsonDecode(response.body);

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
