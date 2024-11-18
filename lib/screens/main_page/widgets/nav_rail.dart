import 'package:aureola_platform/providers/appbar_title_provider.dart';
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
  void _updateIndex(int index, String title) {
    ref.read(selectedMenuIndexProvider.notifier).state = index;
    if (index != 0) {
      ref.read(appBarTitleProvider.notifier).state = title;
    }
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
                  ? const BorderSide(width: 0.5, color: AppTheme.divider)
                  : BorderSide.none,
              right: !isRtl
                  ? const BorderSide(width: 0.5, color: AppTheme.divider)
                  : BorderSide.none,
            ),
          ),
          width: 230,
          height: double.infinity,
          child: Column(
            crossAxisAlignment:
                isRtl ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              // TODO: changing logo to png
              const Padding(
                padding: EdgeInsets.only(top: 12, right: 24),
                child: Text(
                  'Naya',
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

              // navigation of venue name
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: VenueNavigation(
                  label: 'Al bait El Shami restaurant and',
                  iconPath: 'assets/icons/arrow.svg',
                  onCloseOverlay: () {
                    _updateIndex(0, '');
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
                        onTap: () => _updateIndex(
                          1,
                          AppLocalizations.of(context)!.translate('dashboard'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        label: AppLocalizations.of(context)!.translate('order'),
                        leadingIconPath: 'assets/icons/order.svg',
                        isSelected: selectedIndex == 2,
                        onTap: () => _updateIndex(
                          2,
                          AppLocalizations.of(context)!
                              .translate('order_title'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        label: AppLocalizations.of(context)!
                            .translate('menu_management'),
                        leadingIconPath: 'assets/icons/menu_management.svg',
                        trailingIconPath: 'assets/icons/arrow_down.svg',
                        isSelected: selectedIndex >= 3 && selectedIndex <= 7,
                        onTap: () => _updateIndex(
                            3,
                            AppLocalizations.of(context)!
                                .translate('menu_management')),
                      ),
                      if (selectedIndex >= 3 && selectedIndex <= 7) ...[
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
                                onSelect: () => _updateIndex(
                                    3,
                                    AppLocalizations.of(context)!
                                        .translate('menu_management')),
                                onTap: () {},
                              ),
                              const Divider(
                                  color: AppTheme.divider, thickness: 0.5),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate('categories'),
                                isSelected: selectedIndex == 4,
                                onSelect: () => _updateIndex(
                                    4,
                                    AppLocalizations.of(context)!
                                        .translate('menu_management')),
                                onTap: () {},
                              ),
                              const Divider(
                                  color: AppTheme.divider, thickness: 0.5),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("Items"),
                                isSelected: selectedIndex == 5,
                                onSelect: () => _updateIndex(
                                    5,
                                    AppLocalizations.of(context)!
                                        .translate('menu_management')),
                                onTap: () {},
                              ),
                              const Divider(
                                  color: AppTheme.divider, thickness: 0.5),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("Add-ons"),
                                isSelected: selectedIndex == 6,
                                onSelect: () => _updateIndex(
                                    6,
                                    AppLocalizations.of(context)!
                                        .translate('menu_management')),
                                onTap: () {},
                              ),
                              const Divider(
                                  color: AppTheme.divider, thickness: 0.5),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("branding_design"),
                                isSelected: selectedIndex == 7,
                                onSelect: () => _updateIndex(
                                    7,
                                    AppLocalizations.of(context)!
                                        .translate('menu_management')),
                                onTap: () {},
                              )
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      NavigationItem(
                        label:
                            AppLocalizations.of(context)!.translate("Feedback"),
                        leadingIconPath: 'assets/icons/feedback.svg',
                        isSelected: selectedIndex == 8,
                        onTap: () => _updateIndex(
                            8,
                            AppLocalizations.of(context)!
                                .translate("Feedback")),
                      ),
                      const SizedBox(height: 8),
                      NavigationItem(
                        label:
                            AppLocalizations.of(context)!.translate("Settings"),
                        leadingIconPath: 'assets/icons/setting.svg',
                        trailingIconPath: 'assets/icons/arrow_down.svg',
                        isSelected: selectedIndex >= 9 && selectedIndex <= 11,
                        onTap: () => _updateIndex(
                            9,
                            AppLocalizations.of(context)!
                                .translate("venue_info")),
                      ),
                      if (selectedIndex >= 9 && selectedIndex <= 11) ...[
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
                                    .translate("venue_info"),
                                isSelected: selectedIndex == 9,
                                onSelect: () => _updateIndex(
                                    9,
                                    AppLocalizations.of(context)!
                                        .translate("venue_info")),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("tables_management"),
                                isSelected: selectedIndex == 10,
                                onSelect: () => _updateIndex(
                                    10,
                                    AppLocalizations.of(context)!
                                        .translate("tables_management")),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("QR_Code"),
                                isSelected: selectedIndex == 11,
                                onSelect: () => _updateIndex(
                                    11,
                                    AppLocalizations.of(context)!
                                        .translate("QR_Code")),
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
