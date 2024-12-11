import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';

class BillingTab extends StatelessWidget {
  const BillingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Billing Information',
        style: AppTheme.paragraph,
      ),
    );
  }
}
