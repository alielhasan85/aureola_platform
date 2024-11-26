import 'package:flutter/material.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:aureola_platform/localization/localization.dart';

class DefaultLanguageDropdown extends StatefulWidget {
  final double width;

  const DefaultLanguageDropdown({Key? key, required this.width})
      : super(key: key);

  @override
  _DefaultLanguageDropdownState createState() =>
      _DefaultLanguageDropdownState();
}

class _DefaultLanguageDropdownState extends State<DefaultLanguageDropdown> {
  String? _selectedLanguage;

  final List<String> _languages = [
    'English',
    'Arabic',
    'French',
    // Add more languages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: AppTheme.inputDecoration(
          label: AppLocalizations.of(context)!.translate("default_language"),
        ),
        value: _selectedLanguage,
        items: _languages
            .map(
              (lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value;
          });
        },
      ),
    );
  }
}
