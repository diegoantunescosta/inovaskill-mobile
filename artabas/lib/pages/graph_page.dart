// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: Colors.red,
//         hintColor: Colors.white,
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.black),
//           bodyMedium: TextStyle(color: Colors.black),
//         ),
//         buttonTheme: const ButtonThemeData(
//           buttonColor: Colors.red, // Button color
//           textTheme: ButtonTextTheme.primary, // Text color in buttons
//         ),
//         appBarTheme: const AppBarTheme(
//           color: Colors.red,
//         ), 
//       ),
//       home: GraphScreen(),
//     );
//   }
// }

// class GraphScreen extends StatefulWidget {
//   const GraphScreen({super.key});

//   @override
//   _GraphScreenState createState() => _GraphScreenState();
// }

// class _GraphScreenState extends State<GraphScreen> {
//   late Future<List<SalesData>> _fetchDataFuture;
//   String _selectedChickenType = 'Dekalb White'; // Default type
//   final DateTime _today = DateTime.now(); // Define today's date

//   @override
//   void initState() {
//     super.initState();
//     _fetchDataFuture = fetchData(_selectedChickenType);
//   }

//   Future<List<SalesData>> fetchData(String chickenType) async {
//     final response = await http.get(Uri.parse('https://rnndd9xtrg.execute-api.us-east-1.amazonaws.com/dev/getData?chickenType=$chickenType'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map<SalesData>((item) => SalesData(
//         DateTime.parse(item['Date']),
//         item['TotalAvesMortas'].toDouble(),
//         item['TotalPrevistoRacao'].toDouble(),
//         item['TotalRealRacao'].toDouble(),
//       )).toList();
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Future<void> uploadExcel() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx'],
//     );

//     if (result != null) {
//       PlatformFile platformFile = result.files.single;
//       if (platformFile.bytes != null) {
//         await uploadFile(platformFile); // Await uploadFile which returns Future<void>
//         setState(() {
//           _fetchDataFuture = fetchData(_selectedChickenType); // Refresh data based on selected chicken type
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Erro ao obter o conteúdo do arquivo'),
//           backgroundColor: Colors.red,
//         ));
//       }
//     }
//   }

//   Future<void> uploadFile(PlatformFile file) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const Dialog(
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(width: 20),
//                 Text('Uploading...'),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     var request = http.MultipartRequest('POST', Uri.parse('http://213.199.37.135:5000/upload_excel'));
//     request.files.add(http.MultipartFile.fromBytes('file', file.bytes!, filename: file.name));
//     var response = await request.send();

//     Navigator.of(context).pop(); // Close the loading dialog

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Upload successful'),
//         backgroundColor: Colors.green,
//       ));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Upload failed'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   void _onChickenTypeChanged(String? newValue) {
//     if (newValue != null) {
//       setState(() {
//         _selectedChickenType = newValue;
//         _fetchDataFuture = fetchData(_selectedChickenType); // Update data based on selected chicken type
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gráficos Diários'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Centralize the dropdown and upload button
//             Container(
//               alignment: Alignment.center,
//               child: Column(
//                 children: [
//                   DropdownButton<String>(
//                     value: _selectedChickenType,
//                     onChanged: _onChickenTypeChanged,
//                     items: <String>['Dekalb White', 'Lohmann brown', 'Lohmann White', 'Bovans White'] // List of chicken types
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),
//                   OutlinedButton(
//                     onPressed: uploadExcel,
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), // Border color
//                     ), // Correct usage
//                     child: Text('Enviar Excel'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: FutureBuilder<List<SalesData>>(
//                 future: _fetchDataFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('Nenhum dado disponível.'));
//                   } else {
//                     final data = snapshot.data!;
//                     return Column(
//                       children: [
//                         Expanded(
//                           flex: 2, // Make this section take up more space
//                           child: SalesLineChart(data: data, today: _today),
//                         ),
//                         const SizedBox(height: 20),
//                         Expanded(
//                           flex: 1, // Make this section take up less space
//                           child: DualSalesLineChart(data: data, today: _today),
//                         ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SalesLineChart extends StatelessWidget {
//   final List<SalesData> data;
//   final DateTime today;

//   const SalesLineChart({super.key, required this.data, required this.today});

//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//       primaryXAxis: DateTimeAxis(
//         maximum: today, // Define the maximum date as today
//       ),
//       title: ChartTitle(text: 'Total de Aves Mortas Diárias'),
//       series: <ChartSeries<SalesData, DateTime>>[
//         LineSeries<SalesData, DateTime>(
//           dataSource: data,
//           xValueMapper: (SalesData sales, _) => sales.date,
//           yValueMapper: (SalesData sales, _) => sales.totalAvesMortas,
//           dataLabelSettings: const DataLabelSettings(isVisible: true),
//         ),
//       ],
//     );
//   }
// }

// class DualSalesLineChart extends StatelessWidget {
//   final List<SalesData> data;
//   final DateTime today;

//   const DualSalesLineChart({super.key, required this.data, required this.today});

//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//       primaryXAxis: DateTimeAxis(
//         maximum: today, // Define the maximum date as today
//       ),
//       title: ChartTitle(text: 'Comparação de Ração Diária'),
//       legend: Legend(isVisible: true),
//       series: <ChartSeries<SalesData, DateTime>>[
//         LineSeries<SalesData, DateTime>(
//           dataSource: data,
//           xValueMapper: (SalesData sales, _) => sales.date,
//           yValueMapper: (SalesData sales, _) => sales.totalPrevistoRacao,
//           name: 'Previsto',
//           dataLabelSettings: const DataLabelSettings(isVisible: true),
//         ),
//         LineSeries<SalesData, DateTime>(
//           dataSource: data,
//           xValueMapper: (SalesData sales, _) => sales.date,
//           yValueMapper: (SalesData sales, _) => sales.totalRealRacao,
//           name: 'Real',
//           dataLabelSettings: const DataLabelSettings(isVisible: true),
//         ),
//       ],
//     );
//   }
// }

// class SalesData {
//   final DateTime date;
//   final double totalAvesMortas;
//   final double totalPrevistoRacao;
//   final double totalRealRacao;

//   SalesData(this.date, this.totalAvesMortas, this.totalPrevistoRacao, this.totalRealRacao);
// }
