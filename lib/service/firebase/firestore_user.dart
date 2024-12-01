import 'package:aureola_platform/models/user/subscription.dart';
import 'package:aureola_platform/models/user/user_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/models/user/payment.dart';

class FirestoreUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection;

  FirestoreUser()
      : _usersCollection = FirebaseFirestore.instance.collection('users');

  // Check if a user with the given email or phone number already exists in Firestore.
  Future<bool> checkIfUserExists(
      {required String email, String? phoneNumber}) async {
    // Check by email
    final emailQuery =
        _usersCollection.where('contact.email', isEqualTo: email);

    // Check by phone number if provided
    Query? phoneQuery;
    if (phoneNumber != null) {
      phoneQuery =
          _usersCollection.where('contact.phoneNumber', isEqualTo: phoneNumber);
    }

    // Combine queries
    List<Future<QuerySnapshot>> futures = [
      emailQuery.limit(1).get(),
      if (phoneQuery != null) phoneQuery.limit(1).get(),
    ];

    List<QuerySnapshot> querySnapshots = await Future.wait(futures);

    for (var snapshot in querySnapshots) {
      if (snapshot.docs.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  // Add a new user to Firestore with the provided [UserModel] data.
  Future<void> addUser(UserModel user) async {
    await _usersCollection.doc(user.userId).set(user.toMap());
  }

  // Delete a user from Firestore by their [userId].
  Future<void> deleteUser(String userId) async {
    await _usersCollection.doc(userId).delete();
  }

  // Deactivate a user by setting their `isActive` field to false (soft delete).
  Future<void> deactivateUser(String userId) async {
    await _usersCollection.doc(userId).update({'isActive': false});
  }

  // Reactivate a user by setting their `isActive` field to true.
  Future<void> reactivateUser(String userId) async {
    await _usersCollection.doc(userId).update({'isActive': true});
  }

  // Update specific fields of a user's data by their [userId] with the [updatedData] provided.
  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    await _usersCollection.doc(userId).update(updatedData);
  }

  // Retrieve a user's data from Firestore by their [userId].
  Future<UserModel?> getUserById(String userId) async {
    final docSnapshot = await _usersCollection.doc(userId).get();

    if (docSnapshot.exists) {
      return UserModel.fromMap(
          docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
    }

    return null;
  }

  // Retrieve a list of all users in Firestore.
  Future<List<UserModel>> getAllUsers() async {
    final querySnapshot = await _usersCollection.get();
    return querySnapshot.docs
        .map((doc) =>
            UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Search for users by their name or email using the [query] provided.
  Future<List<UserModel>> searchUsers(String query) async {
    // Perform two separate queries since Firestore doesn't support 'or' queries directly.
    final nameQuerySnapshot = await _usersCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final emailQuerySnapshot = await _usersCollection
        .where('contact.email', isGreaterThanOrEqualTo: query)
        .where('contact.email', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    // Combine the results, avoiding duplicates
    final Map<String, DocumentSnapshot> userMap = {};

    for (var doc in nameQuerySnapshot.docs) {
      userMap[doc.id] = doc;
    }

    for (var doc in emailQuerySnapshot.docs) {
      userMap[doc.id] = doc;
    }

    return userMap.values
        .map((doc) =>
            UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Update the notification preferences of a user.
  Future<void> updateUserNotificationPreferences(String userId,
      {bool? emailNotification, bool? smsNotification}) async {
    final updates = <String, dynamic>{};
    if (emailNotification != null)
      updates['notifications.emailNotification'] = emailNotification;
    if (smsNotification != null)
      updates['notifications.smsNotification'] = smsNotification;

    await _usersCollection.doc(userId).update(updates);
  }

  // Increment the login count for a user.
  Future<void> incrementLoginCount(String userId) async {
    await _usersCollection.doc(userId).update({
      'loginCount': FieldValue.increment(1),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  // Record a payment made by the user.
  Future<void> recordPayment(String userId, Payment payment) async {
    await _usersCollection.doc(userId).update({
      'totalPaid': FieldValue.increment(payment.amount),
      'paymentHistory': FieldValue.arrayUnion([payment.toMap()]),
    });
  }

  // Update user settings.
  Future<void> updateUserSettings(
      String userId, UserSettings userSettings) async {
    await _usersCollection.doc(userId).update({
      'userSettings': userSettings.toMap(),
    });
  }

  // Update the subscription of a user.
  Future<void> updateUserSubscription(
      String userId, Subscription subscription) async {
    await _usersCollection.doc(userId).update({
      'subscription': subscription.toMap(),
    });
  }

  // Set a password reset token for a user.
  Future<void> setPasswordResetToken(String userId, String token) async {
    await _usersCollection.doc(userId).update({
      'resetToken': token,
      'tokenGeneratedAt': FieldValue.serverTimestamp(),
    });
  }
}
