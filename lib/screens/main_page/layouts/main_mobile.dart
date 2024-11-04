import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Responsive MainPage'),
        ),
        body: Center(
          child: Column(
            children: const [
              Text('Mobile Layout'),
              // Add more widgets specific to mobile view
            ],
          ),
        ));
  }
}
