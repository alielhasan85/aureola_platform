// lib/models/venue/design_and_display.dart

import 'package:aureola_platform/images/aspect_ratio.dart';

class DesignAndDisplay {
  final String logoUrl;
  final AspectRatioOption logoAspectRatio;
  final String backgroundUrl;
  final AspectRatioOption backgroundAspectRatio;
  final String backgroundColor;
  final String cardBackground;
  final String accentColor;
  final String textColor;

  const DesignAndDisplay({
    this.logoUrl = '',
    this.logoAspectRatio =
        AspectRatioOption.square, // Default aspect ratio for logo
    this.backgroundUrl = '',
    this.backgroundAspectRatio =
        AspectRatioOption.widescreen, // Default aspect ratio for background
    this.backgroundColor = '#FFFFFF',
    this.cardBackground = '#FFFFFF',
    this.accentColor = '#0000FF',
    this.textColor = '#000000',
  });

  DesignAndDisplay copyWith({
    String? logoUrl,
    AspectRatioOption? logoAspectRatio,
    String? backgroundUrl,
    AspectRatioOption? backgroundAspectRatio,
    String? backgroundColor,
    String? cardBackground,
    String? accentColor,
    String? textColor,
  }) {
    return DesignAndDisplay(
      logoUrl: logoUrl ?? this.logoUrl,
      logoAspectRatio: logoAspectRatio ?? this.logoAspectRatio,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      backgroundAspectRatio:
          backgroundAspectRatio ?? this.backgroundAspectRatio,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardBackground: cardBackground ?? this.cardBackground,
      accentColor: accentColor ?? this.accentColor,
      textColor: textColor ?? this.textColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'logoUrl': logoUrl,
      'logoAspectRatio': logoAspectRatio.toString().split('.').last,
      'backgroundUrl': backgroundUrl,
      'backgroundAspectRatio': backgroundAspectRatio.toString().split('.').last,
      'backgroundColor': backgroundColor,
      'cardBackground': cardBackground,
      'accentColor': accentColor,
      'textColor': textColor,
    };
  }

  factory DesignAndDisplay.fromMap(Map<String, dynamic> map) {
    return DesignAndDisplay(
      logoUrl: map['logoUrl'] ?? '',
      logoAspectRatio: AspectRatioOption.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            (map['logoAspectRatio'] ?? 'square'),
        orElse: () => AspectRatioOption.square,
      ),
      backgroundUrl: map['backgroundUrl'] ?? '',
      backgroundAspectRatio: AspectRatioOption.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            (map['backgroundAspectRatio'] ?? 'widescreen'),
        orElse: () => AspectRatioOption.widescreen,
      ),
      backgroundColor: map['backgroundColor'] ?? '#FFFFFF',
      cardBackground: map['cardBackground'] ?? '#FFFFFF',
      accentColor: map['accentColor'] ?? '#0000FF',
      textColor: map['textColor'] ?? '#000000',
    );
  }

  @override
  String toString() {
    return 'DesignAndDisplay(logoUrl: $logoUrl, logoAspectRatio: ${logoAspectRatio.label}, backgroundUrl: $backgroundUrl, backgroundAspectRatio: ${backgroundAspectRatio.label}, backgroundColor: $backgroundColor, cardBackground: $cardBackground, accentColor: $accentColor, textColor: $textColor)';
  }
}
