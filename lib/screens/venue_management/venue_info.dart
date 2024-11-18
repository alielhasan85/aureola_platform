import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({super.key});

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update UI when the tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return Center(child: Text('Venue Details Content'));
      case 1:
        return Center(child: Text('Social Media Content'));
      case 2:
        return Center(child: Text('Pricing Options Content'));
      case 3:
        return Center(child: Text('Language Options Content'));
      default:
        return Center(child: Text('Unknown Tab'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              HeaderContainer(userName: 'Ali Elhassan'),
              // Tab Bar Section
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppTheme.accent,
                unselectedLabelColor: AppTheme.primary,
                indicatorColor: AppTheme.accent,
                tabs: const [
                  Tab(text: 'Venue Details'),
                  Tab(text: 'Social Media'),
                  Tab(text: 'Pricing Options'),
                  Tab(text: 'Language Options'),
                ],
              ),

              // Dynamic Content Container
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 50,
                    top: 28,
                  ),
                  child: Container(
                    width: 485,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(60),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x4C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: _getTabContent(_tabController.index),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Fixed Footer
        const AppFooter(),
      ],
    );
  }
}
