import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/src/controllers/activity_controller.dart';
import 'package:mobile/src/models/activity_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/activity_stores.dart';
import 'package:mobile/src/widgets/text_field.dart';

class ActivityForm extends StatefulWidget {
  final int? id;

  const ActivityForm({super.key, this.id});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final ActivityStore store = ActivityStore(
    controller: ActivityController(
      client: HttpClient(),
    ),
  );

  late DateTime selectedDate;
  late TextEditingController dateController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    selectedDate = DateTime.now();

    if (widget.id != null) {
      _loadActivity();
    }

    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    descriptionController.dispose();
    titleController.dispose();

    super.dispose();
  }

  Future<void> _loadActivity() async {
    final activity = await store.getActivityById(widget.id!);
    setState(() {
      titleController.text = activity?.title ?? "";
      descriptionController.text = activity?.description ?? "";
      dateController.text = activity?.date ?? "";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          dateController.text =
              DateFormat('dd/MM/yyyy HH:mm').format(selectedDate);
        });
      }
    }
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
                  widget.id != null ? 'Editar atividade' : 'Criar atividade',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: titleController,
                  icon: Icons.title,
                  hint: "Título",
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: descriptionController,
                  icon: Icons.description_outlined,
                  hint: "Descrição",
                  isTextArea: true,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Data de entrega",
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text;
                    final description = descriptionController.text;
                    final date = dateController.text;

                    if (title.isEmpty || description.isEmpty || date.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha o formulário.'),
                          backgroundColor: Colors.red,
                        ),
                      );

                      return;
                    }

                    final newActivity = widget.id != null
                        ? ActivityModel(
                            id: widget.id,
                            title: title,
                            description: description,
                            date: date,
                          )
                        : ActivityModel(
                            title: title,
                            description: description,
                            date: date,
                          );

                    if (widget.id != null) {
                      await store.updateActivity(newActivity);
                    } else {
                      await store.createActivity(newActivity);
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
