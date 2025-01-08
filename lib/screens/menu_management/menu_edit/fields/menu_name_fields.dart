import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Your providers, theme, and localization
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

// The multi-language dialog you created (or a simpler version of it)
import 'package:aureola_platform/widgest/multilang_dialog.dart';

class MenuNameFields extends ConsumerStatefulWidget {
  final Map<String, String> menuName;
  final ValueChanged<Map<String, String>> onMenuNameChanged;
  final String? Function(String?)? validator;

  /// You can keep these if you need them, or remove if unused
  final double dialogWidth;
 

  const MenuNameFields({
    super.key,
    required this.menuName,
    required this.onMenuNameChanged,
    this.validator,
    required this.dialogWidth,
    
  });

  @override
  ConsumerState<MenuNameFields> createState() => _MenuNameFieldsState();
}

class _MenuNameFieldsState extends ConsumerState<MenuNameFields> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Read the current UI language
    final currentLang = ref.read(languageProvider);
    // Initialize the text field with the menuName in that language
    _controller = TextEditingController(text: widget.menuName[currentLang] ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Opens a standard dialog with `MultiLangDialog`.
  Future<void> _showMultiLangDialog(BuildContext context, String label) async {
    final venue = ref.read(draftVenueProvider);
    final currentLang = ref.read(languageProvider);

    // The list of languages available for this venue
    final availableLangs = venue?.languageOptions ?? [currentLang];

    // We call `showDialog`, expecting a Map<String, String>? result
    final updatedMap = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) {
        return MultiLangDialog(
          label: label,
          initialValues: widget.menuName,
          availableLanguages: availableLangs,
          defaultLang: venue?.additionalInfo['defaultLanguage'] ?? 'en',
          googleApiKey: 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA', // Or your real API key if you want translate
        );
      },
    );

    // If user pressed "Save," updatedMap is not null
    if (updatedMap != null) {
      widget.onMenuNameChanged(updatedMap);

      // Also update the local controller with the current language text
      final newCurrentValue = updatedMap[currentLang] ?? '';
      _controller.text = newCurrentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final currentLang = ref.watch(languageProvider);
    final venue = ref.watch(draftVenueProvider);
    final availableLangs = venue?.languageOptions ?? [currentLang];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate("edit.menuName"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 6),

        TextFormField(
          controller: _controller,
          style: AppThemeLocal.paragraph,
          cursorColor: AppThemeLocal.accent,
          validator: widget.validator,
          onChanged: (val) {
            // Update the map for the current language as the user types
            final updatedMap = {...widget.menuName};
            updatedMap[currentLang] = val;
            widget.onMenuNameChanged(updatedMap);
          },
          decoration: AppThemeLocal.textFieldinputDecoration(
            hint: localization.translate("edit.PleaseEnterMenuName"),
            suffixIcon: availableLangs.length > 1
                ? IconButton(
                    icon: const Icon(Icons.translate, color: AppThemeLocal.accent),
                    tooltip: localization.translate("edit.editInOtherLanguages"),
                    onPressed: () => _showMultiLangDialog( context, "edit.menuName"),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
