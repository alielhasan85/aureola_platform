import 'package:aureola_platform/providers/menus_list_provider.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/edit_menu.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/models/menu/menu_availability.dart';
import 'package:aureola_platform/providers/providers.dart';
// Where menusListProvider is accessible

class MenuCard extends ConsumerWidget {
  final MenuModel menu;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;

  /// Callback when the user taps the white area of the card.
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.menu,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    final String formattedDate = formatter.format(menu.updatedAt);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppThemeLocal.grey2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1) Tappable area for selection highlight
          InkWell(
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
                  // TODO: (In your final code, you might fetch sections subcollection and count them)
                  const Text(
                    '4 sections • 15 items',
                    style: TextStyle(fontSize: 14),
                  ),

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
            const Divider(height: 0.5, color: AppThemeLocal.grey2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              height: 48,
              decoration: BoxDecoration(
                color: AppThemeLocal.background2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 2) 3-dots for Settings or Delete
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppThemeLocal.accent,
                      size: 28.0,
                    ),
                    onSelected: (String value) async {
                      final venue = ref.read(draftVenueProvider);
                      if (venue == null) return;

                      switch (value) {
                        case 'settings':
                          // ...
                          break;
                        case 'delete':
                          await ref
                              .read(menusListProvider(venue.venueId).notifier)
                              .deleteMenu(menu.menuId);
                          break;
                        case 'move_up':
                          await ref
                              .read(menusListProvider(venue.venueId).notifier)
                              .moveUp(menu.menuId);
                          break;
                        case 'move_down':
                          await ref
                              .read(menusListProvider(venue.venueId).notifier)
                              .moveDown(menu.menuId);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      final items = <PopupMenuEntry<String>>[];

                      items.add(
                        const PopupMenuItem(
                          value: 'settings',
                          child: Text('Settings'),
                        ),
                      );
                      items.add(
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      );

                      // Add "Move Up" if not first
                      if (!isFirst) {
                        items.add(
                          const PopupMenuItem(
                            value: 'move_up',
                            child: Text('Move Up'),
                          ),
                        );
                      }

                      // Add "Move Down" if not last
                      if (!isLast) {
                        items.add(
                          const PopupMenuItem(
                            value: 'move_down',
                            child: Text('Move Down'),
                          ),
                        );
                      }

                      return items;
                    },
                  ),

                  // 4) Toggle isOnline
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('Live'),
                        style: const TextStyle(
                          color: AppThemeLocal.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        value: menu.isOnline,
                        onChanged: (val) async {
                          if (val == null) return;
                          final newMenu = menu.copyWith(isOnline: val);
                          final venue = ref.read(draftVenueProvider);
                          if (venue != null) {
                            // Partial update or upsert
                            await ref
                                .read(menusListProvider(venue.venueId).notifier)
                                .upsertMenu(newMenu);
                          }
                        },
                      ),
                    ],
                  ),

                  // 5) Edit button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('edit_menu'),
                        style: const TextStyle(
                          color: AppThemeLocal.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                        splashRadius: 20,
                        tooltip: AppLocalizations.of(context)!
                            .translate('edit_menu'),
                        onPressed: () {
                          // Example: show dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EditMenuDialog(
                                menu: menu,
                                onSave: (updatedMenu) async {
                                  // Save via upsert
                                  final venue = ref.read(draftVenueProvider);
                                  if (venue != null) {
                                    await ref
                                        .read(
                                          menusListProvider(venue.venueId)
                                              .notifier,
                                        )
                                        .upsertMenu(updatedMenu);
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
