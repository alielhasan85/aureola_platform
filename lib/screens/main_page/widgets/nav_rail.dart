import 'package:aureola_platform/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_submenu_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:aureola_platform/localization/localization.dart';

class CustomNavigation extends ConsumerStatefulWidget {
  const CustomNavigation({super.key});

  @override
  ConsumerState<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends ConsumerState<CustomNavigation> {
  void _updateIndex(int index) {
    ref.read(selectedMenuIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final selectedIndex = ref.watch(selectedMenuIndexProvider);

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            border: Border(
              left: isRtl
                  ? const BorderSide(width: 2, color: AppTheme.divider)
                  : BorderSide.none,
              right: !isRtl
                  ? const BorderSide(width: 2, color: AppTheme.divider)
                  : BorderSide.none,
            ),
          ),
          width: 230,
          height: double.infinity,
          child: Column(
            crossAxisAlignment:
                isRtl ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12, right: 24),
                child: Text(
                  'Aureola',
                  style: AppTheme.titleAureola,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(right: 24),
                child: Text(
                  'Platform',
                  style: AppTheme.titlePlatform,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: VenueNavigation(
                  label: 'Al bait El Shami restaurant and',
                  iconPath: 'assets/icons/establishment.svg',
                  onCloseOverlay: () {
                    _updateIndex(0);
                  },
                  isSelected: selectedIndex == 0,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: isRtl ? 0 : 21,
                    left: isRtl ? 21 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      NavigationItem(
                        label: AppLocalizations.of(context)!
                            .translate('dashboard'),
                        leadingIconPath: 'assets/icons/dashboard.svg',
                        isSelected: selectedIndex == 1,
                        onTap: () => _updateIndex(1),
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        label: AppLocalizations.of(context)!.translate('order'),
                        leadingIconPath: 'assets/icons/order.svg',
                        isSelected: selectedIndex == 2,
                        onTap: () => _updateIndex(2),
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        label: AppLocalizations.of(context)!
                            .translate('menu_management'),
                        leadingIconPath: 'assets/icons/menu_management.svg',
                        trailingIconPath: 'assets/icons/arrow_down.svg',
                        isSelected: selectedIndex >= 3 && selectedIndex <= 6,
                        onTap: () => _updateIndex(3),
                      ),
                      if (selectedIndex >= 3 && selectedIndex <= 6) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: 180,
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            left: isRtl ? 0 : 20,
                            right: isRtl ? 20 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.background.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate('menu'),
                                isSelected: selectedIndex == 3,
                                onSelect: () => _updateIndex(3),
                                onTap: () {},
                              ),
                              const Divider(
                                  color: AppTheme.divider, thickness: 0.5),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate('categories'),
                                isSelected: selectedIndex == 4,
                                onSelect: () => _updateIndex(4),
                                onTap: () {},
                              ),
                              const Divider(
                                  color: AppTheme.divider, thickness: 0.5),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("Items"),
                                isSelected: selectedIndex == 5,
                                onSelect: () => _updateIndex(5),
                                onTap: () {},
                              ),
                              const Divider(
                                  color: AppTheme.divider, thickness: 0.5),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("Add-ons"),
                                isSelected: selectedIndex == 6,
                                onSelect: () => _updateIndex(6),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      NavigationItem(
                        label:
                            AppLocalizations.of(context)!.translate("Feedback"),
                        leadingIconPath: 'assets/icons/feedback.svg',
                        isSelected: selectedIndex == 7,
                        onTap: () => _updateIndex(7),
                      ),
                      const SizedBox(height: 8),
                      NavigationItem(
                        label:
                            AppLocalizations.of(context)!.translate("Settings"),
                        leadingIconPath: 'assets/icons/setting.svg',
                        trailingIconPath: 'assets/icons/arrow_down.svg',
                        isSelected: selectedIndex >= 8 && selectedIndex <= 11,
                        onTap: () => _updateIndex(8),
                      ),
                      if (selectedIndex >= 8 && selectedIndex <= 10) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: 180,
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            left: isRtl ? 0 : 20,
                            right: isRtl ? 20 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.background.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("venue_management"),
                                isSelected: selectedIndex == 8,
                                onSelect: () => _updateIndex(8),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("tables_management"),
                                isSelected: selectedIndex == 9,
                                onSelect: () => _updateIndex(9),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("QR_Code"),
                                isSelected: selectedIndex == 10,
                                onSelect: () => _updateIndex(10),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        // Add other navigation items similarly
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
