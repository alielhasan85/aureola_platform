import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Example imports for your app:
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/widgest/language_config.dart';

/// A standard Dialog that shows multiple text fields for each language,
/// plus optional Google Translate support. On "Save," it returns
/// a Map<String,String> with the updated text for each language.
///
/// Usage:
///   final result = await showDialog<Map<String,String>>(
///     context: context,
///     builder: (_) => MultiLangDialog(
///       initialValues: {'en': 'Hello', 'ar': ''},
///       availableLanguages: ['en','ar','fr'],
///       label: 'Menu Name',
///       googleApiKey: 'YOUR_API_KEY', // Or empty if you don't want auto-translate
///     ),
///   );
///   if (result != null) {
///     // user pressed "Save" => result is the updated map
///   } else {
///     // user canceled
///   }
class MultiLangDialog extends ConsumerStatefulWidget {
  final Map<String, String> initialValues;
  final List<String> availableLanguages;

  /// A short descriptor of what is being translated. E.g. "Menu Name"
  final String? label;

  /// Optionally provide a default language code. This is used as
  /// the "first" field in the dialog and also the main source for auto-translate
  /// if it has text.
  final String? defaultLang;

  /// If empty, the "Translate" button is hidden or disabled.
  final String googleApiKey;

  const MultiLangDialog({
    super.key,
    required this.initialValues,
    required this.availableLanguages,
    this.defaultLang,
    this.googleApiKey = '',
    this.label = '',
  });

  @override
  ConsumerState<MultiLangDialog> createState() => _MultiLangDialogState();
}

class _MultiLangDialogState extends ConsumerState<MultiLangDialog> {
  final _formKey = GlobalKey<FormState>();

  /// One TextEditingController per language
  late final Map<String, TextEditingController> _controllers;

  bool _isTranslating = false;
  String _translationError = '';

  @override
  void initState() {
    super.initState();
    // Create a controller for each language, with the initial text if any
    _controllers = {};
    for (final lang in widget.availableLanguages) {
      _controllers[lang] = TextEditingController(
        text: widget.initialValues[lang] ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    // If no defaultLang is provided, fallback to 'en' or the first in the list.
    final effectiveDefaultLang = widget.defaultLang ??
        (widget.availableLanguages.isNotEmpty
            ? widget.availableLanguages.first
            : 'en');

    // Reorder so that defaultLang is at the front
    final reorderedLangs = _reorderLangs(
      widget.availableLanguages,
      effectiveDefaultLang,
    );

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjust height dynamically
              children: [
                // --- Title + Auto-Translate button row ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Title and a subtle explanation
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.translate("Edit_Translations"),
                          style: AppThemeLocal.appBarTitle,
                        ),
                        const SizedBox(height: 6),
                        if (widget.label?.isNotEmpty == true)
                          Text(
                            // e.g. "You are editing translations for: Menu Name"
                            localization
                                .translate("You_are_editing_translations_for")
                                .replaceAll(
                                  '{label}',
                                  localization.translate(widget.label!),
                                ),
                            style: AppThemeLocal.paragraph.copyWith(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: AppThemeLocal.secondary,
                            ),
                          ),
                      ],
                    ),

                    // Right side: Auto-translate button if we have an API key
                    if (widget.googleApiKey.isNotEmpty)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton(
                            heroTag: null, // avoid hero conflicts
                            onPressed: _isTranslating ? null : _autoTranslate,
                            backgroundColor: _isTranslating
                                ? Colors.grey
                                : AppThemeLocal.red,
                            child: const Icon(Icons.translate),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localization.translate("Auto_Translate"),
                            style: AppThemeLocal.paragraph.copyWith(
                              fontSize: 12,
                              color: _isTranslating
                                  ? AppThemeLocal.grey
                                  : AppThemeLocal.primary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // --- Form with language fields ---
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Allow dynamic resizing
                    children: [
                      // Fields for each language
                      for (final langCode in reorderedLangs) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            codeToName(langCode),
                            style: AppThemeLocal.paragraph,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _controllers[langCode],
                          style: AppThemeLocal.paragraph,
                          decoration:
                              AppThemeLocal.textFieldinputDecoration().copyWith(
                            hintText: localization
                                .translate("EnterTextIn")
                                .replaceAll(
                                  '{langName}',
                                  codeToName(langCode),
                                ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Show error message if translation fails
                      if (_translationError.isNotEmpty) ...[
                        Text(
                          _translationError,
                          style: AppThemeLocal.paragraph
                              .copyWith(color: AppThemeLocal.red),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Spinner if translating
                      if (_isTranslating) ...[
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
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // --- Action buttons ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop<Map<String, String>>(context, null),
                      child: Text(localization.translate('cancel')),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: AppThemeLocal.saveButtonStyle,
                      onPressed: _onSave,
                      child: Text(localization.translate('save')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reorders so defaultLang is first in the list
  List<String> _reorderLangs(List<String> langs, String defaultLang) {
    if (!langs.contains(defaultLang)) return langs;
    return [
      defaultLang,
      ...langs.where((lang) => lang != defaultLang),
    ];
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Gather all the text into a final map
      final result = <String, String>{};
      for (final lang in widget.availableLanguages) {
        result[lang] = _controllers[lang]!.text.trim();
      }
      Navigator.pop(context, result);
    }
  }

  Future<void> _autoTranslate() async {
    setState(() {
      _isTranslating = true;
      _translationError = '';
    });

    try {
      // 1) Find a sourceLang that actually has text
      final sourceLang = _findSourceLanguage();
      final sourceText = _controllers[sourceLang]!.text.trim();

      // 2) Translate only empty fields
      for (final targetLang in widget.availableLanguages) {
        if (targetLang == sourceLang) continue;

        final currentVal = _controllers[targetLang]!.text.trim();
        if (currentVal.isEmpty) {
          final translated = await _translateText(
            sourceText,
            sourceLang,
            targetLang,
            widget.googleApiKey,
          );
          setState(() {
            _controllers[targetLang]!.text = translated;
          });
        }
      }
    } catch (e) {
      setState(() {
        _translationError = 'Translation failed: $e';
      });
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  String _findSourceLanguage() {
    // If defaultLang has text, use that
    final defaultLang = widget.defaultLang ?? 'en';
    if (_controllers[defaultLang]?.text.trim().isNotEmpty == true) {
      return defaultLang;
    }
    // Otherwise pick the first that is non-empty
    for (final lang in widget.availableLanguages) {
      if (_controllers[lang]!.text.trim().isNotEmpty) return lang;
    }
    throw Exception('No source language found - all fields are empty.');
  }

  Future<String> _translateText(
    String text,
    String sourceLang,
    String targetLang,
    String apiKey,
  ) async {
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
      throw Exception('API error: ${response.body}');
    }
  }
}
