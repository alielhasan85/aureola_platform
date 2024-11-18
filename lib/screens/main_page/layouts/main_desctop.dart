import 'package:aureola_platform/providers/appbar_title_provider.dart';
import 'package:aureola_platform/providers/navigation_provider.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_rail.dart';
import 'package:aureola_platform/screens/venue_management/menu_branding.dart';
import 'package:aureola_platform/screens/venue_management/venue_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_app_bar.dart';

class DesktopLayout extends ConsumerWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedMenuIndexProvider);
    final appBarTitle = ref.watch(appBarTitleProvider);

    // Display content based on selected index
    Widget _getContentForTab(int index) {
      switch (index) {
        // case of venue selection and changes
        // case 0:
        //   return Center(child: Text('Venue Dashboard'));
        //case of dashboard
        case 1:
          return Center(child: Text('Dashboard'));

        // case or order management
        case 2:
          return Center(child: Text('Order Management'));

// case or menu managemnt (change from )
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

        case 8: // Venue Management section
          return Center(child: Text('feedback'));
        case 9:
          return VenueInfo();
        case 10:
          return Center(child: Text('tables'));
        case 11:
          return Center(child: Text('Qr code'));

        // Additional cases for other tabs
        default:
          return Center(child: Text('Default Content'));
      }
    }

    return Scaffold(
      body: Row(
        children: [
          const CustomNavigation(),
          Expanded(
            child: Column(
              children: [
                CustomAppBar(title: appBarTitle),
                Expanded(
                  child: _getContentForTab(selectedIndex),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
