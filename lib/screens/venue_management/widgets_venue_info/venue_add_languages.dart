// lib/screens/venue_management/widgets_venue_info/venue_add_languages.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays the current venue languages and
/// allows adding more languages to `venue.languageOptions`.
class VenueAddLanguages extends ConsumerStatefulWidget {
  final double width; // size constraint (optional)

  const VenueAddLanguages({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  ConsumerState<VenueAddLanguages> createState() => _VenueAddLanguagesState();
}

class _VenueAddLanguagesState extends ConsumerState<VenueAddLanguages> {
  late TextEditingController _languageController;

  @override
  void initState() {
    super.initState();
    _languageController = TextEditingController();
  }

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.watch(draftVenueProvider);

    if (venue == null) {
      return const SizedBox.shrink();
    }

    // The existing list of languages from the venue model, e.g. ["English","Arabic"]
    final currentLanguages = venue.languageOptions;

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            AppLocalizations.of(context)!.translate('venue_languages') ??
                'Venue Languages',
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),

          // Show the existing languages
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: currentLanguages.map((lang) {
              return Chip(
                label: Text(lang, style: AppThemeLocal.paragraph),
                // OPTIONAL: If you want to remove a language on tap
                onDeleted: () {
                  _removeLanguage(lang);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Input row for adding a new language
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _languageController,
                  style: AppThemeLocal.paragraph,
                  cursorColor: AppThemeLocal.accent,
                  decoration: AppThemeLocal.textFieldinputDecoration(
                    hint: AppLocalizations.of(context)!
                        .translate('Add_a_language'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addLanguage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeLocal.primary,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('add') ?? 'Add',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addLanguage() {
    final newLang = _languageController.text.trim();
    if (newLang.isEmpty) return;

    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    // Avoid duplicates
    if (venue.languageOptions.contains(newLang)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                    .translate('language_already_exists') ??
                'Language already exists',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add to the list
    final updatedList = [...venue.languageOptions, newLang];

    // Update the draftVenue
    ref.read(draftVenueProvider.notifier).updateVenue(
          languageOptions: updatedList,
        );

    // Clear the text field
    _languageController.clear();
  }

  void _removeLanguage(String lang) {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    // e.g. remove the chip
    final updatedList = venue.languageOptions.where((l) => l != lang).toList();
    ref.read(draftVenueProvider.notifier).updateVenue(
          languageOptions: updatedList,
        );
  }
}
