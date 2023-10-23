import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
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
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          TextButton(
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
              child: const Text("Câmera")),
          photo != null
              ? Container(
                  child: Image.file(File(photo!.path)),
                )
              : Container()
        ],
      )),
    );
  }
}
