import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/images/image_card.dart';
import 'package:aureola_platform/images/venue_image_controller.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/menu_branding_form_fields.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/menu_branding_preview.dart';
import 'package:aureola_platform/service/firebase/firestore_venue.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBranding extends ConsumerWidget {
  const MenuBranding({Key? key}) : super(key: key);

  static const double baseNavRailWidth = 230.0;
  static const double minFormWidth = 600.0;
  static const double maxFormWidth = 800.0;
  static const double previewContainerWidth = 393.0;
  static const double cardSpacing = 20.0;
  static const double mobileBreakpoint = 700.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venue = ref.read(venueProvider);

    if (venue == null) {
      return const LoginPage();
    }

    final design = venue.designAndDisplay;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < mobileBreakpoint;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth - baseNavRailWidth;
              const minNeededForTwoCards = baseNavRailWidth +
                  minFormWidth +
                  previewContainerWidth +
                  (3 * cardSpacing);

              final isDesktop =
                  !isMobile && constraints.maxWidth >= minNeededForTwoCards;
              final isTablet = !isMobile &&
                  !isDesktop &&
                  constraints.maxWidth > mobileBreakpoint;

              if (isDesktop) {
                final maxPossibleFormWidth =
                    availableWidth - previewContainerWidth - (3 * cardSpacing);
                final formContainerWidth =
                    maxPossibleFormWidth.clamp(minFormWidth, maxFormWidth);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: formContainerWidth,
                      margin: const EdgeInsets.all(cardSpacing),
                      decoration: AppThemeLocal.cardDecoration,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            MenuBrandingFormFields(
                              design: design,
                              layout: 'isDesktop',
                            ),
                            _saveCancel(ref),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: previewContainerWidth,
                      margin: const EdgeInsets.all(cardSpacing),
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const SingleChildScrollView(
                        child: MenuBrandingPreview(),
                      ),
                    ),
                  ],
                );
              } else if (isTablet) {
                final tabletFormWidth = (availableWidth - (2 * cardSpacing))
                    .clamp(minFormWidth, maxFormWidth);

                return Stack(
                  children: [
                    Center(
                      child: Container(
                        width: tabletFormWidth,
                        margin: const EdgeInsets.all(cardSpacing),
                        decoration: AppThemeLocal.cardDecoration,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              MenuBrandingFormFields(
                                design: design,
                                layout: 'isTablet',
                              ),
                              _saveCancel(ref),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: FloatingActionButton(
                        onPressed: () => _showPreviewDialog(context),
                        child: const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ],
                );
              } else if (isMobile) {
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: AppThemeLocal.cardDecorationMob,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            MenuBrandingFormFields(
                              design: design,
                              layout: 'isMobile',
                            ),
                            _saveCancel(ref),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: FloatingActionButton(
                        onPressed: () => _showPreviewDialog(context),
                        child: const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ],
                );
              } else {
                final fallbackWidth = (constraints.maxWidth -
                        baseNavRailWidth -
                        (2 * cardSpacing))
                    .clamp(minFormWidth, maxFormWidth);
                return Center(
                  child: Container(
                    width: fallbackWidth,
                    margin: const EdgeInsets.all(cardSpacing),
                    decoration: AppThemeLocal.cardDecoration,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MenuBrandingFormFields(
                              design: design, layout: 'isMobile'),
                          _saveCancel(ref),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        if (screenWidth >= mobileBreakpoint) const AppFooter(),
      ],
    );
  }

  Widget _saveCancel(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _onCancel(ref),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _onSave(ref),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _showPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preview'),
        content: const Text('This is where the preview will be shown.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(WidgetRef ref) async {
    final venue = ref.read(venueProvider);
    if (venue == null) return;

    final draftRatio = ref.read(draftLogoAspectRatioProvider);
    final draftImageData = ref.read(draftLogoImageDataProvider);

    final newDisplayName = ref.read(displayNameProvider);
    final newTagline = ref.read(taglineProvider);

    if (newDisplayName != venue.venueName) {
      //update provider venue
      ref.read(venueProvider.notifier).updateVenueName(newDisplayName);
      // update firestore
    }

    if (newTagline != venue.tagLine) {
      ref.read(venueProvider.notifier).updateTagline(newTagline);
    }

    if (draftRatio != null &&
        draftRatio != venue.designAndDisplay.logoAspectRatio) {
      await _updateLogoAspectRatioInFirestore(ref, draftRatio);
    }

    if (draftImageData != null) {
      await ref.read(venueImageControllerProvider.notifier).uploadImage(
            imageData: draftImageData,
            imageKey: 'logoUrl',
            imageCategory: 'branding',
            imageType: 'logo',
          );
    } else {
      if (venue.designAndDisplay.logoUrl.isNotEmpty) {
        await ref
            .read(venueImageControllerProvider.notifier)
            .deleteImage(imageKey: 'logoUrl');
      }
    }

    // Clear drafts
    ref.read(draftLogoAspectRatioProvider.notifier).state = null;
    ref.read(draftLogoImageDataProvider.notifier).state = null;
  }

  void _onCancel(WidgetRef ref) {
    // Discard draft changes
    ref.read(draftLogoAspectRatioProvider.notifier).state = null;
    ref.read(draftLogoImageDataProvider.notifier).state = null;
  }

  Future<void> _updateLogoAspectRatioInFirestore(
      WidgetRef ref, AspectRatioOption newRatio) async {
    final venue = ref.read(venueProvider);
    if (venue == null) return;

    final updatedDesign =
        venue.designAndDisplay.copyWith(logoAspectRatio: newRatio);
    final updatedVenue = venue.copyWith(designAndDisplay: updatedDesign);

    ref.read(venueProvider.notifier).setVenue(updatedVenue);

    await FirestoreVenue().updateVenue(
      venue.userId,
      venue.venueId,
      {'designAndDisplay': updatedDesign.toMap()},
    );
  }
}
