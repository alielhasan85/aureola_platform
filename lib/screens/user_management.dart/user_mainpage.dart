import 'package:aureola_platform/providers/navigation_provider.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_app_bar.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/navigation_rail_user.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/billing.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/cards.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/notification.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/plan.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profile_tab.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedMenuIndexProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTabletOrDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          appBar: CustomAppBar(
            title: _getTitle(selectedIndex, context),
            // Add leading icon to open the drawer on mobile devices
            leading: !isTabletOrDesktop
                ? IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )
                : null,
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
