import 'dart:typed_data';
import 'package:aureola_platform/images/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerWidget {
  static Future<Uint8List?> pickAndCropImage(
    BuildContext context, {
    required CropAspectRatio aspectRatio,
  }) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
      return null;
    }

    PlatformFile file = result.files.first;
    if (file.size > 15 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image size exceeds 15 MB limit.')),
      );
      return null;
    }

    final croppedImage = await showDialog<Uint8List?>(
      context: context,
      builder: (ctx) => CropperDialogLocal(
        imageData: file.bytes!,
        aspectRatio: aspectRatio,
      ),
    );

    return croppedImage;
  }
}
