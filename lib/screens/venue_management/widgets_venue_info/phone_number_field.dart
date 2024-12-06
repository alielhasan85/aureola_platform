// lib/screens/user_management.dart/widgets_user/profiletab/phone_number_field.dart

import 'package:aureola_platform/providers/lang_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class PhoneNumberField extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController controller;

  const PhoneNumberField({
    super.key,
    required this.width,
    required this.controller,
  });

  @override
  ConsumerState<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends ConsumerState<PhoneNumberField> {
  String completeNumber = '';

  @override
  Widget build(BuildContext context) {
    // Fetch the current language code from the provider
    final languageCode = ref.watch(languageProvider);

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
          Directionality(
            textDirection: TextDirection.ltr,
            child: IntlPhoneField(
              languageCode: languageCode, // Use the fetched language code
              pickerDialogStyle: PickerDialogStyle(
                width: widget.width,
                countryNameStyle: AppTheme.paragraph,
              ),
              controller: widget.controller,
              style: AppTheme.paragraph,
              cursorColor: AppTheme.accent,
              decoration: AppTheme.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("enter_phone_number"),
              ),
              initialCountryCode: 'QA',
              onChanged: (phone) {
                setState(() {
                  completeNumber = phone.completeNumber;
                });
                // Optionally handle the complete number
              },
              dropdownTextStyle: AppTheme.paragraph,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  // No need to override dispose() since the controller is managed by the parent
}
