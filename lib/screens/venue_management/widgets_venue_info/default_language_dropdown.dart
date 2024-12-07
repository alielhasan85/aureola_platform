import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DefaultLanguageDropdown extends StatefulWidget {
  final double width;
  final String initialLanguage;
  final ValueChanged<String>? onChanged; // new callback

  const DefaultLanguageDropdown(
      {super.key,
      this.initialLanguage = 'english',
      required this.width,
      this.onChanged});

  @override
  State<DefaultLanguageDropdown> createState() =>
      _DefaultLanguageDropdownState();
}

class _DefaultLanguageDropdownState extends State<DefaultLanguageDropdown> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedType with the passed initialValue
    _selectedLanguage = widget.initialLanguage;
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
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              menuProps: const MenuProps(
                backgroundColor: AppTheme.background,
                margin: EdgeInsets.only(top: 12, right: 0),
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
                      vertical: 12.0, horizontal: 12),
                  child: Text(
                    item,
                    style: AppTheme.paragraph
                        .copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.start,
                  ),
                );
              },
            ),
            items: (filter, infiniteScrollProps) => [
              AppLocalizations.of(context)!.translate("english_"),
              AppLocalizations.of(context)!.translate("arabic_"),
              AppLocalizations.of(context)!.translate("french_"),
            ],
            decoratorProps: DropDownDecoratorProps(
              baseStyle: AppTheme.paragraph,
              decoration: AppTheme.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("Select_Default_Language"),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue;
              });
              if (widget.onChanged != null && newValue != null) {
                widget.onChanged!(newValue);
              }
            },
            selectedItem: _selectedLanguage,
          ),
        ],
      ),
    );
  }
}
