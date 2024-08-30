import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import para SharedPreferences
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart for the line chart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ClimatizacaoDetalhesPage(),
    );
  }
}

class ClimatizacaoDetalhesPage extends StatefulWidget {
  @override
  _ClimatizacaoDetalhesPageState createState() => _ClimatizacaoDetalhesPageState();
}

class _ClimatizacaoDetalhesPageState extends State<ClimatizacaoDetalhesPage> {
  bool exaustoresLigado = false;
  bool exemplo2Ligado = false;
  double luzValue = 0.0;
  String chaveAtual = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _loadChave(); // Carregar a chave ao inicializar a página
  // }

  // // Função para carregar a chave das SharedPreferences
  // Future<void> _loadChave() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     chaveAtual = prefs.getString('chaveAtual') ?? 'Chave não definida';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navega para a página anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Título
            Text(
              'Climatização',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),

            // Subtítulo (Identificador aviário)
            Text(
              'Identificador aviário',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            // Linha Separadora
            Divider(thickness: 1, color: Colors.black26),
            SizedBox(height: 10),

            // Line Chart Placeholder
            Container(
              height: 150,
              color: Colors.white,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 25),
                        FlSpot(1, 27),
                        FlSpot(2, 24),
                        FlSpot(3, 26),
                        FlSpot(4, 28),
                        FlSpot(5, 29),
                        FlSpot(6, 30),
                      ],
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}°C',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          List<String> days = [
                            'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
                          ];
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Exaustores Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exaustores'),
                ToggleButtons(
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Desligado'),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Ligado'),
                    ),
                  ],
                  isSelected: [!exaustoresLigado, exaustoresLigado],
                  onPressed: (index) {
                    setState(() {
                      exaustoresLigado = index == 1;
                    });
                  },
                  color: Colors.black54,
                  selectedColor: Colors.white,
                  fillColor: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Exemplo2 Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exemplo2'),
                ToggleButtons(
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Desligado'),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Ligado'),
                    ),
                  ],
                  isSelected: [!exemplo2Ligado, exemplo2Ligado],
                  onPressed: (index) {
                    setState(() {
                      exemplo2Ligado = index == 1;
                    });
                  },
                  color: Colors.black54,
                  selectedColor: Colors.white,
                  fillColor: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Luz Slider
            Text('Luz'),
            Slider(
              value: luzValue,
              onChanged: (newValue) {
                setState(() {
                  luzValue = newValue;
                });
              },
              activeColor: Colors.red,
              inactiveColor: Colors.red[100],
              min: 0,
              max: 100,
            ),
          ],
        ),
      ),
    );
  }
}
