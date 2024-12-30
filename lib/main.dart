// lib/main.dart
import 'package:aureola_platform/app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

// Entry point of the application
void main() async {
  // Ensure Flutter is initializedfirebase
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load any additional assets or localization data
  await loadLocalizationAssets();
  runApp(const ProviderScope(child: MyApp()));
}

// Helper function to load localization assets
Future<void> loadLocalizationAssets() async {
  try {
    await rootBundle.loadString('assets/lang/en.json');
  } catch (e) {
    // Handle error or log it
    print('Error loading localization assets: $e');
  }
}
