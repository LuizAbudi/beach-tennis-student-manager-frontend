import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/activities/activity_item_list_view.dart';
import 'package:mobile/src/activities/my_activity_item_list_view.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/pages/login.dart';
import 'package:mobile/src/students/student_item_list_view.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final tabs = [
    const UserItemListView(),
    const ActivityItemListView(),
    const MyActivityItemListView(),
  ];

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
  }

  Future<bool> _checkToken() async {
    final token = localStorage.getItem('token');
    return token != null;
  }

  void _logout() {
    localStorage.clear();
    _checkToken().then((loggedIn) {
      if (!loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 248, 249, 1),
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Olá, ',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Color.fromRGBO(22, 24, 35, 1),
                  fontSize: 22,
                ),
              ),
              TextSpan(
                text: loggedUserModel?.name ?? "Usuário",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(22, 24, 35, 1),
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout,
              color: Color.fromRGBO(22, 24, 35, 1),
            ),
          )
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13,
        selectedItemColor: const Color.fromRGBO(255, 98, 62, 1),
        unselectedFontSize: 12,
        backgroundColor: Colors.white,
        items: List.generate(3, (index) {
          return BottomNavigationBarItem(
            icon: _buildIcon(index, context),
            label: _getLabel(index),
          );
        }),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildIcon(int index, BuildContext context) {
    final bool isSelected = _currentIndex == index;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isSelected)
          Container(
            width: 60,
            height: 32,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 98, 62, 0.2),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        Icon(
          _getIcon(index),
          color: isSelected
              ? const Color.fromRGBO(255, 98, 62, 1)
              : const Color.fromRGBO(22, 24, 35, 0.6),
        ),
      ],
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.people;
      case 1:
        return Icons.assignment;
      case 2:
      default:
        return Icons.person;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Alunos";
      case 1:
        return "Aulas";
      case 2:
      default:
        return "Meu Perfil";
    }
  }
}
