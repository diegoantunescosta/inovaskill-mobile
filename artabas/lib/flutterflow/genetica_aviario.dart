import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AviaryBatchScreen(),
    );
  }
}

class AviaryBatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
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
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aviário\n', // Use actual identifier
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(thickness: 1),
                    SizedBox(height: 10),
                    Text(
                      'Genética',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    CheckboxListTile(
                      title: Text("Lohman"),
                      value: true,
                      onChanged: (newValue) {
                        // Handle checkbox change
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text("Lohman"),
                      value: true,
                      onChanged: (newValue) {
                        // Handle checkbox change
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text("Lohman"),
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
                      child: Text(
                        'Adicionar genética',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Divider(thickness: 1),
                    SizedBox(height: 10),
                    Text(
                      'Data e quantidade',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Data inicial',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantidade inicial',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
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
