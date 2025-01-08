import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/widgest/language_config.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

import 'package:dropdown_search/dropdown_search.dart';

class VenueDefaultLanguage extends ConsumerStatefulWidget {
  final double width;

  const VenueDefaultLanguage({super.key, required this.width});

  @override
  ConsumerState<VenueDefaultLanguage> createState() => _VenueDefaultLanguageState();
}

class _VenueDefaultLanguageState extends ConsumerState<VenueDefaultLanguage> {
  String? _selectedLangCode;

  @override
  Widget build(BuildContext context) {
    final venue = ref.watch(draftVenueProvider);
    if (venue == null) return const SizedBox.shrink();

    final localization = AppLocalizations.of(context)!;

    // 1) The current default language code
    final defaultLangCode = venue.additionalInfo['defaultLanguage'] as String? ??
        (venue.languageOptions.isNotEmpty ? venue.languageOptions.first : 'en');

    // 2) Build a list of potential languages for the dropdown
    //    We exclude what’s already set as the default.
    //    (But you could also allow re-selecting the same code if you want.)
    final possibleCodes = kSupportedLanguageCodes
        .where((code) => code != defaultLangCode)
        .toList();

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            localization.translate("default_language"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 8),
 Wrap(
            children: [
              Chip(

                deleteIconColor: AppThemeLocal.accent, 
                side: const BorderSide(
    color: AppThemeLocal.accent, // Replace with your desired accent color
    width: 0.5, // Optional: Adjust the border width
  ),
                label: Text(
                  codeToName(defaultLangCode),
                  style: AppThemeLocal.paragraph.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
const SizedBox(height: 16),

          // Row with a dropdown + "Set" button
          Row(
            children: [
              Expanded(
                child: DropdownSearch<String>(
                  // We'll convert codes -> user-friendly name for display
                  items: (filter, _) => possibleCodes.map(codeToName).toList(),

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

                  // If user hasn’t chosen a new default yet, show a placeholder
                  dropdownBuilder: (context, selectedItem) {
                    if (selectedItem == null) {
                      return Text(
                        localization.translate('Select_Main_Language'),
                        style: AppThemeLocal.paragraph,
                      );
                    }
                    // If selected, display user-friendly name
                    return Text(
                      localization.translate(selectedItem),
                      style: AppThemeLocal.paragraph,
                    );
                  },

                  // The currently "selected" item is user-friendly name if _selectedLangCode is set
                  selectedItem: _selectedLangCode != null
                      ? codeToName(_selectedLangCode!)
                      : null,

                  onChanged: (String? newFriendlyName) {
                    if (newFriendlyName == null) return;
                    final newCode = nameToCode(newFriendlyName);
                    setState(() => _selectedLangCode = newCode);
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: AppThemeLocal.cancelButtonStyle.copyWith(elevation: WidgetStateProperty.all(0.0) ),
                onPressed: _onSetDefaultLanguage,
                child: Text(localization.translate("set")),
              ),
            ],
          ),

          

          // Show the current default language as a Chip (no remove icon)
         
        ],
      ),
    );
  }

  /// When the user presses "Set," we update the default language
  void _onSetDefaultLanguage() {
    if (_selectedLangCode == null) {
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

    // If it’s already the default, skip
    final currentDefault = venue.additionalInfo['defaultLanguage'] as String? ??
        (venue.languageOptions.isNotEmpty ? venue.languageOptions.first : 'en');
    if (newCode == currentDefault) {
      return;
    }

    // Actually update the draftVenue to set the new default
    ref.read(draftVenueProvider.notifier).updateDefaultLanguage(newCode);

    // Clear the local selection so the dropdown goes back to placeholder
    setState(() {
      _selectedLangCode = null;
    });
  }
}
