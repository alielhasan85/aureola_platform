// lib/widgets/app_logo.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Naya',
            style: AppThemeLocal.titleAureola,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Platform',
            style: AppThemeLocal.titlePlatform,
          ),
        ],
      ),
    );
  }
}
