import 'package:aureola_platform/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:popover/popover.dart';

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

  void _showPopover(BuildContext context) {
    showPopover(
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      bodyBuilder: (context) => Material(
        elevation: 4,
        child: Container(
          width: 200,
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 6),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('available_restaurant'),
                    style: AppTheme.heading1.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const Divider(
                thickness: 0.5,
                color: AppTheme.divider,
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/establishment.svg',
                  width: 20,
                  height: 20,
                ),
                title: const Text('Option 1'),
                onTap: () {
                  // Perform action for Option 1
                  Navigator.pop(context); // Close popover
                },
                trailing:
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              ),

              ListTile(
                title: const Text('Option 2'),
                onTap: () {
                  // Perform action for Option 2
                  Navigator.pop(context); // Close popover
                },
              ),
              // Add more options as needed
            ],
          ),
        ),
      ),
      onPop: widget.onCloseOverlay,
      width: 200,
      height: 48 * 4,
      arrowHeight: 10,
      arrowWidth: 20,
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      direction: PopoverDirection.right,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopover(context),
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
                      widget.iconPath,
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
