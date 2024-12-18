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
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            enabled: false,
            obscureText: true,
            controller: TextEditingController(text: '********'),
            decoration: AppThemeLocal.textFieldinputDecoration(
              hint: '********',
            ),
          ),
        ],
      ),
    );
  }
}
