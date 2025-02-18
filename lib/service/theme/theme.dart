// xai-9AbgG5HP2TBgospTyMnxcAXKhFtQTowJcfhPiw3k6O1vrod0KVVP3J3c0LhtbJmAmoU3Fi4VSylDNQel
//X-Api-Key: xai-9AbgG5HP2TBgospTyMnxcAXKhFtQTowJcfhPiw3k6O1vrod0KVVP3J3c0LhtbJmAmoU3Fi4VSylDNQel
//google_api_key: AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA

import 'package:flutter/material.dart';

class Breakpoints {
  static const double desktop = 1024;
  static const double tablet = 768;
  static const double mobile = 480;
}

class AppThemeLocal {
  // ===========================
  // Color Palette
  // ===========================

  // Primary Colors
  static const Color primary = Color(0xFF2E4857);
  static const Color secondary = Color(0xFF4E6776);
  static const Color accent = Color(0xFFFF5E1E);
  static Color accent2 = accent.withAlpha((0.5 * 255).toInt());

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFDAD5CF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color grey2 = Color(0xFFE0E0E0);
  static const Color greyButton = Color(0xFFF0F2F5);
  static const Color background = Color(0xFFF0F2F5);
  static const Color background2 = Color(0xFFFFF9F6);

  // Feedback Colors
  static const Color red = Color(0xFFD31B27);
  static const Color green = Color(0xFF39C57F);
  static const Color blue = Color(0xFF007AFF);

  // Accent Colors
  static const Color lightGreen = Color(0xFFd3f1a7);
  static const Color lightPeach = Color(0xFFFEC195);

  // ===========================
  // Text Styles
  // ===========================


/// Google API Key
  static const String googleApiKey = "AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA";


  
  static const TextStyle titleAureola = TextStyle(
    fontFamily: 'CinzelDecorative',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    // letterSpacing: 0.4,
    color: primary,
  );

  static const TextStyle titlePlatform = TextStyle(
    fontFamily: 'comme',
    fontWeight:
        FontWeight.normal, // You can adjust the font weight or style here
    fontSize: 22, // Same font size to keep consistency
    // letterSpacing: 0.4,
    color: accent, // Apply a different color or style
  );

  static const TextStyle appBarTitle = TextStyle(
    color: primary,
    fontSize: 20,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,


    // fontWeight: FontWeight.,
  );

static const TextStyle headingCard = TextStyle(
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
    color: primary,
    fontSize: 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  

  static const TextStyle dropdownItemText = TextStyle(
    color: primary,
    fontSize: 16,
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
    fontWeight: FontWeight.normal,
  );

  // ===========================
  // Base Button Style
  // ===========================

  /// Base button style that other styles can inherit from.
  static ButtonStyle baseButtonStyle({
    Color backgroundColor = AppThemeLocal.accent,
    Color foregroundColor = AppThemeLocal.white,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    double borderRadius = 8.0,
    double elevation = 2.0,
    BorderSide? side,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
      foregroundColor: WidgetStateProperty.all<Color>(foregroundColor),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding),
      elevation: WidgetStateProperty.all<double>(elevation),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: side ?? BorderSide.none,
        ),
      ),
      // Optionally, you can add other properties like overlayColor, shadowColor, etc.
    );
  }

  // ===========================
  // Specific Button Styles
  // ===========================

  /// Preview Button Style
  static final ButtonStyle previewButtonStyle = baseButtonStyle(
    backgroundColor: AppThemeLocal.background2, // Very light background
    foregroundColor: AppThemeLocal.primary, // Primary color text
    elevation: 1.0, // Material Design elevation 1
    borderRadius: 8.0, // Default border radius
    side: const BorderSide(
      color: AppThemeLocal.primary, // Primary color border
      width: 1.0, // Border width
    ),
  );

  /// Add New Translation Button Style
  static final ButtonStyle addButtonStyle = baseButtonStyle(
    backgroundColor: AppThemeLocal.red, // Light green background
    foregroundColor: AppThemeLocal.white, // Primary color text
    elevation: 4.0, // Material Design elevation 1
    borderRadius: 100.0, // Circular border radius as per Figma design
    side: BorderSide.none,
    // (
    //   color: Color, // Primary color border
    //   width: 1.0, // Border width
    // ),
  );

  /// Save Button Style
  static final ButtonStyle saveButtonStyle = baseButtonStyle(
    backgroundColor: AppThemeLocal.accent, // Orange color
    foregroundColor: AppThemeLocal.white, // White text
    elevation: 1.0, // Material Design elevation 1
    borderRadius: 8.0, // Default border radius
  );

  /// Cancel Button Style
  static final ButtonStyle cancelButtonStyle = baseButtonStyle(
    backgroundColor: AppThemeLocal.greyButton, // Light grey background
    foregroundColor: AppThemeLocal.primary, // Primary color text
    elevation: 1.0, // Material Design elevation 1
    borderRadius: 8.0, // Default border radius
  );

  // ===========================
  // Input Decoration
  // ===========================

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
          label != null ? AppThemeLocal.paragraph.copyWith(fontSize: 16, color: primary) : null,

      hintStyle:
          hint != null ? AppThemeLocal.paragraph.copyWith(fontSize: 12, color: secondary) : null,

      // Define the default border
      border: const OutlineInputBorder(),

      // Define the enabled border
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppThemeLocal.grey2,
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),

      // Define the focused border
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppThemeLocal.accent,
          width: 0.75, // Updated to match the revised decoration
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
  




/// Define a global InputDecorationTheme for consistency
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    labelStyle: paragraph.copyWith(fontSize: 16, color: primary),
    hintStyle: paragraph.copyWith(fontSize: 12, color: secondary),
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: grey2,
        width: 0.75,
      ),
      borderRadius: BorderRadius.circular(6.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: accent,
        width: 0.75,
      ),
      borderRadius: BorderRadius.circular(6.0),
    ),
  );


  // ===========================
  // Card Decoration
  // ===========================

  static ShapeDecoration get cardDecoration {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
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

  static ShapeDecoration get cardDecorationMob {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
  // ===========================
  // Color Scheme
  // ===========================

  static const ColorScheme colorScheme = ColorScheme(
    primary: primary,
    onPrimary: background,
    primaryContainer: accent,
    onPrimaryContainer: white, 
    
    secondary: background,
    onSecondary: secondary,
    secondaryContainer: lightPeach, 
    surface: white,
    error: red,
    onSurface: primary,
    onError: white,
    brightness: Brightness.light,
  );
}
