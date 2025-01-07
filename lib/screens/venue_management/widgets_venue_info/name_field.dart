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
  // We might store the current language code so we don't read it repeatedly
  late String currentLang;

  @override
  void initState() {
    super.initState();
    // read the current UI language once
    currentLang = ref.read(languageProvider);
  }

  Future<void> _showMultiLangDialog(BuildContext context) async {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    // The current map of all languages for venueName
    final currentMap = venue.venueName;
    // The list of available languages
    final availableLangs = venue.languageOptions.isNotEmpty
        ? venue.languageOptions
        : [currentLang];

    // Show the multi-lang dialog
    final updatedMap = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MultiLangDialog(
        label: 'Edit Venue Name',
        initialValues: currentMap,
        availableLanguages: availableLangs,
        defaultLang: venue.additionalInfo['defaultLanguage'] ?? 'en',
        googleApiKey: 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA',
      ),
    );

    if (updatedMap != null) {
      // user pressed save => updatedMap is the new entire map
      ref.read(draftVenueProvider.notifier).updateVenueNameMap(updatedMap);

      // Also update the controller with the text for the current language
      final updatedText = updatedMap[currentLang] ?? '';
      widget.controller.text = updatedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final venue = ref.watch(draftVenueProvider);
    // if no venue, or no map, fallback
    final entireMap = venue?.venueName ?? {currentLang: ''};

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
                      onPressed: () => _showMultiLangDialog(context),
                    )
                  : null,
            ),
            onChanged: (val) {
              // user typing => update only the current language's text
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
