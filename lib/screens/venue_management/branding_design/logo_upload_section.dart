import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/images/image_card.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class LogoUploadSection extends ConsumerWidget {
  final String layout;
  final AspectRatioOption currentRatio;

  const LogoUploadSection({
    Key? key,
    required this.layout,
    required this.currentRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Decide layout based on the parent's `layout` value
    if (layout == 'isDesktop' || layout == 'isTablet') {
      // Desktop/Tablet: Use row layout
      return Row(
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
      );
    } else if (layout == 'isMobile') {
      // Mobile: Use column layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeftPanel(context, ref, currentRatio),
          const SizedBox(height: 20),
          _buildRightPanel(context, ref, currentRatio),
        ],
      );
    } else {
      // Fallback layout can be the same as desktop if desired
      return Row(
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
      );
    }
  }

  Widget _buildLeftPanel(
      BuildContext context, WidgetRef ref, AspectRatioOption currentRatio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("Upload_Logo"),
          style: AppThemeLocal.appBarTitle,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.translate("Select_aspect_ratio"),
          style: AppThemeLocal.paragraph,
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
          onChanged: (newRatio) {
            if (newRatio == null) return;
            // Just update draft ratio, do not upload yet
            ref.read(draftLogoAspectRatioProvider.notifier).state = newRatio;
          },
        ),
      ],
    );
  }

  Widget _buildRightPanel(
      BuildContext context, WidgetRef ref, AspectRatioOption currentRatio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageUploadCard(
          width: 300,
          aspectRatioOption: currentRatio,
          imageKey: 'logoUrl',
          imageCategory: 'branding',
          imageType: 'logo',
        ),
      ],
    );
  }
}
