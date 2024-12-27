// lib/screens/menu.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/menu_management/items_list.dart';
import 'package:aureola_platform/screens/menu_management/menu_list.dart';
import 'package:aureola_platform/screens/menu_management/section_list.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/preview.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// appBarTitleProvider import
import 'package:aureola_platform/providers/main_title_provider.dart';

/// This widget shows either 3 side-by-side containers on desktop,
/// or a horizontal carousel on tablet/mobile, for:
///  - Menu
///  - Section
///  - Items
///
/// The actual container shown depends on selectedMenuIndexProvider:
///  - 3 => "Menu"
///  - 4 => "Section"
///  - 5 => "Items"
class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  // Navigation rail width
  static const double baseNavRailWidth = 230.0;

  // Minimum recommended width for each container
  static const double minFormWidth = 393.0;

  // Maximum recommended width for each container
  static const double maxFormWidth = 600.0;

  // Spacing between cards
  static const double cardSpacing = 16.0;

  // Mobile breakpoint
  static const double mobileBreakpoint = 600.0;

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  // Carousel controller for tablet/mobile
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // Helper to set the appBarTitleProvider based on containerIndex (0,1,2)
  void _updateSubTitle(int containerIndex) {
    String subTitle;
    switch (containerIndex) {
      case 0:
        subTitle = 'Menu';
        break;
      case 1:
        subTitle = 'Section';
        break;
      default:
        subTitle = 'Items';
        break;
    }
    ref.read(appBarTitleProvider.notifier).state =
        "Menu Management - $subTitle";
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) {
      return const LoginPage();
    }

    // Global selected index from the nav rail: 3 => Menu, 4 => Section, 5 => Items
    final globalIndex = ref.watch(selectedMenuIndexProvider);

    // Map globalIndex => containerIndex (0 => Menu, 1 => Section, 2 => Items)
    int containerIndex = globalIndex - 3;
    if (containerIndex < 0) containerIndex = 0;
    if (containerIndex > 2) containerIndex = 2;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < Menu.mobileBreakpoint;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Space available minus nav rail
              final availableWidth =
                  constraints.maxWidth - Menu.baseNavRailWidth;

              // If the screen can fit 3 min-form-width containers side by side + spacing:
              const minNeededForThreeCards = Menu.baseNavRailWidth +
                  (Menu.minFormWidth * 3) +
                  (4 * Menu.cardSpacing);

              // If the screen can fit at least 2 containers:
              const minNeededForTwoCards = Menu.baseNavRailWidth +
                  (Menu.minFormWidth * 2) +
                  (3 * Menu.cardSpacing);

              final isDesktop =
                  !isMobile && constraints.maxWidth >= minNeededForThreeCards;
              final isTablet = !isMobile &&
                  !isDesktop &&
                  constraints.maxWidth > minNeededForTwoCards;

              // ==============================
              // DESKTOP LAYOUT: 3 side-by-side
              // ==============================
              if (isDesktop) {
                // Each card's maximum possible width
                final maxPossibleFormWidth =
                    (availableWidth - (4 * Menu.cardSpacing)) / 3;
                final formContainerWidth = maxPossibleFormWidth.clamp(
                  Menu.minFormWidth,
                  Menu.maxFormWidth,
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    // isSelected if index == containerIndex
                    final isSelected = (index == containerIndex);

                    // Determine which child widget for 0 => Menu, 1 => Section, 2 => Items
                    Widget childWidget;
                    switch (index) {
                      case 0:
                        childWidget = const MenuList(layout: 'isDesktop');
                        break;
                      case 1:
                        childWidget = const SectionList(layout: 'isDesktop');
                        break;
                      default:
                        childWidget = const ItemsList(layout: 'isDesktop');
                        break;
                    }

                    return GestureDetector(
                      onTap: () {
                        // user picks container #index => set global index = 3 + index
                        ref.read(selectedMenuIndexProvider.notifier).state =
                            3 + index;
                        _updateSubTitle(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: formContainerWidth,
                        margin: const EdgeInsets.all(Menu.cardSpacing),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x4C000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: AppThemeLocal.lightPeach,
                                    blurRadius: 10.0,
                                    offset: Offset(0, 5),
                                  )
                                ],
                                border: Border.all(
                                  color: AppThemeLocal.lightPeach,
                                  width: 2.0,
                                ),
                              )
                            : AppThemeLocal.cardDecoration,
                        child: SingleChildScrollView(
                          child: childWidget,
                        ),
                      ),
                    );
                  }),
                );
              }

              // ==============================
              // TABLET/MOBILE => Carousel
              // ==============================
              else {
                // layoutType used by the child widgets
                final layoutType = isTablet ? 'isTablet' : 'isMobile';

                Widget buildCarouselItem(Widget w) {
                  if (isMobile) {
                    // full width, no card shape
                    return Container(
                      width: constraints.maxWidth,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.white,
                      child: SingleChildScrollView(child: w),
                    );
                  } else {
                    // Tablet => partial width with some shape
                    const desired = 550.0;
                    final cardWidth = desired.clamp(
                      Menu.minFormWidth,
                      Menu.maxFormWidth,
                    );
                    return Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: AppThemeLocal.cardDecoration,
                      child: SingleChildScrollView(child: w),
                    );
                  }
                }

                // 1.0 for mobile (full screen), 0.8 or so for tablet
                final double fraction = isMobile ? 1.0 : 0.8;

                return Column(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          // Show the correct page based on globalIndex
                          initialPage: containerIndex,
                          height: double.infinity,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                          viewportFraction: fraction,
                          scrollPhysics: const BouncingScrollPhysics(),
                          onPageChanged: (pageIndex, reason) {
                            // user swiped => set global index to 3+pageIndex
                            ref.read(selectedMenuIndexProvider.notifier).state =
                                3 + pageIndex;
                            _updateSubTitle(pageIndex);
                          },
                        ),
                        items: [
                          buildCarouselItem(MenuList(layout: layoutType)),
                          buildCarouselItem(SectionList(layout: layoutType)),
                          buildCarouselItem(ItemsList(layout: layoutType)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Page indicators
                    AnimatedSmoothIndicator(
                      // activeIndex = containerIndex
                      activeIndex: containerIndex,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: AppThemeLocal.accent,
                        dotHeight: 10.0,
                        dotWidth: 10.0,
                        expansionFactor: 6,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              }
            },
          ),
        ),
        // Footer on bigger screens
        if (screenWidth >= Menu.mobileBreakpoint) const AppFooter(),
      ],
    );
  }
}
