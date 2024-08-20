import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/students/student_form.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/student_card.dart';

class UserItemListView extends StatefulWidget {
  const UserItemListView({
    super.key,
  });

  @override
  State<UserItemListView> createState() => _UserItemListViewState();
}

class _UserItemListViewState extends State<UserItemListView> {
  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  var isLoaded = false;
  UserModel? loggedUserModel;
  final loggedUser = localStorage.getItem('token');

  @override
  void initState() {
    super.initState();

    if (loggedUser != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(loggedUser!);

      loggedUserModel = UserModel(
        id: decodedToken['id'],
        name: decodedToken['name'],
        email: decodedToken['email'],
      );
    }

    store.getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation:
                Listenable.merge([store.isLoading, store.error, store.state]),
            builder: (context, child) {
              if (store.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                itemBuilder: (_, index) {
                  final student = store.state.value[index];

                  return GestureDetector(
                    onTap: () {},
                    child: StudentCard(
                      name: student.user.name!,
                      plan: student.level!,
                      imageUrl:
                          "https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg",
                      paymentStatus: "pago",
                      level: "Intermediário",
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: store.state.value.length,
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 80,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: "Cadastrar aluno",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserForm(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
