// lib/screens/menu_management/menu_edit/fields/menu_name_fields.dart

import 'package:aureola_platform/screens/menu_management/menu_edit/fields/multilang_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class MenuNameFields extends ConsumerWidget {
  final Map<String, String> menuName; // e.g. {'en': 'Breakfast', 'ar': '...'}
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
    // 1) The app's current UI language code
    final currentAppLang = ref.watch(languageProvider);

    // 2) The current venue to retrieve languageOptions
    final venue = ref.watch(draftVenueProvider);

    // 3) The text for the current UI language
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
            // Expanded text field for the current language
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
                if (venue == null) return; // Just to be safe

                // We assume venue.languageOptions is something like ['en','ar','fr']
                final availableLangs = venue.languageOptions;

                showDialog(
                  context: context,
                  builder: (_) => MultilangFieldDialog(
                    initialValues: menuName,
                    availableLanguages: availableLangs,
                    title: 'Edit Menu Name',
                    onSave: (updatedNames) {
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
