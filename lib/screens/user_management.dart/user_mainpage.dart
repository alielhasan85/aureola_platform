// lib/screens/user_management.dart/user_profile_page.dart

import 'package:aureola_platform/providers/user_title.dart';
import 'package:aureola_platform/screens/main_page/main_page.dart';

import 'package:aureola_platform/screens/user_management.dart/widgets_user/navigation_rail_user.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/billing.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/cards.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/notification.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/plan.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profile_tab.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/widgest/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/screens/main_page/widgets/custom_app_bar.dart'; // Import CustomAppBar

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(userProfileSelectedMenuIndexProvider);
    final appBarTitle = ref.watch(userProfileAppBarTitleProvider);

    // Content based on selected index
    Widget _getContentForTab(int index) {
      switch (index) {
        case 0:
          return const ProfileTab();
        case 1:
          return const BillingTab();
        case 2:
          return const PlanTab();
        case 3:
          return const NotificationsSettingTab();
        case 4:
          return const CardsTab();
        default:
          return const ProfileTab();
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTabletOrDesktop = constraints.maxWidth >= 800;

        if (isTabletOrDesktop) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            resizeToAvoidBottomInset: false,
            body: Row(
              children: [
                const NavigationRailUser(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 60.5,
                        child: AppBar(
                          bottom: const PreferredSize(
                            preferredSize: Size.fromHeight(0.5),
                            child: Divider(
                              height: 0,
                              thickness: 0.5,
                              color: AppTheme.divider,
                            ),
                          ),
                          iconTheme:
                              const IconThemeData(color: AppTheme.primary),
                          backgroundColor: AppTheme.white,
                          title: Text(
                            appBarTitle,
                            style: AppTheme.appBarTitle,
                          ),
                          actions: [
                            const LanguageSelector(),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _getContentForTab(selectedIndex),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            key: GlobalKey<ScaffoldState>(),
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: appBarTitle,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            drawer: const Drawer(
              child: NavigationRailUser(isDrawer: true),
            ),
            body: _getContentForTab(selectedIndex),
          );
        }
      },
    );
  }
}
