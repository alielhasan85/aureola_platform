import 'package:aureola_platform/providers/lang_providers.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhatsappNumber extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController controller;

  WhatsappNumber({
    super.key,
    required this.width,
    required this.controller,
  });

  @override
  ConsumerState<WhatsappNumber> createState() => _WhatsappNumberState();
}

class _WhatsappNumberState extends ConsumerState<WhatsappNumber> {
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
            AppLocalizations.of(context)!.translate("whatsapp_number"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.ltr,
            child: IntlPhoneField(
              languageCode: languageCode,
              pickerDialogStyle: PickerDialogStyle(
                width: widget.width,
                countryNameStyle: AppTheme.paragraph,
              ),
              controller: widget.controller,
              style: AppTheme.paragraph,
              cursorColor: AppTheme.accent,
              decoration: AppTheme.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("enter_whatsapp_number"),
              ),
              initialCountryCode: 'QA',
              onChanged: (phone) {
                setState(() {
                  completeNumber = phone.completeNumber;
                });
                //print(completeNumber); // Output example: +97474716942
              },
              dropdownTextStyle:
                  AppTheme.paragraph.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}