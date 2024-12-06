// firestore_venue.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';

class FirestoreVenue {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _venuesCollection;

  FirestoreVenue()
      : _venuesCollection = FirebaseFirestore.instance.collection('venues');

  // Add a new venue to Firestore
  Future<void> addVenue(VenueModel venue) async {
    await _venuesCollection.doc(venue.venueId).set(venue.toMap());
  }

  // Update specific fields of an existing venue
  Future<void> updateVenue(
      String venueId, Map<String, dynamic> updatedData) async {
    await _venuesCollection.doc(venueId).update(updatedData);
  }

  // Retrieve a venue by ID
  Future<VenueModel?> getVenueById(String venueId) async {
    final docSnapshot = await _venuesCollection.doc(venueId).get();
    if (docSnapshot.exists) {
      return VenueModel.fromMap(
          docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
    }
    return null;
  }

  // Delete a venue
  Future<void> deleteVenue(String venueId) async {
    await _venuesCollection.doc(venueId).delete();
  }

  // Retrieve all venues
  Future<List<VenueModel>> getAllVenues() async {
    final querySnapshot = await _venuesCollection.get();
    return querySnapshot.docs
        .map((doc) =>
            VenueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Search for venues by name or type
  Future<List<VenueModel>> searchVenues(String query) async {
    // Firestore doesn't support 'OR' queries directly, so perform multiple queries
    final nameQuerySnapshot = await _venuesCollection
        .where('venueName', isGreaterThanOrEqualTo: query)
        .where('venueName', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final typeQuerySnapshot =
        await _venuesCollection.where('venueType', isEqualTo: query).get();

    // Combine results without duplicates
    final Map<String, DocumentSnapshot> venueMap = {};

    for (var doc in nameQuerySnapshot.docs) {
      venueMap[doc.id] = doc;
    }

    for (var doc in typeQuerySnapshot.docs) {
      venueMap[doc.id] = doc;
    }

    return venueMap.values
        .map((doc) =>
            VenueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Additional methods can be added as needed
}
