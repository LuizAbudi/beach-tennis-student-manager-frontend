import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String plan;
  final String imageUrl;
  final String paymentStatus;
  final String level;

  const StudentCard({
    super.key,
    required this.name,
    required this.plan,
    required this.imageUrl,
    required this.paymentStatus,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Plano: $plan',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Nível: $level',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildPaymentStatus(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus() {
    Color statusColor;
    String statusText;

    switch (paymentStatus.toLowerCase()) {
      case 'pago':
        statusColor = Colors.green;
        statusText = 'Pago';
        break;
      case 'pendente':
        statusColor = Colors.red;
        statusText = 'Pendente';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Desconhecido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
