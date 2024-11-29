import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
        backgroundColor: AppTheme.lightPeach,
      ),
    );
  }
}
