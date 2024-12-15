import 'package:aureola_platform/images/image_card.dart';
import 'package:aureola_platform/screens/menu_management/branding_design/widgets/color_palette.dart';
import 'package:aureola_platform/screens/menu_management/branding_design/widgets/display_name.dart';
import 'package:aureola_platform/screens/menu_management/branding_design/widgets/logo_upload_section.dart';
import 'package:aureola_platform/screens/menu_management/branding_design/widgets/tag_line.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/models/venue/design_display.dart';
import 'package:aureola_platform/images/aspect_ratio.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
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
        children: [
          Text(
            AppLocalizations.of(context)!
                .translate("Customize_your_brand_look"),
            style: AppTheme.appBarTitle,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.translate(
              "Tailor_your_QR_menu_to_showcase your unique brand identity.",
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
          Expanded(child: TaglineWidget()),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DisplayName(),
          const SizedBox(height: 16),
          TaglineWidget(),
        ],
      );
    }
  }
}
