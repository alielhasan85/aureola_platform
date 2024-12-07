// venue_address_field.dart
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the languageProvider from lang_providers.dart
//import 'package:aureola_platform/providers/lang_providers.dart';

class VenueAddressField extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController addressController;
  // final void Function(String country)? onCountryChanged;
  // final void Function(String state)? onStateChanged;
  // final void Function(String city)? onCityChanged;

  const VenueAddressField({
    super.key,
    required this.width,
    required this.addressController,
    // this.onCountryChanged,
    // this.onStateChanged,
    // this.onCityChanged,
  });

  @override
  ConsumerState<VenueAddressField> createState() => _VenueAddressFieldState();
}

class _VenueAddressFieldState extends ConsumerState<VenueAddressField> {
  @override
  Widget build(BuildContext context) {
    //final currentLanguage = ref.watch(languageProvider);
    final venue = ref.read(venueProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.translate("Detailed_address"),
                style: AppTheme.paragraph,
              ),
              const SizedBox(height: 6),
              TextField(
                onChanged: (text) {
                  ref.read(venueProvider.notifier).updateAddress(street: text);
                },
                style: AppTheme.paragraph,
                cursorColor: AppTheme.accent,
                controller:
                    TextEditingController(text: venue!.address.displayAddress),
                decoration: AppTheme.textFieldinputDecoration().copyWith(
                  hintText:
                      AppLocalizations.of(context)!.translate("enter_address"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
