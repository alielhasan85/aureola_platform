import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomColorPickerDialog extends ConsumerStatefulWidget {
  final StateProvider<Color?> colorProvider;
  final Color initialColor;

  const CustomColorPickerDialog({
    required this.colorProvider,
    required this.initialColor,
    Key? key,
  }) : super(key: key);

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
    currentColor = widget.initialColor;
    hexController = TextEditingController(
      text: _colorToHex(currentColor),
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
                  hexController.text = _colorToHex(newColor);
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
                  final newColor = _hexToColor(value);
                  setState(() {
                    currentColor = newColor;
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
            // Update the provider with the selected color
            ref.read(widget.colorProvider.notifier).state = currentColor;
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            // Do not update the provider, just close the dialog
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
