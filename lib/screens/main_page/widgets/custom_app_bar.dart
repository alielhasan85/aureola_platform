import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/lang_providers.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguageCode = ref.watch(languageProvider);

    // Map language codes to display labels
    final languageMap = {
      'English': 'en',
      'Arabic': 'ar',
      'French': 'fr',
      'Turkish': 'tr'
    };

    // Display the selected language label (e.g., English, Arabic)
    final currentLanguageLabel = languageMap.keys.firstWhere(
      (key) => languageMap[key] == currentLanguageCode,
      orElse: () => 'English', // Default to English if no match
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: AppTheme.white,
          toolbarHeight: 60,
          title: Text(
            title,
            style: AppTheme.heading1,
          ),
          actions: [
            // Language Selection Button with PopupMenuButton
            PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              onSelected: (String language) {
                // Update language based on selection
                ref.watch(languageProvider.notifier).state =
                    languageMap[language]!;
              },
              itemBuilder: (BuildContext context) {
                return languageMap.keys.map((String language) {
                  return PopupMenuItem<String>(
                    value: language,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      language,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primary,
                      ),
                    ),
                  );
                }).toList();
              },
              child: Row(
                children: [
                  Text(
                    currentLanguageLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Notification Icon Button
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: AppTheme.primary,
              ),
              onPressed: () {
                // Handle notification action
              },
            ),
            const SizedBox(width: 12),
            // Profile Icon Button
            IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: AppTheme.primary,
              ),
              onPressed: () {
                // Handle profile action
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        const Divider(
          height: 0,
          thickness: 0.5,
          color: AppTheme.divider,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
