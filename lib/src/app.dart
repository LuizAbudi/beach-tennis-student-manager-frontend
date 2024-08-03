import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/home.dart';
import 'package:mobile/src/login.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTokenCheckTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTokenCheckTimer() {
    const checkInterval = Duration(seconds: 10);
    _timer = Timer.periodic(checkInterval, (_) {
      _checkToken();
    });
  }

  Future<bool> _checkToken() async {
    final token = localStorage.getItem('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        restorationScopeId: 'app',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        home: FutureBuilder(
          future: _checkToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data!) {
                return const Home();
              } else {
                return const LoginPage();
              }
            }
          },
        ));
  }
}
