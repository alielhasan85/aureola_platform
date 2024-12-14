import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/screens/menu_management/branding_design/widgets/color_picker.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPaletteWidget extends ConsumerWidget {
  const ColorPaletteWidget({super.key});

  Widget _buildColorOption(
    BuildContext context,
    String label,
    String
        colorKey, // The colorKey corresponds to the 'backgroundColor', 'highlightColor', or 'textColor'
    WidgetRef ref,
  ) {
    final venue = ref.watch(venueProvider);
    final designAndDisplay = venue?.designAndDisplay ?? {};

    // // Get the current color from the provider
    // Color color = designAndDisplay.containsKey(colorKey)
    //     ? _hexToColor(designAndDisplay[colorKey])
    //     : Colors.blue; // Default color if no value is found

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomColorPickerDialog(
                  // Pass the color key to the dialog instead of color and callback
                  colorKey: colorKey,
                );
              },
            ),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                // TODO: to change to be dynamic
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.grey2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      surfaceTintColor: AppTheme.grey2,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customize Colors', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            _buildColorOption(
              context,
              'Background Color',
              'backgroundColor', // Key for background color
              ref,
            ),
            _buildColorOption(
              context,
              'Highlight Color',
              'highlightColor', // Key for highlight color
              ref,
            ),
            _buildColorOption(
              context,
              'Text Color',
              'textColor', // Key for text color
              ref,
            ),
          ],
        ),
      ),
    );
  }

  // // Method to save colors to Firestore
  // Future<void> _saveColorsToFirestore(
  //     WidgetRef ref, BuildContext context) async {
  //   try {
  //     final venue = ref.read(venueProvider);
  //     if (venue == null) return; // Handle null check

  //     // Get colors from provider
  //     final designAndDisplay = venue.designAndDisplay ?? {};
  //     final userId = venue.userId;
  //     final venueId = venue.venueId;

  //     if (designAndDisplay.isNotEmpty) {
  //       // Save colors to Firestore using FirestoreVenue service
  //       final FirestoreVenue firestoreVenue = FirestoreVenue();
  //       await firestoreVenue.updateDesignAndDisplay(
  //           userId, venueId, designAndDisplay);

  //       // Show success message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Color theme saved successfully!')));
  //     }
  //   } catch (e) {
  //     // Show error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error saving color theme: $e')));
  //   }
  // }

  // Utility method to convert a Color to a hex string
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Utility method to convert a hex string to a Color object
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
