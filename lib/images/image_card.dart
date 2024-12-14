import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/images/image_picker.dart';
import 'package:aureola_platform/images/venue_image_controller.dart';

class ImageUploadCard extends ConsumerWidget {
  final double width;
  final String imageKey; // e.g. 'logoUrl'
  final String imageCategory; // e.g. 'branding'
  final String imageType; // e.g. 'logo', 'background'
  final AspectRatioOption aspectRatioOption; // Add this to specify ratio

  const ImageUploadCard({
    Key? key,
    required this.width,
    required this.imageKey,
    required this.imageCategory,
    required this.imageType,
    required this.aspectRatioOption,
  }) : super(key: key);

  Future<void> _onPickImage(BuildContext context, WidgetRef ref) async {
    final aspectRatio = aspectRatioOption.toCropAspectRatio();
    final imageData = await ImagePickerWidget.pickAndCropImage(
      context,
      aspectRatio: aspectRatio,
    );

    if (imageData != null) {
      ref.read(venueImageControllerProvider.notifier).uploadImage(
            imageData: imageData,
            imageKey: imageKey,
            imageCategory: imageCategory,
            imageType: imageType,
          );
    }
  }

  Future<void> _onDeleteImage(BuildContext context, WidgetRef ref) async {
    bool confirm = await _showDeleteConfirmationDialog(context);
    if (!confirm) return;

    ref.read(venueImageControllerProvider.notifier).deleteImage(
          imageKey: imageKey,
        );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venue = ref.watch(venueProvider);
    final imageUrl = venue != null
        ? (imageKey == 'logoUrl'
            ? venue.designAndDisplay.logoUrl
            : venue.designAndDisplay.backgroundUrl)
        : '';

    Widget imageWidget = imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : Center(
            child: Text(
              'Tap to upload image',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          );

    return InkWell(
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
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageWidget,
              ),
            ),
            if (imageUrl.isNotEmpty)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _onDeleteImage(context, ref),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
