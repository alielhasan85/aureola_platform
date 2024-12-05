import 'package:aureola_platform/providers/appbar_title_provider.dart';
import 'package:aureola_platform/providers/navigation_provider.dart';

import 'package:aureola_platform/screens/user_management.dart/widgets_user/navigation_rail_user.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/billing.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/cards.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/notification.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/plan.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profile_tab.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedMenuIndexProvider);
    final appBarTitle = ref.watch(appBarTitleProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTabletOrDesktop = constraints.maxWidth >= 800;

        // Ensure Scaffold is returned
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(0.5), // Height of the divider
              child: Divider(
                height: 0,
                thickness: 0.5,
                color: AppTheme.divider,
              ),
            ),
            iconTheme: const IconThemeData(color: AppTheme.primary),
            backgroundColor: AppTheme.white,
            title: Text(
              appBarTitle,
              style: AppTheme.appBarTitle,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          drawer: !isTabletOrDesktop
              ? Drawer(
                  child: NavigationRailUser(isDrawer: true),
                )
              : null,
          body: Row(
            children: [
              if (isTabletOrDesktop) NavigationRailUser(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSectionContent(selectedIndex),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTitle(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.translate('profile_');
      case 1:
        return AppLocalizations.of(context)!.translate('billing_');
      case 2:
        return AppLocalizations.of(context)!.translate('plan_');
      case 3:
        return AppLocalizations.of(context)!.translate('notifications_setting');
      case 4:
        return AppLocalizations.of(context)!.translate('cards_');
      default:
        return AppLocalizations.of(context)!.translate('profile_');
    }
  }

  Widget _buildSectionContent(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return ProfileTab(); // Your existing ProfileTab widget
      case 1:
        return BillingTab(); // Your existing BillingTab widget
      case 2:
        return PlanTab(); // Your existing PlanTab widget
      case 3:
        return NotificationsSettingTab(); // Your existing NotificationsSettingTab widget
      case 4:
        return CardsTab(); // Your existing CardsTab widget
      default:
        return ProfileTab();
    }
  }
}
