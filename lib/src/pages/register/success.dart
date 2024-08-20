import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/pages/home.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_text.dart';
import 'package:mobile/src/widgets/pulse_icon.dart';

class RegisterSuccessPage extends StatefulWidget {
  final String email;
  final String password;

  const RegisterSuccessPage(
      {super.key, required this.email, required this.password});

  @override
  State<RegisterSuccessPage> createState() => RegisterSuccessPageState();
}

class RegisterSuccessPageState extends State<RegisterSuccessPage> {
  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  void _handleStart() async {
    final login = UserModel(email: widget.email, password: widget.password);

    await store.login(login);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
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
              child: _buildView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildView() {
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 248, 248, 251)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PulseIcon(
              icon: Icons.check_circle,
            ),
            const SizedBox(height: 40),
            const CustomText(
              text: "Cadastro bem-sucedido!",
              type: "header",
            ),
            const SizedBox(height: 10),
            const CustomText(
              text:
                  "Parabéns! Seu registro no CoachApp foi concluído com sucesso. Agora você pode acessar todos os recursos e começar sua jornada!",
              type: "paragraph",
              textAlign: TextAlign.center,
              color: Color.fromRGBO(22, 24, 35, 0.8),
            ),
            const SizedBox(height: 40),
            CustomButton(
              onPressed: _handleStart,
              text: "Começar",
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
