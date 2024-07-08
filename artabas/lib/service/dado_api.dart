// arquivo: dado_api.dart

class DadoAPI {
  String data;
  double preco;
  String regiaoTipo;
  double variacaoSemana;

  DadoAPI({
    required this.data,
    required this.preco,
    required this.regiaoTipo,
    required this.variacaoSemana,
  });

  factory DadoAPI.fromJson(Map<String, dynamic> json) {
    return DadoAPI(
      data: json['Data'],
      preco: json['Preco (R\$\/30 dz)'],
      regiaoTipo: json['Regiao\/Tipo'],
      variacaoSemana: json['Variacao\/Semana (%)'],
    );
  }
}
