import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/menu_card.dart';

// Mock menus
import 'package:aureola_platform/models/menu/mockup_menu.dart';

class MenuList extends ConsumerStatefulWidget {
  final String layout;

  const MenuList({super.key, required this.layout});

  @override
  ConsumerState<MenuList> createState() => _MenuListState();
}

class _MenuListState extends ConsumerState<MenuList> {
  String? _selectedMenuId;

  @override
  Widget build(BuildContext context) {
    final draftVenue = ref.watch(draftVenueProvider);

    if (draftVenue == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // In real code, you might fetch menus from Firestore.
    // Here, we demonstrate with the mock: menu1, menu2, etc.
    final menus = [menu1, menu2];

    // 1) If no menu is selected yet and we have at least one menu,
    //    default to the first menu in the list.
    if (_selectedMenuId == null && menus.isNotEmpty) {
      _selectedMenuId = menus.first.menuId;
    }

    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: widget.layout != 'isMobile'
              ? const EdgeInsets.all(16)
              : const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Header row
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate('available_menus_at'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    draftVenue.venueName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppThemeLocal.red,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2) Display each menu in a loop
              for (final menu in menus) ...[
                MenuCard(
                  menu: menu,
                  // The card is selected if its menuId == _selectedMenuId
                  isSelected: menu.menuId == _selectedMenuId,
                  onTap: () {
                    setState(() {
                      // 3) Only one selected at a time
                      _selectedMenuId = menu.menuId;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        Divider(
            color: AppThemeLocal.accent.withAlpha((0.5 * 255).toInt()),
            thickness: 0.5),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5E1E),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.translate('add_new_menu'),
              style: AppThemeLocal.buttonText.copyWith(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ]),
    );
  }
}
