import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/login.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/users/user_details_view.dart';
import 'package:mobile/src/users/user_form.dart';

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

    store.getUsers();
  }

  Future<bool> _checkToken() async {
    final token = localStorage.getItem('token');
    return token != null;
  }

  void _logout({bool showConfirmationDialog = false, int? userId}) {
    if (showConfirmationDialog) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                const Text("Seus dados serão removidos, tem certeza disso ?"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Sim",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await store.deleteUser(userId!);
                  _performLogout();
                },
              ),
              TextButton(
                child: const Text(
                  "Não",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      _performLogout();
    }
  }

  void _performLogout() {
    localStorage.clear();
    loggedUserModel = null;
    _checkToken().then((loggedIn) {
      if (!loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  void _deleteUser(int userId) async {
    _logout(showConfirmationDialog: true, userId: userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation:
            Listenable.merge([store.isLoading, store.error, store.state]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            itemBuilder: (_, index) {
              final item = store.state.value[index];
              final isMyUser = item.id == loggedUserModel?.id;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserItemDetailsView(
                            id: item.id!,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white30,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.email,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isMyUser)
                                IconButton(
                                  onPressed: () async {
                                    bool willRefresh = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserForm(
                                          id: item.id,
                                        ),
                                      ),
                                    );

                                    if (willRefresh) {
                                      store.getUsers();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white30,
                                  ),
                                ),
                              if (isMyUser)
                                IconButton(
                                  onPressed: () {
                                    _deleteUser(item.id!);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white30,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: store.state.value.length,
            padding: const EdgeInsets.all(16),
          );
        },
      ),
    );
  }
}
