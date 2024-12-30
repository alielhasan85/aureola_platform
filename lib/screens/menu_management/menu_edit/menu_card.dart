import 'package:aureola_platform/screens/menu_management/menu_edit/edit_menu.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';

import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/models/menu/menu_availability.dart';

class MenuCard extends StatelessWidget {
  final MenuModel menu;
  final bool isSelected;

  /// Callback when the user taps the white area of the card.
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.menu,
    required this.isSelected,
    required this.onTap,
  });

  /// Example function to get the total number of items across all sections.
  int getTotalItems() {
    int total = 0;
    for (var section in menu.sections) {
      total += section.items.length;
    }
    return total;
  }

  /// Returns a user-friendly availability description.
  String getAvailabilityText() {
    final availability = menu.availability;
    if (availability == null) {
      return 'No availability set';
    }

    switch (availability.type) {
      case AvailabilityType.always:
        return 'Always available';

      case AvailabilityType.periodic:
        final days = availability.daysOfWeek;
        final start = availability.startTime ?? '??';
        final end = availability.endTime ?? '??';
        if (days.isEmpty) {
          return '$start - $end';
        } else {
          final daysString = days.join(', ');
          return '$daysString • $start - $end';
        }

      case AvailabilityType.specific:
        final startDate = availability.startDate;
        final endDate = availability.endDate;
        final startTime = availability.startTime;
        final endTime = availability.endTime;

        final startDateStr =
            startDate != null ? DateFormat('MMM d').format(startDate) : '??';
        final endDateStr =
            endDate != null ? DateFormat('MMM d').format(endDate) : '??';

        final timeRange = (startTime != null && endTime != null)
            ? ' • $startTime - $endTime'
            : '';

        return 'From $startDateStr to $endDateStr$timeRange';
    }
  }

  /// Builds a list of "chips" to show where the menu is live.
  List<Widget> buildLiveChips() {
    final chips = <Widget>[];
    if (menu.isOnline) {
      chips.add(_buildTagChip('Dine-in'));
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
    return chips;
  }

  Widget _buildTagChip(String label) {
    return Chip(
      padding: EdgeInsets.zero,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/$label.svg',
            width: 20,
            height: 20,
            colorFilter:
                const ColorFilter.mode(AppThemeLocal.primary, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(label, style: AppThemeLocal.paragraph.copyWith(fontSize: 12)),
        ],
      ),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    final String formattedDate = formatter.format(menu.updatedAt);
    final totalSections = menu.sections.length;
    final totalItems = getTotalItems();

    // White card container
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppThemeLocal.grey2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tap area for selection
          InkWell(
            // 1) Tapping the card calls onTap
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
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
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: menu.isOnline ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // "Sections • Items"
                  Text(
                    '$totalSections sections • $totalItems items',
                    style: const TextStyle(fontSize: 14),
                  ),

                  // Additional rows only if selected
                  if (isSelected) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Availability: ${getAvailabilityText()}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: $formattedDate',
                      style: AppThemeLocal.paragraph.copyWith(
                        color: AppThemeLocal.secondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: buildLiveChips(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          if (isSelected) ...[
            // A divider
            const Divider(height: 0.5, color: AppThemeLocal.grey2),

            // Bottom action row (Edit, Visible, 3-dots)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              height: 48,
              decoration: BoxDecoration(
                // 2) If selected, show a different background color
                color: isSelected ? AppThemeLocal.background2 : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 3-dots
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppThemeLocal.accent,
                      size: 28.0,
                    ),
                    onSelected: (String value) {
                      // TODO: Implement actions based on the selected value
                      if (value == 'settings') {
                        // Handle Settings action
                      } else if (value == 'delete') {
                        // Handle Delete action
                      }
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

                  // Visible toggle
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('_Visible_'),
                        style: const TextStyle(
                          color: AppThemeLocal.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        value: menu.isOnline,
                        onChanged: (val) {
                          // TODO: Toggle isActive in Firestore or local state
                        },
                      ),
                    ],
                  ),
                  // Edit
                  // 1. Edit Menu Button with leading text
                  Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the Row takes up minimal space
                    children: [
                      // Non-interactive Text
                      Text(
                        AppLocalizations.of(context)!.translate('edit_menu'),
                        style: const TextStyle(
                          color: AppThemeLocal.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8), // Spacing between text and icon

                      // Interactive IconButton
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/edit.svg',
                          width: 28,
                          height: 28,
                          colorFilter: const ColorFilter.mode(
                            AppThemeLocal.accent,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          // Open the EditMenuDialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EditMenuDialog(
                                menu: menu,
                                onSave: (updatedMenu) {
                                  // Handle the updated menu
                                  //onMenuUpdated(updatedMenu);
                                },
                              );
                            },
                          );
                        },
                        splashRadius:
                            20, // Adjusts the splash radius for better UX
                        tooltip: AppLocalizations.of(context)!
                            .translate('edit_menu'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
