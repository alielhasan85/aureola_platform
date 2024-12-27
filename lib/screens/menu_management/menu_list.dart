import 'package:aureola_platform/models/menu/mockup_menu.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/menu_management/menu_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuList extends ConsumerWidget {
  final String layout;

  const MenuList({super.key, required this.layout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftVenue = ref.watch(draftVenueProvider);

    if (draftVenue == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // In a real scenario, you'd fetch the list of menus from Firestore
    // or from some state provider. For now, we just show one "menu1".
    return Padding(
      padding: layout != 'isMobile'
          ? const EdgeInsets.all(16)
          : const EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Some heading
            Text(
              'Menus at ${draftVenue.venueName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            // Spacing
            const SizedBox(height: 16),

            // Mock usage of MenuCard
            MenuCard(menu: menu1),

            // Spacing
            const SizedBox(height: 16),
// Mock usage of MenuCard
            MenuCard(menu: menu2),

            // If you had multiple menus, you could build them in a ListView.builder
            // or just replicate more MenuCards here
          ],
        ),
      ),
    );
  }
}
