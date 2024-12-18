// default_language_dropdown.dart

import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DefaultLanguageDropdown extends StatefulWidget {
  final double width;
  final String initialLanguage;
  final ValueChanged<String>? onChanged;

  const DefaultLanguageDropdown({
    super.key,
    required this.width,
    this.initialLanguage = 'english_', // store a stable key here
    this.onChanged,
  });

  @override
  State<DefaultLanguageDropdown> createState() =>
      _DefaultLanguageDropdownState();
}

class _DefaultLanguageDropdownState extends State<DefaultLanguageDropdown> {
  String? _selectedLanguage;

  final languageKeys = ["English", "Arabic", "French", "Turkish"];

  @override
  void initState() {
    super.initState();
    // Initialize with the provided initialLanguage
    _selectedLanguage = widget.initialLanguage;
  }

  @override
  void didUpdateWidget(covariant DefaultLanguageDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent updates initialLanguage, reflect that change here
    if (widget.initialLanguage != oldWidget.initialLanguage) {
      setState(() {
        _selectedLanguage = widget.initialLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("default_language"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          DropdownSearch<String>(
            items: (filter, infiniteScrollProps) => languageKeys,
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              menuProps: const MenuProps(
                backgroundColor: AppThemeLocal.background,
                margin: EdgeInsets.only(top: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              constraints: BoxConstraints(
                maxWidth: widget.width,
              ),
              itemBuilder: (context, item, isDisabled, isSelected) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate(item),
                    style: AppThemeLocal.paragraph.copyWith(
                      color: AppThemeLocal.secondary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                );
              },
            ),
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem == null
                    ? AppLocalizations.of(context)!
                        .translate("Select_Default_Language")
                    : AppLocalizations.of(context)!.translate(selectedItem),
                style: AppThemeLocal.paragraph,
              );
            },
            selectedItem: _selectedLanguage,
            onChanged: (String? newKey) {
              setState(() {
                _selectedLanguage = newKey;
              });
              if (widget.onChanged != null && newKey != null) {
                widget.onChanged!(newKey);
              }
            },
            decoratorProps: DropDownDecoratorProps(
              baseStyle: AppThemeLocal.paragraph,
              decoration: AppThemeLocal.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("Select_Default_Language"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
