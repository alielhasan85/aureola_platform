import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ensure the footer is compact
      children: [
        Center(
          child: Text(
            AppLocalizations.of(context)!.translate("copyright"),
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 8,
          color: AppTheme.background2,
        ),
      ],
    );
  }
}
