import 'package:aureola_platform/models/user/notification.dart';
import 'package:aureola_platform/models/user/payment.dart';
import 'package:aureola_platform/models/user/subscription.dart';
import 'package:aureola_platform/models/user/user_setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/service/firebase/firestore_user.dart';

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
                phoneNumber: updatedData['contact']['phoneNumber'] ??
                    state!.contact.phoneNumber,
                countryCode: updatedData['contact']['countryCode'] ??
                    state!.contact.countryCode,
                countryDial: updatedData['contact']['countryDial'] ??
                    state!.contact.countryDial,
              )
            : state!.contact,
        address: updatedData['address'] != null
            ? state!.address.copyWith(
                country:
                    updatedData['address']['country'] ?? state!.address.country,
                state: updatedData['address']['state'] ?? state!.address.state,
                city: updatedData['address']['city'] ?? state!.address.city,
                addressLine: updatedData['address']['addressLine'] ??
                    state!.address.addressLine,
              )
            : state!.address,
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

  // Function to update the user's subscription
  Future<void> updateSubscription(Subscription subscription) async {
    if (state != null) {
      await FirestoreUser().updateUserSubscription(state!.userId, subscription);
      state = state!.copyWith(subscription: subscription);
    }
  }

  // Function to update notifications preferences
  Future<void> updateNotifications(Notifications notifications) async {
    if (state != null) {
      await FirestoreUser().updateUserNotificationPreferences(
        state!.userId,
        emailNotification: notifications.emailNotification,
        smsNotification: notifications.smsNotification,
      );
      state = state!.copyWith(notifications: notifications);
    }
  }

  // Function to record a payment
  Future<void> recordPayment(Payment payment) async {
    if (state != null) {
      await FirestoreUser().recordPayment(state!.userId, payment);
      // Update local state
      final updatedPaymentHistory = List<Payment>.from(state!.paymentHistory)
        ..add(payment);
      state = state!.copyWith(
        totalPaid: state!.totalPaid + payment.amount,
        paymentHistory: updatedPaymentHistory,
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
