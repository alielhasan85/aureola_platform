import 'dart:typed_data';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/firebase/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';

/// This controller handles image upload logic:
/// - Receives raw/cropped image bytes
/// - Uploads to Firebase Storage
/// - Updates Firestore
/// - Updates the venue provider state
class VenueImageController extends StateNotifier<AsyncValue<void>> {
  VenueImageController(this.ref) : super(AsyncData(null));

  final Ref ref;
  final _storageService = FirebaseStorageService();

  /// Upload a cropped image to Firebase Storage only.
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
      // If no venue in draft, can't proceed
      state = AsyncError('No venue data available', StackTrace.current);
      return null;
    }

    try {
      // 1. Delete old image from Firebase Storage, if present
      final oldImageUrl = _getCurrentImageUrl(venue, imageKey);
      if (oldImageUrl.isNotEmpty) {
        await _storageService.deleteImage(oldImageUrl);
      }

      // 2. Upload new image
      final imageUrl = await _storageService.uploadImage(
        imageData: imageData,
        userId: venue.userId,
        venueId: venue.venueId,
        imageCategory: imageCategory,
        imageType: imageType,
      );
      if (imageUrl == null) {
        throw Exception('Failed to upload image');
      }

      // 3. Update the draft venue with the new URL (not Firestore)
      _updateDraftVenue(imageKey, imageUrl);

      state = const AsyncData(null);
      return imageUrl;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }

  /// If you really want to let users delete *right now*, you can do so.
  /// Otherwise, you could also handle "delete" in the parent widget.
  Future<void> deleteImage({required String imageKey}) async {
    state = const AsyncLoading();
    final venue = ref.read(draftVenueProvider);
    if (venue == null) {
      state = AsyncError('No venue data available', StackTrace.current);
      return;
    }

    final imageUrl = _getCurrentImageUrl(venue, imageKey);
    if (imageUrl.isEmpty) {
      state = const AsyncData(null); // Nothing to delete
      return;
    }

    try {
      // Delete from Firebase Storage
      await _storageService.deleteImage(imageUrl);

      // Update the local draft with an empty URL
      _updateDraftVenue(imageKey, '');

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

  void _updateDraftVenue(String imageKey, String imageUrl) {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    final currentDesign = venue.designAndDisplay;
    final updatedDesign = (imageKey == 'logoUrl')
        ? currentDesign.copyWith(logoUrl: imageUrl)
        : currentDesign.copyWith(backgroundUrl: imageUrl);

    ref.read(draftVenueProvider.notifier).setVenue(
          venue.copyWith(designAndDisplay: updatedDesign),
        );
  }
}

/// A provider for the VenueImageController
final venueImageControllerProvider =
    StateNotifierProvider<VenueImageController, AsyncValue<void>>((ref) {
  return VenueImageController(ref);
});
