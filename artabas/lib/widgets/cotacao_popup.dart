import 'dart:convert';
import 'package:artabas/service/dado_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CotacaoPopup extends StatefulWidget {
  @override
  _CotacaoPopupState createState() => _CotacaoPopupState();
}


class _CotacaoPopupState extends State<CotacaoPopup> {
  List<DadoAPI> dados = [];
  bool isLoading = true; // Variável para controlar o estado de carregamento

  String getLastBusinessDay() {
    DateTime now = DateTime.now();
    DateTime lastBusinessDay = now;

    // Subtrair um dia até encontrar um dia útil
    do {
      lastBusinessDay = lastBusinessDay.subtract(Duration(days: 1));
    } while (lastBusinessDay.weekday == DateTime.saturday ||
        lastBusinessDay.weekday == DateTime.sunday);

    return DateFormat('yyyy-MM-dd').format(lastBusinessDay);
  }

  Future<void> fetchData() async {
    String lastBusinessDay = getLastBusinessDay();
    final response = await http.get(Uri.parse(
        'http://213.199.37.135:5000/api/egg-prices?date=$lastBusinessDay'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        dados = jsonData.map((e) => DadoAPI.fromJson(e)).toList();
        isLoading = false; // Altera o estado de carregamento ao finalizar a busca
      });
    } else {
      throw Exception('Falha ao carregar dados da API');
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
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados da API',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(), // Indicador de carregamento
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      return DadoAPIWidget(dado: dados[index]);
                    },
                  ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fechar'),
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
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    );
  }
}
