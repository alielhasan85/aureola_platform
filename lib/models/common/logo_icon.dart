// lib/widgets/app_logo.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Naya',
          style: AppTheme.titleAureola,
        ),
        Text(
          'Platform',
          style: AppTheme.titlePlatform,
        ),
      ],
    );
  }
}
