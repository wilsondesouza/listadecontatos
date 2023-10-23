import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'repository/registrar_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'services/crop_image.dart';

class RegistrarPageContatos extends StatefulWidget {
  const RegistrarPageContatos({super.key, Key? chave});

  @override
  State<RegistrarPageContatos> createState() => _RegistrarPageContatosState();
}

class _RegistrarPageContatosState extends State<RegistrarPageContatos> {
  XFile? photo;
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController sobrenomeController = TextEditingController();
    final TextEditingController telefoneController = TextEditingController();

    var contatoData = Provider.of<ContatoData>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 29, 29),
        body: Padding(
          padding: const EdgeInsets.all(70.0),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 40.0),
              IconButton(
                iconSize: 100,
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return Wrap(children: [
                          ListTile(
                              leading: const FaIcon(FontAwesomeIcons.camera),
                              title: const Text("Camera"),
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                photo = await picker.pickImage(source: ImageSource.camera);
                                if (photo != null) {
                                  String path = (await path_provider.getApplicationDocumentsDirectory()).path;
                                  String name = basename(photo!.path);
                                  await photo!.saveTo("$path/$name");
                                  await GallerySaver.saveImage(photo!.path);
                                  Navigator.pop(context);
                                  cropImage(photo!);
                                  setState(() {
                                    imageBytes = File(photo!.path).readAsBytesSync();
                                  });
                                }
                              }),
                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.images),
                            title: const Text("Galeria"),
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              photo = await picker.pickImage(source: ImageSource.gallery);
                              Navigator.pop(context);
                              cropImage(photo!);

                              setState(() {
                                imageBytes = File(photo!.path).readAsBytesSync();
                              });
                            },
                          )
                        ]);
                      });
                },
                icon: imageBytes != null
                    ? CircleAvatar(
                        radius: 45,
                        backgroundImage: MemoryImage(imageBytes!, scale: 22.0),
                      )
                    : const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.greenAccent,
                      ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome', labelStyle: TextStyle(color: Colors.greenAccent), border: OutlineInputBorder(), filled: true, fillColor: Colors.black87),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: sobrenomeController,
                decoration: const InputDecoration(labelText: 'Sobrenome', labelStyle: TextStyle(color: Colors.greenAccent), border: OutlineInputBorder(), filled: true, fillColor: Colors.black87),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone', labelStyle: TextStyle(color: Colors.greenAccent), border: OutlineInputBorder(), filled: true, fillColor: Colors.black87),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  String nome = nomeController.text;
                  String sobrenome = sobrenomeController.text;
                  String telefone = telefoneController.text;

                  if (nome.isEmpty || sobrenome.isEmpty || telefone.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Erro'),
                          content: const Text('Preencha todos os campos obrigatórios.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Contatos contato = Contatos(
                      nome: nome,
                      sobrenome: sobrenome,
                      telefone: telefone,
                      imagem: imageBytes,
                    );

                    contatoData.adicionarContato(contato);

                    nomeController.clear();
                    sobrenomeController.clear();
                    telefoneController.clear();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
