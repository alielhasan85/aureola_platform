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
  List<String> items = [
    'Bistro',
    'Cafe',
    'Hotel',
    'Fast Food',
    'Resort'
  ]; // Static list

  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: true, // Enables the search box
        searchFieldProps: TextFieldProps(
          cursorColor: AppTheme.accent,
          decoration: AppTheme.inputDecoration(
            label: AppLocalizations.of(context)!.translate("search_venue_type"),
          ),
        ),
      ),
      items: (filter, infiniteScrollProps) => [
        "Menu",
        "Dialog",
        "Modal",
        "BottomSheet"
      ], // Use 'items' for static lists
      decoratorProps: DropDownDecoratorProps(
        decoration: AppTheme.inputDecoration(
          label: AppLocalizations.of(context)!.translate("venue_type"),
        ).copyWith(
          hintText:
              AppLocalizations.of(context)!.translate("select_venue_type"),
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



// decoratorProps: DropDownDecoratorProps(
//         decoration: AppTheme.inputDecoration(
//           label: AppLocalizations.of(context)!.translate("venue_type"),
//         ).copyWith(
//           hintText: AppLocalizations.of(context)!.translate("select_venue_type"),
//         ),
//       ),