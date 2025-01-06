// lib/screens/main_page/widgets/language_selector.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/widgest/language_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The user-friendly name for each code
    // We also localize them if needed:
    // But typically "English","Arabic" can be in the JSON.
    final languageMap = {
      for (final code in kSupportedLanguageCodes)
        code: AppLocalizations.of(context)!.translate(codeToName(code)),
    };

    return PopupMenuButton<String>(
      tooltip: AppLocalizations.of(context)!.translate('select_language'),
      onSelected: (String languageCode) {
        // This updates the global language provider
        ref.read(languageProvider.notifier).state = languageCode;
        // Then your MaterialApp might respond by changing the Locale
      },
      itemBuilder: (BuildContext context) {
        return languageMap.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key, // the code, e.g. "en"
            child: Row(
              children: [
                // Optional: add flags by code
                // Image.asset('assets/flags/${entry.key}.png', width: 24),
                const SizedBox(width: 8),
                Text(
                  entry.value,
                  style: AppThemeLocal.dropdownItemText,
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Row(
        children: const [
          Icon(
            Icons.language,
            color: AppThemeLocal.primary,
          ),
          Icon(
            Icons.arrow_drop_down,
            color: AppThemeLocal.primary,
          ),
        ],
      ),
    );
  }
}
