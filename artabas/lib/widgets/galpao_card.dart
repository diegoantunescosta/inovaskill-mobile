import 'package:flutter/material.dart';

class GalpaoCard extends StatelessWidget {
  final String title;
  final String temperatura;
  final String agua;
  final String alimentacao;
  final String updatedAt;
  final Color color;
  final IconData icon;
  final VoidCallback onPressedSettings;

  const GalpaoCard({
    required this.title,
    required this.temperatura,
    required this.agua,
    required this.alimentacao,
    required this.updatedAt,
    required this.color,
    required this.icon,
    required this.onPressedSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Temperatura ($temperatura)',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Água ($agua)',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Alimentação ($alimentacao)',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 5),
                Text(
                  'Atualizado em: $updatedAt',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey),
              onPressed: onPressedSettings,
            ),
          ],
        ),
      ),
    );
  }
}
