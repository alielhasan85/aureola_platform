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
          cropBoxResizable: true,
          presentStyle: WebPresentStyle.dialog,
          background: true,
          context: context,
          dragMode: WebDragMode.move,
          guides: true,
          viewwMode: WebViewMode.mode_1,
          customDialogBuilder: (cropper, initCropper, crop, rotate, scale) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final dialogWidth =
                    (constraints.maxWidth * 0.9).clamp(300.0, 800.0);
                final dialogHeight =
                    (constraints.maxHeight * 0.9).clamp(400.0, 600.0);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Initialize the cropper after the UI is laid out
                  initCropper();
                });

                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: dialogWidth,
                    height: dialogHeight,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Crop Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Use Expanded with AspectRatio directly
                        Expanded(
                          child: AspectRatio(
                            aspectRatio:
                                aspectRatio.ratioX / aspectRatio.ratioY,
                            child: ClipRect(
                              child: cropper,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.rotate_left),
                              onPressed: () {
                                rotate(RotationAngle.clockwise270);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.rotate_right),
                              onPressed: () {
                                rotate(RotationAngle.clockwise90);
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final croppedFilePath = await crop();
                                Navigator.of(context).pop(croppedFilePath);
                              },
                              child: const Text('Save'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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
