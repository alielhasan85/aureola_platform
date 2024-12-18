import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final String apiKey;

  LocationService({required this.apiKey});

  Future<String?> fetchAndUploadStaticMapImage({
    required LatLng location,
    required String userId,
    required String venueId,
    required Future<String?> Function(
            Uint8List imageData, String imageCategory, String imageType)
        uploadImage,
  }) async {
    try {
      final imageUrl = _buildStaticMapUrl(
        latitude: location.latitude,
        longitude: location.longitude,
        apiKey: apiKey,
      );

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch static map image: ${response.statusCode}');
      }

      final imageData = response.bodyBytes;
      final downloadUrl = await uploadImage(imageData, 'map', 'static_map');
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  String _buildStaticMapUrl({
    required double latitude,
    required double longitude,
    required String apiKey,
    String size = '600x300',
    String mapType = 'roadmap',
    int zoom = 15,
  }) {
    final uri = Uri.https(
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
    );
    return uri.toString();
  }

  Future<String?> reverseGeocode(LatLng location, String language) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2'
        '&lat=${location.latitude}&lon=${location.longitude}&accept-language=$language',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'];
      }
    } catch (_) {}
    return null; // fallback if reverse geocode fails
  }
}
