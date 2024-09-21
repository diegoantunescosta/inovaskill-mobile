import 'package:artabas/flutterflow/chatpage.dart';
import 'package:artabas/flutterflow/graph.dart';
import 'package:artabas/flutterflow/inputdados.dart';
import 'package:artabas/pages/graph_page.dart';
import 'package:artabas/widgets/cotacao_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  final String token;
  final String tokenAuth;
  final String mac;

  const DashboardPage({super.key, required this.token, required this.tokenAuth, required this.mac});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? lastReading;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://osm2ll72f4.execute-api.us-east-1.amazonaws.com/dev/api/products/detalhes');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "token": widget.token,
      "token_auth": widget.tokenAuth,
      "mac": widget.mac,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          lastReading = data['lastReading'];
        });
      } else {
        print('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  void _navigateToChatPage(String systemPrompt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(systemPrompt: systemPrompt, token: 'Diego'),
      ),
    );
  }

  void _navigateToPageGraph(String page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrendLineChart(token: widget.token),
      ),
    );
  }
    void _navigateToPageInputDados(String page) {
    Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => DataInputScreen(token: widget.token),
      ),
    );
  }

  void _showCotacaoPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CotacaoPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Dashboard'),
      ),
      body: lastReading == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InfoCard(
                            temp: '${lastReading!['average_temperature']}°C',
                            humidity: '${lastReading!['average_humidity']}%',
                            pressure: '${lastReading!['p1']} Pa',
                            title: 'Leitura Atual',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InfoCard(
                            temp: '${lastReading!['desired_temperature']}°C',
                            humidity: '${lastReading!['desired_humidity']}%',
                            pressure: '${lastReading!['desired_pressure']} Pa',
                            title: 'Ajustes Desejados',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SectionTitle('Consumo de Água'),
                  WaterConsumption(
                    sensor: 'H2O',
                    today: '${lastReading?['h2o1'] ?? 'N/A'} Litros',
                    total: '${lastReading?['h2o_lot'] ?? 'N/A'} Litros',
                  ),
                  SectionTitle('CO2'),
                  Co2Card(
                    sensor: 'CO2',
                    value: '${lastReading?['air_co2'] ?? 'N/A'} PPM',
                  ),
                  SectionTitle('Sondas Temperatura'),
                  SensorList(
                    sensors: [
                      {'label': 'T-1', 'value': '${lastReading?['t1'] ?? 'N/A'}°C'},
                      {'label': 'T-2', 'value': '${lastReading?['t2'] ?? 'N/A'}°C'},
                      {'label': 'T-3', 'value': '${lastReading?['t3'] ?? 'N/A'}°C'},
                      {'label': 'T-4', 'value': '${lastReading?['t4'] ?? 'N/A'}°C'},
                      {'label': 'T-5', 'value': '${lastReading?['t5'] ?? 'N/A'}°C'},
                    ],
                  ),
                  SectionTitle('Sondas Umidade'),
                  SensorList(
                    sensors: [
                      {'label': 'U-1', 'value': '${lastReading?['h1'] ?? 'N/A'}%'},
                      {'label': 'U-2', 'value': '${lastReading?['h2'] ?? 'N/A'}%'},
                    ],
                  ),
                  SectionTitle('Sondas de Temperatura/Umidade'),
                  TempHumidityList(
                    data: [
                      {'sensor': 'TU-1', 'temp': '${lastReading?['th1_t'] ?? 'N/A'}°C', 'humidity': '${lastReading?['th1_h'] ?? 'N/A'}%'},
                      {'sensor': 'TU-2', 'temp': '${lastReading?['th2_t'] ?? 'N/A'}°C', 'humidity': '${lastReading?['th2_h'] ?? 'N/A'}%'},
                      {'sensor': 'TU-3', 'temp': '${lastReading?['th3_t'] ?? 'N/A'}°C', 'humidity': '${lastReading?['th3_h'] ?? 'N/A'}%'},
                    ],
                  ),
                  SectionTitle('Sondas de Pressão'),
                  SensorList(
                    sensors: [
                      {'label': 'P-1', 'value': '${lastReading?['p1'] ?? 'N/A'} Pa'},
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () => _navigateToPageGraph('Home'),
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              color: Colors.white,
              onPressed: () {
                if (lastReading != null) {
                  final systemPrompt = 'Os detalhes atuais são: ${jsonEncode(lastReading)}';
                  _navigateToChatPage(systemPrompt);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.show_chart),
              color: Colors.white,
              onPressed: () => _navigateToPageGraph('Graph'),
            ),
            IconButton(
              icon: const Icon(Icons.info),
              color: Colors.white,
              onPressed: _showCotacaoPopup,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () => _navigateToPageInputDados('Input'),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String temp;
  final String humidity;
  final String pressure;

  const InfoCard({super.key, required this.title, required this.temp, required this.humidity, required this.pressure});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 0, 0, 0),
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Temperatura: $temp', style: const TextStyle(color: Colors.black87)),
                Text('Umidade: $humidity', style: const TextStyle(color: Colors.black87)),
                Text('Pressão: $pressure', style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}

class WaterConsumption extends StatelessWidget {
  final String sensor;
  final String today;
  final String total;

  const WaterConsumption({super.key, required this.sensor, required this.today, required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 0, 0, 0),
            width: double.infinity,
            child: Text(
              'Consumo de Água - Sensor $sensor',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Hoje: $today', style: const TextStyle(color: Colors.black87)),
                Text('Total: $total', style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Co2Card extends StatelessWidget {
  final String sensor;
  final String value;

  const Co2Card({super.key, required this.sensor, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 0, 0, 0),
            width: double.infinity,
            child: Text(
              'CO2 - Sensor $sensor',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Valor: $value', style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SensorList extends StatelessWidget {
  final List<Map<String, String>> sensors;

  const SensorList({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 0, 0, 0),
            width: double.infinity,
            child: Text(
              'Sensores',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sensors.map((sensor) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${sensor['label']}: ${sensor['value']}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TempHumidityList extends StatelessWidget {
  final List<Map<String, String>> data;

  const TempHumidityList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 0, 0, 0),
            width: double.infinity,
            child: Text(
              'Temperatura/Umidade',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${item['sensor']}: Temp: ${item['temp']}, Humidade: ${item['humidity']}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
