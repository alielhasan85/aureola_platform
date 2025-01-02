import 'dart:typed_data';

import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/address_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/country_city_picker.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/location_service.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/tag_line.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/venue_add_languages.dart';
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

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({super.key});

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo> {
  final locationService =
      LocationService(apiKey: 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA');

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _taglineController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;
  String _currentPhoneNumber = '';

  String? _selectedVenueType;
  String? _selectedDefaultLanguage;
  bool? _alcoholOption;
  LatLng _selectedLocation = const LatLng(25.286106, 51.534817);

  String _countryValue = '';
  String _stateValue = '';
  String _cityValue = '';

  @override
  void initState() {
    super.initState();
    // Initialize fields from the stable venue provider data
    final venue = ref.read(draftVenueProvider);
    _initializeFormFields(venue);
  }

  void _initializeFormFields(VenueModel? venue) {
    _nameController = TextEditingController(text: venue?.venueName ?? '');
    _taglineController = TextEditingController(text: venue?.tagLine ?? '');
    _emailController = TextEditingController(text: venue?.contact.email ?? '');
    _websiteController =
        TextEditingController(text: venue?.contact.website ?? '');
    _addressController =
        TextEditingController(text: venue?.address.displayAddress ?? '');

    _selectedVenueType = venue?.additionalInfo['venueType'] ?? "Fine_Dining";
    _selectedDefaultLanguage = (venue?.languageOptions.isNotEmpty == true)
        ? venue!.languageOptions.first
        : 'en';

    _alcoholOption = venue?.additionalInfo['sellAlcohol'] ?? false;
    _selectedLocation =
        venue?.address.location ?? const LatLng(25.286106, 51.534817);
    _currentPhoneNumber = venue?.contact.phoneNumber ?? '';
    _countryValue = venue?.address.country ?? '';
    _stateValue = venue?.address.state ?? '';
    _cityValue = venue?.address.city ?? '';
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
    final user = ref.read(userProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth >= 800 ? 800 : double.infinity;
    final isTabletOrDesktop = screenWidth >= 900;

    return Column(
      children: [
        if (isTabletOrDesktop) HeaderContainer(userName: user!.name),
        Expanded(
          child: Padding(
            padding: isTabletOrDesktop
                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              width: containerWidth,
              decoration: isTabletOrDesktop
                  ? AppThemeLocal.cardDecoration
                  : AppThemeLocal.cardDecorationMob,
              child: SingleChildScrollView(
                child: Padding(
                  padding: isTabletOrDesktop
                      ? const EdgeInsets.symmetric(horizontal: 30)
                      : const EdgeInsets.symmetric(horizontal: 15),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final containerWidth = constraints.maxWidth;
                      int columns = isTabletOrDesktop ? 2 : 1;
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
          style: AppThemeLocal.appBarTitle,
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
            style: AppThemeLocal.buttonText
                .copyWith(fontSize: isLargeScreen ? 16 : 14),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(
      int columns, double fieldWidth, double spacing, double containerWidth) {
    // Original logic retained
    if (columns == 1) {
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
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          PhoneNumberField(
            width: fieldWidth,
            //validator: _validatePhoneNumber,
            // initialPhoneNumber:
            //     _currentPhoneNumber, // This is the variable updated in _initializeFormFields
          ),
          const SizedBox(height: 16),
          EmailField(
              width: fieldWidth,
              controller: _emailController,
              validator: _validateEmail),
          const SizedBox(height: 16),
          WebsiteFields(
              width: fieldWidth,
              websiteController: _websiteController,
              validator: _validateWebsite),
          const SizedBox(height: 12),
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          VenueTypeDropdown(
            width: fieldWidth,
            initialValue: _selectedVenueType ?? "Fine_Dining",
            onChanged: (val) {
              setState(() {
                _selectedVenueType = val;
              });
              ref.read(draftVenueProvider.notifier).updateVenueType(val);
            },
          ),
          const SizedBox(height: 16),
          AlcoholOptionField(
            width: fieldWidth,
            initialValue: _alcoholOption ?? false,
            onChanged: (val) {
              setState(() => _alcoholOption = val);
              ref.read(draftVenueProvider.notifier).updateSellAlcohol(val);
            },
          ),
          const SizedBox(height: 12),
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          Text(
          AppLocalizations.of(context)!.translate("Language_Options"),
          style: AppThemeLocal.paragraph,
        ),
          DefaultLanguageDropdown(
            width: fieldWidth,
            initialLanguage: _selectedDefaultLanguage ?? 'en',
            onChanged: (val) {
              setState(() => _selectedDefaultLanguage = val);
              ref.read(draftVenueProvider.notifier).updateDefaultLanguage(val);
            },
          ),
          const SizedBox(height: 16),
          VenueAddLanguages(width: fieldWidth),
          const SizedBox(height: 12),
          
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.translate("Enter_venue_address"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 8),
          CountryStateCityPicker(
            width: fieldWidth * 1.25,
            // initialCountry: _countryValue,
            // initialState: _stateValue,
            // initialCity: _cityValue,
            // onLocationChanged: (country, state, city) {
            //   setState(() {
            //     _countryValue = country;
            //     _stateValue = state;
            //     _cityValue = city;
            //   });
            // },
          ),
          const SizedBox(height: 16),
          VenueAddressField(
              width: fieldWidth * 1.25, addressController: _addressController),
          const SizedBox(height: 16),
          _buildPickupLocationSection(containerWidth, _selectedLocation),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _handleCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel'),
                    style: AppThemeLocal.buttonText.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E1E),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('save'),
                    style: AppThemeLocal.buttonText.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Desktop layout code unchanged
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //venue name + tagline 
          //TODO: to add multi language support
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
          const SizedBox(height: 12),
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          PhoneNumberField(
            width: fieldWidth,
            //validator: _validatePhoneNumber,
            // initialPhoneNumber:
            //     _currentPhoneNumber, // This is the variable updated in _initializeFormFields
          ),
          SizedBox(width: spacing),
          const SizedBox(height: 12),
          Row(
            children: [
              EmailField(
                  width: fieldWidth,
                  controller: _emailController,
                  validator: _validateEmail),
              SizedBox(width: spacing),
              WebsiteFields(
                  width: fieldWidth,
                  websiteController: _websiteController,
                  validator: _validateWebsite),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          Row(
            children: [
              VenueTypeDropdown(
                width: fieldWidth,
                initialValue: _selectedVenueType ?? "Fine_Dining",
                onChanged: (val) {
                  setState(() {
                    _selectedVenueType = val;
                  });
                  ref.read(draftVenueProvider.notifier).updateVenueType(val);
                },
              ),
              SizedBox(width: spacing),
              AlcoholOptionField(
              width: fieldWidth,
              initialValue: _alcoholOption ?? false,
              onChanged: (val) {
                setState(() => _alcoholOption = val);
                ref.read(draftVenueProvider.notifier).updateSellAlcohol(val);
              },
            ),
              
            ],
          ),
         const SizedBox(height: 12),
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
 Text(
          AppLocalizations.of(context)!.translate("Language_Options"),
          style: AppThemeLocal.paragraph,
        ),
         const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            DefaultLanguageDropdown(
                width: fieldWidth,
                initialLanguage: _selectedDefaultLanguage ?? 'en',
                onChanged: (val) {
                  setState(() => _selectedDefaultLanguage = val);
                  ref
                      .read(draftVenueProvider.notifier)
                      .updateDefaultLanguage(val);
                },
              ),
            SizedBox(width: spacing),
            VenueAddLanguages(width: fieldWidth),
          ]),

         
          const SizedBox(height: 12),
          Divider(color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.translate("Enter_venue_address"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 8),
          CountryStateCityPicker(
            width: fieldWidth * 1.25,
            // initialCountry: _countryValue,
            // initialState: _stateValue,
            // initialCity: _cityValue,
            // onLocationChanged: (country, state, city) {
            //   setState(() {
            //     _countryValue = country;
            //     _stateValue = state;
            //     _cityValue = city;
            //     ref.read(venueProvider.notifier).updateAddress(
            //         country: _countryValue,
            //         state: _stateValue,
            //         city: _cityValue);
            //   });
            // },
          ),
          const SizedBox(height: 16),
          VenueAddressField(
              width: fieldWidth * 1.25, addressController: _addressController),
          const SizedBox(height: 16),
          _buildPickupLocationSection(containerWidth, _selectedLocation),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _handleCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel'),
                    style: AppThemeLocal.buttonText.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E1E),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('save'),
                    style: AppThemeLocal.buttonText.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

//location widget
  Widget _buildPickupLocationSection(double containerWidth, LatLng location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => MapPickerDialog(
                  containerWidth: containerWidth, initialLocation: location),
            );
            if (result != null && result['location'] != null) {
              await _handleLocationPicked(result['location']);
            }
          },
          child: Text(
            AppLocalizations.of(context)!.translate("pickup_location"),
            style: AppThemeLocal.paragraph.copyWith(
              color: AppThemeLocal.blue,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: AppThemeLocal.blue,
            ),
          ),
        ),
        const SizedBox(height: 16),
        LocationPickerField(width: containerWidth),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _handleLocationPicked(LatLng location) async {
    setState(() {
      _selectedLocation = location;
    });

    final user = ref.read(userProvider);
    final venue = ref.read(venueProvider);

    if (user == null || venue == null) return;

    // Placeholder method to upload image to Firebase Storage
    // Implement according to your logic
    Future<String?> uploadImage(
        Uint8List imageData, String category, String type) async {
      // TODO: Implement actual upload to Firebase Storage and return download URL
      return null;
    }

    // Fetch and upload static map image using locationService
    final downloadUrl = await locationService.fetchAndUploadStaticMapImage(
      location: location,
      userId: user.userId,
      venueId: venue.venueId,
      uploadImage: uploadImage,
    );

    // Update provider with map image URL and location if upload was successful
    if (downloadUrl != null) {
      ref.read(draftVenueProvider.notifier).updateMapImageUrl(downloadUrl);
      ref
          .read(draftVenueProvider.notifier)
          .updateAddress(newLocation: location);
    }
  }

  Future<void> _handleCancel() async {
    final user = ref.read(userProvider);
    final venue = ref.read(venueProvider);

    if (user == null || venue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('no_initial_data'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Reset draftVenueProvider to match venueProvider
      ref.read(draftVenueProvider.notifier).setVenue(venue);

      setState(() {
        _initializeFormFields(venue);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('form_reset_successfully'),
          ),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.translate('reset_failed')}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(userProvider);
      final draft = ref.read(draftVenueProvider);

      if (user == null || draft == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.translate('unable_to_save')),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final standardizedWebsite =
            _standardizeUrl(_websiteController.text.trim());

        final updateData = {
          'venueName': draft.venueName.trim(),
          'tagLine': draft.tagLine.trim(),
          'contact.phoneNumber': draft.contact.phoneNumber.trim(),
          'contact.countryDial': draft.contact.countryDial,
          'contact.countryCode': draft.contact.countryCode,
          'contact.countryName': draft.contact.countryName,
          'contact.email': draft.contact.email.trim(),
          'contact.website': standardizedWebsite,
          'address.street': draft.address.street,
          'address.city': draft.address.city,
          'address.state': draft.address.state,
          'address.postalCode': draft.address.postalCode,
          'address.country': draft.address.country,
          'address.displayAddress': draft.address.displayAddress,
          'address.location.latitude': draft.address.location.latitude,
          'address.location.longitude': draft.address.location.longitude,
          'additionalInfo.venueType': draft.additionalInfo['venueType'],
          'additionalInfo.sellAlcohol': draft.additionalInfo['sellAlcohol'],
          'additionalInfo.mapImageUrl': draft.additionalInfo['mapImageUrl'],
          'languageOptions': draft.languageOptions,
          'additionalInfo.defaultLanguage':
              draft.additionalInfo['defaultLanguage'] ?? '',
        };

        await FirestoreVenue()
            .updateVenue(user.userId, draft.venueId, updateData);

        // After successful save, update the stable provider
        ref.read(venueProvider.notifier).setVenue(draft);
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
                '${AppLocalizations.of(context)!.translate('save_failed')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.translate('please_fix_errors')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Minimal helper for URL standardization (unchanged)
  String _standardizeUrl(String url) {
    url = url.trim();
    if (!url.startsWith(RegExp(r'^https?://'))) {
      url = 'http://$url';
    }
    return url;
  }

  String? _validateWebsite(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate("website_required");
    }

    String url = value.trim();
    if (!url.startsWith(RegExp(r'^https?://'))) {
      url = 'http://$url';
    }

    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAuthority) {
      return AppLocalizations.of(context)!.translate("invalid_website");
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return AppLocalizations.of(context)!.translate("invalid_website_scheme");
    }

    String host = uri.host;
    if (host.endsWith('.')) {
      return AppLocalizations.of(context)!.translate("invalid_website");
    }

    if (!host.contains('.')) {
      return AppLocalizations.of(context)!.translate("invalid_website");
    }

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
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.translate("invalid_email");
    }
    return null;
  }

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
    return null;
  }

  String? _validateVenueName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate("venue_name_required");
    }
    return null;
  }
}
