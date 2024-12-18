import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class TaglineWidget extends StatelessWidget {
  final double width;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const TaglineWidget({
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
            AppLocalizations.of(context)!.translate("Tagline"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            controller: controller,
            decoration: AppThemeLocal.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!
                  .translate("enter_venue_tagline"),
            ),
            validator: validator, // Attach the validator here
          ),
        ],
      ),
    );
  }
}
