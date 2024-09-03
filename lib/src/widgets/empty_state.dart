import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({
    super.key,
    this.message = 'Você ainda não possui alunos cadastrados.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox, // Ícone de caixa vazia
            size: 80, // Tamanho do ícone
            color: Colors.grey, // Cor do ícone
          ),
          const SizedBox(height: 16), // Espaçamento entre o ícone e o texto
          Text(
            message,
            style: const TextStyle(
              fontSize: 18, // Tamanho da fonte
              color: Colors.grey, // Cor do texto
            ),
            textAlign: TextAlign.center, // Centraliza o texto
          ),
        ],
      ),
    );
  }
}
