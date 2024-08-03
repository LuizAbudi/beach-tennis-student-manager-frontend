import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/activities/activity_form.dart';
import 'package:mobile/src/controllers/activity_controller.dart';
import 'package:mobile/src/models/activity_model.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/activity_stores.dart';

class ActivityItemDetailsView extends StatefulWidget {
  final int id;
  final bool isFromMyActivity;

  const ActivityItemDetailsView(
      {super.key, required this.id, this.isFromMyActivity = false});

  @override
  State<ActivityItemDetailsView> createState() =>
      _ActivityItemDetailsViewState();
}

class _ActivityItemDetailsViewState extends State<ActivityItemDetailsView> {
  final ActivityStore store = ActivityStore(
    controller: ActivityController(
      client: HttpClient(),
    ),
  );

  ActivityModel? item;

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

    _loadActivity();
  }

  Future<void> _loadActivity() async {
    final activity = await store.getActivityById(widget.id);
    setState(() {
      item = activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe da atividade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              _buildDetailItem(
                icon: Icons.title,
                text: item?.title ?? 'Título não disponível',
                fontSize: 24,
                color: Colors.deepOrange.shade400,
              ),
              const SizedBox(height: 16),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              _buildDetailItem(
                icon: Icons.description,
                text: item?.description ?? 'Descrição não disponível',
                fontSize: 20,
                color: Colors.deepOrange.shade400,
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              _buildDetailItem(
                icon: Icons.date_range,
                text: item?.date ?? 'Data não disponível',
                fontSize: 20,
                color: Colors.deepOrange.shade400,
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    if (!widget.isFromMyActivity)
                      ElevatedButton(
                        onPressed: () async {
                          if (loggedUserModel?.id != null) {
                            await store.linkActivity(
                                widget.id, loggedUserModel!.id!);
                          }

                          if (store.error.value.isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(store.error.value),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true);
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: const MaterialStatePropertyAll(
                            Size(double.infinity, 50),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.green.withOpacity(0.8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.assignment_ind_outlined,
                              color: Colors.white54,
                            ),
                            Text(
                              "Vincular para mim",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!widget.isFromMyActivity)
                          ElevatedButton(
                            onPressed: () async {
                              bool willRefresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivityForm(
                                    id: widget.id,
                                  ),
                                ),
                              );

                              if (willRefresh) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, true);
                              }
                            },
                            style: const ButtonStyle(
                              fixedSize:
                                  MaterialStatePropertyAll(Size(200, 50)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.white54,
                                ),
                                Text(
                                  "Editar",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        if (!widget.isFromMyActivity)
                          ElevatedButton(
                            onPressed: () async {
                              await store.deleteActivity(widget.id);

                              if (store.error.value.isEmpty) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, true);
                              }
                            },
                            style: const ButtonStyle(
                              fixedSize:
                                  MaterialStatePropertyAll(Size(200, 50)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.white54,
                                ),
                                Text(
                                  "Remover",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        if (widget.isFromMyActivity)
                          ElevatedButton(
                            onPressed: () async {
                              if (loggedUserModel?.id != null) {
                                await store.unlinkActivity(
                                    widget.id, loggedUserModel!.id!);
                              }

                              if (store.error.value.isNotEmpty) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(store.error.value),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, true);
                              }
                            },
                            style: const ButtonStyle(
                              fixedSize:
                                  MaterialStatePropertyAll(Size(200, 50)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.assignment_return_outlined,
                                  color: Colors.white54,
                                ),
                                Text(
                                  "Desvincular",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        if (widget.isFromMyActivity)
                          ElevatedButton(
                            onPressed: () async {
                              if (loggedUserModel?.id != null) {
                                await store.finishActivity(
                                    widget.id, loggedUserModel!.id!);
                              }

                              if (store.error.value.isNotEmpty) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(store.error.value),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, true);
                              }
                            },
                            style: const ButtonStyle(
                                fixedSize:
                                    MaterialStatePropertyAll(Size(200, 50)),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.check_box,
                                  color: Colors.white54,
                                ),
                                Text(
                                  "Entregar",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String text,
    required double fontSize,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w300,
                color: Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
