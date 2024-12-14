// lib/service/firebase/firebase_storage_service.dart

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads an image and returns the download URL.
  ///
  /// [imageData]: The image data in bytes.
  /// [userId]: The ID of the user uploading the image.
  /// [venueId]: The ID of the venue associated with the image.
  /// [imageCategory]: The category of the image (e.g., branding, meals).
  /// [imageType]: The type of image within the category (e.g., logo, background).
  Future<String?> uploadImage({
    required Uint8List imageData,
    required String userId,
    required String venueId,
    required String imageCategory, // e.g., branding, meals, offers
    required String imageType, // e.g., logo, background, mealImage, etc.
  }) async {
    try {
      // Generate a logical and unique file name
      final fileName =
          _generateFileName(userId, venueId, imageCategory, imageType);
      final ref = _storage.ref().child(fileName);

      // Upload the image
      final uploadTask = ref.putData(imageData);

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  /// Generates a unique and logical file name based on provided parameters.
  ///
  /// Returns a path string in the format:
  /// 'users/$userId/$venueId/$imageCategory/$imageType-$timestamp.webp'
  String _generateFileName(
      String userId, String venueId, String imageCategory, String imageType) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // Optional: Use UUID for more uniqueness
    // String uuid = const Uuid().v4();
    return 'users/$userId/$venueId/$imageCategory/$imageType-$timestamp.webp';
    // If using UUID:
    // return 'users/$userId/$venueId/$imageCategory/$imageType-$uuid.webp';
  }

  /// Deletes an image from Firebase Storage by its download URL.
  Future<void> deleteImage(String imageUrl) async {
    try {
      final storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  /// Deletes all images within a specific category for a venue.
  ///
  /// [userId]: The ID of the user.
  /// [venueId]: The ID of the venue.
  /// [imageCategory]: The category of images to delete (e.g., branding, meals).
  Future<void> deleteAllVenueCategoryImages({
    required String userId,
    required String venueId,
    required String imageCategory,
  }) async {
    try {
      final ListResult result = await _storage
          .ref()
          .child('users/$userId/$venueId/$imageCategory')
          .listAll();

      for (var file in result.items) {
        await file.delete();
      }
    } catch (e) {
      throw Exception(
          'Error deleting all images in category "$imageCategory": $e');
    }
  }

  /// Deletes all images across all categories for a specific venue.
  ///
  /// [userId]: The ID of the user.
  /// [venueId]: The ID of the venue.
  /// [imageCategories]: A list of image categories to delete (e.g., branding, meals, offers).
  Future<void> deleteAllVenueImages({
    required String userId,
    required String venueId,
    required List<String> imageCategories,
  }) async {
    try {
      for (var category in imageCategories) {
        await deleteAllVenueCategoryImages(
          userId: userId,
          venueId: venueId,
          imageCategory: category,
        );
      }
    } catch (e) {
      throw Exception('Error deleting all venue images: $e');
    }
  }

  /// Deletes all files related to a specific user across all venues and categories.
  ///
  /// [userId]: The ID of the user.
  Future<void> deleteAllUserFiles(String userId) async {
    try {
      final ListResult venuesResult =
          await _storage.ref().child('users/$userId').listAll();

      for (var venueRef in venuesResult.prefixes) {
        final String venueId =
            venueRef.name; // Assuming venueRef.name is venueId
        final ListResult categoriesResult = await venueRef.listAll();

        for (var categoryRef in categoriesResult.prefixes) {
          final ListResult imagesResult = await categoryRef.listAll();

          for (var imageRef in imagesResult.items) {
            await imageRef.delete();
          }
        }
      }
    } catch (e) {
      throw Exception('Error deleting all user files: $e');
    }
  }
}
