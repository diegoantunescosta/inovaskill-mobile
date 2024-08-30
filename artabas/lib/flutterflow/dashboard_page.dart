import 'dart:convert';
import 'package:artabas/flutterflow/aviario.dart';
import 'package:artabas/flutterflow/climatizacao.dart';
import 'package:artabas/flutterflow/smaai.dart';
import 'package:artabas/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:artabas/pages/graph_page.dart';
import 'package:artabas/widgets/cotacao_popup.dart';
import 'package:artabas/widgets/recurso_popup.dart';
import 'package:artabas/widgets/settings_sheet.dart';
import 'package:artabas/widgets/quick_access_button.dart';
import 'package:artabas/widgets/galpao_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
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
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
            color: Colors.black,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
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
              const Text(
                'Nome Granja',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 205, 210),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      '1 dispositivo com parâmetros fora do normal',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Acesso rápido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginSmaai(),
                            ),
                          );
                        },
                        child: QuickAccessButton(
                          label: 'Smaai',
                          icon: Icons.build,
                        ),
                      );
                    } else if (index == 1) {
                      return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GraphScreen(),
                            ),
                          );
                        },
                        child: QuickAccessButton(
                          label: 'Estatísticas operacionais',
                          icon: Icons.bar_chart,
                        ),
                      );
                    } else if (index == 2) {
                      return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AviaryScreen(),
                            ),
                          );
                        },
                        child: QuickAccessButton(
                          label: 'Aviario',
                          icon: Icons.add,
                        ),
                      );
                    } else if (index == 3) {
                      return TextButton(
                        onPressed: () {
                          _showPopup(context);
                        },
                        child: QuickAccessButton(
                          label: 'Recurso',
                          icon: Icons.more_horiz,
                        ),
                      );
                    } else if (index == 4) {
                      return TextButton(
                        onPressed: () {
                          _showCotacaoPopup(context);
                        },
                        child: QuickAccessButton(
                          label: 'Cotação',
                          icon: Icons.monetization_on,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dispositivos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              // Container com ListView para os cards de dispositivos
              Container(
                height: MediaQuery.of(context).size.height - 380, // Altura ajustável conforme necessário
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(), // Impede que o ListView interaja
                  children: [
                    GalpaoCard(
                      title: 'Dispositivo A',
                      temperatura: '25°C',
                      agua: '13%',
                      alimentacao: '88%',
                      updatedAt: '26/06 10:37',
                      color: Color.fromARGB(255, 255, 205, 210),
                      icon: Icons.warning,
                      onPressedSettings: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClimatizacaoDetalhesPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GalpaoCard(
                      title: 'Dispositivo B',
                      temperatura: '22°C',
                      agua: '92%',
                      alimentacao: '80%',
                      updatedAt: '26/06 10:37',
                      color: Color.fromARGB(255, 255, 255, 255),
                      icon: Icons.thumb_up,
                      onPressedSettings: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClimatizacaoDetalhesPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GalpaoCard(
                      title: 'Dispositivo C',
                      temperatura: '23°C',
                      agua: '89%',
                      alimentacao: '72%',
                      updatedAt: '26/06 10:37',
                      color: Color.fromARGB(255, 255, 255, 255),
                      icon: Icons.thumb_up,
                      onPressedSettings: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClimatizacaoDetalhesPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GalpaoCard(
                      title: 'Dispositivo D',
                      temperatura: '22°C',
                      agua: '80%',
                      alimentacao: '81%',
                      updatedAt: '26/06 10:37',
                      color: Color.fromARGB(255, 255, 255, 255),
                      icon: Icons.thumb_up,
                      onPressedSettings: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClimatizacaoDetalhesPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                _logout(context);
              },
            ),
            // Outras opções podem ser adicionadas aqui
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _showPopup(BuildContext context) {
    showPopup(context);
  }

  void _showCotacaoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CotacaoPopup();
      },
    );
  }
}
