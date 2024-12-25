// lib/screens/menu.dart

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/login/auth_page.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/menu_management/menu_list.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/preview.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  // Navigation rail width
  static const double baseNavRailWidth = 230.0;

  // Minimum recommended width for a card
  static const double minFormWidth = 393.0;

  // Maximum recommended width for a card
  static const double maxFormWidth = 600.0;

  // Spacing between cards
  static const double cardSpacing = 16.0;

  // Mobile breakpoint
  static const double mobileBreakpoint = 600.0;

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  // Use the correct CarouselController from the package
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  int _currentIndex = 0;
  int? _selectedDesktopCardIndex; // Tracks the selected card on desktop

  @override
  Widget build(BuildContext context) {
    final venue = ref.read(draftVenueProvider);

    if (venue == null) {
      return const LoginPage();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < Menu.mobileBreakpoint;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // The available width for the main content area
              final availableWidth =
                  constraints.maxWidth - Menu.baseNavRailWidth;

              // The total space needed to fit 3 cards side-by-side
              //  - baseNavRailWidth + (3 * minFormWidth) + (4 * cardSpacing)
              //    ^ because if you have 3 cards, you have (3+1)=4 gaps if you’re using "mainAxisAlignment: spaceEvenly" or explicit margins
              const minNeededForThreeCards = Menu.baseNavRailWidth +
                  Menu.minFormWidth * 3 +
                  (4 * Menu.cardSpacing);

              // The total space needed to fit at least 2 cards side-by-side
              const minNeededForTwoCards = Menu.baseNavRailWidth +
                  Menu.minFormWidth * 2 +
                  (3 * Menu.cardSpacing);

              // Decide if it's desktop, tablet, or mobile based on constraints
              final isDesktop =
                  !isMobile && constraints.maxWidth >= minNeededForThreeCards;
              final isTablet = !isMobile &&
                  !isDesktop &&
                  constraints.maxWidth > minNeededForTwoCards;

              // -------------------------------------
              // DESKTOP LAYOUT: 3 side-by-side if enough space
              // -------------------------------------
              if (isDesktop) {
                // Calculate the maximum possible width for each card
                final maxPossibleFormWidth =
                    (availableWidth - (4 * Menu.cardSpacing)) / 3;

                // Clamp it between 393 and 600 (or any max you like)
                final formContainerWidth = maxPossibleFormWidth.clamp(
                  Menu.minFormWidth,
                  Menu.maxFormWidth,
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    final isSelected = _selectedDesktopCardIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle selection highlight
                          _selectedDesktopCardIndex =
                              (isSelected ? null : index);
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: formContainerWidth,
                        margin: const EdgeInsets.all(Menu.cardSpacing),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Color(0x4C000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  ),
                                  const BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.5),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 3.0,
                                ),
                              )
                            : AppThemeLocal.cardDecoration,
                        child: SingleChildScrollView(
                          child: (index < 2)
                              ? MenuList(layout: 'isDesktop')
                              : const MenuBrandingPreview(),
                        ),
                      ),
                    );
                  }),
                );
              }
              // -------------------------------------
              // TABLET / MOBILE LAYOUT: Carousel
              // -------------------------------------
              else {
                // We'll differentiate the layout type for inside content:
                final layoutType = isTablet ? 'isTablet' : 'isMobile';

                // If you'd like each card to have a fixed width of, say, 550 for tablet,
                // you could define that here. For demonstration, let's pick a "desired" width.
                // Then the carousel's `viewportFraction` and horizontal margins can create partial overlap.

                // Example: a fixed 550 on tablet, or 90% of constraints for mobile
                // (Adjust as needed for your design)
                double getCardWidth() {
                  if (isTablet) {
                    // Could either fix it or clamp it
                    // return 550; // a fixed width
                    // or clamp it:
                    const desired = 550.0;
                    return desired.clamp(Menu.minFormWidth, Menu.maxFormWidth);
                  } else {
                    return constraints.maxWidth * 0.9;
                  }
                }

                // You might also want partial peeking on tablet, so let's use a smaller viewportFraction
                // so that not all the card is displayed, thus partially hidden side-cards.
                final double fraction = isMobile ? 0.95 : 0.7;

                return Column(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        // Correct usage: pass the controller via 'controller:', not 'carouselController:'
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: double.infinity,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                          viewportFraction: fraction,
                          scrollPhysics: const BouncingScrollPhysics(),
                          onPageChanged: (index, reason) {
                            setState(() => _currentIndex = index);
                          },
                        ),
                        items: [
                          // Card 1
                          Container(
                            width: getCardWidth(),
                            margin: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: AppThemeLocal.cardDecoration,
                            child: SingleChildScrollView(
                              child: MenuList(layout: layoutType),
                            ),
                          ),
                          // Card 2
                          Container(
                            width: getCardWidth(),
                            margin: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: AppThemeLocal.cardDecoration,
                            child: SingleChildScrollView(
                              child: MenuList(layout: layoutType),
                            ),
                          ),
                          // Card 3
                          Container(
                            width: getCardWidth(),
                            margin: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: AppThemeLocal.cardDecoration,
                            child: const SingleChildScrollView(
                              child: MenuBrandingPreview(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Page Indicators
                    AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.blue,
                        dotHeight: 8.0,
                        dotWidth: 8.0,
                        expansionFactor: 4,
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
