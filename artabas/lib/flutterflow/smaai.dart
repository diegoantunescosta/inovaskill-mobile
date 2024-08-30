import 'package:artabas/flutterflow/authenticacaozap.dart';
import 'package:artabas/flutterflow/smaai.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'shared_preferences.dart'; // Importe o helper para SharedPreferences

void main() {
  runApp(MyApp());
}

class LoginSmaai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPrefsHelper.getUserKey(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red, // Red app bar as in the image
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Climatização'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Climatização'),
            ),
            body: Center(child: Text('Erro ao carregar chave')),
          );
        } else {
          final key = snapshot.data ?? 'Chave não encontrada';
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Climatização'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Climatização',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Smaai5',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Chave atual: $key',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    'Login da granja',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome da granja',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Login',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color as in the image
                      ),
                      onPressed: () {
                        // Handle the login logic
                      },
                      child: Text('Próximo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
