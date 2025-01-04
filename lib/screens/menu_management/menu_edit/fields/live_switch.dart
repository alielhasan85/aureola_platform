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
        style: AppThemeLocal.paragraph,
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
          color: isLive ? Colors.green : Colors.grey,
        ),
      ),
      value: isLive,
      onChanged: onChanged,
      activeColor: AppThemeLocal.accent,
      activeTrackColor: AppThemeLocal.accent.withAlpha(60),
      inactiveThumbColor: AppThemeLocal.secondary,
      inactiveTrackColor: AppThemeLocal.grey2,
    );
  }
}
