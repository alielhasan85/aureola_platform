import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  // Constructor to initialize AppLocalizations with the provided locale
  AppLocalizations(this.locale);

  // This method allows you to access AppLocalizations in the widget tree using:
  // AppLocalizations.of(context)
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // The delegate that provides localization support
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String>
      _localizedStrings; // This will hold the localized strings after loading

  // Loads the JSON file containing the localized strings
  Future<bool> load() async {
    try {
      // Load the JSON file from the assets/lang directory
      String jsonString = await rootBundle
          .loadString('assets/lang/${locale.languageCode}.json');

      // Decode the JSON file to a Map
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Convert the dynamic map to a Map<String, String>
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true; // Indicate that the loading was successful
    } catch (e) {
      // Handle any errors that occur during file loading
      return false;
    }
  }

  // Translate a key to its localized string
  String translate(String key) {
    // Return the localized string if available; otherwise, return the key itself
    return _localizedStrings[key] ?? key;
  }
}

// Delegate class that helps Flutter load and manage the localizations
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support English and Arabic languages
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Load the localizations for the given locale
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) =>
      false; // No need to reload if delegate is the same
}
