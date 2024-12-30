import 'dart:async';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'location_service.dart';

class LocationPickerField extends ConsumerStatefulWidget {
  final double width;

  const LocationPickerField({
    super.key,
    required this.width,
  });

  @override
  ConsumerState<LocationPickerField> createState() =>
      _LocationPickerFieldState();
}

class _LocationPickerFieldState extends ConsumerState<LocationPickerField> {
// Inside your State class
  String? _selectedAddress;
  LocationService? locationService;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Initialize the LocationService with the API key from .env

    _updateAddress(); // You can call this once here to set initial address if needed
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _updateAddress() {
    final venue = ref.read(venueProvider);
    if (venue?.address.location != null) {
      final loc = venue!.address.location;
      final lang = ref.read(languageProvider);

      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        final address = await locationService?.reverseGeocode(loc, lang);
        if (mounted) {
          setState(() {
            _selectedAddress = address ?? '${loc.latitude}, ${loc.longitude}';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    locationService =
        LocationService(apiKey: 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA');
    final venue = ref.watch(venueProvider);
    final mapImageUrl = venue?.additionalInfo['mapImageUrl'];
    final currentLanguage = ref.watch(languageProvider);

    // Use ref.listen inside build
    ref.listen<String>(languageProvider, (previous, next) {
      // Language changed, update address
      _updateAddress();
    });

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
                style: AppThemeLocal.paragraph,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Directionality(
                  textDirection: currentLanguage == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Text(
                    _selectedAddress!,
                    style: AppThemeLocal.paragraph,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        _buildStaticMapImage(mapImageUrl),
      ],
    );
  }

  Widget _buildStaticMapImage(String? mapImageUrl) {
    if (mapImageUrl != null && mapImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: mapImageUrl,
        height: 300,
        width: widget.width,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return Container(
        height: 300,
        width: widget.width,
        alignment: Alignment.center,
        color: Colors.grey.shade200,
        child: const Text(
          'No image available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }
}
