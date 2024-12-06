// venue_address_field.dart
import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the languageProvider from lang_providers.dart
import 'package:aureola_platform/providers/lang_providers.dart';

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/lang_providers.dart';

class VenueAddressField extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController addressController;
  final void Function(String country)? onCountryChanged;
  final void Function(String state)? onStateChanged;
  final void Function(String city)? onCityChanged;

  const VenueAddressField({
    super.key,
    required this.width,
    required this.addressController,
    this.onCountryChanged,
    this.onStateChanged,
    this.onCityChanged,
  });

  @override
  _VenueAddressFieldState createState() => _VenueAddressFieldState();
}

class _VenueAddressFieldState extends ConsumerState<VenueAddressField> {
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  @override
  Widget build(BuildContext context) {
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
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
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
              if (widget.onCountryChanged != null && value != null) {
                widget.onCountryChanged!(value);
              }
            },
            onStateChanged: (value) {
              setState(() {
                stateValue = value;
              });
              if (widget.onStateChanged != null && value != null) {
                widget.onStateChanged!(value);
              }
            },
            onCityChanged: (value) {
              setState(() {
                cityValue = value;
              });
              if (widget.onCityChanged != null && value != null) {
                widget.onCityChanged!(value);
              }
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
                controller: widget.addressController,
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
