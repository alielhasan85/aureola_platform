import 'package:aureola_platform/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

import 'package:intl_phone_field/intl_phone_field.dart';

class UserPhoneNumberField extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController controller;

  UserPhoneNumberField({
    super.key,
    required this.width,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController();

  @override
  ConsumerState<UserPhoneNumberField> createState() =>
      _UserPhoneNumberFieldState();
}

class _UserPhoneNumberFieldState extends ConsumerState<UserPhoneNumberField> {
  String completeNumber = '';

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(languageProvider);

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
          Directionality(
            textDirection: TextDirection.ltr,
            child: IntlPhoneField(
              languageCode: languageCode,
              pickerDialogStyle: PickerDialogStyle(
                width: widget.width,
                countryNameStyle: AppThemeLocal.paragraph,
              ),
              // Use the fetched language code
              controller: widget.controller,
              style: AppThemeLocal.paragraph,
              cursorColor: AppThemeLocal.accent,
              decoration: AppThemeLocal.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("enter_phone_number"),
              ),
              initialCountryCode: 'QA',
              onChanged: (phone) {
                setState(() {
                  completeNumber = phone.completeNumber;
                });
                // print(completeNumber); // Output example: +97474716942
              },
              dropdownTextStyle: AppThemeLocal.paragraph,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
