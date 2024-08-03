import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/activities/my_activity_item_list_view.dart';
import 'package:mobile/src/login.dart';
import 'package:mobile/src/models/user_model.dart';

import 'activities/activity_item_list_view.dart';
import 'users/user_item_list_view.dart';

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
    const ActivityItemListView(),
    const MyActivityItemListView(),
    const UserItemListView()
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
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Olá, ',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white54,
                  fontSize: 22,
                ),
              ),
              TextSpan(
                text: loggedUserModel?.name ?? "Usuário",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
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
              color: Colors.deepOrange,
            ),
          )
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16,
        selectedItemColor: Colors.deepOrange.shade500,
        unselectedItemColor: Colors.white54,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Todas Atividades",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            label: "Minhas Atividades",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Usuários",
          )
        ],
        onTap: (index) => {
          setState(() {
            _currentIndex = index;
          })
        },
      ),
    );
  }
}
