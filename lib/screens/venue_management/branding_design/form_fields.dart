// lib/screens/venue_management/branding_design/form_fields.dart

import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/images/image_card.dart';
import 'package:aureola_platform/images/venue_image_controller.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_palette.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/logo_upload.dart';
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

  void _initializeFormFields(VenueModel? venue) {
    if (venue != null) {
      ref.read(draftVenueProvider.notifier).setVenue(venue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draftVenue = ref.watch(draftVenueProvider);

    // Handle null draftVenue gracefully
    if (draftVenue == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Convert hex strings to Color objects
    Color backgroundColor =
        _hexToColor(draftVenue.designAndDisplay.backgroundColor);
    Color cardBackgroundColor =
        _hexToColor(draftVenue.designAndDisplay.cardBackground);
    Color accentColor = _hexToColor(draftVenue.designAndDisplay.accentColor);
    Color textColor = _hexToColor(draftVenue.designAndDisplay.textColor);

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
                    .translate("branding_visual_design_title"),
                style: AppThemeLocal.headingCard,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!
                  .translate("upload_brand_assets_logo"),
              style: AppThemeLocal.paragraph,
            ),

            const SizedBox(height: 12),
            Divider(
                color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
            const SizedBox(height: 8),

// Title
            Center(
              child: Text(
                AppLocalizations.of(context)!
                    .translate("Customize_Your_Color_Palette"),
                style: AppThemeLocal.headingCard.copyWith(
                    fontSize: 16), // Assuming you have a heading style
              ),
            ),

// Description
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.translate(
                  "Select_and_save_your_preferred_colors_to_personalize_your_QR_menu."),
              style: AppThemeLocal.paragraph.copyWith(
                  color: AppThemeLocal.secondary,
                  fontSize: 14), // Assuming you have a paragraph style
            ),
            const SizedBox(height: 8),
            // Each ColorPaletteSection handles one color with unique colorField
            ColorPaletteSection(
              name: AppLocalizations.of(context)!.translate('background_color'),
              colorField: 'backgroundColor', // Correct identifier
              initialColor: backgroundColor,
            ),

            const SizedBox(height: 8),
            ColorPaletteSection(
              name: AppLocalizations.of(context)!.translate('card_background'),
              colorField: 'cardBackground', // Correct identifier
              initialColor: cardBackgroundColor,
            ),

            const SizedBox(height: 12),
            ColorPaletteSection(
              name: AppLocalizations.of(context)!.translate('accent_color'),
              colorField: 'accentColor', // Correct identifier
              initialColor: accentColor,
            ),

            const SizedBox(height: 12),
            ColorPaletteSection(
              name: AppLocalizations.of(context)!.translate('text_color'),
              colorField: 'textColor', // Correct identifier
              initialColor: textColor,
            ),
            const SizedBox(height: 12),
            Divider(
                color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),

            const SizedBox(height: 12),
            LogoUploadSection(
              layout: widget.layout,
            ),

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
          child: Text(AppLocalizations.of(context)!.translate('cancel_button')),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _saveForm(context, ref),
          child: Text(AppLocalizations.of(context)!.translate('save_button')),
        ),
      ],
    );
  }

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('please_fix_errors'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = ref.read(userProvider);
    final draft = ref.read(draftVenueProvider);
    if (user == null || draft == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('unable_to_save'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // 1. Access the VenueImageController
      final imageController = ref.read(venueImageControllerProvider.notifier);

      // 2. Check if user picked a new logo image
      final logoImageData = ref.read(draftLogoImageDataProvider);
      if (logoImageData != null) {
        // 2a. Upload that image to Firebase Storage
        final imageUrl = await imageController.uploadImage(
          imageData: logoImageData,
          imageKey: 'logoUrl',
          imageCategory: 'branding',
          imageType: 'logo',
        );

        // 2b. If the upload succeeded, the draftVenue is already updated internally.
        //     (But you can explicitly call updateLogoUrl if you want.)
        if (imageUrl == null) {
          throw Exception('Image upload failed');
        }
      }

      // 3. Read the updated draft again (it now has the newly uploaded image URL)
      final updatedDraft = ref.read(draftVenueProvider);
      if (updatedDraft == null) {
        throw Exception('Draft venue became null unexpectedly');
      }

      // 4. Build Firestore update data from the updated draft
      final updateData = {
        'designAndDisplay.backgroundColor':
            updatedDraft.designAndDisplay.backgroundColor,
        'designAndDisplay.cardBackground':
            updatedDraft.designAndDisplay.cardBackground,
        'designAndDisplay.accentColor':
            updatedDraft.designAndDisplay.accentColor,
        'designAndDisplay.textColor': updatedDraft.designAndDisplay.textColor,
        'designAndDisplay.logoUrl': updatedDraft.designAndDisplay.logoUrl,
        // 4a. Save aspect ratio if desired:
        'designAndDisplay.logoAspectRatio':
            updatedDraft.designAndDisplay.logoAspectRatio.name,
      };

      // 5. Update Firestore once with all final changes
      await FirestoreVenue().updateVenue(
        user.userId,
        updatedDraft.venueId,
        updateData,
      );

      // 6. Update the stable venue provider
      ref.read(venueProvider.notifier).setVenue(updatedDraft);

      // 7. Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .translate('changes_saved_successfully'),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // If anything fails, show an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.translate('save_failed')}: $e',
          ),
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

      // Removed setState as provider updates trigger rebuilds
      _initializeFormFields(originalVenue);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.translate('changes_discarded')),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('original_venue_data_not_found')),
        ),
      );
    }
  }
}
