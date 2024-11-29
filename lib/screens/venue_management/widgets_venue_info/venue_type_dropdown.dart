import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VenueTypeDropdown extends StatefulWidget {
  final double width;
  const VenueTypeDropdown({super.key, required this.width});

  @override
  State<VenueTypeDropdown> createState() => _VenueTypeDropdownState();
}

class _VenueTypeDropdownState extends State<VenueTypeDropdown> {
  String? _selectedType;

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
              menuProps: const MenuProps(
                backgroundColor: AppTheme.background,
                margin: EdgeInsets.only(top: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
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

            // Use 'items' for static lists
            decoratorProps: DropDownDecoratorProps(
              baseStyle: AppTheme.paragraph,
              decoration: AppTheme.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("Select_Type_of_your_business"),
              ),
            ),

            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue; // Update the selected type
              });
            },
            selectedItem: _selectedType,
          ),
        ],
      ),
    );
  }
}
