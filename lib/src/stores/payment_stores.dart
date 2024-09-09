import 'package:flutter/foundation.dart';
import 'package:mobile/src/controllers/payment_controller.dart';
import 'package:mobile/src/models/payment_model.dart';

class PaymentStore {
  final PaymentController controller;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<PaymentModel>> state =
      ValueNotifier<List<PaymentModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>("");

  PaymentStore({required this.controller});

  Future<void> CreatePayment(int id, String date, String status) async {
    isLoading.value = true;
    error.value = "";
    try {
      final result = await controller.createPayment(id, date, status);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<void> getStudentPayments(int id) async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await controller.getStudentPayments(id);
      state.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }

    isLoading.value = false;
  }
}
