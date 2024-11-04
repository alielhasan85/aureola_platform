import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final VoidCallback onClose;

  const CustomDropdownMenu({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(),
        width: 200,
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true, // Prevents the list from expanding infinitely
          children: [
            ListTile(
              title: const Text('Option 1'),
              onTap: onClose,
            ),
            ListTile(
              title: const Text('Option 2'),
              onTap: onClose,
            ),
            ListTile(
              title: const Text('Option 3'),
              onTap: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
