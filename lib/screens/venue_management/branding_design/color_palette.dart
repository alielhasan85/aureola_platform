// lib/widgets/color_palette_section.dart

import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_picker.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
// lib/widgets/color_palette_section.dart

class ColorPaletteSection extends ConsumerStatefulWidget {
  final String layout; // 'isDesktop', 'isTablet', 'isMobile', or fallback
  final String name;
  final String colorField; // Specific field in DesignAndDisplay

  const ColorPaletteSection({
    super.key,
    required this.layout,
    required this.name,
    required this.colorField,
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
    final initialColor = _getInitialColor();
    _hexController = TextEditingController(text: _colorToHex(initialColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  Color _getInitialColor() {
    final design = ref.read(draftVenueProvider)?.designAndDisplay;
    if (design == null) return _hexToColor('#FFFFFF'); // Default color
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
      final newColor = _hexToColor(value);
      _updateColor(newColor);
    }
  }

  void _onHexSubmitted(String value) {
    if (_validateHex(value) == null) {
      final newColor = _hexToColor(value);
      _updateColor(newColor);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid hex color code.')),
      );
    }
  }

  void _updateColor(Color newColor) {
    final updatedDesign = _updateDesignField(newColor);
    ref.read(draftVenueProvider.notifier).updateDesignAndDisplay(updatedDesign);
  }

  DesignAndDisplay _updateDesignField(Color newColor) {
    final currentDesign = ref.read(draftVenueProvider)?.designAndDisplay;
    if (currentDesign == null) return DesignAndDisplay();
    switch (widget.colorField) {
      case 'backgroundColor':
        return currentDesign.copyWith(backgroundColor: _colorToHex(newColor));
      case 'cardBackground':
        return currentDesign.copyWith(cardBackground: _colorToHex(newColor));
      case 'accentColor':
        return currentDesign.copyWith(accentColor: _colorToHex(newColor));
      case 'textColor':
        return currentDesign.copyWith(textColor: _colorToHex(newColor));
      default:
        return currentDesign;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = ref.watch(draftVenueProvider)?.designAndDisplay;
    final draftColor = design != null
        ? _hexToColor(
            widget.colorField == 'backgroundColor'
                ? design.backgroundColor
                : widget.colorField == 'cardBackground'
                    ? design.cardBackground
                    : widget.colorField == 'accentColor'
                        ? design.accentColor
                        : design.textColor,
          )
        : _hexToColor('#FFFFFF');

    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppThemeLocal.grey2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
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
                            labelText: 'Hex Color',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 2.0, // Adjust as needed
                            ),
                          ),
                          validator: _validateHex,
                          onFieldSubmitted: _onHexSubmitted,
                          onChanged: _onHexChanged,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^#?([A-Fa-f0-9]{0,6})$')),
                            LengthLimitingTextInputFormatter(
                                7), // '#' + 6 hex digits
                          ],
                          onEditingComplete: () {
                            // Automatically add '#' if missing
                            if (!_hexController.text.startsWith('#') &&
                                _hexController.text.isNotEmpty) {
                              _hexController.text = '#${_hexController.text}';
                              _hexController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _hexController.text.length),
                              );
                              _onHexChanged(_hexController.text);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () async {
                      // Open the color picker dialog and await the selected color
                      final selectedColor = await showDialog<Color>(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomColorPickerDialog(
                            initialColor:
                                Colors.white, // Placeholder, will be overridden
                          );
                        },
                      );

                      if (selectedColor != null) {
                        final hex = _colorToHex(selectedColor);
                        setState(() {
                          _hexController.text = hex;
                        });
                        _updateColor(selectedColor);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: draftColor,
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: AppThemeLocal.grey2, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
