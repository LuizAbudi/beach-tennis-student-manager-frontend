import 'package:flutter/material.dart';
import 'package:mobile/src/classes/classes_detail_view.dart';
import 'package:mobile/src/classes/classes_form.dart';
import 'package:mobile/src/controllers/classes_controller.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/classes_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart'; // Import do CustomButton

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

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    await store.getClasses();
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
                return const Center(
                  child: Text('Nenhuma aula disponível.'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: store.state.value.length,
                    itemBuilder: (context, index) {
                      final classModel = store.state.value[index];
                      final dayOfWeek = classModel.classDay ?? 0; // Usa 0 como valor padrão
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
                          title: Text('Dia da aula: ${_dayOfWeek(dayOfWeek)}'),
                          subtitle: Text(
                              'Horário: ${classModel.startTime} - ${classModel.endTime}'),
                          trailing:
                              Text('Professor ID: ${classModel.teacherId}'),
                          onTap: () {
                            if (classModel.id != null) {  // Verifica se o ID não é null
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassesDetailsView(
                                    classId: classModel.id!,
                                  ),
                                ),
                              );
                            } else {
                              // Trate o caso onde classModel.id é null, se necessário.
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
                      builder: (context) => const ClassForm(), // Tela do formulário de classe
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
