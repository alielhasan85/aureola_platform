import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerDialog extends StatefulWidget {
  final LatLng initialLocation;
  final double containerWidth;

  const MapPickerDialog({
    super.key,
    required this.initialLocation,
    required this.containerWidth,
  });

  @override
  State<MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<MapPickerDialog> {
  late LatLng _pickedLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
    print(_pickedLocation);
  }

  // Function to animate camera to a specific location
  void _animateToLocation(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: 17),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.translate("Select_Location_from_Map"),
      ),
      titleTextStyle: AppThemeLocal.appBarTitle.copyWith(fontSize: 16),
      content: SizedBox(
        width: widget.containerWidth,
        height: 400,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _pickedLocation,
            zoom: 17,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            // Ensure the camera centers on the initial location when the map is created
            _animateToLocation(_pickedLocation);
          },
          onTap: (LatLng location) {
            setState(() {
              _pickedLocation = location;
            });
            _animateToLocation(
                location); // Optionally animate to the new location
          },
          markers: {
            Marker(
              markerId: const MarkerId('selected-location'),
              position: _pickedLocation,
            ),
          },
          myLocationButtonEnabled: false, // Disable default my-location button
          zoomControlsEnabled: true, // Enable zoom controls
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.translate('cancel'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'location': _pickedLocation,
            });
          },
          child: Text(
            AppLocalizations.of(context)!.translate('save'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
