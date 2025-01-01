import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/widgest/language_config.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class VenueAddLanguages extends ConsumerStatefulWidget {
  final double width;
  const VenueAddLanguages({Key? key, required this.width}) : super(key: key);

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
    if (venue == null) return const SizedBox.shrink();

    final currentLangCodes = venue.languageOptions;

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('venue_languages'),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: currentLangCodes.map((code) {
              final display = codeToName(code);
              return Chip(
                label: Text(display, style: AppThemeLocal.paragraph),
                onDeleted: () => _removeLanguage(code),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
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
    final input = _languageController.text.trim();
    if (input.isEmpty) return;

    final newCode = nameToCode(input);
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    if (venue.languageOptions.contains(newCode)) {
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

    final updated = [...venue.languageOptions, newCode];
    ref.read(draftVenueProvider.notifier).updateVenue(
          languageOptions: updated,
        );
    _languageController.clear();
  }

  void _removeLanguage(String code) {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;
    final updated = venue.languageOptions.where((c) => c != code).toList();
    ref.read(draftVenueProvider.notifier).updateVenue(
          languageOptions: updated,
        );
  }
}
