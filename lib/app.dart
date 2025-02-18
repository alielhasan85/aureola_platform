import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/service/localization/localization.dart';
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
        Locale('es', ''),
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
        colorScheme: AppThemeLocal.colorScheme,

        inputDecorationTheme: AppThemeLocal.inputDecorationTheme,

        // Apply the TextTheme from AppTheme
        textTheme: TextTheme(
          displayLarge: AppThemeLocal.titleAureola,
          displayMedium: AppThemeLocal.titlePlatform,
          displaySmall: AppThemeLocal.appBarTitle,
          headlineLarge: AppThemeLocal.heading2,
          headlineMedium: AppThemeLocal.navigationItemText,
          headlineSmall: AppThemeLocal.navigationItemText,
          bodyLarge: AppThemeLocal.paragraph.copyWith(fontSize: 20),
          bodyMedium: AppThemeLocal.paragraph,
          // Add more mappings if necessary
        ),

        // Define the default font family
        fontFamily: 'Inter', // Ensure this matches your desired default font

        // ElevatedButton Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemeLocal.accent, // Background color
            foregroundColor: AppThemeLocal.buttonText.color, // Text color
            textStyle: AppThemeLocal.buttonText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),

        // AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppThemeLocal.primary,
          titleTextStyle: AppThemeLocal.titleAureola.copyWith(
            color: AppThemeLocal.white,
            fontSize: 20,
          ),
          iconTheme: const IconThemeData(
            color: AppThemeLocal.white,
          ),
        ),

        // // Input Decoration Theme
        // inputDecorationTheme: InputDecorationTheme(
        //   filled: true,
        //   fillColor: AppThemeLocal.greyButton,
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(6.0),
        //     borderSide: const BorderSide(
        //       color: AppThemeLocal.grey2,
        //       width: 0.75,
        //     ),
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(6.0),
        //     borderSide: const BorderSide(
        //       color: AppThemeLocal.grey2,
        //       width: 0.75,
        //     ),
        //   ),
        //   focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(6.0),
        //     borderSide: const BorderSide(
        //       color: AppThemeLocal.accent,
        //       width: 0.75,
        //     ),
        //   ),
        //   labelStyle: AppThemeLocal.paragraph.copyWith(fontSize: 20),
        //   hintStyle: AppThemeLocal.paragraph.copyWith(fontSize: 14),
        // ),

        // BottomNavigationBar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppThemeLocal.white,
          selectedItemColor: AppThemeLocal.primary,
          unselectedItemColor: AppThemeLocal.grey2,
          selectedLabelStyle: AppThemeLocal.navigationItemText,
          unselectedLabelStyle: AppThemeLocal.navigationItemText,
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
