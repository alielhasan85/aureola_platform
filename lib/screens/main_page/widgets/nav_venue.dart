import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:aureola_platform/theme/theme.dart';

// TODO: to manage behavior, and to change ui of overlay

class VenueNavigation extends ConsumerStatefulWidget {
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
  ConsumerState<VenueNavigation> createState() => _VenueNavigationState();
}

class _VenueNavigationState extends ConsumerState<VenueNavigation> {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;

  void _showDropdownMenu(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Get the position and size of the widget on the screen
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final leftPosition =
        isRtl ? offset.dx - 200 : offset.dx + renderBox.size.width;

    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: leftPosition,
          top: offset.dy + renderBox.size.height,
          child: Material(
            elevation: 4,
            child: Container(
              width: 200,
              height: 200,
              color: Colors.white,
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Option 1'),
                    onTap: () {
                      // Perform action for Option 1
                      _removeDropdownMenu();
                    },
                  ),
                  ListTile(
                    title: const Text('Option 2'),
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
      Overlay.of(context).insert(_overlayEntry!);
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
          color: _isHovered ? AppTheme.background2 : AppTheme.white,
          height: 71,
          width: 230,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: AutoSizeText(
                      widget.label,
                      style: (_isHovered)
                          ? AppTheme.heading2.copyWith(
                              fontSize: 24,
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
                      maxFontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Transform.rotate(
                    angle: Directionality.of(context) == TextDirection.rtl
                        ? -3.14159
                        : 0, // -180 degrees in radians
                    child: SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      width: 16,
                      height: 16,
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
