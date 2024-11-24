import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CustomPhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CustomPhoneNumberField({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomPhoneNumberFieldState createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  Country _selectedCountry = Country(
    phoneCode: '974',
    countryCode: 'QA',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Qatar',
    example: 'Qatar',
    displayName: 'Qatar',
    displayNameNoCountryCode: 'QA',
    e164Key: '',
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      decoration: AppTheme.inputDecoration(
        label: AppLocalizations.of(context)!.translate("phone_number"),
      ).copyWith(prefixIcon: _buildCountryCodeDropdown()),
      onChanged: (value) {
        String completeNumber = '+${_selectedCountry.phoneCode}$value';
        widget.onChanged(completeNumber);
      },
    );
  }

  Widget _buildCountryCodeDropdown() {
    return Container(
      width: 100, // Set the width you desire
      child: InkWell(
        onTap: () {
          _showCountryPicker();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+${_selectedCountry.phoneCode}',
              style: TextStyle(color: AppTheme.secondary),
            ),
            Icon(Icons.arrow_drop_down, color: AppTheme.secondary),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        backgroundColor: AppTheme.background,
        textStyle: TextStyle(color: AppTheme.secondary),
        bottomSheetHeight: 500, // Adjust the height as needed
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        inputDecoration: AppTheme.inputDecoration(
          label: AppLocalizations.of(context)!.translate("search"),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }
}
