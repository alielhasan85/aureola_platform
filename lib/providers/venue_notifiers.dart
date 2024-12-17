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
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:flutter/material.dart';
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
        ...?state!.additionalInfo,
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

  // Update defaultLanguage in additionalInfo
  void updateDefaultLanguage(String defaultLanguage) {
    if (state != null) {
      final updatedInfo = {
        ...state!.additionalInfo,
        'defaultLanguage': defaultLanguage,
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

  // Update specific parts of the address
  void updateAddress({
    String? displayAddress,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    LatLng? location,
  }) {
    if (state != null) {
      this.state = this.state!.copyWith(
            address: this.state!.address.copyWith(
                  street: street,
                  city: city,
                  state: state,
                  postalCode: postalCode,
                  country: country,
                  location: location,
                  displayAddress: displayAddress,
                ),
          );
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

  /// Updates one or more fields within the DesignAndDisplay object.
  void updateDesignAndDisplay({
    String? logoUrl,
    AspectRatioOption? logoAspectRatio,
    AspectRatioOption? backgroundAspectRatio,
    String? backgroundUrl,
    String? backgroundColor,
    String? cardBackground,
    String? accentColor,
    String? textColor,
  }) {
    if (state != null) {
      // Retrieve the current DesignAndDisplay, or initialize if null
      DesignAndDisplay currentDesign = state!.designAndDisplay;

      // Create a new DesignAndDisplay with updated fields
      final updatedDesign = currentDesign.copyWith(
        logoUrl: logoUrl ?? currentDesign.logoUrl,
        logoAspectRatio: logoAspectRatio ?? currentDesign.logoAspectRatio,
        backgroundUrl: backgroundUrl ?? currentDesign.backgroundUrl,
        backgroundAspectRatio:
            backgroundAspectRatio ?? currentDesign.backgroundAspectRatio,
        backgroundColor: backgroundColor ?? currentDesign.backgroundColor,
        cardBackground: cardBackground ?? currentDesign.cardBackground,
        accentColor: accentColor ?? currentDesign.accentColor,
        textColor: textColor ?? currentDesign.textColor,
      );

      // Update the state with the new DesignAndDisplay
      state = state!.copyWith(designAndDisplay: updatedDesign);
    }
  }

// In VenueNotifier
  Future<void> updateLogoAspectRatio(AspectRatioOption newRatio) async {
    if (state == null) return;

    final updatedDesign =
        state!.designAndDisplay.copyWith(logoAspectRatio: newRatio);
    final updatedVenue = state!.copyWith(designAndDisplay: updatedDesign);
    state = updatedVenue;

    // Immediately update Firestore
    await FirestoreVenue().updateVenue(
      state!.userId,
      state!.venueId,
      {'designAndDisplay': updatedDesign.toMap()},
    );
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

  // Add more methods as needed for other fields
}
