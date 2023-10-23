import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'repository/registrar_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class RegistrarPageContatos extends StatefulWidget {
  const RegistrarPageContatos({super.key, Key? chave});

  @override
  State<RegistrarPageContatos> createState() => _RegistrarPageContatosState();
}

class _RegistrarPageContatosState extends State<RegistrarPageContatos> {
  XFile? photo;
  cropImage(XFile file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: const Color.fromARGB(255, 31, 29, 29), toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController redeController = TextEditingController();
    final TextEditingController macController = TextEditingController();

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
                            },
                          )
                        ]);
                      });
                },
                icon: const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 70.0),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome', labelStyle: TextStyle(color: Colors.greenAccent), border: OutlineInputBorder(), filled: true, fillColor: Colors.black87),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: redeController,
                decoration: const InputDecoration(labelText: 'Rede', labelStyle: TextStyle(color: Colors.greenAccent), border: OutlineInputBorder(), filled: true, fillColor: Colors.black87),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: macController,
                decoration: const InputDecoration(labelText: 'Endereço MAC', labelStyle: TextStyle(color: Colors.greenAccent), border: OutlineInputBorder(), filled: true, fillColor: Colors.black87),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  String nome = nomeController.text;
                  String rede = redeController.text;
                  String mac = macController.text;

                  if (nome.isEmpty || rede.isEmpty || mac.isEmpty) {
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
                    Contatos lan = Contatos(
                      nome: nome,
                      rede: rede,
                      mac: mac,
                    );

                    contatoData.adicionarContato(lan);

                    nomeController.clear();
                    redeController.clear();
                    macController.clear();
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
