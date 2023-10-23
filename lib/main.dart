import 'package:flutter/material.dart';
import 'package:listadecontatos/pages/repository/registrar_repository.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final contato = await carregarContatos();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContatoData(contato)),
      ],
      child: const MyApp(),
    ),
  );
}
