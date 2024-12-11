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

// Update venue type in additionalInfo
  void updateSellAlcohol(bool sellAlcohol) {
    if (state != null) {
      final updatedInfo = {
        ...?state!.additionalInfo,
        'sellAlcohol': sellAlcohol,
      };
      state = state!.copyWith(additionalInfo: updatedInfo);
    }
  }

  // Update venue type in additionalInfo
  void updateVenueType(String venueType) {
    if (state != null) {
      final updatedInfo = {
        ...?state!.additionalInfo,
        'venueType': venueType,
      };
      state = state!.copyWith(additionalInfo: updatedInfo);
    }
  }

// Update venue type in additionalInfo
  void updateDefaultLanguage(String defaultLanguage) {
    if (state != null) {
      final updatedInfo = {
        ...?state!.additionalInfo,
        'defaultLanguage': defaultLanguage,
      };
      state = state!.copyWith(additionalInfo: updatedInfo);
    }
  }

  void updateMapImageUrl(String mapImageUrl) {
    if (state != null) {
      final updatedInfo = {
        ...?state!.additionalInfo,
        'mapImageUrl': mapImageUrl,
      };
      state = state!.copyWith(additionalInfo: updatedInfo);
      // Ensure listeners are notified
    }
  }

  // void updateDesignAndDisplay(String key, String value) {
  //   if (state != null) {
  //     final updatedDesignAndDisplay = {...state!.designAndDisplay, key: value};
  //     state = state!.copyWith(designAndDisplay: updatedDesignAndDisplay);
  //   }
  // }

  // // Method to update price options such as currency, price display, etc.
  // void updatePriceOption(String key, dynamic value) {
  //   if (state != null) {
  //     final updatedPriceOptions = {...state!.priceOptions, key: value};
  //     state = state!.copyWith(priceOptions: updatedPriceOptions);
  //   }
  // }

  // void updateColor(String colorType, Color color) {
  //   if (state != null) {
  //     final updatedDesignAndDisplay = {...state!.designAndDisplay};
  //     updatedDesignAndDisplay[colorType] = _colorToHex(color);
  //     state = state!.copyWith(designAndDisplay: updatedDesignAndDisplay);
  //   }
  // }

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

  //

  void updateVenueName(String venueName) {
    if (state != null) {
      state = state!.copyWith(venueName: venueName);
    }

    String _colorToHex(Color color) {
      return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    }

    // // Function to update venue data locally and in Firestore
    // Future<void> updateVenueData(
    //     String userId, String venueId, Map<String, dynamic> updatedData) async {
    //   if (state != null) {
    //     // Update Firestore with the new data
    //     await FirestoreVenue().updateVenue(userId, venueId, updatedData);

    //     // Update the state locally
    //     state = state!.copyWith(
    //       venueName: updatedData['venueName'] ?? state!.venueName,
    //       address: updatedData['address'] ?? state!.address,
    //       contact: updatedData['contact'] ?? state!.contact,
    //       // Add other fields as needed
    //     );
    //   }
    // }
  }
}
