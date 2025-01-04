import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/widgest/language_config.dart';

/// A widget that shows multiple text fields (each with a TextEditingController)
/// for [availableLanguages], and provides a "Translate" button to fill missing
/// fields from a chosen source language.
class MultilangFieldDialogContent extends ConsumerStatefulWidget {
  /// Example:
  ///   initialValues = {'en': 'Breakfast', 'ar': ''}
  ///   availableLanguages might be ["en","ar","fr","tr"]
  ///
  /// onSave returns the final map [String -> text] for all languages
  /// after the user presses "Save".
  final Map<String, String> initialValues;
  final List<String> availableLanguages;
  final ValueChanged<Map<String, String>> onSave;
  final VoidCallback onCancel;

  const MultilangFieldDialogContent({
    super.key,
    required this.initialValues,
    required this.availableLanguages,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<MultilangFieldDialogContent> createState() =>
      _MultilangFieldDialogContentState();
}

class _MultilangFieldDialogContentState
    extends ConsumerState<MultilangFieldDialogContent> {
  final _formKey = GlobalKey<FormState>();

  /// A `TextEditingController` for each language in [availableLanguages].
  late final Map<String, TextEditingController> _controllers;

  /// Replace with your actual Google Cloud Translation API key
  final String apiKey = 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA';

  bool isTranslating = false;
  String translationError = '';

  @override
  void initState() {
    super.initState();

    // Build a controller for each language code, setting initial text
    _controllers = {};
    for (final lang in widget.availableLanguages) {
      _controllers[lang] = TextEditingController(
        text: widget.initialValues[lang] ?? '',
      );
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.read(draftVenueProvider);
    final defaultLang = venue?.additionalInfo['defaultLanguage'] ?? 'en';

    // Reorder so that defaultLang is first, if present
    final reorderedLangs =
        _reorderLanguages(widget.availableLanguages, defaultLang);
//TODO: to fix the issue of overflex whgen running on mobile app
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Title row with "Translate" button ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.translate("Translations_"),
                style: AppThemeLocal.appBarTitle,
              ),
              ElevatedButton.icon(
                style: AppThemeLocal.addButtonStyle,
                onPressed: _autoTranslateFields,
                icon: Icon(Icons.translate,
                    color: AppThemeLocal.addButtonStyle.foregroundColor
                        ?.resolve({})),
                label: Text(
                  AppLocalizations.of(context)!.translate("Translate_"),
                  style: AppThemeLocal.appBarTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Multilingual Fields (one per language) ---
          for (final langCode in reorderedLangs) ...[
            Text(codeToName(langCode), style: AppThemeLocal.paragraph),
            const SizedBox(height: 8),
            TextFormField(
              controller: _controllers[langCode],
              decoration: AppThemeLocal.textFieldinputDecoration().copyWith(
                hintText: 'Enter text in ${codeToName(langCode)}',
                border: const OutlineInputBorder(),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter text in ${codeToName(langCode)}';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          // Display an error if there's a translation issue
          if (translationError.isNotEmpty) ...[
            Text(
              translationError,
              style: AppThemeLocal.paragraph.copyWith(color: AppThemeLocal.red),
            ),
            const SizedBox(height: 8),
          ],

          // Show a simple spinner if translating
          if (isTranslating) ...[
            const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Translating...'),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // --- Actions row (Cancel, Save) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _onSavePressed,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Reorder so [defaultLang] is first in the list, if it's present
  List<String> _reorderLanguages(List<String> langs, String defaultLang) {
    if (!langs.contains(defaultLang)) return langs;
    return [
      defaultLang,
      ...langs.where((lang) => lang != defaultLang),
    ];
  }

  /// When user taps "Save", we gather text from each controller into a map
  /// and pass it to `widget.onSave`.
  void _onSavePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      // Build the final map from controllers
      final updatedMap = <String, String>{};
      for (final lang in widget.availableLanguages) {
        updatedMap[lang] = _controllers[lang]!.text;
      }
      widget.onSave(updatedMap);
    }
  }

  /// Attempt to translate from some source language into all other missing fields
  Future<void> _autoTranslateFields() async {
    setState(() {
      isTranslating = true;
      translationError = '';
    });

    try {
      final venue = ref.read(draftVenueProvider);
      final defaultLang = venue?.additionalInfo['defaultLanguage'] ?? 'en';

      // 1) figure out a "sourceLang" that actually has text
      final sourceLang = _findSourceLanguage(defaultLang);
      final sourceText = _controllers[sourceLang]!.text.trim();

      // 2) Fill only missing fields
      for (final langCode in widget.availableLanguages) {
        if (langCode == sourceLang) continue;

        final currentVal = _controllers[langCode]!.text.trim();
        if (currentVal.isEmpty) {
          final translated =
              await translateText(sourceText, sourceLang, langCode);
          setState(() {
            _controllers[langCode]!.text = translated;
          });
        }
      }
    } catch (e) {
      setState(() {
        translationError = 'Translation failed: $e';
      });
    } finally {
      setState(() => isTranslating = false);
    }
  }

  /// If the default language has text, use that. Otherwise,
  /// pick the first language in `availableLanguages` that has text.
  /// If none has text, throw an error.
  String _findSourceLanguage(String defaultLang) {
    // 1) If defaultLang is in the list and has text, use it
    if (widget.availableLanguages.contains(defaultLang)) {
      final text = _controllers[defaultLang]!.text.trim();
      if (text.isNotEmpty) return defaultLang;
    }

    // 2) Otherwise, find the first language with text
    for (final lang in widget.availableLanguages) {
      final text = _controllers[lang]!.text.trim();
      if (text.isNotEmpty) return lang;
    }

    throw Exception('No valid source language found (all fields are empty).');
  }

  /// Example function calling Google Cloud Translate
  Future<String> translateText(
      String text, String sourceLang, String targetLang) async {
    if (apiKey.isEmpty) {
      throw Exception('Translation API key is missing.');
    }

    final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'source': sourceLang,
        'target': targetLang,
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final translatedText = data['data']['translations'][0]['translatedText'];
      return translatedText;
    } else {
      throw Exception('API call failed: ${response.body}');
    }
  }
}
