import 'dart:typed_data';

import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/images/image_card.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/models/venue/design_display.dart';

class MenuBranding extends ConsumerWidget {
  const MenuBranding({Key? key}) : super(key: key);

  static const double baseNavRailWidth = 230.0;
  static const double minFormWidth = 600.0;
  static const double maxFormWidth = 800.0;
  static const double previewContainerWidth = 485.0;
  static const double cardSpacing = 20.0;
  static const double mobileBreakpoint = 700.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venue = ref.watch(venueProvider);

    if (venue == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
                // Desktop scenario: Two containers side by side
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
                      decoration: AppTheme.cardDecoration,
                      child: SingleChildScrollView(
                        child:
                            _buildFormFields(context, design, ref, 'isDesktop'),
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
                      child: SingleChildScrollView(
                          child: _buildPreviewContainer()),
                    ),
                  ],
                );
              } else if (isTablet) {
                // Tablet scenario: One container and a preview button (FAB)
                final tabletFormWidth = (availableWidth - (2 * cardSpacing))
                    .clamp(minFormWidth, maxFormWidth);

                return Stack(
                  children: [
                    Center(
                      child: Container(
                        width: tabletFormWidth,
                        margin: const EdgeInsets.all(cardSpacing),
                        decoration: AppTheme.cardDecoration,
                        child: SingleChildScrollView(
                          child: _buildFormFields(
                              context, design, ref, 'isTablet'),
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
                // Mobile scenario: Full width + FAB for preview
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: AppTheme.cardDecorationMob,
                      child: SingleChildScrollView(
                        child:
                            _buildFormFields(context, design, ref, 'isMobile'),
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
                // Fallback scenario: treat as tablet
                final fallbackWidth = (constraints.maxWidth -
                        baseNavRailWidth -
                        (2 * cardSpacing))
                    .clamp(minFormWidth, maxFormWidth);
                return Center(
                  child: Container(
                    width: fallbackWidth,
                    margin: const EdgeInsets.all(cardSpacing),
                    decoration: AppTheme.cardDecoration,
                    child: SingleChildScrollView(
                      child: _buildFormFields(context, design, ref, ''),
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

  Widget _buildFormFields(BuildContext context, DesignAndDisplay design,
      WidgetRef ref, String layout) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
              AppLocalizations.of(context)!
                  .translate("Customize_your_brand_look"),
              style: AppTheme.appBarTitle),
          const SizedBox(height: 8),
          Text(
              AppLocalizations.of(context)!.translate(
                  "Add_your_brand_s_colors to personalize your product. Choose text, background, and highlight colors to match your identity!"),
              style: AppTheme.paragraph),
          const SizedBox(height: 16),
          if (layout == 'isDesktop' || layout == 'isTablet')
            _buildRowLayout(context, ref, design)
          else if (layout == 'isMobile')
            _buildColumnLayoutForMobile(context, ref, design)
          else
            // fallback
            _buildRowLayout(context, ref, design),
        ],
      ),
    );
  }

  Widget _buildPreviewContainer() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Preview', style: AppTheme.paragraph),
          SizedBox(height: 10),
          Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity),
        ],
      ),
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

  Widget _buildRowLayout(
      BuildContext context, WidgetRef ref, DesignAndDisplay design) {
    // Left: Title, "Select Aspect Ratio", Dropdown
    // Right: ImageUploadCard
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Panel
        Expanded(
          flex: 1,
          child: _buildLeftPanel(context, ref, design),
        ),
        const SizedBox(width: 20),
        // Right Panel
        Expanded(
          flex: 1,
          child: _buildRightPanel(context, design),
        ),
      ],
    );
  }

  Widget _buildColumnLayoutForMobile(
      BuildContext context, WidgetRef ref, DesignAndDisplay design) {
    // For mobile, stack vertically
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeftPanel(context, ref, design),
        const SizedBox(height: 20),
        _buildRightPanel(context, design),
      ],
    );
  }

  Widget _buildLeftPanel(
      BuildContext context, WidgetRef ref, DesignAndDisplay design) {
    final venueNotifier = ref.read(venueProvider.notifier);
    final currentRatio = design.logoAspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("Upload_Logo"),
          style: AppTheme.appBarTitle,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.translate("Select_aspect_ratio"),
          style: AppTheme.paragraph,
        ),
        const SizedBox(height: 8),
        DropdownButton<AspectRatioOption>(
          value: currentRatio,
          items: AspectRatioOption.values
              .map((ratio) => DropdownMenuItem<AspectRatioOption>(
                    value: ratio,
                    child: Text(ratio.label),
                  ))
              .toList(),
          onChanged: (newRatio) async {
            if (newRatio == null) return;
            // Update aspect ratio immediately in VenueNotifier and Firestore
            await venueNotifier.updateLogoAspectRatio(newRatio);
          },
        ),
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context, DesignAndDisplay design) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageUploadCard(
          width: 300,
          aspectRatioOption: design.logoAspectRatio,
          imageKey: 'logoUrl',
          imageCategory: 'branding',
          imageType: 'logo',
        ),
      ],
    );
  }
}
