import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late Future<String> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _fetchDataFuture = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos Sheets'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                );

                if (result != null) {
                  PlatformFile platformFile = result.files.single;
                  if (platformFile.bytes != null) {
                    await uploadExcel(context, platformFile);
                    await _refreshData(); // Atualize os gráficos após o upload
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Erro ao obter o conteúdo do arquivo'),
                      backgroundColor: Colors.red,
                    ));
                  }
                }
              },
              child: Text('Enviar Excel'),
            ),
            SizedBox(height: 20),
            Expanded(child: SalesChart(
              title: 'Total de Aves Mortas',
              yValueMapper: (item) => item['TotalAvesMortas'].toDouble(),
              fetchDataFuture: _fetchDataFuture,
            )),
            SizedBox(height: 20),
            Expanded(child: DualSalesChart(
              title: 'Comparação de Previsto vs Real de Ração',
              previstoYValueMapper: (item) => item['TotalPrevistoRacao'].toDouble(),
              realYValueMapper: (item) => item['TotalRealRacao'].toDouble(),
              fetchDataFuture: _fetchDataFuture,
            )),
          ],
        ),
      ),
    );
  }
}

class SalesChart extends StatelessWidget {
  final String title;
  final double Function(Map<String, dynamic>) yValueMapper;
  final Future<String> fetchDataFuture;

  const SalesChart({
    Key? key,
    required this.title,
    required this.yValueMapper,
    required this.fetchDataFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
        } else {
          final data = jsonDecode(snapshot.data.toString());
          final List<SalesData> chartData = data.map<SalesData>((item) =>
              SalesData(item['Sheet'], yValueMapper(item))).toList();

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: title),
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

class DualSalesChart extends StatelessWidget {
  final String title;
  final double Function(Map<String, dynamic>) previstoYValueMapper;
  final double Function(Map<String, dynamic>) realYValueMapper;
  final Future<String> fetchDataFuture;

  const DualSalesChart({
    Key? key,
    required this.title,
    required this.previstoYValueMapper,
    required this.realYValueMapper,
    required this.fetchDataFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
        } else {
          final data = jsonDecode(snapshot.data.toString());
          final List<SalesData> previstoData = data.map<SalesData>((item) =>
              SalesData(item['Sheet'], previstoYValueMapper(item))).toList();

          final List<SalesData> realData = data.map<SalesData>((item) =>
              SalesData(item['Sheet'], realYValueMapper(item))).toList();

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: title),
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
  final response = await http.get(Uri.parse('http://213.199.37.135:5000/getData'));
  return response.body;
}

Future<void> uploadExcel(BuildContext context, PlatformFile platformFile) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Uploading...'),
            ],
          ),
        ),
      );
    },
  );

  var request = http.MultipartRequest('POST', Uri.parse('http://213.199.37.135:5000/upload_excel'));
  request.files.add(http.MultipartFile.fromBytes('file', platformFile.bytes!, filename: platformFile.name));
  var response = await request.send();

  Navigator.of(context).pop(); // Close the loading dialog

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Upload successful'),
      backgroundColor: Color.fromARGB(255, 95, 95, 95),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Upload failed'),
      backgroundColor: Color.fromARGB(255, 95, 95, 95),
    ));
  }
}

class SalesData {
  final String sheet;
  final double sales;

  SalesData(this.sheet, this.sales);
}


