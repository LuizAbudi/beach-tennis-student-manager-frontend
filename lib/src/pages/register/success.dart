import 'package:flutter/material.dart';
import 'package:mobile/src/pages/home.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_text.dart';
import 'package:mobile/src/widgets/pulse_icon.dart';

class RegisterSuccessPage extends StatefulWidget {
  const RegisterSuccessPage({super.key});

  @override
  State<RegisterSuccessPage> createState() => RegisterSuccessPageState();
}

class RegisterSuccessPageState extends State<RegisterSuccessPage> {
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              text: "Começar",
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
