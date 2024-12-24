// lib/screens/venue_management/branding_design/form_fields.dart

import 'package:aureola_platform/images/venue_image_controller.dart';
import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/main_title_provider.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_palette.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/logo_upload.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuList extends ConsumerStatefulWidget {
  final String layout; // 'isDesktop', 'isTablet', 'isMobile', or fallback

  const MenuList({
    super.key,
    required this.layout,
  });

  @override
  ConsumerState<MenuList> createState() => _MenuBrandingFormFieldsState();
}

class _MenuBrandingFormFieldsState extends ConsumerState<MenuList> {
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

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child:
            //       (widget.layout == 'isDesktop' || widget.layout == 'isTablet')
            //           ? Text(
            //               AppLocalizations.of(context)!
            //                   .translate("branding_visual_design_title"),
            //               style: AppThemeLocal.headingCard,
            //             )
            //           : null,
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   AppLocalizations.of(context)!
            //       .translate("upload_brand_assets_logo"),
            //   style: AppThemeLocal.paragraph,
            // ),

            // const SizedBox(height: 12),
            // Divider(
            //     color: AppThemeLocal.accent.withOpacity(0.5), thickness: 0.5),
            // const SizedBox(height: 8),

// Title

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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: Text(AppLocalizations.of(context)!.translate('cancel_button')),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _onSaveForm(context, ref),
          child: Text(AppLocalizations.of(context)!.translate('save_button')),
        ),
      ],
    );
  }

  Future<void> _onSaveForm(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) {
      // ...
      return;
    }

    final user = ref.read(userProvider);
    final draft = ref.read(draftVenueProvider);
    if (user == null || draft == null) {
      // ...
      return;
    }

    try {
      final imageController = ref.read(venueImageControllerProvider.notifier);
      final newImageData = ref.read(draftLogoImageDataProvider);
      final wantToDeleteOld = ref.read(draftLogoDeleteProvider);

      // 1) Possibly upload new image
      String newLogoUrl = draft.designAndDisplay.logoUrl;
      if (newImageData != null) {
        final uploadedUrl = await imageController.uploadImage(
          imageData: newImageData,
          imageKey: 'logoUrl',
          imageCategory: 'branding',
          imageType: 'logo',
        );
        if (uploadedUrl == null) {
          throw Exception('Image upload failed');
        }
        newLogoUrl = uploadedUrl;
      }

      // 2) Possibly delete old image (if user wants to delete & no new image is picked)
      final oldImageUrl = draft.designAndDisplay.logoUrl;
      final hasPickedANewImage = (newImageData != null);
      if (wantToDeleteOld && !hasPickedANewImage && oldImageUrl.isNotEmpty) {
        await imageController.deleteImage(imageKey: 'logoUrl');
        newLogoUrl = '';
      }

      // 3) Build a final venue with the final logoUrl
      final updatedDraft = ref.read(draftVenueProvider);
      if (updatedDraft == null) {
        throw Exception('Draft unexpectedly null after uploading image');
      }

      final finalLogoUrl =
          (wantToDeleteOld && !hasPickedANewImage) ? '' : newLogoUrl;

      final finalDesign = updatedDraft.designAndDisplay.copyWith(
        logoUrl: finalLogoUrl,
      );
      final finalVenue = updatedDraft.copyWith(designAndDisplay: finalDesign);

      // 4) Update Firestore
      final updateData = {
        'designAndDisplay.logoUrl': finalLogoUrl,
        'designAndDisplay.logoAspectRatio': finalDesign.logoAspectRatio.name,
        'designAndDisplay.backgroundColor': finalDesign.backgroundColor,
        'designAndDisplay.cardBackground': finalDesign.cardBackground,
        'designAndDisplay.accentColor': finalDesign.accentColor,
        'designAndDisplay.textColor': finalDesign.textColor,
      };
      await FirestoreVenue().updateVenue(
        user.userId,
        finalVenue.venueId,
        updateData,
      );

      // 5) Update stable provider
      ref.read(venueProvider.notifier).setVenue(finalVenue);

      // 6) ALSO update the draft provider so your UI sees the new URL
      ref.read(draftVenueProvider.notifier).setVenue(finalVenue);

      // 7) Clear temporary states
      ref.read(draftLogoImageDataProvider.notifier).state = null;
      ref.read(draftLogoDeleteProvider.notifier).state = false;

      // 8) Show success
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
      // Show error
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
      // Clear draft picks
      ref.read(draftLogoImageDataProvider.notifier).state = null;
      ref.read(draftLogoDeleteProvider.notifier).state = false;
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
