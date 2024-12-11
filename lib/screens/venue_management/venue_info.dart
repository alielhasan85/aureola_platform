import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/address_field.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/email_fields.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/location_picker_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/map_picker_dialog.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/venue_type_dropdown.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/alcohol_option_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/default_language_dropdown.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/phone_number_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/name_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/website_fields.dart';
import 'package:aureola_platform/service/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({super.key});

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo> {
  // 1 venue name
  late TextEditingController _venueNameController;

  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;

  String? _selectedVenueType;
  String? _selectedDefaultLanguage;
  bool? _alcoholOption;

  LatLng? _selectedLocation;
  String? _mapImageUrl;

  @override
  void initState() {
    super.initState();

    final venue = ref.read(venueProvider);
    if (venue != null) {
      _venueNameController = TextEditingController(text: venue.venueName);
      _emailController = TextEditingController(text: venue.contact.email);
      _websiteController = TextEditingController(text: venue.contact.website);
      _addressController =
          TextEditingController(text: venue.address.displayAddress);

      // Store venue type key
      _selectedVenueType = venue.additionalInfo?['venueType'] ?? "Fine_Dining";

      // Store default language as a key
      // If venue.languageOptions includes something like "English", you need to map it:
      // If it's already a known key from languageKeys:
      //   _selectedDefaultLanguage = venue.languageOptions.isNotEmpty ? venue.languageOptions.first : "english_";
      // Otherwise, map "English" -> "english_", "Arabic" -> "arabic_", etc.
      _selectedDefaultLanguage = (venue.languageOptions.isNotEmpty)
          ? venue.languageOptions
              .first // ensure this returns "english_" or similar key
          : "english_";

      _alcoholOption = venue.additionalInfo?['sellAlcohol'] ?? false;
      _selectedLocation = venue.address.location;
      _mapImageUrl = venue.additionalInfo!['mapImageUrl'];
    } else {
      _venueNameController = TextEditingController();
      _emailController = TextEditingController();
      _websiteController = TextEditingController();
      _addressController = TextEditingController();
      _selectedVenueType = "Fine_Dining";
      _selectedDefaultLanguage = "english_";
    }
  }

  @override
  void dispose() {
    _venueNameController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine container width based on breakpoints
    double containerWidth;
    if (screenWidth >= Breakpoints.desktop) {
      containerWidth = screenWidth * 0.5;
    } else if (screenWidth >= Breakpoints.tablet) {
      containerWidth = screenWidth * 0.7;
    } else {
      containerWidth = double.infinity; // Full width on mobile
    }

    final isTabletOrDesktop = screenWidth >= Breakpoints.tablet;

    return Column(
      children: [
        if (isTabletOrDesktop)
          HeaderContainer(
            userName: user!.name,
          ),
        Expanded(
          child: Padding(
            padding: isTabletOrDesktop
                ? const EdgeInsets.symmetric(horizontal: 20)
                : EdgeInsets.zero,
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.symmetric(
                vertical: isTabletOrDesktop ? 30 : 12,
              ),
              decoration: isTabletOrDesktop ? AppTheme.cardDecoration : null,
              child: SingleChildScrollView(
                child: Padding(
                  padding: isTabletOrDesktop
                      ? const EdgeInsets.symmetric(horizontal: 30)
                      : const EdgeInsets.symmetric(horizontal: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final containerWidth = constraints.maxWidth;

                      // Decide the number of columns
                      int columns = isTabletOrDesktop ? 2 : 1;

                      // Calculate the width for each field
                      double spacing = 16;
                      double fieldWidth = columns == 1
                          ? containerWidth
                          : (containerWidth - spacing) / 2;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildHeader(isTabletOrDesktop),
                          const SizedBox(height: 16),
                          _buildFormFields(
                              columns, fieldWidth, spacing, containerWidth),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isTabletOrDesktop) const AppFooter(),
      ],
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("venue_info_title"),
          style: AppTheme.appBarTitle,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isLargeScreen ? 100 : 50),
            ),
            elevation: 5,
            padding: isLargeScreen
                ? const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
                : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          onPressed: () {
            // TODO: Add new venue functionality
          },
          child: Text(
            AppLocalizations.of(context)!.translate("Add_new_venue"),
            style: AppTheme.buttonText.copyWith(
              fontSize: isLargeScreen ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(
      int columns, double fieldWidth, double spacing, double containerWidth) {
    if (columns == 1) {
      // Mobile layout: fields in a single column
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VenueNameField(width: fieldWidth, controller: _venueNameController),
          const SizedBox(height: 16),
          VenueTypeDropdown(
            width: fieldWidth,
            initialValue: _selectedVenueType ??
                AppLocalizations.of(context)!
                    .translate("Select_Type_of_your_business"),
            onChanged: (val) {
              setState(() {
                _selectedVenueType = val; // Update local state
              });
              ref
                  .read(venueProvider.notifier)
                  .updateVenueType(val); // Update notifier
            },
          ),
          const SizedBox(height: 16),
          AlcoholOptionField(
            width: fieldWidth,
            onChanged: (val) => setState(() => _alcoholOption = val),
          ),
          const SizedBox(height: 16),
          DefaultLanguageDropdown(
            width: fieldWidth,
            initialLanguage: _selectedDefaultLanguage ??
                "english_", // ensure a stable key is provided
            onChanged: (val) {
              setState(() => _selectedDefaultLanguage = val);
              ref.read(venueProvider.notifier).updateDefaultLanguage(val);
            },
          ),
          const SizedBox(height: 16),
          WebsiteFields(
              width: fieldWidth, websiteController: _websiteController),
          const SizedBox(height: 16),
          EmailField(width: fieldWidth, controller: _emailController),
          const SizedBox(height: 16),
          PhoneNumberField(width: fieldWidth),
          const SizedBox(height: 16),
          _buildPickupLocationSection(containerWidth),
          const SizedBox(height: 16),
          VenueAddressField(
            width: fieldWidth,
            addressController: _addressController,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _handleSave,
              child: Text(AppLocalizations.of(context)!.translate('save')),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VenueNameField(width: fieldWidth, controller: _venueNameController),
          const SizedBox(height: 24),
          Divider(color: AppTheme.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 6),
          Row(
            children: [
              PhoneNumberField(width: fieldWidth),
              SizedBox(width: spacing),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              EmailField(
                width: fieldWidth,
                controller: _emailController,
              ),
              SizedBox(width: spacing),
              WebsiteFields(
                  width: fieldWidth, websiteController: _websiteController)
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: AppTheme.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 6),
          Row(
            children: [
              VenueTypeDropdown(
                width: fieldWidth,
                initialValue: _selectedVenueType ??
                    AppLocalizations.of(context)!
                        .translate("Select_Type_of_your_business"),
                onChanged: (val) {
                  setState(() {
                    _selectedVenueType = val; // Update local state
                  });
                  ref
                      .read(venueProvider.notifier)
                      .updateVenueType(val); // Update notifier
                },
              ),
              SizedBox(width: spacing),
              DefaultLanguageDropdown(
                width: fieldWidth,
                initialLanguage: _selectedDefaultLanguage ??
                    "english_", // ensure a stable key is provided
                onChanged: (val) {
                  setState(() => _selectedDefaultLanguage = val);
                  ref.read(venueProvider.notifier).updateDefaultLanguage(val);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          AlcoholOptionField(width: fieldWidth),
          const SizedBox(height: 24),
          Divider(color: AppTheme.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 6),
          _buildPickupLocationSection(containerWidth),
          const SizedBox(height: 12),
          VenueAddressField(
            width: fieldWidth,
            addressController: _addressController,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _handleSave,
              child: Text(AppLocalizations.of(context)!.translate('save')),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPickupLocationSection(double containerWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => MapPickerDialog(
                containerWidth: containerWidth,
              ),
            );
            if (result != null) {
              setState(() {
                ref
                    .read(venueProvider.notifier)
                    .updateMapImageUrl(result['imageUrl']);
                _selectedLocation = result['location'];
                ref.read(venueProvider.notifier).updateAddress(
                      location: result['location'],
                    );
              });
            }
          },
          child: Text(
            AppLocalizations.of(context)!.translate("pickup_location"),
            style: AppTheme.tabItemText.copyWith(
              color: AppTheme.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        LocationPickerField(
          width: containerWidth,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _handleSave() async {
    // Validation checks...
    if (_venueNameController.text.isEmpty ||
        _selectedVenueType == null ||
        _selectedDefaultLanguage == null ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .translate('please_fill_all_required_fields'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final user = ref.read(userProvider);
    final venue = ref.read(venueProvider);

    if (user == null || venue == null) {
      // Handle errors...
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('unable_to_save'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      String? downloadUrl = venue.additionalInfo?['mapImageUrl'];
      print('inside image save button');
      print(downloadUrl);
      // Prepare Firestore update data
      final updateData = {
        'venueName': _venueNameController.text.trim(),
        'contact.email': _emailController.text.trim(),
        'contact.website': _websiteController.text.trim(),
        'address.street': venue.address.street,
        'address.city': venue.address.city,
        'address.state': venue.address.state,
        'address.postalCode': venue.address.postalCode,
        'address.country': venue.address.country,
        'address.displayAddress': venue.address.displayAddress,
        'address.location.latitude': venue.address.location.latitude,
        'address.location.longitude': venue.address.location.longitude,
        'additionalInfo.venueType': _selectedVenueType,
        'additionalInfo.sellAlcohol': _alcoholOption,
        'additionalInfo.mapImageUrl': downloadUrl,
        'languageOptions': [_selectedDefaultLanguage!],
      };

      if (_selectedLocation != null) {
        updateData['additionalInfo.location'] = {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
        };
      }

      await FirestoreVenue()
          .updateVenue(user.userId, venue.venueId, updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .translate('changes_saved_successfully'),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.translate('save_failed')}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
//   bool _locationChanged() {
//     final venue = ref.read(venueProvider);
//     if (venue == null || _selectedLocation == null) return false;

//     final oldLocation = venue.address.location;
//     return oldLocation.latitude != _selectedLocation!.latitude ||
//         oldLocation.longitude != _selectedLocation!.longitude;
//   }
// }
