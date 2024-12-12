import 'package:aureola_platform/widgest/logo_icon.dart';
import 'package:aureola_platform/providers/main_navigation_provider.dart';
import 'package:aureola_platform/providers/main_title_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_submenu_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_venue.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class CustomNavigation extends ConsumerStatefulWidget {
  final bool isDrawer;

  const CustomNavigation({
    super.key,
    this.isDrawer = false,
  });

  @override
  ConsumerState<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends ConsumerState<CustomNavigation> {
  void _updateIndex(int index, String title, {bool closeDrawer = true}) {
    // Avoid changing index when venue is selected (index 0)
    if (index != 0) {
      ref.read(selectedMenuIndexProvider.notifier).state = index;
      ref.read(appBarTitleProvider.notifier).state = title;
    }

    // Close the drawer only if closeDrawer is true
    if (widget.isDrawer && closeDrawer) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final selectedIndex = ref.watch(selectedMenuIndexProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: widget.isDrawer
            ? null
            : Border(
                left: isRtl
                    ? const BorderSide(width: 0.5, color: AppTheme.divider)
                    : BorderSide.none,
                right: !isRtl
                    ? const BorderSide(width: 0.5, color: AppTheme.divider)
                    : BorderSide.none,
              ),
      ),
      width: widget.isDrawer ? null : 230,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: widget.isDrawer
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              : const EdgeInsets.only(right: 16, left: 12, top: 16, bottom: 12),
          child: Column(
            crossAxisAlignment: widget.isDrawer
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              // Header (Logo, Title)
              if (!widget.isDrawer) ...[const AppLogo()],

              // Navigation Items
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: VenueNavigation(
                  label: 'Al bait El Shami restaurant',
                  iconPath: 'assets/icons/arrow.svg',
                  onCloseOverlay: () {
                    _updateIndex(0, '', closeDrawer: false);
                  },
                  isSelected: selectedIndex == 0,
                ),
              ),
              NavigationItem(
                label: AppLocalizations.of(context)!.translate('dashboard'),
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
                  AppLocalizations.of(context)!.translate('order_title'),
                ),
              ),
              const SizedBox(height: 10),
              NavigationItem(
                label:
                    AppLocalizations.of(context)!.translate('menu_management'),
                leadingIconPath: 'assets/icons/menu_management.svg',
                trailingIconPath: 'assets/icons/arrow_down.svg',
                isSelected: selectedIndex >= 3 && selectedIndex <= 7,
                onTap: () => _updateIndex(3,
                    AppLocalizations.of(context)!.translate('menu_management'),
                    closeDrawer: false),
              ),
              if (selectedIndex >= 3 && selectedIndex <= 8) ...[
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
                        label: AppLocalizations.of(context)!.translate('menu'),
                        isSelected: selectedIndex == 3,
                        onSelect: () => _updateIndex(
                            3,
                            AppLocalizations.of(context)!
                                .translate('menu_management')),
                      ),
                      const Divider(color: AppTheme.divider, thickness: 0.5),
                      SubMenuItem(
                        label: AppLocalizations.of(context)!
                            .translate('categories'),
                        isSelected: selectedIndex == 4,
                        onSelect: () => _updateIndex(
                            4,
                            AppLocalizations.of(context)!
                                .translate('menu_management')),
                      ),
                      const Divider(color: AppTheme.divider, thickness: 0.5),
                      SubMenuItem(
                        label: AppLocalizations.of(context)!.translate("Items"),
                        isSelected: selectedIndex == 5,
                        onSelect: () => _updateIndex(
                            5,
                            AppLocalizations.of(context)!
                                .translate('menu_management')),
                      ),
                      const Divider(color: AppTheme.divider, thickness: 0.5),
                      SubMenuItem(
                        label:
                            AppLocalizations.of(context)!.translate("Add-ons"),
                        isSelected: selectedIndex == 6,
                        onSelect: () => _updateIndex(
                            6,
                            AppLocalizations.of(context)!
                                .translate('menu_management')),
                      ),
                      const Divider(color: AppTheme.divider, thickness: 0.5),
                      SubMenuItem(
                        label: AppLocalizations.of(context)!
                            .translate("branding_design"),
                        isSelected: selectedIndex == 7,
                        onSelect: () => _updateIndex(
                            7,
                            AppLocalizations.of(context)!
                                .translate('menu_management')),
                      ),
                      const Divider(color: AppTheme.divider, thickness: 0.5),
                      SubMenuItem(
                        label: AppLocalizations.of(context)!
                            .translate("Flush_Screen"),
                        isSelected: selectedIndex == 8,
                        onSelect: () => _updateIndex(
                            8,
                            AppLocalizations.of(context)!
                                .translate('Flush_Screen')),
                      )
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              NavigationItem(
                label: AppLocalizations.of(context)!.translate("Feedback"),
                leadingIconPath: 'assets/icons/feedback.svg',
                isSelected: selectedIndex == 9,
                onTap: () => _updateIndex(
                    9, AppLocalizations.of(context)!.translate("Feedback")),
              ),
              const SizedBox(height: 8),
              NavigationItem(
                label: AppLocalizations.of(context)!.translate("Settings"),
                leadingIconPath: 'assets/icons/setting.svg',
                trailingIconPath: 'assets/icons/arrow_down.svg',
                isSelected: selectedIndex >= 10 && selectedIndex <= 12,
                onTap: () => _updateIndex(
                    10, AppLocalizations.of(context)!.translate("venue_info"),
                    closeDrawer: false),
              ),
              if (selectedIndex >= 10 && selectedIndex <= 13) ...[
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  padding: const EdgeInsets.all(8),
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
                        isSelected: selectedIndex == 10,
                        onSelect: () => _updateIndex(
                            10,
                            AppLocalizations.of(context)!
                                .translate("venue_info")),
                      ),
                      const Divider(
                        color: AppTheme.divider,
                        thickness: 0.5,
                      ),
                      SubMenuItem(
                        label: AppLocalizations.of(context)!
                            .translate("social_media"),
                        isSelected: selectedIndex == 11,
                        onSelect: () => _updateIndex(
                            11,
                            AppLocalizations.of(context)!
                                .translate("social_media")),
                      ),
                      const Divider(
                        color: AppTheme.divider,
                        thickness: 0.5,
                      ),
                      SubMenuItem(
                        label: AppLocalizations.of(context)!
                            .translate("prices_option"),
                        isSelected: selectedIndex == 12,
                        onSelect: () => _updateIndex(
                            12,
                            AppLocalizations.of(context)!
                                .translate("prices_option")),
                      ),
                      const Divider(
                        color: AppTheme.divider,
                        thickness: 0.5,
                      ),
                      SubMenuItem(
                        label: AppLocalizations.of(context)!
                            .translate("tables_management"),
                        isSelected: selectedIndex == 13,
                        onSelect: () => _updateIndex(
                            13,
                            AppLocalizations.of(context)!
                                .translate("tables_management")),
                      ),
                      const Divider(
                        color: AppTheme.divider,
                        thickness: 0.5,
                      ),
                      SubMenuItem(
                        label:
                            AppLocalizations.of(context)!.translate("QR_Code"),
                        isSelected: selectedIndex == 14,
                        onSelect: () => _updateIndex(14,
                            AppLocalizations.of(context)!.translate("QR_Code")),
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
    );
  }
}
