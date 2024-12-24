// lib/screens/main_page/main_page.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_app_bar.dart';
import 'package:aureola_platform/screens/menu_management/menu.dart';
import 'package:aureola_platform/screens/venue_management/branding.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'package:aureola_platform/providers/main_title_provider.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_rail.dart';
import 'package:aureola_platform/screens/venue_management/venue_info.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();

  //   // Initialize the appBar title when the page loads
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(appBarTitleProvider.notifier).state =
  //         "Dashboard"; // Set default title
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setOrientation();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedMenuIndexProvider);
    final appBarTitle = ref.watch(appBarTitleProvider);

    // Content based on selected index
    Widget _getContentForTab(int index) {
      switch (index) {
        case 1:
          return const Center(
              child: Text('Dashboard', style: AppThemeLocal.appBarTitle));
        case 2:
          return const Center(
              child:
                  Text('Order Management', style: AppThemeLocal.appBarTitle));
        case 3:
          return const Menu();
        case 4:
          return const Center(
              child:
                  Text('Categories Content', style: AppThemeLocal.appBarTitle));
        case 5:
          return const Center(
              child: Text('Items Content', style: AppThemeLocal.appBarTitle));
        case 6:
          return const Center(
              child: Text('Add-ons Content', style: AppThemeLocal.appBarTitle));
        case 7:
          return const Center(
              child: Text('flush screen', style: AppThemeLocal.appBarTitle));
        case 8:
          return const Center(
              child: Text('Feedback', style: AppThemeLocal.appBarTitle));

        case 9:
          return const VenueInfo();
        case 10:
          return const MenuBranding();

        case 11:
          return const Center(
              child: Text('social_media', style: AppThemeLocal.appBarTitle));
        case 12:
          return const Center(
              child: Text('prices_option', style: AppThemeLocal.appBarTitle));
        case 13:
          return const Center(
              child:
                  Text('tables_management', style: AppThemeLocal.appBarTitle));
        case 14:
          return const Center(
              child: Text('QR_code', style: AppThemeLocal.appBarTitle));
        default:
          return const Center(
              child: Text('Dashboard', style: AppThemeLocal.appBarTitle));
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          // Desktop/Tablet layout with navigation rail and app bar inside body
          return Scaffold(
            backgroundColor: AppThemeLocal.background,
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            body: Row(
              children: [
                const CustomNavigation(), // Navigation rail
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // Ensure children stretch
                    children: [
                      SizedBox(
                        height:
                            60.5, // Same as CustomAppBar's preferredSize.height
                        child: CustomAppBar(title: appBarTitle),
                      ),
                      Expanded(child: _getContentForTab(selectedIndex)),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Mobile layout with Drawer
          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: appBarTitle,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            drawer: const Drawer(
              child: CustomNavigation(isDrawer: true),
            ),
            body: _getContentForTab(selectedIndex),
          );
        }
      },
    );
  }

  void _setOrientation() {
    // Use portrait for mobile, landscape for larger screens
    if (MediaQuery.of(context).size.width < 700) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    // Reset the orientation when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}
