import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/lang_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popover/popover.dart';
import 'package:aureola_platform/theme/theme.dart';
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

    // Display the selected language code (e.g., EN, AR)
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
          title: Text(
            title,
            style: AppTheme.heading1,
          ),
          actions: [
            // Language Selection Button with Popover
            TextButton(
              onPressed: () {
                showPopover(
                  context: context,
                  bodyBuilder: (BuildContext context) => ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: languageMap.keys.map((String language) {
                      return ListTile(
                        title: Text(
                          language,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2E4857),
                          ),
                        ),
                        onTap: () {
                          // Update language based on selection
                          ref.read(languageProvider.notifier).state =
                              languageMap[language]!;
                          Navigator.pop(context); // Close popover
                        },
                      );
                    }).toList(),
                  ),
                  onPop: () {}, // Optional callback when popover is closed
                  direction: PopoverDirection.bottom,
                  width: 150,
                  height:
                      languageMap.length * 48.0, // Adjust height dynamically
                  arrowHeight: 10,
                  arrowWidth: 15,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // Remove padding
                minimumSize: const Size(40, 40), // Set a minimum size if needed
              ),
              child: Row(
                children: [
                  Text(
                    currentLanguageLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E4857),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF2E4857),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Notification Icon Button
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle notification action
              },
            ),

            // Profile Icon Button
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                // Handle profile action
              },
            ),
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
