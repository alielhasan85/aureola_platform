import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/lang_providers.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguageCode = ref.watch(languageProvider);

    // Map language labels to their respective language codes
    final languageMap = {
      'English': 'en',
      'Arabic': 'ar',
      'French': 'fr',
      'Turkish': 'tr'
    };

    // Reverse map to display the selected language label in the dropdown
    final currentLanguageLabel = languageMap.keys.firstWhere(
      (key) => languageMap[key] == currentLanguageCode,
      orElse: () => 'English', // Default to English if no match
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: AppTheme.white,
          toolbarHeight: 73,
          title: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Handle notification action
              },
            ),
            // Language Dropdown
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentLanguageLabel,
                icon: const Icon(Icons.language),
                items: languageMap.keys.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newLanguage) {
                  if (newLanguage != null) {
                    ref.read(languageProvider.notifier).state =
                        languageMap[newLanguage]!;
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Handle profile action
              },
            ),
          ],
        ),
        const Divider(
          height: 2,
          thickness: 0,
          color: AppTheme.divider,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
