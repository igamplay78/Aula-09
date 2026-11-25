class Endereco {
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;

  const Endereco({
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'logradouro': String rua,
        'bairro': String bairro,
        'localidade': String cidade,
        'uf': String estado,
      } =>
        Endereco(rua: rua, bairro: bairro, cidade: cidade, estado: estado),
      _ => throw const FormatException('Falha no carregamento...'),
    };
  }
}
