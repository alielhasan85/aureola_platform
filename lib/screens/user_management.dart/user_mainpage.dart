import 'package:aureola_platform/screens/main_page/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider);

    // final selectedSection = ref.watch(selectedProfileSectionProvider);

    String selectedSection = 'Notifications';

    return Scaffold(
      //TODO: to add localization
      appBar: CustomAppBar(title: "Profile"),

      //  CustomAppBar(
      //   title: 'User Profile',
      //   actions: [
      //     IconButton(
      //       tooltip: 'Close',
      //       icon: Icon(Icons.close, color: AppTheme.iconTheme.color),
      //       onPressed: () => Navigator.of(context).pop(),
      //     ),
      //     const SizedBox(width: 20),
      //   ],
      // ),
      body: Row(
        children: [
          // const UserProfileNavigationRail(), // Moved to separate file
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: IconButton(
                //     tooltip: isNavigationRailExpanded ? 'Collapse' : 'Expand',
                //     icon: Icon(
                //       isNavigationRailExpanded
                //           ? Icons.keyboard_arrow_left
                //           : Icons.keyboard_arrow_right,
                //       color: AppTheme.iconTheme.color,
                //     ),
                //     onPressed: () {
                //       ref
                //           .read(isNavigationRailExpandedProvider.notifier)
                //           .state = !isNavigationRailExpanded;
                //     },
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildSectionContent(selectedSection),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(
    String selectedSection,
    // UserModel user
  ) {
    switch (selectedSection) {
      case 'Profile':
        return _buildNotificationsTab();
      // return const ProfileTab(); // Keep ProfileTab as a separate widget
      case 'Notifications':
        return _buildNotificationsTab();
      case 'Teams':
        return _buildTeamsTab();
      case 'Subscriptions':
        return _buildSubscriptionsTab();
      case 'Invoices & Billing':
        return _buildInvoicesBillingTab();
      case 'Card':
        return _buildCardTab();
      default:
        return _buildNotificationsTab();
      // return const ProfileTab();
    }
  }

  Widget _buildNotificationsTab() {
    return Center(
        child: Text(
      'Notifications Settings',
    ));
  }

  Widget _buildTeamsTab() {
    return Center(
        child: Text(
      'Teams Management',
    ));
  }

  Widget _buildSubscriptionsTab() {
    return Center(
        child: Text(
      'Subscription Details',
    ));
  }

  Widget _buildInvoicesBillingTab() {
    return Center(
        child: Text(
      'Invoices & Billing',
    ));
  }

  Widget _buildCardTab() {
    return Center(
        child: Text(
      'Card Management',
    ));
  }
}
