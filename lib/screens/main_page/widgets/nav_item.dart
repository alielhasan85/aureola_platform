import 'package:aureola_platform/service/theme/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationItem extends ConsumerStatefulWidget {
  final String label;
  final String? leadingIconPath; // Optional left icon
  final String? trailingIconPath; // Optional right icon
  final VoidCallback onTap;
  final bool isSelected;

  const NavigationItem({
    super.key,
    required this.label,
    this.leadingIconPath,
    this.trailingIconPath,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  ConsumerState<NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends ConsumerState<NavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Set background color based on hover and selection
    Color backgroundColor = widget.isSelected || _isHovered
        ? AppThemeLocal.grey2.withOpacity(0.5)
        : AppThemeLocal.white;

    // Set icon and text color based on selection
    Color iconAndTextColor =
        widget.isSelected ? AppThemeLocal.accent : AppThemeLocal.secondary;

    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: Container(
            width: 200,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Conditionally render the leading icon if provided
                if (widget.leadingIconPath != null)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SvgPicture.asset(
                      width: 24,
                      height: 24,
                      widget.leadingIconPath!,
                      colorFilter: ColorFilter.mode(
                        iconAndTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                if (widget.leadingIconPath != null) const SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    widget.label,
                    style: AppThemeLocal.navigationItemText.copyWith(
                      color: iconAndTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 14,
                  ),
                ),
                if (widget.leadingIconPath != null) const SizedBox(width: 4),
                // Conditionally render the trailing icon if provided
                if (widget.trailingIconPath != null)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SvgPicture.asset(
                      widget.trailingIconPath!,
                      colorFilter: ColorFilter.mode(
                        iconAndTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
