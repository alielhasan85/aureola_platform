// lib/screens/menu.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/menu_management/items_list.dart';
import 'package:aureola_platform/screens/menu_management/menu_list.dart';
import 'package:aureola_platform/screens/menu_management/section_list.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// This widget shows either:
///  - **Desktop**: 3 side-by-side containers (Menu, Section, Items)
///  - **Tablet/Mobile**: A horizontal [CarouselSlider] of those 3 containers
///
/// The container displayed is determined by the global [selectedMenuIndexProvider]:
///  - index = 3 => "Menu"
///  - index = 4 => "Section"
///  - index = 5 => "Items"
///
/// We map them to container indices 0,1,2 internally.
class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  static const double baseNavRailWidth = 230.0;
  static const double minFormWidth = 450.0;
  static const double maxFormWidth = 600.0;
  static const double cardSpacing = 16.0;
  static const double mobileBreakpoint = 600.0;

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  // Controls the carousel for tablet/mobile
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // We store whether we are currently in "desktop mode" to avoid animating
  // the carousel unnecessarily. We'll set/update this in [build].
  bool _isDesktop = false;

  // Called whenever we switch to container index 0/1/2,
  // sets the appBarTitle accordingly.
  void _updateSubTitle(int containerIndex) {
    // 0 => "Menu", 1 => "Section", 2 => "Items"
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
  void initState() {
    super.initState();
    // We listen for changes to the selectedMenuIndexProvider so that
    // if the user changes it via the nav rail, we animate the carousel (on tablet/mobile).
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) {
      return const LoginPage();
    }
    ref.listen<int>(selectedMenuIndexProvider, (previous, next) {
      // Convert 3/4/5 => 0/1/2
      int pageIndex = next - 3;
      if (pageIndex < 0) pageIndex = 0;
      if (pageIndex > 2) pageIndex = 2;

      // If NOT desktop, we animate the carousel to that page
      // (which also updates the page indicator, etc.)
      if (!_isDesktop) {
        _carouselController.animateToPage(pageIndex);
        _updateSubTitle(pageIndex);
      }
    });

    // The global nav index: 3 => Menu, 4 => Section, 5 => Items
    final globalIndex = ref.watch(selectedMenuIndexProvider);

    // Convert to local container index (0 => Menu, 1 => Section, 2 => Items)
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
              // Figure out if we're in desktop/tablet mode:
              final availableWidth =
                  constraints.maxWidth - Menu.baseNavRailWidth;

              const minNeededForThreeCards = Menu.baseNavRailWidth +
                  (Menu.minFormWidth * 3) +
                  (4 * Menu.cardSpacing);

              const minNeededForTwoCards = Menu.baseNavRailWidth +
                  (Menu.minFormWidth * 2) +
                  (3 * Menu.cardSpacing);

              _isDesktop =
                  !isMobile && constraints.maxWidth >= minNeededForThreeCards;
              final isTablet = !isMobile &&
                  !_isDesktop &&
                  constraints.maxWidth > minNeededForTwoCards;

              // ================
              // DESKTOP LAYOUT
              // ================
              if (_isDesktop) {
                final maxPossibleFormWidth =
                    (availableWidth - (4 * Menu.cardSpacing)) / 3;
                final formContainerWidth = maxPossibleFormWidth.clamp(
                  Menu.minFormWidth,
                  Menu.maxFormWidth,
                );

                // Build 3 side-by-side
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    final isSelected = (index == containerIndex);

                    // 0 => MenuList, 1 => SectionList, 2 => ItemsList
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
                        // user picks container #index => set global index => 3+index
                        ref.read(selectedMenuIndexProvider.notifier).state =
                            3 + index;
                        // also set appbar sub-title
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
                                    blurRadius: 6.0,
                                    offset: Offset(0, 3),
                                  )
                                ],
                                border: Border.all(
                                  color:
                                      AppThemeLocal.lightPeach.withOpacity(0.5),
                                  width: 0.5,
                                ),
                              )
                            : AppThemeLocal.cardDecoration,
                        child: SingleChildScrollView(child: childWidget),
                      ),
                    );
                  }),
                );
              }
              // ========================
              // TABLET / MOBILE LAYOUT
              // ========================
              else {
                final layoutType = isTablet ? 'isTablet' : 'isMobile';

                // Helper to build each container item
                Widget buildCarouselItem(Widget w) {
                  if (isMobile) {
                    // full-width, no card shape
                    return Container(
                      width: constraints.maxWidth,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.white,
                      child: SingleChildScrollView(child: w),
                    );
                  } else {
                    // tablet => partial width with shape
                    const desired = 550.0;
                    final cardWidth = desired.clamp(
                      Menu.minFormWidth,
                      Menu.maxFormWidth,
                    );
                    return Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: AppThemeLocal.cardDecoration,
                      child: SingleChildScrollView(child: w),
                    );
                  }
                }

                final double fraction = isMobile ? 1.0 : 0.8;

                return Column(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          // Start on the containerIndex derived from selectedMenuIndex
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
                    AnimatedSmoothIndicator(
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
        ), // Footer on bigger screens
        if (screenWidth >= Menu.mobileBreakpoint) const AppFooter(),
      ],
    );
  }
}
