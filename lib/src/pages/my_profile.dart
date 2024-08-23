import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/payment_controller.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/payment_stores.dart';
import 'package:mobile/src/stores/user_stores.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  final PaymentStore paymentStore = PaymentStore(
    controller: PaymentController(
      client: HttpClient(),
    ),
  );

  UserModel? myUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    if (myUser != null) await paymentStore.getStudentPayments(myUser!.id!);
  }

  Future<void> _loadUser() async {
    myUser = await store.getMe();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          store.isLoading,
          paymentStore.isLoading,
          store.error,
        ]),
        builder: (context, child) {
          if (store.error.value.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(store.error.value),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (store.isLoading.value || paymentStore.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(255, 98, 62, 1),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    "https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  myUser!.name ?? 'Nome não disponível',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Email: ${myUser!.email ?? 'não disponível'}",
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Histórico de pagamentos",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPaymentHistory(),
              ],
            ),
          );
        });
  }

  Widget _buildPaymentHistory() {
    return AnimatedBuilder(
      animation: paymentStore.isLoading,
      builder: (context, child) {
        if (paymentStore.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(255, 98, 62, 1),
            ),
          );
        } else if (paymentStore.state.value.isEmpty) {
          return const Column(
            children: [
              SizedBox(height: 32),
              Icon(
                Icons.inbox_outlined,
                size: 48.0,
                color: Colors.grey,
              ),
              SizedBox(height: 8.0),
              Text(
                "Ainda não tem pagamentos",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        } else {
          return Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              children: paymentStore.state.value.map((payment) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      payment.paymentStatus == "paid"
                          ? Icons.payment
                          : Icons.pending,
                      color: Colors.black54,
                    ),
                    title: Text(
                      "Data: ${payment.paymentDate}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Status: ${payment.paymentStatus == "paid" ? "Pago" : "Pendente"}",
                    ),
                    trailing: Icon(
                      payment.paymentStatus == "paid"
                          ? Icons.check_circle
                          : Icons.error,
                      color: payment.paymentStatus == "paid"
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
