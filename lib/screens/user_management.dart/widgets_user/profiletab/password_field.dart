import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class PasswordField extends StatelessWidget {
  final double width;

  const PasswordField({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('Password'),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppTheme.paragraph,
            cursorColor: AppTheme.accent,
            enabled: false,
            obscureText: true,
            controller: TextEditingController(text: '********'),
            decoration: AppTheme.textFieldinputDecoration(
              hint: '********',
            ),
          ),
        ],
      ),
    );
  }
}
