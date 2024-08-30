import 'package:artabas/flutterflow/authenticacaozap.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para codificar o JSON

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false; // Adiciona uma variável para controlar o estado de carregamento

  // Função para enviar o número para a API
  Future<void> _sendNumber() async {
    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    final number = _controller.text;

    // Adiciona o código do país (55) ao número
    final formattedNumber = '55$number';

    // Verifica se o número não está vazio
    if (formattedNumber.isEmpty) {
      // Exibe uma mensagem de erro se o número estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um número de WhatsApp.')),
      );
      setState(() {
        _isLoading = false; // Para o carregamento
      });
      return;
    }

    // Configuração da requisição
    final url = Uri.parse('https://e2d9w1aprk.execute-api.us-east-1.amazonaws.com/dev/add_number');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'number': formattedNumber}),
    );

    // Verifica a resposta
    if (response.statusCode == 200) {
      // Sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Número enviado com sucesso!')),
      );
      
      // Navega para a próxima página passando o número
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthenticZap(number: formattedNumber, key: UniqueKey()),
        ),
      );
    } else {
      // Erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao enviar o número.')),
      );
    }

    setState(() {
      _isLoading = false; // Para o carregamento
    });
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
            //   'image_3-sem fundo.png', // replace with your image asset path
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
                    'Insira seu número de WhatsApp para continuar',
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

            // WhatsApp Number Input Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Número de WhatsApp',
                hintText: 'Número de WhatsApp',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),

            // Next Button
            ElevatedButton(
              onPressed: _isLoading ? null : _sendNumber, // Desativa o botão enquanto carrega
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    ) // Exibe o carregamento se estiver ativo
                  : Text(
                      'Próximo',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
