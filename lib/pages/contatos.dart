import 'package:flutter/material.dart';
import 'package:listadecontatos/pages/consulta_page_lan.dart';
import 'package:listadecontatos/pages/registrar_page_contatos.dart';

class ContatosPage extends StatefulWidget {
  const ContatosPage({super.key, Key? chave});

  @override
  State<ContatosPage> createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  int indexPage = 0;
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      indexPage = value;
                    });
                  },
                  children: const [
                    ConsultaPageContatos(),
                    RegistrarPageContatos(),
                  ],
                ),
              ),
              BottomNavigationBar(
                  backgroundColor: const Color.fromARGB(255, 31, 29, 29),
                  selectedItemColor: Colors.greenAccent,
                  unselectedItemColor: Colors.white,
                  onTap: (value) {
                    pageController.jumpToPage(value);
                  },
                  currentIndex: indexPage,
                  items: const [
                    BottomNavigationBarItem(label: "Consultar Contatos", icon: Icon(Icons.add)),
                    BottomNavigationBarItem(label: "Registrar Contatos", icon: Icon(Icons.find_in_page)),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
