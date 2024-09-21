// import 'dart:convert';
// import 'package:artabas/flutterflow/aviario.dart';
// import 'package:artabas/flutterflow/climatizacao.dart';
// import 'package:artabas/flutterflow/smaai.dart';
// import 'package:artabas/pages/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:artabas/pages/graph_page.dart';
// import 'package:artabas/widgets/cotacao_popup.dart';
// import 'package:artabas/widgets/recurso_popup.dart';
// import 'package:artabas/widgets/settings_sheet.dart';
// import 'package:artabas/widgets/quick_access_button.dart'; // Se não estiver usando mais, remova
// import 'package:artabas/widgets/galpao_card.dart';

// class DashboardPage extends StatelessWidget {
//   // const DashboardPage({super.key, Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Row(
//           children: [
//             SizedBox(width: 10),
//             Text(
//               'Artabas',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: () {
//               _logout(context);
//             },
//             color: Colors.black,
//           ),
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               _showSettingsSheet(context);
//             },
//             color: Colors.black,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Nome Granja',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 255, 205, 210),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.warning, color: Colors.red),
//                     SizedBox(width: 10),
//                     Text(
//                       '1 dispositivo com parâmetros fora do normal',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Acesso rápido',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 120, // Ajuste a altura conforme necessário
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5, // Quantidade de botões
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: _buildQuickAccessButton(
//                         context,
//                         label: _getButtonLabel(index),
//                         icon: _getButtonIcon(index),
//                         onTap: () {
//                           _handleButtonTap(context, index);
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Dispositivos',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height - 380, // Altura ajustável conforme necessário
//                 child: ListView(
//                   shrinkWrap: true,
//                   physics: const ClampingScrollPhysics(), // Impede que o ListView interaja
//                   children: [
//                     GalpaoCard(
//                       title: 'Dispositivo A',
//                       temperatura: '25°C',
//                       agua: '13%',
//                       alimentacao: '88%',
//                       updatedAt: '26/06 10:37',
//                       color: const Color.fromARGB(255, 255, 205, 210),
//                       icon: Icons.warning,
//                       onPressedSettings: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ClimatizacaoDetalhesPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     GalpaoCard(
//                       title: 'Dispositivo B',
//                       temperatura: '22°C',
//                       agua: '92%',
//                       alimentacao: '80%',
//                       updatedAt: '26/06 10:37',
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       icon: Icons.thumb_up,
//                       onPressedSettings: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ClimatizacaoDetalhesPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     GalpaoCard(
//                       title: 'Dispositivo C',
//                       temperatura: '23°C',
//                       agua: '89%',
//                       alimentacao: '72%',
//                       updatedAt: '26/06 10:37',
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       icon: Icons.thumb_up,
//                       onPressedSettings: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ClimatizacaoDetalhesPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     GalpaoCard(
//                       title: 'Dispositivo D',
//                       temperatura: '22°C',
//                       agua: '80%',
//                       alimentacao: '81%',
//                       updatedAt: '26/06 10:37',
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       icon: Icons.thumb_up,
//                       onPressedSettings: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ClimatizacaoDetalhesPage(),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickAccessButton(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     required Function() onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 100, // Largura ajustável para cada botão
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 32, color: Colors.blue),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _getButtonLabel(int index) {
//     switch (index) {
//       case 0:
//         return 'Smaai';
//       case 1:
//         return 'Estatísticas operacionais';
//       case 2:
//         return 'Aviário';
//       case 3:
//         return 'Recurso';
//       case 4:
//         return 'Cotação';
//       default:
//         return '';
//     }
//   }

//   IconData _getButtonIcon(int index) {
//     switch (index) {
//       case 0:
//         return Icons.build;
//       case 1:
//         return Icons.bar_chart;
//       case 2:
//         return Icons.add;
//       case 3:
//         return Icons.more_horiz;
//       case 4:
//         return Icons.monetization_on;
//       default:
//         return Icons.help;
//     }
//   }

//   void _handleButtonTap(BuildContext context, int index) {
//     switch (index) {
//       case 0:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LoginSmaai(),
//           ),
//         );
//         break;
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => GraphScreen(),
//           ),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AviaryScreen(),
//           ),
//         );
//         break;
//       case 3:
//         _showPopup(context);
//         break;
//       case 4:
//         _showCotacaoPopup(context);
//         break;
//       default:
//         break;
//     }
//   }

//   void _showSettingsSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.exit_to_app),
//               title: const Text('Sair'),
//               onTap: () {
//                 _logout(context);
//               },
//             ),
//             // Outras opções podem ser adicionadas aqui
//           ],
//         );
//       },
//     );
//   }

//   void _logout(BuildContext context) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   void _showPopup(BuildContext context) {
//     showPopup(context);
//   }

//   void _showCotacaoPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CotacaoPopup();
//       },
//     );
//   }
// }
