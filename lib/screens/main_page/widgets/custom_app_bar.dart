// lib/screens/main_page/widgets/custom_app_bar.dart

import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/user_management.dart/user_mainpage.dart';

import 'package:aureola_platform/screens/user_management.dart/widgets_user/billing.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/plan.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/lang_providers.dart';

// TODO: UI of the drop down menu of profile
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
  final Widget? leading;

  const CustomAppBar({super.key, required this.title, this.leading});

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

    // Display the selected language label
    final currentLanguageLabel = languageMap.keys.firstWhere(
      (key) => languageMap[key] == currentLanguageCode,
      orElse: () => 'English', // Default to English if no match
    );

    // Determine screen size
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return AppBar(
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5), // Height of the divider
        child: Divider(
          height: 0,
          thickness: 0.5,
          color: AppTheme.divider,
        ),
      ),
      leading: leading,
      iconTheme: const IconThemeData(color: AppTheme.primary),
      backgroundColor: AppTheme.white,
      toolbarHeight: 60,
      title: Row(
        children: [
          // Include AppLogo if desired
          const SizedBox(width: 8), // Optional spacing
          Expanded(
            child: Text(
              title,
              style: AppTheme.appBarTitle,
              overflow: TextOverflow.ellipsis, // Handle long titles gracefully
            ),
          ),
        ],
      ),
      actions: [
        // On mobile, consolidate actions into a single menu
        if (isMobile)
          PopupMenuButton<AppBarMenuOption>(
            icon: const Icon(
              Icons.more_vert,
              color: AppTheme.primary,
            ),
            onSelected: (AppBarMenuOption option) {
              if (option == AppBarMenuOption.profile) {
                _handleMenuSelection(context, option);
              } else if (option == AppBarMenuOption.logout) {
                _handleLogout(context);
              } else if (option == AppBarMenuOption.notifications) {
                // Handle notifications
              } else if (option == AppBarMenuOption.billing) {
                // Handle billing
              }
              // Add other options as needed
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<AppBarMenuOption>(
                value: AppBarMenuOption.profile,
                child: Text('Profile'),
              ),
              const PopupMenuItem<AppBarMenuOption>(
                value: AppBarMenuOption.billing,
                child: Text('Billing'),
              ),
              const PopupMenuItem<AppBarMenuOption>(
                value: AppBarMenuOption.logout,
                child: Text('Log Out'),
              ),
            ],
          )
        else ...[
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
                    style: AppTheme.tabBarItemText,
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
      ],
    );
  }

  void _handleMenuSelection(BuildContext context, AppBarMenuOption option) {
    switch (option) {
      case AppBarMenuOption.profile:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfilePage(),
          ),
        );
        break;
      case AppBarMenuOption.billing:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BillingTab(),
          ),
        );
        break;
      case AppBarMenuOption.plan:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PlanTab(),
          ),
        );
        break;
      // Handle other cases
      case AppBarMenuOption.logout:
        _handleLogout(context);
        break;
      default:
        // Handle default case
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    // Implement your logout logic here

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
