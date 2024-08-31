import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/controllers/classes_controller.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/classes_model.dart';
import 'package:mobile/src/pages/home.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/classes_stores.dart';
import 'package:mobile/src/stores/user_stores.dart';
import 'package:mobile/src/widgets/custom_button.dart';
import 'package:mobile/src/widgets/custom_input.dart';

class ClassForm extends StatefulWidget {
  const ClassForm({super.key});

  @override
  State<ClassForm> createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  final ClassStore store = ClassStore(
    controller: ClassController(
      client: HttpClient(),
    ),
  );

  final UserStore userStore = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );
  
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  int? teacherId; // Variável para armazenar o ID do usuário logado
  int? selectedDay; // Variável para armazenar o dia selecionado

  List<int> selectedStudentIds = []; // Lista para armazenar IDs dos alunos selecionados

  @override
  void initState() {
    super.initState();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();

    _getLoggedUserId(); // Obtém o ID do usuário logado
    userStore.getStudents(); // Carrega os alunos disponíveis
  }

  Future<void> _getLoggedUserId() async {
    final token = localStorage.getItem('token');
    if (token != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        teacherId = decodedToken['id'];
      });
    }
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  void _onSubmitClass() async {
    setState(() {
      store.isLoading.value = true;
    });

    final startTime = startTimeController.text;
    final endTime = endTimeController.text;

    if (selectedDay == null || startTime.isEmpty || endTime.isEmpty || teacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o formulário.'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        store.isLoading.value = false;
      });

      return;
    }

    final newClassModel = ClassModel(
      classDay: selectedDay!,
      startTime: startTime,
      endTime: endTime,
      teacherId: teacherId!,
      studentIds: selectedStudentIds, // Inclui os IDs dos alunos selecionados
    );

    await store.createClass(newClassModel);

    setState(() {
      store.isLoading.value = false;
    });

    if (store.isSuccess.value) {
      _showSuccessModal(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao cadastrar a aula.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Cadastro de aula realizado com sucesso!",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Voltar",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(initialIndex: 1), // Definir a aba de "Aulas"
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([store.isLoading, store.isSuccess, store.error, userStore.isLoading]),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cadastro de Aula'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: selectedDay,
                  decoration: InputDecoration(
                    labelText: 'Dia da Aula',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Domingo')),
                    DropdownMenuItem(value: 2, child: Text('Segunda-feira')),
                    DropdownMenuItem(value: 3, child: Text('Terça-feira')),
                    DropdownMenuItem(value: 4, child: Text('Quarta-feira')),
                    DropdownMenuItem(value: 5, child: Text('Quinta-feira')),
                    DropdownMenuItem(value: 6, child: Text('Sexta-feira')),
                    DropdownMenuItem(value: 7, child: Text('Sábado')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value;
                    });
                  },
                  hint: const Text('Selecione o dia da semana'),
                ),
                const SizedBox(height: 16),
                CustomInput(
                  placeholder: "Informe o horário de início",
                  controller: startTimeController,
                  prefixIcon: Icons.access_time,
                  label: "Horário de Início",
                ),
                CustomInput(
                  placeholder: "Informe o horário de término",
                  controller: endTimeController,
                  prefixIcon: Icons.access_time_filled,
                  label: "Horário de Término",
                ),
                const SizedBox(height: 16),
                Text(
                  "Selecione os Alunos",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: userStore.isLoading.value
                      ? CircularProgressIndicator()
                      : ListView(
                          children: userStore.state.value.map((student) {
                            return CheckboxListTile(
                              title: Text(student.user.name ?? 'Nome não disponível'), // Valor padrão se o nome for nulo
                              value: selectedStudentIds.contains(student.id ?? -1), // Valor padrão se o ID for nulo
                              onChanged: (bool? value) {
                                setState(() {
                                  final studentId = student.id ?? -1; // Valor padrão se o ID for nulo
                                  if (value == true) {
                                    selectedStudentIds.add(studentId);
                                  } else {
                                    selectedStudentIds.remove(studentId);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: "Cadastrar",
                  onPressed: _onSubmitClass,
                  isLoading: store.isLoading.value,
                  width: 300,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}