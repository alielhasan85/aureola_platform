import 'package:aureola_platform/screens/main_page/widgets/nav_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_submenu_item.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({super.key});

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _selectedIndex = 0;
  int _selectedMenuSubMenuIndex =
      0; // Track selected item in Menu Management submenu
  int _selectedSettingsSubMenuIndex =
      0; // Track selected item in Settings submenu

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
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            border: Border(
              right: BorderSide(
                width: 2,
                color: AppTheme.divider,
              ),
            ),
          ),
          width: 230,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                padding: EdgeInsets.symmetric(vertical: 24),
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
                  padding: const EdgeInsets.only(
                      right: 21), // Right padding for alignment
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      NavigationItem(
                        label: 'Dashboard',
                        leadingIconPath: 'icons/dashboard.svg',
                        isSelected: _selectedIndex == 1,
                        onTap: () => _updateIndex(1),
                      ),
                      const SizedBox(height: 10),
                      NavigationItem(
                        label: 'Order',
                        leadingIconPath: 'icons/order.svg',
                        isSelected: _selectedIndex == 2,
                        onTap: () => _updateIndex(2),
                      ),
                      const SizedBox(height: 10),
                      // Menu Management Navigation Item with Dropdown
                      NavigationItem(
                        label: 'Menu Management',
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
                          margin: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.background.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubMenuItem(
                                label: 'Menus',
                                isSelected: _selectedMenuSubMenuIndex == 0,
                                onSelect: () => _onMenuSubMenuSelect(0),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: 'Categories',
                                isSelected: _selectedMenuSubMenuIndex == 1,
                                onSelect: () => _onMenuSubMenuSelect(1),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: 'Items',
                                isSelected: _selectedMenuSubMenuIndex == 2,
                                onSelect: () => _onMenuSubMenuSelect(2),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: 'Add-ons',
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
                        label: 'Feedback',
                        leadingIconPath: 'icons/feedback.svg',
                        isSelected: _selectedIndex == 4,
                        onTap: () => _updateIndex(4),
                      ),
                      const SizedBox(height: 8),
                      // Settings Navigation Item with Dropdown
                      NavigationItem(
                        label: 'Settings',
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
                          margin: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.background.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubMenuItem(
                                label: 'Venue Management',
                                isSelected: _selectedSettingsSubMenuIndex == 0,
                                onSelect: () => _onSettingsSubMenuSelect(0),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: 'Tables Management',
                                isSelected: _selectedSettingsSubMenuIndex == 1,
                                onSelect: () => _onSettingsSubMenuSelect(1),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),
                              SubMenuItem(
                                label: 'QR Code',
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
