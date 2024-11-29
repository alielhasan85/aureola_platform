import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("web_site"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            cursorColor: AppTheme.accent,
            controller: websiteController,
            decoration: AppTheme.textFieldinputDecoration().copyWith(
              hintText:
                  AppLocalizations.of(context)!.translate("enter_web_site"),
            ),
          ),
        ],
      ),
    );
  }
}
