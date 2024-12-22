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

    if (layout == 'isDesktop' || layout == 'isTablet') {
      return Column(
        children: [
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
              Expanded(child: _buildLeftPanel(context, ref, currentRatio)),
              const SizedBox(width: 20),
              Expanded(child: _buildRightPanel(context, ref, currentRatio)),
            ],
          ),
        ],
      );
    } else if (layout == 'isMobile') {
      return Column(
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Upload_Logo"),
              style: AppThemeLocal.headingCard.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          _buildLeftPanel(context, ref, currentRatio),
          const SizedBox(height: 16),
          _buildRightPanel(context, ref, currentRatio),
        ],
      );
    } else {
      // fallback layout
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildLeftPanel(context, ref, currentRatio)),
          const SizedBox(width: 20),
          Expanded(child: _buildRightPanel(context, ref, currentRatio)),
        ],
      );
    }
  }

  Widget _buildLeftPanel(
      BuildContext context, WidgetRef ref, AspectRatioOption currentRatio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("Select_aspect_ratio"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 8),
        DropdownButton<AspectRatioOption>(
          value: currentRatio,
          items: AspectRatioOption.values.map((ratio) {
            return DropdownMenuItem<AspectRatioOption>(
              value: ratio,
              child: Text(ratio.label),
            );
          }).toList(),
          onChanged: (newRatio) {
            if (newRatio == null) return;
            ref
                .read(draftVenueProvider.notifier)
                .updateLogoAspectRatio(newRatio);
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
