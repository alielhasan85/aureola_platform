import 'package:aureola_platform/screens/main_page/widgets/nav_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_submenu_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:aureola_platform/localization/localization.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({super.key});

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _selectedIndex = 0;
  int _selectedMenuSubMenuIndex = 0;
  int _selectedSettingsSubMenuIndex = 0;

  bool get isMenuManagementSelected => _selectedIndex == 3;
  bool get isSettingsSelected => _selectedIndex == 5;

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuSubMenuSelect(int index) {
    setState(() {
      _selectedMenuSubMenuIndex = index;
    });
  }

  void _onSettingsSubMenuSelect(int index) {
    setState(() {
      _selectedSettingsSubMenuIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
                  iconPath: 'icons/establishment.svg',
                  onCloseOverlay: () {
                    _updateIndex(0);
                  },
                  isSelected: _selectedIndex == 0,
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
                        leadingIconPath: 'icons/dashboard.svg',
                        isSelected: _selectedIndex == 1,
                        onTap: () => _updateIndex(1),
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        label: AppLocalizations.of(context)!.translate('order'),
                        leadingIconPath: 'icons/order.svg',
                        isSelected: _selectedIndex == 2,
                        onTap: () => _updateIndex(2),
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        label: AppLocalizations.of(context)!
                            .translate('menu_management'),
                        leadingIconPath: 'icons/menu_management.svg',
                        trailingIconPath: 'icons/arrow_down.svg',
                        isSelected: _selectedIndex == 3,
                        onTap: () => _updateIndex(3),
                      ),
                      if (isMenuManagementSelected) ...[
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
                                isSelected: _selectedMenuSubMenuIndex == 0,
                                onSelect: () => _onMenuSubMenuSelect(0),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate('categories'),
                                isSelected: _selectedMenuSubMenuIndex == 1,
                                onSelect: () => _onMenuSubMenuSelect(1),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("Items"),
                                isSelected: _selectedMenuSubMenuIndex == 2,
                                onSelect: () => _onMenuSubMenuSelect(2),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("Add-ons"),
                                isSelected: _selectedMenuSubMenuIndex == 3,
                                onSelect: () => _onMenuSubMenuSelect(3),
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
                        leadingIconPath: 'icons/feedback.svg',
                        isSelected: _selectedIndex == 4,
                        onTap: () => _updateIndex(4),
                      ),
                      const SizedBox(height: 8),
                      NavigationItem(
                        label:
                            AppLocalizations.of(context)!.translate("Settings"),
                        leadingIconPath: 'icons/setting.svg',
                        trailingIconPath: 'icons/arrow_down.svg',
                        isSelected: _selectedIndex == 5,
                        onTap: () => _updateIndex(5),
                      ),
                      if (isSettingsSelected) ...[
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
                                isSelected: _selectedSettingsSubMenuIndex == 0,
                                onSelect: () => _onSettingsSubMenuSelect(0),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("tables_management"),
                                isSelected: _selectedSettingsSubMenuIndex == 1,
                                onSelect: () => _onSettingsSubMenuSelect(1),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: AppLocalizations.of(context)!
                                    .translate("QR_Code"),
                                isSelected: _selectedSettingsSubMenuIndex == 2,
                                onSelect: () => _onSettingsSubMenuSelect(2),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
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
