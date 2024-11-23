import 'package:aureola_platform/providers/appbar_title_provider.dart';
import 'package:aureola_platform/providers/navigation_provider.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_rail.dart';
import 'package:aureola_platform/screens/venue_management/menu_branding.dart';
// import 'package:aureola_platform/screens/venue_management/venue_info.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../widgets/custom_app_bar.dart';

// class DesktopLayout extends ConsumerWidget {
//   const DesktopLayout({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedIndex = ref.watch(selectedMenuIndexProvider);
//     final appBarTitle = ref.watch(appBarTitleProvider);

//     // Display content based on selected index
//     Widget _getContentForTab(int index) {
//       switch (index) {
//         case 1:
//           return Center(child: Text('Dashboard'));
//         case 2:
//           return Center(child: Text('Order Management'));
//         case 3:
//           return Center(child: Text('Menu Content'));
//         case 4:
//           return Center(child: Text('Categories Content'));
//         case 5:
//           return Center(child: Text('Items Content'));
//         case 6:
//           return Center(child: Text('Add-ons Content'));
//         case 7:
//           return const MenuBranding();
//         case 8:
//           return Center(child: Text('Feedback'));
//         case 9:
//           return VenueInfo();
//         case 10:
//           return Center(child: Text('Tables'));
//         case 11:
//           return Center(child: Text('QR Code'));
//         default:
//           return Center(child: Text('Default Content'));
//       }
//     }

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > 800) {
//           // Desktop layout with navigation rail
//           return Scaffold(
//             body: Row(
//               children: [
//                 const CustomNavigation(),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       CustomAppBar(title: appBarTitle),
//                       Expanded(
//                         child: _getContentForTab(selectedIndex),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           // Mobile layout with Drawer
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(appBarTitle),
//             ),
//             drawer: Drawer(
//               child: CustomNavigation(
//                 isDrawer: true,
//               ),
//             ),
//             body: _getContentForTab(selectedIndex),
//           );
//         }
//       },
//     );
//   }
// }
