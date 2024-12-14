import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import riverpod
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomColorPickerDialog extends ConsumerStatefulWidget {
  final String
      colorKey; // The key in designAndDisplay ('backgroundColor', etc.)

  const CustomColorPickerDialog({
    required this.colorKey, // Pass the color key instead of just color
    super.key,
  });

  @override
  _CustomColorPickerDialogState createState() =>
      _CustomColorPickerDialogState();
}

class _CustomColorPickerDialogState
    extends ConsumerState<CustomColorPickerDialog> {
  late Color currentColor;
  late TextEditingController hexController;

  @override
  void initState() {
    super.initState();
    // Access the current color from the provider
    final venue = ref.read(venueProvider);
    final designAndDisplay = venue?.designAndDisplay ?? {};

    // Retrieve and set the initial color

    // currentColor = designAndDisplay.containsKey(widget.colorKey)
    //     ? _hexToColor(designAndDisplay[widget.colorKey])
    //     : Colors.blue; // Default color

    // Initialize the hex controller with the current color
    hexController = TextEditingController(
      text:
          '#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color newColor) {
                setState(() {
                  currentColor = newColor;
                  hexController.text =
                      '#${newColor.value.toRadixString(16).substring(2).toUpperCase()}';

                  // Auto-save the color to the venueProvider

                  // ref.read(venueProvider.notifier).updateDesignAndDisplay(
                  //       widget
                  //           .colorKey, // Update the color key (backgroundColor, etc.)
                  //       _colorToHex(newColor),
                  //     );
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: hexController,
              decoration: const InputDecoration(
                labelText: 'Hex Color',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (RegExp(r'^#([A-Fa-f0-9]{6})$').hasMatch(value)) {
                  setState(() {
                    currentColor = Color(
                        int.parse(value.substring(1), radix: 16) + 0xFF000000);

                    // Auto-save the color to the venueProvider
                    ref.read(venueProvider.notifier).updateDesignAndDisplay();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid hex color code.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text('Select'),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Just close the dialog since colors auto-save
          },
        ),
      ],
    );
  }

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
