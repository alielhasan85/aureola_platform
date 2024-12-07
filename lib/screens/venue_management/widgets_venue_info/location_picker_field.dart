// location_picker_field.dart

import 'package:aureola_platform/providers/lang_providers.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerField extends ConsumerStatefulWidget {
  final double width;
  final LatLng? selectedLocation;

  const LocationPickerField({
    super.key,
    required this.width,
    this.selectedLocation,
  });

  @override
  ConsumerState<LocationPickerField> createState() =>
      _LocationPickerFieldState();
}

class _LocationPickerFieldState extends ConsumerState<LocationPickerField> {
  final String apiKey =
      'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA'; // Replace with your actual API key

  LatLng? _selectedLatLng;
  String? _selectedAddress;

  // Flag to ensure ref.listen is only called once
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    //TODO : to check if we can get address from GPS
    // Initialize with the selected location or default location (e.g., Doha, Qatar)
    _selectedLatLng =
        widget.selectedLocation ?? const LatLng(25.286106, 51.534817);

    // Delay reverse geocoding until after the first build to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLanguage = ref.read(languageProvider);
      _reverseGeocode(_selectedLatLng!, language: currentLanguage);
    });
  }

  @override
  void didUpdateWidget(covariant LocationPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLocation != oldWidget.selectedLocation &&
        widget.selectedLocation != null) {
      _selectedLatLng = widget.selectedLocation;
      final currentLanguage = ref.read(languageProvider);
      _reverseGeocode(_selectedLatLng!, language: currentLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the languageProvider to get the current language
    final currentLanguage = ref.watch(languageProvider);

    // Set up ref.listen only once
    if (!_isListening) {
      _isListening = true;
      ref.listen<String>(languageProvider, (previous, next) {
        if (_selectedLatLng != null) {
          _reverseGeocode(_selectedLatLng!, language: next);
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (_selectedAddress != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.translate("selected_location:"),
                style: AppTheme.paragraph,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Directionality(
                  textDirection: currentLanguage == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Text(
                    _selectedAddress!,
                    style: AppTheme.paragraph,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        // Display Static Map Image
        _buildStaticMapImage(),
      ],
    );
  }

  Widget _buildStaticMapImage() {
    return Image.network(
      _buildStaticMapUrl(),
      height: 300,
      width: widget.width,
      fit: BoxFit.cover,
    );
  }

  String _buildStaticMapUrl() {
    final lat = _selectedLatLng!.latitude;
    final lng = _selectedLatLng!.longitude;

    final staticMapUrl = Uri.https(
      'maps.googleapis.com',
      '/maps/api/staticmap',
      {
        'center': '$lat,$lng',
        'zoom': '15',
        'size': '600x300',
        'maptype': 'roadmap',
        'markers': 'color:red|$lat,$lng', // Corrected line
        'key': apiKey,
      },
    ).toString();

    return staticMapUrl;
  }

  Future<void> _reverseGeocode(LatLng location,
      {required String language}) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2'
        '&lat=${location.latitude}'
        '&lon=${location.longitude}'
        '&accept-language=$language',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        if (data['display_name'] != null) {
          setState(() {
            _selectedAddress = data['display_name'];
          });

          ref.read(venueProvider.notifier).updateAddress(
                location: location,
                displayAddress: data['display_name'],
                street: data['address']['road'] ?? '',
                city: data['address']['city'] ?? '',
                state: data['address']['state'] ?? '',
                postalCode: data['address']['postcode'] ?? '',
                country: data['address']['country'] ?? '',
              );
        } else {
          setState(() {
            _selectedAddress = '${location.latitude}, ${location.longitude}';
          });
        }
      }
    } catch (e) {
      // print('Error in reverse geocoding: $e');
      // setState(() {
      //   _selectedAddress = '${location.latitude}, ${location.longitude}';
      // });
    }
  }
}
