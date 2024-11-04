import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Table layout'),
        ),
        body: Center(
          child: Row(
            children: const [
              Expanded(child: Text('Tablet Layout')),
              // Add more widgets specific to tablet view
            ],
          ),
        ));
  }
}
