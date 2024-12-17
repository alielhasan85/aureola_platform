import 'package:aureola_platform/images/image_card.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_palette.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/display_name.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/logo_upload_section.dart';

import 'package:aureola_platform/screens/venue_management/widgets_venue_info/tag_line.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/models/venue/design_display.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBrandingFormFields extends ConsumerWidget {
  final DesignAndDisplay design;
  final String layout; // 'isDesktop', 'isTablet', 'isMobile', or fallback

  const MenuBrandingFormFields({
    super.key,
    required this.design,
    required this.layout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftRatio = ref.watch(draftLogoAspectRatioProvider);
    final currentRatio = draftRatio ?? design.logoAspectRatio;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!
                  .translate("Branding_&_Viual_Design"),
              style: AppTheme.headingCard,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.translate(
              "Upload_Your_Brand_Assets:_Logo",
            ),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 16),

          _buildNameAndTaglineLayout(),
          const SizedBox(height: 16),

          LogoUploadSection(
            layout: layout,
            currentRatio: currentRatio,
          ),
          const SizedBox(height: 16),

          // Now we add the color palette section below the logo upload
          ColorPaletteSection(layout: layout),
        ],
      ),
    );
  }

  Widget _buildNameAndTaglineLayout() {
    if (layout == 'isDesktop' || layout == 'isTablet') {
      return Row(
        children: [
          Expanded(child: DisplayName()),
          const SizedBox(width: 16),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DisplayName(),
          const SizedBox(height: 16),
          // TaglineWidget(
          //   width: 300,
          // ),
        ],
      );
    }
  }
}
