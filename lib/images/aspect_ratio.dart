// lib/models/venue/aspect_ratio.dart

import 'package:image_cropper/image_cropper.dart';

enum AspectRatioOption {
  square, // 1:1
  standard, // 4:3
  classic, // 3:2
  widescreen, // 16:9
  vertical, // 9:16
  panoramic, // 2:1
  nearlySquare, // 5:4
}

extension AspectRatioExtension on AspectRatioOption {
  String get label {
    switch (this) {
      case AspectRatioOption.square:
        return '1:1 (Square)';
      case AspectRatioOption.standard:
        return '4:3 (Standard)';
      case AspectRatioOption.classic:
        return '3:2 (Classic)';
      case AspectRatioOption.widescreen:
        return '16:9 (Widescreen)';
      case AspectRatioOption.vertical:
        return '9:16 (Vertical)';
      case AspectRatioOption.panoramic:
        return '2:1 (Panoramic)';
      case AspectRatioOption.nearlySquare:
        return '5:4 (Nearly Square)';
    }
  }

  double get widthRatio {
    switch (this) {
      case AspectRatioOption.square:
        return 1.0;
      case AspectRatioOption.standard:
        return 4.0;
      case AspectRatioOption.classic:
        return 3.0;
      case AspectRatioOption.widescreen:
        return 16.0;
      case AspectRatioOption.vertical:
        return 9.0;
      case AspectRatioOption.panoramic:
        return 2.0;
      case AspectRatioOption.nearlySquare:
        return 5.0;
    }
  }

  double get heightRatio {
    switch (this) {
      case AspectRatioOption.square:
        return 1.0;
      case AspectRatioOption.standard:
        return 3.0;
      case AspectRatioOption.classic:
        return 2.0;
      case AspectRatioOption.widescreen:
        return 9.0;
      case AspectRatioOption.vertical:
        return 16.0;
      case AspectRatioOption.panoramic:
        return 1.0;
      case AspectRatioOption.nearlySquare:
        return 4.0;
    }
  }

  CropAspectRatio toCropAspectRatio() {
    return CropAspectRatio(
      ratioX: widthRatio,
      ratioY: heightRatio,
    );
  }
}
