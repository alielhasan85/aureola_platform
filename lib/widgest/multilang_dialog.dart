// lib/widgets/multilang_dialog.dart (or wherever you keep it)

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

/// A generic dialog to edit a Map<String, String> for multiple languages.
/// e.g. initialValues = {'en': 'Breakfast', 'ar': 'الإفطار'}
/// availableLanguages might be ["en","ar","fr","tr"]
/// onSave callback returns the updated map after user hits Save.
class MultilangFieldDialog extends StatefulWidget {
  final Map<String, String> initialValues;
  final List<String> availableLanguages;
  final String title;
  final ValueChanged<Map<String, String>> onSave;

  const MultilangFieldDialog({
    Key? key,
    required this.initialValues,
    required this.availableLanguages,
    required this.title,
    required this.onSave,
  }) : super(key: key);

  @override
  _MultilangFieldDialogState createState() => _MultilangFieldDialogState();
}

class _MultilangFieldDialogState extends State<MultilangFieldDialog> {
  late Map<String, String> _localValues;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Copy the initial map into local state
    _localValues = Map<String, String>.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.availableLanguages.map((langCode) {
              final existingText = _localValues[langCode] ?? '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label for the language
                    Text(
                      'Language: $langCode',
                      style: AppThemeLocal.paragraph.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // TextFormField for that language's text
                    TextFormField(
                      initialValue: existingText,
                      onChanged: (val) {
                        setState(() {
                          _localValues[langCode] = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter text for "$langCode"',
                        border: const OutlineInputBorder(),
                        suffixIcon: _buildTranslateIcon(langCode),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.translate('Cancel') ?? 'Cancel',
          ),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text(
            AppLocalizations.of(context)!.translate('Save') ?? 'Save',
          ),
        ),
      ],
    );
  }

  Widget? _buildTranslateIcon(String targetLang) {
    // Optionally skip showing an icon if targetLang is "en" or if you only
    // want to auto-translate from e.g. "en" => others.
    return IconButton(
      tooltip: 'Translate from default language',
      icon: const Icon(Icons.translate),
      onPressed: () async {
        await _translateFieldValue(targetLang);
      },
    );
  }

  Future<void> _translateFieldValue(String targetLang) async {
    // 1) Identify your default language code in the map
    //    For example, if "en" is always your default. Or it might be languageOptions[0].
    //    We'll assume "en" is default for demonstration.
    const defaultLang = 'en';

    final sourceText = _localValues[defaultLang] ?? '';
    if (sourceText.isEmpty) {
      // No text to translate from
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No text in default language to translate from.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2) Make a call to your translator service
    //    We'll use a mock function for now
    final translated = await _mockTranslateApi(
      sourceText,
      sourceLang: defaultLang,
      targetLang: targetLang,
    );

    // 3) Update local value
    setState(() {
      _localValues[targetLang] = translated;
    });
  }

  // Mock translator function simulating an API call to Google Cloud Translate
  // or a library like `translator`.
  Future<String> _mockTranslateApi(
    String text, {
    required String sourceLang,
    required String targetLang,
  }) async {
    // Normally you'd do a real HTTP call here
    // For now, we just append "[translated]" for demonstration
    await Future.delayed(const Duration(milliseconds: 500));
    return '$text [auto-$targetLang]';
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_localValues);
      Navigator.of(context).pop();
    }
  }
}
