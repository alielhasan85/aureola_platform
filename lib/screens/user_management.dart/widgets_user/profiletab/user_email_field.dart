import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class UserEmailField extends StatelessWidget {
  final double width;
  final TextEditingController controller;

  const UserEmailField({
    super.key,
    required this.width,
    required this.controller,
    this.enabled = true,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('Email_'),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppTheme.paragraph,
            cursorColor: AppTheme.accent,
            controller: controller,
            enabled: enabled,
            decoration: AppTheme.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!.translate('Email'),
            ),
          ),
        ],
      ),
    );
  }
}
