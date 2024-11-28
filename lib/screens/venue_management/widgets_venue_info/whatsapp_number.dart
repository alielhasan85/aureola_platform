import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/theme/theme.dart';

class WhatsappNumber extends StatefulWidget {
  final double width;
  final TextEditingController controller;

  WhatsappNumber({
    super.key,
    required this.width,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController();

  @override
  _WhatsappNumberState createState() => _WhatsappNumberState();
}

class _WhatsappNumberState extends State<WhatsappNumber> {
  String completeNumber = '';

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                print(completeNumber); // Output example: +97474716942
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
