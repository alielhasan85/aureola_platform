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

  // Function to set the venue data
  void setVenue(VenueModel venue) {
    state = venue;
  }

  // Function to clear the venue data
  void clearVenue() {
    state = null;
  }

  // Function to fetch the venue data from Firestore and set it
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

  // Update venueName
  void updateVenueName(String venueName) {
    if (state != null) {
      state = state!.copyWith(venueName: venueName);
    }
  }

  // Update venueName
  void updateTagline(String tagLine) {
    if (state != null) {
      state = state!.copyWith(tagLine: tagLine);
    }
  }

  // // Update specific parts of the address
  // void updateAddress({
  //   String? displayAddress,
  //   String? street,
  //   String? city,
  //   String? state,
  //   String? postalCode,
  //   String? country,
  //   LatLng? location,
  // }) {
  //   if (state != null) {
  //     this.state = this.state!.copyWith(
  //           address: this.state!.address.copyWith(
  //                 street: street,
  //                 city: city,
  //                 state: state,
  //                 postalCode: postalCode,
  //                 country: country,
  //                 location: location,
  //                 displayAddress: displayAddress,
  //               ),
  //         );
  //   }
  // }

// lib/providers/venue_notifier.dart

  // Refactored updateAddress method
  void updateAddress({
    String? newDisplayAddress,
    String? newStreet,
    String? newCity,
    String? newState,
    String? newPostalCode,
    String? newCountry,
    LatLng? newLocation,
  }) {
    if (newState != null ||
        newCity != null ||
        newCountry != null ||
        newStreet != null ||
        newPostalCode != null ||
        newDisplayAddress != null ||
        newLocation != null) {
      if (state != null) {
        Address currentAddress = state!.address;

        // Create an updated address by selectively replacing fields
        Address updatedAddress = currentAddress.copyWith(
          displayAddress: newDisplayAddress ?? currentAddress.displayAddress,
          street: newStreet ?? currentAddress.street,
          city: newCity ?? currentAddress.city,
          state: newState ?? currentAddress.state,
          postalCode: newPostalCode ?? currentAddress.postalCode,
          country: newCountry ?? currentAddress.country,
          location: newLocation ?? currentAddress.location,
        );

        // Update the state with the new address
        state = state!.copyWith(address: updatedAddress);
      }
    }
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

  // Method to update DesignAndDisplay
  void updateDesignAndDisplay(DesignAndDisplay newDesign) {
    if (state != null) {
      state = state!.copyWith(designAndDisplay: newDesign);
    }
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
    String? venueName,
    String? tagLine,
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

  void updateDefaultLanguage(String code) {
    if (state == null) return;

    // Make a copy of the current languageOptions
    final currentLangs = [...state!.languageOptions];

    // If the code isn't in the array, insert it
    if (!currentLangs.contains(code)) {
      currentLangs.insert(0, code);
    } else {
      // Optionally move it to the front
      currentLangs.remove(code);
      currentLangs.insert(0, code);
    }

    // Example: store the default in additionalInfo as well (optional),
    // or just rely on the first item in languageOptions to be the default
    final updatedInfo = {...state!.additionalInfo};
    updatedInfo['defaultLanguage'] = code;

    state = state!.copyWith(
      languageOptions: currentLangs,
      additionalInfo: updatedInfo,
    );
  }

  // Specific methods to update individual color fields
  void updateBackgroundColor(String hex) {
    if (state != null) {
      final updatedDesign =
          state!.designAndDisplay.copyWith(backgroundColor: hex);
      state = state!.copyWith(designAndDisplay: updatedDesign);
    }
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
}
  // Add more methods as needed for other fields

