// lib/service/firebase/firestore_venue.dart

import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';

class FirestoreVenue {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreVenue();

  /// Add a new venue under `/users/{userId}/venues/{venueId}`
  Future<String> addVenue(String userId, VenueModel venue) async {
    final venuesCollection =
        _firestore.collection('users').doc(userId).collection('venues');

    // Generate a new document ID
    final venueDoc = venuesCollection.doc();
    venue = venue.copyWith(venueId: venueDoc.id);

    await venueDoc.set(venue.toMap());

    // Return the newly created venue ID
    return venueDoc.id;
  }

  /// Update specific fields of a venue by its [venueId] for a specific user
  Future<void> updateVenue(
      String userId, String venueId, Map<String, dynamic> updatedData) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update(updatedData);
  }

  /// Delete a venue from Firestore by its [venueId] for a specific user
  Future<void> deleteVenue(String userId, String venueId) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.delete();
  }

  /// Retrieve a specific venue by its [venueId] for a specific user
  Future<VenueModel?> getVenueById(String userId, String venueId) async {
    final venueDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .get();

    if (venueDoc.exists) {
      return VenueModel.fromMap(
          venueDoc.data() as Map<String, dynamic>, venueDoc.id);
    }
    return null;
  }

  /// Retrieve a list of all venues for a specific user
  Future<List<VenueModel>> getAllVenues(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .get();

    return querySnapshot.docs.map((doc) {
      return VenueModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  // -------------- Additional optional methods --------------

  /// Example: Retrieve only the designAndDisplay field
  Future<DesignAndDisplay?> getDesignAndDisplay(
      String userId, String venueId) async {
    final venueDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId)
        .get();

    if (venueDoc.exists) {
      final data = venueDoc.data() as Map<String, dynamic>?;
      if (data != null && data['designAndDisplay'] != null) {
        return DesignAndDisplay.fromMap(
            data['designAndDisplay'] as Map<String, dynamic>);
      }
    }
    return null;
  }

  /// Example: Update only the background color of a venue
  Future<void> updateBackgroundColor(
      String userId, String venueId, String backgroundColor) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await docRef.update({
      'designAndDisplay.backgroundColor': backgroundColor,
    });
  }

  /// Update the entire designAndDisplay object
  Future<void> updateDesignAndDisplay({
    required String userId,
    required String venueId,
    required DesignAndDisplay designAndDisplay,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('venues')
          .doc(venueId);

      await docRef.update({'designAndDisplay': designAndDisplay.toMap()});
    } catch (e) {
      throw Exception('Error updating DesignAndDisplay: $e');
    }
  }

  /// Delete a specific field from designAndDisplay
  Future<void> deleteDesignAndDisplayField({
    required String userId,
    required String venueId,
    required String fieldKey,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('venues')
          .doc(venueId);

      await docRef.update({
        'designAndDisplay.$fieldKey': FieldValue.delete(),
      });
    } catch (e) {
      throw Exception('Error deleting field from DesignAndDisplay: $e');
    }
  }
}
