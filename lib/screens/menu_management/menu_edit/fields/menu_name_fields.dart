import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/widgest/multilang_dialog.dart';

/// A widget for editing `menuName` (a Map<String, String>) in multiple languages.
///
/// [menuName] might look like:
///   { 'en': 'Breakfast Menu', 'ar': 'قائمة الإفطار' }
/// [onMenuNameChanged] is called whenever the map is updated.
class MenuNameFields extends ConsumerWidget {
  final Map<String, String> menuName;
  final ValueChanged<Map<String, String>> onMenuNameChanged;
  final String? Function(String?)? validator;

  const MenuNameFields({
    Key? key,
    required this.menuName,
    required this.onMenuNameChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) The app's current UI language code: e.g. 'en'
    final currentAppLang = ref.watch(languageProvider);

    // 2) The current venue to retrieve languageOptions
    final venue = ref.watch(draftVenueProvider);

    // If venue is null or has no languageOptions, fallback to just [currentAppLang]
    final availableLangs = venue?.languageOptions ?? [currentAppLang];

    // 3) The text for the *current* language
    //    If there's no entry for the current language, default to ''
    final currentText = menuName[currentAppLang] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("menu_name"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            // Expanded TextFormField for the *current* language
            Expanded(
              child: TextFormField(
                initialValue: currentText,
                style: AppThemeLocal.paragraph,
                cursorColor: AppThemeLocal.accent,
                validator: validator,
                onChanged: (val) {
                  // Update only the current language in the map
                  final updatedMap = Map<String, String>.from(menuName);
                  updatedMap[currentAppLang] = val;
                  onMenuNameChanged(updatedMap);
                },
                decoration: AppThemeLocal.textFieldinputDecoration(
                  hint: AppLocalizations.of(context)!
                      .translate("Menu_Name_($currentAppLang)"),
                ),
              ),
            ),

            // Icon to open the multi-lang dialog
            IconButton(
              icon: const Icon(Icons.language, color: Colors.blue),
              tooltip: 'Edit in other languages',
              onPressed: () {
                if (availableLangs.isEmpty) {
                  // If we have no known language options, do nothing or show an alert
                  return;
                }

                showDialog(
                  context: context,
                  builder: (_) => MultilangFieldDialog(
                    initialValues: menuName,
                    availableLanguages: availableLangs,
                    title: 'Edit Menu Name',
                    onSave: (updatedNames) {
                      // The user saved from the multi-lang dialog
                      onMenuNameChanged(updatedNames);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
