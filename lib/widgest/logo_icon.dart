// lib/widgets/app_logo.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Naya',
          style: AppTheme.titleAureola,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          'Platform',
          style: AppTheme.titlePlatform,
        ),
      ],
    );
  }
}
