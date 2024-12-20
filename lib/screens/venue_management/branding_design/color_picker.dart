// lib/screens/venue_management/branding_design/custom_color_picker_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';

class CustomColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const CustomColorPickerDialog({
    required this.initialColor,
    super.key,
  });

  @override
  State<CustomColorPickerDialog> createState() =>
      _CustomColorPickerDialogState();
}

class _CustomColorPickerDialogState extends State<CustomColorPickerDialog> {
  late Color currentColor;
  late TextEditingController hexController;
  final _colorRegex = RegExp(r'^#([A-Fa-f0-9]{6})$');

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
    hexController = TextEditingController(text: _colorToHex(currentColor));
  }

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
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

  String? _validateHex(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hex color code cannot be empty.';
    }
    if (!_colorRegex.hasMatch(value)) {
      return 'Invalid hex color code.';
    }
    return null;
  }

  void _onHexChanged(String value) {
    if (_validateHex(value) == null) {
      setState(() {
        currentColor = _hexToColor(value);
      });
    }
  }

  void _onHexSubmitted(String value) {
    if (_validateHex(value) == null) {
      setState(() {
        currentColor = _hexToColor(value);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid hex color code.')),
      );
    }
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
            TextFormField(
              controller: hexController,
              decoration: const InputDecoration(
                labelText: 'Hex Color',
                border: OutlineInputBorder(),
              ),
              validator: _validateHex,
              onFieldSubmitted: _onHexSubmitted,
              onChanged: _onHexChanged,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^#?([A-Fa-f0-9]{0,6})$')),
                LengthLimitingTextInputFormatter(7),
              ],
              onEditingComplete: () {
                if (!hexController.text.startsWith('#') &&
                    hexController.text.isNotEmpty) {
                  hexController.text = '#${hexController.text}';
                  hexController.selection = TextSelection.fromPosition(
                    TextPosition(offset: hexController.text.length),
                  );
                  _onHexChanged(hexController.text);
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
            Navigator.of(context).pop(currentColor);
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
