import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

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
