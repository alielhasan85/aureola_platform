import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebsiteFields extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("web_site"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            // Use TextFormField instead of TextField
            cursorColor: AppThemeLocal.accent,
            controller: websiteController,
            onChanged: (val) {
              // Correctly update the venue name in the provider
              ref.read(venueProvider.notifier).updateWebsite(val);
            },
            decoration: AppThemeLocal.textFieldinputDecoration().copyWith(
              hintText:
                  AppLocalizations.of(context)!.translate("enter_web_site"),
            ),
            validator: validator, // Attach the validator directly
            keyboardType: TextInputType.url, // Use appropriate keyboard
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // Real-time validation
          ),
        ],
      ),
    );
  }
}
