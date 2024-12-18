import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/venue_management/branding_design/color_picker.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPaletteSection extends ConsumerWidget {
  final String layout; // 'isDesktop', 'isTablet', 'isMobile', or fallback

  const ColorPaletteSection({super.key, required this.layout});

  Widget _buildColorOption(
    BuildContext context,
    String label,
    StateProvider<Color?> colorProvider,
    WidgetRef ref,
  ) {
    final color = ref.watch(colorProvider) ?? AppThemeLocal.accent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        // If you want different layout on mobile vs desktop,
        // you can use layout logic here. For simplicity, we keep it simple.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppThemeLocal.paragraph),
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomColorPickerDialog(
                  colorProvider: colorProvider,
                  initialColor: color,
                );
              },
            ),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppThemeLocal.grey2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppThemeLocal.grey2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      //BoxDecoration(border: Border.all(color: AppTheme.grey2)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customize Colors', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            _buildColorOption(
              context,
              'Background Color',
              draftBackgroundColorProvider,
              ref,
            ),
            _buildColorOption(
              context,
              'Highlight Color',
              draftHighlightColorProvider,
              ref,
            ),
            _buildColorOption(
              context,
              'Text Color',
              draftTextColorProvider,
              ref,
            ),
          ],
        ),
      ),
    );
  }
}
