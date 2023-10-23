import 'package:flutter/material.dart';
import 'contatos.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Lista de Contatos', style: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic, color: Colors.greenAccent)),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 128),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 31, 29, 29),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContatosPage()));
                },
                child: const Text(
                  'Iniciar Calculadora IMC',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
