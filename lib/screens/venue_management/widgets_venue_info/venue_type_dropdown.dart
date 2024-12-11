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
    final venueTypeKeys = [
      "Fine_Dining",
      "Fast_Food",
      "Fast_Casual",
      "Drive_Thru",
      "Coffe_Shop",
      "Buffet",
      "Hotel_Room_Service",
      "Spa",
      "Bar",
      "Flower_Shop",
      "Beauty_Salon",
    ];
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
                    AppLocalizations.of(context)!.translate(item),
                    style: AppTheme.paragraph
                        .copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.start,
                  ),
                );
              },
            ),
            items: (filter, infiniteScrollProps) => venueTypeKeys,
            selectedItem: _selectedType, // store the key

            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem == null
                    ? AppLocalizations.of(context)!
                        .translate("Select_Type_of_your_business")
                    : AppLocalizations.of(context)!.translate(selectedItem),
                style: AppTheme.paragraph,
              );
            },
            onChanged: (String? newKey) {
              setState(() {
                _selectedType = newKey;
              });
              if (widget.onChanged != null && newKey != null) {
                widget.onChanged!(newKey); // <-- This should pass the key
              }
            },
            decoratorProps: DropDownDecoratorProps(
              baseStyle: AppTheme.paragraph,
              decoration: AppTheme.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("Select_Type_of_your_business"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
