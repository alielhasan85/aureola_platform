import 'dart:typed_data';
import 'dart:html' as html; // For web URL creation
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CropperDialogLocal extends StatefulWidget {
  final Uint8List imageData;
  final CropAspectRatio aspectRatio; // Pass the desired aspect ratio

  const CropperDialogLocal({
    Key? key,
    required this.imageData,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  _CropperDialogLocalState createState() => _CropperDialogLocalState();
}

class _CropperDialogLocalState extends State<CropperDialogLocal> {
  bool _isCropping = false;
  CroppedFile? _croppedFile;
  String? _tempUrl;

  @override
  void initState() {
    super.initState();
    _initCropper();
  }

  Future<void> _initCropper() async {
    _tempUrl = await _createTemporaryUrl(widget.imageData);
    await _openCropper();
  }

  Future<void> _openCropper() async {
    // Since 'aspectRatioPresets' isn't supported on web, we use 'aspectRatio' directly.
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _tempUrl!,
      aspectRatio: widget.aspectRatio,
      uiSettings: [
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          viewwMode: WebViewMode.mode_1,
          dragMode: WebDragMode.move,
          background: false,
          guides: true,
        )
      ],
    );
    setState(() {
      _croppedFile = croppedFile;
    });
  }

  Future<String> _createTemporaryUrl(Uint8List imageData) async {
    final blob = html.Blob([imageData]);
    return html.Url.createObjectUrlFromBlob(blob);
  }

  Future<void> _uploadCroppedImage() async {
    if (_croppedFile == null) return;
    setState(() {
      _isCropping = true;
    });

    final croppedBytes = await _croppedFile!.readAsBytes();
    final optimizedBytes = await _optimizeImage(croppedBytes);

    Navigator.of(context).pop(optimizedBytes);
  }

  Future<Uint8List> _optimizeImage(Uint8List imageData) async {
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

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_croppedFile == null) {
      content = const Center(child: CircularProgressIndicator());
    } else {
      content = FutureBuilder<Uint8List>(
        future: _croppedFile!.readAsBytes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.contain,
          );
        },
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Crop Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(child: content),
            const SizedBox(height: 16),
            if (!_isCropping)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _uploadCroppedImage,
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
