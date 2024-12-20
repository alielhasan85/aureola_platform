import 'dart:typed_data';

import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/providers/venue_notifiers.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
// App general provider

enum AuthForm { login, signUp }

final authFormProvider = StateProvider<AuthForm>((ref) => AuthForm.login);

final languageProvider =
    StateProvider<String>((ref) => 'en'); // Default to 'en'

// This provider will store the index of the selected tab
// TODO: to be initialized to zero
final selectedMenuIndexProvider = StateProvider<int>((ref) => 10);

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

final venueListProvider = FutureProvider<List<VenueModel>>((ref) async {
  final user = ref.read(userProvider);
  if (user != null) {
    return FirestoreVenue().getAllVenues(user.userId);
  }
  return [];
});
