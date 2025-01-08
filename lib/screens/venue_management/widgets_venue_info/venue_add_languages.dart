import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/widgest/language_config.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

import 'package:dropdown_search/dropdown_search.dart';

class VenueAddLanguages extends ConsumerStatefulWidget {
  final double width;
  const VenueAddLanguages({super.key, required this.width});

  @override
  ConsumerState<VenueAddLanguages> createState() => _VenueAddLanguagesState();
}

class _VenueAddLanguagesState extends ConsumerState<VenueAddLanguages> {
  /// We'll keep the currently selected language code in this local state.
  String? _selectedLangCode;

  @override
  Widget build(BuildContext context) {
    final venue = ref.watch(draftVenueProvider);
    if (venue == null) return const SizedBox.shrink();

    // 1) Identify the default language (stored in additionalInfo or the first code)
    final defaultLangCode = venue.additionalInfo['defaultLanguage'] as String? ??
        (venue.languageOptions.isNotEmpty ? venue.languageOptions.first : 'en');

    // 2) The "additional" languages are everything except the default
    final additionalLangs =
        venue.languageOptions.where((c) => c != defaultLangCode);

    // 3) Build a list of potential languages for the dropdown
    //    We'll exclude the default from the dropdown, and also exclude codes already in languageOptions
    final existingCodes = venue.languageOptions.toSet();
    final possibleCodes = kSupportedLanguageCodes
        .where((code) => code != defaultLangCode)
        .where((code) => !existingCodes.contains(code))
        .toList();

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            AppLocalizations.of(context)!.translate('other_languages'),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height:8),

         
          // Wrap for the "additional" languages as chips
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: additionalLangs.map((code) {
              final display = codeToName(code);
              return Chip(
                 deleteIconColor: AppThemeLocal.accent, 
                side: const BorderSide(
    color: AppThemeLocal.accent, // Replace with your desired accent color
    width: 0.5, // Optional: Adjust the border width
  ),
                label: Text(display, style: AppThemeLocal.paragraph.copyWith(fontSize: 14)),
                // Let the user remove additional languages
                onDeleted: () => _removeLanguage(code),
              );
            }).toList(),
          ),
 const SizedBox(height: 16),

          // Row with a dropdown + add button
          Row(
            children: [
              // Same container styling as your second code
              Expanded(
                child: 
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   decoration: BoxDecoration(
                //     color: AppThemeLocal.background,
                //     borderRadius: BorderRadius.circular(6.0),
                //     border: Border.all(color: Colors.grey.shade400),
                //   ),
                //   child: 
                  
                  DropdownSearch<String>(
                    // Provide the user-friendly names for the dropdown
                    items: (filter, _) =>
                        possibleCodes.map(codeToName).toList(),

                    // The same popup styling as in your first code
                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      menuProps: const MenuProps(
                        backgroundColor: AppThemeLocal.background,
                        margin: EdgeInsets.only(top: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      constraints: BoxConstraints(maxWidth: widget.width),
                    ),

                    // The selectedItem is the user-friendly name for _selectedLangCode
                    selectedItem: _selectedLangCode != null
                        ? codeToName(_selectedLangCode!)
                        : null,

                    // If user hasn't chosen anything yet, show a hint
                    dropdownBuilder: (context, selectedItem) {
                      if (selectedItem == null) {
                        return Text(
                          AppLocalizations.of(context)!
                              .translate('Add_a_language'),
                          style: AppThemeLocal.paragraph,
                        );
                      }
                      // Otherwise, we localize or display the chosen name
                      return Text(
                        AppLocalizations.of(context)!.translate(selectedItem),
                        style: AppThemeLocal.paragraph,
                      );
                    },

                    // Called when the user picks a new friendlyName
                    onChanged: (String? newFriendlyName) {
                      if (newFriendlyName == null) return;
                      final newCode = nameToCode(newFriendlyName);
                      setState(() {
                        _selectedLangCode = newCode;
                      });
                    },
                  ),
                ),
              
              const SizedBox(width: 16),

              ElevatedButton(
                style: AppThemeLocal.cancelButtonStyle.copyWith(elevation: WidgetStateProperty.all(0.0) ),
                onPressed: _onAddLanguage,
                child: Text(
                  AppLocalizations.of(context)!.translate("add"),
                ),
              ),
            ],
          ),

          
        ],
      ),
    );
  }

  /// When user presses the "Add" button, we add _selectedLangCode to languageOptions
  void _onAddLanguage() {
    if (_selectedLangCode == null) {
      // No language selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('please_select_language'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newCode = _selectedLangCode!;
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    // 1) Identify default language code again
    final defaultLangCode = venue.additionalInfo['defaultLanguage'] as String? ??
        (venue.languageOptions.isNotEmpty ? venue.languageOptions.first : 'en');

    // If it's the default, skip
    if (newCode == defaultLangCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .translate('cannot_add_default_language'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If it’s already in languageOptions, skip
    if (venue.languageOptions.contains(newCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('language_already_exists'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Insert the new code into languageOptions behind the default
    final updated = [...venue.languageOptions];
    updated.remove(defaultLangCode);
    updated.insert(0, defaultLangCode);
    updated.add(newCode);

    // Update the draft
    ref.read(draftVenueProvider.notifier).updateVenue(languageOptions: updated);

    // Clear the local selection
    setState(() {
      _selectedLangCode = null;
    });
  }

  /// Removing a chip => removing that code from languageOptions
  void _removeLanguage(String code) {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    // If user tries to remove the default, skip
    final defaultLangCode = venue.additionalInfo['defaultLanguage'] as String? ??
        (venue.languageOptions.isNotEmpty ? venue.languageOptions.first : 'en');
    if (code == defaultLangCode) {
      return;
    }

    final updated = venue.languageOptions.where((c) => c != code).toList();
    ref.read(draftVenueProvider.notifier).updateVenue(languageOptions: updated);
  }
}
