// lib/providers/venue_notifier.dart

import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/models/common/address.dart';
import 'package:aureola_platform/models/common/contact.dart';
import 'package:aureola_platform/models/common/subscription.dart';
import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:aureola_platform/models/venue/operations.dart';
import 'package:aureola_platform/models/venue/price_options.dart';
import 'package:aureola_platform/models/venue/qr_code.dart';
import 'package:aureola_platform/models/venue/social_accounts.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VenueNotifier extends StateNotifier<VenueModel?> {
  VenueNotifier() : super(null);

  // 1) Set or clear the entire venue
  void setVenue(VenueModel venue) => state = venue;
  void clearVenue() => state = null;

  // 2) Fetch from Firestore
  Future<void> fetchVenue(String userId, String venueId) async {
    final venueData = await FirestoreVenue().getVenueById(userId, venueId);
    if (venueData != null) {
      setVenue(venueData);
    }
  }

// Update sellAlcohol in additionalInfo
  void updateSellAlcohol(bool sellAlcohol) {
    if (state != null) {
      final updatedInfo = {
        ...state!.additionalInfo,
        'sellAlcohol': sellAlcohol,
      };
      state = state!.copyWith(additionalInfo: updatedInfo);
    }
  }

  // Update venueType in additionalInfo
  void updateVenueType(String venueType) {
    if (state != null) {
      final updatedInfo = {
        ...state!.additionalInfo,
        'venueType': venueType,
      };
      state = state!.copyWith(additionalInfo: updatedInfo);
    }
  }

  // Update mapImageUrl in additionalInfo
  void updateMapImageUrl(String mapImageUrl) {
    if (state != null) {
      final updatedInfo = {
        ...state!.additionalInfo,
        'mapImageUrl': mapImageUrl,
      };
      state = state!.copyWith(additionalInfo: updatedInfo);
      // Ensure listeners are notified
    }
  }

  // 3) Multi-lingual venueName update
  void updateVenueName(Map<String, String> newName) {
    if (state == null) return;
    state = state!.copyWith(venueName: newName);
  }

  // 4) Multi-lingual tagLine update
  void updateTagLine(Map<String, String> newTagLine) {
    if (state == null) return;
    state = state!.copyWith(tagLine: newTagLine);
  }

  // 5) Add or remove languages
  void addLanguage(String langCode) {
    if (state == null) return;

    final current = [...state!.languageOptions];
    // Avoid duplicates
    if (!current.contains(langCode)) {
      current.add(langCode);
      state = state!.copyWith(languageOptions: current);
    }
  }

  void removeLanguage(String langCode) {
    if (state == null) return;
    if (state!.languageOptions.first == langCode) {
      // It's the default language => cannot remove or decide your logic
      return;
    }
    final filtered =
        state!.languageOptions.where((l) => l != langCode).toList();
    state = state!.copyWith(languageOptions: filtered);
  }

  // 6) Update the "default language," moving it to index 0
  void updateDefaultLanguage(String code) {
    if (state == null) return;

    final updatedInfo = {...state!.additionalInfo};
    updatedInfo['defaultLanguage'] = code;

    final currentLangs = [...state!.languageOptions];
    // remove it if present
    currentLangs.remove(code);
    // Insert as first
    currentLangs.insert(0, code);

    state = state!.copyWith(
      languageOptions: currentLangs,
      additionalInfo: updatedInfo,
    );
  }

  // 7) Additional info updates

  // 8) Address updates
  void updateAddress({
    String? newDisplayAddress,
    String? newStreet,
    String? newCity,
    String? newState,
    String? newPostalCode,
    String? newCountry,
    LatLng? newLocation,
  }) {
    if (state == null) return;
    final currentAddress = state!.address;
    final updatedAddress = currentAddress.copyWith(
      displayAddress: newDisplayAddress ?? currentAddress.displayAddress,
      street: newStreet ?? currentAddress.street,
      city: newCity ?? currentAddress.city,
      state: newState ?? currentAddress.state,
      postalCode: newPostalCode ?? currentAddress.postalCode,
      country: newCountry ?? currentAddress.country,
      location: newLocation ?? currentAddress.location,
    );
    state = state!.copyWith(address: updatedAddress);
  }

  void updateCountryStateCity({
    String? country,
    String? state,
    String? city,
  }) {
    if (country != null || state != null || city != null) {
      if (this.state != null) {
        Address currentAddress = this.state!.address;

        // Update only the country, state, and city fields
        Address updatedAddress = currentAddress.copyWith(
          country: country ?? currentAddress.country,
          state: state ?? currentAddress.state,
          city: city ?? currentAddress.city,
        );

        // Update the state with the new address
        this.state = this.state!.copyWith(address: updatedAddress);
      }
    }
  }

  // Contact update methods
  void updateContactPhoneNumber(String phoneNumber) {
    if (state != null) {
      state = state!.copyWith(
        contact: state!.contact.copyWith(phoneNumber: phoneNumber),
      );
    }
  }

  void updateContactCountryDial(String countryDial) {
    if (state != null) {
      state = state!.copyWith(
        contact: state!.contact.copyWith(countryDial: countryDial),
      );
    }
  }

  // Update email
  void updateEmail(String email) {
    if (state != null) {
      state = state!.copyWith(
        contact: state!.contact.copyWith(email: email),
      );
    }
  }

  // Update email
  void updateWebsite(String website) {
    if (state != null) {
      state = state!.copyWith(
        contact: state!.contact.copyWith(website: website),
      );
    }
  }

  void updateContactCountryCode(String countryCode) {
    if (state != null) {
      state = state!.copyWith(
        contact: state!.contact.copyWith(countryCode: countryCode),
      );
    }
  }

  void updateContactCountryName(String countryName) {
    if (state != null) {
      state = state!.copyWith(
        contact: state!.contact.copyWith(countryName: countryName),
      );
    }
  }

  // 10) Update design display
  void updateDesignAndDisplay(DesignAndDisplay newDesign) {
    if (state == null) return;
    state = state!.copyWith(designAndDisplay: newDesign);
  }

// In VenueNotifier
  Future<void> updateLogoAspectRatio(AspectRatioOption newRatio) async {
    if (state == null) return;

    final updatedDesign =
        state!.designAndDisplay.copyWith(logoAspectRatio: newRatio);
    final updatedVenue = state!.copyWith(designAndDisplay: updatedDesign);
    state = updatedVenue;

    // // Immediately update Firestore
    // await FirestoreVenue().updateVenue(
    //   state!.userId,
    //   state!.venueId,
    //   {'designAndDisplay': updatedDesign.toMap()},
    // );
  }

// Contact update methods
  void updateContact({
    String? email,
    String? website,
    String? phoneNumber,
    String? countryDial,
    String? countryCode,
    String? countryName,
  }) {
    if (state != null) {
      state = state!.copyWith(
        contact: state!.contact.copyWith(
          email: email ?? state!.contact.email,
          website: website ?? state!.contact.website,
          phoneNumber: phoneNumber ?? state!.contact.phoneNumber,
          countryDial: countryDial ?? state!.contact.countryDial,
          countryCode: countryCode ?? state!.contact.countryCode,
          countryName: countryName ?? state!.contact.countryName,
        ),
      );
    }
  }

  /// Comprehensive method to update multiple fields of the VenueModel.
  void updateVenue({
    Map<String, String>? venueName,
    Map<String, String>? tagLine,
    Address? address,
    Contact? contact,
    List<String>? languageOptions,
    SocialAccounts? socialAccounts,
    Operations? operations,
    List<QrCode>? qrCodes,
    DesignAndDisplay? designAndDisplay,
    PriceOptions? priceOptions,
    Subscription? subscription,
    List<String>? staff,
    Map<String, dynamic>? additionalInfo,
    // Add more fields as needed
  }) {
    if (state != null) {
      // Update Address if provided
      Address updatedAddress = address ?? state!.address;

      // Update Contact if provided
      Contact updatedContact = contact ?? state!.contact;

      // Update AdditionalInfo if provided
      Map<String, dynamic> updatedAdditionalInfo = additionalInfo != null
          ? {...state!.additionalInfo, ...additionalInfo}
          : state!.additionalInfo;

      // Update DesignAndDisplay if provided
      DesignAndDisplay updatedDesignAndDisplay =
          designAndDisplay ?? state!.designAndDisplay;

      // Create a new VenueModel with updated fields
      state = state!.copyWith(
        venueName: venueName,
        tagLine: tagLine,
        address: updatedAddress,
        contact: updatedContact,
        languageOptions: languageOptions ?? state!.languageOptions,
        socialAccounts: socialAccounts ?? state!.socialAccounts,
        operations: operations ?? state!.operations,
        qrCodes: qrCodes ?? state!.qrCodes,
        designAndDisplay: updatedDesignAndDisplay,
        priceOptions: priceOptions ?? state!.priceOptions,
        subscription: subscription ?? state!.subscription,
        staff: staff ?? state!.staff,
        additionalInfo: updatedAdditionalInfo,
      );
    }
  }

  // For background color, accent color, etc.:
  void updateBackgroundColor(String hex) {
    if (state == null) return;
    final updated = state!.designAndDisplay.copyWith(backgroundColor: hex);
    state = state!.copyWith(designAndDisplay: updated);
  }

  // 11) Save to Firestore manually if needed
  Future<void> saveVenueToFirestore(String userId) async {
    if (state == null) return;

    // For example, build updatedData from state!.toMap():
    final updatedData = state!.toMap();

    await FirestoreVenue().updateVenue(userId, state!.venueId, updatedData);
  }

  void updateCardBackgroundColor(String hex) {
    if (state != null) {
      final updatedDesign =
          state!.designAndDisplay.copyWith(cardBackground: hex);
      state = state!.copyWith(designAndDisplay: updatedDesign);
    }
  }

  void updateAccentColor(String hex) {
    if (state != null) {
      final updatedDesign = state!.designAndDisplay.copyWith(accentColor: hex);
      state = state!.copyWith(designAndDisplay: updatedDesign);
    }
  }

  void updateTextColor(String hex) {
    if (state != null) {
      final updatedDesign = state!.designAndDisplay.copyWith(textColor: hex);
      state = state!.copyWith(designAndDisplay: updatedDesign);
    }
  }

  void updateLogoUrl(String url) {
    if (state != null) {
      final updatedDesign = state!.designAndDisplay.copyWith(logoUrl: url);
      state = state!.copyWith(designAndDisplay: updatedDesign);
    }
  }

  /// Update the entire venueName map at once.
  void updateVenueNameMap(Map<String, String> newMap) {
    if (state == null) return;
    state = state!.copyWith(venueName: newMap);
  }

  /// Update the entire tagLine map at once.
  void updateTagLineMap(Map<String, String> newMap) {
    if (state == null) return;
    state = state!.copyWith(tagLine: newMap);
  }

  // Additional partial updates as needed...
}
