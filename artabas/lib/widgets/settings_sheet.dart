import 'package:flutter/material.dart';

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});

  @override
  _SettingsSheetState createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  bool _ventilationOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Ventilação'),
            trailing: Switch(
              value: _ventilationOn,
              onChanged: (value) {
                setState(() {
                  _ventilationOn = value;
                });
              },
              activeColor: Colors.red, // Cor vermelha quando ativo
            ),
          ),
          ListTile(
            title: const Text('Bebedouro'),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green), // Fundo verde
              child: const Text('Acionar'),
            ),
          ),
          ListTile(
            title: const Text('Alimentação'),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green), // Fundo verde
              child: const Text('Acionar'),
            ),
          ),
        ],
      ),
    );
  }
}