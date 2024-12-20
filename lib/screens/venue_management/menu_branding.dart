// lib/screens/venue_management/branding_design/menu_branding.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/form_fields.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/preview.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBranding extends ConsumerWidget {
  const MenuBranding({super.key});

  static const double baseNavRailWidth = 230.0;
  static const double minFormWidth = 600.0;
  static const double maxFormWidth = 800.0;
  static const double previewContainerWidth = 393.0;
  static const double cardSpacing = 20.0;
  static const double mobileBreakpoint = 700.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venue = ref.read(draftVenueProvider);

    if (venue == null) {
      return const LoginPage();
    }

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
                      child: const SingleChildScrollView(
                        child: MenuBrandingFormFields(layout: 'isDesktop'),
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
                        child: const SingleChildScrollView(
                          child: MenuBrandingFormFields(layout: 'isTablet'),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const MenuBrandingPreview(),
                          );
                        },
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
                      child: const SingleChildScrollView(
                        child: MenuBrandingFormFields(layout: 'isMobile'),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const MenuBrandingPreview(),
                          );
                        },
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
                    child: const SingleChildScrollView(
                      child: MenuBrandingFormFields(layout: 'isMobile'),
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
}

  // void _showPreviewDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => const AlertDialog(
  //       title: Text('Preview'),
  //       content: Text('This is where the preview will be shown.'),
  //       actions: [
  //         TextButton(
  //           onPressed: null,
  //           child: Text('CLOSE'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
