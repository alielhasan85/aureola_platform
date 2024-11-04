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
  int _selectedSubMenuIndex = -1; // Track selected submenu item

  bool get isMenuManagementSelected => _selectedIndex == 3;

  void _updateIndex(int index) {
    setState(() {
      // Toggle selection for "Menu Management" (index 3)

      _selectedIndex = index;
    });
  }

  void _onSubMenuSelect(int index) {
    setState(() {
      _selectedSubMenuIndex = index; // Update selected index
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
                      const SizedBox(height: 12), // Space between items
                      NavigationItem(
                        label: 'Order',
                        leadingIconPath: 'icons/order.svg',
                        isSelected: _selectedIndex == 2,
                        onTap: () => _updateIndex(2),
                      ),
                      const SizedBox(height: 12),
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
                          width: 160,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(left: 50),
                          decoration: BoxDecoration(
                            color: AppTheme.background.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubMenuItem(
                                label: 'Menus',
                                isSelected: _selectedSubMenuIndex == 0,
                                onSelect: () => _onSubMenuSelect(0),
                                onTap: () {},
                              ),
                              // const SizedBox(height: 2),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),

                              SubMenuItem(
                                label: 'Categories',
                                isSelected: _selectedSubMenuIndex == 1,
                                onSelect: () => _onSubMenuSelect(1),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),

                              SubMenuItem(
                                label: 'Items',
                                isSelected: _selectedSubMenuIndex == 2,
                                onSelect: () => _onSubMenuSelect(2),
                                onTap: () {},
                              ),
                              const Divider(
                                color: AppTheme.divider,
                                thickness: 0.5,
                              ),

                              SubMenuItem(
                                label: 'Add-ons',
                                isSelected: _selectedSubMenuIndex == 3,
                                onSelect: () => _onSubMenuSelect(3),
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
                      NavigationItem(
                        label: 'Settings',
                        leadingIconPath: 'icons/setting.svg',
                        isSelected: _selectedIndex == 5,
                        onTap: () => _updateIndex(5),
                      ),
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
