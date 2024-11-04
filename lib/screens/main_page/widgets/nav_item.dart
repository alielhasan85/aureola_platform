import 'package:aureola_platform/screens/main_page/widgets/nav_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:aureola_platform/theme/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationItem extends StatefulWidget {
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
  _NavigationItemState createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Set background color based on hover and selection
    Color backgroundColor = widget.isSelected || _isHovered
        ? Color(0x7FF0F2F5).withOpacity(0.5)
        : AppTheme.white;

    // Set icon and text color based on selection
    Color iconAndTextColor =
        widget.isSelected ? AppTheme.accent : AppTheme.secondary;

    return GestureDetector(
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
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SvgPicture.asset(
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
                  style: AppTheme.navigationItemText.copyWith(
                    color: iconAndTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 14,
                ),
              ),
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
    );
  }
}
