import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2E4857);
  static const Color secondary = Color(0xFF4E6776);
  static const Color accent = Color(0xFFFF5E1E);

  static const Color white = Color(0xFFFFFFFF);

  static const Color divider = Color(0xFFDAD5CF);
  static const Color grey2 = Color(0xFFE0E0E0);
  static const Color greyButton = Color(0xFFF0F2F5);
  static const Color background = Color(0xFFF9F9F9);
  static const Color background2 = Color(0xFFFFF9F6);

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
    color: primary,
  );

  static const TextStyle titlePlatform = TextStyle(
    fontFamily: 'comme',
    fontWeight:
        FontWeight.normal, // You can adjust the font weight or style here
    fontSize: 26, // Same font size to keep consistency
    letterSpacing: 0.4,

    color: accent, // Apply a different color or style
  );

  static const TextStyle heading1 = TextStyle(
    color: primary,
    fontSize: 18,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle heading2 = TextStyle(
    color: red,
    fontSize: 22,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle navigationItemText = TextStyle(
    color: secondary,
    fontSize: 15,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tabItemText = TextStyle(
    color: secondary,
    fontSize: 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle tabBarItemText = TextStyle(
    color: primary,
    fontSize: 18,
    fontFamily: 'DM Sans',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.10,
  );

  static const TextStyle paragraph = TextStyle(
    color: primary,
    fontSize: 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  static InputDecoration textFieldinputDecoration({
    String? label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool alwaysFloatLabel = false,
  }) {
    return InputDecoration(
      // Optionally include a prefix icon
      prefixIcon: prefixIcon,

      // Optionally include a suffix icon
      suffixIcon: suffixIcon,

      // Handle floating label behavior based on parameter
      floatingLabelBehavior: alwaysFloatLabel
          ? FloatingLabelBehavior.always
          : FloatingLabelBehavior.auto,

      // Optionally include label text
      labelText: label,

      // Optionally include hint text
      hintText: hint,

      // Apply styles conditionally
      labelStyle:
          label != null ? AppTheme.paragraph.copyWith(fontSize: 20) : null,

      hintStyle:
          hint != null ? AppTheme.paragraph.copyWith(fontSize: 14) : null,

      // Define the default border
      border: const OutlineInputBorder(),

      // Define the enabled border
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppTheme.grey2,
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),

      // Define the focused border
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppTheme.accent,
          width: 0.75, // Updated to match the revised decoration
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }

  static ShapeDecoration get cardDecoration {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x4C000000),
          blurRadius: 2,
          offset: Offset(0, 1),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 6,
          offset: Offset(0, 2),
          spreadRadius: 2,
        ),
      ],
    );
  }
}