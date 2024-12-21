// lib/screens/venue_management/branding_design/color_palette.dart

import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_picker.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:aureola_platform/service/localization/localization.dart'; // Ensure this import exists

class ColorPaletteSection extends ConsumerStatefulWidget {
  final String name;
  final String colorField;
  final Color initialColor;

  const ColorPaletteSection({
    super.key,
    required this.name,
    required this.colorField,
    required this.initialColor,
  });

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
        // Schedule the update after the current frame to avoid setState during build
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
    final venue = ref.watch(draftVenueProvider);
    Color currentColor = _getCurrentColor(venue);

    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5, color: AppThemeLocal.grey2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 180,
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
                    message: AppLocalizations.of(context)!
                        .translate('enter_hex_color_code_tooltip'),
                    child: SizedBox(
                      height: 30,
                      child: TextFormField(
                        controller: _hexController,
                        style: AppThemeLocal.paragraph.copyWith(fontSize: 14),
                        decoration:
                            AppThemeLocal.textFieldinputDecoration().copyWith(
                          hintText: AppLocalizations.of(context)!
                              .translate('enter_hex_color_code_hint'),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 4.0,
                          ),
                        ),
                        validator: (value) => _validateHex(context, value),
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
                          initialColor: currentColor,
                        );
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
                      border: Border.all(color: AppThemeLocal.grey2, width: 1),
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
    if (_validateHex(context, value) == null) {
      final newColor = _hexToColor(value);
      _updateColorInProvider(newColor);
    }
  }

  /// Handles submission of the hex text field.
  void _handleHexSubmit(String value) {
    if (_validateHex(context, value) == null) {
      final newColor = _hexToColor(value);
      _updateColorInProvider(newColor);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('invalid_hex_color_code')),
        ),
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
  Color _getCurrentColor(VenueModel? venue) {
    if (venue == null) return _hexToColor('#FFFFFF');
    switch (widget.colorField) {
      case 'backgroundColor':
        return _hexToColor(venue.designAndDisplay.backgroundColor);
      case 'cardBackground':
        return _hexToColor(venue.designAndDisplay.cardBackground);
      case 'accentColor':
        return _hexToColor(venue.designAndDisplay.accentColor);
      case 'textColor':
        return _hexToColor(venue.designAndDisplay.textColor);
      default:
        return _hexToColor('#FFFFFF');
    }
  }

  /// Validates the hex color code.
  String? _validateHex(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!
          .translate('hex_color_cannot_be_empty');
    }
    if (!_colorRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.translate('invalid_hex_color_code');
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
