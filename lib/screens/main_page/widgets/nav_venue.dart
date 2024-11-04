import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:aureola_platform/theme/theme.dart';

class VenueNavigation extends StatefulWidget {
  final String label;
  final String iconPath;
  final VoidCallback onCloseOverlay;
  final bool isSelected;
  const VenueNavigation({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onCloseOverlay,
    this.isSelected = false,
  });

  @override
  _VenueNavigationState createState() => _VenueNavigationState();
}

class _VenueNavigationState extends State<VenueNavigation> {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;

  void _showDropdownMenu(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: 235,
          top: 120,
          child: Material(
            elevation: 4,
            child: Container(
              width: 200,
              height: 200,
              color: Colors.white,
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Option 1'),
                    onTap: () {
                      // Perform action for Option 1
                      _removeDropdownMenu();
                    },
                  ),
                  ListTile(
                    title: Text('Option 2'),
                    onTap: () {
                      // Perform action for Option 2
                      _removeDropdownMenu();
                    },
                  ),
                  // Add more options as needed
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  void _removeDropdownMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeDropdownMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_overlayEntry == null) {
            _showDropdownMenu(context);
          } else {
            _removeDropdownMenu();
          }
        });
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
          color: _isHovered
              ? AppTheme.accent.withOpacity(0.2)
              : AppTheme.background2.withOpacity(0.8),
          height: 71,
          width: 230,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    widget.iconPath,
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      AppTheme.red,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: AutoSizeText(
                      widget.label,
                      style: (_isHovered)
                          ? AppTheme.heading2.copyWith(
                              fontSize: 20,
                              shadows: [
                                const Shadow(
                                  offset: Offset(0, 8),
                                  blurRadius: 4,
                                  color: AppTheme.white,
                                ),
                              ],
                            )
                          : AppTheme.heading2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 14,
                      maxFontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SvgPicture.asset(
                    'icons/arrow.svg',
                    width: 16,
                    height: 16,
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
