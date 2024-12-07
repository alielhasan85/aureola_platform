import 'package:aureola_platform/models/user/user_setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/service/firebase/firestore_user.dart';

// TODO: not sure if function are repeating here and in firebase
class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  // Function to set the user data
  void setUser(UserModel user) {
    state = user;
  }

  // Function to clear the user data
  void clearUser() {
    state = null;
  }

  // Function to fetch the user data from Firestore and set it
  Future<void> fetchUser(String userId) async {
    final userData = await FirestoreUser().getUserById(userId);
    if (userData != null) {
      setUser(userData);
    }
  }

  // Function to update user data locally and in Firestore
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    if (state != null) {
      final userId = state!.userId;

      // Update Firestore with the new data
      await FirestoreUser().updateUser(userId, updatedData);

      // Update the state locally using copyWith and handling nested objects
      state = state!.copyWith(
        name: updatedData['name'] ?? state!.name,
        jobTitle: updatedData['jobTitle'] ?? state!.jobTitle,
        businessName: updatedData['businessName'] ?? state!.businessName,
        contact: updatedData['contact'] != null
            ? state!.contact.copyWith(
                email: updatedData['contact']['email'] ?? state!.contact.email,
                countryDial: updatedData['contact']['countryDial'] ??
                    state!.contact.countryDial,
                phoneNumber: updatedData['contact']['phoneNumber'] ??
                    state!.contact.phoneNumber,
                countryName: updatedData['contact']['countryName'] ??
                    state!.contact.countryName,
                website:
                    updatedData['contact']['website'] ?? state!.contact.website,
              )
            : state!.contact,

        subscription: updatedData['subscription'] != null
            ? state!.subscription.copyWith(
                type: updatedData['subscription']['type'] ??
                    state!.subscription.type,
                featuresEnabled: updatedData['subscription']
                        ['featuresEnabled'] ??
                    state!.subscription.featuresEnabled,
                startDate: updatedData['subscription']['startDate'] ??
                    state!.subscription.startDate,
                endDate: updatedData['subscription']['endDate'] ??
                    state!.subscription.endDate,
              )
            : state!.subscription,
        // Update other fields as needed
      );
    }
  }

  // Function to update user settings
  Future<void> updateUserSettings(UserSettings settings) async {
    if (state != null) {
      await FirestoreUser().updateUserSettings(state!.userId, settings);
      state = state!.copyWith(userSettings: settings);
    }
  }
}
