// venue_type_dropdown.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/providers.dart';

class VenueTypeDropdown extends ConsumerStatefulWidget {
  final double width;
  final String initialValue;
  final ValueChanged<String>? onChanged;

  const VenueTypeDropdown({
    super.key,
    required this.width,
    this.initialValue = 'Fine_Dining',
    this.onChanged,
  });

  @override
  ConsumerState<VenueTypeDropdown> createState() => _VenueTypeDropdownState();
}

class _VenueTypeDropdownState extends ConsumerState<VenueTypeDropdown> {
  String? _selectedType;

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

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant VenueTypeDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedType = widget.initialValue;
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
            AppLocalizations.of(context)!.translate("venue_Business_type") ??
                'Venue Business Type',
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              menuProps: const MenuProps(
                backgroundColor: AppThemeLocal.background,
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
                    AppLocalizations.of(context)!.translate(item) ?? item,
                    style: AppThemeLocal.paragraph,
                    textAlign: TextAlign.start,
                  ),
                );
              },
            ),
            items: (filter, infiniteScrollProps) => venueTypeKeys,
            selectedItem: _selectedType,
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem == null
                    ? AppLocalizations.of(context)!
                            .translate("Select_Type_of_your_business") ??
                        'Select Type of Your Business'
                    : AppLocalizations.of(context)!.translate(selectedItem) ??
                        selectedItem,
                style: AppThemeLocal.paragraph,
              );
            },
            onChanged: (String? newKey) {
              setState(() {
                _selectedType = newKey;
              });
              if (newKey != null) {
                // Update draftVenueProvider
                ref.read(draftVenueProvider.notifier).updateVenueType(newKey);
                if (widget.onChanged != null) {
                  widget.onChanged!(newKey);
                }
              }
            },
            decoratorProps: DropDownDecoratorProps(
              baseStyle: AppThemeLocal.paragraph,
              decoration: AppThemeLocal.textFieldinputDecoration(
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
