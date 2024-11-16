import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:flutter/material.dart';

class VenueManagementContent extends StatelessWidget {
  const VenueManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Number of tabs
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TODO: name dynamic from firebase
          HeaderContainer(userName: 'Ali Elhassan'),

          const SizedBox(height: 24), // Spacer

          // Main content card
          Center(
            child: Container(
              width: 485,
              height: 600,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x3F000000),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0x66000000),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Content here',
                  style: TextStyle(fontSize: 16),
                ),
              ),
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
