import 'package:aureola_platform/providers/lang_providers.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class PhoneNumberField extends ConsumerStatefulWidget {
  final double width;

  const PhoneNumberField({
    super.key,
    required this.width,
  });

  @override
  ConsumerState<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends ConsumerState<PhoneNumberField> {
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final venue = ref.read(venueProvider);
    final phoneNumber = venue?.contact.phoneNumber ?? '';
    _phoneController = TextEditingController(text: phoneNumber);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(languageProvider);
    final venue = ref.watch(venueProvider);

    // Determine initial country code
    final initialCountryCode =
        (venue != null && venue.contact.countryCode.isNotEmpty)
            ? venue.contact.countryCode
            : 'US';

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("phone_number"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          // Remove explicit Directionality unless truly needed
          Directionality(
            textDirection: TextDirection.ltr,
            child: IntlPhoneField(
              languageCode: languageCode,
              pickerDialogStyle: PickerDialogStyle(
                width: widget.width,
                countryNameStyle: AppTheme.paragraph,
              ),
              controller: _phoneController,
              style: AppTheme.paragraph,
              cursorColor: AppTheme.accent,
              decoration: AppTheme.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("enter_phone_number"),
              ),
              initialCountryCode: initialCountryCode,
              onChanged: (phone) {
                ref
                    .read(venueProvider.notifier)
                    .updateContactPhoneNumber(phone.number);
                ref
                    .read(venueProvider.notifier)
                    .updateContactCountryDial(phone.countryCode);
              },
              onCountryChanged: (country) {
                ref
                    .read(venueProvider.notifier)
                    .updateContactCountryName(country.name);
                ref
                    .read(venueProvider.notifier)
                    .updateContactCountryCode(country.code);
              },
              dropdownTextStyle: AppTheme.paragraph,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
