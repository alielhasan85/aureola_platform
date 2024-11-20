import 'package:aureola_platform/screens/main_page/widgets/custom_app_bar.dart';
import 'package:aureola_platform/screens/venue_management/menu_branding.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Responsive MainPage'),
        ),
        body: const Center(
          child: Expanded(
            child: Column(
              children: [
                const CustomAppBar(title: 'venue management'),
                Expanded(
                  child: Text(''),
                ),
              ],
            ),
          ),
        ));
  }
}
