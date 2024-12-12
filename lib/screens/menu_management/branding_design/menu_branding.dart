import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBranding extends ConsumerStatefulWidget {
  const MenuBranding({super.key});

  @override
  ConsumerState<MenuBranding> createState() => _MenuBrandingState();
}

class _MenuBrandingState extends ConsumerState<MenuBranding> {
  static const double baseNavRailWidth = 230.0;
  static const double minFormWidth = 600.0;
  static const double maxFormWidth = 800.0;
  static const double previewContainerWidth = 485.0;
  static const double cardSpacing = 20.0;
  static const double mobileBreakpoint = 700.0;

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < mobileBreakpoint;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth - baseNavRailWidth;
              final minNeededForTwoCards = baseNavRailWidth +
                  minFormWidth +
                  previewContainerWidth +
                  (3 * cardSpacing);

              final isDesktop =
                  !isMobile && constraints.maxWidth >= minNeededForTwoCards;
              final isTablet = !isMobile &&
                  !isDesktop &&
                  constraints.maxWidth > mobileBreakpoint;

              if (isDesktop) {
                // Desktop scenario: Two containers side by side
                final maxPossibleFormWidth =
                    availableWidth - previewContainerWidth - (3 * cardSpacing);
                final formContainerWidth =
                    maxPossibleFormWidth.clamp(minFormWidth, maxFormWidth);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: formContainerWidth,
                      margin: EdgeInsets.all(cardSpacing),
                      decoration: AppTheme.cardDecoration,
                      child: SingleChildScrollView(child: _buildFormFields()),
                    ),
                    Container(
                      width: previewContainerWidth,
                      margin: EdgeInsets.all(cardSpacing),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: SingleChildScrollView(
                          child: _buildPreviewContainer()),
                    ),
                  ],
                );
              } else if (isTablet) {
                // Tablet scenario: One container + FAB for preview
                final tabletFormWidth = (availableWidth - (2 * cardSpacing))
                    .clamp(minFormWidth, maxFormWidth);

                return Stack(
                  children: [
                    Center(
                      child: Container(
                        width: tabletFormWidth,
                        margin: EdgeInsets.all(cardSpacing),
                        decoration: AppTheme.cardDecoration,
                        child: SingleChildScrollView(child: _buildFormFields()),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () => _showPreviewDialog(context),
                        child: const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ],
                );
              } else if (isMobile) {
                // Mobile scenario: Full width + FAB for preview
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: AppTheme.cardDecorationMob,
                      child: SingleChildScrollView(child: _buildFormFields()),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () => _showPreviewDialog(context),
                        child: const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ],
                );
              } else {
                // Fallback scenario: treat as tablet
                final fallbackWidth = (constraints.maxWidth -
                        baseNavRailWidth -
                        (2 * cardSpacing))
                    .clamp(minFormWidth, maxFormWidth);
                return Center(
                  child: Container(
                    width: fallbackWidth,
                    margin: EdgeInsets.all(cardSpacing),
                    decoration: AppTheme.cardDecoration,
                    child: SingleChildScrollView(
                      child: _buildFormFields(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        if (MediaQuery.of(context).size.width >= mobileBreakpoint)
          const AppFooter(),
      ],
    );
  }

  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Brand Configuration', style: AppTheme.paragraph),
          // Additional form fields for brand config go here
        ],
      ),
    );
  }

  Widget _buildPreviewContainer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Preview', style: AppTheme.paragraph),
          // Preview content goes here
        ],
      ),
    );
  }

  void _showPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preview'),
        content: const Text('This is where the preview will be shown.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}
