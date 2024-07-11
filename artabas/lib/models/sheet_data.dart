class SheetData {
  String id;
  String sheet;
  String granja;
  String genetica;
  String dataNasc;
  String lote;
  int quantInicialAves;
  String galpaoCria;
  String galpaoRecria;
  String galpaoPostura;
  double criaRecria;
  double postura;
  int n1;
  int n2;
  List<TabelaData> tabela;

  SheetData({
    required this.id,
    required this.sheet,
    required this.granja,
    required this.genetica,
    required this.dataNasc,
    required this.lote,
    required this.quantInicialAves,
    required this.galpaoCria,
    required this.galpaoRecria,
    required this.galpaoPostura,
    required this.criaRecria,
    required this.postura,
    required this.n1,
    required this.n2,
    required this.tabela,
  });

  factory SheetData.fromJson(Map<String, dynamic> json) {
    var oid;
    return SheetData(
      id: json['_id']['$oid'],
      sheet: json['Sheet'],
      granja: json['Data']['Granja'],
      genetica: json['Data']['Genética'],
      dataNasc: json['Data']['Data Nasc.'],
      lote: json['Data']['Lote'],
      quantInicialAves: json['Data']['Quant. Inicial Aves'],
      galpaoCria: json['Data']['Galpão Cria'],
      galpaoRecria: json['Data']['Galpão Recria'],
      galpaoPostura: json['Data']['Galpão Postura'],
      criaRecria: json['Data']['Cria/Recria'],
      postura: json['Data']['Postura'],
      n1: json['Data']['N1'],
      n2: json['Data']['N2'],
      tabela: (json['Data']['Tabela'] as List)
          .map((item) => TabelaData.fromJson(item))
          .toList(),
    );
  }
}

class TabelaData {
  String data;
  int semana;
  String dia;
  int avesMortas;
  double previstoPercent;
  double previstoAves;
  int realAves;
  double previstoPercentOvos;
  double previstoQtdeOvos;
  String realOvos;
  String realPercentOvos;
  int previstoRacao;
  int realRacao;

  TabelaData({
    required this.data,
    required this.semana,
    required this.dia,
    required this.avesMortas,
    required this.previstoPercent,
    required this.previstoAves,
    required this.realAves,
    required this.previstoPercentOvos,
    required this.previstoQtdeOvos,
    required this.realOvos,
    required this.realPercentOvos,
    required this.previstoRacao,
    required this.realRacao,
  });

  factory TabelaData.fromJson(Map<String, dynamic> json) {
    return TabelaData(
      data: json['Data'],
      semana: json['Semana'],
      dia: json['Dia'],
      avesMortas: json['Aves Mortas'],
      previstoPercent: json['Previsto %'],
      previstoAves: json['Previsto Aves'],
      realAves: json['Real Aves'],
      previstoPercentOvos: json['Previsto % Ovos'],
      previstoQtdeOvos: json['Previsto Qtde Ovos'],
      realOvos: json['Real Ovos'],
      realPercentOvos: json['Real % Ovos'],
      previstoRacao: json['Previsto Ração'],
      realRacao: json['Real Ração'],
    );
  }
}
