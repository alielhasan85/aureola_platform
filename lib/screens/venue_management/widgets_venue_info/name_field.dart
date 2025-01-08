// venue_name_field.dart

import 'package:aureola_platform/widgest/multilang_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class VenueNameField extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const VenueNameField({
    super.key,
    required this.width,
    required this.controller,
    this.validator,
  });

  @override
  ConsumerState<VenueNameField> createState() => _VenueNameFieldState();
}

class _VenueNameFieldState extends ConsumerState<VenueNameField> {
  Future<void> _showMultiLangDialog(BuildContext context, String currentLang) async {
    final venue = ref.read(draftVenueProvider);
    final localization = AppLocalizations.of(context)!;
    if (venue == null) return;

    final currentMap = venue.venueName;
    final availableLangs = venue.languageOptions.isNotEmpty
        ? venue.languageOptions
        : [currentLang];

    final updatedMap = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MultiLangDialog(
        label: localization.translate("venue_name"),
        initialValues: currentMap,
        availableLanguages: availableLangs,
        defaultLang: venue.additionalInfo['defaultLanguage'] ?? 'en',
        googleApiKey: AppThemeLocal.googleApiKey,
      ),
    );

    if (updatedMap != null) {
      // Update the entire map in the provider
      ref.read(draftVenueProvider.notifier).updateVenueNameMap(updatedMap);

      // Defer updating the controller text
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.text = updatedMap[currentLang] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final currentLang = ref.watch(languageProvider);
    final venue = ref.watch(draftVenueProvider);
    final entireMap = venue?.venueName ?? {currentLang: ''};

    // Check if we need to update the controller text
    final newText = entireMap[currentLang] ?? '';
    if (widget.controller.text != newText) {
      // Defer the text update until after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.controller.text = newText;
        }
      });
    }

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.translate("venue_name"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            decoration: AppThemeLocal.textFieldinputDecoration(
              hint: localization.translate("enter_venue_display_name"),
              suffixIcon: (venue?.languageOptions.length ?? 0) > 1
                  ? IconButton(
                      icon: const Icon(Icons.translate,
                          color: AppThemeLocal.accent),
                      onPressed: () => _showMultiLangDialog(context, currentLang),
                    )
                  : null,
            ),
            onChanged: (val) {
              // Only update the current language key in the map
              final updated = {...entireMap};
              updated[currentLang] = val;
              ref.read(draftVenueProvider.notifier).updateVenueNameMap(updated);
            },
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
