import 'package:aureola_platform/widgest/multilang_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class MenuDescriptionFields extends ConsumerStatefulWidget {
  final Map<String, String> descriptionMap;
  final ValueChanged<Map<String, String>> onDescriptionChanged;
  final String? Function(String?)? validator;

  final double dialogWidth;
  

  const MenuDescriptionFields({
    super.key,
    required this.descriptionMap,
    required this.onDescriptionChanged,
    this.validator,
    required this.dialogWidth,
    
    
      
    
  });

  @override
  ConsumerState<MenuDescriptionFields> createState() =>
      _MenuDescriptionFieldsState();
}

class _MenuDescriptionFieldsState extends ConsumerState<MenuDescriptionFields> {
  

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentLang = ref.read(languageProvider);
    // Initialize the single text field with whatever is in the "current" language
    _controller =
        TextEditingController(text: widget.descriptionMap[currentLang] ?? '');
  }

  @override
  void dispose() {
   
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
          initialValues: widget.descriptionMap,
          availableLanguages: availableLangs,
          defaultLang: venue?.additionalInfo['defaultLanguage'] ?? 'en',
          googleApiKey: 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA', // Or your real API key if you want translate
        );
      },
    );

   // If user pressed "Save," updatedMap is not null
    if (updatedMap != null) {
      widget.onDescriptionChanged(updatedMap);

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
          AppLocalizations.of(context)!.translate("edit.menuDescription"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          maxLines: null, // Allow the field to expand as needed
          style: AppThemeLocal.paragraph,
          cursorColor: AppThemeLocal.accent,
          validator: widget.validator,
          onChanged: (val) {
            final updatedMap = {...widget.descriptionMap};
            updatedMap[currentLang] = val;
            widget.onDescriptionChanged(updatedMap);
          },
          decoration: AppThemeLocal.textFieldinputDecoration(
            hint: AppLocalizations.of(context)!
                .translate("edit.MenuDescriptionHint"),
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
