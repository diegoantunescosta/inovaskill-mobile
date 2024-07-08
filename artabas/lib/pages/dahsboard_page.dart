import 'package:artabas/widgets/cotacao_popup.dart';
import 'package:artabas/widgets/recurso_popup.dart';
import 'package:artabas/widgets/settings_sheet.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';




class DashboardPage extends StatelessWidget {
  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SettingsSheet();
      },
    );
  }

  void _showPopup(BuildContext context) {
  showPopup(context);
}

    void _showCotacaoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CotacaoPopup(); // Retorna a instância do seu widget de cotação
      },
    );
  }

Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://apicotacaoovos.onrender.com/api/eggs_online'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Falha ao carregar dados da API');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Artabas',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showSettingsSheet(context);
            },
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome Granja',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      '2 dispositivos com parâmetros fora do normal',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Acesso rápido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildQuickAccessButton(
                          'Equipamentos', Icons.build);
                    } else if (index == 1) {
                      return _buildQuickAccessButton(
                          'Estatísticas operacionais', Icons.bar_chart);
                    } else if (index == 2) {
                      return TextButton(
                        onPressed: () {
                          _showPopup(context);
                        },
                        child: _buildQuickAccessButton('Recurso', Icons.more_horiz),
                      );
                    } else if (index == 3) {
                      return TextButton(
                        onPressed: () {
                          _showCotacaoPopup(context);
                        },
                        child: _buildQuickAccessButton('Cotação', Icons.add),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Dispositivos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              ToggleButtons(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Todos'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Em alerta'),
                  ),
                ],
                isSelected: [true, false],
                onPressed: (int index) {
                  // Ação ao alternar entre 'Todos' e 'Em alerta'
                },
              ),
              SizedBox(height: 20),
              _buildGalpaoCard(
                context,
                'Dispositivo A',
                '25°C',
                '13%',
                '88%',
                '26/06 10:37',
              ),
              SizedBox(height: 10),
              _buildGalpaoCard(
                context,
                'Dispositivo B',
                '22°C',
                '92%',
                '17%',
                '26/06 10:37',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(String label, IconData icon) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 100,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.black),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildGalpaoCard(BuildContext context, String title, String temperatura,
      String agua, String alimentacao, String updatedAt) {
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
              onPressed: () => _showSettingsSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

