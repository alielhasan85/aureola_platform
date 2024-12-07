import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// venue_type_dropdown.dart

class VenueTypeDropdown extends StatefulWidget {
  final double width;
  final String initialValue;
  final ValueChanged<String>? onChanged;

  const VenueTypeDropdown({
    super.key,
    required this.width,
    this.initialValue = '',
    this.onChanged,
  });

  @override
  State<VenueTypeDropdown> createState() => _VenueTypeDropdownState();
}

class _VenueTypeDropdownState extends State<VenueTypeDropdown> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedType with the passed initialValue
    _selectedType = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("venue_Business_type"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              menuProps: const MenuProps(
                backgroundColor: AppTheme.background,
                margin: EdgeInsets.only(top: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
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
              AppLocalizations.of(context)!.translate("Fine_Dining"),
              AppLocalizations.of(context)!.translate("Fast_Food"),
              AppLocalizations.of(context)!.translate("Fast_Casual"),
              AppLocalizations.of(context)!.translate("Drive_Thru"),
              AppLocalizations.of(context)!.translate("Coffe_Shop"),
              AppLocalizations.of(context)!.translate("Buffet"),
              AppLocalizations.of(context)!.translate("Hotel_Room_Service"),
              AppLocalizations.of(context)!.translate("Spa"),
              AppLocalizations.of(context)!.translate("Bar"),
              AppLocalizations.of(context)!.translate("Flower_Shop"),
              AppLocalizations.of(context)!.translate("Beauty_Salon"),
            ],
            decoratorProps: DropDownDecoratorProps(
              baseStyle: AppTheme.paragraph,
              decoration: AppTheme.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("Select_Type_of_your_business"),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue;
              });
              if (widget.onChanged != null && newValue != null) {
                widget.onChanged!(newValue);
              }
            },
            selectedItem: _selectedType,
          ),
        ],
      ),
    );
  }
}
