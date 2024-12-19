// lib/widgets/country_state_city_picker.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryStateCityPicker extends ConsumerWidget {
  final double width;

  const CountryStateCityPicker({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the draftVenueProvider for changes
    final draft = ref.watch(draftVenueProvider);

    // Safeguard against null values
    if (draft == null) {
      return SizedBox(
        width: width,
        child: Text(
          AppLocalizations.of(context)!.translate('no_data_available'),
          style: AppThemeLocal.paragraph,
        ),
      );
    }

    // Extract current selections from the provider
    final currentCountry =
        draft.address.country.isNotEmpty ? draft.address.country : null;
    final currentState =
        draft.address.state.isNotEmpty ? draft.address.state : null;
    final currentCity =
        draft.address.city.isNotEmpty ? draft.address.city : null;

    return SizedBox(
      width: width,
      child: CSCPicker(
        key: ValueKey(
            '${currentCountry ?? ''}_${currentState ?? ''}_${currentCity ?? ''}'),
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
        dropdownItemStyle: AppThemeLocal.paragraph.copyWith(fontSize: 15),
        countryDropdownLabel: "*Country",
        stateDropdownLabel: "*State",
        cityDropdownLabel: "*City",
        onCountryChanged: (value) {
          if (value.isNotEmpty) {
            ref
                .read(draftVenueProvider.notifier)
                .updateCountryStateCity(country: value);
          }
        },
        onStateChanged: (value) {
          if (value != null && value.isNotEmpty) {
            ref
                .read(draftVenueProvider.notifier)
                .updateCountryStateCity(state: value);
          }
        },
        onCityChanged: (value) {
          if (value != null && value.isNotEmpty) {
            ref
                .read(draftVenueProvider.notifier)
                .updateCountryStateCity(city: value);
          }
        },
        currentCountry: currentCountry,
        currentState: currentState,
        currentCity: currentCity,
      ),
    );
  }
}
