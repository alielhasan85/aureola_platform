import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Function to update venue data locally and in Firestore
  Future<void> updateVenueData(
      String userId, String venueId, Map<String, dynamic> updatedData) async {
    if (state != null) {
      // Update Firestore with the new data
      await FirestoreVenue().updateVenue(userId, venueId, updatedData);

      // Update the state locally
      state = state!.copyWith(
        venueName: updatedData['venueName'] ?? state!.venueName,
        address: updatedData['address'] ?? state!.address,
        contact: updatedData['contact'] ?? state!.contact,
        // Add other fields as needed
      );
    }
  }
}
