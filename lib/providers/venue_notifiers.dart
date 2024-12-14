// lib/providers/venue_notifier.dart

import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
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
        ...?state!.additionalInfo,
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
      DesignAndDisplay currentDesign =
          state!.designAndDisplay ?? DesignAndDisplay();

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

  // Add more methods as needed for other fields
}
