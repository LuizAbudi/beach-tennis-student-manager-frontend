import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  // try {
  //   await dotenv.load(fileName: '.env');
  // } catch (e) {
  //   if (kDebugMode) {
  //     print('Erro ao carregar o arquivo .env: $e');
  //   }
  // }

  if (kDebugMode) {
    const apiUrl = "https://beach-tennis-student-manager.onrender.com";
    print(apiUrl);
  }

  runApp(const MyApp());
}
