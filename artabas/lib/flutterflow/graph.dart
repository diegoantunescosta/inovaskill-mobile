import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trend Line Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrendLineChart(token: 'm6z6gqn2',),
    );
  }
}

class TrendLineChart extends StatefulWidget {
  final String token;

  const TrendLineChart({super.key, required this.token});

  @override
  _TrendLineChartState createState() => _TrendLineChartState();
}

class _TrendLineChartState extends State<TrendLineChart> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  final List<String> options = [
    'Real Aves',
    'Previsto Aves',
    'Aves Mortas',
    'Previsto Qtde Ovos',
    'Real Ovos',
    'Previsto Ração',
    'Real Ração'
  ];

  final Map<String, Color> colors = {
    'Real Aves': Colors.blue,
    'Previsto Aves': Colors.green,
    'Aves Mortas': Colors.red,
    'Previsto Qtde Ovos': Colors.orange,
    'Real Ovos': Colors.purple,
    'Previsto Ração': Colors.yellow,
    'Real Ração': Colors.cyan,
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://rnndd9xtrg.execute-api.us-east-1.amazonaws.com/dev/dados_graph'),
      headers: {
        'Authorization': widget.token, // Adiciona o token aos cabeçalhos
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        data = List<Map<String, dynamic>>.from(json.decode(response.body));
        isLoading = false;
        // Delay the scroll to ensure the layout is built before scrolling
        Future.delayed(Duration(milliseconds: 100), () {
          _scrollToEnd();
        });
      });
    } else {
      // Handle API error here
      print('Failed to load data');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trend Line Chart'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Container(
                        width: data.length * 100.0, // Ajuste a largura conforme necessário
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  interval: 10,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: TextStyle(fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  interval: 10,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: TextStyle(fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < data.length) {
                                      String date = data[index]['Data'];
                                      return Text(
                                        date,
                                        style: TextStyle(fontSize: 12),
                                      );
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false, // Desativa os números no topo
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: const Color(0xff37434d),
                                width: 1,
                              ),
                            ),
                            lineBarsData: _getLineBarsData(),
                            minY: 0,
                            maxY: _getMaxYValue(), // Valor dinâmico de maxY
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((touchedSpot) {
                                    return LineTooltipItem(
                                      '${data[touchedSpot.x.toInt()]['Data']}:\n${options[touchedSpot.barIndex]}: ${touchedSpot.y}',
                                      TextStyle(color: Colors.white),
                                    );
                                  }).toList();
                                },
                              ),
                              touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                                // Handle touch event
                              },
                              handleBuiltInTouches: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Espaço entre o gráfico e a legenda
                  _buildLegend(), // Legenda posicionada aqui
                ],
              ),
            ),
    );
  }

  // Função que cria a legenda abaixo do gráfico
  Widget _buildLegend() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: colors[option],
            ),
            SizedBox(width: 5),
            Text(option),
          ],
        );
      }).toList(),
    );
  }

  List<LineChartBarData> _getLineBarsData() {
    return options.map((option) {
      return LineChartBarData(
        isCurved: true,
        spots: data.asMap().entries.map((entry) {
          int index = entry.key;
          double value = double.tryParse(entry.value[option].toString()) ?? 0;
          return FlSpot(index.toDouble(), value);
        }).toList(),
        dotData: FlDotData(show: true),
        color: colors[option],
        belowBarData: BarAreaData(show: false),
      );
    }).toList();
  }

  double _getMaxYValue() {
    double maxY = 0;
    for (String option in options) {
      for (Map<String, dynamic> entry in data) {
        double value = double.tryParse(entry[option].toString()) ?? 0;
        if (value > maxY) {
          maxY = value;
        }
      }
    }
    return maxY;
  }
}
