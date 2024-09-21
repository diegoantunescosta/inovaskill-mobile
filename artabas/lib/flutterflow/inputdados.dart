import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataInputScreen(token: 'm6z6gqn2-515'),
    );
  }
}

class DataInputScreen extends StatefulWidget {
  final String token;

  const DataInputScreen({super.key, required this.token});

  @override
  _DataInputScreenState createState() => _DataInputScreenState();
}

class _DataInputScreenState extends State<DataInputScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for the form fields
  final TextEditingController granjaController = TextEditingController();
  final TextEditingController geneticaController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController loteController = TextEditingController();
  final TextEditingController quantInicialAvesController = TextEditingController();
  final TextEditingController galpaoCriaController = TextEditingController();
  final TextEditingController galpaoRecriaController = TextEditingController();
  final TextEditingController galpaoPosturaController = TextEditingController();
  final TextEditingController criaRecriaController = TextEditingController();
  final TextEditingController posturaController = TextEditingController();
  final TextEditingController n1Controller = TextEditingController();
  final TextEditingController n2Controller = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController semanaController = TextEditingController();
  final TextEditingController diaController = TextEditingController();
  final TextEditingController avesMortasController = TextEditingController();
  final TextEditingController previstoPercentualController = TextEditingController();
  final TextEditingController previstoAvesController = TextEditingController();
  final TextEditingController realAvesController = TextEditingController();
  final TextEditingController previstoOvosPercentualController = TextEditingController();
  final TextEditingController previstoQtdeOvosController = TextEditingController();
  final TextEditingController realOvosController = TextEditingController();
  final TextEditingController realOvosPercentualController = TextEditingController();
  final TextEditingController previstoRacaoController = TextEditingController();
  final TextEditingController realRacaoController = TextEditingController();

  Future<void> enviarDados() async {
    final url = Uri.parse('https://rnndd9xtrg.execute-api.us-east-1.amazonaws.com/dev/inserir_dados');

    // Cria um mapa com os dados do formulário
    final Map<String, dynamic> dados = {
      'Granja': granjaController.text,
      'Genética': geneticaController.text,
      'Data Nasc.': dataNascimentoController.text,
      'Lote': loteController.text,
      'Quant. Inicial Aves': quantInicialAvesController.text,
      'Galpão Cria': galpaoCriaController.text,
      'Galpão Recria': galpaoRecriaController.text,
      'Galpão Postura': galpaoPosturaController.text,
      'Cria/Recria': criaRecriaController.text,
      'Postura': posturaController.text,
      'N1': n1Controller.text,
      'N2': n2Controller.text,
      'Data': dataController.text,
      'Semana': semanaController.text,
      'Dia': diaController.text,
      'Aves Mortas': avesMortasController.text,
      'Previsto %': previstoPercentualController.text,
      'Previsto Aves': previstoAvesController.text,
      'Real Aves': realAvesController.text,
      'Previsto % Ovos': previstoOvosPercentualController.text,
      'Previsto Qtde Ovos': previstoQtdeOvosController.text,
      'Real Ovos': realOvosController.text,
      'Real % Ovos': realOvosPercentualController.text,
      'Previsto Ração': previstoRacaoController.text,
      'Real Ração': realRacaoController.text,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': widget.token, // Adiciona o token aos cabeçalhos
      },
      body: jsonEncode(dados),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados enviados com sucesso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar os dados: ${response.body}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: Text('Inserir Dados'),
    backgroundColor: Colors.red,
  ),
  backgroundColor: Colors.white, // Adiciona esta linha para definir o fundo branco
  body: SingleChildScrollView(
    padding: EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informações Gerais'),
          _buildTextField(granjaController, 'Granja'),
          _buildTextField(geneticaController, 'Genética'),
          _buildTextField(dataNascimentoController, 'Data de Nascimento'),
          _buildTextField(loteController, 'Lote'),
          _buildTextField(quantInicialAvesController, 'Quantidade Inicial de Aves'),
          SizedBox(height: 20),
          _buildSectionTitle('Galpões'),
          _buildTextField(galpaoCriaController, 'Galpão Cria'),
          _buildTextField(galpaoRecriaController, 'Galpão Recria'),
          _buildTextField(galpaoPosturaController, 'Galpão Postura'),
          SizedBox(height: 20),
          _buildSectionTitle('Estágios de Criação'),
          _buildTextField(criaRecriaController, 'Cria/Recria'),
          _buildTextField(posturaController, 'Postura'),
          _buildTextField(n1Controller, 'N1'),
          _buildTextField(n2Controller, 'N2'),
          SizedBox(height: 20),
          _buildSectionTitle('Tabela de Dados'),
          _buildTextField(dataController, 'Data'),
          _buildTextField(semanaController, 'Semana'),
          _buildTextField(diaController, 'Dia'),
          _buildTextField(avesMortasController, 'Aves Mortas'),
          _buildTextField(previstoPercentualController, 'Previsto %'),
          _buildTextField(previstoAvesController, 'Previsto Aves'),
          _buildTextField(realAvesController, 'Real Aves'),
          _buildTextField(previstoOvosPercentualController, 'Previsto % Ovos'),
          _buildTextField(previstoQtdeOvosController, 'Previsto Qtde Ovos'),
          _buildTextField(realOvosController, 'Real Ovos'),
          _buildTextField(realOvosPercentualController, 'Real % Ovos'),
          _buildTextField(previstoRacaoController, 'Previsto Ração'),
          _buildTextField(realRacaoController, 'Real Ração'),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _isLoading ? null : () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  enviarDados();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(250, 50), // Aumentando o comprimento do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Enviar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    ),
  ),
);

  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}
