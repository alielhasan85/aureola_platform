import 'package:flutter/material.dart';
import 'package:aureola_platform/theme/theme.dart';

class SubMenuItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback onSelect;
  final bool isSelected;

  const SubMenuItem({
    super.key,
    required this.label,
    required this.onTap,
    required this.onSelect,
    this.isSelected = false,
  });

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
    Color textColor = widget.isSelected ? AppTheme.accent : AppTheme.secondary;

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
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.label,
            style: AppTheme.navigationItemText.copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
