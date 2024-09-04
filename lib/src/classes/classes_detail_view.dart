import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/classes_controller.dart';
import 'package:mobile/src/models/classes_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/classes_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';

class ClassesDetailsView extends StatefulWidget {
  final int classId;

  const ClassesDetailsView({super.key, required this.classId});

  @override
  State<ClassesDetailsView> createState() => _ClassesDetailsViewState();
}

class _ClassesDetailsViewState extends State<ClassesDetailsView> {
  final ClassStore store = ClassStore(
    controller: ClassController(
      client: HttpClient(),
    ),
  );

  ClassModel? classModel;

  @override
  void initState() {
    super.initState();
    _loadClassDetails();
  }

  Future<void> _loadClassDetails() async {
    await store.getClassById(widget.classId);
    setState(() {
      classModel = store.selectedClass.value;
    });
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
      appBar: AppBar(
        title: const Text("Detalhes da Aula"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: classModel == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Text(
                    "Dia da Aula: ${_dayOfWeek(classModel!.classDay ?? 0)}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Horário: ${classModel!.startTime ?? 'N/A'} - ${classModel!.endTime ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Professor: ${classModel!.teacher?.name ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    "Alunos:",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: classModel!.students?.length ?? 0,
                      itemBuilder: (context, index) {
                        final student = classModel!.students![index];
                        return ListTile(
                          title: Text(student.name ?? 'N/A'),
                          subtitle: Text('Nível: ${student.level ?? 'N/A'}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16.0),
                      CustomButton(
                        text: "Editar",
                        onPressed: () {},
                        icon: Icons.edit,
                        height: 40,
                        textSize: 14,
                        withShadow: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
