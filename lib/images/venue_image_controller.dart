import 'dart:typed_data';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/firebase/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';

class VenueImageController extends StateNotifier<AsyncValue<void>> {
  VenueImageController(this.ref) : super(const AsyncData(null));

  final Ref ref;
  final _storageService = FirebaseStorageService();

  /// Upload a cropped image to Firebase Storage.
  /// Returns the newly uploaded URL or null if error.
  Future<String?> uploadImage({
    required Uint8List imageData,
    required String imageKey, // e.g. 'logoUrl'
    required String imageCategory, // e.g. 'branding'
    required String imageType, // e.g. 'logo' or 'background'
  }) async {
    state = const AsyncLoading();

    final venue = ref.read(draftVenueProvider);
    if (venue == null) {
      state = AsyncError('No venue data available', StackTrace.current);
      return null;
    }

    try {
      // If there's an old image, delete it from Storage
      final oldImageUrl = _getCurrentImageUrl(venue, imageKey);
      if (oldImageUrl.isNotEmpty) {
        await _storageService.deleteImage(oldImageUrl);
      }

      // Upload new image
      final newUrl = await _storageService.uploadImage(
        imageData: imageData,
        userId: venue.userId,
        venueId: venue.venueId,
        imageCategory: imageCategory,
        imageType: imageType,
      );
      if (newUrl == null) {
        throw Exception('Failed to upload image');
      }

      // Return the new URL (do NOT update Firestore here)
      state = const AsyncData(null);
      return newUrl;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }

  /// Optionally used if you want to forcibly delete from Storage
  /// before or after finalizing changes.
  Future<void> deleteImage({
    required String imageKey,
  }) async {
    state = const AsyncLoading();

    final venue = ref.read(draftVenueProvider);
    if (venue == null) {
      state = AsyncError('No venue data available', StackTrace.current);
      return;
    }

    try {
      final imageUrl = _getCurrentImageUrl(venue, imageKey);
      if (imageUrl.isNotEmpty) {
        await _storageService.deleteImage(imageUrl);
      }
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  String _getCurrentImageUrl(VenueModel venue, String imageKey) {
    final design = venue.designAndDisplay;
    if (imageKey == 'logoUrl') {
      return design.logoUrl;
    } else if (imageKey == 'backgroundUrl') {
      return design.backgroundUrl;
    }
    return '';
  }
}

final venueImageControllerProvider =
    StateNotifierProvider<VenueImageController, AsyncValue<void>>((ref) {
  return VenueImageController(ref);
});
