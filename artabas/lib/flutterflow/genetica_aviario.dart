import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AviaryBatchScreen(),
    );
  }
}

class AviaryBatchScreen extends StatelessWidget {
  const AviaryBatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
     // Use actual user name
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.red,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: const Text(
                  'Adicione um lote\npara o aviário ', // Use actual identifier
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aviário\n', // Use actual identifier
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    const Text(
                      'Genética',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    CheckboxListTile(
                      title: const Text("Lohman"),
                      value: true,
                      onChanged: (newValue) {
                        // Handle checkbox change
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text("Lohman"),
                      value: true,
                      onChanged: (newValue) {
                        // Handle checkbox change
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text("Lohman"),
                      value: true,
                      onChanged: (newValue) {
                        // Handle checkbox change
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle add genetics action
                      },
                      child: const Text(
                        'Adicionar genética',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    const Text(
                      'Data e quantidade',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Data inicial',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantidade inicial',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Adicionar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
