import 'package:aureola_platform/widgest/language_config.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class DefaultLanguageDropdown extends ConsumerStatefulWidget {
  final double width;

  /// We store an ISO code, e.g. 'en', 'ar', 'fr', 'tr'.
  final String initialLanguage;

  final ValueChanged<String>? onChanged;

  const DefaultLanguageDropdown({
    super.key,
    required this.width,
    this.initialLanguage = 'en',
    this.onChanged,
  });

  @override
  ConsumerState<DefaultLanguageDropdown> createState() =>
      _DefaultLanguageDropdownState();
}

class _DefaultLanguageDropdownState
    extends ConsumerState<DefaultLanguageDropdown> {
  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    // If it’s already a code, this is no-op. If it’s "English" from older data,
    // nameToCode will convert => "en"
    _selectedCode = nameToCode(widget.initialLanguage);
  }

  @override
  Widget build(BuildContext context) {
    // We show user-friendly names in the dropdown
    final languageNames = kSupportedLanguageCodes.map(codeToName).toList();

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("default_language"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          DropdownSearch<String>(
            items: (filter, _) => languageNames,
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
            // Show user-friendly name
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null) {
                return Text(
                  AppLocalizations.of(context)!
                          .translate("Select_Default_Language") ,
                  style: AppThemeLocal.paragraph,
                );
              }
              return Text(
                AppLocalizations.of(context)!.translate(selectedItem),
                style: AppThemeLocal.paragraph,
              );
            },
            // Convert the stored code -> user-friendly name for the selected item
            selectedItem: codeToName(_selectedCode),

            onChanged: (String? newFriendlyName) {
              if (newFriendlyName == null) return;
              final newCode = nameToCode(newFriendlyName);

              setState(() {
                _selectedCode = newCode;
              });

              // Here we call updateDefaultLanguage in the draftVenue
              ref
                  .read(draftVenueProvider.notifier)
                  .updateDefaultLanguage(newCode);

              // Also call the parent callback
              if (widget.onChanged != null) {
                widget.onChanged!(newCode);
              }
            },
          ),
        ],
      ),
    );
  }
}
