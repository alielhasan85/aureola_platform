import 'package:flutter/material.dart';
import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/theme/theme.dart';

class VenueNameField extends StatelessWidget {
  final double width;
  final TextEditingController controller;

  VenueNameField({
    Key? key,
    required this.width,
    TextEditingController? controller,
  })  : controller = controller ?? TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        cursorColor: AppTheme.accent,
        controller: controller,
        decoration: AppTheme.inputDecoration(
          label: AppLocalizations.of(context)!.translate("venue_name"),
        ),
      ),
    );
  }
}