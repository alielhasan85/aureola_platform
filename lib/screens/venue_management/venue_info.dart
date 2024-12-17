import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/address_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/tag_line.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/email_fields.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/location_picker_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/map_picker_dialog.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/venue_type_dropdown.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/alcohol_option_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/venue_language.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/phone_number_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/name_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/website_fields.dart';
import 'package:aureola_platform/service/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/phone_number.dart';

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({super.key});

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo> {
  final _formKey = GlobalKey<FormState>();

  // 1 venue name
  late TextEditingController _nameController;
  late TextEditingController _taglineController;
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
      _nameController = TextEditingController(text: venue.venueName);
      _taglineController = TextEditingController(text: venue.tagLine);
      _emailController = TextEditingController(text: venue.contact.email);
      _websiteController = TextEditingController(text: venue.contact.website);
      _addressController =
          TextEditingController(text: venue.address.displayAddress);

      _selectedVenueType = venue.additionalInfo['venueType'];
      _selectedDefaultLanguage = venue.languageOptions.first;

      _alcoholOption = venue.additionalInfo['sellAlcohol'];
      _selectedLocation = venue.address.location;
      _mapImageUrl = venue.additionalInfo['mapImageUrl'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();

    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final screenWidth = MediaQuery.of(context).size.width;

    // Determine container width based on breakpoints
    // Resposnivness is good
    double containerWidth;

    if (screenWidth >= 800) {
      containerWidth = 800;
    } else {
      containerWidth = double.infinity;
    }

    final isTabletOrDesktop = screenWidth >= 900;

    return Column(
      children: [
        if (isTabletOrDesktop)
          HeaderContainer(
            userName: user!.name,
          ),
        Expanded(
          child: Padding(
            padding: isTabletOrDesktop
                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              width: containerWidth,
              // margin: EdgeInsets.symmetric(
              //   vertical: isTabletOrDesktop ? 30 : 12,
              // ),
              decoration: isTabletOrDesktop
                  ? AppTheme.cardDecoration
                  : AppTheme.cardDecorationMob,
              child: SingleChildScrollView(
                child: Padding(
                  padding: isTabletOrDesktop
                      ? const EdgeInsets.symmetric(horizontal: 30)
                      : const EdgeInsets.symmetric(horizontal: 15),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final containerWidth = constraints.maxWidth;
                      //print('inisde container $containerWidth');
                      // Decide the number of columns
                      int columns = isTabletOrDesktop ? 2 : 1;

                      // Calculate the width for each field
                      double spacing = 16;
                      double fieldWidth = columns == 1
                          ? containerWidth
                          : (containerWidth - spacing) / 2;

                      return Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            _buildHeader(isTabletOrDesktop),
                            const SizedBox(height: 16),
                            _buildFormFields(
                                columns, fieldWidth, spacing, containerWidth),
                            const SizedBox(height: 16),
                          ],
                        ),
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
          VenueNameField(
            width: fieldWidth,
            controller: _nameController,
            validator: _validateVenueName,
          ),
          const SizedBox(height: 16),
          TaglineWidget(
            width: fieldWidth,
            controller: _taglineController,
            validator: _validateTagline,
          ),
          const SizedBox(height: 12),
          Divider(color: AppTheme.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          PhoneNumberField(width: fieldWidth),
          const SizedBox(height: 16),
          EmailField(
            width: fieldWidth,
            controller: _emailController,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          WebsiteFields(
            width: fieldWidth,
            websiteController: _websiteController,
            validator: _validateWebsite, // Attach the validator
          ),
          const SizedBox(height: 12),
          Divider(color: AppTheme.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
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
            initialValue: _alcoholOption ?? false,
            onChanged: (val) {
              setState(() => _alcoholOption = val);
              ref.read(venueProvider.notifier).updateSellAlcohol(val);
            },
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
          Row(
            children: [
              VenueNameField(
                width: fieldWidth,
                controller: _nameController,
                validator: _validateVenueName,
              ),
              SizedBox(width: spacing),
              TaglineWidget(
                width: fieldWidth,
                controller: _taglineController,
                validator: _validateTagline,
              )
            ],
          ),
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
                validator: _validateEmail,
              ),
              SizedBox(width: spacing),
              WebsiteFields(
                width: fieldWidth,
                websiteController: _websiteController,
                validator: _validateWebsite, // Attach the validator
              ),
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
          AlcoholOptionField(
            width: fieldWidth,
            initialValue: _alcoholOption ?? false,
            onChanged: (val) {
              setState(() => _alcoholOption = val);
              ref.read(venueProvider.notifier).updateSellAlcohol(val);
            },
          ),
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
            style: AppTheme.paragraph.copyWith(
              color: AppTheme.blue,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline, // Add underline
              decorationColor: AppTheme.blue,
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

// Validator for Website
  String? _validateWebsite(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate("website_required");
    }

    String url = value.trim();

    // If the user hasn't included the scheme, assume 'http://'
    if (!url.startsWith(RegExp(r'^https?://'))) {
      url = 'http://$url';
    }

    Uri? uri = Uri.tryParse(url);

    if (uri == null || !uri.hasAuthority) {
      return AppLocalizations.of(context)!.translate("invalid_website");
    }

    // Enforce specific schemes like http or https
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return AppLocalizations.of(context)!.translate("invalid_website_scheme");
    }

    // Additional Checks:

    // 1. Host should not end with a dot
    String host = uri.host;
    if (host.endsWith('.')) {
      return AppLocalizations.of(context)!.translate("invalid_website");
    }

    // 2. Host should contain at least one dot
    if (!host.contains('.')) {
      return AppLocalizations.of(context)!.translate("invalid_website");
    }

    // 3. TLD should be at least two characters
    List<String> parts = host.split('.');
    String tld = parts.last;
    if (tld.length < 2) {
      return AppLocalizations.of(context)!.translate("invalid_website_tld");
    }

    return null; // Validation passed
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate("email_required");
    }
    // Simple email regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.translate("invalid_email");
    }
    return null;
  }

// Validator for Tagline
  String? _validateTagline(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate("tagline_required");
    }
    if (value.trim().length < 5) {
      return AppLocalizations.of(context)!.translate("tagline_too_short");
    }
    if (value.trim().length > 100) {
      return AppLocalizations.of(context)!.translate("tagline_too_long");
    }
    return null; // Return null if validation passes
  }

  String? _validateVenueName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate("venue_name_required");
    }
    return null;
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      // All form fields are valid
      final user = ref.read(userProvider);
      final venue = ref.read(venueProvider);

      if (user == null || venue == null) {
        // User or Venue data is missing
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
        //? downloadUrl = venue.additionalInfo['mapImageUrl'];

        // Prepare Firestore update data
        final updateData = {
          'venueName': _nameController.text.trim(),
          'tagLine': _taglineController.text.trim(),
          'contact.phoneNumber': venue.contact.phoneNumber.trim(),
          'contact.countryDial': venue.contact.countryDial,
          'contact.countryCode': venue.contact.countryCode,
          'contact.countryName': venue.contact.countryName,
          'contact.email': _emailController.text.trim(),
          'contact.website': _websiteController.text.trim(),
          'address.street': venue.address.street,
          'address.city': venue.address.city,
          'address.state': venue.address.state,
          'address.postalCode': venue.address.postalCode,
          'address.country': venue.address.country,
          'address.displayAddress': venue.address.displayAddress,
          // location - to be considered
          'address.location.latitude': venue.address.location.latitude,
          'address.location.longitude': venue.address.location.longitude,
          'additionalInfo.venueType': _selectedVenueType,
          'additionalInfo.sellAlcohol': _alcoholOption,
          'additionalInfo.mapImageUrl': venue.additionalInfo['mapImageUrl'],
          'languageOptions': [_selectedDefaultLanguage!],
        };

        // if (_selectedLocation != null) {
        //   updateData['additionalInfo.location'] = {
        //     'latitude': _selectedLocation!.latitude,
        //     'longitude': _selectedLocation!.longitude,
        //   };
        // }

        // Update Firestore
        await FirestoreVenue()
            .updateVenue(user.userId, venue.venueId, updateData);

        // Update the provider with the new venue data
        ref.read(venueProvider.notifier).updateVenue(
          venueName: _nameController.text.trim(),
          tagLine: _taglineController.text.trim(),
          contact: venue.contact.copyWith(
            email: _emailController.text.trim(),
            website: _websiteController.text.trim(),
          ),
          address: venue.address.copyWith(
            street: venue.address.street,
            city: venue.address.city,
            state: venue.address.state,
            postalCode: venue.address.postalCode,
            country: venue.address.country,
            displayAddress: venue.address.displayAddress,
            location: _selectedLocation ?? venue.address.location,
          ),
          languageOptions: [_selectedDefaultLanguage!],
          additionalInfo: {
            'venueType': _selectedVenueType,
            'sellAlcohol': _alcoholOption,
            'mapImageUrl': venue.additionalInfo['mapImageUrl'],
            'location': _selectedLocation != null
                ? {
                    'latitude': _selectedLocation!.latitude,
                    'longitude': _selectedLocation!.longitude,
                  }
                : venue.additionalInfo['location'],
          },
        );

        // Show success SnackBar
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
        // Handle any errors during save
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.translate('save_failed')}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Form is invalid, show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('please_fix_errors'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
