// lib/widgets/menu_branding_form_fields.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_palette.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBrandingFormFields extends ConsumerWidget {
  final String layout; // 'isDesktop', 'isTablet', 'isMobile', or fallback

  const MenuBrandingFormFields({
    super.key,
    required this.layout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define the list of color fields dynamically
    final List<Map<String, String>> colorFields = [
      {
        'name': 'Background Color',
        'field': 'backgroundColor',
      },
      {
        'name': 'Card Background',
        'field': 'cardBackground',
      },
      {
        'name': 'Accent Color',
        'field': 'accentColor',
      },
      {
        'name': 'Text Color',
        'field': 'textColor',
      },
      // Add more color fields here as needed
    ];

    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!
                    .translate("Branding_&_Viual_Design"),
                style: AppThemeLocal.headingCard,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.translate(
                "Upload_Your_Brand_Assets:_Logo",
              ),
              style: AppThemeLocal.paragraph,
            ),
            const SizedBox(height: 12),
            Divider(
                color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
            const SizedBox(height: 12),

            // Dynamically generate ColorPaletteSection widgets
            ...colorFields.map((colorField) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ColorPaletteSection(
                  layout: layout,
                  name: colorField['name']!,
                  colorField: colorField['field']!,
                ),
              );
            }).toList(),

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

  Widget _saveCancelButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _onCancel(context, ref),
          child: const Text('Cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _onSave(context, ref),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final form = Form.of(context);
    if (form != null && form.validate()) {
      // All fields are valid, proceed with saving
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All colors are valid!')),
      );

      // Implement your save logic here
      final updatedVenue = ref.read(draftVenueProvider);
      if (updatedVenue != null) {
        try {
          await FirestoreVenue().updateVenue(
              updatedVenue.userId, updatedVenue.venueId, updatedVenue.toMap());
          // After saving, update the main venueProvider
          ref.read(venueProvider.notifier).setVenue(updatedVenue);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Changes saved successfully!')),
          );
        } catch (e) {
          // Handle Firestore update errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save changes: $e')),
          );
        }
      }
    } else {
      // Validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fix the errors in red before saving.')),
      );
    }
  }

  void _onCancel(BuildContext context, WidgetRef ref) {
    // Discard draft changes by resetting draftVenueProvider to venueProvider's value
    final originalVenue = ref.read(venueProvider);
    if (originalVenue != null) {
      ref.read(draftVenueProvider.notifier).setVenue(originalVenue);
      // Optionally, reset form fields if needed
      final form = Form.of(context);
      if (form != null) {
        form.reset();
      }
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
