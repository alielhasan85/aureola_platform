import 'dart:typed_data';

import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aureola_platform/images/image_picker.dart';

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
    final newImageData = ref.watch(draftLogoImageDataProvider);
    final wantToDeleteOldImage = ref.watch(draftLogoDeleteProvider);

    // Existing Firestore image (if any)
    String existingImageUrl = '';
    if (draftVenue != null && imageKey == 'logoUrl') {
      existingImageUrl = draftVenue.designAndDisplay.logoUrl;
    }
    print(draftVenue?.designAndDisplay.logoUrl);

    // Decide what to show
    Widget imageWidget;
    // Priority #1: If a new image is in memory, show that
    if (newImageData != null) {
      imageWidget = Image.memory(newImageData, fit: BoxFit.cover);

      // Priority #2: If the user hasn't "deleted" the old image, and we have an old image, show it
    } else if (!wantToDeleteOldImage && existingImageUrl.isNotEmpty) {
      imageWidget = Image.network(
        existingImageUrl,
        fit: BoxFit.cover,
        
      );

      // Otherwise, placeholder
    } else {
      imageWidget = Center(
        child: Text(
          'Tap to upload image',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      );
    }

    // Container
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

        // If there's a new image in memory, show a "Clear" button
        if (newImageData != null)
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () =>
                  ref.read(draftLogoImageDataProvider.notifier).state = null,
            ),
          )
        // If there's NO new image, but the old image is present (and not yet "deleted"), show "Delete"
        else if (!wantToDeleteOldImage && existingImageUrl.isNotEmpty)
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () =>
                  ref.read(draftLogoDeleteProvider.notifier).state = true,
            ),
          ),
      ],
    );
  }

  /// Pick a new image from the local device
  Future<void> _onPickImage(BuildContext context, WidgetRef ref) async {
    final aspectRatio = aspectRatioOption.toCropAspectRatio();
    final imageData = await ImagePickerWidget.pickAndCropImage(
      context,
      aspectRatio: aspectRatio,
    );
    if (imageData != null) {
      // If user picks a new image, clear any "delete" request for the old image
      ref.read(draftLogoDeleteProvider.notifier).state = false;
      // Set the new image
      ref.read(draftLogoImageDataProvider.notifier).state = imageData;
    }
  }
}
