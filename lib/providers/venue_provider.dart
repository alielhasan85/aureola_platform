import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/providers/venue_notifiers.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final venueProvider = StateNotifierProvider<VenueNotifier, VenueModel?>((ref) {
  return VenueNotifier();
});

final venueListProvider = FutureProvider<List<VenueModel>>((ref) async {
  final user = ref.read(userProvider);
  if (user != null) {
    return FirestoreVenue().getAllVenues(user.userId);
  }
  return [];
});
