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
//TODO: handle date and availability in case of multi language
  /// Returns a user-friendly availability description.
  String getAvailabilityText(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final availability = menu.availability;

    // If no availability is set, return "No Availability"
    if (availability == null) {
      return localization.translate('menu.no_availability');
    }

    switch (availability.type) {
      case AvailabilityType.always:
        return localization.translate('menu.always_available');

      case AvailabilityType.periodic:
        // ---- Periodic case ----
        final days = availability.daysOfWeek; // e.g. ["monday","tuesday"]
        final startStr = availability.startTime ?? '??'; // "HH:mm" or "??"
        final endStr = availability.endTime ?? '??';

        // 1) Localize the day-of-week strings
        //    We'll assume you have JSON keys like "day_monday", "day_tuesday", etc.
        final localizedDays = days.map((dayId) {
          final key = 'day_$dayId'.toLowerCase(); // e.g. "day_monday"
          return localization.translate(key);
        }).toList();
        final daysString = localizedDays.join(', ');

        // 2) Localize or format the start/end time if they're valid
        final startTimeLocalized = _localizeTime(startStr, locale);
        final endTimeLocalized = _localizeTime(endStr, locale);

        if (days.isEmpty) {
          // If user didn’t pick any specific days, show just time range
          return '$startTimeLocalized - $endTimeLocalized';
        } else {
          // "Monday, Tuesday • 08:00 - 11:00"
          return '$daysString • ($startTimeLocalized --- $endTimeLocalized)';
        }

      case AvailabilityType.specific:
        // ---- Specific case ----
        final dtFormatter = DateFormat('MMM d', locale);

        // Dates
        final startDate = availability.startDate;
        final endDate = availability.endDate;
        final startDateStr =
            (startDate != null) ? dtFormatter.format(startDate) : '??';
        final endDateStr =
            (endDate != null) ? dtFormatter.format(endDate) : '??';

        // Times
        final startTimeStr = availability.startTime ?? '??';
        final endTimeStr = availability.endTime ?? '??';
        final startTimeLocalized = _localizeTime(startTimeStr, locale);
        final endTimeLocalized = _localizeTime(endTimeStr, locale);

        // If both times exist, we show them with a " • " in front
        final timeRange =
            (availability.startTime != null && availability.endTime != null)
                ? ' • ($startTimeLocalized --- $endTimeLocalized)'
                : '';

        // "From {startDate} to {endDate}{timeRange}"
        // e.g. "From Apr 10 to Apr 15 • 09:00 - 20:00"
        return localization
            .translate('menu.from_to')
            .replaceAll('{startDate}', startDateStr)
            .replaceAll('{endDate}', endDateStr)
            .replaceAll('{timeRange}', timeRange);
    }
  }

  /// A helper function to localize or format a "HH:mm" time string.
  /// If you store times in "HH:mm" format, we can parse them into a DateTime or TimeOfDay.
  String _localizeTime(String rawTime, String locale) {
    // If it's "??", just return "??"
    if (rawTime == '??') return '??';

    // rawTime is expected like "08:00" or "15:30".
    // We'll parse it:
    final parts = rawTime.split(':');
    if (parts.length != 2) return rawTime; // fallback if invalid

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    // Create a DateTime just for formatting
    final dt = DateTime(2023, 1, 1, hour, minute);
    // Format with, say, 24-hour style: "HH:mm"
    return DateFormat('HH:mm', locale).format(dt);

    // If you want 12-hour format with AM/PM:
    // return DateFormat.jm(locale).format(dt); // "8:00 AM", e.g.
  }

  /// Builds a list of "chips" to show where the menu is live.
  List<Widget> buildLiveChips(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final chips = <Widget>[];
    if (menu.visibleOnQr) {
      chips.add(_buildTagChip(localization.translate('menu.dine_in'),'Dine-in' , context));
    }
    if (menu.visibleOnPickup) {
      chips.add(_buildTagChip(localization.translate('menu.pickup'), 'Pickup', context));
    }
    if (menu.visibleOnDelivery) {
      chips
          .add(_buildTagChip(localization.translate('menu.delivery'),  'Delivery',context));
    }
    if (menu.visibleOnTablet) {
      chips.add(_buildTagChip(localization.translate('menu.tablet'), 'Tablet',context));
    }
    return chips;
  }

  Widget _buildTagChip(String label, String iconName, BuildContext context) {
    return Chip(
      padding: EdgeInsets.zero,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/$iconName.svg',
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
    final localization = AppLocalizations.of(context)!;

    // 1) Watch the current language code
    final currentLang = ref.watch(languageProvider);

    // 2) Find the menu name in the chosen language
    //    If it doesn't exist, fallback to any available name or a default
    final menuNameMap = menu.menuName;
    // Attempt to get it in the user's language
    String? localizedName = menuNameMap[currentLang];
    // If that is null, fallback to 'en' or the first key or "Untitled"
    if (localizedName == null || localizedName.isEmpty) {
      // Fallback strategy 1: check English
      localizedName = menuNameMap['en'];
    }
    if (localizedName == null || localizedName.isEmpty) {
      // Fallback strategy 2: pick the first language in the map
      if (menuNameMap.isNotEmpty) {
        localizedName = menuNameMap.values.first;
      }
    }
    final nameToShow = localizedName?.trim().isNotEmpty == true
        ? localizedName!
        : 'Untitled Menu';

// Use the current locale from the Flutter `Localizations` system.
    final currentLocale = Localizations.localeOf(context).toString();

    final DateFormat formatter = DateFormat('MMM dd, yyyy', currentLocale);
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
                        nameToShow,
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
                  Text(
                    localization
                        .translate('menu.sections_items')
                        .replaceAll('{sections}', '4')
                        .replaceAll('{items}', '15'),
                    style: const TextStyle(fontSize: 14),
                  ),

                  if (isSelected) ...[
                    const SizedBox(height: 8),
                    Text(
                      localization.translate('menu.availability').replaceAll(
                          '{availability}', getAvailabilityText(context)),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization
                          .translate('menu.last_updated')
                          .replaceAll('{date}', formattedDate),
                      style: AppThemeLocal.paragraph.copyWith(
                        color: AppThemeLocal.secondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: buildLiveChips(context),
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
              decoration: const BoxDecoration(
                color: AppThemeLocal.background2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 2) 3-dots for Settings or Delete
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
        // Handle settings action
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
      case 'duplicate':
        // NEW: Duplicate the menu
        await ref
            .read(menusListProvider(venue.venueId).notifier)
            .duplicateMenu(menu.menuId);
        break;
    }
  },
  itemBuilder: (BuildContext context) {
    final items = <PopupMenuEntry<String>>[];

    items.add(
      PopupMenuItem(
        value: 'settings',
        child: Text(localization.translate('menu.settings')),
      ),
    );
    items.add(
      PopupMenuItem(
        value: 'duplicate',
        child: Text(localization.translate('menu.duplicate')),
      ),
    );
    items.add(
      PopupMenuItem(
        value: 'delete',
        child: Text(localization.translate('menu.delete')),
      ),
    );

    // Add "Move Up" if not first
    if (!isFirst) {
      items.add(
        PopupMenuItem(
          value: 'move_up',
          child: Text(localization.translate('menu.move_up')),
        ),
      );
    }

    // Add "Move Down" if not last
    if (!isLast) {
      items.add(
        PopupMenuItem(
          value: 'move_down',
          child: Text(localization.translate('menu.move_down')),
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
                        localization.translate('menu.live'),
                        style: const TextStyle(
                          color: AppThemeLocal.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),

                        side: BorderSide(
                          color: AppThemeLocal.accent2,
                          width: 1,
                        ),
                        activeColor:
                            AppThemeLocal.grey2, // Set the accent color
                        checkColor: AppThemeLocal.accent,
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
                        localization.translate('menu.edit_menu'),
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
                        // tooltip: localization.translate('menu.edit_menu'),
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
