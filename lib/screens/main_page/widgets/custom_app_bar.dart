// lib/screens/main_page/widgets/custom_app_bar.dart

// lib/screens/main_page/widgets/custom_app_bar.dart

import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/user_management/user_mainpage.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/billing.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/plan.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/cards.dart';

import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/widgest/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/service/localization/localization.dart';

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
    // Determine screen size
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 700;

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
              _handleMenuSelection(context, option);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<AppBarMenuOption>(
                value: AppBarMenuOption.profile,
                child: Text(AppLocalizations.of(context)!.translate('profile')),
              ),
              PopupMenuItem<AppBarMenuOption>(
                value: AppBarMenuOption.billing,
                child: Text(AppLocalizations.of(context)!.translate('billing')),
              ),
              PopupMenuItem<AppBarMenuOption>(
                value: AppBarMenuOption.logout,
                child: Text(AppLocalizations.of(context)!.translate('log_out')),
              ),
              // Add other options as needed
            ],
          )
        else ...[
          // Language Selection Widget
          const LanguageSelector(),
          const SizedBox(width: 16),

          // Notification Icon Button
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: AppTheme.primary,
            ),
            onPressed: () {
              // Navigate to Notifications Page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Scaffold(
                          body: Center(child: Text('notifications')),
                        )),
              );
            },
            tooltip: AppLocalizations.of(context)!.translate('notifications'),
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
                    AppLocalizations.of(context)!.translate(
                      option.label.toLowerCase().replaceAll(' ', '_'),
                    ),
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
      case AppBarMenuOption.cards:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CardsTab(),
          ),
        );
        break;
      case AppBarMenuOption.notifications:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const Scaffold(body: Center(child: Text('nitifications'))),
          ),
        );
        break;
      case AppBarMenuOption.teams:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const Scaffold(body: Center(child: Text('teams'))),
          ),
        );
        break;
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
