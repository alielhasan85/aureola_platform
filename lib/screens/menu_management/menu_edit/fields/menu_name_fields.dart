// menu_name_fields.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/widgest/multilang_dialog.dart';

class MenuNameFields extends ConsumerStatefulWidget {
  final Map<String, String> menuName;
  final ValueChanged<Map<String, String>> onMenuNameChanged;
  final String? Function(String?)? validator;

  final double dialogWidth;
  final Offset popoverOffset; // Control vertical position
  final BoxDecoration popoverDecoration;

  const MenuNameFields({
    super.key,
    required this.menuName,
    required this.onMenuNameChanged,
    this.validator,
    required this.dialogWidth,

    /// Additional styling
    this.popoverOffset = const Offset(0, 8.0), // Adjusted y-offset
    this.popoverDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
  });

  @override
  ConsumerState<MenuNameFields> createState() => _MenuNameFieldsState();
}

class _MenuNameFieldsState extends ConsumerState<MenuNameFields> {
  final LayerLink _layerLink = LayerLink(); // For Composited transforms
  OverlayEntry? _multilangOverlay;

  // Add a GlobalKey to capture the TextFormField's size and position
  final GlobalKey _fieldKey = GlobalKey();

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentLang = ref.read(languageProvider);
    _controller =
        TextEditingController(text: widget.menuName[currentLang] ?? '');
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _multilangOverlay?.remove();
    _multilangOverlay = null;
  }

  void _showMultilangDialog() {
    // If already visible, remove it first
    _removeOverlay();

    final overlay = Overlay.of(context);
    // if (overlay == null) return;

    // Obtain the RenderBox of the TextFormField using the GlobalKey
    final RenderBox? renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size fieldSize = renderBox.size;
    final Offset fieldPosition = renderBox.localToGlobal(Offset.zero);

    _multilangOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Transparent barrier to detect taps outside the overlay
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Positioned multilingual overlay
            Positioned(
              left: fieldPosition.dx,
              top:
                  fieldPosition.dy + fieldSize.height + widget.popoverOffset.dy,
              child: Material(
                elevation: 4,
                color: Colors.transparent,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    // Dismiss overlay on any scroll event
                    _removeOverlay();
                    return false;
                  },
                  child: Container(
                    width: fieldSize.width, // Match the TextFormField's width
                    decoration: widget.popoverDecoration,
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      // Prevents taps inside the overlay from closing it
                      onTap: () {},
                      child: _buildMultilangFields(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_multilangOverlay!);
  }

  Widget _buildMultilangFields() {
    // We read the venue or languageOptions from the provider
    final venue = ref.read(draftVenueProvider);
    final currentLang = ref.read(languageProvider);

    return MultilangFieldDialogContent(
      initialValues: widget.menuName,
      // If no venue or no languageOptions, fallback to just [currentLang].
      availableLanguages: venue?.languageOptions ?? [currentLang],
      onSave: (updatedMap) {
        widget.onMenuNameChanged(updatedMap);
        _removeOverlay();
      },
      onCancel: _removeOverlay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);
    final venue = ref.watch(draftVenueProvider);
    final availableLangs = venue?.languageOptions ?? [currentLang];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("edit.menuName"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 6),

        // CompositedTransformTarget
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            key: _fieldKey, // Assign the GlobalKey here
            child: TextFormField(
              controller: _controller,
              style: AppThemeLocal.paragraph,
              cursorColor: AppThemeLocal.accent,
              validator: widget.validator,
              onChanged: (val) {
                final updatedMap = {...widget.menuName};
                updatedMap[currentLang] = val;
                widget.onMenuNameChanged(updatedMap);
              },
              decoration: AppThemeLocal.textFieldinputDecoration(
                hint: AppLocalizations.of(context)!
                    .translate("edit.menuNameDescritpion"),
                suffixIcon: availableLangs.length > 1
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: AppThemeLocal.accent,
                              thickness: 0.5,
                              width: 4,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.translate,
                              color: AppThemeLocal.accent,
                            ),
                            tooltip: AppLocalizations.of(context)!
                    .translate("edit.editInOtherLanguages")
                            ,
                            onPressed: _showMultilangDialog,
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
