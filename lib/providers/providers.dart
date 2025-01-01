import 'dart:typed_data';

import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/venue_notifiers.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/providers/user_notifier.dart';
// App general provider

enum AuthForm { login, signUp }

final authFormProvider = StateProvider<AuthForm>((ref) => AuthForm.login);

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

final languageProvider =
    StateProvider<String>((ref) => 'en'); // Default to 'en'

// This provider will store the index of the selected tab
// TODO: to be initialized to zero
final selectedMenuIndexProvider = StateProvider<int>((ref) => 1);
final appBarTitleProvider = StateProvider<String>((ref) => 'Dashboard');
// // Provider for logo aspect ratio
// final draftLogoAspectRatioProvider =
//     StateProvider<AspectRatioOption?>((ref) => AspectRatioOption.square);

//logo for image data provider - to be used to transfer data from widgte to widget
final draftLogoImageDataProvider = StateProvider<Uint8List?>((ref) => null);

// Provider for stable venue data from Firestore
final venueProvider = StateNotifierProvider<VenueNotifier, VenueModel?>((ref) {
  return VenueNotifier();
});

// Provider for editable draft venue data
final draftVenueProvider =
    StateNotifierProvider<VenueNotifier, VenueModel?>((ref) {
  return VenueNotifier();
});

// Holds a boolean: does the user want to delete the old image from Firestore?
final draftLogoDeleteProvider = StateProvider<bool>((ref) => false);

final venueListProvider = FutureProvider<List<VenueModel>>((ref) async {
  final user = ref.read(userProvider);
  if (user != null) {
    return FirestoreVenue().getAllVenues(user.userId);
  }
  return [];
});
