import 'package:flutter/material.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:aureola_platform/localization/localization.dart';

class WebsiteFields extends StatelessWidget {
  final double width;
  final TextEditingController websiteController;

  WebsiteFields({
    super.key,
    required this.width,
    TextEditingController? websiteController,
  }) : websiteController = websiteController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        cursorColor: AppTheme.accent,
        controller: websiteController,
        decoration: AppTheme.inputDecoration(
          label: AppLocalizations.of(context)!.translate("web_site"),
        ).copyWith(
          hintText: AppLocalizations.of(context)!.translate("enter_web_site"),
        ),
      ),
    );
  }
}
