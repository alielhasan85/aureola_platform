import 'package:aureola_platform/providers/menus_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/providers/providers.dart'; 
  // <-- Make sure you have menusListProvider or import 
  // the file where you defined `menusListProvider`
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/menu_card.dart';

/// This widget displays all menus for the current draftVenue (if any),
/// using the menusListProvider to load data from Firestore.
class MenuList extends ConsumerStatefulWidget {
  final String layout;

  const MenuList({Key? key, required this.layout}) : super(key: key);

  @override
  ConsumerState<MenuList> createState() => _MenuListState();
}

class _MenuListState extends ConsumerState<MenuList> {
  String? _selectedMenuId;

  @override
  Widget build(BuildContext context) {
    // 1) We watch the "draftVenue" to know which venue is selected
    final draftVenue = ref.watch(draftVenueProvider);

    // If no venue is selected, show a loading or "no venue" message
    if (draftVenue == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) We watch the provider that fetches a list of menus for this venue
    final menusAsync = ref.watch(menusListProvider(draftVenue.venueId));

    // 3) Return UI based on AsyncValue state
    return menusAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (menus) {
        // If no menu is selected yet but we do have menus, select the first one
        if (_selectedMenuId == null && menus.isNotEmpty) {
          _selectedMenuId = menus.first.menuId;
        }

        return SingleChildScrollView(
          child: Column(children: [
            // --- Header and Title ---
            Padding(
              padding: widget.layout != 'isMobile'
                  ? const EdgeInsets.all(16)
                  : const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Row: "Available Menus at <VenueName>"
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

                  // --- The Menus ---
                  if (menus.isEmpty) ...[
                    // If no menus exist, show a simple message
                    Center(
                      child: Text(
                        'No menus found.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ] else ...[
                    // List all menus
                    for (final menu in menus) ...[
                      MenuCard(
                        menu: menu,
                        // Check if this menu is selected
                        isSelected: menu.menuId == _selectedMenuId,
                        onTap: () {
                          setState(() {
                            _selectedMenuId = menu.menuId;
                          });
                        },
                        // Additional callbacks can be placed inside MenuCard if desired
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ],
              ),
            ),

            // Divider
            Divider(
              color: AppThemeLocal.accent.withAlpha((0.5 * 255).toInt()),
              thickness: 0.5,
            ),

            const SizedBox(height: 12),

            // "Add New Menu" Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5E1E),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // 4) Create a new blank/placeholder menu
                  final newMenu = MenuModel(
                    menuId: '',       // Let Firestore assign an ID
                    venueId: draftVenue.venueId,
                    menuName: {'en': 'Untitled Menu'},
                    description: {},
                    notes: {},
                    imageUrl: null,
                    sortOrder: menus.length, // put it at the end
                  );

                  // Use the provider to upsert (add) this new menu
                  await ref
                      .read(menusListProvider(draftVenue.venueId).notifier)
                      .upsertMenu(newMenu);

                  // Optionally, automatically select it
                  // We might need to refetch the updated list or do it after upsert
                  // For simplicity, we will rely on the list refreshing itself
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('add_new_menu'),
                  style: AppThemeLocal.buttonText.copyWith(fontSize: 14),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ]),
        );
      },
    );
  }
}
