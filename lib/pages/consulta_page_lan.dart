import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repository/registrar_repository.dart';

class ConsultaPageContatos extends StatefulWidget {
  const ConsultaPageContatos({super.key, Key? chave});

  @override
  State<ConsultaPageContatos> createState() => _ConsultaPageContatosState();
}

class _ConsultaPageContatosState extends State<ConsultaPageContatos> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var posicaoPaginar = scrollController.position.maxScrollExtent * 0.7;
      if (posicaoPaginar < scrollController.position.pixels) {
        carregarContatos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var contatoData = Provider.of<ContatoData>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 29, 29),
        body: ListView.builder(
          controller: scrollController,
          itemCount: contatoData.registros.length,
          itemBuilder: (context, index) {
            Contatos lan = contatoData.registros[index];
            return Container(
              decoration: const BoxDecoration(color: Colors.black87),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                title: Text(
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    'Nome: ${lan.nome}'),
                textColor: Colors.white,
                subtitle: Text(style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 17), 'Rede: ${lan.rede}\nEndereço MAC: ${lan.mac}'),
                trailing: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    contatoData.removerContato(index);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
