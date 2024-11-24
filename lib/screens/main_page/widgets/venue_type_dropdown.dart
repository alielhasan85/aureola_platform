import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VenueTypeDropdown extends StatefulWidget {
  const VenueTypeDropdown({super.key});

  @override
  State<VenueTypeDropdown> createState() => _VenueTypeDropdownState();
}

class _VenueTypeDropdownState extends State<VenueTypeDropdown> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: false, // Enables the search box
        searchFieldProps: TextFieldProps(
          cursorColor: AppTheme.accent,
          decoration: AppTheme.inputDecoration(
            label: AppLocalizations.of(context)!.translate("search_venue_type"),
          ),
        ),
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
      ], // Use 'items' for static lists
      decoratorProps: DropDownDecoratorProps(
        decoration: AppTheme.inputDecoration(
          label: AppLocalizations.of(context)!.translate("venue_type"),
        ).copyWith(
          hintText:
              AppLocalizations.of(context)!.translate("Type_of_your_business"),
        ),
      ),

      onChanged: (String? newValue) {
        setState(() {
          _selectedType = newValue; // Update the selected type
        });
      },
      selectedItem: _selectedType,
    );
  }
}
