import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/home.dart';
import 'package:mobile/src/login.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  void registrar() async{
    print("to aqui dentro");

    final Map<String, dynamic> user = {
      'firstName': firstnameController.text,
      'lastName': lastnameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'userType': userType,
      'level': levelController.text.toUpperCase(),
      'paymentValue': double.parse(paymentValueController.text),
      'paymentDate': double.parse(paymentDateController.text),
      'lastPaymentDate': lastPaymentDateController.text,
      'teacherId': int.parse(teacherIdController.text),
    };

    final userJson = jsonEncode(user);
      final response = await http.post(Uri.parse("https://beach-tennis-student-manager.onrender.com/api/register"), body: userJson, headers: {
        'Content-Type': 'application/json',
      });
      print(response.statusCode);
      print(response.body);
      if(response.statusCode >= 200 && response.statusCode < 300){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário registrado com sucesso.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        print(response.body);
       } else {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
            content: Text("erro ao registrar usuário"),
            backgroundColor: Colors.red,
          ),
        );
      }

  }

  List<String> userTypes = ['student', 'teacher'];
  String userType = 'student';
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController levelController;
  late TextEditingController paymentValueController;
  late TextEditingController paymentDateController;
  late TextEditingController lastPaymentDateController;
  late TextEditingController teacherIdController;

  @override
  void initState() {
    super.initState();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    levelController = TextEditingController();
    paymentValueController = TextEditingController();
    paymentDateController = TextEditingController();
    lastPaymentDateController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    teacherIdController = TextEditingController();
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    levelController.dispose();
    paymentValueController.dispose();
    paymentDateController.dispose();
    lastPaymentDateController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final firstname = firstnameController.text;
    final lastname = lastnameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final level = levelController.text;
    final paymentValue = paymentValueController.text;
    final paymentDate = paymentDateController.text;
    final lastPaymentDate = lastPaymentDateController.text;

    if (userType == "student") {
      if (firstname.isEmpty ||
          lastname.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          level.isEmpty ||
          paymentValue.isEmpty ||
          paymentDate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, preencha todos os campos.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      if (firstname.isEmpty ||
          lastname.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, preencha todos os campos.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              //height: MediaQuery.sizeOf(context).height,
              width: double.infinity,
              child: _buildInputFields(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            "Registrar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 60),
          CustomTextField(
            controller: firstnameController,
            icon: Icons.person_outline,
            hint: "Primeiro Nome",
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: lastnameController,
            icon: Icons.person_outline,
            hint: "Sobrenome",
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: emailController,
            icon: Icons.email_outlined,
            hint: "Email",
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: passwordController,
            icon: Icons.lock_outline,
            hint: "Password",
            isPassword: true,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 173,
                child: RadioListTile(
                    title: const Text(
                      'Estudante',
                      style: TextStyle(color: Colors.white38, fontSize: 16),
                    ),
                    value: userTypes[0],
                    groupValue: userType,
                    onChanged: (String? value) {
                      setState(() {
                        userType = value!;
                      });
                    }),
              ),
              Container(
                width: 173,
                child: RadioListTile(
                    title: const Text('Professor',
                        style:
                            TextStyle(color: Colors.white38, fontSize: 16)),
                    value: userTypes[1],
                    groupValue: userType,
                    onChanged: (String? value) {
                      setState(() {
                        userType = value!;
                      });
                    }),
              ),
            ],
          ),
          const SizedBox(height: 5),
          userType == 'student'
              ? CustomTextField(
                  controller: levelController,
                  icon: Icons.sports,
                  hint: "Level",
                )
              : const SizedBox(),
          userType == 'student' ? SizedBox(height: 32) : const SizedBox(),
          userType == 'student'
              ? CustomTextField(
                  isNumeric: true,
                  controller: paymentValueController,
                  icon: Icons.paid,
                  hint: "valor do pagamento",
                )
              : const SizedBox(),
          userType == 'student' ? SizedBox(height: 32) : const SizedBox(),
          userType == 'student'
              ? CustomTextField(
                  controller: paymentDateController,
                  icon: Icons.add_chart,
                  hint: "Dia do pagamento",
                )
              : const SizedBox(),
          userType == 'student' ? SizedBox(height: 32) : const SizedBox(),
          userType == 'student'
              ? CustomTextField(
                  controller: lastPaymentDateController,
                  icon: Icons.lock_outline,
                  hint: "Último dia do pagamento",
                )
              : const SizedBox(),
          userType == 'student' ? SizedBox(height: 32) : const SizedBox(),
          userType == 'student'
              ? CustomTextField(
            controller: teacherIdController,
            icon: Icons.lock_outline,
            hint: "Id do professor",
          )
              : const SizedBox(),
          userType == 'student' ? SizedBox(height: 32) : const SizedBox(),
          ElevatedButton(
            onPressed: () {
              try {
                registrar();
              } catch (e) {

              }
            },
            style: const ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size(200, 50)),
            ),
            child:
                 const Text(
                    "Registrar",
                    style: TextStyle(color: Colors.black),
                  ),
          )
        ],
      ),
    );
  }
}
