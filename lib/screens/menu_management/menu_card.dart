import 'package:aureola_platform/models/menu/menu_availability.dart';
import 'package:aureola_platform/models/menu/mockup_menu.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:intl/intl.dart';

class MenuCard extends StatelessWidget {
  final MenuModel menu;

  const MenuCard({
    super.key,
    required this.menu,
  });

  /// Example function to get the total number of items
  /// across all sections.
  int getTotalItems() {
    int total = 0;
    for (var section in menu.sections) {
      total += section.items.length;
    }
    return total;
  }

  /// Returns a user-friendly availability description based on the
  /// `MenuAvailability` settings in `menu.availability`.
  String getAvailabilityText(MenuModel menu) {
    final availability = menu.availability;

    // If there's no availability object at all, return something safe
    if (availability == null) {
      return 'No availability set';
    }

    switch (availability.type) {
      case AvailabilityType.always:
        return 'Always available';

      case AvailabilityType.periodic:
        // e.g., "Mon, Tue from 07:00 to 10:00"
        final days = availability.daysOfWeek;
        final start = availability.startTime ?? '??';
        final end = availability.endTime ?? '??';

        if (days.isEmpty) {
          // If no days specified, just show the time range
          return '$start - $end';
        } else {
          // Join the days with commas (e.g., "Mon, Tue, Wed")
          final daysString = days.join(', ');
          return '$daysString • $start - $end';
        }

      case AvailabilityType.specific:
        // e.g., "From Dec 27 to Dec 31 • 10:00 - 15:00"
        final startDate = availability.startDate;
        final endDate = availability.endDate;
        final startTime = availability.startTime;
        final endTime = availability.endTime;

        // Convert dates to a simple 'MMM d' format, or however you prefer
        // (In real code, consider using intl package for localized formatting)
        final startDateStr = startDate != null
            ? '${startDate.month}/${startDate.day}' // e.g., "12/27"
            : '??';
        final endDateStr =
            endDate != null ? '${endDate.month}/${endDate.day}' : '??';

        // If time is set, show it; otherwise skip
        final timeRange = (startTime != null && endTime != null)
            ? ' • $startTime - $endTime'
            : '';

        return 'From $startDateStr to $endDateStr$timeRange';
    }
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
    final DateFormat formatter = DateFormat('MMM, dd, yyyy');
    final String formattedDate = formatter.format(menu.updatedAt);

    final totalSections = menu.sections.length;
    final totalItems = getTotalItems();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppThemeLocal.grey2),
      ),
      //margin: const EdgeInsets.symmetric(vertical: 8),
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
              'Availability: ${getAvailabilityText(menu1)}',
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
            Text('Last updated: $formattedDate',
                style: AppThemeLocal.paragraph
                    .copyWith(color: AppThemeLocal.secondary, fontSize: 12)),

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
