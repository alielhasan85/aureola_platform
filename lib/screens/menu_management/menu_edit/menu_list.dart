// lib/screens/menu_management/menu_edit/menu_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/menus_list_provider.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/menu_card.dart';

/// This widget displays all menus for the current draftVenue (if any),
/// using the menusListProvider to load data from Firestore.
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
      loading: () => const SizedBox(
          height: 700,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Loading Available menus'),
            Center(child: CircularProgressIndicator())
          ])),
      error: (err, stack) => Center(
        child: Text(
          AppLocalizations.of(context)!
              .translate('menuList.error')
              .replaceFirst('{error}', err.toString()),
        ),
      ),
      data: (menus) {
        // If no menu is selected yet but we have menus, select the first one
        if (_selectedMenuId == null && menus.isNotEmpty) {
          _selectedMenuId = menus.first.menuId;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // --- Header and Title ---
              Padding(
                padding: widget.layout != 'isMobile'
                    ? const EdgeInsets.all(16)
                    : const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Row: "Available Menus at {VenueName}"
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text(
                    //         AppLocalizations.of(context)!
                    //             .translate('menuList.availableMenusAt')
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translate('menu.availableMenusAt'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          draftVenue.venueName,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: AppThemeLocal.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- The Menus ---
                    if (menus.isEmpty) ...[
                      // If no menus exist
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('menu.noMenusFound'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ] else ...[
                      // For each menu, figure out if it's first or last
                      for (int i = 0; i < menus.length; i++) ...[
                        // Determine if this is top or bottom in the list
                        MenuCard(
                          menu: menus[i],
                          isSelected: menus[i].menuId == _selectedMenuId,
                          onTap: () {
                            setState(() {
                              _selectedMenuId = menus[i].menuId;
                            });
                          },
                          isFirst: i == 0,
                          isLast: i == menus.length - 1,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ],
                  ],
                ),
              ),

              // Divider
              Divider(
                color: AppThemeLocal.accent2,
                thickness: 0.5,
              ),
              const SizedBox(height: 12),

              // "Add New Menu" Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E1E),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // 4) Create a new blank/placeholder menu
                    final newMenu = MenuModel(
                      menuId: '', // Let Firestore assign an ID
                      venueId: draftVenue.venueId,
                      menuName: {'en': 'Untitled Menu'},
                      description: {},
                      notes: {},
                      imageUrl: null,
                      isOnline: false,
                      sortOrder: menus.length, // put it at the end
                    );

                    // Use the provider to upsert (add) this new menu
                    await ref
                        .read(menusListProvider(draftVenue.venueId).notifier)
                        .upsertMenu(newMenu);

                    // Optionally, automatically select it
                    // We might need to refetch the updated list or do it after upsert
                    // For simplicity, rely on the list refreshing itself
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('menu.addNewMenu'),
                    style: AppThemeLocal.buttonText.copyWith(fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
