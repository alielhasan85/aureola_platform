import 'package:aureola_platform/models/venue/venue_model.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/images/image_card.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class LogoUploadSection extends ConsumerWidget {
  final String layout;

  const LogoUploadSection({
    super.key,
    required this.layout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftVenue = ref.read(draftVenueProvider);
    final currentRatio = draftVenue!.designAndDisplay.logoAspectRatio;

    // Decide layout based on the parent's `layout` value
    if (layout == 'isDesktop' || layout == 'isTablet') {
      // Desktop/Tablet: Use row layout
      return Column(children: [
        Center(
          child: Text(
            AppLocalizations.of(context)!.translate("Upload_Logo"),
            style: AppThemeLocal.headingCard.copyWith(fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _buildLeftPanel(context, ref, currentRatio),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: _buildRightPanel(context, ref, currentRatio),
            ),
          ],
        ),
      ]);
    } else if (layout == 'isMobile') {
      // Mobile: Use column layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Upload_Logo"),
              style: AppThemeLocal.headingCard.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          _buildLeftPanel(context, ref, currentRatio),
          const SizedBox(height: 16),
          _buildRightPanel(context, ref, currentRatio),
        ],
      );
    } else {
      // Fallback layout can be the same as desktop if desired
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Upload_Logo"),
              style: AppThemeLocal.headingCard.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: _buildLeftPanel(context, ref, currentRatio),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: _buildRightPanel(context, ref, currentRatio),
          ),
        ],
      );
    }
  }

  Widget _buildLeftPanel(
      BuildContext context, WidgetRef ref, AspectRatioOption currentRatio) {
    VenueModel? venue = ref.read(draftVenueProvider);
    bool isImage = venue!.designAndDisplay.logoUrl.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("Select_aspect_ratio"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 8),
        DropdownButton<AspectRatioOption>(
          enableFeedback: isImage,
          value: currentRatio,
          items: AspectRatioOption.values
              .map((ratio) => DropdownMenuItem<AspectRatioOption>(
                    value: ratio,
                    child: Text(ratio.label),
                  ))
              .toList(),
          onChanged: (newRatio) {
            if (newRatio == null) return;
            // Just update draft ratio, do not upload yet
            ref
                .read(draftVenueProvider.notifier)
                .updateLogoAspectRatio(newRatio);
            // Update the aspect ratio in the provider
            //ref.read(draftLogoAspectRatioProvider.notifier).state = newRatio;
          },
        ),
      ],
    );
  }

  Widget _buildRightPanel(
      BuildContext context, WidgetRef ref, AspectRatioOption currentRatio) {
    return ImageUploadCard(
      width: 150,
      aspectRatioOption: currentRatio,
      imageKey: 'logoUrl',
      imageCategory: 'branding',
      imageType: 'logo',
    );
  }
}
