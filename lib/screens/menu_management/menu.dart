import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/menu_management/menu_list.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/form_fields.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/preview.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  static const double baseNavRailWidth = 230.0;
  static const double minFormWidth = 393.0;
  static const double maxFormWidth = 600.0;
  static const double previewContainerWidth = 393.0;
  static const double cardSpacing = 16.0;
  static const double mobileBreakpoint = 600.0;

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
              const minNeededForThreeCards = baseNavRailWidth +
                  minFormWidth +
                  minFormWidth +
                  previewContainerWidth +
                  (4 * cardSpacing);
              const minNeededForTwoCards = baseNavRailWidth +
                  minFormWidth +
                  minFormWidth +
                  (3 * cardSpacing);

              final isDesktop =
                  !isMobile && constraints.maxWidth >= minNeededForThreeCards;
              final isTablet = !isMobile &&
                  !isDesktop &&
                  constraints.maxWidth > minNeededForTwoCards;

              if (isDesktop) {
                final maxPossibleFormWidth = (availableWidth -
                        previewContainerWidth -
                        (4 * cardSpacing)) /
                    2;
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
                        child: MenuList(layout: 'isDesktop'),
                      ),
                    ),
                    Container(
                      width: formContainerWidth,
                      margin: const EdgeInsets.all(cardSpacing),
                      decoration: AppThemeLocal.cardDecoration,
                      child: const SingleChildScrollView(
                        child: MenuList(layout: 'isDesktop'),
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
                          child: MenuList(layout: 'isTablet'),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: tabletFormWidth,
                        margin: const EdgeInsets.all(cardSpacing),
                        decoration: AppThemeLocal.cardDecoration,
                        child: const SingleChildScrollView(
                          child: MenuList(layout: 'isTablet'),
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
                        child: MenuList(layout: 'isMobile'),
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
                      child: MenuList(layout: 'isMobile'),
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

