import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/user_management.dart/user_mainpage.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/lang_providers.dart';

// Import your destination screens

// Enum for menu options
enum AppBarMenuOption {
  profile,
  billing,
  plan,
  cards,
  notifications,
  teams,
  logout,
}

extension AppBarMenuOptionExtension on AppBarMenuOption {
  String get label {
    switch (this) {
      case AppBarMenuOption.profile:
        return 'Profile';
      case AppBarMenuOption.billing:
        return 'Billing';
      case AppBarMenuOption.plan:
        return 'Plan';
      case AppBarMenuOption.cards:
        return 'Cards';
      case AppBarMenuOption.notifications:
        return 'Notifications';
      case AppBarMenuOption.teams:
        return 'Teams';
      case AppBarMenuOption.logout:
        return 'Log Out';
    }
  }
}

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
                ref.read(languageProvider.notifier).state =
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
                // Navigate to Notifications Page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const NotificationsPage(),
                //   ),
                // );
              },
            ),
            const SizedBox(width: 12),

            // Profile Dropdown Menu
            PopupMenuButton<AppBarMenuOption>(
              icon: const Icon(
                Icons.account_circle,
                color: AppTheme.primary,
              ),
              onSelected: (AppBarMenuOption option) {
                _handleMenuSelection(context, option);
              },
              itemBuilder: (BuildContext context) {
                return AppBarMenuOption.values.map((AppBarMenuOption option) {
                  return PopupMenuItem<AppBarMenuOption>(
                    value: option,
                    child: Text(
                      option.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primary,
                      ),
                    ),
                  );
                }).toList();
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

  void _handleMenuSelection(BuildContext context, AppBarMenuOption option) {
    switch (option) {
      case AppBarMenuOption.profile:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfilePage(),
          ),
        );
        break;
      case AppBarMenuOption.billing:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const BillingPage(),
        //   ),
        // );
        break;
      case AppBarMenuOption.plan:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const PlanPage(),
        //   ),
        // );
        break;
      case AppBarMenuOption.cards:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const CardsPage(),
        //   ),
        // );
        break;
      case AppBarMenuOption.notifications:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const NotificationsPage(),
        //   ),
        // );
        break;
      case AppBarMenuOption.teams:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const TeamsPage(),
        //   ),
        // );
        break;
      case AppBarMenuOption.logout:
        _handleLogout(context);
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    // Implement your logout logic here
    // For example, clearing user data, tokens, etc.

    // After logout logic, navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(60 + 0.5); // AppBar height + Divider
}
