// location_picker_field.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:aureola_platform/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationPickerField extends StatefulWidget {
  final double width;

  const LocationPickerField({super.key, required this.width});

  @override
  _LocationPickerFieldState createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  final String apiKey =
      'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA'; // Replace with your API key

  // Variables to store selected location details
  LatLng? _selectedLatLng;
  String? _selectedAddress;

  // Variable to track whether the map picker is active
  bool _isMapPickerActive = false;

  @override
  void initState() {
    super.initState();
    // Initialize with a default location (e.g., Doha, Qatar)
    _selectedLatLng = LatLng(25.286106, 51.534817);
    _reverseGeocode(_selectedLatLng!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.translate("location"),
          style: AppTheme.tabItemText,
        ),
        SizedBox(height: 8),
        if (_selectedAddress != null) ...[
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.translate("selected_location"),
            style: AppTheme.paragraph,
          ),
          SizedBox(height: 8),
          Text(
            _selectedAddress!,
            style: AppTheme.paragraph,
          ),
        ],
        SizedBox(height: 16),
        // Display Static Map Image or Map Picker
        _buildMapOrImage(),
      ],
    );
  }

  Widget _buildMapOrImage() {
    if (_isMapPickerActive) {
      // Show interactive map
      return Container(
        height: 300,
        width: widget.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLatLng!,
                zoom: 17,
              ),
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _selectedLatLng = position.target;
                });
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Icon(Icons.place, size: 50, color: Colors.red),
            Positioned(
              bottom: 10,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isMapPickerActive = false;
                  });
                  _reverseGeocode(_selectedLatLng!);
                },
                child: Text(
                  AppLocalizations.of(context)!.translate("select_location"),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Show static map image
      return GestureDetector(
        onTap: () {
          setState(() {
            _isMapPickerActive = true;
          });
        },
        child: Image.network(
          _buildStaticMapUrl(),
          height: 300,
          width: widget.width,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  String _buildStaticMapUrl() {
    final lat = _selectedLatLng!.latitude;
    final lng = _selectedLatLng!.longitude;

    final staticMapUrl = Uri.https(
      'maps.googleapis.com',
      '/maps/api/staticmap',
      {
        'center': '$lat,$lng',
        'zoom': '17',
        'size': '600x300',
        'maptype': 'roadmap',
        'markers': 'color:red%7C$lat,$lng',
        'key': apiKey,
      },
    ).toString();

    return staticMapUrl;
  }

  Future<void> _reverseGeocode(LatLng location) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${location.latitude}&lon=${location.longitude}',
      );
      final response = await http.get(url

          //  headers: {
          //   'User-Agent': 'aureola-5e3dd (elhasan.ali@gmail.com)',
          // }

          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['display_name'] != null) {
          setState(() {
            _selectedAddress = data['display_name'];
          });
        } else {
          setState(() {
            _selectedAddress = '${location.latitude}, ${location.longitude}';
          });
        }
      } else {
        print('Error in reverse geocoding: ${response.statusCode}');
        setState(() {
          _selectedAddress = '${location.latitude}, ${location.longitude}';
        });
      }
    } catch (e) {
      print('Error in reverse geocoding: $e');
      setState(() {
        _selectedAddress = '${location.latitude}, ${location.longitude}';
      });
    }
  }
}
