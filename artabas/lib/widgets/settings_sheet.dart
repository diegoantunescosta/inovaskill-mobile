import 'package:flutter/material.dart';

class SettingsSheet extends StatefulWidget {
  @override
  _SettingsSheetState createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  bool _ventilationOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Ventilação'),
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
            title: Text('Bebedouro'),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green), // Fundo verde
              child: Text('Acionar'),
            ),
          ),
          ListTile(
            title: Text('Alimentação'),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green), // Fundo verde
              child: Text('Acionar'),
            ),
          ),
        ],
      ),
    );
  }
}