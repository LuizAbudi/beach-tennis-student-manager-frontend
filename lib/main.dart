import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalStorage();
  await dotenv.load();

  if (kDebugMode) {
    final apiUrl = dotenv.get("API_URL");
    print(apiUrl);
  }

  runApp(const MyApp());
}
