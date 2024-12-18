import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';

class PlanTab extends StatelessWidget {
  const PlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Plan Details',
        style: AppThemeLocal.paragraph,
      ),
    );
  }
}
