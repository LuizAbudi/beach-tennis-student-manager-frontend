import 'package:flutter/material.dart';
import 'package:mobile/src/stores/user_stores.dart';

class StudentSelectionDialog extends StatefulWidget {
  final UserStore userStore;

  const StudentSelectionDialog({
    Key? key,
    required this.userStore,
  }) : super(key: key);

  @override
  _StudentSelectionDialogState createState() => _StudentSelectionDialogState();
}

class _StudentSelectionDialogState extends State<StudentSelectionDialog> {
  List<int> selectedStudentIds = [];

  @override
  void initState() {
    super.initState();
    widget.userStore.getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecionar Estudantes'),
      content: AnimatedBuilder(
        animation: Listenable.merge([widget.userStore.isLoading, widget.userStore.error, widget.userStore.state]),
        builder: (context, child) {
          if (widget.userStore.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (widget.userStore.error.value.isNotEmpty) {
            return Center(child: Text('Erro: ${widget.userStore.error.value}'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: widget.userStore.state.value.length,
              itemBuilder: (context, index) {
                final student = widget.userStore.state.value[index];
                final studentId = student.id; // Pegue o ID do estudante
                return CheckboxListTile(
                  title: Text(student.user.name!),
                  value: selectedStudentIds.contains(studentId),
                  onChanged: (isChecked) {
                    setState(() {
                      if (isChecked == true && studentId != null) {
                        selectedStudentIds.add(studentId!); // Adicione apenas se não for nulo
                      } else if (isChecked == false && studentId != null) {
                        selectedStudentIds.remove(studentId!); // Remova apenas se não for nulo
                      }
                    });
                  },
                );
              },
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedStudentIds);
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
