import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/pages/home.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_input.dart';
import 'package:mobile/src/widgets/custom_text.dart';
import 'package:mobile/src/widgets/level_selector.dart';

class UserForm extends StatefulWidget {
  final int? id;

  const UserForm({super.key, this.id});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController levelController;

  UserModel? loggedUserModel;
  final loggedUser = localStorage.getItem('token');

  @override
  void initState() {
    emailController = TextEditingController();
    nameController = TextEditingController();
    levelController = TextEditingController();

    if (widget.id != null) {
      _loadUser();
    }

    if (loggedUser != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(loggedUser!);

      loggedUserModel = UserModel(
        id: decodedToken['id'],
        name: decodedToken['name'],
        email: decodedToken['email'],
        teacherId: decodedToken['teacherId'],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    levelController.dispose();

    super.dispose();
  }

  void _onSubmitStudent() async {
    final email = emailController.text;
    final name = nameController.text;
    final level = levelController.text;

    if (email.isEmpty || name.isEmpty || level.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o formulário.'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final newStudent = widget.id != null
        ? UserModel(
            id: widget.id,
            email: email,
            level: level,
            name: name,
          )
        : UserModel(
            level: level,
            email: email,
            name: name,
            userType: "student",
            password: "1234abc",
            teacherId: loggedUserModel?.teacherId,
          );

    if (widget.id != null) {
      await store.updateUser(newStudent);
    } else {
      await store.createStudent(newStudent);
      if (store.isSuccess.value) {
        _showSuccessModal(context);
      }
    }
  }

  Future<void> _loadUser() async {
    final student = await store.getUserById(widget.id!);
    setState(() {
      emailController.text = student?.user.email ?? "";
      nameController.text = student?.user.name ?? "";
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
      animation:
          Listenable.merge([store.isLoading, store.isSuccess, store.error]),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
          appBar: AppBar(
            title: const Text('Cadastro de aluno'),
            backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
          ),
          body: SingleChildScrollView(
            // Torna a coluna rolável
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomInput(
                    placeholder: "Informe o nome",
                    controller: nameController,
                    prefixIcon: Icons.person_outline,
                    label: "Nome completo",
                  ),
                  CustomInput(
                    placeholder: "Informe o email",
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    label: "E-mail",
                  ),
                  const SizedBox(height: 8),
                  LevelSelector(
                    levels: const ['PRO', 'A', 'B', 'C', 'D'],
                    onSelectedLevelChanged: (selectedLevel) {
                      levelController.text = selectedLevel;
                    },
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: "Cadastrar",
                    onPressed: _onSubmitStudent,
                    isLoading: store.isLoading.value,
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
}
