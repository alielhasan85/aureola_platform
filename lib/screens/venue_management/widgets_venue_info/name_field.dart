// lib/widgets/venue_name_field.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/venue_provider.dart';

class VenueNameField extends ConsumerWidget {
  final double width;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const VenueNameField({
    Key? key,
    required this.width,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("venue_name"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            onChanged: (val) {
              // Correctly update the venue name in the provider
              ref.read(venueProvider.notifier).updateVenueName(val);
            },
            controller: controller,
            validator: validator,
            decoration: AppThemeLocal.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("enter_venue_display_name")),
          ),
        ],
      ),
    );
  }
}
