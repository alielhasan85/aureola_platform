import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';
import 'package:aureola_platform/providers/lang_providers.dart';
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
    final currentLanguage = ref
        .watch(languageProvider); // This should hold 'en', 'ar', 'fr', or 'tr'

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aureola Platform',
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
        Locale('tr', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Use the current language code directly for locale
      locale: Locale(currentLanguage),
      builder: (context, child) {
        // Use currentLanguage to determine text direction
        final isRtl = currentLanguage == 'ar';
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: const LoginPage(),
    );
  }
}
