import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Função para buscar dados da API
Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('http://213.199.37.135:5000/api/eggs_online'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Falha ao carregar dados da API');
  }
}

// Widget RecursoPopup
class RecursoPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('Nenhum dado disponível'));
        }

        Map<String, dynamic> dados = snapshot.data!;
        return AlertDialog(
          title: Text('Dados da API'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView(
                shrinkWrap: true,
                children: dados.keys.map((key) {
                  List<dynamic> items = dados[key];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: items.map((item) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Período: ${item['Periodo']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '💵',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Câmbio: ${item['Cambio']}, Preço: ${item['preco'] ?? item['Dolar']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
