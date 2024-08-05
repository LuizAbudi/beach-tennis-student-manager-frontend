import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/home.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/register.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  Future<void> Login() async {
    final Map<String, dynamic> user = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final userJson = jsonEncode(user);
    final response = await http.post(Uri.parse("https://beach-tennis-student-manager.onrender.com/api/login"), body: userJson, headers: {
      'Content-Type': 'application/json',
    });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = jsonDecode(response.body);
      final accessToken = responseData['access_token'];
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('access_token', accessToken);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário logado com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao logar usuário"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _handleLogin() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um e-mail e uma senha.'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final login = UserModel(email: email, password: password);

    await store.login(login);

    if (store.error.value.isEmpty) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(store.error.value),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: double.infinity,
              child: _buildInputFields(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.black54],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              "Entrar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 60),
            CustomTextField(
              controller: emailController,
              icon: Icons.person_outline,
              hint: "Email",
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: passwordController,
              icon: Icons.lock_outline,
              hint: "Password",
              isPassword: true,
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                print("to no botão");
                Login();
              },
              child: const Text(
                      "Entrar",
                      style: TextStyle(color: Colors.black),
                    ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: const Text(
                "Não é cadastrado? Cadastre-se agora.",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
