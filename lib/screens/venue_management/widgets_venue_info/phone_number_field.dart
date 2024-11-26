import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:aureola_platform/theme/theme.dart';

class PhoneNumberField extends StatefulWidget {
  final double width;

  const PhoneNumberField({Key? key, required this.width}) : super(key: key);

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  String completeNumber = '';
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: IntlPhoneField(
        controller: _phoneNumberController,
        decoration: AppTheme.inputDecoration(
          label: 'Phone Number',
        ),
        initialCountryCode: 'QA',
        onChanged: (phone) {
          setState(() {
            completeNumber = phone.completeNumber;
          });
          print(completeNumber); // Output: +97474716942
        },
      ),
    );
  }
}
