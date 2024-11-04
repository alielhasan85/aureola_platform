import 'package:flutter/material.dart';

class AppTheme {
  // Colors extracted from the image

  static const Color primary = Color(0xFF2E4857);
  static const Color secondary = Color(0xFF4E6776);
  static const Color accent = Color(0xFFFF5E1E);

  static const Color white = Color(0xFFFFFFFF);

  static const Color divider = Color(0xFFDAD5CF);
  static const Color grey2 = Color(0xFFE0E0E0);
  static const Color greyButton = Color(0xFFF0F2F5);
  static const Color background = Color(0xFFF0F2F5);
  static const Color background2 = Color(0xFFFFF4EE);

  static const Color red = Color(0xFFD31B27);
  static const Color green = Color(0xFF39C57F);
  static const Color blue = Color(0xFF007AFF);

  static const Color lightGreen = Color(0xFFd3f1a7);
  static const Color lightPeach = Color(0xFFFEC195);

  static const TextStyle titleAureola = TextStyle(
    fontFamily: 'CinzelDecorative',
    fontWeight: FontWeight.bold,
    fontSize: 28,
    letterSpacing: 0.4,
    height: 0.9,
    color: primary,
  );

  static const TextStyle titlePlatform = TextStyle(
    fontFamily: 'comme',
    fontWeight:
        FontWeight.normal, // You can adjust the font weight or style here
    fontSize: 26, // Same font size to keep consistency
    letterSpacing: 0.4,
    height: 0.8,
    color: accent, // Apply a different color or style
  );

  static const TextStyle heading2 = TextStyle(
    color: red,
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    height: 0,
  );

  static const TextStyle navigationItemText = TextStyle(
    color: secondary,
    fontSize: 15,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 0,
  );
}
