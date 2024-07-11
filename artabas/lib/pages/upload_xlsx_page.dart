import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XLSX Upload Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      Uint8List bytes = file.bytes!;
      var excel = Excel.decodeBytes(bytes);

      // Enviar dados de cada aba sequencialmente
      for (var sheetName in excel.tables.keys) {
        var table = excel.tables[sheetName]!;
        var jsonData = {
          "Granja": _getCellValue(table, 0, 1),
          "Genética": _getCellValue(table, 1, 1),
          "Data Nasc.": _formatDate(_getCellValue(table, 2, 1)),
          "Lote": _getCellValue(table, 3, 1),
          "Quant. Inicial Aves": _getCellValue(table, 0, 6),
          "Galpão Cria": _getCellValue(table, 1, 6),
          "Galpão Recria": _getCellValue(table, 2, 6),
          "Galpão Postura": _getCellValue(table, 3, 6),
          "Cria/Recria": _getCellValue(table, 0, 12),
          "Postura": _getCellValue(table, 1, 12),
          "N1": _getCellValue(table, 0, 13),
          "N2": _getCellValue(table, 1, 13),
        };

        List<Map<String, dynamic>> tabelaDados = [];
        for (int i = 6; i < table.maxRows!; i++) {
          var row = table.row(i);
          if (row.isNotEmpty) {
            tabelaDados.add({
              "Data": _formatDate(_getCellValue(table, i, 0)),
              "Semana": _getCellValue(table, i, 1),
              "Dia": _getCellValue(table, i, 2),
              "Aves Mortas": _getCellValue(table, i, 3),
              "Previsto %": _getCellValue(table, i, 4),
              "Previsto Aves": _getCellValue(table, i, 5),
              "Real Aves": _getCellValue(table, i, 6),
              "Previsto % Ovos": _getCellValue(table, i, 7),
              "Previsto Qtde Ovos": _getCellValue(table, i, 8),
              "Real Ovos": _getCellValue(table, i, 9),
              "Real % Ovos": _getCellValue(table, i, 10),
              "Previsto Ração": _getCellValue(table, i, 11),
              "Real Ração": _getCellValue(table, i, 12),
            });
          }
        }
        // Converter a lista de mapas em uma string JSON
        jsonData["Tabela"] = jsonEncode(tabelaDados);

        // Enviar dados para a API
        await _sendDataToAPI(context, jsonData);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleção de arquivo cancelada')),
      );
    }
  }

  String _getCellValue(Sheet table, int row, int col) {
    var cell = table.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
    if (cell != null && cell.value != null) {
      if (cell.value is DateTime) {
        return (cell.value as DateTime).toIso8601String(); // Formato ISO 8601 para datas
      }
      return cell.value.toString();
    }
    return '';
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    DateTime? date = DateTime.tryParse(dateStr);
    if (date != null) {
      return date.toIso8601String(); // Formato ISO 8601 para datas
    }
    return dateStr; // Retorna a string original se não for uma data válida
  }

  Future<void> _sendDataToAPI(BuildContext context, Map<String, dynamic> data) async {
    try {
      // URL da sua API
      const String apiUrl = 'http://127.0.0.1:5000/saveData';

      // Fazendo a requisição POST
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      // Verificar o status da resposta
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados enviados com sucesso para a API')),
        );
        print('Dados enviados com sucesso: ${response.body}');
        // Aqui você pode lidar com a resposta da API conforme necessário
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao enviar os dados para a API')),
        );
        print('Falha ao enviar os dados. Status: ${response.statusCode}');
        // Aqui você pode lidar com erros de envio para a API
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro durante o envio dos dados: $e')),
      );
      print('Erro durante o envio dos dados: $e');
      // Lidar com exceções, se houver, durante o envio
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload XLSX')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickFile(context),
          child: const Text('Selecionar Arquivo XLSX'),
        ),
      ),
    );
  }
}
