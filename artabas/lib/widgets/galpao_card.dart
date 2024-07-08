import 'package:flutter/material.dart';

class GalpaoCard extends StatelessWidget {
  final String title;
  final String temperatura;
  final String agua;
  final String alimentacao;
  final String updatedAt;

  GalpaoCard({
    required this.title,
    required this.temperatura,
    required this.agua,
    required this.alimentacao,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Temperatura ($temperatura)',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  'Água ($agua)',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  'Alimentação ($alimentacao)',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 5),
                Text(
                  'Atualizado em: $updatedAt',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.grey),
              onPressed: () {}, // Implementação da função de configurações
            ),
          ],
        ),
      ),
    );
  }
}
