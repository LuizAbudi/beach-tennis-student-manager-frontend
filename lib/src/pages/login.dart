import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/pages/home.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/pages/register/user_type.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_input.dart';
import 'package:mobile/src/widgets/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.error.value),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 251),
        title: const CustomText(
          text: "Bem-vindo ao CoachApp",
          type: "header",
          color: Color.fromRGBO(22, 24, 35, 0.9),
        ),
        centerTitle: true,
      ),
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
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 248, 248, 251)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const Image(
                  image: AssetImage('assets/images/coachapp_logo.png'),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 60),
            CustomInput(
              label: "Email",
              placeholder: "Digite seu email",
              controller: emailController,
            ),
            CustomInput(
              label: "Senha",
              placeholder: "Digite sua senha",
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 40),
            ValueListenableBuilder<bool>(
              valueListenable: store.isLoading,
              builder: (context, isLoading, child) {
                return CustomButton(
                  text: "Entrar",
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  onPressed: _handleLogin,
                  isLoading: isLoading,
                );
              },
            ),
            const SizedBox(height: 30),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterUserTypePage(),
                  ),
                );
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CustomText(
                  text: "Registrar",
                  type: "paragraph",
                  color: Color.fromRGBO(22, 24, 35, 0.9),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
