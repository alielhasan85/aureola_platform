import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/nav_rail.dart';
import '../widgets/custom_app_bar.dart';

class DesktopLayout extends ConsumerStatefulWidget {
  const DesktopLayout({super.key});

  @override
  ConsumerState<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<DesktopLayout> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          CustomNavigation(),

          // Main content area
          Expanded(
            child: Column(
              children: [
                // Custom AppBar that starts right after the navigation container
                CustomAppBar(),

                // Main content below the AppBar
                Expanded(
                  child: Center(
                    child: Text('content'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, IconData icon, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedIndex == index ? Colors.blue : Colors.grey[200],
          foregroundColor:
              _selectedIndex == index ? Colors.white : Colors.black,
          minimumSize: const Size(double.infinity, 60), // Full width button
        ),
        onPressed: _selectedIndex == index
            ? null // Disable if already selected
            : () {
                setState(() {
                  _selectedIndex = index;
                });
              },
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
