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
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            controller: controller,
            decoration: AppThemeLocal.textFieldinputDecoration(
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
