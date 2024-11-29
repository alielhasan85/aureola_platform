// venue_address_field.dart
import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the languageProvider from lang_providers.dart
import 'package:aureola_platform/providers/lang_providers.dart';

class VenueAddressField extends ConsumerStatefulWidget {
  final double width;

  const VenueAddressField({super.key, required this.width});

  @override
  _VenueAddressFieldState createState() => _VenueAddressFieldState();
}

class _VenueAddressFieldState extends ConsumerState<VenueAddressField> {
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  final TextEditingController addressController = TextEditingController();
  String address = "";

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the languageProvider to get the current language
    final currentLanguage = ref.watch(languageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: widget.width,
          child: CSCPicker(
            layout: Layout.horizontal,
            showStates: true,
            showCities: true,
            flagState: CountryFlag.DISABLE,
            dropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            disabledDropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            // Replace placeholders and labels with localized strings
            countrySearchPlaceholder: AppLocalizations.of(context)!
                .translate("country_search_placeholder"),
            stateSearchPlaceholder: AppLocalizations.of(context)!
                .translate("state_search_placeholder"),
            citySearchPlaceholder: AppLocalizations.of(context)!
                .translate("city_search_placeholder"),
            countryDropdownLabel: AppLocalizations.of(context)!
                .translate("country_dropdown_label"),
            stateDropdownLabel:
                AppLocalizations.of(context)!.translate("state_dropdown_label"),
            cityDropdownLabel:
                AppLocalizations.of(context)!.translate("city_dropdown_label"),
            selectedItemStyle: AppTheme.paragraph,
            dropdownHeadingStyle:
                AppTheme.paragraph.copyWith(fontWeight: FontWeight.bold),
            dropdownItemStyle: AppTheme.paragraph,
            dropdownDialogRadius: 10.0,
            searchBarRadius: 10.0,
            onCountryChanged: (value) {
              setState(() {
                countryValue = value;
              });
            },
            onStateChanged: (value) {
              setState(() {
                stateValue = value;
              });
            },
            onCityChanged: (value) {
              setState(() {
                cityValue = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
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
                style: AppTheme.paragraph,
                cursorColor: AppTheme.accent,
                controller: addressController,
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
