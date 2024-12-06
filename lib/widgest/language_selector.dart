// lib/screens/main_page/widgets/language_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/providers/lang_providers.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the current language code from the provider
    final currentLanguageCode = ref.watch(languageProvider);

    // Map language codes to display labels (localized)
    final languageMap = {
      'en': AppLocalizations.of(context)!.translate('English'),
      'ar': AppLocalizations.of(context)!.translate('Arabic'),
      'fr': AppLocalizations.of(context)!.translate('French'),
      'tr': AppLocalizations.of(context)!.translate('Turkish'),
    };

    // Get the current language label
    final currentLanguageLabel = languageMap[currentLanguageCode] ?? 'English';

    return PopupMenuButton<String>(
      // Removed 'icon' to prevent the assertion error
      tooltip: AppLocalizations.of(context)!.translate('select_language'),
      onSelected: (String languageCode) {
        // Update the language provider state
        ref.read(languageProvider.notifier).state = languageCode;
        // Optionally, trigger locale change in your localization setup
        // This depends on how you've implemented localization
      },
      itemBuilder: (BuildContext context) {
        return languageMap.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                // Optionally, include language flags/icons here
                // Example:
                // Image.asset('assets/flags/${entry.key}.png', width: 24),
                const SizedBox(width: 8),
                Text(
                  entry.value,
                  style: AppTheme.tabBarItemText,
                ),
              ],
            ),
          );
        }).toList();
      },
      child: const Row(
        children: [
          Icon(
            Icons.language,
            color: AppTheme.primary,
          ),
          // const SizedBox(width: 4),
          // Text(
          //   currentLanguageLabel,
          //   style: const TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //     color: AppTheme.primary,
          //   ),
          // ),
          const Icon(
            Icons.arrow_drop_down,
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}
