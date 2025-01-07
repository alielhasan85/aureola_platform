import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/widgest/multilang_dialog.dart';

/// A multi-language editor for "notes," similar to MenuDescriptionFields.
///
/// [notesMap] is a Map<String, String> storing the text for each language.
/// [onNotesChanged] is called whenever the map is updated.
/// [validator] can impose length/other rules on the "current" language field.
///
/// [dialogWidth], [popoverOffset], [popoverDecoration] let you style the popover.
class MenuNotesFields extends ConsumerStatefulWidget {
  final Map<String, String> notesMap;
  final ValueChanged<Map<String, String>> onNotesChanged;
  final String? Function(String?)? validator;

  final double dialogWidth;
 
  const MenuNotesFields({
    super.key,
    required this.notesMap,
    required this.onNotesChanged,
    this.validator,
    required this.dialogWidth,
  
  });

  @override
  ConsumerState<MenuNotesFields> createState() => _MenuNotesFieldsState();
}

class _MenuNotesFieldsState extends ConsumerState<MenuNotesFields> {
  

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentLang = ref.read(languageProvider);
    // Initialize the field with the "current" language's notes
    _controller =
        TextEditingController(text: widget.notesMap[currentLang] ?? '');
  }

  @override
  void dispose() {
    // _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  
 

  /// Opens a standard dialog with `MultiLangDialog`.
  Future<void> _showMultiLangDialog(BuildContext context) async {
    final venue = ref.read(draftVenueProvider);
    final currentLang = ref.read(languageProvider);

    // The list of languages available for this venue
    final availableLangs = venue?.languageOptions ?? [currentLang];

    // We call `showDialog`, expecting a Map<String, String>? result
    final updatedMap = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) {
        return MultiLangDialog(
          initialValues: widget.notesMap,
          availableLanguages: availableLangs,
          defaultLang: venue?.additionalInfo['defaultLanguage'] ?? 'en',
          googleApiKey: 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA', // Or your real API key if you want translate
        );
      },
    );

    // If user pressed "Save," updatedMap is not null
    if (updatedMap != null) {
      widget.onNotesChanged(updatedMap);

      // Also update the local controller with the current language text
      final newCurrentValue = updatedMap[currentLang] ?? '';
      _controller.text = newCurrentValue;
    }
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
          AppLocalizations.of(context)!.translate("edit.Note"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          maxLines: null,
          style: AppThemeLocal.paragraph,
          cursorColor: AppThemeLocal.accent,
          validator: widget.validator,
          onChanged: (val) {
            final updatedMap = {...widget.notesMap};
            updatedMap[currentLang] = val;
            widget.onNotesChanged(updatedMap);
          },
          decoration: AppThemeLocal.textFieldinputDecoration(
            hint: AppLocalizations.of(context)!
                .translate("edit.NotesDescription"),
            suffixIcon: availableLangs.length > 1
                ? IconButton(
                  icon: const Icon(
                    Icons.translate,
                    color: AppThemeLocal.accent,
                  ),
                  tooltip: AppLocalizations.of(context)!
                                .translate("edit.editInOtherLanguages")
                  ,
                  onPressed: () => _showMultiLangDialog(context),
                )
                : null,
          ),
        ),
      ],
    );
  }
}
