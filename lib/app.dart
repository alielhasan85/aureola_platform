import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/providers/lang_providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Watch the current language from Riverpod provider
    final currentLanguage =
        ref.watch(languageProvider); // Holds 'en', 'ar', 'fr', or 'tr'

    // Determine if the current language is RTL
    final bool isRtl = currentLanguage == 'ar';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aureola Platform',

      // ===========================
      // Localization Configuration
      // ===========================
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
        Locale('tr', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // Your custom localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(currentLanguage),

      // ===========================
      // Theming Configuration
      // ===========================
      theme: ThemeData(
        useMaterial3: true,
        // Apply the ColorScheme from AppTheme
        //colorScheme: AppTheme.colorScheme,

        // Apply the ColorScheme from AppTheme
        colorScheme: AppTheme.colorScheme,

        // Apply the TextTheme from AppTheme
        textTheme: const TextTheme(
          displayLarge: AppTheme.titleAureola,
          displayMedium: AppTheme.titlePlatform,
          displaySmall: AppTheme.heading1,
          headlineLarge: AppTheme.heading2,
          headlineMedium: AppTheme.navigationItemText,
          headlineSmall: AppTheme.tabItemText,
          bodyLarge: AppTheme.paragraph,
          bodyMedium: AppTheme.buttonText,
          // Add more mappings if necessary
        ),

        // Define the default font family
        fontFamily: 'Inter', // Ensure this matches your desired default font

        // ElevatedButton Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent, // Background color
            foregroundColor: AppTheme.buttonText.color, // Text color
            textStyle: AppTheme.buttonText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),

        // AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.primary,
          titleTextStyle: AppTheme.titleAureola.copyWith(
            color: AppTheme.white,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: AppTheme.white,
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.greyButton,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: AppTheme.grey2,
              width: 0.75,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: AppTheme.grey2,
              width: 0.75,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: AppTheme.accent,
              width: 0.75,
            ),
          ),
          labelStyle: AppTheme.paragraph.copyWith(fontSize: 20),
          hintStyle: AppTheme.paragraph.copyWith(fontSize: 14),
        ),

        // BottomNavigationBar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppTheme.white,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.grey2,
          selectedLabelStyle: AppTheme.navigationItemText,
          unselectedLabelStyle: AppTheme.navigationItemText,
        ),

        // Additional theme customizations can be added here
      ),

      // ===========================
      // Localization and Directionality
      // ===========================
      builder: (context, child) {
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },

      // Define the home screen based on your app's flow
      home: const LoginPage(), // Replace with your desired initial screen
    );
  }
}
