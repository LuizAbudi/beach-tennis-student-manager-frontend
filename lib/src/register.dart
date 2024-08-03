import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/login.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController passwordConfirmationController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    passwordConfirmationController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    passwordConfirmationController.dispose();

    super.dispose();
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
              "Cadastrar-se",
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 60),
            CustomTextField(
              controller: nameController,
              icon: Icons.person_outline,
              hint: "Nome",
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
              icon: Icons.info_outline,
              hint: "Senha",
              isPassword: true,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: passwordConfirmationController,
              icon: Icons.info_outline,
              hint: "Confirmação de senha",
              isPassword: true,
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text;
                final email = emailController.text;
                final password = passwordController.text;
                final confirmPassword = passwordConfirmationController.text;

                if (name.isEmpty ||
                    email.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha o formulário.'),
                      backgroundColor: Colors.red,
                    ),
                  );

                  return;
                }

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('As senhas não coincidem.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final newUser = UserModel(
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                );

                await store.createUser(newUser);

                if (!store.isLoading.value) {
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              },
              style: const ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(200, 50)),
              ),
              child: store.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white60),
                    ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text("Já é cadastrado? Fazer login.",
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Colors.white54,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
