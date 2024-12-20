// lib/screens/venue_management/branding_design/color_palette.dart

import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_picker.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class ColorPaletteSection extends ConsumerStatefulWidget {
  final String name;
  final String colorField;
  final Color initialColor;

  const ColorPaletteSection({
    Key? key,
    required this.name,
    required this.colorField,
    required this.initialColor,
  }) : super(key: key);

  @override
  ConsumerState<ColorPaletteSection> createState() =>
      _ColorPaletteSectionState();
}

class _ColorPaletteSectionState extends ConsumerState<ColorPaletteSection> {
  late TextEditingController _hexController;
  final _colorRegex = RegExp(r'^#([A-Fa-f0-9]{6})$');

  @override
  void initState() {
    super.initState();
    _hexController =
        TextEditingController(text: _colorToHex(widget.initialColor));
  }

  @override
  void didUpdateWidget(covariant ColorPaletteSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      final newHex = _colorToHex(widget.initialColor);
      if (_hexController.text != newHex) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _hexController.text = newHex;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = ref.watch(draftVenueProvider)?.designAndDisplay;
    final currentColor = _getCurrentColor(design);

    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppThemeLocal.grey2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              widget.name,
              style: AppThemeLocal.paragraph.copyWith(
                color: AppThemeLocal.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 170,
            child: Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: 'Enter a hex color code (e.g., #FFFFFF)',
                    child: SizedBox(
                      height: 30,
                      child: TextFormField(
                        controller: _hexController,
                        style: AppThemeLocal.paragraph.copyWith(fontSize: 14),
                        decoration:
                            AppThemeLocal.textFieldinputDecoration().copyWith(
                          hintText: 'Enter hex color code',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 4.0,
                          ),
                        ),
                        validator: _validateHex,
                        onFieldSubmitted: _handleHexSubmit,
                        onChanged: _handleHexChange,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^#?([A-Fa-f0-9]{0,6})$')),
                          LengthLimitingTextInputFormatter(7),
                        ],
                        onEditingComplete: _autoPrefixHex,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () async {
                    final selectedColor = await showDialog<Color>(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomColorPickerDialog(
                            initialColor: currentColor);
                      },
                    );

                    if (selectedColor != null) {
                      _updateColorInProvider(selectedColor);
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppThemeLocal.grey2, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Automatically prefixes the hex code with '#' if missing.
  void _autoPrefixHex() {
    if (!_hexController.text.startsWith('#') &&
        _hexController.text.isNotEmpty) {
      _hexController.text = '#${_hexController.text}';
      _handleHexChange(_hexController.text);
    }
  }

  /// Handles changes in the hex text field.
  void _handleHexChange(String value) {
    if (_validateHex(value) == null) {
      final newColor = _hexToColor(value);
      _updateColorInProvider(newColor);
    }
  }

  /// Handles submission of the hex text field.
  void _handleHexSubmit(String value) {
    if (_validateHex(value) == null) {
      final newColor = _hexToColor(value);
      _updateColorInProvider(newColor);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid hex color code.')),
      );
    }
  }

  /// Updates the provider with the new color using VenueNotifier's methods.
  void _updateColorInProvider(Color newColor) {
    final newHex = _colorToHex(newColor);
    switch (widget.colorField) {
      case 'backgroundColor':
        ref.read(draftVenueProvider.notifier).updateBackgroundColor(newHex);
        break;
      case 'cardBackground':
        ref.read(draftVenueProvider.notifier).updateCardBackgroundColor(newHex);
        break;
      case 'accentColor':
        ref.read(draftVenueProvider.notifier).updateAccentColor(newHex);
        break;
      case 'textColor':
        ref.read(draftVenueProvider.notifier).updateTextColor(newHex);
        break;
      default:
        // Handle unknown fields
        break;
    }
  }

  /// Retrieves the current color based on the provider's state.
  Color _getCurrentColor(DesignAndDisplay? design) {
    if (design == null) return _hexToColor('#FFFFFF');
    switch (widget.colorField) {
      case 'backgroundColor':
        return _hexToColor(design.backgroundColor);
      case 'cardBackground':
        return _hexToColor(design.cardBackground);
      case 'accentColor':
        return _hexToColor(design.accentColor);
      case 'textColor':
        return _hexToColor(design.textColor);
      default:
        return _hexToColor('#FFFFFF');
    }
  }

  /// Validates the hex color code.
  String? _validateHex(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hex color code cannot be empty.';
    }
    if (!_colorRegex.hasMatch(value)) {
      return 'Invalid hex color code.';
    }
    return null;
  }

  /// Converts a Color to its hex string representation.
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Converts a hex string to a Color.
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
