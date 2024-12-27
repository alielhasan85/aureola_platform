import 'package:flutter/material.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';

// A mock widget that displays your menu card
class MenuCard extends StatelessWidget {
  final MenuModel menu;

  const MenuCard({
    Key? key,
    required this.menu,
  }) : super(key: key);

  /// Example function to get the total number of items
  /// across all sections.
  int getTotalItems() {
    int total = 0;
    for (var section in menu.sections) {
      total += section.items.length;
    }
    return total;
  }

  /// Format your availability object into a user-friendly string
  String getAvailabilityText() {
    // This is just a placeholder for demonstration
    // Adjust logic as you build out more advanced availability features
    final days = menu.availability?['days'] ?? [];
    final times = menu.availability?['times'] ?? {};
    final start = times['start'] ?? '??';
    final end = times['end'] ?? '??';
    return '${days.join(', ')} • $start - $end';
  }

  /// A helper that returns a list of "chips" or small tags
  /// showing where the menu is live (pickup, delivery, etc.)
  List<Widget> buildLiveChips() {
    final chips = <Widget>[];

    if (menu.isOnline) {
      chips.add(_buildTagChip('Online'));
    }
    if (menu.visibleOnPickup) {
      chips.add(_buildTagChip('Pickup'));
    }
    if (menu.visibleOnDelivery) {
      chips.add(_buildTagChip('Delivery'));
    }
    if (menu.visibleOnTablet) {
      chips.add(_buildTagChip('Tablet'));
    }
    if (menu.visibleOnQr) {
      chips.add(_buildTagChip('QR'));
    }

    return chips;
  }

  Widget _buildTagChip(String label) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSections = menu.sections.length;
    final totalItems = getTotalItems();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row #1: Menu name + circle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  menu.menuName['en'] ?? 'Untitled Menu',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: menu.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Row #2: Availability
            Text(
              'Availability: ${getAvailabilityText()}',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 8),

            // Row #3: Sections & Items summary
            Text(
              '$totalSections sections • $totalItems items',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 8),

            // Row #4: Last updated
            Text(
              'Last updated: ${menu.updatedAt}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 8),

            // Row #5: Where the menu is live
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: buildLiveChips(),
            ),

            const Divider(height: 16),

            // Row #6: Actions (Edit button, toggle, 3 dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Edit menu button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Handle edit
                  },
                  child: const Text('Edit Menu'),
                ),

                // Radio/Switch for isActive or isVisible
                Row(
                  children: [
                    const Text('Visible'),
                    Switch(
                      value: menu.isActive,
                      onChanged: (val) {
                        // TODO: Handle toggling "isActive"
                      },
                    ),
                  ],
                ),

                // 3-dots menu (PopupMenuButton)
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    // TODO: Implement additional actions
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'settings',
                        child: Text('Settings'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
