import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/classes/classes_detail_view.dart';
import 'package:mobile/src/classes/classes_form.dart';
import 'package:mobile/src/controllers/classes_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/classes_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/empty_state.dart'; // Import do CustomButton

class ClassesListView extends StatefulWidget {
  const ClassesListView({super.key});

  @override
  State<ClassesListView> createState() => _ClassesListViewState();
}

class _ClassesListViewState extends State<ClassesListView> {
  final ClassStore store = ClassStore(
    controller: ClassController(
      client: HttpClient(),
    ),
  );

  UserModel? loggedUserModel;
  final token = localStorage.getItem('token');

  @override
  void initState() {
    super.initState();

    if (token != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      loggedUserModel = UserModel(
        id: decodedToken['id'],
        name: decodedToken['name'],
        email: decodedToken['email'],
        userType: decodedToken['userType'],
        teacherId: decodedToken['teacherId'],
      );
    }

    _loadClasses();
  }

  Future<void> _loadClasses() async {
    await store.getClasses(loggedUserModel!.teacherId!);
  }

  String _dayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Domingo';
      case 2:
        return 'Segunda-feira';
      case 3:
        return 'Terça-feira';
      case 4:
        return 'Quarta-feira';
      case 5:
        return 'Quinta-feira';
      case 6:
        return 'Sexta-feira';
      case 7:
        return 'Sábado';
      default:
        return 'Dia inválido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([store.isLoading, store.error]),
            builder: (context, child) {
              if (store.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(255, 98, 62, 1),
                  ),
                );
              } else if (store.error.value.isNotEmpty) {
                return Center(
                  child: Text(
                    'Erro: ${store.error.value}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (store.state.value.isEmpty) {
                return const EmptyStateWidget(
                  message: "Nenhuma aula cadastrada...",
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: store.state.value.length,
                    itemBuilder: (context, index) {
                      final classModel = store.state.value[index];
                      final dayOfWeek = classModel.classDay ?? 0;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.sports_outlined),
                          title: Text('Dia da aula: ${_dayOfWeek(dayOfWeek)}'),
                          subtitle: Text(
                              'Horário: ${classModel.startTime} - ${classModel.endTime}'),
                          trailing: Text('Prof. ${classModel.teacher!.name}'),
                          onTap: () {
                            if (classModel.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassesDetailsView(
                                    classId: classModel.id!,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: "Cadastrar Aula",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ClassForm(), // Tela do formulário de classe
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
