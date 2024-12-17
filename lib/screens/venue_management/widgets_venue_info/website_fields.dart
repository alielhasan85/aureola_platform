import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class WebsiteFields extends StatefulWidget {
  final double width;
  final TextEditingController websiteController;
  final String? Function(String?)? validator; // Add validator parameter

  const WebsiteFields({
    super.key,
    required this.width,
    required this.websiteController, // Make websiteController required
    this.validator, // Initialize validator
  });

  @override
  State<WebsiteFields> createState() => _WebsiteFieldsState();
}

class _WebsiteFieldsState extends State<WebsiteFields> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("web_site"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            // Use TextFormField instead of TextField
            cursorColor: AppTheme.accent,
            controller: widget.websiteController,
            decoration: AppTheme.textFieldinputDecoration().copyWith(
              hintText:
                  AppLocalizations.of(context)!.translate("enter_web_site"),
            ),
            validator: widget.validator, // Attach the validator directly
            keyboardType: TextInputType.url, // Use appropriate keyboard
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // Real-time validation
          ),
        ],
      ),
    );
  }
}
