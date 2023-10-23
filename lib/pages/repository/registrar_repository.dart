import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contatos {
  final String nome;
  final String sobrenome;
  final String telefone;
  final Uint8List? imagem;

  Contatos({required this.nome, required this.sobrenome, required this.telefone, this.imagem});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
      'imagem': imagem != null ? imagem!.toList() : null,
    };
  }

  factory Contatos.fromJson(Map<String, dynamic> json) {
    return Contatos(
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      telefone: json['telefone'],
      imagem: json['imagem'] != null ? Uint8List.fromList(json['imagem']) : null,
    );
  }
}

Future<void> salvarContatos(List<Contatos> lan) async {
  final prefs = await SharedPreferences.getInstance();
  final lanJson = lan.map((lan) {
    Map<String, dynamic> json = lan.toJson();
    if (lan.imagem != null) {
      json['imagem'] = lan.imagem!.toList();
    }
    return jsonEncode(json);
  }).toList();
  await prefs.setStringList('contato', lanJson);
}

Future<List<Contatos>> carregarContatos() async {
  final prefs = await SharedPreferences.getInstance();
  final contatoJson = prefs.getStringList('contato');
  if (contatoJson == null) {
    return [];
  }
  return contatoJson.map((contatosJson) {
    final decoded = jsonDecode(contatosJson);
    return Contatos(
      nome: decoded['nome'],
      sobrenome: decoded['sobrenome'],
      telefone: decoded['telefone'],
      imagem: decoded['imagem'] != null ? Uint8List.fromList(decoded['imagem'].cast<int>()) : null,
    );
  }).toList();
}

class ContatoData extends ChangeNotifier {
  List<Contatos> registros = [];

  ContatoData(List<Contatos> contato) {
    registros = contato;
  }

  void adicionarContato(Contatos contato) {
    registros.add(contato);
    salvarContatos(registros);
    notifyListeners();
  }

  void removerContato(int index) {
    registros.removeAt(index);
    salvarContatos(registros);
    notifyListeners();
  }
}
