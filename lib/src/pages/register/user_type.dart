import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/pages/register/user_info.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_text.dart';

class RegisterUserTypePage extends StatefulWidget {
  const RegisterUserTypePage({super.key});

  @override
  State<RegisterUserTypePage> createState() => _RegisterUserTypePageState();
}

class _RegisterUserTypePageState extends State<RegisterUserTypePage> {
  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  String? _selectedUserType;

  void _handleSubmit() {
    if (_selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione o tipo de usuário.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterUserInfoPage(
          userType: _selectedUserType!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 251),
        title: const CustomText(
          text: "Tipo de usuário",
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
                text: "Registre-se no CoachApp",
                type: "header",
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text:
                    "Escolha se você é um instrutor ou um aluno para começar. Instrutores podem criar e gerenciar aulas, enquanto alunos podem se inscrever nos planos dos instrutores. Aproveite ao máximo ",
                type: "paragraph",
                color: Color.fromRGBO(22, 24, 35, 0.8),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const CustomText(
                      text: "Instrutor",
                      type: "paragraph",
                    ),
                    subtitle: const CustomText(
                      text: "Crie e gerencie suas aulas",
                      fontWeight: FontWeight.normal,
                      size: 14,
                      color: Color.fromRGBO(22, 24, 35, 0.6),
                    ),
                    value: 'teacher',
                    groupValue: _selectedUserType,
                    activeColor: const Color.fromRGBO(255, 98, 62, 1),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserType = value;
                      });
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color.fromRGBO(237, 237, 240, 1),
                  ),
                  RadioListTile<String>(
                    title: const CustomText(
                      text: "Aluno",
                      type: "paragraph",
                    ),
                    subtitle: const CustomText(
                      text: "Inscreva-se nos planos dos instrutores",
                      fontWeight: FontWeight.normal,
                      size: 14,
                      color: Color.fromRGBO(22, 24, 35, 0.6),
                    ),
                    value: 'student',
                    groupValue: _selectedUserType,
                    activeColor: const Color.fromRGBO(255, 98, 62, 1),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserType = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              onPressed: _handleSubmit,
              text: "Continuar",
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
