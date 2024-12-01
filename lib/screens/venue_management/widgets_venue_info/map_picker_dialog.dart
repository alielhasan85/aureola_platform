// map_picker_dialog.dart

import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerDialog extends StatefulWidget {
  final LatLng initialLocation;
  final double containerWidth;

  const MapPickerDialog(
      {super.key, required this.initialLocation, required this.containerWidth});

  @override
  State<MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<MapPickerDialog> {
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          AppLocalizations.of(context)!.translate("Select_Location_from_Map")),
      titleTextStyle: AppTheme.heading1.copyWith(fontSize: 16),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pop(_pickedLocation); // Save and return location
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
