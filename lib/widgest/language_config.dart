/// language_config.dart

/// The official list of supported language codes in our app.
const List<String> kSupportedLanguageCodes = ['en', 'ar', 'fr', 'tr', 'es'];

/// Convert ISO code -> user-friendly English name
String codeToName(String code) {
  switch (code) {
    case 'en':
      return 'English';
    case 'ar':
      return 'Arabic';
    case 'fr':
      return 'French';
    case 'tr':
      return 'Turkish';
    case 'es':
      return 'Spanish';
    default:
      return code; // fallback if unknown
  }
}

/// Convert user-friendly English name -> ISO code
String nameToCode(String name) {
  // Lowercase comparison to handle variations like "English" or "english"
  final lower = name.toLowerCase();
  switch (lower) {
    case 'english':
      return 'en';
    case 'arabic':
      return 'ar';
    case 'french':
      return 'fr';
    case 'turkish':
      return 'tr';

    case 'spanish':
      return 'es';
    default:
      return name; // fallback if unknown
  }
}

class LanguageItem {
  final String code; // e.g. "en"
  final String name; // e.g. "English"

  LanguageItem({required this.code, required this.name});

  @override
  String toString() => name;
}
