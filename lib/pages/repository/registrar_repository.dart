import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contatos {
  final String nome;
  final String rede;
  final String mac;

  Contatos({
    required this.nome,
    required this.rede,
    required this.mac,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'rede': rede,
      'MAC': mac,
    };
  }

  factory Contatos.fromJson(Map<String, dynamic> json) {
    return Contatos(
      nome: json['nome'],
      rede: json['rede'],
      mac: json['MAC'],
    );
  }
}

Future<void> salvarContatos(List<Contatos> lan) async {
  final prefs = await SharedPreferences.getInstance();
  final lanJson = lan.map((lan) => jsonEncode(lan.toJson())).toList();
  await prefs.setStringList('contato', lanJson);
}

Future<List<Contatos>> carregarContatos() async {
  final prefs = await SharedPreferences.getInstance();
  final contatoJson = prefs.getStringList('contato');
  if (contatoJson == null) {
    return [];
  }
  return contatoJson.map((contatosJson) => Contatos.fromJson(jsonDecode(contatosJson))).toList();
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
