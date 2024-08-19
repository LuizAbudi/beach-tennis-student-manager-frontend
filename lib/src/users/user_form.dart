import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_input.dart';

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

  @override
  void initState() {
    emailController = TextEditingController();
    nameController = TextEditingController();

    if (widget.id != null) {
      _loadUser();
    }

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();

    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await store.getUserById(widget.id!);
    setState(() {
      emailController.text = user?.email ?? "";
      nameController.text = user?.name ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
      appBar: AppBar(
        title: const Text('Cadastro de aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            CustomInput(
              placeholder: "Informe o email",
              controller: emailController,
              prefixIcon: Icons.email_outlined,
              label: "E-mail",
            ),
            const SizedBox(height: 32),
            CustomInput(
              placeholder: "Informe o nome",
              controller: nameController,
              prefixIcon: Icons.person_outline,
              label: "Nome",
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final name = nameController.text;

                if (email.isEmpty || name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha o formulário.'),
                      backgroundColor: Colors.red,
                    ),
                  );

                  return;
                }

                final newUser = widget.id != null
                    ? UserModel(
                        id: widget.id,
                        name: name,
                        email: email,
                      )
                    : UserModel(
                        name: name,
                        email: email,
                      );

                if (widget.id != null) {
                  await store.updateUser(newUser);
                } else {
                  await store.createUser(newUser);
                }

                if (!store.isLoading.value) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, true);
                }
              },
              style: const ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(200, 50)),
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Color.fromRGBO(255, 98, 62, 1),
                ),
              ),
              child: Text(
                widget.id != null ? 'Editar' : 'Cadastrar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
