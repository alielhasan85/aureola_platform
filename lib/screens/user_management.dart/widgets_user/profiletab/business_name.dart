import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class BusinessNameField extends StatelessWidget {
  final double width;
  final TextEditingController controller;

  const BusinessNameField({
    super.key,
    required this.width,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('Company_Name'),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppTheme.paragraph,
            cursorColor: AppTheme.accent,
            controller: controller,
            decoration: AppTheme.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!.translate('Company_Name'),
            ),
          ),
        ],
      ),
    );
  }
}
