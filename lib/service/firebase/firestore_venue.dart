// firestore_venue.dart

import 'package:aureola_platform/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';

class FirestoreVenue {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _venuesCollection;

  FirestoreVenue()
      : _venuesCollection = FirebaseFirestore.instance.collection('venues');

// Add a new venue to a specific user's document in Firestore
  Future<String> addVenue(String userId, VenueModel venue) async {
    final venuesCollection =
        _firestore.collection('users').doc(userId).collection('venues');

    // Generate a new document ID
    DocumentReference venueDoc = venuesCollection.doc();
    venue = venue.copyWith(venueId: venueDoc.id);

    await venueDoc.set(venue.toMap());

    // Return the newly created venue ID
    return venueDoc.id;
  }
  // // Add a new venue to Firestore
  // Future<void> addVenue(VenueModel venue) async {
  //   await _venuesCollection.doc(venue.venueId).set(venue.toMap());
  // }

  // Create a default venue when a user account is created
  // Future<void> createDefaultVenue(UserModel user) async {
  //   try {
  //     // Extracting the necessary contact information (email, phone, country code) from user model
  //     VenueModel defaultVenue = VenueModel(
  //       venueId: '', // Firestore will generate the ID
  //       venueName: user.businessName, // Default venue name from the user model
  //       userId: user.userId, // Pass the userId from the UserModel
  //       address: ,
  //       contact: ,
  //       // Additional fields left as defaults or set according to your needs
  //       socialAccounts: ,
  //       operations: ,
  //       qrCodes: ,
  //       designAndDisplay: ,
  //       priceOptions: ,
  //     );

  //     // Add the venue using the addVenue method
  //     await addVenue(user.userId, defaultVenue);

  //     print('Default venue created successfully');
  //   } catch (e) {
  //     print('Error creating default venue: $e');
  //     // Handle error (e.g., show a message to the user)
  //   }
  // }

  // Update specific fields of a venue by its [venueId] for a specific user
  Future<void> updateVenue(
      String userId, String venueId, Map<String, dynamic> updatedData) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.update(updatedData);
  }

  // // Update specific fields of an existing venue
  // Future<void> updateVenue(
  //     String venueId, Map<String, dynamic> updatedData) async {
  //   await _venuesCollection.doc(venueId).update(updatedData);
  // }

  // // Delete a venue
  // Future<void> deleteVenue(String venueId) async {
  //   await _venuesCollection.doc(venueId).delete();
  // }

  // Delete a venue from Firestore by its [venueId] for a specific user
  Future<void> deleteVenue(String userId, String venueId) async {
    final venueDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .doc(venueId);

    await venueDoc.delete();
  }

//  // Retrieve a venue by ID
//   Future<VenueModel?> getVenueById(String venueId) async {
//     final docSnapshot = await _venuesCollection.doc(venueId).get();
//     if (docSnapshot.exists) {
//       return VenueModel.fromMap(
//           docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
//     }
//     return null;
//   }

// Retrieve a specific venue's data by its [venueId] for a specific user
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

  // Retrieve a list of all venues for a specific user
  Future<List<VenueModel>> getAllVenues(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('venues')
        .get();

    return querySnapshot.docs
        .map((doc) =>
            VenueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
  // // Retrieve all venues
  // Future<List<VenueModel>> getAllVenues() async {
  //   final querySnapshot = await _venuesCollection.get();
  //   return querySnapshot.docs
  //       .map((doc) =>
  //           VenueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
  //       .toList();
  // }

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