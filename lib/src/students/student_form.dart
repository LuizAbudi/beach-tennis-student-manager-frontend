import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/student_model.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_input.dart';
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

    final userModel = UserModel(
      email: email,
      name: name,
      userType: "student",
      password: "1234abc",
    );

    final newStudent = widget.id != null
        ? StudentModel(
            id: widget.id,
            level: level,
            user: userModel,
            teacherId: loggedUserModel?.id,
          )
        : StudentModel(
            level: level,
            user: userModel,
            teacherId: loggedUserModel?.id,
          );

    if (widget.id != null) {
      await store.updateUser(newStudent);
    } else {
      await store.createStudent(newStudent);
    }

    if (mounted && !store.isLoading.value) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _loadUser() async {
    final student = await store.getUserById(widget.id!);
    setState(() {
      emailController.text = student?.user.email ?? "";
      nameController.text = student?.user.name ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
      appBar: AppBar(
        title: const Text('Cadastro de aluno'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
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
            ),
          ],
        ),
      ),
    );
  }
}
