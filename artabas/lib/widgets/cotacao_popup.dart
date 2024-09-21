import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:artabas/service/dado_api.dart'; // Certifique-se de ajustar o caminho

class CotacaoPopup extends StatefulWidget {
  @override
  _CotacaoPopupState createState() => _CotacaoPopupState();
}

class _CotacaoPopupState extends State<CotacaoPopup> {
  List<DadoAPI> cotacaoData = [];
  Map<String, dynamic> onlineData = {};
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  String getLastBusinessDay() {
    DateTime now = DateTime.now();
    DateTime lastBusinessDay = now;

    do {
      lastBusinessDay = lastBusinessDay.subtract(Duration(days: 1));
    } while (lastBusinessDay.weekday == DateTime.saturday || lastBusinessDay.weekday == DateTime.sunday);

    return DateFormat('yyyy-MM-dd').format(lastBusinessDay);
  }

  Future<void> fetchData() async {
    String lastBusinessDay = getLastBusinessDay();
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final cotacaoResponse = await http.get(Uri.parse('http://213.199.37.135:5000/api/egg-prices?date=$lastBusinessDay'));
      final onlineResponse = await http.get(Uri.parse('http://213.199.37.135:5000/api/eggs_online'));

      if (cotacaoResponse.statusCode == 200 && onlineResponse.statusCode == 200) {
        final cotacaoJson = jsonDecode(cotacaoResponse.body) as List<dynamic>;
        final onlineJson = jsonDecode(onlineResponse.body) as Map<String, dynamic>;

        setState(() {
          cotacaoData = cotacaoJson.map((e) => DadoAPI.fromJson(e)).toList();
          onlineData = onlineJson;
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar dados da API');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados de Mercado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.red, // Cor do indicador de progresso
                    ),
                  )
                : hasError
                    ? Center(
                        child: Text(
                          'Erro: $errorMessage',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          children: [
                            Text(
                              'Cotação',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (cotacaoData.isNotEmpty)
                              ...cotacaoData.map((dado) => DadoAPIWidget(dado: dado)).toList()
                            else
                              Center(child: Text('Dados de cotação inválidos')),
                            SizedBox(height: 20),
                            Text(
                              'Online',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (onlineData.isNotEmpty)
                              ...(onlineData.keys.map((key) {
                                var items = onlineData[key];
                                return Container(
                                  constraints: BoxConstraints(
                                    maxWidth: double.infinity,
                                  ),
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            key,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red, // Cor do título
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: items.map<Widget>((item) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Período: ${item['Periodo']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '💵',
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Câmbio: ${item['Cambio']}, Preço: ${item['preco'] ?? item['Dolar']}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList())
                            else
                              Center(child: Text('Dados online inválidos')),
                          ],
                        ),
                      ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fechar'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Cor do texto do botão
                  backgroundColor: Colors.red, // Cor de fundo do botão
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DadoAPIWidget extends StatelessWidget {
  final DadoAPI dado;

  DadoAPIWidget({required this.dado});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity, // Garante que o card use toda a largura disponível
      ),
      child: Card(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data: ${dado.data}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text('Preço (Reais/30 dz): ${dado.preco.toString()}', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Região/Tipo: ${dado.regiaoTipo}', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Variação/Semana (%): ${dado.variacaoSemana.toString()}', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
