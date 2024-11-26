import 'package:flutter/material.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:aureola_platform/localization/localization.dart';

class VenueAddressField extends StatefulWidget {
  final double width;

  const VenueAddressField({Key? key, required this.width}) : super(key: key);

  @override
  _VenueAddressFieldState createState() => _VenueAddressFieldState();
}

class _VenueAddressFieldState extends State<VenueAddressField> {
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
            countrySearchPlaceholder: "Country",
            stateSearchPlaceholder: "State",
            citySearchPlaceholder: "City",
            countryDropdownLabel: "*Country",
            stateDropdownLabel: "*State",
            cityDropdownLabel: "*City",
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
          child: TextField(
            cursorColor: AppTheme.accent,
            controller: addressController,
            decoration: AppTheme.inputDecoration(
              label:
                  AppLocalizations.of(context)!.translate("Detailed_address"),
            ).copyWith(
              hintText:
                  AppLocalizations.of(context)!.translate("enter_address"),
            ),
          ),
        ),
      ],
    );
  }
}
