import 'package:flutter/material.dart';
import 'package:listadecontatos/pages/consulta_page_contatos.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      title: "Contatos",
      color: const Color.fromARGB(255, 31, 29, 29),
      home: const ConsultaPageContatos(),
      initialRoute: '/',
    );
  }
}
