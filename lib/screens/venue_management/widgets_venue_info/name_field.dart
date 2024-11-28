import 'package:flutter/material.dart';
import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/theme/theme.dart';

class VenueNameField extends StatelessWidget {
  final double width;
  final TextEditingController controller;

  VenueNameField({
    super.key,
    required this.width,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("venue_name"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppTheme.paragraph,
            cursorColor: AppTheme.accent,
            controller: controller,
            decoration: AppTheme.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!
                  .translate("enter_venue_display_name"),
            ),
          ),
        ],
      ),
    );
  }
}
