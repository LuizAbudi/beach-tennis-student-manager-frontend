import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/text_field.dart';

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
      appBar: AppBar(
        title: const Text('Voltar'),
      ),
      body: Center(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.id != null ? 'Editar usuário' : 'Criar usuário',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: emailController,
                  icon: Icons.email_outlined,
                  hint: "E-mail",
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: nameController,
                  icon: Icons.person_outline,
                  hint: "Nome",
                  isTextArea: true,
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
                    fixedSize: MaterialStatePropertyAll(Size(200, 50)),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.deepOrange),
                  ),
                  child: Text(
                    widget.id != null ? 'Editar' : 'Criar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
