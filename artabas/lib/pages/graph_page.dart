import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gráficos Sheets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gráficos Sheets'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: AvesMortasChart()),
              SizedBox(height: 20), // Espaçamento entre os gráficos
              Expanded(child: PrevistoVsRealRacaoChart()),
            ],
          ),
        ),
      ),
    );
  }
}

class AvesMortasChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar dados: ${snapshot.error}');
        } else {
          final data = jsonDecode(snapshot.data.toString());
          final List<SalesData> chartData = data.map<SalesData>((item) =>
              SalesData(item['Sheet'], item['TotalAvesMortas'].toDouble())).toList();

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Total de Aves Mortas por Sheet'),
            series: <ChartSeries<SalesData, String>>[
              ColumnSeries<SalesData, String>(
                dataSource: chartData,
                xValueMapper: (SalesData sales, _) => sales.sheet,
                yValueMapper: (SalesData sales, _) => sales.sales,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              )
            ],
          );
        }
      },
    );
  }
}

class PrevistoVsRealRacaoChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar dados: ${snapshot.error}');
        } else {
          final data = jsonDecode(snapshot.data.toString());
          final List<SalesData> previstoData = data.map<SalesData>((item) =>
              SalesData(item['Sheet'], item['TotalPrevistoRacao'].toDouble())).toList();

          final List<SalesData> realData = data.map<SalesData>((item) =>
              SalesData(item['Sheet'], item['TotalRealRacao'].toDouble())).toList();

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Comparação de Previsto vs Real de Ração por Sheet'),
            legend: Legend(isVisible: true),
            series: <ChartSeries<SalesData, String>>[
              ColumnSeries<SalesData, String>(
                dataSource: previstoData,
                xValueMapper: (SalesData sales, _) => sales.sheet,
                yValueMapper: (SalesData sales, _) => sales.sales,
                name: 'Previsto',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
              ColumnSeries<SalesData, String>(
                dataSource: realData,
                xValueMapper: (SalesData sales, _) => sales.sheet,
                yValueMapper: (SalesData sales, _) => sales.sales,
                name: 'Real',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          );
        }
      },
    );
  }
}

Future<String> fetchData() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000/getData'));
  return response.body;
}

class SalesData {
  final String sheet;
  final double sales;

  SalesData(this.sheet, this.sales);
}
