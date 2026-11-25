import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'endereco.dart';

Future<Endereco> buscaEndereco(String cep) async {
  final resposta = await http.get(
    Uri.parse('https://viacep.com.br/ws/$cep/json/'),
    headers: {'Accept': 'application/json'},
  );
  if (resposta.statusCode == 200) {
    return Endereco.fromJson(
        jsonDecode(resposta.body) as Map<String, dynamic>);
  } else {
    throw Exception('Falha ao carregar endereço.');
  }
}

void main() {
  runApp(const Janela());
}

class Janela extends StatelessWidget {
  const Janela({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Principal()),
    );
  }
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final controlaCep = TextEditingController();
  Future<Endereco>? enderecoFuturo;

  @override
  void dispose() {
    controlaCep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controlaCep,
            decoration: const InputDecoration(hintText: 'CEP'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              enderecoFuturo = buscaEndereco(controlaCep.text);
            });
          },
          child: const Text('Buscar'),
        ),
        if (enderecoFuturo != null)
          FutureBuilder<Endereco>(
            future: enderecoFuturo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text('Rua: ${snapshot.data!.rua}'),
                    Text('Bairro: ${snapshot.data!.bairro}'),
                    Text('Cidade: ${snapshot.data!.cidade}'),
                    Text('Estado: ${snapshot.data!.estado}'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Text('Carregando...');
            },
          ),
      ],
    );
  }
}
