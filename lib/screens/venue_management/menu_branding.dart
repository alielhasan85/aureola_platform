import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';

class MenuBranding extends StatelessWidget {
  const MenuBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: name dynamic from firebase
          // TODO: background is changed in case of scrol down maybe to remove this header or make it prt of app bar
          HeaderContainer(userName: 'Ali Elhassan'),
          const SizedBox(height: 10), // Spacer

          // TabBar Section
          SizedBox(
            width: 160 * 4,
            height: 40,
            child: TabBar(
              unselectedLabelStyle: AppTheme.tabBarItemText,
              labelStyle: AppTheme.tabBarItemText.copyWith(
                  fontWeight: FontWeight.w600, color: AppTheme.accent),
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.secondary,
              indicatorColor: AppTheme.accent,
              indicatorWeight: 2.0,
              tabs: const [
                Tab(text: 'Venue Details'),
                Tab(text: 'Branding & Design'),
                Tab(text: 'Flash Screen'),
              ],
            ),
          ),

          const SizedBox(height: 16), // Spacer

          const SizedBox(height: 24), // Spacer

          Expanded(
            child: TabBarView(
              children: [
                // Venue Details Content
                Center(
                  child: Container(
                    width: 485,
                    height: 600,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Venue Details Content',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                // Branding & Design Content
                Center(
                  child: Container(
                    width: 485,
                    height: 600,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Branding & Design Content',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                // Flash Screen Content
                Center(
                  child: Container(
                    width: 485,
                    height: 600,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Flash Screen Content',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 64), // Space before footer text

          // Footer text
          const Center(
            child: Text(
              'Copy Right Reserved Aureola Platform 2024',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 8), // Space before footer text

          // Bottom container bar
          Container(
            width: double.infinity,
            height: 6,
            color: const Color(0xFFFFF4EE),
          ),
        ],
      ),
    );
  }
}
