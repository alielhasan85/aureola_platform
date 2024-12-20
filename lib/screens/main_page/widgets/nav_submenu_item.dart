import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class SubMenuItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback onSelect;
  final bool isSelected;

  const SubMenuItem({
    super.key,
    required this.label,
    this.onTap = _defaultCallback,
    required this.onSelect,
    this.isSelected = false,
  });

// Default no-op callback function
  static void _defaultCallback() {}

  @override
  _SubMenuItemState createState() => _SubMenuItemState();
}

class _SubMenuItemState extends State<SubMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Background color changes based on hover and selected state
    Color backgroundColor = _isHovered
        ? Colors.transparent // Lighter shade on hover or select
        : Colors.transparent;

    // Text color changes based on selection
    Color textColor =
        widget.isSelected ? AppThemeLocal.accent : AppThemeLocal.secondary;

    return GestureDetector(
      onTap: () {
        widget.onSelect(); // Notify parent of selection change
        widget.onTap();
      },
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
          width: 180,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.label,
            style: AppThemeLocal.navigationItemText.copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
