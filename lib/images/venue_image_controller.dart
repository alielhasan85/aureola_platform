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
  VenueImageController(this.ref) : super(const AsyncData(null));

  final Ref ref;
  final _storageService = FirebaseStorageService();
  final _firestoreVenue = FirestoreVenue();

  /// Upload a cropped image to Firebase Storage and update Firestore & venueProvider.
  /// [imageKey] is either 'logoUrl' or 'backgroundUrl'.
  Future<void> uploadImage({
    required Uint8List imageData,
    required String imageKey,
    required String imageCategory, // e.g., 'branding'
    required String imageType, // e.g., 'logo' or 'background'
  }) async {
    state = const AsyncLoading();

    final venue = ref.read(venueProvider);
    if (venue == null) {
      //state = AsyncError( 'No venue data available');
      return;
    }

    final userId = venue.userId;
    final venueId = venue.venueId;

    try {
      // If there's an old image, delete it first
      String oldImageUrl = _getCurrentImageUrl(venue, imageKey);
      if (oldImageUrl.isNotEmpty) {
        await _storageService.deleteImage(oldImageUrl);
      }

      // Upload new image
      final imageUrl = await _storageService.uploadImage(
        imageData: imageData,
        userId: userId,
        venueId: venueId,
        imageCategory: imageCategory,
        imageType: imageType,
      );

      if (imageUrl == null) {
        throw Exception('Failed to upload image');
      }

      // Update Firestore
      await _updateVenueDesignAndDisplay(userId, venueId, imageKey, imageUrl);

      // Update venue provider
      _updateVenueProvider(imageKey, imageUrl);

      state = const AsyncData(null);
    } catch (e) {
      // state = AsyncError(e);
    }
  }

  /// Delete an existing image from Storage and update Firestore & venueProvider.
  Future<void> deleteImage({
    required String imageKey,
  }) async {
    state = const AsyncLoading();

    final venue = ref.read(venueProvider);
    if (venue == null) {
      // state = AsyncError('No venue data available');
      return;
    }

    final userId = venue.userId;
    final venueId = venue.venueId;
    final imageUrl = _getCurrentImageUrl(venue, imageKey);

    if (imageUrl.isEmpty) {
      state = AsyncData(null); // Nothing to delete
      return;
    }

    try {
      // Delete from Storage
      await _storageService.deleteImage(imageUrl);

      // Delete from Firestore
      await _firestoreVenue.deleteDesignAndDisplayField(
        userId: userId,
        venueId: venueId,
        fieldKey: imageKey,
      );

      // Update provider
      _updateVenueProvider(imageKey, '');

      state = const AsyncData(null);
    } catch (e) {
      //  state = AsyncError(e);
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

  Future<void> _updateVenueDesignAndDisplay(
    String userId,
    String venueId,
    String imageKey,
    String imageUrl,
  ) async {
    final currentDesign = (await ref.read(venueProvider))?.designAndDisplay ??
        const DesignAndDisplay();

    DesignAndDisplay updatedDesign;
    if (imageKey == 'logoUrl') {
      updatedDesign = currentDesign.copyWith(logoUrl: imageUrl);
    } else {
      updatedDesign = currentDesign.copyWith(backgroundUrl: imageUrl);
    }

    await _firestoreVenue.updateVenue(
      userId,
      venueId,
      {'designAndDisplay': updatedDesign.toMap()},
    );
  }

  void _updateVenueProvider(String imageKey, String imageUrl) {
    final venue = ref.read(venueProvider);
    if (venue == null) return;

    final currentDesign = venue.designAndDisplay;
    DesignAndDisplay updatedDesign;
    if (imageKey == 'logoUrl') {
      updatedDesign = currentDesign.copyWith(logoUrl: imageUrl);
    } else {
      updatedDesign = currentDesign.copyWith(backgroundUrl: imageUrl);
    }

    ref.read(venueProvider.notifier).setVenue(
          venue.copyWith(designAndDisplay: updatedDesign),
        );
  }
}

/// A provider for the VenueImageController
final venueImageControllerProvider =
    StateNotifierProvider<VenueImageController, AsyncValue<void>>((ref) {
  return VenueImageController(ref);
});
