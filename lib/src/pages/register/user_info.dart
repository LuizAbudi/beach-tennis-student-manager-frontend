import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/helpers/handle_erros.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/pages/register/success.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_input.dart';
import 'package:mobile/src/widgets/custom_text.dart';

class RegisterUserInfoPage extends StatefulWidget {
  const RegisterUserInfoPage({super.key});

  @override
  State<RegisterUserInfoPage> createState() => _RegisterUserInfoPageState();
}

class _RegisterUserInfoPageState extends State<RegisterUserInfoPage> {
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

  void _handleSubmit() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = passwordConfirmationController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      const HandleErros(errorMessage: "Por favor, preencha o formulário.")
          .showError(context);
      return;
    }

    if (password != confirmPassword) {
      const HandleErros(errorMessage: "As senhas não coincidem.")
          .showError(context);
      return;
    }

    final newUser = UserModel(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      userType: "teacher",
    );

    await store.createUser(newUser);

    if (mounted && store.error.value.isNotEmpty) {
      HandleErros(errorMessage: store.error.value).showError(context);
      return;
    }

    if (mounted && !store.isLoading.value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterSuccessPage(
            email: email,
            password: password,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 251),
        title: const CustomText(
          text: "Informações",
          size: 20,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(22, 24, 35, 0.9),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          color: const Color.fromRGBO(22, 24, 35, 0.9),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: "Bem-vindo!",
                type: "header",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: "Preencha os campos abaixo para criar sua conta.",
                type: "paragraph",
                color: Color.fromRGBO(22, 24, 35, 0.8),
              ),
            ),
            const SizedBox(height: 32),
            CustomInput(
              controller: nameController,
              label: "Nome",
              placeholder: "Digite seu nome completo",
              prefixIcon: Icons.person_outline,
            ),
            CustomInput(
              controller: emailController,
              prefixIcon: Icons.email_outlined,
              label: "Email",
              placeholder: "Digite seu email",
            ),
            CustomInput(
              controller: passwordController,
              label: "Senha",
              placeholder: "Digite sua senha",
              isPassword: true,
            ),
            CustomInput(
              controller: passwordConfirmationController,
              label: "Confirme a senha",
              placeholder: "Confirme sua senha",
              isPassword: true,
            ),
            const SizedBox(height: 40),
            ValueListenableBuilder<bool>(
              valueListenable: store.isLoading,
              builder: (context, isLoading, child) {
                return CustomButton(
                  text: "Cadastrar",
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  onPressed: _handleSubmit,
                  isLoading: isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
