import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/pages/home.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_input.dart';
import 'package:mobile/src/widgets/custom_text.dart';
import 'package:mobile/src/widgets/level_selector.dart';

import '../controllers/payment_controller.dart';
import '../stores/payment_stores.dart';

class PaymentForm extends StatefulWidget {
  final int? studentId;

  const PaymentForm({super.key, required this.studentId});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final PaymentStore paymentStore = PaymentStore(
    controller: PaymentController(
      client: HttpClient(),
    ),
  );

  late TextEditingController paymentStatusController;
  late TextEditingController paymentDateController;
  String SelectedPaymentStatus = "pending";

  UserModel? loggedUserModel;
  final loggedUser = localStorage.getItem('token');

  @override
  void initState() {
    paymentStatusController = TextEditingController();
    paymentDateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    paymentStatusController.dispose();
    paymentDateController.dispose();
    super.dispose();
  }

  // void _onSubmitStudent() async {
  //   final email = emailController.text;
  //   final name = nameController.text;
  //   final level = levelController.text;
  //
  //   if (email.isEmpty || name.isEmpty || level.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Por favor, preencha o formulário.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //
  //     return;
  //   }
  //
  //   final newStudent = widget.studentId != null
  //       ? UserModel(
  //           id: widget.studentId,
  //           email: email,
  //           level: level,
  //           name: name,
  //         )
  //       : UserModel(
  //           level: level,
  //           email: email,
  //           name: name,
  //           userType: "student",
  //           password: "1234abc",
  //           teacherId: loggedUserModel?.teacherId,
  //         );
  //
  //   if (widget.studentId != null) {
  //     await store.updateUser(newStudent);
  //   } else {
  //     await store.createStudent(newStudent);
  //     if (store.isSuccess.value && mounted) {
  //       _showSuccessModal(context);
  //     }
  //   }
  // }

  // Future<void> _loadUser() async {
  //   final student = await store.getUserById(widget.studentId!);
  //   setState(() {
  //     emailController.text = student?.user.email ?? "";
  //     nameController.text = student?.user.name ?? "";
  //   });
  // }

  void _handleCreatePayment() async {
    await paymentStore.CreatePayment(
        widget.studentId!, paymentDateController.text, SelectedPaymentStatus);
    if (mounted && paymentStore.error.value.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(paymentStore.error.value),
          backgroundColor: Colors.red,
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pagamento Criado com sucesso"),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      paymentStore.getStudentPayments(widget.studentId!);
    });
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: "1234abc"));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha copiada para o clipboard')),
    );
  }

  void _showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                text:
                    "Cadastro realizado com sucesso! A senha temporária do aluno é:",
                type: "paragraph",
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _copyToClipboard(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 98, 62, 1),
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "1234abc",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.copy,
                        color: Color.fromRGBO(255, 98, 62, 1),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const CustomText(
                text: "Por favor, copie a senha e entregue ao aluno.",
                type: "paragraph",
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Voltar ao inicio",
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([paymentStore.isLoading]),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
          appBar: AppBar(
            title: const Text('Criar pagamento'),
            backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
          ),
          body: SingleChildScrollView(
            // Torna a coluna rolável
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: SelectedPaymentStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status do Pagamento',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: "pending", child: Text('Pendente')),
                      DropdownMenuItem(value: "paid", child: Text('Pago')),
                      DropdownMenuItem(
                          value: "expired", child: Text('Vencido')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        SelectedPaymentStatus = value!;
                      });
                    },
                    hint: const Text('Selecione o dia da semana'),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: paymentDateController,
                    decoration: InputDecoration(
                      labelText: 'Data do Pagamento',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: "Criar Pagamento",
                    onPressed: () {
                      print(
                          "Criar Pagamento: ${widget.studentId} - $SelectedPaymentStatus - ${paymentDateController.text}");
                      _handleCreatePayment();
                    }, //store.isLoading.value
                    width: 300,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));

    if (_picked != null) {
      setState(() {
        paymentDateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
