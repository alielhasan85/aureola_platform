// lib/screens/menu_management/menu_edit/fields/live_switch.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class LiveSwitch extends StatelessWidget {
  final bool isLive;
  final ValueChanged<bool> onChanged;

  const LiveSwitch({
    super.key,
    required this.isLive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      //contentPadding: EdgeInsets.zero, // Removes default padding
      title: Text(
        AppLocalizations.of(context)!.translate('menu.live'),
        style: AppThemeLocal.paragraph.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.translate('menu.liveDescription'),
        style: AppThemeLocal.paragraph.copyWith(
          fontSize: 12,
          color: AppThemeLocal.secondary,
        ),
      ),
      secondary: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLive ? AppThemeLocal.green : Colors.grey,
        ),
      ),
      value: isLive,
      onChanged: onChanged,
      activeColor: AppThemeLocal.accent,
      activeTrackColor: AppThemeLocal.accent.withAlpha(40),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
  (Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      // When the switch is active (selected)
      return null; // Define this color in your theme
    }
    // When the switch is inactive
    return AppThemeLocal.grey; // Your desired inactive border color
  },
), 
      inactiveThumbColor: AppThemeLocal.grey,
      inactiveTrackColor: AppThemeLocal.grey2,
    );
  }
}
