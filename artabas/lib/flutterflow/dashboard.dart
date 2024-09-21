// import 'package:artabas/flutterflow/aviario.dart';
// import 'package:artabas/flutterflow/climatizacao.dart';
// import 'package:artabas/pages/graph_page.dart';
// import 'package:flutter/material.dart';
// import 'dashboard_page.dart'; 
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Artabas App',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//       ),
//       home: const DashboardPage2(),
//     );
//   }
// }
// class DashboardPage2 extends StatelessWidget {
//   const DashboardPage2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: DropdownButton<String>(
//           value: 'identificador granja',
//           items: <String>['identificador granja'].map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           onChanged: (_) {},
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {},
//             color: Colors.white,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Search bar
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Pergunte para a IA',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Central Dashboard Button
//               _buildMenuButton(
//                 context,
//                 'Dashboard Central',
//                 Icons.dashboard_customize,
//                 Colors.red,
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => GraphScreen(),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               // Aviários Button
//               _buildMenuButton(
//                 context,
//                 'Aviários',
//                 Icons.home,
//                 Colors.red,
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AviaryScreen(),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               // Climatização Button
//               _buildMenuButton(
//                 context,
//                 'Climatização',
//                 Icons.thermostat,
//                 Colors.red,
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ClimatizacaoDetalhesPage(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.red,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: Colors.white),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_customize, color: Colors.white),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.thermostat, color: Colors.white),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuButton(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onPressed,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: color),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         trailing: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: color,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           onPressed: onPressed,
//           child: Text('Ir para a página'),
//         ),
//       ),
//     );
//   }
// }