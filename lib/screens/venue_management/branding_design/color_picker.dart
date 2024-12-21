// lib/screens/venue_management/branding_design/custom_color_picker_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';
import 'package:aureola_platform/service/localization/localization.dart'; // Ensure this import exists

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
  final _colorRegex =
      RegExp(r'^#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})$'); // Updated regex

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
    String processedHex = hexString;
    if (hexString.length == 3) {
      // Expand shorthand hex (e.g., #FFF -> #FFFFFF)
      processedHex = hexString.split('').map((c) => '$c$c').join('');
    }
    final buffer = StringBuffer();
    if (processedHex.length == 6 || processedHex.length == 7)
      buffer.write('ff');
    buffer.write(processedHex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String? _validateHex(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!
          .translate('hex_color_cannot_be_empty');
    }
    if (!_colorRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.translate('invalid_hex_color_code');
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('invalid_hex_color_code')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          AppLocalizations.of(context)!.translate('pick_a_color_dialog_title')),
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
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('hex_color_label'),
                border: const OutlineInputBorder(),
              ),
              validator: (value) => _validateHex(value),
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
          child: Text(AppLocalizations.of(context)!.translate('select_button')),
          onPressed: () {
            Navigator.of(context).pop(currentColor);
          },
        ),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.translate('cancel_button')),
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
