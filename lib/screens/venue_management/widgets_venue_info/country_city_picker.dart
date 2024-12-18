import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';

class CountryStateCityPicker extends StatefulWidget {
  final void Function(String country, String state, String city)?
      onLocationChanged;
  final String initialCountry;
  final String initialState;
  final String initialCity;
  final double width;

  const CountryStateCityPicker({
    super.key,
    this.onLocationChanged,
    this.initialCountry = '',
    this.initialState = '',
    this.initialCity = '',
    required this.width,
  });

  @override
  State<CountryStateCityPicker> createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';

  @override
  void initState() {
    super.initState();
    countryValue = widget.initialCountry;
    stateValue = widget.initialState;
    cityValue = widget.initialCity;
  }

  void _onCountryChanged(String value) {
    setState(() {
      countryValue = value;
      stateValue = '';
      cityValue = '';
    });
    _notifyParent();
  }

  void _onStateChanged(String? value) {
    setState(() {
      stateValue = value ?? '';
      cityValue = '';
    });
    _notifyParent();
  }

  void _onCityChanged(String? value) {
    setState(() {
      cityValue = value ?? '';
    });
    _notifyParent();
  }

  void _notifyParent() {
    if (widget.onLocationChanged != null) {
      widget.onLocationChanged!(countryValue, stateValue, cityValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: CSCPicker(
        showStates: true,
        showCities: true,
        layout: Layout.vertical,
        flagState: CountryFlag.DISABLE,
        dropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        selectedItemStyle: AppThemeLocal.paragraph,
        dropdownItemStyle: AppThemeLocal.paragraph.copyWith(
          fontSize: 15,
        ),
        countryDropdownLabel: "*Country",
        stateDropdownLabel: "*State",
        cityDropdownLabel: "*City",
        onCountryChanged: _onCountryChanged,
        onStateChanged: _onStateChanged,
        onCityChanged: _onCityChanged,
        currentCountry: countryValue.isEmpty ? null : countryValue,
        currentState: stateValue.isEmpty ? null : stateValue,
        currentCity: cityValue.isEmpty ? null : cityValue,
      ),
    );
  }
}
