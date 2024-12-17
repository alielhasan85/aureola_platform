import 'dart:typed_data';

import 'package:aureola_platform/service/firebase/firebase_storage.dart';
import 'package:aureola_platform/widgest/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/providers/venue_provider.dart';

import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class MapPickerDialog extends ConsumerStatefulWidget {
  final double containerWidth;

  const MapPickerDialog({
    super.key,
    required this.containerWidth,
  });

  @override
  ConsumerState<MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends ConsumerState<MapPickerDialog> {
  late LatLng _pickedLocation;
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    final venue = ref.read(venueProvider);
    print('checking location inisde mapicker');
    print(venue?.address.location);
    // Initialize with the venue's current location or a default location
    _pickedLocation =
        venue?.address.location ?? const LatLng(25.286106, 51.534817);
  }

  String buildStaticMapUrl({
    required double latitude,
    required double longitude,
    required String apiKey,
    String size = '600x300',
    String mapType = 'roadmap',
    int zoom = 15,
  }) {
    final staticMapUrl = Uri.https(
      'maps.googleapis.com',
      '/maps/api/staticmap',
      {
        'center': '$latitude,$longitude',
        'zoom': '$zoom',
        'size': size,
        'maptype': mapType,
        'markers': 'color:red|$latitude,$longitude',
        'key': apiKey,
      },
    ).toString();

    return staticMapUrl;
  }

  Future<String?> _fetchAndUploadStaticMapImage({
    required LatLng location,
    required String userId,
    required String venueId,
    required String imageType,
    required String apiKey,
  }) async {
    try {
      // Build the static map URL
      final imageUrl = buildStaticMapUrl(
        latitude: location.latitude,
        longitude: location.longitude,
        apiKey: apiKey,
      );

      // Fetch the image data from Google Maps
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch static map image from Google: ${response.statusCode}');
      }

      // Convert the image data to Uint8List
      final Uint8List imageData = response.bodyBytes;

      // Upload the image to Firebase Storage
      final storageService = FirebaseStorageService();
      final downloadUrl = await storageService.uploadImage(
        imageData: imageData,
        userId: userId,
        venueId: venueId,
        imageCategory: 'map',
        imageType: imageType,
      );

      if (downloadUrl == null) {
        throw Exception('Failed to upload image to Firebase Storage');
      }

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.read(venueProvider);

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.translate("Select_Location_from_Map"),
      ),
      titleTextStyle: AppTheme.appBarTitle.copyWith(fontSize: 16),
      content: SizedBox(
        width: widget.containerWidth,
        height: 400,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _pickedLocation,
                zoom: 17,
              ),
              onTap: (LatLng location) {
                setState(() {
                  _pickedLocation = location;
                });
              },
              markers: {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: _pickedLocation,
                ),
              },
            ),
            if (_isLoading) CustomProgressIndicator(), // Show loading indicator
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (!_isLoading) Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_isLoading) return;

            setState(() {
              _isLoading = true; // Start loading
            });

            try {
              const String apiKey =
                  'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA'; // Replace with actual API key
              final venue = ref.read(venueProvider);

              if (venue == null) {
                throw Exception('Venue is null');
              }

              final userId = venue.userId;
              final venueId = venue.venueId;

              final downloadUrl = await _fetchAndUploadStaticMapImage(
                location: _pickedLocation,
                userId: userId,
                venueId: venueId,
                imageType: 'static_map',
                apiKey: apiKey,
              );

              if (downloadUrl == null) {
                throw Exception('Image upload failed');
              }

              // Update provider with new image URL
              ref.read(venueProvider.notifier).updateAddress(
                    location: _pickedLocation,
                    displayAddress:
                        'Updated Address', // Replace with actual data
                  );
              ref.read(venueProvider.notifier).updateMapImageUrl(downloadUrl);

              Navigator.of(context).pop(); // Close the dialog
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            } finally {
              setState(() {
                _isLoading = false; // Stop loading
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
