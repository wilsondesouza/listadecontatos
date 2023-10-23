import 'package:flutter/material.dart';
import 'package:listadecontatos/pages/registrar_page_contatos.dart';
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
            Contatos contato = contatoData.registros[index];
            return Container(
              decoration: const BoxDecoration(color: Colors.black87),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: contato.imagem != null ? MemoryImage(contato.imagem!, scale: 22.0) : null,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    title: Text(
                      'Nome: ${contato.nome}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      'Sobrenome: ${contato.sobrenome}\nTelefone: ${contato.telefone}',
                      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      contatoData.removerContato(index);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarPageContatos()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
