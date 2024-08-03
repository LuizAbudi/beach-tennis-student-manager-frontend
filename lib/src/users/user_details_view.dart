import 'package:flutter/material.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/user_stores.dart';

class UserItemDetailsView extends StatefulWidget {
  final int id;

  const UserItemDetailsView({super.key, required this.id});

  @override
  State<UserItemDetailsView> createState() => _UserItemDetailsViewState();
}

class _UserItemDetailsViewState extends State<UserItemDetailsView> {
  final UserStore store = UserStore(
    controller: UserController(
      client: HttpClient(),
    ),
  );

  UserModel? item;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await store.getUserById(widget.id);
    setState(() {
      item = user;
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
                icon: Icons.person_outline,
                text: item?.name ?? 'Desconhecido',
                fontSize: 24,
                color: Colors.deepOrange.shade400,
              ),
              const SizedBox(height: 16),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              _buildDetailItem(
                icon: Icons.email_outlined,
                text: item?.email ?? 'Sem e-mail',
                fontSize: 20,
                color: Colors.deepOrange.shade400,
              ),
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
