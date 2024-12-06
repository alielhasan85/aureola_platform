import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
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
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/address_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/name_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/website_fields.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/whatsapp_number.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({super.key});

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _whatsAppController;
  late TextEditingController _venueNameController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController; // For detailed address

  String? _selectedVenueType;
  String? _selectedDefaultLanguage;
  bool? _alcoholOption;
  String? _country;
  String? _state;
  String? _city;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    final venue = ref.read(venueProvider);
    _phoneNumberController =
        TextEditingController(text: venue?.contact.phoneNumber ?? '');
    _whatsAppController =
        TextEditingController(text: venue?.contact.phoneNumber ?? '');
    _venueNameController = TextEditingController(text: venue?.venueName ?? '');
    _emailController = TextEditingController(text: venue?.contact.email ?? '');
    _websiteController =
        TextEditingController(text: venue?.contact.website ?? '');
    _addressController =
        TextEditingController(text: venue?.address.country ?? '');

    _selectedVenueType = null;
    _selectedDefaultLanguage = 'English';
    _alcoholOption = false;
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _whatsAppController.dispose();
    _venueNameController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        // TODO: username dynamic from firebase
        if (isTabletOrDesktop)
          HeaderContainer(
            userName: 'ali el hassan',
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
            onChanged: (val) => setState(() => _selectedVenueType = val),
          ),
          const SizedBox(height: 16),
          AlcoholOptionField(
            width: fieldWidth,
            onChanged: (val) => setState(() => _alcoholOption = val),
          ),
          const SizedBox(height: 16),
          DefaultLanguageDropdown(
            width: fieldWidth,
            onChanged: (val) => setState(() => _selectedDefaultLanguage = val),
          ),
          const SizedBox(height: 16),
          WebsiteFields(
              width: fieldWidth, websiteController: _websiteController),
          const SizedBox(height: 16),
          EmailField(width: fieldWidth, controller: _emailController),
          const SizedBox(height: 16),
          PhoneNumberField(
              width: fieldWidth, controller: _phoneNumberController),
          const SizedBox(height: 16),
          VenueAddressField(
            width: fieldWidth,
            addressController: _addressController,
            onCountryChanged: (val) => _country = val,
            onStateChanged: (val) => _state = val,
            onCityChanged: (val) => _city = val,
          ),
          const SizedBox(height: 16),
          _buildPickupLocationSection(containerWidth),
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
              PhoneNumberField(
                  width: fieldWidth, controller: _phoneNumberController),
              SizedBox(width: spacing),
              WhatsappNumber(width: fieldWidth, controller: _whatsAppController)
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
              VenueTypeDropdown(width: fieldWidth),
              SizedBox(width: spacing),
              DefaultLanguageDropdown(width: fieldWidth),
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
            onCountryChanged: (val) => _country = val,
            onStateChanged: (val) => _state = val,
            onCityChanged: (val) => _city = val,
          ),

          // Pickup Location Button and Map

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
            LatLng? result = await showDialog<LatLng>(
              context: context,
              builder: (context) => MapPickerDialog(
                initialLocation:
                    _selectedLocation ?? const LatLng(25.286106, 51.534817),
                containerWidth: containerWidth,
              ),
            );
            if (result != null) {
              setState(() {
                _selectedLocation = result;
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
          selectedLocation: _selectedLocation,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

// venue_info.dart

  void _handleSave() async {
    // Step 1: Validate Required Fields
    if (_venueNameController.text.isEmpty ||
        _selectedVenueType == null ||
        _selectedDefaultLanguage == null ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('please_fill_all_required_fields')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = ref.read(userProvider);

    // Step 2: Identify the Venue ID
    // If adding a new venue, generate a unique ID
    // If updating an existing venue, retrieve the venueId appropriately
    final venueId = FirebaseFirestore.instance.collection('venues').doc().id;
    final userId = user?.userId ?? 'anonymousUser';

    // Step 3: Construct the Partial Data Map
    Map<String, dynamic> updatedData = {
      'venueId': venueId,
      'venueName': _venueNameController.text,
      'userId': userId,
      'address': {
        'street': _addressController.text,
        'city': _city ?? '',
        'state': _state ?? '',
        'postalCode': '', // Assign default or collect if available
        'country': _country ?? '',
      },
      'contact': {
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'countryCode': '', // Assign default or derive from country if available
        'website': _websiteController.text,
        'whatsappNumber': _whatsAppController.text,
      },
      'languageOptions': [_selectedDefaultLanguage ?? 'English'],
      'venueType': _selectedVenueType,
      'alcoholOption': _alcoholOption,
      // Add other fields as necessary
    };

    // Step 4: Save to Firestore
    try {
      final firestoreVenue = FirestoreVenue();
      await firestoreVenue.addVenue(
          userId, VenueModel.fromMap(updatedData, venueId));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('changes_saved_successfully')),
          backgroundColor: Colors.green,
        ),
      );

      // Optionally, reset the form or navigate away
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${AppLocalizations.of(context)!.translate('save_failed')}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
