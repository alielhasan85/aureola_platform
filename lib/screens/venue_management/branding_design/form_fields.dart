// lib/screens/venue_management/branding_design/form_fields.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_palette.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBrandingFormFields extends ConsumerStatefulWidget {
  final String layout; // 'isDesktop', 'isTablet', 'isMobile', or fallback

  const MenuBrandingFormFields({
    super.key,
    required this.layout,
  });

  @override
  ConsumerState<MenuBrandingFormFields> createState() =>
      _MenuBrandingFormFieldsState();
}

class _MenuBrandingFormFieldsState
    extends ConsumerState<MenuBrandingFormFields> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final draftVenue = ref.watch(draftVenueProvider);

    // Ensure draftVenue is not null
    if (draftVenue == null) {
      // Show loading or placeholder
      return const Center(child: CircularProgressIndicator());
    }

    final design = draftVenue.designAndDisplay;

    // Convert hex strings to Color objects
    final backgroundColor = _hexToColor(design.backgroundColor);
    final cardBackgroundColor = _hexToColor(design.cardBackground);
    final accentColor = _hexToColor(design.accentColor);
    final textColor = _hexToColor(design.textColor);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!
                    .translate("Branding_&_Visual_Design"),
                style: AppThemeLocal.headingCard,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!
                  .translate("Upload_Your_Brand_Assets:_Logo"),
              style: AppThemeLocal.paragraph,
            ),
            const SizedBox(height: 12),
            Divider(
                color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
            const SizedBox(height: 12),

            // Each ColorPaletteSection handles one color
            ColorPaletteSection(
              name: 'Background Color',
              colorField: 'backgroundColor',
              initialColor: backgroundColor,
            ),

            const SizedBox(height: 12),
            ColorPaletteSection(
              name: 'Card Background',
              colorField: 'cardBackground',
              initialColor: cardBackgroundColor,
            ),

            const SizedBox(height: 12),
            ColorPaletteSection(
              name: 'Accent Color',
              colorField: 'accentColor',
              initialColor: accentColor,
            ),

            const SizedBox(height: 12),
            ColorPaletteSection(
              name: 'Text Color',
              colorField: 'textColor',
              initialColor: textColor,
            ),

            const SizedBox(height: 12),
            Divider(
                color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
            const SizedBox(height: 20),

            _saveCancelButtons(context, ref),
          ],
        ),
      ),
    );
  }

  /// Converts a hex string to a Color object
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Converts a Color object to a hex string
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Widget _saveCancelButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _onCancel(context, ref),
          child: const Text('Cancel'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _saveForm(context, ref),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = ref.read(userProvider);
      final draft = ref.read(draftVenueProvider);

      if (user == null || draft == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.translate('unable_to_save')),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final updateData = {
          'designAndDisplay.backgroundColor':
              draft.designAndDisplay.backgroundColor,
          'designAndDisplay.cardBackground':
              draft.designAndDisplay.cardBackground,
          'designAndDisplay.accentColor': draft.designAndDisplay.accentColor,
          'designAndDisplay.textColor': draft.designAndDisplay.textColor,
        };

        await FirestoreVenue()
            .updateVenue(user.userId, draft.venueId, updateData);

        // Update stable provider after successful save
        ref.read(venueProvider.notifier).setVenue(draft);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .translate('changes_saved_successfully')),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.translate('save_failed')}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.translate('please_fix_errors')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onCancel(BuildContext context, WidgetRef ref) {
    final originalVenue = ref.read(venueProvider);

    if (originalVenue != null) {
      ref.read(draftVenueProvider.notifier).setVenue(originalVenue);
      _formKey.currentState?.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes have been discarded.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Original venue data not found.')),
      );
    }
  }
}
