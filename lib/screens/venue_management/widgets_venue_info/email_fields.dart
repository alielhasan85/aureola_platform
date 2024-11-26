import 'package:flutter/material.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:aureola_platform/localization/localization.dart';

class EmailFields extends StatelessWidget {
  final double width;
  final TextEditingController emailController;

  EmailFields({
    super.key,
    required this.width,
    TextEditingController? emailController,
  }) : emailController = emailController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        cursorColor: AppTheme.accent,
        controller: emailController,
        decoration: AppTheme.inputDecoration(
          label: AppLocalizations.of(context)!.translate("email"),
        ).copyWith(
          hintText: AppLocalizations.of(context)!.translate("enter_email"),
        ),
      ),
    );
  }
}
