// phone_number_field.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:intl_phone_field/phone_number.dart';

// class PhoneNumberField extends ConsumerStatefulWidget {
//   final double width;
//   final String? Function(PhoneNumber?)? validator;

//   const PhoneNumberField({
//     super.key,
//     required this.width,
//     this.validator,
//   });

//   @override
//   ConsumerState<PhoneNumberField> createState() => _PhoneNumberFieldState();
// }

// class _PhoneNumberFieldState extends ConsumerState<PhoneNumberField> {
//   late TextEditingController _phoneController;

//   @override
//   void initState() {
//     super.initState();
//     final venue = ref.read(venueProvider);
//     final phoneNumber = venue?.contact.phoneNumber ?? '';
//     _phoneController = TextEditingController(text: phoneNumber);
//   }

//   @override
//   void didUpdateWidget(covariant PhoneNumberField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final venue = ref.read(venueProvider);
//     final phoneNumber = venue?.contact.phoneNumber ?? '';
//     if (_phoneController.text != phoneNumber) {
//       _phoneController.text = phoneNumber;
//     }
//   }

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final languageCode = ref.watch(languageProvider);
//     final venue = ref.watch(venueProvider);

//     // Determine initial country code
//     final initialCountryCode =
//         (venue != null && venue.contact.countryCode.isNotEmpty)
//             ? venue.contact.countryCode
//             : 'US';

//     return SizedBox(
//       width: widget.width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             AppLocalizations.of(context)!.translate("phone_number"),
//             style: AppThemeLocal.paragraph,
//           ),
//           const SizedBox(height: 6),
//           IntlPhoneField(
//             languageCode: languageCode,
//             pickerDialogStyle: PickerDialogStyle(
//               width: widget.width,
//               countryNameStyle: AppThemeLocal.paragraph,
//             ),
//             controller: _phoneController,
//             style: AppThemeLocal.paragraph,
//             cursorColor: AppThemeLocal.accent,
//             decoration: AppThemeLocal.textFieldinputDecoration(
//               hint:
//                   AppLocalizations.of(context)!.translate("enter_phone_number"),
//             ),
//             initialCountryCode: initialCountryCode,
//             onChanged: (phone) {
//               ref
//                   .read(venueProvider.notifier)
//                   .updateContactPhoneNumber(phone.number);
//               ref
//                   .read(venueProvider.notifier)
//                   .updateContactCountryDial(phone.countryCode);
//             },
//             onCountryChanged: (country) {
//               ref
//                   .read(venueProvider.notifier)
//                   .updateContactCountryName(country.name);
//               ref
//                   .read(venueProvider.notifier)
//                   .updateContactCountryCode(country.code);
//             },
//             dropdownTextStyle: AppThemeLocal.paragraph,
//             textAlign: TextAlign.start,
//             validator: widget.validator, // Pass the generic validator here
//             autovalidateMode: AutovalidateMode
//                 .onUserInteraction, // Enables real-time validation
//           ),
//         ],
//       ),
//     );
//   }
// }

// phone_number_field.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneNumberField extends ConsumerStatefulWidget {
  final double width;
  final String? Function(PhoneNumber?)? validator;

  const PhoneNumberField({
    super.key,
    required this.width,
    this.validator,
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
  void didUpdateWidget(covariant PhoneNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final venue = ref.read(venueProvider);
    final phoneNumber = venue?.contact.phoneNumber ?? '';

    // Defer the controller text update until after this frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _phoneController.text != phoneNumber) {
        _phoneController.text = phoneNumber;
      }
    });
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
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          IntlPhoneField(
            languageCode: languageCode,
            pickerDialogStyle: PickerDialogStyle(
              width: widget.width,
              countryNameStyle: AppThemeLocal.paragraph,
            ),
            controller: _phoneController,
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            decoration: AppThemeLocal.textFieldinputDecoration(
              hint:
                  AppLocalizations.of(context)!.translate("enter_phone_number"),
            ),
            initialCountryCode: initialCountryCode,
            onChanged: (phone) {
              // User-initiated change
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
            dropdownTextStyle: AppThemeLocal.paragraph,
            textAlign: TextAlign.start,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
