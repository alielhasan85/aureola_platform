//

import 'package:aureola_platform/screens/main_page/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';

import 'package:aureola_platform/providers/appbar_title_provider.dart';
import 'package:aureola_platform/providers/navigation_provider.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_rail.dart';
import 'package:aureola_platform/screens/venue_management/menu_branding.dart';
import 'package:aureola_platform/screens/venue_management/venue_info.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
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
          return Center(child: Text('Dashboard'));
        case 2:
          return Center(child: Text('Order Management'));
        case 3:
          return Center(child: Text('Menu Content'));
        case 4:
          return Center(child: Text('Categories Content'));
        case 5:
          return Center(child: Text('Items Content'));
        case 6:
          return Center(child: Text('Add-ons Content'));
        case 7:
          return const MenuBranding();
        case 8:
          return Center(child: Text('Feedback'));
        case 9:
          return const VenueInfo();
        case 10:
          return Center(child: Text('Tables'));
        case 11:
          return Center(child: Text('QR Code'));
        default:
          return Center(child: Text('Default Content'));
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Desktop/Tablet layout with navigation rail
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Row(
              children: [
                const CustomNavigation(),
                Expanded(
                  child: Column(
                    children: [
                      CustomAppBar(title: appBarTitle),
                      Expanded(child: _getContentForTab(selectedIndex)),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          //TODO: App bar in case of mobile layout
          // Mobile layout with Drawer
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(appBarTitle),
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
    if (MediaQuery.of(context).size.width < 600) {
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
