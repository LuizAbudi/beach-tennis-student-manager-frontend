import 'package:flutter/material.dart';

class HandleErros extends StatelessWidget {
  final String errorMessage;

  const HandleErros({
    super.key,
    required this.errorMessage,
  });

  void showError(BuildContext context) {
    String translatedErrorMessage;

    switch (errorMessage) {
      case "User already exists":
        translatedErrorMessage = "Usuário já existe";
        break;
      default:
        translatedErrorMessage = errorMessage;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translatedErrorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
