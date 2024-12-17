import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class EmailField extends StatelessWidget {
  final double width;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const EmailField({
    super.key,
    required this.width,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("email"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            style: AppTheme.paragraph,
            cursorColor: AppTheme.accent,
            controller: controller,
            decoration: AppTheme.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!.translate("enter_email"),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
