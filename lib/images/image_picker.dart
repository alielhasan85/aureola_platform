import 'dart:typed_data';
import 'dart:html' as html; // For web usage
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickerWidget {
  static Future<Uint8List?> pickAndCropImage(
    BuildContext context, {
    required CropAspectRatio aspectRatio,
  }) async {
    // Pick the file
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

    final bytes = file.bytes!;
    final tempUrl = _createTemporaryUrl(bytes);

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: tempUrl,
      aspectRatio: aspectRatio,
      uiSettings: [
        WebUiSettings(
          presentStyle: WebPresentStyle.dialog,
          background: true,
          context: context,
          dragMode: WebDragMode.move,
          guides: true,
          viewwMode: WebViewMode.mode_1,
        ),
        // Add other platform settings if needed (but on web only these apply)
      ],
    );

    if (croppedFile == null) {
      // User cancelled cropping
      return null;
    }

    // Read and optimize the image
    final croppedBytes = await croppedFile.readAsBytes();
    final optimizedBytes = await _optimizeImage(croppedBytes);

    return optimizedBytes;
  }

  static String _createTemporaryUrl(Uint8List imageData) {
    final blob = html.Blob([imageData]);
    return html.Url.createObjectUrlFromBlob(blob);
  }

  static Future<Uint8List> _optimizeImage(Uint8List imageData) async {
    int originalSize = imageData.length;
    int quality = 97;
    int minWidth = 1920;
    int minHeight = 1080;

    if (originalSize > 10 * 1024 * 1024) {
      quality = 60;
    } else if (originalSize > 5 * 1024 * 1024) {
      quality = 70;
    }

    final result = await FlutterImageCompress.compressWithList(
      imageData,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
    );

    return result;
  }
}
