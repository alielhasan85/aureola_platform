import 'dart:typed_data';

import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aureola_platform/images/image_picker.dart';
import 'package:aureola_platform/images/venue_image_controller.dart';

class ImageUploadCard extends ConsumerWidget {
  final double width;
  final String imageKey; // e.g. 'logoUrl'
  final String imageCategory; // e.g. 'branding'
  final String imageType; // e.g. 'logo', 'background'
  final AspectRatioOption aspectRatioOption;

  const ImageUploadCard({
    super.key,
    required this.width,
    required this.imageKey,
    required this.imageCategory,
    required this.imageType,
    required this.aspectRatioOption,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftVenue = ref.watch(draftVenueProvider);
    final draftImageData = ref.watch(draftLogoImageDataProvider);

    // If the user previously saved an image in Firestore, its URL is stored here:
    final existingImageUrl = (draftVenue != null && imageKey == 'logoUrl')
        ? draftVenue.designAndDisplay.logoUrl
        : '';

    final hasDraftImage = (draftImageData != null);
    final hasExistingImage = existingImageUrl.isNotEmpty;

    // Decide which widget to display inside the container
    Widget imageWidget;
    if (hasDraftImage) {
      // Show the newly picked image in memory
      imageWidget = Image.memory(draftImageData!, fit: BoxFit.cover);
    } else if (hasExistingImage) {
      // Show the image from Firestore
      imageWidget = CachedNetworkImage(
        imageUrl: existingImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      // Show a placeholder if no image at all
      imageWidget = Center(
        child: Text(
          'Tap to upload image',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      );
    }

    // Build the container with the “pick” tap
    return Stack(
      children: [
        InkWell(
          onTap: () => _onPickImage(context, ref),
          child: Container(
            width: width,
            height: width *
                (aspectRatioOption.heightRatio / aspectRatioOption.widthRatio),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
          ),
        ),
        // Decide whether to show a close icon
        // 1) If we have a draft image, show a "clear" button
        if (hasDraftImage)
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              iconSize: 24,
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _onClearDraftImage(ref),
            ),
          )
        // 2) If we do NOT have a draft image but do have an existing image,
        //    show a "delete" button that removes it from Firestore + Storage
        else if (hasExistingImage)
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              iconSize: 24,
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _onDeleteExistingImage(context, ref),
            ),
          ),
      ],
    );
  }

  /// Handle picking a new image from local device (draft only).
  Future<void> _onPickImage(BuildContext context, WidgetRef ref) async {
    final aspectRatio = aspectRatioOption.toCropAspectRatio();
    final imageData = await ImagePickerWidget.pickAndCropImage(
      context,
      aspectRatio: aspectRatio,
    );
    if (imageData != null) {
      // Store the picked image in the draft
      ref.read(draftLogoImageDataProvider.notifier).state = imageData;
    }
  }

  /// Clears an unsaved draft image from memory.
  void _onClearDraftImage(WidgetRef ref) {
    ref.read(draftLogoImageDataProvider.notifier).state = null;
  }

  /// Deletes an existing, already saved image from Firestore + Storage.
  Future<void> _onDeleteExistingImage(
      BuildContext context, WidgetRef ref) async {
    final confirm = await _showDeleteConfirmationDialog(context);
    if (!confirm) return;

    final imageController = ref.read(venueImageControllerProvider.notifier);
    await imageController.deleteImage(imageKey: imageKey);

    // The above call sets draftVenue's URL to "",
    // so no draftImageData needed to clear here.
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
              size: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text('Delete Image'),
            content: const Text('Are you sure you want to delete this image?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
