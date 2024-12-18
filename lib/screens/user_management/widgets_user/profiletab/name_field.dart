import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class NameField extends StatelessWidget {
  final double width;
  final TextEditingController controller;

  const NameField({
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
            AppLocalizations.of(context)!.translate("Name"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            controller: controller,
            decoration: AppThemeLocal.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!.translate("Name_"),
            ),
          ),
        ],
      ),
    );
  }
}
