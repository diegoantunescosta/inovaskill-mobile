import 'dart:convert';

import 'package:artabas/flutterflow/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'shared_preferences.dart'; // Importe o helper

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthenticZap(number: '', key: UniqueKey()), // Inicialize com um valor padrão ou vazio
    );
  }
}

class AuthenticZap extends StatefulWidget {
  final String number;

  AuthenticZap({Key? key, required this.number}) : super(key: key);

  @override
  _AuthenticZapState createState() => _AuthenticZapState();
}

class _AuthenticZapState extends State<AuthenticZap> {
  final TextEditingController _keyController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _checkKey() async {
    final key = _keyController.text;
    final url = Uri.parse('https://e2d9w1aprk.execute-api.us-east-1.amazonaws.com/dev/get_number_by_key?key=$key');

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Supondo que o número seja retornado na resposta
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String number = data['number'];

        // Salve a chave no SharedPreferences
        await SharedPrefsHelper.saveUserKey(key);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(keywhats: key, number: number),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Chave não encontrada';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erro ao verificar a chave';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Logo
            // Image.asset(
            //   'assets/images/image_3-sem fundo.png', // substitua pelo caminho do seu ativo de imagem
            //   height: 150,
            // ),
            // SizedBox(height: 20),

            // Welcome Text
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.red,
              child: Column(
                children: [
                  Text(
                    'Bem-vindo',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Insira a chave para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Login Label
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),

            // Key Input Field
            TextField(
              controller: _keyController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Chave',
                hintText: 'Digite a chave',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),

            // Next Button
            ElevatedButton(
              onPressed: _isLoading ? null : _checkKey,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Próximo',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
